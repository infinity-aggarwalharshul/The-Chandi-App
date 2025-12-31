/**
 * ENCRYPTION MODULE - AES-256-GCM Implementation
 *
 * Purpose: Client-side encryption for sensitive health data
 * Compliance: DPDP Act 2023, ISO 27001
 * Algorithm: AES-256-GCM with PBKDF2 key derivation
 *
 * @module encryption
 * @author The ChitraHarsha VPK Ventures
 * @version 2.0.0
 */

class EncryptionService {
  constructor() {
    this.algorithm = "AES-GCM";
    this.keyLength = 256;
    this.iterations = 100000; // PBKDF2 iterations
    this.saltLength = 16; // bytes
    this.ivLength = 12; // bytes for GCM
  }

  /**
   * Generate encryption key from password using PBKDF2
   * @param {string} password - User password
   * @param {Uint8Array} salt - Salt for key derivation
   * @returns {Promise<CryptoKey>} - Derived encryption key
   */
  async generateKey(password, salt) {
    try {
      const encoder = new TextEncoder();
      const passwordBuffer = encoder.encode(password);

      // Import password as key material
      const keyMaterial = await crypto.subtle.importKey(
        "raw",
        passwordBuffer,
        "PBKDF2",
        false,
        ["deriveBits", "deriveKey"]
      );

      // Derive AES-GCM key
      const key = await crypto.subtle.deriveKey(
        {
          name: "PBKDF2",
          salt: salt,
          iterations: this.iterations,
          hash: "SHA-256",
        },
        keyMaterial,
        {
          name: this.algorithm,
          length: this.keyLength,
        },
        false, // not extractable
        ["encrypt", "decrypt"]
      );

      return key;
    } catch (error) {
      console.error("Key generation failed:", error);
      throw new Error("Failed to generate encryption key");
    }
  }

  /**
   * Encrypt data using AES-256-GCM
   * @param {string|Object} data - Data to encrypt
   * @param {string} password - Encryption password
   * @returns {Promise<Object>} - Encrypted data with IV and salt
   */
  async encrypt(data, password) {
    try {
      // Convert data to string if object
      const plaintext = typeof data === "string" ? data : JSON.stringify(data);
      const encoder = new TextEncoder();
      const plaintextBuffer = encoder.encode(plaintext);

      // Generate random salt and IV
      const salt = crypto.getRandomValues(new Uint8Array(this.saltLength));
      const iv = crypto.getRandomValues(new Uint8Array(this.ivLength));

      // Generate encryption key
      const key = await this.generateKey(password, salt);

      // Encrypt data
      const encrypted = await crypto.subtle.encrypt(
        {
          name: this.algorithm,
          iv: iv,
        },
        key,
        plaintextBuffer
      );

      // Return encrypted data with metadata
      return {
        ciphertext: this.arrayBufferToBase64(encrypted),
        iv: this.arrayBufferToBase64(iv),
        salt: this.arrayBufferToBase64(salt),
        algorithm: this.algorithm,
        version: "1.0",
      };
    } catch (error) {
      console.error("Encryption failed:", error);
      throw new Error("Failed to encrypt data");
    }
  }

  /**
   * Decrypt data using AES-256-GCM
   * @param {Object} encryptedData - Encrypted data object
   * @param {string} password - Decryption password
   * @returns {Promise<string|Object>} - Decrypted data
   */
  async decrypt(encryptedData, password) {
    try {
      // Convert base64 to ArrayBuffer
      const ciphertext = this.base64ToArrayBuffer(encryptedData.ciphertext);
      const iv = this.base64ToArrayBuffer(encryptedData.iv);
      const salt = this.base64ToArrayBuffer(encryptedData.salt);

      // Generate decryption key
      const key = await this.generateKey(password, salt);

      // Decrypt data
      const decrypted = await crypto.subtle.decrypt(
        {
          name: this.algorithm,
          iv: iv,
        },
        key,
        ciphertext
      );

      // Convert to string
      const decoder = new TextDecoder();
      const plaintext = decoder.decode(decrypted);

      // Try to parse as JSON
      try {
        return JSON.parse(plaintext);
      } catch {
        return plaintext;
      }
    } catch (error) {
      console.error("Decryption failed:", error);
      throw new Error(
        "Failed to decrypt data - invalid password or corrupted data"
      );
    }
  }

  /**
   * Hash data using SHA-256 for integrity checks
   * @param {string} data - Data to hash
   * @returns {Promise<string>} - Hash in base64
   */
  async hash(data) {
    try {
      const encoder = new TextEncoder();
      const dataBuffer = encoder.encode(data);
      const hashBuffer = await crypto.subtle.digest("SHA-256", dataBuffer);
      return this.arrayBufferToBase64(hashBuffer);
    } catch (error) {
      console.error("Hashing failed:", error);
      throw new Error("Failed to hash data");
    }
  }

  /**
   * Generate random encryption password
   * @param {number} length - Password length
   * @returns {string} - Random password
   */
  generateRandomPassword(length = 32) {
    const charset =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
    const randomValues = crypto.getRandomValues(new Uint8Array(length));
    return Array.from(randomValues)
      .map((x) => charset[x % charset.length])
      .join("");
  }

  /**
   * Convert ArrayBuffer to Base64
   * @param {ArrayBuffer} buffer - Buffer to convert
   * @returns {string} - Base64 string
   */
  arrayBufferToBase64(buffer) {
    const bytes = new Uint8Array(buffer);
    let binary = "";
    for (let i = 0; i < bytes.length; i++) {
      binary += String.fromCharCode(bytes[i]);
    }
    return btoa(binary);
  }

  /**
   * Convert Base64 to ArrayBuffer
   * @param {string} base64 - Base64 string
   * @returns {ArrayBuffer} - Array buffer
   */
  base64ToArrayBuffer(base64) {
    const binary = atob(base64);
    const bytes = new Uint8Array(binary.length);
    for (let i = 0; i < binary.length; i++) {
      bytes[i] = binary.charCodeAt(i);
    }
    return bytes.buffer;
  }

  /**
   * Encrypt file (for images/audio)
   * @param {File|Blob} file - File to encrypt
   * @param {string} password - Encryption password
   * @returns {Promise<Object>} - Encrypted file data
   */
  async encryptFile(file, password) {
    try {
      const arrayBuffer = await file.arrayBuffer();
      const uint8Array = new Uint8Array(arrayBuffer);

      // Generate random salt and IV
      const salt = crypto.getRandomValues(new Uint8Array(this.saltLength));
      const iv = crypto.getRandomValues(new Uint8Array(this.ivLength));

      // Generate encryption key
      const key = await this.generateKey(password, salt);

      // Encrypt file data
      const encrypted = await crypto.subtle.encrypt(
        {
          name: this.algorithm,
          iv: iv,
        },
        key,
        uint8Array
      );

      return {
        ciphertext: this.arrayBufferToBase64(encrypted),
        iv: this.arrayBufferToBase64(iv),
        salt: this.arrayBufferToBase64(salt),
        originalType: file.type,
        originalSize: file.size,
        algorithm: this.algorithm,
        version: "1.0",
      };
    } catch (error) {
      console.error("File encryption failed:", error);
      throw new Error("Failed to encrypt file");
    }
  }

  /**
   * Decrypt file
   * @param {Object} encryptedFile - Encrypted file object
   * @param {string} password - Decryption password
   * @returns {Promise<Blob>} - Decrypted file as Blob
   */
  async decryptFile(encryptedFile, password) {
    try {
      const ciphertext = this.base64ToArrayBuffer(encryptedFile.ciphertext);
      const iv = this.base64ToArrayBuffer(encryptedFile.iv);
      const salt = this.base64ToArrayBuffer(encryptedFile.salt);

      const key = await this.generateKey(password, salt);

      const decrypted = await crypto.subtle.decrypt(
        {
          name: this.algorithm,
          iv: iv,
        },
        key,
        ciphertext
      );

      return new Blob([decrypted], { type: encryptedFile.originalType });
    } catch (error) {
      console.error("File decryption failed:", error);
      throw new Error("Failed to decrypt file");
    }
  }
}

// Export singleton instance
const encryptionService = new EncryptionService();

// Make available globally
if (typeof window !== "undefined") {
  window.EncryptionService = encryptionService;
}
