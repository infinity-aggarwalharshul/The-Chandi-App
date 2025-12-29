import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../core/config.dart';
import '../../services/app_state.dart';

class MandiScreen extends StatelessWidget {
  const MandiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.bgGray,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Vipanika Mandi",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.rajBlue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.rajBlue.withOpacity(0.1)),
                    ),
                    child: const Text(
                      "10T-Scale Ready",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.rajBlue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search 10 Trillion Records...",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("LAT: 0.0004ms", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400)),
                  const Text("INDEX: OPTIMIZED", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.rajGreen)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: state.products.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final p = state.products[index];
                    return _buildProductCard(p);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Opacity(
        opacity: 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.spa, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("No active listings in your area.", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(dynamic p) {
    String emoji = "🥬";
    if (p.crop.toLowerCase().contains("wheat")) emoji = "🌾";
    if (p.crop.toLowerCase().contains("bajra")) emoji = "🌽";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              image: p.imagePath != null
                  ? DecorationImage(
                      image: FileImage(File(p.imagePath!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: p.imagePath == null 
                ? Center(child: Text(emoji, style: const TextStyle(fontSize: 32)))
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(p.crop, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Chip(
                      label: Text("Verified", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                      backgroundColor: Color(0x11138808),
                      labelStyle: TextStyle(color: AppColors.rajGreen),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text("₹${p.price}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.rajOrange)),
                    const SizedBox(width: 4),
                    Text("/ ${p.quantity.replaceAll(RegExp(r'\d+'), '').trim()}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text("${p.location} • ${p.date}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    if (p.audioPath != null)
                      const Icon(Icons.volume_up, size: 14, color: AppColors.rajBlue),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
