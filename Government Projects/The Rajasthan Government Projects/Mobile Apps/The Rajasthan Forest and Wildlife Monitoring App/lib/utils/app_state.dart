import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'vajra_kavach.dart';
import 'db_helper.dart';

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
  final DbHelper _dbHelper = DbHelper();

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

  AppState() {
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final data = await _dbHelper.queryAllLogs();
    _logs = data.map((e) => Map<String, dynamic>.from(e)).toList();
    notifyListeners();
  }

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

  Future<void> addLog(Map<String, dynamic> logData, {File? imageFile, String? audioPath}) async {
    // 1. Encrypt Text
    final encryptedNotes = await VajraKavach.encryptData(logData['notes'] ?? "");
    
    // 2. Encrypt & Save Files
    String? encImagePath;
    String? encAudioPath;
    
    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      final encBytes = await VajraKavach.encryptBinary(bytes);
      final dir = await getApplicationDocumentsDirectory();
      final path = "${dir.path}/ENC_IMG_${DateTime.now().millisecondsSinceEpoch}.bin";
      await File(path).writeAsBytes(encBytes);
      encImagePath = path;
    }

    if (audioPath != null) {
      final file = File(audioPath);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        final encBytes = await VajraKavach.encryptBinary(bytes);
        final dir = await getApplicationDocumentsDirectory();
        final path = "${dir.path}/ENC_AUD_${DateTime.now().millisecondsSinceEpoch}.bin";
        await File(path).writeAsBytes(encBytes);
        encAudioPath = path;
      }
    }

    // 3. Insert into DB
    final row = {
      "id": logData['id'],
      "type": logData['type'],
      "encrypted_notes": encryptedNotes,
      "has_voice": (audioPath != null) ? 1 : 0,
      "has_image": (imageFile != null) ? 1 : 0,
      "timestamp": logData['timestamp'],
      "synced": _isOnline ? 1 : 0,
      "encrypted_image_path": encImagePath,
      "encrypted_audio_path": encAudioPath
    };

    await _dbHelper.insertLog(row);
    
    // 4. Refresh UI (Simulate 'Decrypted' View for the logger)
    // In a real app, we would decrypt on the fly. Here we just reload the DB list 
    // and rely on existing metadata for the list item.
    await _loadLogs();
  }

  Future<void> syncData() async {
    if (!_isOnline) return;
    _isSyncing = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2));

    // Update all local rows to synced
    final allLogs = await _dbHelper.queryAllLogs();
    for (var log in allLogs) {
      if (log['synced'] == 0) {
        final newRow = Map<String, dynamic>.from(log);
        newRow['synced'] = 1;
        await _dbHelper.update(newRow);
      }
    }

    await _loadLogs();
    _isSyncing = false;
    notifyListeners();
  }

  double get localStorageUsage {
    // Basic estimation
    return _logs.length * 256.0; 
  }
}
