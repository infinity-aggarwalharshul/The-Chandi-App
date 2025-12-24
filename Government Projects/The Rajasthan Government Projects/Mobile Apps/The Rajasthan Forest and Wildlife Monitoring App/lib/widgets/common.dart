import 'dart:ui';
import 'package:flutter/material.dart';

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Border? border;
  final bool isDark;

  const GlassPanel({
    Key? key,
    required this.child,
    this.padding,
    this.borderRadius = 24.0,
    this.border,
    this.isDark = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: isDark ? 16 : 20, sigmaY: isDark ? 16 : 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF0F172A).withOpacity(0.9) : Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ?? Border.all(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.4),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(31, 38, 135, 0.15),
                blurRadius: 32,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color baseColor;
  final VoidCallback onTap;

  const ActionCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.baseColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: baseColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: baseColor, size: 28),
            ),
            SizedBox(height: 12),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey.shade800)),
            Text(subtitle, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }
}
