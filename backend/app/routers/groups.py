from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import Group, Person
from app.schemas import GroupCreate, GroupUpdate, GroupResponse
from app.auth import verify_token
from typing import List

router = APIRouter(prefix="/api/groups", tags=["groups"])

def get_client_ip(request: Request) -> str:
    forwarded = request.headers.get("X-Forwarded-For")
    if forwarded:
        return forwarded.split(",")[0]
    return request.client.host if request.client else "unknown"

@router.get("/", response_model=List[GroupResponse])
def get_groups(request: Request, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    return db.query(Group).order_by(Group.name).all()

@router.post("/", response_model=GroupResponse)
def create_group(request: Request, group: GroupCreate, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    existing = db.query(Group).filter(Group.name == group.name).first()
    if existing:
        raise HTTPException(status_code=400, detail="Group already exists")
    
    db_group = Group(name=group.name)
    db.add(db_group)
    db.commit()
    db.refresh(db_group)
    
    return db_group

@router.put("/{group_id}", response_model=GroupResponse)
def update_group(request: Request, group_id: int, group_update: GroupUpdate, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    db_group = db.query(Group).filter(Group.id == group_id).first()
    if not db_group:
        raise HTTPException(status_code=404, detail="Group not found")
    
    existing = db.query(Group).filter(Group.name == group_update.name, Group.id != group_id).first()
    if existing:
        raise HTTPException(status_code=400, detail="Group name already exists")
    
    db_group.name = group_update.name
    db.commit()
    db.refresh(db_group)
    
    return db_group

@router.delete("/{group_id}")
def delete_group(request: Request, group_id: int, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    db_group = db.query(Group).filter(Group.id == group_id).first()
    if not db_group:
        raise HTTPException(status_code=404, detail="Group not found")
    
    persons_count = db.query(Person).filter(Person.gruppe_id == group_id).count()
    if persons_count > 0:
        raise HTTPException(status_code=400, detail=f"Cannot delete group: {persons_count} persons are using it")
    
    db.delete(db_group)
    db.commit()
    
    return {"message": "Group deleted successfully"}