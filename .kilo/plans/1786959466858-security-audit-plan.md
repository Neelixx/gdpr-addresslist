# Security Audit Plan

## 1. Scope
- Identify security weaknesses in the codebase handling personal data.
- Focus on GDPR compliance aspects: data collection, storage, processing, deletion, and transmission.
- Examine frontend consent mechanisms, backend APIs, database schemas, and storage encryption.

## 2. Threat Modeling
- Enumerate assets: frontend UI, API endpoints, database, backup files, logs.
- Identify potential threats: unauthorized data access, data leakage, insufficient consent, insecure transmission, improper backup handling.
- Prioritize by impact and exploitability.

## 3. Data Flow Review
- Map flow from user input (login/consent) → backend validation → database storage → response.
- Check for missing validation, improper error handling, and insecure redirects.
- Verify encryption at rest (DB, backups) and in transit (HTTPS, API calls).

## 4. Vulnerability Checklist
- **Authentication/Authorization**: Strength of password policies, JWT handling, session management.
- **Input Validation**: SQL injection, XSS, CSRF in frontend forms.
- **Data Exposure**: Logging of personal data, debug logs in production, backup file accessibility.
- **Third‑party Dependencies**: Versions of npm packages, Python requirements, known CVEs.
- **Secure Configuration**: Environment variable exposure (.env.example), file permissions on backups.

## 5. Validation Steps
- Run static analysis tools (e.g., bandit for Python, eslint security plugins for JS/TS).
- Perform dependency vulnerability scan (pip list --vulnerable, npm audit).
- Conduct secret scanning for accidental credential leaks.
- Review backup files for plaintext personal data.

## 6. Open Questions / Decisions
- Which consent mechanisms are considered legally sufficient under GDPR?
- Are backup retention policies documented and enforced?
- Do we need to perform a full penetration test or is static analysis sufficient for the current scope?

---

*Prepared for security audit of `gdpr-addresslist` project.*