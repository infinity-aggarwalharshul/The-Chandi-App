# Security Policy (Vajra-Kavach™)

## Security Vision

The **Rajasthan Forest & Wildlife Monitoring System** adopts a "Security First" approach, acknowledging the sensitive nature of forest surveillance data, anti-poaching intelligence, and legal offense records. Our security framework, codenamed **Vajra-Kavach**, is designed to protect data confidentiality, integrity, and availability.

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

Please do not report security vulnerabilities through public GitHub issues. Use the following channels:

- **Email**: `security@forest.rajasthan.gov.in` (Simulated)
- **Response Time**: We aim to acknowledge within 24 hours.

## Technical Security Measures

### 1. Encryption (Vajra-Kavach)

- **Client-Side**: All sensitive fields (offender names, specific gps coordinates of endangered species) are encrypted using **AES-256-GCM** before being stored in the local database (`localStorage` or IndexedDB).
- **Transmission**: Data in transit is secured via **TLS 1.2+**.

### 2. Access Control

- **Role-Based Access Control (RBAC)**:
  - `Van Prahari` (Field Guard): Write-only access to Offense Logs; Read-only access to assigned beat map.
  - `DFO` (District Forest Officer): Full Read/Write access to District Dashboard.
- **Biometric Simulation**: The application simulates biometric authentication to reinforce the concept of non-repudiation.

### 3. Data Sovereignty

- All data is architected to reside within servers physically located in India (MeitY empaneled Cloud or SDC), complying with the **Data Localization** directives of the Government of India.

### 4. Audit Trails

- Every action (login, data entry, sync) generates an immutable log entry in the "Ledger" for forensic auditing.

---

**Note**: This security policy applies to the software architecture. Physical security of devices (tablets/phones) is the responsibility of the respective Forest Division.
