# Contributing to Nidaan X (OpenForge Copy)

Thank you for your interest in contributing to the **The Rajasthan Nidaan Health Monitoring System**. As a Government of Rajasthan project, we follow strict guidelines to ensure security, stability, and compliance.

## Code of Conduct

This project and everyone participating in it is governed by the [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## How to Contribute

### 1. Reporting Bugs

- Ensure the bug was not already reported.
- Open a new Issue on OpenForge/GitHub.
- **Do not** include any Real Patient Data in screenshots or logs. Use dummy data "John Doe".

### 2. Suggesting Enhancements

- Open an Issue with the tag `enhancement`.
- Explain why this feature would benefit the field health workers (ASHAs/ANMs).

### 3. Pull Requests (PR)

- Fork the repository.
- Create a branch: `git checkout -b feature/AmazingFeature`.
- Commit your changes: `git commit -m 'feat: Add AmazingFeature'`.
- **Sign your commits** (GPG Signature required for Govt Projects).
- Push to the branch: `git push origin feature/AmazingFeature`.
- Open a Pull Request.

## Coding Standards (Vastu-Digital)

- **JavaScript**: ES6+ features, functional programming style preferred.
- **Encryption**: NEVER bypass the `EncryptionService`. All PII must be encrypted.
- **Comments**: Must be comprehensive.
- **Language**: Variable names in English, but UI strings supported in Hindi (`hi.json`).

## Review Process

All PRs require review by:

1.  **Lead Architect** (ChitraHarsha VPK)
2.  **Security Officer** (to check for vulnerabilities)
3.  **Project Manager** (DoIT&C / NHM Representative)

## License

By contributing, you agree that your contributions will be licensed under the project's [Commercial/MIT License](LICENSE).
