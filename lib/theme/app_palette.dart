import 'package:flutter/material.dart';

class AppPalette {
  static const Color primary = Color(0xFF2A7AB7);
  static const Color primaryDark = Color(0xFF184A73);
  static const Color primarySoft = Color(0xFF9ABBFF);
  static const Color accent = Color(0xFFFFB86C);
  static const Color accentSoft = Color(0xFFFFE8CF);
  static const Color mint = Color(0xFF48BFA3);
  static const Color canvas = Color(0xFFF4F8FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFD8E4F2);
  static const Color text = Color(0xFF17324D);
  static const Color muted = Color(0xFF6C7B8C);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [primaryDark, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [primarySoft, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
