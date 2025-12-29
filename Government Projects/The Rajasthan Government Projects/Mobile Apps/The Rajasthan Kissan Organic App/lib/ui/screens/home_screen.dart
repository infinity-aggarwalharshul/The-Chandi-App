import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/config.dart';
import '../../services/app_state.dart';
import '../../services/ai_processor.dart';
import '../../services/cloud_adapter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.user!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Welcome Banner
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.rajOrange, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.rajOrange.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Namaste, ${user['name'].split(' ')[0]} ji! 🙏",
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "District: ${user['district']}",
                        style: TextStyle(color: Colors.orange.shade50, fontSize: 14),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Emblem_of_India.svg/20px-Emblem_of_India.svg.png",
                      width: 30,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildPill(Icons.shield, "Verified Farmer"),
                  const SizedBox(width: 8),
                  _buildPill(Icons.cloud, "MeghKosh Linked"),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // System Intelligence
        _buildSectionHeader(Icons.analytics, "System Intelligence", AppColors.rajOrange, AIProcessor.nlpVersion),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatusCard("Inbuilt NLP", "ACTIVE", Colors.green, true),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatusCard("Sync Manager", "AUTO-DATA", AppColors.rajBlue, false, 
                isLoading: state.syncStatus == "syncing"),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Action Grid
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                "Vikray (Sell)",
                "List Produce",
                Icons.spa,
                Colors.green.shade50,
                AppColors.rajGreen,
                () => state.setView("sell"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                context,
                "Kray (Buy)",
                "Vipanika Mandi",
                Icons.shopping_cart,
                Colors.blue.shade50,
                AppColors.rajBlue,
                () => state.setView("mandi"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Schemes Ticker
        _buildSectionHeader(Icons.flag, "Govt. Yojna (Schemes)", Colors.black, "View All", 
          onAction: () => state.setView("schemes")),
        const SizedBox(height: 12),
        ...CloudAdapter.getSchemes().take(2).map((s) => _buildSchemeCard(s)),
        const SizedBox(height: 80), // Padding for bottom nav
      ],
    );
  }

  Widget _buildPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color iconColor, String actionText, {VoidCallback? onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 8),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.grey.shade500,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onAction,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: onAction != null ? Colors.transparent : AppColors.rajOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              actionText,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: onAction != null ? AppColors.rajOrange : AppColors.rajOrange,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard(String label, String status, Color statusColor, bool pulse, {bool isLoading = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (isLoading)
                const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))
              else
                Icon(Icons.circle, size: 8, color: statusColor),
              const SizedBox(width: 8),
              Text(
                status,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String title, String subtitle, IconData icon, Color bgColor, Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildSchemeCard(Map<String, String> s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.rajSand.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Text(s['icon']!, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  s['benefit']!,
                  style: const TextStyle(color: AppColors.rajGreen, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
