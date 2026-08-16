Ich möchte eine Liste der Abiturienten von 1980 einschließlich Lehrer und ehemaliger Mitschüler in einer Liste pflegen, um sie später für jährliche Events z.B. 50-jähriges Abitur im Jahr 2030 einladen zu können.

Diese Liste wurde 2010 erstellt, muss aber weiter gepflegt werden. Seit 2018 ist allerdings die DSGVO (englisch GDPR) in Kraft und muss beachtet werden.

Idee zur Umsetzung:

- Über eine Anwendung in einem Docker-Container wird diese Liste gepflegt.

- Jede Person in dieser Liste bekommt zunächst per EMail einen Link und kann:
  
  - Ein neues Passwort vergeben bzw. ein bestehendes Passwort ändern.
  
  - Zustimmung zur Datenspeicherung nach DSGVO geben oder verweigern.
  
  - Zustimmen, dass die eigenen Daten mit anderen Personen der Liste geteilt werden.
  
  - Zustimmen, dass Photos mit anderen Personen der Liste geteilt werden.
  
  - Die eigenen Daten ändern: Name, Vorname, Geburtsname, Adresse, Land, PLZ, Ort, Telefon_1, Telefon_2, Mobil, Email_1, Email_2

- Personen, die zugestimmt haben, die eigenen Daten zu teilen, dürfen auch die Liste mit Daten der Personen sehen, die ebenfalls zugestimmt haben.

- Von Personen, die der DSGVO widersprochen haben, werden alle Kontaktdaten gelöscht. Name, Vorname und email-Adresse bleiben erhalten, damit sie ihr Passwort zurücksetzen können.

- Personen, die der DSGVO widersprochen haben, dürfen sich auch komplett aus der Liste löschen. Name, Vorname bleibt erhalten. Die Kennung wird gesperrt, die eMail-Adresse gelöscht.

- Einige Personen werden Admin-Rechte bekommen und dürfen weitergehende Änderungen machen:
  
  - Andere Personen als Admin ernennen
  
  - Backup und Restore aller gespeicherten Daten als Download.
  
  - Gruppen von Personen ändern, Auswahlliste, Vorgabe der Gruppen: SchülerIn, LehrerIn, MitschülerIn.
  
  - Art der Erreichbarkeit von Personen ändern, Auswahlliste, Vorgabe: -unbekannt-, E-Mail, WhatsApp, Festnetz
  
  - Einzelne Personen manuell eintragen: Gruppe, Name, Vorname, email-Adresse.
  
  - Liste aller Personen als csv-Liste exportieren.
  
  - Liste aller Personen als csv-Liste importieren:
    
    - Muster: Adressliste.csv
    
    - Format der Felder zunächst prüfen.
    
    - Alle bestehenden Daten werden gelöscht.
    
    - Ausprägungen des Feldes Gruppe und Erreichbarkeit werden als Auswahlliste verwendet.
    
    - Liste der Personen wird importiert.


