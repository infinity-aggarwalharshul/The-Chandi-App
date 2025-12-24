import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';

class OffenseModal extends StatefulWidget {
  @override
  _OffenseModalState createState() => _OffenseModalState();
}

class _OffenseModalState extends State<OffenseModal> {
  final TextEditingController _notesController = TextEditingController();
  String _offenseType = "wood_cutting";
  bool _isRecording = false;
  bool _hasVoice = false;
  bool _hasImage = false;

  void _submit() async {
    if (_notesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter notes")));
      return;
    }

    Navigator.pop(context); // Close modal first
    
    // Simulate Encryption Delay
    await Future.delayed(Duration(seconds: 1));

    // Add to State
    Provider.of<AppState>(context, listen: false).addLog({
      "id": "GOV-RJ-${DateTime.now().millisecondsSinceEpoch}",
      "type": _offenseType,
      "notes": _notesController.text, // This will get encrypted in Provider
      "has_voice": _hasVoice,
      "has_image": _hasImage,
      "timestamp": DateTime.now().toIso8601String(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Encrypted Data Uploaded via Vajra-Kavach."),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade900,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.lock, color: Colors.yellow, size: 16),
                  SizedBox(width: 8),
                  Text("Apradh Panjiyan (Secure)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Spacer(),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(FontAwesomeIcons.xmark, color: Colors.grey),
                  )
                ],
              ),
            ),
            
            // Body
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.yellow.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.yellow.shade200)),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.shieldHalved, size: 12, color: Colors.yellow.shade800),
                        SizedBox(width: 8),
                        Expanded(child: Text("Vajra-Kavach Active: Data will be AES-256 encrypted.", style: TextStyle(fontSize: 10, color: Colors.yellow.shade800))),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Form
                  _label("Offense Type"),
                  DropdownButtonFormField<String>(
                    value: _offenseType,
                    items: [
                      DropdownMenuItem(value: "wood_cutting", child: Text("Illegal Wood Cutting")),
                      DropdownMenuItem(value: "poaching", child: Text("Wildlife Poaching")),
                      DropdownMenuItem(value: "encroachment", child: Text("Land Encroachment")),
                    ],
                    onChanged: (v) => setState(() => _offenseType = v!),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                  ),
                  SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _hasImage = true),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(_hasImage ? FontAwesomeIcons.check : FontAwesomeIcons.camera, color: _hasImage ? Colors.green : Colors.grey.shade300),
                                SizedBox(height: 4),
                                Text(_hasImage ? "Captured" : "Evidence", style: TextStyle(fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                       Expanded(
                        child: InkWell(
                          onTap: () => setState(() {
                            _isRecording = !_isRecording;
                            if (!_isRecording) _hasVoice = true;
                          }),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(color: _isRecording ? Colors.red.shade50 : Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: _isRecording ? Colors.red.shade200 : Colors.grey.shade200)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _isRecording 
                                  ? Icon(FontAwesomeIcons.microphone, color: Colors.red).animate(onPlay: (c) => c.repeat()).fade() 
                                  : Icon(_hasVoice ? FontAwesomeIcons.check : FontAwesomeIcons.microphone, color: _hasVoice ? Colors.green : Colors.grey.shade300),
                                SizedBox(height: 4),
                                Text(_isRecording ? "Recording..." : (_hasVoice ? "Recorded" : "Voice Note"), style: TextStyle(fontSize: 10, color: _isRecording ? Colors.red : Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  _label("Confidential Notes"),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Enter sensitive details...",
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),

                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: Icon(FontAwesomeIcons.lock),
                      label: Text("ENCRYPT & SAVE"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6.0, left: 2),
    child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 0.5)),
  );
}

class AIScanModal extends StatefulWidget {
  @override
  _AIScanModalState createState() => _AIScanModalState();
}

class _AIScanModalState extends State<AIScanModal> {
  bool _scanned = false;

  void _scan() async {
    // Simulate scan
    setState(() => _scanned = true);
    await Future.delayed(Duration(seconds: 3));
    if (mounted) Navigator.pop(context, true); // Return true to trigger autofill
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.6,
              child: Image.network("https://images.unsplash.com/photo-1542358892-7cb66b265008?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80", fit: BoxFit.cover, height: double.infinity, width: double.infinity),
            ),
            
            // HUD
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.cyan.withOpacity(0.3))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("DRISHTI VISION v4.0", style: TextStyle(color: Colors.cyanAccent, fontFamily: "monospace", fontWeight: FontWeight.bold, fontSize: 12)),
                              Text("TENSORFLOW LITE: ACTIVE", style: TextStyle(color: Colors.white70, fontFamily: "monospace", fontSize: 10)),
                            ],
                          ),
                        ),
                        IconButton(onPressed: () => Navigator.pop(context), icon: Icon(FontAwesomeIcons.xmark, color: Colors.white)),
                      ],
                    ),

                    // Reticle
                    Expanded(
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(width: 250, height: 250, decoration: BoxDecoration(border: Border.all(color: Colors.cyan.withOpacity(0.5)))),
                            // Scan line
                            if (!_scanned)
                              Container(height: 2, width: 240, color: Colors.cyan).animate(onPlay: (c) => c.repeat()).moveY(begin: -120, end: 120, duration: 1.5.seconds),
                            
                            // Result Overlay
                            if (_scanned)
                              Container(
                                margin: EdgeInsets.only(top: 280),
                                padding: EdgeInsets.all(12),
                                color: Colors.black87,
                                child: Text(
                                  "> DETECTING OBJECT...\n> MATCH: PROSOPIS CINERARIA\n> CONFIDENCE: 99.8%\n> STATUS: PROTECTED (ACT 1953)",
                                  style: TextStyle(color: Colors.cyanAccent, fontFamily: "monospace", fontSize: 12),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _scan,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.cyanAccent),
                          padding: EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: Text(_scanned ? "ANALYZING..." : "INITIATE BIO-SCAN", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
