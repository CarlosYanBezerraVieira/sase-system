import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Utilitários de feedback visual padronizado para o app SASE.
class SaseFeedbackUtils {
  const SaseFeedbackUtils._();

  static void showSuccess({
    required String title,
    required String message,
    required Color color,
    IconData icon = Icons.check_circle,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color.withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      borderRadius: 16,
      icon: Icon(icon, color: Colors.white, size: 40),
      duration: const Duration(seconds: 4),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static void showError({
    required String title,
    required String message,
    Color color = Colors.redAccent,
    IconData icon = Icons.error_outline,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: Colors.white,
      margin: const EdgeInsets.all(24),
      icon: Icon(icon, color: Colors.white),
    );
  }
}
