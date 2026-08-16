from pydantic import BaseModel, EmailStr, model_validator
from datetime import datetime
from typing import Optional, Any
from app.models import Reachability, Group

class GroupBase(BaseModel):
    name: str

class GroupCreate(GroupBase):
    pass

class GroupUpdate(BaseModel):
    name: str

class GroupResponse(GroupBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True

class PersonBase(BaseModel):
    gruppe_id: int
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
    gruppe_id: Optional[int] = None
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
    gruppe: Any = None
    is_deleted: Optional[bool] = False
    is_blocked: Optional[bool] = False
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True
    
    @model_validator(mode='after')
    def set_gruppe_name(self):
        if isinstance(self.gruppe, Group):
            self.gruppe = self.gruppe.name
        elif self.gruppe is None:
            self.gruppe = ""
        return self

class PersonPublicResponse(BaseModel):
    id: int
    gruppe: Any = None
    vorname: str
    nachname: str
    adresse: Optional[str] = None
    land: Optional[str] = None
    ort: Optional[str] = None
    plz: Optional[str] = None
    telefon_1: Optional[str] = None
    telefon_2: Optional[str] = None
    mobil: Optional[str] = None
    erreichbarkeit: Reachability
    email_1: Optional[str] = None
    email_2: Optional[str] = None
    admin: bool
    consent_sharing: bool

    class Config:
        from_attributes = True
    
    @model_validator(mode='after')
    def set_gruppe_name(self):
        if isinstance(self.gruppe, Group):
            self.gruppe = self.gruppe.name
        elif self.gruppe is None:
            self.gruppe = ""
        return self

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
    person_id: int
    admin: bool

class MagicLinkRequest(BaseModel):
    email: EmailStr

class MagicLinkVerify(BaseModel):
    token: str