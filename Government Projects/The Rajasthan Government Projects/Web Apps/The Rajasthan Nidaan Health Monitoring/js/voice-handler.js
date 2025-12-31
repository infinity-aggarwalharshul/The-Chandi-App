/**
 * VOICE & AUDIO HANDLER MODULE
 *
 * Purpose: Voice recognition and audio recording for hands-free data entry
 * Features: Speech-to-text, voice commands, audio recording
 * APIs: Web Speech API, MediaRecorder API
 *
 * @module voice-handler
 * @author The ChitraHarsha VPK Ventures
 * @version 2.0.0
 */

class VoiceHandler {
  constructor() {
    this.recognition = null;
    this.mediaRecorder = null;
    this.audioChunks = [];
    this.isListening = false;
    this.isRecording = false;
    this.currentLanguage = "en-IN"; // Default: English (India)
    this.consentGiven = false;

    // Voice commands mapping
    this.commands = {
      "save record": () => this.executeCommand("save"),
      "take photo": () => this.executeCommand("photo"),
      "switch tab": () => this.executeCommand("switch"),
      "start recording": () => this.startAudioRecording(),
      "stop recording": () => this.stopAudioRecording(),
    };

    this.initSpeechRecognition();
  }

  /**
   * Initialize Web Speech API
   */
  initSpeechRecognition() {
    if (
      !("webkitSpeechRecognition" in window) &&
      !("SpeechRecognition" in window)
    ) {
      console.warn("Speech Recognition not supported");
      return;
    }

    const SpeechRecognition =
      window.SpeechRecognition || window.webkitSpeechRecognition;
    this.recognition = new SpeechRecognition();

    this.recognition.continuous = false;
    this.recognition.interimResults = true;
    this.recognition.maxAlternatives = 1;
    this.recognition.lang = this.currentLanguage;

    this.setupRecognitionHandlers();
  }

  /**
   * Setup event handlers for speech recognition
   */
  setupRecognitionHandlers() {
    if (!this.recognition) return;

    this.recognition.onstart = () => {
      this.isListening = true;
      this.updateUI("listening", true);
      console.log("Voice recognition started");
    };

    this.recognition.onresult = (event) => {
      const result = event.results[event.results.length - 1];
      const transcript = result[0].transcript.trim();
      const isFinal = result.isFinal;

      console.log("Transcript:", transcript, "Final:", isFinal);

      if (isFinal) {
        this.handleTranscript(transcript);
      } else {
        this.updateUI("interim", transcript);
      }
    };

    this.recognition.onerror = (event) => {
      console.error("Speech recognition error:", event.error);
      this.isListening = false;
      this.updateUI("error", event.error);
    };

    this.recognition.onend = () => {
      this.isListening = false;
      this.updateUI("listening", false);
      console.log("Voice recognition ended");
    };
  }

  /**
   * Start voice recognition
   * @param {string} targetField - ID of target input field
   */
  async startVoiceInput(targetField = "voice-transcript") {
    if (!this.recognition) {
      alert(
        "Voice recognition not supported in this browser. Please use Chrome, Edge, or Safari."
      );
      return;
    }

    // Request consent if not given
    if (!this.consentGiven) {
      const consent = await this.requestConsent("voice");
      if (!consent) return;
    }

    try {
      this.targetField = targetField;
      this.recognition.start();
    } catch (error) {
      console.error("Failed to start voice recognition:", error);
      if (error.message.includes("already started")) {
        this.stopVoiceInput();
        setTimeout(() => this.startVoiceInput(targetField), 500);
      }
    }
  }

  /**
   * Stop voice recognition
   */
  stopVoiceInput() {
    if (this.recognition && this.isListening) {
      this.recognition.stop();
    }
  }

  /**
   * Toggle language (Hindi/English)
   */
  toggleLanguage() {
    this.currentLanguage = this.currentLanguage === "en-IN" ? "hi-IN" : "en-IN";
    if (this.recognition) {
      this.recognition.lang = this.currentLanguage;
    }
    return this.currentLanguage;
  }

  /**
   * Handle recognized transcript
   * @param {string} transcript - Recognized text
   */
  handleTranscript(transcript) {
    // Check if it's a voice command
    const commandKey = transcript.toLowerCase();
    if (this.commands[commandKey]) {
      this.commands[commandKey]();
      return;
    }

    // Regular transcript - insert into form
    const targetElement = document.getElementById(this.targetField);
    if (targetElement) {
      // Append to existing text
      const currentText = targetElement.value || "";
      targetElement.value = currentText + (currentText ? " " : "") + transcript;

      // Trigger input event for any listeners
      targetElement.dispatchEvent(new Event("input", { bubbles: true }));

      // Visual feedback
      this.showNotification(`Captured: "${transcript}"`, "success");
    }
  }

  /**
   * Execute voice command
   * @param {string} command - Command to execute
   */
  executeCommand(command) {
    console.log("Executing command:", command);

    switch (command) {
      case "save":
        // Trigger save button click
        const saveBtn = document.querySelector('button[type="submit"]');
        if (saveBtn) saveBtn.click();
        break;
      case "photo":
        // Trigger camera activation
        if (window.app && window.app.startCamera) {
          window.app.startCamera();
        }
        break;
      case "switch":
        // Switch to next tab
        if (window.app && window.app.nav) {
          const tabs = ["dashboard", "field", "cloud"];
          const currentTab = tabs.find(
            (tab) =>
              !document
                .getElementById(`view-${tab}`)
                .classList.contains("hidden")
          );
          const currentIndex = tabs.indexOf(currentTab);
          const nextTab = tabs[(currentIndex + 1) % tabs.length];
          window.app.nav(nextTab);
        }
        break;
    }

    this.showNotification(`Command executed: ${command}`, "info");
  }

  /**
   * Start audio recording (for patient consultation)
   */
  async startAudioRecording() {
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
      alert("Audio recording not supported in this browser.");
      return;
    }

    // Request consent if not given
    if (!this.consentGiven) {
      const consent = await this.requestConsent("audio");
      if (!consent) return;
    }

    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });

      // Use WebM format with Opus codec for best compression
      const options = { mimeType: "audio/webm;codecs=opus" };
      this.mediaRecorder = new MediaRecorder(stream, options);

      this.audioChunks = [];

      this.mediaRecorder.ondataavailable = (event) => {
        if (event.data.size > 0) {
          this.audioChunks.push(event.data);
        }
      };

      this.mediaRecorder.onstop = () => {
        const audioBlob = new Blob(this.audioChunks, { type: "audio/webm" });
        this.handleRecordedAudio(audioBlob);

        // Stop all tracks
        stream.getTracks().forEach((track) => track.stop());
      };

      this.mediaRecorder.start();
      this.isRecording = true;
      this.updateUI("recording", true);

      // Auto-stop after 5 minutes (300000ms) to prevent excessive files
      setTimeout(() => {
        if (this.isRecording) {
          this.stopAudioRecording();
          this.showNotification(
            "Recording stopped (5 minute limit)",
            "warning"
          );
        }
      }, 300000);

      this.showNotification("Recording started...", "info");
    } catch (error) {
      console.error("Failed to start audio recording:", error);
      alert("Microphone permission denied or not available.");
    }
  }

  /**
   * Stop audio recording
   */
  stopAudioRecording() {
    if (this.mediaRecorder && this.isRecording) {
      this.mediaRecorder.stop();
      this.isRecording = false;
      this.updateUI("recording", false);
    }
  }

  /**
   * Handle recorded audio blob
   * @param {Blob} audioBlob - Recorded audio
   */
  async handleRecordedAudio(audioBlob) {
    console.log("Audio recorded:", audioBlob.size, "bytes");

    // Create audio player for preview
    const audioURL = URL.createObjectURL(audioBlob);
    this.displayAudioPlayer(audioURL, audioBlob);
  }

  /**
   * Display audio player for preview and save
   * @param {string} audioURL - Object URL
   * @param {Blob} audioBlob - Audio blob
   */
  displayAudioPlayer(audioURL, audioBlob) {
    // Create audio player UI
    const container =
      document.getElementById("audio-preview-container") ||
      this.createAudioPlayerContainer();

    container.innerHTML = `
      <div style="background: #f0f4f8; padding: 15px; border-radius: 8px; margin-top: 15px;">
        <div style="display: flex; align-items: center; gap: 15px; margin-bottom: 10px;">
          <span style="font-weight: 600;">🎙️ Recording Preview</span>
          <span style="font-size: 0.85rem; color: #718096;">
            ${(audioBlob.size / 1024).toFixed(1)} KB
          </span>
        </div>
        <audio controls src="${audioURL}" style="width: 100%; margin-bottom: 10px;"></audio>
        <div style="display: flex; gap: 10px;">
          <button onclick="window.VoiceHandler.saveAudio()" 
                  class="btn-primary" 
                  style="flex: 1; padding: 8px;">
            💾 Save Recording
          </button>
          <button onclick="window.VoiceHandler.discardAudio()" 
                  class="btn-primary" 
                  style="flex: 1; padding: 8px; background: #e53e3e;">
            🗑️ Discard
          </button>
        </div>
      </div>
    `;

    container.classList.remove("hidden");

    // Store blob for saving
    this.currentAudioBlob = audioBlob;
  }

  /**
   * Create audio player container
   */
  createAudioPlayerContainer() {
    const container = document.createElement("div");
    container.id = "audio-preview-container";
    container.className = "hidden";

    // Insert into field report card
    const fieldCard = document.querySelector("#view-field .card");
    if (fieldCard) {
      fieldCard.appendChild(container);
    }

    return container;
  }

  /**
   * Save recorded audio
   */
  async saveAudio() {
    if (!this.currentAudioBlob) return;

    try {
      // Encrypt audio if encryption service available
      let audioData = this.currentAudioBlob;

      if (
        window.EncryptionService &&
        window.app &&
        window.app.state.currentUser
      ) {
        const encryptedAudio = await window.EncryptionService.encryptFile(
          this.currentAudioBlob,
          window.app.state.currentUser
        );
        audioData = encryptedAudio;
      }

      // Store in app state for later upload
      if (window.app) {
        window.app.attachAudio(audioData);
      }

      this.showNotification("Audio saved successfully!", "success");
      this.discardAudio();
    } catch (error) {
      console.error("Failed to save audio:", error);
      this.showNotification("Failed to save audio", "error");
    }
  }

  /**
   * Discard recorded audio
   */
  discardAudio() {
    const container = document.getElementById("audio-preview-container");
    if (container) {
      container.classList.add("hidden");
      container.innerHTML = "";
    }
    this.currentAudioBlob = null;
  }

  /**
   * Request user consent for recording
   * @param {string} type - 'voice' or 'audio'
   * @returns {Promise<boolean>} - Consent granted
   */
  async requestConsent(type) {
    return new Promise((resolve) => {
      const message =
        type === "voice"
          ? "Allow microphone access for voice input?\n\nYour voice will be processed locally for text conversion."
          : "Allow microphone access for audio recording?\n\nRecording will be encrypted and stored securely.";

      const consent = confirm(message);
      if (consent) {
        this.consentGiven = true;
      }
      resolve(consent);
    });
  }

  /**
   * Update UI elements
   * @param {string} action - UI action
   * @param {any} value - Value to update
   */
  updateUI(action, value) {
    switch (action) {
      case "listening":
        const voiceBtn = document.getElementById("voice-input-btn");
        if (voiceBtn) {
          voiceBtn.textContent = value ? "🎙️ Listening..." : "🎤 Voice Input";
          voiceBtn.style.background = value ? "#f39c12" : "";
        }
        break;

      case "recording":
        const recordBtn = document.getElementById("audio-record-btn");
        if (recordBtn) {
          recordBtn.textContent = value
            ? "⏸️ Stop Recording"
            : "🎙️ Record Audio";
          recordBtn.style.background = value ? "#e53e3e" : "";
        }
        break;

      case "interim":
        const interimDisplay = document.getElementById("interim-transcript");
        if (interimDisplay) {
          interimDisplay.textContent = value;
          interimDisplay.style.display = "block";
        }
        break;

      case "error":
        console.error("Voice error:", value);
        break;
    }
  }

  /**
   * Show notification
   * @param {string} message - Notification message
   * @param {string} type - Notification type
   */
  showNotification(message, type = "info") {
    // Create notification element
    const notification = document.createElement("div");
    notification.style.cssText = `
      position: fixed;
      top: 80px;
      right: 20px;
      background: ${
        type === "success"
          ? "#27ae60"
          : type === "error"
          ? "#e53e3e"
          : "#3498db"
      };
      color: white;
      padding: 12px 20px;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.2);
      z-index: 10001;
      animation: slideIn 0.3s ease;
    `;
    notification.textContent = message;

    document.body.appendChild(notification);

    setTimeout(() => {
      notification.style.animation = "slideOut 0.3s ease";
      setTimeout(() => notification.remove(), 300);
    }, 3000);
  }
}

// Create singleton instance
const voiceHandler = new VoiceHandler();

// Export globally
if (typeof window !== "undefined") {
  window.VoiceHandler = voiceHandler;
}

// Add CSS animations
const style = document.createElement("style");
style.textContent = `
  @keyframes slideIn {
    from { transform: translateX(400px); opacity: 0; }
    to { transform: translateX(0); opacity: 1; }
  }
  @keyframes slideOut {
    from { transform: translateX(0); opacity: 1; }
    to { transform: translateX(400px); opacity: 0; }
  }
`;
document.head.appendChild(style);
