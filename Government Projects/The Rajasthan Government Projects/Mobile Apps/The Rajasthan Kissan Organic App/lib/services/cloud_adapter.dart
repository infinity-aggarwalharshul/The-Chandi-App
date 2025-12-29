import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:lzstring/lzstring.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CloudAdapter {
  static const String storageKey = "raj_kissan_meghkosh_data";

  // AES Encryption helper
  static String encryptData(String data, String key) {
    final encryptionKey = encrypt.Key.fromUtf8(key.padRight(32, '0').substring(0, 32));
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(encryptionKey));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  // Compression helper
  static String compress(String data) {
    return LZString.compressToUTF16(data) as String? ?? data;
  }

  static String decompress(String data) {
    return LZString.decompressFromUTF16(data) as String? ?? data;
  }

  static Future<List<Product>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final localData = prefs.getString(storageKey);
    if (localData == null) return [];
    
    try {
      final decompressed = decompress(localData);
      final List<dynamic> decoded = jsonDecode(decompressed);
      return decoded.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<Product> uploadData(Map<String, dynamic> item, bool isOnline) async {
    final products = await getData();
    
    final newItem = Product(
      id: "VPK-${DateTime.now().millisecondsSinceEpoch}",
      crop: item['crop'],
      quantity: item['quantity'],
      price: item['price'],
      location: item['location'],
      date: DateTime.now().toString().substring(0, 10),
      syncStatus: isOnline ? "SYNCED_TO_MEGHRAJ" : "PENDING_UPLOAD",
      traceId: item['traceId'] ?? "CH-TRACE-${DateTime.now().millisecondsSinceEpoch}",
      seller: item['seller'],
      district: item['district'],
    );

    products.insert(0, newItem);
    
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(products.map((p) => p.toJson()).toList());
    await prefs.setString(storageKey, compress(jsonString));
    
    return newItem;
  }

  static List<Map<String, String>> getSchemes() {
    return [
      {
        "title": "Govardhan Organic Fertilizer",
        "benefit": "₹10,000 Subsidy",
        "type": "Organic",
        "icon": "🌱",
        "code": "GOF-2025",
      },
      {
        "title": "Raj Organic Farming Policy 2025",
        "benefit": "1.20 Lakh Hectare Target",
        "type": "Policy",
        "icon": "📜",
        "code": "ROFP-25",
      },
      {
        "title": "PM-Kisan Samman Nidhi",
        "benefit": "Direct Benefit Transfer",
        "type": "Central",
        "icon": "₹",
        "code": "PMK-DBT",
      },
      {
        "title": "Solar Pump Yojana (Kusum)",
        "benefit": "60% Subsidy",
        "type": "Infra",
        "icon": "☀️",
        "code": "KUSUM",
      },
    ];
  }
}
