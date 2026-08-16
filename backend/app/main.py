from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import Base, engine
from app.routers import auth, persons, admin
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

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.get("/privacy-policy")
def privacy_policy():
    return {
        "title": "Datenschutzerklärung für die Abiturientenliste",
        "content": """
Verantwortlicher: [Name des Administrators / Verantwortlichen], [Kontaktmöglichkeit].

Zweck der Verarbeitung: Die Verarbeitung Ihrer Daten erfolgt ausschließlich zum Zweck der Organisation und Durchführung von Alumni-Events (z. B. Jubiläen).

Rechtsgrundlage: Die Verarbeitung erfolgt auf Basis Ihrer ausdrücklichen Einwilligung gemäß Art. 6 Abs. 1 lit. a DSGVO.

Datenkategorien: Name, Anschrift, E-Mail, Telefonnummer sowie ggf. Fotos und Gruppenangaben.

Weitergabe an Dritte: Ihre Daten werden nur dann für andere Mitglieder der Liste sichtbar, wenn Sie explizit der Funktion "Teilen der Daten" zugestimmt haben. Eine Weitergabe an externe Firmen erfolgt nicht.

Ihre Rechte: Sie haben das Recht auf Auskunft, Berichtigung, Löschung ("Recht auf Vergessenwerden") sowie den Widerruf Ihrer Einwilligung jederzeit mit Wirkung für die Zukunft.

Speicherdauer: Die Daten werden so lange gespeichert, wie Sie Ihre Zustimmung nicht widerrufen oder die Liste aufgelöst wird.
        """
    }
