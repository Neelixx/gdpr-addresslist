from fastapi import APIRouter, Depends, HTTPException, status, Request, Body
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import Person, AuditLog
from app.schemas import PersonCreate, PersonUpdate, PersonResponse, PersonPublicResponse, AuditLogResponse
from app.crud import get_person, get_persons, create_person, update_person, delete_person, block_person, get_audit_logs
from app.auth import verify_password, get_password_hash, create_access_token
from datetime import timedelta
from app.config import settings
from typing import List, Optional

router = APIRouter(prefix="/api/persons", tags=["persons"])

def get_client_ip(request: Request) -> str:
    forwarded = request.headers.get("X-Forwarded-For")
    if forwarded:
        return forwarded.split(",")[0]
    return request.client.host if request.client else "unknown"

@router.get("/", response_model=List[PersonPublicResponse])
def list_persons(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    persons = get_persons(db, skip=skip, limit=limit, include_deleted=False)
    return [p for p in persons if p.consent_sharing and not p.is_deleted and p.erreichbarkeit.value != "verstorben"]

@router.get("/me", response_model=PersonResponse)
def get_my_data(request: Request, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    from app.auth import verify_token
    payload = verify_token(token)
    if not payload:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    person_id = payload.get("person_id")
    person = get_person(db, person_id)
    if not person:
        raise HTTPException(status_code=404, detail="Person not found")
    
    return person

@router.put("/me", response_model=PersonResponse)
def update_my_data(request: Request, person_update: PersonUpdate, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    from app.auth import verify_token
    payload = verify_token(token)
    if not payload:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    person_id = payload.get("person_id")
    ip_address = get_client_ip(request)
    person = update_person(db, person_id, person_update, ip_address)
    if not person:
        raise HTTPException(status_code=404, detail="Person not found")
    
    return person

@router.post("/me/password")
def change_password(request: Request, password: str = Body(..., embed=True), db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    from app.auth import verify_token
    payload = verify_token(token)
    if not payload:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    person_id = payload.get("person_id")
    ip_address = get_client_ip(request)
    person = update_person(db, person_id, PersonUpdate(password=password), ip_address)
    if not person:
        raise HTTPException(status_code=404, detail="Person not found")
    
    return {"message": "Password changed successfully"}

@router.delete("/me", status_code=status.HTTP_204_NO_CONTENT)
def delete_my_data(request: Request, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    from app.auth import verify_token
    payload = verify_token(token)
    if not payload:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    person_id = payload.get("person_id")
    ip_address = get_client_ip(request)
    success = delete_person(db, person_id, ip_address)
    if not success:
        raise HTTPException(status_code=404, detail="Person not found")
    
    return None

@router.get("/export", response_model=List[PersonResponse])
def export_all(request: Request, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    from app.auth import verify_token
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    persons = get_persons(db, include_deleted=False)
    
    log = AuditLog(
        action="EXPORT",
        field_changed="all",
        old_value=None,
        new_value="Admin export performed",
        ip_address=get_client_ip(request)
    )
    db.add(log)
    db.commit()
    
    return persons

@router.get("/audit", response_model=List[AuditLogResponse])
def get_audit_logs_endpoint(request: Request, person_id: Optional[int] = None, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    from app.auth import verify_token
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    return get_audit_logs(db, person_id=person_id)
