from sqlalchemy.orm import Session
from sqlalchemy import or_
from app.models import Person, AuditLog
from app.schemas import PersonCreate, PersonUpdate
from typing import Optional, List
from datetime import datetime
from app.auth import get_password_hash
from fastapi import HTTPException

def get_person(db: Session, person_id: int) -> Optional[Person]:
    return db.query(Person).filter(Person.id == person_id).first()

def get_person_by_email(db: Session, email: str) -> Optional[Person]:
    return db.query(Person).filter(Person.email_1 == email).first()

def get_persons(db: Session, skip: int = 0, limit: int = 100, include_deleted: bool = False) -> List[Person]:
    query = db.query(Person)
    if not include_deleted:
        query = query.filter(or_(Person.is_deleted == False, Person.is_deleted.is_(None)))
    return query.offset(skip).limit(limit).all()

def create_person(db: Session, person: PersonCreate) -> Person:
    person_data = person.model_dump()
    password = person_data.pop("password", None)
    if password:
        person_data["password_hash"] = get_password_hash(password)
    db_person = Person(**person_data)
    db.add(db_person)
    db.commit()
    db.refresh(db_person)
    
    log = AuditLog(
        person_id=db_person.id,
        action="CREATE",
        field_changed="all",
        old_value=None,
        new_value="Person created"
    )
    db.add(log)
    db.commit()
    
    return db_person

def update_person(db: Session, person_id: int, person_update: PersonUpdate, ip_address: Optional[str] = None) -> Optional[Person]:
    db_person = db.query(Person).filter(Person.id == person_id).first()
    if not db_person:
        return None
    
    update_data = person_update.model_dump(exclude_unset=True)
    password = update_data.pop("password", None)
    username = update_data.pop("username", None)
    
    if username is not None:
        existing = db.query(Person).filter(Person.username == username, Person.id != person_id).first()
        if existing:
            raise HTTPException(status_code=400, detail="Username already exists")
        old_value = db_person.username
        if old_value != username:
            log = AuditLog(
                person_id=person_id,
                action="UPDATE",
                field_changed="username",
                old_value=str(old_value) if old_value else None,
                new_value=username,
                ip_address=ip_address
            )
            db.add(log)
            db_person.username = username
    
    for field, value in update_data.items():
        if value is not None:
            old_value = getattr(db_person, field)
            if str(old_value) != str(value):
                log = AuditLog(
                    person_id=person_id,
                    action="UPDATE",
                    field_changed=field,
                    old_value=str(old_value) if old_value else None,
                    new_value=str(value),
                    ip_address=ip_address
                )
                db.add(log)
                setattr(db_person, field, value)
    
    if password is not None:
        db_person.password_hash = get_password_hash(password)
        log = AuditLog(
            person_id=person_id,
            action="UPDATE",
            field_changed="password_hash",
            old_value=None,
            new_value="Password changed",
            ip_address=ip_address
        )
        db.add(log)
    
    db.commit()
    db.refresh(db_person)
    return db_person

def delete_person(db: Session, person_id: int, ip_address: Optional[str] = None) -> bool:
    db_person = db.query(Person).filter(Person.id == person_id).first()
    if not db_person:
        return False
    
    db_person.is_deleted = True
    db_person.email_1 = None
    db_person.email_2 = None
    db_person.telefon_1 = None
    db_person.telefon_2 = None
    db_person.mobil = None
    db_person.adresse = None
    db_person.ort = None
    db_person.plz = None
    db_person.land = None
    db_person.consent_storage = False
    
    log = AuditLog(
        person_id=person_id,
        action="DELETE",
        field_changed="all",
        old_value=None,
        new_value="Person deleted (right to be forgotten)",
        ip_address=ip_address
    )
    db.add(log)
    db.commit()
    return True

def block_person(db: Session, person_id: int, ip_address: Optional[str] = None) -> bool:
    db_person = db.query(Person).filter(Person.id == person_id).first()
    if not db_person:
        return False
    
    db_person.is_blocked = True
    db_person.email_1 = None
    db_person.telefon_1 = None
    db_person.telefon_2 = None
    db_person.mobil = None
    db_person.adresse = None
    db_person.ort = None
    db_person.plz = None
    db_person.land = None
    
    log = AuditLog(
        person_id=person_id,
        action="BLOCK",
        field_changed="all",
        old_value=None,
        new_value="Person blocked (right to be forgotten)",
        ip_address=ip_address
    )
    db.add(log)
    db.commit()
    return True

def get_audit_logs(db: Session, person_id: Optional[int] = None, skip: int = 0, limit: int = 100) -> List[AuditLog]:
    query = db.query(AuditLog)
    if person_id:
        query = query.filter(AuditLog.person_id == person_id)
    return query.order_by(AuditLog.timestamp.desc()).offset(skip).limit(limit).all()

def import_persons(db: Session, persons_data: List[dict], ip_address: Optional[str] = None) -> int:
    imported = 0
    seen_usernames = {}
    for person_data in persons_data:
        existing = db.query(Person).filter(
            (Person.id == person_data.get("id")) |
            (Person.email_1 == person_data.get("email_1"))
        ).first()
        
        username = person_data.get("username")
        if username:
            if username in seen_usernames:
                seen_usernames[username] += 1
                person_data["username"] = f"{username}{seen_usernames[username]}"
            else:
                username_conflict = db.query(Person).filter(Person.username == username).first()
                if username_conflict and (not existing or username_conflict.id != existing.id):
                    seen_usernames[username] = 1
                    person_data["username"] = f"{username}1"
                else:
                    seen_usernames[username] = 0
        
        if existing:
            for key, value in person_data.items():
                if value is not None and hasattr(existing, key):
                    setattr(existing, key, value)
            log = AuditLog(
                person_id=existing.id,
                action="IMPORT_UPDATE",
                field_changed="all",
                old_value=None,
                new_value="Updated via import",
                ip_address=ip_address
            )
            db.add(log)
        else:
            db_person = Person(**person_data)
            db.add(db_person)
            log = AuditLog(
                action="IMPORT_CREATE",
                field_changed="all",
                old_value=None,
                new_value="Created via import",
                ip_address=ip_address
            )
            db.add(log)
            imported += 1
    
    db.commit()
    return imported
