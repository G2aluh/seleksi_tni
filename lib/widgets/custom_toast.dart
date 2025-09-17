import 'package:flutter/material.dart';

/// Snackbar modern minimalis untuk feedback singkat (success/error/info/warning).
class CustomToast {
  static void success(BuildContext context, String message) {
    _show(context, message, const Color(0xFF16A34A));
  }

  static void error(BuildContext context, String message) {
    _show(context, message, const Color(0xFFDC2626));
  }

  static void info(BuildContext context, String message) {
    _show(context, message, const Color(0xFF2563EB));
  }

  static void warning(BuildContext context, String message) {
    _show(context, message, const Color(0xFFF59E0B));
  }

  // Tampilan modern minimalis: latar lembut, aksen garis kiri, tanpa kontras berlebihan
  static void _show(BuildContext context, String message, Color accent) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    final Color bg = accent.withOpacity(0.15);
    const Color textColor = Color(0xFF334155); // slate-700

    messenger.showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: EdgeInsets.zero,
        duration: const Duration(seconds: 2),
        content: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 4,
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                splashRadius: 18,
                icon: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: textColor,
                ),
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
