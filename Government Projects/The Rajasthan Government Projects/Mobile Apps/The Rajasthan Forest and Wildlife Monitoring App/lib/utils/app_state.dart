import 'package:flutter/material.dart';
import 'vajra_kavach.dart';
import 'dart:async';

enum UserRole {
  guard,
  dfo,
  none
}

class AppState extends ChangeNotifier {
  UserRole _currentUser = UserRole.none;
  bool _isOnline = true;
  List<Map<String, dynamic>> _logs = [];
  bool _isSyncing = false;

  UserRole get currentUser => _currentUser;
  bool get isOnline => _isOnline;
  List<Map<String, dynamic>> get logs => _logs;
  bool get isSyncing => _isSyncing;

  // Mock Data
  final List<Map<String, dynamic>> _dfoIncidents = [
    {
      "time": "10:42 AM",
      "msg": "Sensor #442 Triggered (Vibration)",
      "type": "alert",
    },
    {
      "time": "10:30 AM",
      "msg": "Ofc. Vikram logged Patrol Checkpoint 4",
      "type": "info",
    },
    {
      "time": "09:15 AM",
      "msg": "NOC Application #882 flagged for review",
      "type": "warn",
    },
  ];

  List<Map<String, dynamic>> get dfoIncidents => _dfoIncidents;

  void login(UserRole role) {
    _currentUser = role;
    notifyListeners();
  }

  void logout() {
    _currentUser = UserRole.none;
    notifyListeners();
  }

  void toggleNetwork() {
    _isOnline = !_isOnline;
    notifyListeners();
  }

  Future<void> addLog(Map<String, dynamic> logData) async {
    // Encrypt content before adding
    logData['data'] = await VajraKavach.encryptData(logData['notes'] ?? "");
    logData['synced'] = _isOnline; // Auto-sync if online
    
    // Decrypt immediately for local display purpose (in real app, we'd decrypt only when viewing details)
    // But for the list view logs, we might just show metadata.
    // We'll keep the raw 'notes' for display in this session, but 'data' represents the stored value.
    
    _logs.insert(0, logData);
    notifyListeners();
  }

  Future<void> syncData() async {
    if (!_isOnline) return;
    _isSyncing = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));

    for (var log in _logs) {
      log['synced'] = true;
    }

    _isSyncing = false;
    notifyListeners();
  }

  double get localStorageUsage {
    // Mock calculation
    return _logs.length * 256.0; // 256 bytes per log
  }
}
