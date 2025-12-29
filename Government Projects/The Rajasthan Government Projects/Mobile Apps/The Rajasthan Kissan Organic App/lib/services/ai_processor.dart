class AIProcessor {
  static const String nlpVersion = "RJ-NLP-V4.2";

  static Map<String, dynamic> process(String text) {
    String t = text.toLowerCase();
    Map<String, dynamic> data = {
      "crop": "",
      "quantity": "",
      "price": "",
      "confidence": 0.9,
      "noveltyScore": 0.0,
      "sentiment": "NEUTRAL",
    };

    const cropMap = {
      "Wheat": ["wheat", "gehu", "kanak", "gehun", "gandham"],
      "Millet": ["bajra", "millet", "pearl", "baju"],
      "Rice": ["rice", "chawal", "dhaan", "basmati"],
      "Mustard": ["mustard", "sarso", "rayda", "rai"],
      "Organic": ["organic", "jaivik", "shudh", "desi", "natural"],
    };

    cropMap.forEach((key, aliases) {
      if (aliases.any((a) => t.contains(a))) {
        data["crop"] = key;
        data["confidence"] = (data["confidence"] as double) + 0.05;
      }
    });

    if (t.contains("export") || t.contains("videsh") || t.contains("quality")) {
      data["noveltyScore"] = (data["noveltyScore"] as double) + 0.45;
      data["sentiment"] = "POSITIVE";
    }

    // Basic regex for Qty and Price
    final qtyMatch = RegExp(r'(\d+)\s*(kg|quintal|ton|kilo|bori|man)').firstMatch(t);
    if (qtyMatch != null) {
      data["quantity"] = "${qtyMatch.group(1)} ${qtyMatch.group(2)}";
    }

    final priceMatch = RegExp(r'(\d+)\s*(rupee|rs|inr|rupya|paise)').firstMatch(t);
    if (priceMatch != null) {
      data["price"] = priceMatch.group(1);
    }

    data["confidence"] = (data["confidence"] as double).clamp(0.0, 0.99);
    return data;
  }

  static Future<Map<String, dynamic>> checkForUpdates() async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      "version": "2.5.5-CHANDI",
      "status": "REQUIRED",
      "modules": ["NLP-RJ-V5", "SEC-AES-V3", "CROP-ML-V2"],
      "lastUpdate": DateTime.now().toIso8601String(),
    };
  }
}
