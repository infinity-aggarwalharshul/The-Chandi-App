# Detailed Project Report (DPR)

## The ChitraHarsha Van Rakshak: AI-Powered Forest & Wildlife Monitoring System

**Submitted To:** Department of Forest, Government of Rajasthan  
**Developed By:** VPK Ventures  
**Date:** December 24, 2025  
**Version:** 1.0 (Commercial Production Release)

---

### 1. Executive Summary

"The ChitraHarsha Van Rakshak" is a state-of-the-art mobile and desktop application ecosystem designed to modernize forest patrolling, wildlife protection, and offensive reporting in Rajasthan. By leveraging Edge-AI ("Drishti"), Military-Grade Encryption ("Vajra-Kavach"), and Hybrid Offline Networking ("Megh-Setu"), the system addresses critical gaps in real-time monitoring and legal evidence admissibility.

### 2. Objectives

1.  **Zero-Latency Reporting:** Enable Van Praharis (Guards) to log incidents instantly, even in deep forest zones without internet.
2.  **Digital Evidence Chain:** Secure audio/visual evidence against tampering using AES-256-GCM encryption.
3.  **Efficiency:** Automated KPI tracking for DFOs and real-time Parivesh NoC integration.
4.  **Species Protection:** AI-assisted identification of endangered species under WPA, 1972.

### 3. Technical Architecture

#### 3.1 Mobile Unit (The Praharis)

- **Framework:** Flutter (Android/iOS)
- **Local Storage:** SQLite ("Laghu-Bhandar Pro") for persistent offline storage.
- **Encryption:** "Vajra-Kavach 2.0" (AES-256-GCM) for all local data at rest.
- **AI Engine:** TensorFlow Lite mobile models for on-device flora/fauna recognition.

#### 3.2 Command Center (The DFO Dashboard)

- **Platform:** Flutter Desktop / Web
- **Visualization:** Interactive GIS Maps showing patrol beats and live IoT sensor alerts.
- **Admin Features:** Roster management, Parivesh API integration, and Legal Case tracking.

#### 3.3 Data Synchronization (Megh-Setu)

- **Mechanism:** Store-and-Forward. Data is sharded and stored locally when offline.
- **Sync Trigger:** Automatic handshake with State Data Center (SDC) upon network restoration (4G/5G/SatCom).

### 4. Functional Modules

| Module Name         | Description                                                                | Status       |
| :------------------ | :------------------------------------------------------------------------- | :----------- |
| **Apradh Panjiyan** | Digital offense logging (Poaching, Timber Theft) with secure forms.        | ✅ Completed |
| **Vajra-Voice**     | Encrypted audio recording for collecting suspect statements/ambient noise. | ✅ Completed |
| **Secure-Cam**      | Geo-tagged, timestamped, and encrypted image capture.                      | ✅ Completed |
| **Gasti Path**      | GPS tracking of patrol routes to verify beat coverage.                     | ✅ Completed |
| **SOS Aapat-Kaal**  | One-touch emergency beacon with last known coordinates.                    | ✅ Completed |

### 5. Security & Compliance

- **Data Security:** Adheres to **FIPS 140-2** standards via AES-256-GCM.
- **Privacy:** Compliant with **Digital Personal Data Protection (DPDP) Act, 2023**.
- **Evidence:** Hash-chaining of media files ensures admissibility under **Section 65B of the Indian Evidence Act**.

### 6. Implementation Strategy

- **Phase 1 (Pilot):** Deployment in Ranthambore & Sariska Tiger Reserves (50 Units).
- **Phase 2 (Expansion):** Rollout to all District Forest Offices (DFOs) and Critical Tiger Habitats.
- **Phase 3 (Statewide):** Integration with Rajasthan Police and Revenue Department systems.

### 7. Conclusion

This project represents a "Digital Shield" for Rajasthan's biodiversity. By digitizing the first mile of forest protection, we empower the Van Prahari with the best of Indian technology, ensuring transparency, accountability, and rapid response.
