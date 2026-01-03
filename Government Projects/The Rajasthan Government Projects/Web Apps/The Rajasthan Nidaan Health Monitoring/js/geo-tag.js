/**
 * Raj Kissan Geo-Intelligence Module (Zenith Update)
 * Features:
 * - GPS (High Accuracy)
 * - Satellite Mapping (Simulated)
 * - Voice-Guided Navigation (Google Maps-like)
 */
class GeoTagService {
  constructor() {
    this.coords = { lat: 0, lon: 0 };
    this.watchId = null;
    this.isTracking = false;
    this.isNavigating = false;
  }

  // Get current high-accuracy position
  async getLocation() {
    return new Promise((resolve, reject) => {
      if (!navigator.geolocation) {
        reject("GPS not supported");
        return;
      }
      navigator.geolocation.getCurrentPosition(
        (pos) => {
          this.coords = { lat: pos.coords.latitude, lon: pos.coords.longitude };
          resolve(this.coords);
        },
        (err) => reject(err),
        { enableHighAccuracy: true, timeout: 5000, maximumAge: 0 }
      );
    });
  }

  // Start Live Tracking (Mission Mode)
  startTracking(callback) {
    if (this.isTracking) return;
    this.isTracking = true;
    this.watchId = navigator.geolocation.watchPosition(
      (pos) => {
        this.coords = { lat: pos.coords.latitude, lon: pos.coords.longitude };
        if (callback) callback(this.coords);
      },
      (err) => console.error("Tracking Error:", err),
      { enableHighAccuracy: true }
    );
  }

  stopTracking() {
    if (this.watchId) navigator.geolocation.clearWatch(this.watchId);
    this.isTracking = false;
  }

  // OpenStreetMap Embed
  getMapUrl(lat, lon) {
    return `https://www.openstreetmap.org/export/embed.html?bbox=${
      lon - 0.01
    }%2C${lat - 0.01}%2C${lon + 0.01}%2C${
      lat + 0.01
    }&layer=mapnik&marker=${lat}%2C${lon}`;
  }

  /**
   * ZENITH FEATURE: Voice-Guided Navigation
   * "Navigate to Plot 4"
   */
  startVoiceNavigation(destination) {
    this.isNavigating = true;

    // 1. Simulate finding route
    console.log(`🗺️ Calculating Route to: ${destination}...`);

    // 2. Announce start
    this.speak(
      `Starting navigation to ${destination}. Head North for 200 meters.`
    );

    // 3. Simulate updates (In real app, check geolocation changes)
    setTimeout(
      () => this.speak("In 100 meters, turn right towards the tubewell."),
      5000
    );
    setTimeout(() => this.speak("You have arrived at " + destination), 10000);
  }

  speak(text) {
    if ("speechSynthesis" in window) {
      const u = new SpeechSynthesisUtterance(text);
      u.rate = 1.0;
      window.speechSynthesis.speak(u);
    }
  }
}

window.geoService = new GeoTagService();
