/**
 * Raj Kissan Geo-Intelligence Module
 * Handles GPS, Satellite Mapping, and Live Tracking
 */
class GeoTagService {
  constructor() {
    this.coords = { lat: 0, lon: 0 };
    this.watchId = null;
    this.isTracking = false;
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
          this.coords = {
            lat: pos.coords.latitude,
            lon: pos.coords.longitude,
          };
          resolve(this.coords);
        },
        (err) => reject(err),
        { enableHighAccuracy: true, timeout: 5000, maximumAge: 0 }
      );
    });
  }

  // Start Live Tracking for Rural Areas
  startTracking(callback) {
    if (this.isTracking) return;
    this.isTracking = true;
    this.watchId = navigator.geolocation.watchPosition(
      (pos) => {
        this.coords = {
          lat: pos.coords.latitude,
          lon: pos.coords.longitude,
        };
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

  // Generate Satellite Map Embed (using OpenStreetMap as free alternative to Google Satellite)
  getMapUrl(lat, lon) {
    // Returns an embeddable iframe URL for OpenStreetMap (Standard Layer)
    // For satellite, we'd strictly need a paid API key (Google/Mapbox).
    // We will simulate the "Satellite View" text or use a placeholder if key missing.
    return `https://www.openstreetmap.org/export/embed.html?bbox=${
      lon - 0.01
    }%2C${lat - 0.01}%2C${lon + 0.01}%2C${
      lat + 0.01
    }&layer=mapnik&marker=${lat}%2C${lon}`;
  }
}

window.geoService = new GeoTagService();
