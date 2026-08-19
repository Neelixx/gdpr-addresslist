# Technische Spezifikation: Alumni-Adressverwaltung (DSGVO-konform)

## 1. System-Architektur & Deployment

* **Deployment-Modell:** Containerisierte Anwendung via **Docker** und **Docker Compose**.
* **Komponenten:**
  * `App-Container`: Backend (Python/FastAPI) und Frontend (Single Page Application, Vue 3).
  * `DB-Container`: Relationale Datenbank (PostgreSQL 15) zur sicheren Speicherung der Daten.
  * `Reverse Proxy`: Apache 2.4 mit Let's Encrypt SSL (Produktion) für HTTPS-Terminierung und Proxy zu Frontend/Backend.
  * `Volume-Mounts`: Persistente Speicherung der Datenbank, der Backups und des Log-Verzeichnisses.
* **Kommunikation:** 
  * Die Anwendung sendet **keine** E-Mails selbst. 
  * Die Anwendung stellt lediglich einen Export der Liste (CSV) bereit, damit diese extern für den Versand von Serienbriefen genutzt werden kann.
  * Für den initialen Zugang/Passwort-Reset generiert die App Token, die manuell oder über ein externes Mail-System verarbeitet werden können.

## 2. Datenmodell & Felder

### 2.1 Personen-Tabelle (Hauptdaten)

| Feld             | Typ          | Beschreibung                                        |
|:---------------- |:------------ |:--------------------------------------------------- |
| `id`             | Integer (PK) | Eindeutige Kennung                                  |
| `gruppe_id`      | Integer (FK) | Foreign Key auf Gruppen-Tabelle                     |
| `vorname`        | String       | Vorname                                             |
| `nachname`       | String       | Nachname                                            |
| `geburtsname`    | String       | Geburtsname                                         |
| `adresse`        | String       | Straße, Hausnummer                                  |
| `land`           | String       | Land (z. B. D, A, CH)                               |
| `ort`            | String       | Stadt                                               |
| `plz`            | String       | Postleitzahl                                        |
| `telefon_1`      | String       | Internationales Format (+49...)                     |
| `telefon_2`      | String       | Internationales Format (+49...)                     |
| `mobil`          | String       | Internationales Format (+49...)                     |
| `erreichbarkeit` | Enum         | -unbekannt-, E-Mail, WhatsApp, Festnetz, verstorben |
| `email_1`        | String       | Primäre E-Mail (bereinigt)                          |
| `email_2`        | String       | Sekundäre E-Mail (bereinigt)                        |
| `username`       | String       | Benutzername (Format: vorname.nachname, lowercase)  |
| `admin`          | Boolean      | Admin-Rechte                                        |
| `notizen`        | Text         | Freitext für Admins                                 |

### 2.2 Consent & Compliance Felder (Verarbeitungslogik)

* `consent_storage`: Boolean (Zustimmung zur Speicherung der Daten).
* `consent_sharing`: Boolean (Zustimmung, dass Daten für andere Nutzer sichtbar sind).
* `consent_photos`: Boolean (Zustimmung zum Teilen von Fotos).
* `consent_log`: Tabelle/Journal mit: `field_changed`, `old_value`, `new_value`, `timestamp`, `ip_address`.

## 3. Nutzer-Workflows

### 3.1 Erstzugang & Passwort (Magic Link Logik)

* **Token-Generierung:** Bei Bedarf generiert die App einen eindeutigen Token.
* **Konfigurierbare Expirationszeit:** In der Konfiguration (`.env`) kann die Gültigkeit des Tokens in Stunden eingestellt werden (`TOKEN_EXPIRY_HOURS`).
* **Prozess:** Die App generiert den Link/Token $\rightarrow$ Admin/Nutzer nutzt diesen extern für den Versand.

### 3.2 Self-Service (Nutzer)

* **Datenänderung:** Nutzer können alle oben genannten Felder bearbeiten.
* **Recht auf Auskunft / Datenexport:** Ein Button "Meine Daten exportieren" generiert eine CSV der eigenen Datensätze zur Mitnahme/Prüfung.
* **Einwilligungs-Management:** Nutzer können ihre Zustimmungen (`sharing`, `photos`) jederzeit über ein Dashboard ändern.

### 3.3 Löschkonzept & Recht auf Vergessenwerden

* **Widerruf der Speicherung:** Alle Kontaktdaten werden gelöscht. Nur `vorname`, `nachname` und `email_1` bleiben zur Identifikation/Passwort-Reset bestehen.
* **Komplette Löschung (Recht auf Vergessenwerden):** 
  * Alle personenbezogenen Daten werden entfernt.
  * Die Kennung (`ID`) wird als "gesperrt" markiert, um Duplikate zu vermeiden.
  * Die `email_1` wird gelöscht.
* **Status "verstorben":** Wenn in den Notizen/Erreichbarkeit "verstorben" vermerkt wird, werden alle Kontaktdaten (Tel, Email) automatisch aus der Sichtbarkeit entfernt.

## 3.4 Alumni-Webseiten-Link

* **Konfiguration:** Im Admin-Panel unter "Datenschutzerklärung" kann ein Link zur Alumni-Webseite konfiguriert werden.
* **Sichtbarkeit:** 
  * **Startseite:** Für angemeldete Benutzer wird der Link "Zur Alumni-Webseite" angezeigt, öffnet in neuem Tab.
  * **Admin-Panel:** Im Bereich "Datenschutzerklärung" als Eingabefeld "Link zur Alumni-Webseite".
  * **Öffentliche Datenschutzerklärung:** Der Link wird **nicht** in der öffentlichen Datenschutzerklärung angezeigt.
  * **Admin-Endpunkt** (`/api/admin/privacy-policy`): Liefert das Feld `alumni_website` separat zurück.

## 4. Admin-Workflows & Sicherheit

### 4.1 Admin-Funktionen

* **User-Management:** Andere Nutzer zu Admins ernennen.
* **Daten-Import (Merge-Logik):**
  * Vor dem Import: **Automatisches Backup** des aktuellen Datenbankzustands als `.sql`.
  * Der Import führt einen **Merge** durch: Wenn eine ID oder E-Mail existiert, werden die Daten aktualisiert statt neue Zeilen anzulegen.
  * **Spalten-Mapping:** Unterstützt Export-Format (`Benutzername`, `Zusage_Speicherung`, `Zusage_Teilen`, `Zusage_Fotos`, `Gruppe` → `gruppe_id` Lookup).
  * **ID-Konflikte:** Beim Update wird das `id`-Feld ignoriert, um Primary-Key-Konflikte zu vermeiden.
* **Daten-Export:** Export der gesamten Liste als CSV für externe Zwecke (Serienbriefe).
* **Backup/Restore:** Backup herunterladen (.sql), Wiederherstellung aus Backup-Datei mit automatischem Schema-Recreate.
* **Alumni-Webseiten-Link:** Konfigurierbar im Admin-Panel unter Datenschutzerklärung.

### 4.2 Logging & Auditierung (Strikte Trennung)

Um die DSGVO einzuhalten, wird zwischen zwei Log-Typen unterschieden:

| Typ            | Ziel                  | Inhalt                                                                                                                                                                                 |
|:-------------- |:--------------------- |:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **System-Log** | Technischer Betrieb   | `[Timestamp] INFO: Container restart`, `[Timestamp] ERROR: DB connection failed`. Keine personenbezogenen Daten!                                                                       |
| **Audit-Log**  | Compliance / Nachweis | `[Timestamp] ADMIN_ACTION: Export durchgeführt durch ID 1`, `[Timestamp] USER_CHANGE: ID 502 geändert Email_1 (von X nach Y)`, `[Timestamp] CONSENT_CHANGE: ID 102 widerruft sharing`. |

## 5. API-Endpunkte (Auszug)

### Authentifizierung
- `POST /api/auth/magic-link` - Magic Link anfordern
- `POST /api/auth/verify` - Magic Link verifizieren

### Personen
- `GET /api/persons/` - Liste (nur Personen mit Teilen-Einwilligung, **authentifiziert**)
- `GET /api/persons/me` - Eigene Daten abrufen
- `PUT /api/persons/me` - Eigene Daten aktualisieren
- `DELETE /api/persons/me` - Eigene Daten löschen
- `GET /api/persons/export` - Eigene Daten exportieren

### Admin
- `GET /api/admin/privacy-policy` - Datenschutzerklärung abrufen (inkl. `alumni_website`)
- `PUT /api/admin/privacy-policy` - Datenschutzerklärung aktualisieren (inkl. `alumni_website`)
- `POST /api/admin/backup` - Datenbank Backup herunterladen
- `POST /api/admin/restore` - Datenbank aus Backup wiederherstellen
- `GET /api/admin/export/all` - Alle Daten als CSV exportieren (mit Magic-Links)
- `POST /api/admin/import` - CSV Import mit Merge-Logik
- `GET /api/admin/persons` - Alle Personen auflisten (Admin)
- `GET /api/admin/groups` - Gruppen auflisten

## 6. Frontend-Routing & Authentifizierung

* **Route `/persons`**: Erfordert Authentifizierung (`meta: { requiresAuth: true }`)
* **Route `/meine-daten`**: Erfordert Authentifizierung
* **Route `/admin`**: Erfordert Authentifizierung + Admin-Rechte
* **Nicht angemeldete Benutzer** werden auf `/login` weitergeleitet

## 7. Benutzername-Format

* Format: `vorname.nachname` (lowercase)
* Umlaut-Ersetzung: ä→ae, ö→oe, ü→ue, ß→ss
* Leerzeichen und Kommas werden entfernt
* Beispiel: "Müller, Hans" → `hans.mueller`

## 8. CSV Import/Export Format

### Export-Spalten (Admin)
```
ID,Gruppe,Vorname,Nachname,Geburtsname,Adresse,Land,Ort,PLZ,
Telefon_1,Telefon_2,Mobil,Erreichbarkeit,Email_1,Email_2,
Benutzername,Admin,Zusage_Speicherung,Zusage_Teilen,Zusage_Fotos,
Gelöscht,Gesperrt,Erstellt,Aktualisiert,Magic_Link
```

### Import-Spalten (erwartet)
Gleiches Format wie Export. Wichtige Mappings:
- `Gruppe` → `gruppe_id` (Lookup by name)
- `Benutzername` → `username`
- `Zusage_Speicherung`, `Zusage_Teilen`, `Zusage_Fotos` → `consent_storage`, `consent_sharing`, `consent_photos`
- `Admin` → Boolean (`1`/`true`/`yes` = true)

## 9. Compliance-Dokumentation

### 9.1 Datenschutzerklärung (Template)

Die Anwendung stellt beim ersten Zugriff eine Datei/Text bereit, die als Vorlage dient:

> **Datenschutzerklärung für die Abiturientenliste [Jahrgang]**
> 
> **Verantwortlicher:** [Name des Administrators / Verantwortlichen], [Kontaktmöglichkeit].
> 
> **Zweck der Verarbeitung:** Die Verarbeitung Ihrer Daten erfolgt ausschließlich zum Zweck der Organisation und Durchführung von Alumni-Events (z. B. Jubiläen).
> 
> **Rechtsgrundlage:** Die Verarbeitung erfolgt auf Basis Ihrer ausdrücklichen Einwilligung gemäß Art. 6 Abs. 1 lit. a DSGVO.
> 
> **Datenkategorien:** Name, Anschrift, E-Mail, Telefonnummer sowie ggf. Fotos und Gruppenangaben.
> 
> **Weitergabe an Dritte:** Ihre Daten werden nur dann für andere Mitglieder der Liste sichtbar, wenn Sie explizit der Funktion "Teilen der Daten" zugestimmt haben. Eine Weitergabe an externe Firmen erfolgt nicht.
> 
> **Ihre Rechte:** Sie haben das Recht auf Auskunft, Berichtigung, Löschung ("Recht auf Vergessenwerden") sowie den Widerruf Ihrer Einwilligung jederzeit mit Wirkung für die Zukunft.
> 
> **Speicherdauer:** Die Daten werden so lange gespeichert, wie Sie Ihre Zustimmung nicht widerrufen oder die Liste aufgelöst wird.
