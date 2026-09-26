import 'package:flutter/material.dart';

/// App color palette designed for VCall
/// Simple, clean, modern, student-friendly design system
class AppColors {
  // Primary Accent
  static const Color primary = Color(0xFF2563EB); // Vibrant Royal Blue
  static const Color primaryLight = Color(0xFFEFF6FF);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // Background & Surfaces
  static const Color background = Color(0xFFF8FAFC); // Neutral soft slate
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Text Hierarchy
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Status & Actions
  static const Color online = Color(0xFF10B981); // Emerald green for online badge & Accept
  static const Color onlineLight = Color(0xFFD1FAE5);

  static const Color endCall = Color(0xFFEF4444); // Red for end-call & destructive actions
  static const Color endCallLight = Color(0xFFFEE2E2);

  // Border & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);
}
