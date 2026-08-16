from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt
import bcrypt
from app.config import settings
from app.models import MagicToken
from app.database import SessionLocal

ALGORITHM = "HS256"

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def verify_token(token: str):
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except JWTError:
        return None

def create_magic_token(email: str) -> str:
    import secrets
    token = secrets.token_urlsafe(32)
    db = SessionLocal()
    try:
        expires_at = datetime.utcnow() + timedelta(hours=settings.TOKEN_EXPIRY_HOURS)
        db_token = MagicToken(email=email, token=token, expires_at=expires_at)
        db.add(db_token)
        db.commit()
    finally:
        db.close()
    return token

def verify_magic_token(token: str) -> Optional[str]:
    db = SessionLocal()
    try:
        db_token = db.query(MagicToken).filter(
            MagicToken.token == token,
            MagicToken.used == False,
            MagicToken.expires_at > datetime.utcnow()
        ).first()
        if db_token:
            db_token.used = True
            db.commit()
            return db_token.email
    finally:
        db.close()
    return None

def get_password_hash(password: str) -> str:
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return bcrypt.checkpw(plain_password.encode(), hashed_password.encode())
