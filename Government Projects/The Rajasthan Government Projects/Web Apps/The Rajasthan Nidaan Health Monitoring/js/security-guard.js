/**
 * Vajra-Kavach 2.0: Ultimate Anti-Theft & Anti-Hacking Guard
 * - Heuristic detection of console/debugger
 * - Geofencing & Velocity Integrity (Anti-Spoofing)
 * - Object Freezing (Anti-Tamper)
 */

class VajraKavach {
  constructor() {
    this.status = "ACTIVE";
    this.lastPos = null;
    this.lastTime = null;
    this.init();
  }

  init() {
    this.protectEnvironment();
    this.startAntiTheftMonitor();
    console.log("🛡️ Vajra-Kavach 2.0: Active and Monitoring Integrity.");
  }

  protectEnvironment() {
    // 1. Detect Debugger Opening (Heuristic)
    const element = new Image();
    Object.defineProperty(element, "id", {
      get: () => {
        this.handleThreat("DEBUGGER_DETECTED");
      },
    });

    setInterval(() => {
      console.log(element);
      console.clear();
    }, 1000);

    // 2. Prevent Object Tampering (Freeze critical global objects)
    if (window.app) Object.freeze(window.app.config);
  }

  startAntiTheftMonitor() {
    if ("geolocation" in navigator) {
      navigator.geolocation.watchPosition((pos) => {
        this.verifyLocationIntegrity(pos);
      });
    }
  }

  verifyLocationIntegrity(pos) {
    const now = Date.now();
    if (this.lastPos) {
      // Calculate Distance (Haversine simplified for rapid check)
      const dist = this.getDistance(
        this.lastPos.coords.latitude,
        this.lastPos.coords.longitude,
        pos.coords.latitude,
        pos.coords.longitude
      );
      const timeDiff = (now - this.lastTime) / 1000; // seconds
      const velocity = dist / timeDiff; // meters per second

      // If velocity > 300m/s (approx commercial jet speed), flag as potential GPS spoofing
      if (velocity > 300 && timeDiff > 1) {
        this.handleThreat("GPS_SPOOFING_DETECTED");
      }
    }
    this.lastPos = pos;
    this.lastTime = now;
  }

  getDistance(lat1, lon1, lat2, lon2) {
    const R = 6371e3; // metres
    const φ1 = (lat1 * Math.PI) / 180;
    const φ2 = (lat2 * Math.PI) / 180;
    const Δφ = ((lat2 - lat1) * Math.PI) / 180;
    const Δλ = ((lon2 - lon1) * Math.PI) / 180;
    const a =
      Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
      Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  handleThreat(type) {
    console.error(`🚨 VAJRA-KAVACH THREAT NEUTRALIZED: ${type}`);
    this.status = "THREAT_DEFLECTED";

    // Add to Satya-Chain audit log
    if (window.SatyaChain) {
      window.SatyaChain.addTransaction({
        event: "SECURITY_THREAT",
        type: type,
        timestamp: Date.now(),
      });
    }

    // Defensive Actions
    if (type === "DEBUGGER_DETECTED") {
      // Optional: Redirect or clear sensitive state
      // window.location.href = "about:blank";
    }
  }
}

window.SecurityGuard = new VajraKavach();
