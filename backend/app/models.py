from sqlalchemy import Column, Integer, String, Text, Boolean, Enum, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base
import enum

class Reachability(str, enum.Enum):
    unknown = "-unbekannt-"
    email = "E-Mail"
    whatsapp = "WhatsApp"
    landline = "Festnetz"
    deceased = "verstorben"

class Group(Base):
    __tablename__ = "groups"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class Person(Base):
    __tablename__ = "persons"

    id = Column(Integer, primary_key=True, index=True)
    gruppe_id = Column(Integer, ForeignKey("groups.id"), nullable=False)
    vorname = Column(String, nullable=False)
    nachname = Column(String, nullable=False)
    geburtsname = Column(String, nullable=True)
    adresse = Column(String, nullable=True)
    land = Column(String, nullable=True)
    ort = Column(String, nullable=True)
    plz = Column(String, nullable=True)
    telefon_1 = Column(String, nullable=True)
    telefon_2 = Column(String, nullable=True)
    mobil = Column(String, nullable=True)
    erreichbarkeit = Column(Enum(Reachability), nullable=False, default=Reachability.unknown)
    email_1 = Column(String, nullable=True)
    email_2 = Column(String, nullable=True)
    admin = Column(Boolean, default=False)
    username = Column(String, unique=True, nullable=True)
    password_hash = Column(String, nullable=True)
    notizen = Column(Text, nullable=True)
    consent_storage = Column(Boolean, default=False)
    consent_sharing = Column(Boolean, default=False)
    consent_photos = Column(Boolean, default=False)
    is_deleted = Column(Boolean, default=False)
    is_blocked = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    gruppe = relationship("Group", backref="persons")

class AuditLog(Base):
    __tablename__ = "audit_logs"

    id = Column(Integer, primary_key=True, index=True)
    person_id = Column(Integer, ForeignKey("persons.id"), nullable=True)
    action = Column(String, nullable=False)
    field_changed = Column(String, nullable=True)
    old_value = Column(Text, nullable=True)
    new_value = Column(Text, nullable=True)
    ip_address = Column(String, nullable=True)
    timestamp = Column(DateTime(timezone=True), server_default=func.now())

class MagicToken(Base):
    __tablename__ = "magic_tokens"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, index=True, nullable=False)
    token = Column(String, unique=True, index=True, nullable=False)
    expires_at = Column(DateTime(timezone=True), nullable=False)
    used = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class PrivacyPolicy(Base):
    __tablename__ = "privacy_policy"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False, default="Datenschutzerklärung für die Abiturientenliste")
    zweck = Column(Text, nullable=False)
    verantwortlicher = Column(Text, nullable=True)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
