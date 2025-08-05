// lib/screens/home_screen.dart

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartCart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // TODO: Navigate to CartScreen
              print('Cart button pressed!');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner_rounded, size: 150, color: Colors.grey),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text('Start Scanning'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                // TODO: Navigate to qr_scanner_screen.dart
                print('Scanner button pressed!');
              },
            ),
          ],
        ),
      ),
    );
  }
}
