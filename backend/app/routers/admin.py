from fastapi import APIRouter, Depends, HTTPException, Request, File, UploadFile, Form
from fastapi.responses import JSONResponse, FileResponse
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import Person, AuditLog, MagicToken, PrivacyPolicy
from app.schemas import PersonCreate, PersonUpdate, PersonResponse
from app.crud import create_person, update_person, get_persons, get_audit_logs, import_persons, delete_person
from app.auth import verify_token, create_magic_token
from app.config import settings
from typing import List
import csv
import io
import os
import subprocess
import secrets
from datetime import datetime

router = APIRouter(prefix="/api/admin", tags=["admin"])

def get_client_ip(request: Request) -> str:
    forwarded = request.headers.get("X-Forwarded-For")
    if forwarded:
        return forwarded.split(",")[0]
    return request.client.host if request.client else "unknown"

@router.post("/persons")
def create_person_admin(request: Request, person: PersonCreate, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    db_person = create_person(db, person)
    return db_person

@router.put("/persons/{person_id}")
def update_person_admin(request: Request, person_id: int, person_update: PersonUpdate, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    person = update_person(db, person_id, person_update, get_client_ip(request))
    if not person:
        raise HTTPException(status_code=404, detail="Person not found")
    return person

@router.delete("/persons/{person_id}")
def delete_person_admin(request: Request, person_id: int, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    success = delete_person(db, person_id, get_client_ip(request))
    if not success:
        raise HTTPException(status_code=404, detail="Person not found")
    
    return {"message": "Person deleted successfully"}

@router.get("/persons", response_model=List[PersonResponse])
def list_all_persons(request: Request, include_deleted: bool = False, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    return get_persons(db, include_deleted=include_deleted)

@router.post("/import")
async def import_csv(request: Request, file: UploadFile = File(...), db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    if not file.filename.endswith('.csv'):
        raise HTTPException(status_code=400, detail="Only CSV files are allowed")
    
    try:
        contents = await file.read()
        decoded = contents.decode('utf-8')
        reader = csv.DictReader(io.StringIO(decoded))
        
        persons_data = []
        for row in reader:
            person_data = {
                'id': int(row['ID']) if row.get('ID') else None,
                'gruppe': row.get('Gruppe', '').strip(),
                'vorname': row.get('Vorname', '').strip(),
                'nachname': row.get('Nachname', '').strip(),
                'geburtsname': row.get('Geburtsname', '').strip() or None,
                'adresse': row.get('Adresse', '').strip() or None,
                'land': row.get('Land', '').strip() or None,
                'ort': row.get('Ort', '').strip() or None,
                'plz': row.get('PLZ', '').strip() or None,
                'telefon_1': row.get('Telefon_1', '').strip() or None,
                'telefon_2': row.get('Telefon_2', '').strip() or None,
                'mobil': row.get('Mobil', '').strip() or None,
                'erreichbarkeit': row.get('Erreichbarkeit', '').strip(),
                'email_1': row.get('Email_1', '').strip() or None,
                'email_2': row.get('Email_2', '').strip() or None,
                'username': row.get('loginname', '').strip() or None,
                'admin': row.get('Admin', '').strip().lower() in ('1', 'true', 'yes'),
                'notizen': row.get('Notizen', '').strip() or None,
            }
            
            consent_storage = row.get('Zusage_1', '').strip()
            consent_sharing = row.get('Zusage_2', '').strip()
            person_data['consent_storage'] = consent_storage.lower() in ('1', 'true', 'yes')
            person_data['consent_sharing'] = consent_sharing.lower() in ('1', 'true', 'yes')
            person_data['consent_photos'] = False
            
            persons_data.append(person_data)
        
        imported = import_persons(db, persons_data, get_client_ip(request))
        
        log = AuditLog(
            action="IMPORT",
            field_changed="all",
            old_value=None,
            new_value=f"Imported {imported} persons from CSV",
            ip_address=get_client_ip(request)
        )
        db.add(log)
        db.commit()
        
        return {"imported": imported, "message": f"Successfully imported {imported} persons"}
        
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error processing CSV: {str(e)}")

@router.get("/backup")
def backup_database(request: Request, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = f"/app/backups/backup_{timestamp}.sql"
    
    env = os.environ.copy()
    env['PGPASSWORD'] = settings.POSTGRES_PASSWORD
    
    cmd = [
        'pg_dump',
        '-h', 'db',
        '-U', settings.POSTGRES_USER,
        '-d', settings.POSTGRES_DB,
        '-f', backup_path
    ]
    
    try:
        subprocess.run(cmd, check=True, env=env)
        
        log = AuditLog(
            action="BACKUP",
            field_changed="all",
            old_value=None,
            new_value=f"Database backup created: {backup_path}",
            ip_address=get_client_ip(request)
        )
        db.add(log)
        db.commit()
        
        return FileResponse(
            path=backup_path,
            filename=f"backup_{timestamp}.sql",
            media_type="application/octet-stream"
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Backup failed: {str(e)}")

@router.post("/restore")
async def restore_database(request: Request, file: UploadFile = File(...), db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    if not file.filename.endswith('.sql'):
        raise HTTPException(status_code=400, detail="Only .sql files are allowed")
    
    try:
        contents = await file.read()
        sql_content = contents.decode('utf-8')
        
        env = os.environ.copy()
        env['PGPASSWORD'] = settings.POSTGRES_PASSWORD
        
        cmd = [
            'psql',
            '-h', 'db',
            '-U', settings.POSTGRES_USER,
            '-d', settings.POSTGRES_DB,
            '-c', sql_content
        ]
        
        subprocess.run(cmd, check=True, env=env)
        
        log = AuditLog(
            action="RESTORE",
            field_changed="all",
            old_value=None,
            new_value=f"Database restored from {file.filename}",
            ip_address=get_client_ip(request)
        )
        db.add(log)
        db.commit()
        
        return {"message": "Database restored successfully"}
        
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Restore failed: {str(e)}")

@router.get("/export/all")
def export_all_data(request: Request, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    persons = get_persons(db, include_deleted=True)
    
    output = io.StringIO()
    writer = csv.writer(output)
    
    writer.writerow([
        'ID', 'Gruppe', 'Vorname', 'Nachname', 'Geburtsname', 'Adresse', 'Land', 'Ort', 'PLZ',
        'Telefon_1', 'Telefon_2', 'Mobil', 'Erreichbarkeit', 'Email_1', 'Email_2',
        'Benutzername', 'Admin', 'Zusage_Speicherung', 'Zusage_Teilen', 'Zusage_Fotos',
        'Gelöscht', 'Gesperrt', 'Erstellt', 'Aktualisiert', 'Magic_Link'
    ])
    
    for person in persons:
        magic_link = ""
        if person.email_1:
            token = create_magic_token(person.email_1)
            magic_link = f"http://localhost:8085/auth/verify?token={token}"
        
        writer.writerow([
            person.id,
            person.gruppe.value,
            person.vorname,
            person.nachname,
            person.geburtsname or '',
            person.adresse or '',
            person.land or '',
            person.ort or '',
            person.plz or '',
            person.telefon_1 or '',
            person.telefon_2 or '',
            person.mobil or '',
            person.erreichbarkeit.value,
            person.email_1 or '',
            person.email_2 or '',
            person.username or '',
            person.admin,
            person.consent_storage,
            person.consent_sharing,
            person.consent_photos,
            person.is_deleted,
            person.is_blocked,
            person.created_at.isoformat() if person.created_at else '',
            person.updated_at.isoformat() if person.updated_at else '',
            magic_link
        ])
    
    log = AuditLog(
        action="EXPORT_ALL",
        field_changed="all",
        old_value=None,
        new_value=f"Exported all data with magic links ({len(persons)} persons)",
        ip_address=get_client_ip(request)
    )
    db.add(log)
    db.commit()
    
    output.seek(0)
    return JSONResponse(content={"csv": output.getvalue()})

@router.post("/magic-links")
def generate_magic_links(request: Request, person_ids: List[int] = Form(...), db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    results = []
    for person_id in person_ids:
        person = db.query(Person).filter(Person.id == person_id).first()
        if person and person.email_1:
            magic_token = create_magic_token(person.email_1)
            magic_link = f"http://localhost:8085/auth/verify?token={magic_token}"
            results.append({
                "id": person.id,
                "name": f"{person.vorname} {person.nachname}",
                "email": person.email_1,
                "magic_link": magic_link
            })
    
    log = AuditLog(
        action="GENERATE_MAGIC_LINKS",
        field_changed="all",
        old_value=None,
        new_value=f"Generated magic links for {len(results)} persons",
        ip_address=get_client_ip(request)
    )
    db.add(log)
    db.commit()
    
    return {"links": results}

@router.get("/privacy-policy")
def get_privacy_policy(request: Request, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    admin = db.query(Person).filter(Person.id == 1).first()
    policy = db.query(PrivacyPolicy).first()
    
    if not policy:
        policy = PrivacyPolicy(zweck="Die Verarbeitung Ihrer Daten erfolgt ausschließlich zum Zweck der Organisation und Durchführung von Alumni-Events (z. B. Jubiläen).")
        db.add(policy)
        db.commit()
        db.refresh(policy)
    
    verantwortlicher = policy.verantwortlicher if policy.verantwortlicher else (f"{admin.vorname} {admin.nachname}" if admin else "[Name des Administrators / Verantwortlichen]")
    kontakt = admin.email_1 if admin and admin.email_1 else "[Kontaktmöglichkeit]"
    
    # If custom verantwortlicher is set, use it as-is; otherwise append contact
    if policy.verantwortlicher:
        verantwortlicher_line = f"Verantwortlicher: {verantwortlicher}."
    else:
        verantwortlicher_line = f"Verantwortlicher: {verantwortlicher}, {kontakt}."
    
    content = f"""{verantwortlicher_line}

Zweck der Verarbeitung
{policy.zweck}

Rechtsgrundlage
Die Verarbeitung erfolgt auf Basis Ihrer ausdrücklichen Einwilligung gemäß Art. 6 Abs. 1 lit. a DSGVO.

Datenkategorien
Name, Anschrift, E-Mail, Telefonnummer sowie ggf. Fotos und Gruppenangaben.

Weitergabe an Dritte
Ihre Daten werden nur dann für andere Mitglieder der Liste sichtbar, wenn Sie explizit der Funktion "Teilen der Daten" zugestimmt haben. Eine Weitergabe an externe Firmen erfolgt nicht.

Ihre Rechte
Sie haben das Recht auf Auskunft, Berichtigung, Löschung ("Recht auf Vergessenwerden") sowie den Widerruf Ihrer Einwilligung jederzeit mit Wirkung für die Zukunft.

Speicherdauer
Die Daten werden so lange gespeichert, wie Sie Ihre Zustimmung nicht widerrufen oder die Liste aufgelöst wird."""
    
    return {
        "title": policy.title,
        "content": content
    }

@router.put("/privacy-policy")
def update_privacy_policy(request: Request, policy_update: dict, db: Session = Depends(get_db)):
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Not authenticated")
    
    token = auth_header.split(" ")[1]
    payload = verify_token(token)
    if not payload or not payload.get("admin"):
        raise HTTPException(status_code=403, detail="Admin access required")
    
    policy = db.query(PrivacyPolicy).first()
    if not policy:
        policy = PrivacyPolicy()
        db.add(policy)
    
    policy.zweck = policy_update.get("zweck", policy.zweck)
    policy.title = policy_update.get("title", policy.title)
    policy.verantwortlicher = policy_update.get("verantwortlicher", policy.verantwortlicher)
    db.commit()
    db.refresh(policy)
    
    return {"message": "Datenschutzerklärung aktualisiert"}
