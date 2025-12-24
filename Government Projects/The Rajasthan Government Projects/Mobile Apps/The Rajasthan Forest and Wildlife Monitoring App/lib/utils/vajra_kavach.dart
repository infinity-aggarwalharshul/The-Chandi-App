import 'package:encrypt/encrypt.dart';
import 'dart:convert';
import 'dart:math';

/// VAJRA-KAVACH ENCRYPTION MODULE (Patentable Feature)
/// Implements AES-256-GCM Encryption for secure data handling.
class VajraKavach {
  static Key? _key;
  static final _ivLength = 12;

  /// Initialize the secure key (Simulating key generation/retrieval)
  static Future<void> init() async {
    // In a real app, this would come from a secure keystore or derived from user credentials.
    // Generating a random 32-byte key for AES-256.
    _key = Key.fromSecureRandom(32); 
    print("Vajra-Kavach Initialized: Secure Key Generated.");
  }

  /// Encrypts plain text and returns a base64 string containing IV and Ciphertext.
  static Future<String> encryptData(String plainText) async {
    if (_key == null) await init();

    final iv = IV.fromSecureRandom(_ivLength);
    final encrypter = Encrypter(AES(_key!, mode: AESMode.gcm));

    final encrypted = encrypter.encrypt(plainText, iv: iv);

    // Combine IV and Encrypted Data for storage (Format: IV:Base64Data)
    final storedValue = "${iv.base64}:${encrypted.base64}";
    return storedValue;
  }

  /// Decrypts the secure string back to plain text.
  static Future<String> decryptData(String secureString) async {
    if (_key == null) await init();

    try {
      final parts = secureString.split(':');
      if (parts.length != 2) throw Exception("Invalid Secure Format");

      final iv = IV.fromBase64(parts[0]);
      final encryptedData = Encrypted.fromBase64(parts[1]);
      
      final encrypter = Encrypter(AES(_key!, mode: AESMode.gcm));
      return encrypter.decrypt(encryptedData, iv: iv);
    } catch (e) {
      print("Decryption Error: $e");
      return "Error: Data Compromised or Key Invalid.";
    }
  }

  /// Simulation of Media Encryption (since handling large binary blobs in this mock is heavy)
  static String encryptMediaReference(String mediaType) {
    return "VAJRA_ENC_BLOB_${mediaType.toUpperCase()}_${DateTime.now().millisecondsSinceEpoch}";
  }
}
