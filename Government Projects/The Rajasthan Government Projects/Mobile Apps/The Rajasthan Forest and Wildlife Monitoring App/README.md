# The ChitraHarsha Van Rakshak (The Rajasthan Forest and Wildlife Monitoring App)

**Version:** 2025.12.24 (Commercial Edition)  
**Status:** Patent Pending (Vajra-Kavach Encrypted)  
**Organization:** VPK Ventures in collaboration with Government of Rajasthan (Proposed)

![Status](https://img.shields.io/badge/Status-Production%20Ready-emerald) ![Security](https://img.shields.io/badge/Security-AES--256--GCM-yellow) ![Platform](https://img.shields.io/badge/Platform-Flutter%20%7C%20Web%20%7C%20Android-blue)

**The ChitraHarsha Van Rakshak** is the world's most advanced, AI-powered Forest and Wildlife Monitoring System designed specifically for the **Rajasthan Forest Department**. It integrates hybrid cloud-edge computing, biometric authentication, and deep-tech encryption to empower **Van Praharis (Forest Guards)** and **DFOs (District Forest Officers)**.

---

## 🚀 Key Features

### 1. 🛡️ Vajra-Kavach™ 2.0 (Advanced Encryption)

- **Deep-Tech Security:** Defense-Grade **AES-256-GCM** encryption for:
  - **Text Notes:** Offense logs and confidential reports.
  - **Binary Evidence:** Images and Voice Notes are encrypted at byte-level before disk writes.
- **Tamper-Proof:** Ensures chain of custody for legal evidence in poaching cases.
- **Compliance:** Adheres to **IT Act, 2000** and **Evidence Act** digital admissibility standards.

### 2. 👁️ Drishti AI (Bio-Scan)

- **Offline Recognition:** Powered by **TensorFlow Lite**, identifying flora and fauna (e.g., Khejri trees, Blackbucks) instantly without internet.
- **Wildlife Protection Act Integration:** Automatically cites relevant sections (e.g., _Schedule I, WPA 1972_) upon detection.

### 3. 🌐 Megh-Setu (Hybrid Networking) with Laghu-Bhandar Pro

- **Offline First (SQLite):** Uses **SQLite** ("Laghu-Bhandar") to store encrypted shards locally when out of coverage.
- **Auto-Sync:** Seamlessly uploads encrypted payloads to the "10T SQL Grid" once connectivity (5G/SatCom) is restored.

### 4. 📸 Multimedia Evidence

- **Integrated Voice Recorder:** Capture suspect statements/ambient noise directly into the app.
- **Secure Cam:** Capture geo-tagged images of evidence (poached items, footprints) which are immediately encrypted.

### 5. 📜 Parivesh Integration

- **NoC Tracker:** Real-time tracking of Non-Objection Certificates for developmental projects (Solar Parks, Roads) directly from the MoEFCC Parivesh portal APIs.

---

## 🏛️ Government Documentation & Reports

Official documentation for the **Government of Rajasthan** and **Ministry of Environment, Forest and Climate Change (MoEFCC)** can be found in the `Government_Documents/` directory:

- [📄 Detailed Project Report (DPR)](Government_Documents/Detailed_Project_Report.md)
- [📄 Project Proposal for PCCF (HoFF)](Government_Documents/Project_Proposal_Rajasthan_Govt.md)

---

## 🛠️ Technical Architecture

- **Framework:** Flutter (Dart 3.0+)
- **State Management:** Provider
- **Security:** `encrypt` (AES-GCM), Biometric Auth
- **AI/ML:** Custom TensorFlow Lite models (Mocked for Demo)
- **Maps:** Offline GIS Layers (OpenStreetMap based)

---

## 📲 App Modules

### For Van Prahari (Mobile)

- **Apradh Panjiyan:** Secure filing of offenses (Poaching, Illegal Logging).
- **Gasti Path:** GPS-enabled patrol route logging.
- **Aapat-Kaal:** SOS beacon for emergencies.

### For DFO / Command Center (Dashboard)

- **Live Jurisdiction Map:** Real-time tracking of all active guards and sensor triggers.
- **Incident Feed:** Instant alerts from IoT sensors (Vibration/Thermal).
- **Legal Dashboard:** Monitor pending court cases and NoC approvals.

---

## 📥 Installation & Setup

1. **Prerequisites:**

   - Flutter SDK (v3.10+)
   - Android Studio / VS Code
   - Java JDK 11+

2. **Clone & Install:**

   ```bash
   git clone https://github.com/infinity-aggarwalharshul/The-Chandi-App.git
   cd "The Rajasthan Forest and Wildlife Monitoring App"
   flutter pub get
   ```

3. **Run:**
   ```bash
   flutter run
   ```

---

## 📜 Compliance & Legal

This application is built in strict accordance with:

- **The Wildlife (Protection) Act, 1972**
- **The Rajasthan Forest Act, 1953**
- **The Information Technology Act, 2000** (Sec 43A, 66C)
- **Digital Personal Data Protection Act, 2023**

See [GOV_GUIDELINES.md](GOV_GUIDELINES.md) for detailed compliance mappings.

---

## 🔄 Auto-Update Policy

This app supports **Over-the-Air (OTA) Updates** via the Open Forge Git Repository. Critical security patches are applied automatically on app restart.

---

**© 2025 VPK Ventures.** _All Rights Reserved. "Vajra-Kavach", "Drishti AI", and "Megh-Setu" are trademarks of VPK Ventures._
