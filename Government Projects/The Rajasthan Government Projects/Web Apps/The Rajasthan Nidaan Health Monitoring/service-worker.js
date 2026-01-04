/**
 * SERVICE WORKER - Offline-First Architecture
 *
 * Purpose: Enable PWA capabilities, offline access, and background sync
 * Cache Strategy: Network-first for dynamic content, Cache-first for static assets
 *
 * @author The ChitraHarsha VPK Ventures
 * @version 2.0.0
 */

const CACHE_VERSION = "nidaan-x-v3.0.0";
const CACHE_NAME = `${CACHE_VERSION}-static`;
const DATA_CACHE_NAME = `${CACHE_VERSION}-data`;

// Assets to cache on install
const STATIC_ASSETS = [
  "/",
  "/index.html",
  "/manifest.json",
  "/css/style.css",
  "/css/kissan-x.css",
  "/js/encryption.js",
  "/js/voice-handler.js",
  "/js/image-handler.js",
  "/js/ai-brain.js",
  "/js/quantum-db.js",
  "/js/geo-tag.js",
  "/js/e-mandi.js",
  "/js/kissan-bot.js",
  "/js/blockchain.js",
  "/js/security-guard.js",
  // Firebase SDKs (cached from CDN)
  "https://www.gstatic.com/firebasejs/11.6.1/firebase-app.js",
  "https://www.gstatic.com/firebasejs/11.6.1/firebase-auth.js",
  "https://www.gstatic.com/firebasejs/11.6.1/firebase-firestore.js",
  "https://www.gstatic.com/firebasejs/11.6.1/firebase-storage.js",
];

// Install event - cache static assets
self.addEventListener("install", (event) => {
  console.log("[Service Worker] Installing...");

  event.waitUntil(
    caches
      .open(CACHE_NAME)
      .then((cache) => {
        console.log("[Service Worker] Caching static assets");
        return cache.addAll(
          STATIC_ASSETS.map((url) => new Request(url, { cache: "no-cache" }))
        );
      })
      .then(() => self.skipWaiting()) // Activate immediately
      .catch((error) => {
        console.error("[Service Worker] Install failed:", error);
      })
  );
});

// Activate event - cleanup old caches
self.addEventListener("activate", (event) => {
  console.log("[Service Worker] Activating...");

  event.waitUntil(
    caches
      .keys()
      .then((cacheNames) => {
        return Promise.all(
          cacheNames
            .filter((name) => {
              // Delete old cache versions
              return (
                name.startsWith("nidaan-") &&
                name !== CACHE_NAME &&
                name !== DATA_CACHE_NAME
              );
            })
            .map((name) => {
              console.log("[Service Worker] Deleting old cache:", name);
              return caches.delete(name);
            })
        );
      })
      .then(() => self.clients.claim()) // Take control immediately
  );
});

// Fetch event - serve from cache or network
self.addEventListener("fetch", (event) => {
  const { request } = event;
  const url = new URL(request.url);

  // Skip non-GET requests
  if (request.method !== "GET") {
    return;
  }

  // Skip Chrome extensions and Firebase internal requests
  if (
    url.protocol === "chrome-extension:" ||
    url.hostname.includes("googleapis.com")
  ) {
    return;
  }

  // Firebase Firestore requests - network first (always get fresh data)
  if (
    url.hostname.includes("firestore.googleapis.com") ||
    url.hostname.includes("firebase")
  ) {
    event.respondWith(networkFirst(request, DATA_CACHE_NAME));
    return;
  }

  // Static assets - cache first
  if (
    STATIC_ASSETS.includes(url.pathname) ||
    url.pathname.endsWith(".js") ||
    url.pathname.endsWith(".css") ||
    url.pathname.endsWith(".html")
  ) {
    event.respondWith(cacheFirst(request, CACHE_NAME));
    return;
  }

  // Images and media - cache first
  if (
    request.destination === "image" ||
    request.destination === "audio" ||
    request.destination === "video"
  ) {
    event.respondWith(cacheFirst(request, DATA_CACHE_NAME));
    return;
  }

  // Default: network first with cache fallback
  event.respondWith(networkFirst(request, CACHE_NAME));
});

/**
 * Cache-first strategy: Try cache, fallback to network
 */
async function cacheFirst(request, cacheName) {
  try {
    const cache = await caches.open(cacheName);
    const cached = await cache.match(request);

    if (cached) {
      console.log("[Service Worker] Serving from cache:", request.url);
      return cached;
    }

    // Not in cache, fetch from network
    const response = await fetch(request);

    // Cache successful responses
    if (response && response.status === 200) {
      cache.put(request, response.clone());
    }

    return response;
  } catch (error) {
    console.error("[Service Worker] Cache-first failed:", error);

    // Return offline page for navigation requests
    if (request.mode === "navigate") {
      return caches.match("/index.html");
    }

    throw error;
  }
}

/**
 * Network-first strategy: Try network, fallback to cache
 */
async function networkFirst(request, cacheName) {
  try {
    const response = await fetch(request);

    // Cache successful responses
    if (response && response.status === 200) {
      const cache = await caches.open(cacheName);
      cache.put(request, response.clone());
    }

    console.log("[Service Worker] Serving from network:", request.url);
    return response;
  } catch (error) {
    console.log("[Service Worker] Network failed, trying cache:", request.url);

    const cache = await caches.open(cacheName);
    const cached = await cache.match(request);

    if (cached) {
      return cached;
    }

    // Return offline page for navigation requests
    if (request.mode === "navigate") {
      return caches.match("/index.html");
    }

    throw error;
  }
}

// Background Sync - sync offline data when connection restored
self.addEventListener("sync", (event) => {
  console.log("[Service Worker] Background sync triggered:", event.tag);

  if (event.tag === "sync-nidaan-data") {
    event.waitUntil(syncOfflineData());
  }
});

/**
 * Sync offline data to cloud
 */
async function syncOfflineData() {
  try {
    // Get all windows/tabs
    const clients = await self.clients.matchAll();

    if (clients.length > 0) {
      // Send message to main app to trigger sync
      clients[0].postMessage({
        type: "BACKGROUND_SYNC",
        action: "sync-offline-queue",
      });

      console.log("[Service Worker] Background sync message sent");
    }
  } catch (error) {
    console.error("[Service Worker] Background sync failed:", error);
  }
}

// Push Notification Support (for future alerts)
self.addEventListener("push", (event) => {
  console.log("[Service Worker] Push notification received");

  const options = {
    body: event.data ? event.data.text() : "New health alert",
    icon: "https://img.icons8.com/fluency/192/medical-heart.png",
    badge: "https://img.icons8.com/fluency/96/medical-heart.png",
    vibrate: [200, 100, 200],
    tag: "nidaan-alert",
    requireInteraction: true,
    actions: [
      { action: "open", title: "Open App" },
      { action: "close", title: "Dismiss" },
    ],
  };

  event.waitUntil(
    self.registration.showNotification("Nidaan 2.0 Alert", options)
  );
});

// Notification click handler
self.addEventListener("notificationclick", (event) => {
  console.log("[Service Worker] Notification clicked:", event.action);

  event.notification.close();

  if (event.action === "open") {
    event.waitUntil(clients.openWindow("/index.html"));
  }
});

// Message handler (communication with main app)
self.addEventListener("message", (event) => {
  console.log("[Service Worker] Message received:", event.data);

  if (event.data && event.data.type === "SKIP_WAITING") {
    self.skipWaiting();
  }

  if (event.data && event.data.type === "CACHE_URLS") {
    const urls = event.data.urls || [];
    event.waitUntil(
      caches.open(DATA_CACHE_NAME).then((cache) => cache.addAll(urls))
    );
  }
});

console.log("[Service Worker] Loaded successfully");
