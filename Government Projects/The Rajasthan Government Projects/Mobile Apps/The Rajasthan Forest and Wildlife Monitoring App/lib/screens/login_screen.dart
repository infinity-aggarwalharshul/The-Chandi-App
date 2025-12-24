import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../widgets/common.dart';
import '../utils/app_state.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _handleLogin(BuildContext context, UserRole role) {
    setState(() => _isLoading = true);
    
    // Simulate Biometric Scan
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Provider.of<AppState>(context, listen: false).login(role);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1448375240586-dfd8d395ea6c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Dark Overlay
            Container(color: Colors.blueGrey.shade900.withOpacity(0.9)),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassPanel(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Emblem
                      Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Emblem_of_India.svg/1200px-Emblem_of_India.svg.png",
                        height: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "The ChitraHarsha",
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueGrey.shade900,
                        ),
                      ),
                      Text(
                        "Van Rakshak ™",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Powered by VPK Ventures • Patent Pending",
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          letterSpacing: 2,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 32),

                      if (_isLoading)
                         Padding(
                           padding: const EdgeInsets.all(20.0),
                           child: Column(
                             children: [
                               Icon(FontAwesomeIcons.fingerprint, size: 48, color: Colors.green.shade500),
                               SizedBox(height: 16),
                               Text("SCANNING BIOMETRICS...", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                               SizedBox(height: 20),
                               LinearProgressIndicator(color: Colors.green.shade500),
                             ],
                           ),
                         )
                      else
                        Column(
                          children: [
                            _buildLoginButton(
                              icon: FontAwesomeIcons.fingerprint,
                              title: "Van Prahari Login",
                              subtitle: "Field Unit",
                              color: Colors.green,
                              onTap: () => _handleLogin(context, UserRole.guard),
                            ),
                            SizedBox(height: 12),
                            _buildLoginButton(
                              icon: FontAwesomeIcons.dna,
                              title: "DFO / Admin Login",
                              subtitle: "Command Center",
                              color: Colors.blue,
                              onTap: () => _handleLogin(context, UserRole.dfo),
                            ),
                          ],
                        ),

                      SizedBox(height: 32),
                      Text(
                        "Protected by Vajra-Kavach™ End-to-End Encryption.",
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _footerLink("Terms"),
                          Text(" • ", style: TextStyle(fontSize: 10, color: Colors.grey)),
                          _footerLink("Privacy"),
                          Text(" • ", style: TextStyle(fontSize: 10, color: Colors.grey)),
                          _footerLink("Security"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton({required IconData icon, required String title, required String subtitle, required MaterialColor color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color.shade600, size: 20),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 0.5)),
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey.shade900)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _footerLink(String text) {
    return GestureDetector(
      onTap: () {}, // Can open URL
      child: Text(text, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
    );
  }
}
