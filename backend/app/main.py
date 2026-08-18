from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import Base, engine, SessionLocal
from app.routers import auth, persons, admin, groups
from app.models import Person, PrivacyPolicy
from app.init_admin import create_admin_user
import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[
        logging.FileHandler("/app/logs/app.log"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

Base.metadata.create_all(bind=engine)
create_admin_user()

app = FastAPI(title="GDPR Address List", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(persons.router)
app.include_router(admin.router)
app.include_router(groups.router)

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.get("/privacy-policy")
@app.get("/api/privacy-policy")
def privacy_policy():
    db = SessionLocal()
    try:
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
        
        title = policy.title if policy else "Datenschutzerklärung für die Abiturientenliste"
        
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
            "title": title,
            "content": content
        }
    finally:
        db.close()
