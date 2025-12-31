/**
 * IMAGE HANDLER MODULE
 *
 * Purpose: Secure patient image upload, processing, and management
 * Features: Camera capture, file upload, compression, encryption
 *
 * @module image-handler
 * @author The ChitraHarsha VPK Ventures
 * @version 2.0.0
 */

class ImageHandler {
  constructor() {
    this.maxImages = 5; // Maximum images per patient
    this.maxSizeBytes = 1024 * 1024; // 1MB
    this.targetWidth = 1920;
    this.targetHeight = 1080;
    this.quality = 0.85; // JPEG/WebP quality
    this.images = []; // Array of uploaded images
    this.currentStream = null;
  }

  /**
   * Initialize image upload interface
   * @param {string} containerId - Container element ID
   */
  initialize(containerId) {
    const container = document.getElementById(containerId);
    if (!container) {
      console.error("Container not found:", containerId);
      return;
    }

    container.innerHTML = this.createUploadUI();
    this.attachEventListeners();
    this.setupDragAndDrop();
  }

  /**
   * Create upload UI HTML
   * @returns {string} - HTML string
   */
  createUploadUI() {
    return `
      <div id="image-upload-card" class="card" style="margin-top: 20px;">
        <div class="card-header">
          <span class="card-title">📸 Patient Images</span>
          <span id="image-count-badge" class="status-badge status-online" style="font-size: 0.7rem;">
            0/${this.maxImages} images
          </span>
        </div>

        <!-- Upload Controls -->
        <div style="display: flex; gap: 10px; margin-bottom: 15px; flex-wrap: wrap;">
          <button id="capture-image-btn" class="btn-primary" style="flex: 1;">
            📷 Capture Photo
          </button>
          <button id="select-files-btn" class="btn-primary" style="flex: 1;">
            📁 Select Files
          </button>
          <input type="file" id="file-input" accept="image/*" multiple style="display: none;">
        </div>

        <!-- Drag & Drop Zone -->
        <div id="drop-zone" style="
          border: 2px dashed #cbd5e0;
          border-radius: 8px;
          padding: 30px;
          text-align: center;
          color: #718096;
          cursor: pointer;
          transition: all 0.3s;
        ">
          <div style="font-size: 2rem; margin-bottom: 10px;">📤</div>
          <div>Drag & drop images here or click to browse</div>
          <small style="display: block; margin-top: 5px;">(Max 1MB per image, WebP/JPEG/PNG)</small>
        </div>

        <!-- Image Gallery -->
        <div id="image-gallery" style="
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
          gap: 15px;
          margin-top: 15px;
        "></div>

        <!-- Camera Preview (hidden by default) -->
        <div id="camera-preview" class="hidden" style="
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background: rgba(0,0,0,0.95);
          z-index: 10000;
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
        ">
          <video id="preview-video" autoplay playsinline style="max-width: 90%; max-height: 70vh;"></video>
          <div style="margin-top: 20px; display: flex; gap: 15px;">
            <button id="take-photo-btn" class="btn-primary" style="padding: 15px 30px; font-size: 1.1rem;">
              📸 Take Photo
            </button>
            <button id="switch-camera-btn" class="btn-primary" style="padding: 15px 30px;">
              🔄 Switch Camera
            </button>
            <button id="close-camera-btn" class="btn-primary" style="padding: 15px 30px; background: #e53e3e;">
              ❌ Close
            </button>
          </div>
          <canvas id="capture-canvas" style="display: none;"></canvas>
        </div>
      </div>
    `;
  }

  /**
   * Attach event listeners
   */
  attachEventListeners() {
    // Capture photo button
    const captureBtn = document.getElementById("capture-image-btn");
    if (captureBtn) {
      captureBtn.addEventListener("click", () => this.openCamera());
    }

    // Select files button
    const selectBtn = document.getElementById("select-files-btn");
    if (selectBtn) {
      selectBtn.addEventListener("click", () => {
        document.getElementById("file-input").click();
      });
    }

    // File input change
    const fileInput = document.getElementById("file-input");
    if (fileInput) {
      fileInput.addEventListener("change", (e) => this.handleFileSelect(e));
    }

    // Camera controls
    const takePhotoBtn = document.getElementById("take-photo-btn");
    if (takePhotoBtn) {
      takePhotoBtn.addEventListener("click", () => this.capturePhoto());
    }

    const switchCameraBtn = document.getElementById("switch-camera-btn");
    if (switchCameraBtn) {
      switchCameraBtn.addEventListener("click", () => this.switchCamera());
    }

    const closeCameraBtn = document.getElementById("close-camera-btn");
    if (closeCameraBtn) {
      closeCameraBtn.addEventListener("click", () => this.closeCamera());
    }

    // Drop zone click
    const dropZone = document.getElementById("drop-zone");
    if (dropZone) {
      dropZone.addEventListener("click", () => {
        document.getElementById("file-input").click();
      });
    }
  }

  /**
   * Setup drag and drop
   */
  setupDragAndDrop() {
    const dropZone = document.getElementById("drop-zone");
    if (!dropZone) return;

    dropZone.addEventListener("dragover", (e) => {
      e.preventDefault();
      dropZone.style.borderColor = "#3498db";
      dropZone.style.background = "#eef2f7";
    });

    dropZone.addEventListener("dragleave", (e) => {
      e.preventDefault();
      dropZone.style.borderColor = "#cbd5e0";
      dropZone.style.background = "transparent";
    });

    dropZone.addEventListener("drop", async (e) => {
      e.preventDefault();
      dropZone.style.borderColor = "#cbd5e0";
      dropZone.style.background = "transparent";

      const files = Array.from(e.dataTransfer.files).filter((file) =>
        file.type.startsWith("image/")
      );

      for (const file of files) {
        if (this.images.length >= this.maxImages) {
          alert(`Maximum ${this.maxImages} images allowed`);
          break;
        }
        await this.processImage(file);
      }
    });
  }

  /**
   * Open camera for photo capture
   */
  async openCamera() {
    const preview = document.getElementById("camera-preview");
    const video = document.getElementById("preview-video");

    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
      alert("Camera not supported in this browser");
      return;
    }

    try {
      this.currentStream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: "environment" }, // Use back camera on mobile
        audio: false,
      });

      video.srcObject = this.currentStream;
      preview.classList.remove("hidden");
    } catch (error) {
      console.error("Camera access denied:", error);
      alert("Camera permission denied or not available");
    }
  }

  /**
   * Switch between front/back camera
   */
  async switchCamera() {
    this.closeCamera();

    const video = document.getElementById("preview-video");
    const currentFacingMode = this.currentStream
      ?.getVideoTracks()[0]
      ?.getSettings()?.facingMode;
    const newFacingMode = currentFacingMode === "user" ? "environment" : "user";

    try {
      this.currentStream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: newFacingMode },
        audio: false,
      });

      video.srcObject = this.currentStream;
      document.getElementById("camera-preview").classList.remove("hidden");
    } catch (error) {
      console.error("Failed to switch camera:", error);
      // Fallback to any available camera
      this.openCamera();
    }
  }

  /**
   * Capture photo from camera
   */
  capturePhoto() {
    const video = document.getElementById("preview-video");
    const canvas = document.getElementById("capture-canvas");
    const context = canvas.getContext("2d");

    // Set canvas dimensions to match video
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;

    // Draw video frame to canvas
    context.drawImage(video, 0, 0);

    // Convert to blob
    canvas.toBlob(
      async (blob) => {
        if (blob) {
          const file = new File([blob], `capture-${Date.now()}.jpg`, {
            type: "image/jpeg",
          });
          await this.processImage(file);
          this.closeCamera();
        }
      },
      "image/jpeg",
      this.quality
    );
  }

  /**
   * Close camera
   */
  closeCamera() {
    if (this.currentStream) {
      this.currentStream.getTracks().forEach((track) => track.stop());
      this.currentStream = null;
    }

    const preview = document.getElementById("camera-preview");
    if (preview) {
      preview.classList.add("hidden");
    }
  }

  /**
   * Handle file selection
   * @param {Event} event - Change event
   */
  async handleFileSelect(event) {
    const files = Array.from(event.target.files);

    for (const file of files) {
      if (this.images.length >= this.maxImages) {
        alert(`Maximum ${this.maxImages} images allowed`);
        break;
      }
      await this.processImage(file);
    }

    // Reset input
    event.target.value = "";
  }

  /**
   * Process and compress image
   * @param {File} file - Image file
   */
  async processImage(file) {
    // Validate file type
    if (!file.type.startsWith("image/")) {
      alert("Please select an image file");
      return;
    }

    try {
      // Show processing indicator
      this.showProcessing(true);

      // Create image element
      const img = await this.loadImage(file);

      // Compress and resize
      const compressedBlob = await this.compressImage(img);

      // Validate size
      if (compressedBlob.size > this.maxSizeBytes) {
        alert(
          `Image too large even after compression. Please use a smaller image.`
        );
        this.showProcessing(false);
        return;
      }

      // Strip EXIF data for privacy
      const sanitizedBlob = await this.stripEXIF(compressedBlob);

      // Encrypt if encryption service available
      let imageData = {
        blob: sanitizedBlob,
        encrypted: false,
      };

      if (
        window.EncryptionService &&
        window.app &&
        window.app.state.currentUser
      ) {
        const encrypted = await window.EncryptionService.encryptFile(
          sanitizedBlob,
          window.app.state.currentUser
        );
        imageData = {
          data: encrypted,
          encrypted: true,
        };
      }

      // Add to images array
      const imageObj = {
        id: Date.now() + Math.random(),
        name: file.name,
        size: sanitizedBlob.size,
        type: sanitizedBlob.type,
        data: imageData,
        preview: URL.createObjectURL(sanitizedBlob),
        timestamp: new Date().toISOString(),
      };

      this.images.push(imageObj);
      this.updateGallery();
      this.updateCount();
      this.showProcessing(false);

      console.log("Image processed:", imageObj.name, imageObj.size, "bytes");
    } catch (error) {
      console.error("Image processing failed:", error);
      alert("Failed to process image");
      this.showProcessing(false);
    }
  }

  /**
   * Load image from file
   * @param {File} file - Image file
   * @returns {Promise<HTMLImageElement>}
   */
  loadImage(file) {
    return new Promise((resolve, reject) => {
      const img = new Image();
      img.onload = () => resolve(img);
      img.onerror = reject;
      img.src = URL.createObjectURL(file);
    });
  }

  /**
   * Compress image using Canvas API
   * @param {HTMLImageElement} img - Image element
   * @returns {Promise<Blob>}
   */
  compressImage(img) {
    return new Promise((resolve) => {
      const canvas = document.createElement("canvas");
      const ctx = canvas.getContext("2d");

      // Calculate new dimensions maintaining aspect ratio
      let width = img.width;
      let height = img.height;

      if (width > this.targetWidth) {
        height = (height * this.targetWidth) / width;
        width = this.targetWidth;
      }

      if (height > this.targetHeight) {
        width = (width * this.targetHeight) / height;
        height = this.targetHeight;
      }

      canvas.width = width;
      canvas.height = height;

      // Draw and compress
      ctx.drawImage(img, 0, 0, width, height);

      canvas.toBlob(
        (blob) => resolve(blob),
        "image/webp", // Use WebP for better compression
        this.quality
      );
    });
  }

  /**
   * Strip EXIF data (privacy)
   * @param {Blob} blob - Image blob
   * @returns {Promise<Blob>}
   */
  async stripEXIF(blob) {
    // Convert to canvas and back to strip metadata
    const img = await this.loadImage(new File([blob], "temp.jpg"));
    return this.compressImage(img);
  }

  /**
   * Update image gallery display
   */
  updateGallery() {
    const gallery = document.getElementById("image-gallery");
    if (!gallery) return;

    gallery.innerHTML = this.images
      .map(
        (img) => `
      <div class="image-card" data-id="${img.id}" style="
        position: relative;
        border-radius: 8px;
        overflow: hidden;
        background: #f7fafc;
        border: 1px solid #e2e8f0;
      ">
        <img src="${img.preview}" alt="${img.name}" style="
          width: 100%;
          height: 150px;
          object-fit: cover;
          cursor: pointer;
        " onclick="window.ImageHandler.viewImage('${img.id}')">
        <div style="padding: 8px;">
          <div style="font-size: 0.8rem; color: #4a5568; margin-bottom: 5px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
            ${img.name}
          </div>
          <div style="display: flex; justify-content: space-between; align-items: center;">
            <small style="color: #718096;">${(img.size / 1024).toFixed(
              1
            )} KB</small>
            <button onclick="window.ImageHandler.removeImage('${
              img.id
            }')" style="
              background: #e53e3e;
              color: white;
              border: none;
              padding: 4px 8px;
              border-radius: 4px;
              cursor: pointer;
              font-size: 0.75rem;
            ">🗑️</button>
          </div>
        </div>
      </div>
    `
      )
      .join("");
  }

  /**
   * Update image count badge
   */
  updateCount() {
    const badge = document.getElementById("image-count-badge");
    if (badge) {
      badge.textContent = `${this.images.length}/${this.maxImages} images`;
    }
  }

  /**
   * Remove image from collection
   * @param {string} id - Image ID
   */
  removeImage(id) {
    this.images = this.images.filter((img) => img.id.toString() !== id);
    this.updateGallery();
    this.updateCount();
  }

  /**
   * View image in lightbox
   * @param {string} id - Image ID
   */
  viewImage(id) {
    const img = this.images.find((i) => i.id.toString() === id);
    if (!img) return;

    // Create lightbox
    const lightbox = document.createElement("div");
    lightbox.style.cssText = `
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0,0,0,0.9);
      z-index: 10001;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
    `;

    lightbox.innerHTML = `
      <img src="${img.preview}" style="max-width: 90%; max-height: 90vh;">
    `;

    lightbox.onclick = () => lightbox.remove();
    document.body.appendChild(lightbox);
  }

  /**
   * Get all images for upload
   * @returns {Array} - Array of image objects
   */
  getImages() {
    return this.images;
  }

  /**
   * Clear all images
   */
  clearImages() {
    this.images = [];
    this.updateGallery();
    this.updateCount();
  }

  /**
   * Show/hide processing indicator
   * @param {boolean} show - Show indicator
   */
  showProcessing(show) {
    // Add loading spinner to drop zone
    const dropZone = document.getElementById("drop-zone");
    if (!dropZone) return;

    if (show) {
      dropZone.innerHTML =
        '<div style="font-size: 2rem;">⏳</div><div>Processing...</div>';
    } else {
      dropZone.innerHTML = `
        <div style="font-size: 2rem; margin-bottom: 10px;">📤</div>
        <div>Drag & drop images here or click to browse</div>
        <small style="display: block; margin-top: 5px;">(Max 1MB per image, WebP/JPEG/PNG)</small>
      `;
    }
  }
}

// Create singleton instance
const imageHandler = new ImageHandler();

// Export globally
if (typeof window !== "undefined") {
  window.ImageHandler = imageHandler;
}
