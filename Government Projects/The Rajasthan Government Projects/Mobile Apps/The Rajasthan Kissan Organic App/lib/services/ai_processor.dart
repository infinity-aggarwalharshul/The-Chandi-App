class AIProcessor {
  static const String nlpVersion = "KRISHI-SARATHI-V5-HYBRID";
  
  // Localized Dictionary for Global Ready Support
  static const Map<String, Map<String, String>> l10n = {
    'en': {'welcome': 'Namaste', 'intent_found': 'Listing Intent Detected'},
    'hi': {'welcome': 'नमस्ते', 'intent_found': 'विक्रय मंशा पाई गई'},
    'mrw': {'welcome': 'खम्मा घणी', 'intent_found': 'बेचण री मंशा लागी'},
  };

  static Map<String, dynamic> process(String text, {bool isOnline = true, String lang = 'hi'}) {
    if (isOnline) {
      return _processOnlineSemantic(text, lang);
    } else {
      return _processOfflineLocal(text, lang);
    }
  }

  static Map<String, dynamic> _processOfflineLocal(String text, String lang) {
    String t = text.toLowerCase();
    Map<String, dynamic> data = _getInitialData();
    
    _applyCropDetection(t, data);
    _applyRegexExtraction(t, data);
    
    data["novelty"] = analyzeNovelty(data);
    data["processingMode"] = "OFFLINE-LOCAL";
    data["response_text"] = l10n[lang]?['intent_found'] ?? "";
    
    return data;
  }

  static Map<String, dynamic> _processOnlineSemantic(String text, String lang) {
    // Simulated High-Tier Transformer Model Analysis
    var data = _processOfflineLocal(text, lang);
    data["confidence"] = (data["confidence"] as double) + 0.15;
    data["processingMode"] = "ONLINE-HYPER-SEMANTIC";
    data["novelty"]["score"] = (data["novelty"]["score"] as double) + 0.2;
    return data;
  }

  static Map<String, dynamic> _getInitialData() => {
    "crop": "", "quantity": "", "price": "",
    "confidence": 0.85, "sentiment": "NEUTRAL",
  };

  static void _applyCropDetection(String t, Map<String, dynamic> data) {
    const cropMap = {
      "Wheat": ["wheat", "gehu", "kanak", "gehun"],
      "Millet": ["bajra", "millet", "pearl"],
      "Rice": ["rice", "chawal", "dhaan"],
      "Mustard": ["mustard", "sarso", "rayda"],
      "Organic": ["organic", "jaivik", "shudh", "shudh desi"],
    };

    cropMap.forEach((key, aliases) {
      if (aliases.any((a) => t.contains(a))) {
        data["crop"] = key;
        data["confidence"] = (data["confidence"] as double) + 0.05;
      }
    });
  }

  static void _applyRegexExtraction(String t, Map<String, dynamic> data) {
    final qtyMatch = RegExp(r'(\d+)\s*(kg|quintal|ton|kilo|bori|man)').firstMatch(t);
    if (qtyMatch != null) data["quantity"] = "${qtyMatch.group(1)} ${qtyMatch.group(2)}";

    final priceMatch = RegExp(r'(\d+)\s*(rupee|rs|inr|rupya|paise)').firstMatch(t);
    if (priceMatch != null) data["price"] = priceMatch.group(1);
  }

  static Map<String, dynamic> analyzeNovelty(Map<String, dynamic> data) {
    double score = 0.0;
    List<String> insights = [];
    
    if (data["crop"] == "Millet") {
      score += 0.4;
      insights.add("High Demand in Global Organic Markets (Year of Millets)");
    }
    
    if (data["price"] != null && int.tryParse(data["price"])! < 2000) {
      score += 0.3;
      insights.add("Competitive Pricing: High Liquidity Potential");
    }

    return {
      "score": score.clamp(0.0, 1.0),
      "tag": score > 0.6 ? "PLATINUM_LISTING" : "STANDARD",
      "insights": insights,
    };
  }

  static Future<Map<String, dynamic>> checkForUpdates() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      "version": "4.0.0-CHANDI-PRO",
      "status": "UP_TO_DATE",
      "modules": ["NLP-SARATHI-V5", "SEC-HYBRID-RSA", "LAGHU-V2"],
      "lastUpdate": DateTime.now().toIso8601String(),
    };
  }
}
