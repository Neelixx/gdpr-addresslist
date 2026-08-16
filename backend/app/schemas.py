from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional
from app.models import PersonGroup, Reachability

class PersonBase(BaseModel):
    gruppe: PersonGroup
    vorname: str
    nachname: str
    geburtsname: Optional[str] = None
    adresse: Optional[str] = None
    land: Optional[str] = None
    ort: Optional[str] = None
    plz: Optional[str] = None
    telefon_1: Optional[str] = None
    telefon_2: Optional[str] = None
    mobil: Optional[str] = None
    erreichbarkeit: Reachability = Reachability.unknown
    email_1: Optional[str] = None
    email_2: Optional[str] = None
    username: Optional[str] = None
    admin: bool = False
    notizen: Optional[str] = None
    consent_storage: bool = False
    consent_sharing: bool = False
    consent_photos: bool = False

class PersonCreate(PersonBase):
    password: Optional[str] = None

class PersonUpdate(BaseModel):
    gruppe: Optional[PersonGroup] = None
    vorname: Optional[str] = None
    nachname: Optional[str] = None
    geburtsname: Optional[str] = None
    adresse: Optional[str] = None
    land: Optional[str] = None
    ort: Optional[str] = None
    plz: Optional[str] = None
    telefon_1: Optional[str] = None
    telefon_2: Optional[str] = None
    mobil: Optional[str] = None
    erreichbarkeit: Optional[Reachability] = None
    email_1: Optional[str] = None
    email_2: Optional[str] = None
    admin: Optional[bool] = None
    notizen: Optional[str] = None
    consent_storage: Optional[bool] = None
    consent_sharing: Optional[bool] = None
    consent_photos: Optional[bool] = None
    password: Optional[str] = None
    username: Optional[str] = None

class PersonResponse(PersonBase):
    id: int
    is_deleted: Optional[bool] = False
    is_blocked: Optional[bool] = False
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True

class PersonPublicResponse(BaseModel):
    id: int
    gruppe: PersonGroup
    vorname: str
    nachname: str
    adresse: Optional[str] = None
    land: Optional[str] = None
    ort: Optional[str] = None
    plz: Optional[str] = None
    erreichbarkeit: Reachability
    admin: bool
    consent_sharing: bool

    class Config:
        from_attributes = True

class AuditLogResponse(BaseModel):
    id: int
    person_id: Optional[int]
    action: str
    field_changed: Optional[str]
    old_value: Optional[str]
    new_value: Optional[str]
    ip_address: Optional[str]
    timestamp: datetime

    class Config:
        from_attributes = True

class TokenResponse(BaseModel):
    access_token: str
    token_type: str

class MagicLinkRequest(BaseModel):
    email: EmailStr

class MagicLinkVerify(BaseModel):
    token: str
