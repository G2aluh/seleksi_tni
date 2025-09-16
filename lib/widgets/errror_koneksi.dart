import 'package:flutter/material.dart';

Widget noInternetWidget(VoidCallback onRetry) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.wifi_off, size: 80, color: Colors.red),
        const SizedBox(height: 16),
        const Text(
          "Tidak ada koneksi internet",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text("Periksa jaringan Anda lalu coba lagi."),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text("Coba Lagi"),
        ),
      ],
    ),
  );
}

Widget supabaseErrorWidget(String message, VoidCallback onRetry) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.cloud_off, size: 80, color: Colors.orange),
        const SizedBox(height: 16),
        const Text(
          "Masalah koneksi ke server",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('Coba periksa internet anda dan coba lagi', textAlign: TextAlign.center),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text("Muat Ulang"),
        ),
      ],
    ),
  );
}
