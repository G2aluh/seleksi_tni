import 'package:flutter/material.dart';

/// Dialog error untuk koneksi internet dan masalah server Supabase.
/// Menyediakan tombol aksi retry yang dipasok dari caller.
///  Dialog error untuk no internet
void showNoInternetDialog(BuildContext context, VoidCallback onRetry) {
  showDialog(
    context: context,
    barrierDismissible: false, // ⛔ tidak bisa close dengan tap luar
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: const [
          Icon(Icons.wifi_off, color: Colors.red),
          SizedBox(width: 8),
          Text("Tidak ada koneksi"),
        ],
      ),
      content: const Text(
        "Periksa jaringan Anda lalu coba lagi.",
        style: TextStyle(fontSize: 14),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog
            onRetry(); // Jalankan aksi retry
          },
          icon: const Icon(Icons.refresh),
          label: const Text("Coba Lagi"),
        ),
      ],
    ),
  );
}

/// Dialog error untuk Supabase
void showSupabaseErrorDialog(
  BuildContext context,
  String message,
  VoidCallback onRetry,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: const [
          Icon(Icons.cloud_off, color: Colors.orange),
          SizedBox(width: 8),
          Text("Masalah Server"),
        ],
      ),
      content: Text(
        message.isNotEmpty
            ? message
            : "Terjadi masalah koneksi ke server. Periksa internet Anda lalu coba lagi.",
        style: const TextStyle(fontSize: 14),
      ),
      actions: [
        OutlinedButton.icon(
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog
            onRetry(); // Jalankan aksi retry
          },
          icon: const Icon(Icons.refresh),
          label: const Text("Muat Ulang"),
        ),
      ],
    ),
  );
}
