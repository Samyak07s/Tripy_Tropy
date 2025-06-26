import 'package:flutter/material.dart';

class AppColors {
  // Base theme colors
  static const Color background = Color(0xFF121212); // Dark scaffold
  static const Color surface = Color(0xFF1E1E1E); // Cards and inputs
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textOnWhite = Color.fromARGB(255, 53, 53, 53);

  // Primary theme accent
  static const Color greenLight = Color(0xFF69F0AE); // Light green shade
  static const Color greenAccent =
      Color.fromARGB(255, 15, 187, 104); // Lime green
  static const Color gold = Color(0xFFFFD700); // Gold for icons/emojis

  // Linear Gradient (e.g., button or header)
  static const LinearGradient linearGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF64DD17)], // Light to deep green
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Error
  static const Color errorRed = Color(0xFFFF4D4F); // Strong red accent
}
