import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/config.dart';
import '../../services/app_state.dart';
import 'home_screen.dart';
import 'mandi_screen.dart';
import 'sell_screen.dart';
import 'lab_screen.dart';
import 'schemes_screen.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    Widget body;
    switch (state.currentView) {
      case "home":
        body = const HomeScreen();
        break;
      case "mandi":
        body = const MandiScreen();
        break;
      case "sell":
        body = const SellScreen();
        break;
      case "lab":
        body = const LabScreen();
        break;
      case "schemes":
        body = const SchemesScreen();
        break;
      default:
        body = const HomeScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.rajOrange, Colors.red],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "R",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "The ChitraHarsha",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Raj Kissan Organic",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          const Icon(Icons.lock, size: 14, color: AppColors.rajGreen),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.yellow.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.yellow.shade200),
            ),
            child: const Text(
              "Commercial Verifier",
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.govGold),
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: state.isOnline ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: state.isOnline ? Colors.green.shade100 : Colors.red.shade100,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    state.isOnline ? Icons.wifi : Icons.wifi_off,
                    size: 12,
                    color: state.isOnline ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    state.isOnline 
                      ? (state.syncStatus == "syncing" ? "SYNCING..." : "ONLINE")
                      : "OFFLINE",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: state.isOnline ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          body,
          if (state.updateNag != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppColors.rajBlue,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "System Update Available: ${state.updateNag!['version']}",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    const Text(
                      "Update Now",
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getViewIndex(state.currentView),
        onTap: (index) => state.setView(_getViewFromIndex(index)),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedItemColor: AppColors.rajOrange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.balance), label: "E-Mandi"),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: "Vikray"),
          BottomNavigationBarItem(icon: Icon(Icons.biotech), label: "Lab"),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: "Yojna"),
        ],
      ),
    );
  }

  int _getViewIndex(String view) {
    switch (view) {
      case "home": return 0;
      case "mandi": return 1;
      case "sell": return 2;
      case "lab": return 3;
      case "schemes": return 4;
      default: return 0;
    }
  }

  String _getViewFromIndex(int index) {
    switch (index) {
      case 0: return "home";
      case 1: return "mandi";
      case 2: return "sell";
      case 3: return "lab";
      case 4: return "schemes";
      default: return "home";
    }
  }
}
