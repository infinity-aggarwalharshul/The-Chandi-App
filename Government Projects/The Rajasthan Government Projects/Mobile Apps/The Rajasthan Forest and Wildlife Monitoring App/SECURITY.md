# Security Protocol (VAJRA-KAVACH)

## 1. Encryption Standards

- **Algorithm:** AES-256-GCM (Galois/Counter Mode).
- **Key Management:** Ephemeral session keys rotated every 24 hours.

## 2. Chain of Custody

- Every digital evidence artifact (Image/Audio) is hashed (SHA-256) upon creation.
- Providing a tamper-evident audit trail for court admissibility.

## 3. Network Security (Megh-Setu)

- All transmission usage **TLS 1.3** with Certificate Pinning to prevent Man-in-the-Middle (MitM) attacks.
