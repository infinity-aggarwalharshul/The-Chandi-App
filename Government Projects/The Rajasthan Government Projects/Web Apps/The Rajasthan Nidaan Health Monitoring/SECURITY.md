# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 3.0.x   | :white_check_mark: |
| 2.0.x   | :x:                |
| 1.0.x   | :x:                |

## Reporting a Vulnerability

The Government of Rajasthan and The ChitraHarsha VPK Ventures take security seriously. If you discover a vulnerability in **Nidaan X**, please follow these steps:

1.  **Do NOT** disclose the vulnerability publicly.
2.  Email the details to **security@chitraharshavpk.in** or **ciso.doitc@rajasthan.gov.in**.
3.  Include:
    - Description of the vulnerability.
    - Steps to reproduce.
    - Potential impact (e.g., PII exposure).

### Response Timeline

- **Acknowledgment:** Within 24 hours.
- **Assessment:** Within 72 hours.
- **Fix/Patch:** Within 7-14 days depending on severity (Critical/High).

### Data Protection Standards

This project adheres to:

- **ISO/IEC 27001:2013** (Information Security Management)
- **AES-256-GCM** Encryption for Data at Rest and in Transit.
- **OWASP Top 10** mitigation strategies.
- **CERT-In** Guidelines for Government Applications.

## Responsible Disclosure

We permit security researchers to test the application primarily on the `staging` environment. Testing on `production` (live patient data) is strictly prohibited and punishable under the **Information Technology Act, 2000**.
