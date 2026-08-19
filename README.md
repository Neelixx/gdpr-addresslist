# gdpr-addresslist

DSGVO-konforme Alumni-Adressverwaltung zur Organisation von Schuljahrgangs-Events.

## Projektbeschreibung

Dieses Repository enthält eine containerisierte Anwendung zur Verwaltung von Adresslisten für Schuljahrgänge (z. B. Abiturienten), die vollständig konform mit der **Datenschutz-Grundverordnung (DSGVO)** entwickelt wurde.

Das Hauptziel ist es, eine sichere und privatsphäre-schützende Möglichkeit zu bieten, Kontaktdaten für Alumni-Events (wie z. B. das 50-jährige Jubiläum) zu pflegen.

## Technologie-Stack

- **Backend:** FastAPI (Python 3.11)
- **Frontend:** Vue 3 + TypeScript + Vite
- **Datenbank:** PostgreSQL 15
- **Container:** Docker + Docker Compose
- **Reverse Proxy:** Apache mit Let's Encrypt SSL (Produktion)

## Schnellstart

### Voraussetzungen

- Docker und Docker Compose installiert

### Installation

1. Klone das Repository:
   ```bash
   git clone <repository-url>
   cd gdpr-addresslist
   ```

2. Konfiguriere die Umgebungsvariablen:
   ```bash
   cp .env.example .env
   # Passe die Werte in .env an (insbesondere SECRET_KEY!)
   ```

3. Starte die Anwendung:
   ```bash
   docker compose up --build
   ```

4. Öffne die Anwendung:
   - Frontend: http://localhost:8085
   - Backend API: http://localhost:8001

## Projektstruktur

```
.
├── backend/
│   ├── Dockerfile
│   ├── requirements.txt
│   └── app/
│       ├── main.py
│       ├── config.py
│       ├── database.py
│       ├── models.py
│       ├── schemas.py
│       ├── auth.py
|       ├── crud.py
│       └── routers/
│           ├── auth.py
│           ├── persons.py
│           └── admin.py
├── frontend/
│   ├── Dockerfile
│   ├── nginx.conf
│   ├── package.json
│   ├── vite.config.ts
│   ├── tsconfig.json
│   └── src/
│       ├── main.ts
│       ├── App.vue
│       ├── router/
│       ├── stores/
│       ├── api/
│       ├── components/
│       └── views/
├── docker-compose.yml
├── .env.example
├── specification_de.md
└── README.md
```

## Kernfunktionen

- **DSGVO-konformes Management:** Explizite Verwaltung von Einwilligungen (Speicherung, Teilen von Daten, Fotos).
- **Self-Service für Nutzer:** Registrierung via Magic-Links, Passwortverwaltung und eigenständige Datenänderung.
- **Recht auf Vergessenwerden:** Automatisierte Prozesse zur Löschung oder Maskierung von Daten bei Widerruf der Einwilligung.
- **Admin-Kontrolle:** Sicherer Import (mit Merge-Logik und automatischem Backup), Export für Serienbriefe, Alumni-Webseiten-Link und detailliertes Audit-Logging.
- **Alumni-Webseiten-Link:** Konfigurierbarer Link zur Alumni-Webseite, sichtbar für angemeldete Benutzer auf der Startseite und im Admin-Panel.
- **Sicherheit:** Strikte Trennung zwischen System-Logs (technisch) und Audit-Logs (Compliance).
- **CSV Import/Export:** Import mit Merge-Logik (ID/E-Mail) und korrektem Spalten-Mapping, Export für Serienbriefe.

## API-Endpunkte

### Authentifizierung
- `POST /api/auth/magic-link` - Magic Link anfordern
- `POST /api/auth/verify` - Magic Link verifizieren

### Personen
- `GET /api/persons/` - Öffentliche Liste (nur Personen mit Teilen-Einwilligung, **authentifiziert**)
- `GET /api/persons/me` - Eigene Daten abrufen
- `PUT /api/persons/me` - Eigene Daten aktualisieren
- `DELETE /api/persons/me` - Eigene Daten löschen
- `GET /api/persons/export` - Alle Daten exportieren (Admin)

### Admin
- `GET /api/admin/privacy-policy` - Datenschutzerklärung abrufen (inkl. Alumni-Webseiten-Link)
- `PUT /api/admin/privacy-policy` - Datenschutzerklärung aktualisieren (inkl. Alumni-Webseiten-Link)
- `POST /api/admin/backup` - Datenbank Backup herunterladen
- `POST /api/admin/restore` - Datenbank aus Backup wiederherstellen
- `GET /api/admin/export/all` - Alle Daten als CSV exportieren
- `POST /api/admin/import` - CSV Import mit Merge-Logik (ID/E-Mail, Gruppen-Lookup)
- `POST /api/admin/persons` - Person erstellen (Admin)
- `PUT /api/admin/persons/{id}` - Person aktualisieren (Admin)
- `GET /api/admin/persons` - Alle Personen auflisten (Admin)

## Lizenz

MIT License
