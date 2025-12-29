import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/config.dart';
import 'services/app_state.dart';
import 'ui/screens/login_screen.dart';
import 'ui/screens/main_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const RajKissanApp(),
    ),
  );
}

class RajKissanApp extends StatelessWidget {
  const RajKissanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ChandiConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.rajOrange,
          primary: AppColors.rajOrange,
          secondary: AppColors.rajGreen,
          tertiary: AppColors.rajBlue,
        ),
        textTheme: GoogleFonts.notoSansTextTheme(),
        scaffoldBackgroundColor: AppColors.bgGray,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: Consumer<AppState>(
        builder: (context, state, child) {
          if (state.user == null) {
            return const LoginScreen();
          }
          return const MainLayout();
        },
      ),
    );
  }
}
