import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/app_state.dart';
import 'screens/login_screen.dart';
import 'screens/guard_dashboard.dart';
import 'screens/dfo_dashboard.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: VanRakshakApp(),
    ),
  );
}

class VanRakshakApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The ChitraHarsha Van Rakshak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Color(0xFFF8FAFC),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      home: Consumer<AppState>(
        builder: (context, state, child) {
          switch (state.currentUser) {
            case UserRole.guard:
              return GuardDashboard();
            case UserRole.dfo:
              return DfoDashboard();
            case UserRole.none:
            default:
              return LoginScreen();
          }
        },
      ),
    );
  }
}
