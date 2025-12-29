import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cloud_adapter.dart';
import '../services/ai_processor.dart';

class AppState extends ChangeNotifier {
  Map<String, dynamic>? user;
  String currentView = "home";
  bool isOnline = true;
  String syncStatus = "idle";
  List<Product> products = [];
  Map<String, dynamic>? updateNag;

  AppState() {
    _init();
  }

  Future<void> _init() async {
    products = await CloudAdapter.getData();
    notifyListeners();
    
    // Simulation
    AIProcessor.checkForUpdates().then((val) {
      updateNag = val;
      notifyListeners();
    });
  }

  void setOnline(bool val) {
    isOnline = val;
    notifyListeners();
  }

  void login(Map<String, dynamic> userData) {
    user = userData;
    notifyListeners();
  }

  void setView(String view) {
    currentView = view;
    notifyListeners();
  }

  Future<void> addProduct(Map<String, dynamic> item) async {
    syncStatus = "encrypting";
    notifyListeners();
    
    await Future.delayed(const Duration(seconds: 1));
    
    await CloudAdapter.uploadData(item, isOnline);
    products = await CloudAdapter.getData();
    syncStatus = "idle";
    currentView = "mandi";
    notifyListeners();
  }

  void updateUserProfileImage(String path) {
    if (user != null) {
      user!['profileImage'] = path;
      notifyListeners();
    }
  }

  void logout() {
    user = null;
    currentView = "home";
    notifyListeners();
  }
}
