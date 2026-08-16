from fastapi import APIRouter, Depends, HTTPException, status, Request
from pydantic import BaseModel
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import Person, AuditLog
from app.schemas import PersonCreate, PersonUpdate, PersonResponse, PersonPublicResponse, AuditLogResponse, TokenResponse, MagicLinkRequest, MagicLinkVerify
from app.auth import create_access_token, create_magic_token, verify_magic_token, verify_password, get_password_hash
from app.config import settings
from datetime import timedelta
from typing import List

router = APIRouter(prefix="/api/auth", tags=["auth"])

class LoginRequest(BaseModel):
    username: str
    password: str

@router.post("/magic-link", response_model=dict)
def request_magic_link(request: MagicLinkRequest, db: Session = Depends(get_db)):
    token = create_magic_token(request.email)
    magic_link = f"http://localhost:8085/auth/verify?token={token}"
    return {"message": "Magic link generated", "magic_link": magic_link}

@router.post("/verify", response_model=TokenResponse)
def verify_magic_link(request: MagicLinkVerify, db: Session = Depends(get_db)):
    email = verify_magic_token(request.token)
    if not email:
        raise HTTPException(status_code=400, detail="Invalid or expired token")
    
    person = db.query(Person).filter(Person.email_1 == email).first()
    if not person:
        raise HTTPException(status_code=404, detail="Person not found")
    
    access_token = create_access_token(
        data={"sub": email, "person_id": person.id, "admin": person.admin},
        expires_delta=timedelta(hours=settings.TOKEN_EXPIRY_HOURS)
    )
    return {"access_token": access_token, "token_type": "bearer"}

@router.post("/login", response_model=TokenResponse)
def login(request: LoginRequest, db: Session = Depends(get_db)):
    person = db.query(Person).filter(
        (Person.email_1 == request.username) | (Person.username == request.username)
    ).first()
    if not person or not person.password_hash or not verify_password(request.password, person.password_hash):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    access_token = create_access_token(
        data={"sub": person.email_1, "person_id": person.id, "admin": person.admin},
        expires_delta=timedelta(hours=settings.TOKEN_EXPIRY_HOURS)
    )
    return {"access_token": access_token, "token_type": "bearer"}
