<template>
  <div class="privacy">
    <h1>Datenschutzerklärung</h1>
    <div class="privacy-content">
      <h2>Datenschutzerklärung für die Abiturientenliste</h2>
      <p><strong>Verantwortlicher:</strong> [Name des Administrators / Verantwortlichen], [Kontaktmöglichkeit].</p>
      
      <h3>Zweck der Verarbeitung</h3>
      <p>Die Verarbeitung Ihrer Daten erfolgt ausschließlich zum Zweck der Organisation und Durchführung von Alumni-Events (z. B. Jubiläen).</p>
      
      <h3>Rechtsgrundlage</h3>
      <p>Die Verarbeitung erfolgt auf Basis Ihrer ausdrücklichen Einwilligung gemäß Art. 6 Abs. 1 lit. a DSGVO.</p>
      
      <h3>Datenkategorien</h3>
      <p>Name, Anschrift, E-Mail, Telefonnummer sowie ggf. Fotos und Gruppenangaben.</p>
      
      <h3>Weitergabe an Dritte</h3>
      <p>Ihre Daten werden nur dann für andere Mitglieder der Liste sichtbar, wenn Sie explizit der Funktion "Teilen der Daten" zugestimmt haben. Eine Weitergabe an externe Firmen erfolgt nicht.</p>
      
      <h3>Ihre Rechte</h3>
      <p>Sie haben das Recht auf Auskunft, Berichtigung, Löschung ("Recht auf Vergessenwerden") sowie den Widerruf Ihrer Einwilligung jederzeit mit Wirkung für die Zukunft.</p>
      
      <h3>Speicherdauer</h3>
      <p>Die Daten werden so lange gespeichert, wie Sie Ihre Zustimmung nicht widerrufen oder die Liste aufgelöst wird.</p>
    </div>
  </div>
</template>

<script setup lang="ts">
</script>

<style scoped>
.privacy {
  max-width: 800px;
  margin: 0 auto;
}

h1 {
  color: #2c3e50;
  margin-bottom: 2rem;
}

.privacy-content {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.privacy-content h2 {
  margin-bottom: 1rem;
  color: #2c3e50;
}

.privacy-content h3 {
  margin-top: 1.5rem;
  margin-bottom: 0.5rem;
  color: #34495e;
}

.privacy-content p {
  margin-bottom: 1rem;
  line-height: 1.6;
  color: #555;
}
</style>
