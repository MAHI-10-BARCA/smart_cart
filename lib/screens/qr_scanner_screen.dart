// lib/screens/qr_scanner_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../services/firebase_service.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  bool _isScanning = true; // To prevent multiple scans at once

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Product Barcode')),
      body: MobileScanner(
        onDetect: (capture) {
          if (!_isScanning) return; // If already processing a scan, do nothing

          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? scannedCode = barcodes.first.rawValue;
            if (scannedCode != null) {
              setState(() {
                _isScanning = false; // Stop scanning
              });
              _handleScannedCode(scannedCode);
            }
          }
        },
      ),
    );
  }

  Future<void> _handleScannedCode(String code) async {
    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Fetch the product from Firebase
    final Product? product = await _firebaseService.getProductById(code);

    Navigator.of(context).pop(); // Dismiss the loading dialog

    if (product != null) {
      // If product is found, show the product details dialog
      _showProductDialog(product);
    } else {
      // If product is not found, show an error dialog
      _showErrorDialog('Product not found.');
    }
  }

  void _showProductDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.name),
        content: Text('Price: \$${product.price.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Add to Cart'),
            onPressed: () {
              // Use the CartProvider to add the item
              Provider.of<CartProvider>(context, listen: false).addToCart(product);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${product.name} added to cart!')),
              );
            },
          ),
        ],
      ),
    ).then((_) {
      // Allow scanning again after the dialog is closed
      setState(() {
        _isScanning = true;
      });
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ).then((_) {
      // Allow scanning again after the dialog is closed
      setState(() {
        _isScanning = true;
      });
    });
  }
}