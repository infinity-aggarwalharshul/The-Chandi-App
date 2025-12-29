import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:signature/signature.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'dart:io';
import '../../core/config.dart';
import '../../services/app_state.dart';
import '../../services/ai_processor.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _cropController = TextEditingController();
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();
  final _nomineeNameController = TextEditingController();
  final _nomineeRelationController = TextEditingController();
  
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _transcript = "";

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _imageFile = image);
    }
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _audioPath = path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Audio evidence saved: ${path?.split('/').last}")),
      );
    } else {
      if (await _audioRecorder.hasPermission()) {
        const config = RecordConfig();
        final directory = await Directory.systemTemp.createTemp();
        final path = '${directory.path}/audio_evidence_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _audioRecorder.start(config, path: path);
        setState(() {
          _isRecording = true;
          _audioPath = null;
        });
      }
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _transcript = val.recognizedWords;
          });
          if (val.finalResult) {
            _processTranscript(val.recognizedWords);
          }
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Map<String, dynamic>? _lastAiResponse;

  void _processTranscript(String text) {
    final state = context.read<AppState>();
    final data = AIProcessor.process(
      text, 
      isOnline: state.isOnline, 
      lang: state.currentLanguage
    );
    
    setState(() {
      _cropController.text = data['crop'] ?? "";
      _qtyController.text = data['quantity'] ?? "";
      _priceController.text = data['price'] ?? "";
      _lastAiResponse = data;
      _isListening = false;
    });
  }

  void _handleSubmit() {
    if (_cropController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please specify a crop name")),
      );
      return;
    }

    final state = context.read<AppState>();
    state.addProduct({
      'crop': _cropController.text,
      'quantity': _qtyController.text,
      'price': _priceController.text,
      'location': state.user!['district'],
      'seller': state.user!['name'],
      'district': state.user!['district'],
      'imagePath': _imageFile?.path,
      'audioPath': _audioPath,
      'noveltyTag': _lastAiResponse != null ? _lastAiResponse!['novelty']['tag'] : "STANDARD",
      'nominee': {
        'name': _nomineeNameController.text,
        'relation': _nomineeRelationController.text,
      },
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Vikray Kendra",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Voice Assistant
        _buildVoiceTrigger(),

        if (_lastAiResponse != null) _buildNoveltyCard(),

        const SizedBox(height: 24),
        _buildTextField("Crop (Fasal)", _cropController, "e.g. Organic Bajra"),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField("Quantity", _qtyController, "e.g. 50 kg")),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField("Price (₹)", _priceController, "e.g. 2500")),
          ],
        ),
        const SizedBox(height: 24),

        // Nominee Section
        _buildNomineeSection(),

        const SizedBox(height: 24),
        // Signature
        const Text(
          "Electronic Signature (Digital Hastakshar)",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Signature(
              controller: _signatureController,
              backgroundColor: Colors.white,
            ),
          ),
        ),
        TextButton(
          onPressed: () => _signatureController.clear(),
          child: const Text("Clear Signature", style: TextStyle(color: Colors.grey)),
        ),

        const SizedBox(height: 24),
        // Document Upload Simulation
        _buildMediaUpload(),

        const SizedBox(height: 32),
        SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.rajGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.local_shipping),
                SizedBox(width: 8),
                Text("List on E-Mandi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildVoiceTrigger() {
    return GestureDetector(
      onTap: _listen,
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.rajBlue, Colors.blue]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(19),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Icon(Icons.mic, color: _isListening ? AppColors.rajGreen : AppColors.rajBlue, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isListening ? "Listening (Sun raha hu)..." : "Krishi Vaani",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      _isListening ? _transcript : "Tap to speak listing details",
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildNomineeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.rajSand.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.rajOrange.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.security, size: 18, color: AppColors.rajOrange),
              SizedBox(width: 8),
              Text("Nominee (Warisan)", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nomineeNameController,
            decoration: const InputDecoration(hintText: "Nominee Name", isDense: true),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nomineeRelationController,
            decoration: const InputDecoration(hintText: "Relationship", isDense: true),
          ),
        ],
      ),
    );
  }

  Widget _buildNoveltyCard() {
    final novelty = _lastAiResponse!['novelty'];
    final bool isHigh = novelty['tag'] == "PLATINUM_LISTING";
    
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHigh ? AppColors.rajBlue.withValues(alpha: 0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isHigh ? AppColors.rajBlue.withValues(alpha: 0.1) : Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isHigh ? Icons.auto_awesome : Icons.analytics, 
                size: 16, color: isHigh ? AppColors.rajBlue : Colors.grey),
              const SizedBox(width: 8),
              Text(
                "SARATHI NOVELTY DISCOVERY: ${novelty['tag']}",
                style: TextStyle(
                  fontSize: 10, 
                  fontWeight: FontWeight.bold, 
                  color: isHigh ? AppColors.rajBlue : Colors.grey.shade600,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _lastAiResponse!['response_text'] ?? "Analysis complete",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...((novelty['insights'] as List).map((insight) => Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 12, color: AppColors.rajGreen),
                const SizedBox(width: 8),
                Expanded(child: Text(insight, style: const TextStyle(fontSize: 11, color: Colors.grey))),
              ],
            ),
          ))),
          const SizedBox(height: 8),
          Text(
            "Powered by Krishi-Sarathi™ Hybrid NLP v5.0",
            style: TextStyle(fontSize: 8, fontStyle: FontStyle.italic, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaUpload() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey.shade50.withOpacity(0.5),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.none),
            ),
            child: _imageFile != null 
              ? Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(File(_imageFile!.path), height: 100, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 8),
                    const Text("Click to change image", style: TextStyle(fontSize: 10, color: AppColors.rajBlue)),
                  ],
                )
              : Column(
                  children: const [
                    Icon(Icons.camera_alt, size: 32, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      "Upload Crop Image (Fasal ki Photo)",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _toggleRecording,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isRecording ? Colors.red.shade50 : AppColors.rajBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _isRecording ? Colors.red.shade100 : AppColors.rajBlue.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  color: _isRecording ? Colors.red : AppColors.rajBlue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isRecording ? "Recording Audio Evidence..." : (_audioPath != null ? "Audio Evidence Attached" : "Record Audio Description"),
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: FontWeight.bold,
                          color: _isRecording ? Colors.red : AppColors.rajBlue,
                        ),
                      ),
                      if (_audioPath != null && !_isRecording)
                        Text(
                          "Secured by Rajasthan Govt MeghKosh Encrypter",
                          style: TextStyle(fontSize: 8, color: Colors.grey.shade500),
                        ),
                    ],
                  ),
                ),
                if (_isRecording)
                  const SizedBox(width: 8, height: 8, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
