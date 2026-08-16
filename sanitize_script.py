import csv
import re

def format_phone(phone):
    # Entferne alles außer Ziffern und +
    clean = re.sub(r'[^\d+]', '', phone)
    if not clean:
        return ""
    
    # Wenn es mit 0 beginnt (lokal/national), wandle in +49 um (Annahme Deutschland)
    # Dies ist eine Vereinfachung, aber für das Template sinnvoll.
    if clean.startswith('0'):
        clean = '+49' + clean[1:]
    elif not clean.startswith('+'):
        # Falls es gar keine Vorwahl hat, versuchen wir es zu retten oder lassen es so
        pass 
    return clean

def format_email(email_str):
    # Extrahiere E-Mail mit Regex
    email_match = re.search(r'[\w\.-]+@[\w\.-]+\.\w+', email_str)
    if email_match:
        return email_match.group(0).lower().strip()
    return ""

def sanitize_row(row):
    # 1. Felder Zusage_1 und Zusage_2 löschen (werden im neuen Header nicht aufgeführt)
    # Wir mappen die restlichen Felder neu.
    
    new_row = {
        "ID": row["ID"],
        "Gruppe": row["Gruppe"],
        "Vorname": row["Vorname"].strip(),
        "Nachname": row["Nachname"].strip(),
        "Geburtsname": row["Geburtsname"].strip(),
        "Adresse": row["Adresse"].strip(),
        "Land": row["Land"].strip(),
        "Ort": row["Ort"].strip(),
        "PLZ": row["PLZ"].strip(),
        "Telefon_1": "",
        "Telefon_2": "",
        "Mobil": "",
        "Erreichbarkeit": row["Erreichbarkeit"].strip(),
        "Email_1": "",
        "Email_2": "",
        "Admin": row["Admin"].strip(),
        "Notizen": row["Notizen"].strip()
    }

    # 2. Sonderfall "verstorben" prüfen
    is_deceased = False
    if "verstorben" in row["Erreichbarkeit"].lower() or "verstorben" in row["Notizen"].lower():
        is_deceased = True
        new_row["Erreichbarkeit"] = "verstorben"

    # 3. Kontaktdaten extrahieren/formatieren (nur wenn nicht verstorben)
    if not is_deceased:
        # Telefonnummern
        new_row["Telefon_1"] = format_phone(row["Telefon_1"])
        new_row["Telefon_2"] = format_phone(row["Telefon_2"])
        new_row["Mobil"] = format_phone(row["Mobil"])
        
        # E-Mails
        new_row["Email_1"] = format_email(row["Email_1"])
        new_row["Email_2"] = format_email(row["Email_2"])

    return new_row

def main():
    input_file = 'Adressliste.csv'
    output_file = 'Adressliste_template.csv'
    
    try:
        with open(input_file, mode='r', encoding='utf-8') as infile:
            reader = csv.DictReader(infile)
            
            # Neue Spaltenliste (ohne Zusage_1, Zusage_2)
            fieldnames = [
                "ID", "Gruppe", "Vorname", "Nachname", "Geburtsname", 
                "Adresse", "Land", "Ort", "PLZ", "Telefon_1", "Telefon_2", 
                "Mobil", "Erreichbarkeit", "Email_1", "Email_2", "Admin", "Notizen"
            ]
            
            with open(output_file, mode='w', encoding='utf-8', newline='') as outfile:
                writer = csv.DictWriter(outfile, fieldnames=fieldnames)
                writer.writeheader()
                
                for row in reader:
                    sanitized = sanitize_row(row)
                    writer.writerow(sanitized)
        
        print(f"Erfolgreich erstellt: {output_file}")
    except FileNotFoundError:
        print(f"Fehler: {input_file} nicht gefunden.")
    except Exception as e:
        print(f"Ein Fehler ist aufgetreten: {e}")

if __name__ == "__main__":
    main()
