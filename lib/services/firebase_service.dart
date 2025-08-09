// lib/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class FirebaseService {
  // Get a reference to the 'products' collection in Firestore
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');

  // This function takes a product ID (from the scanner) and returns the Product
  Future<Product?> getProductById(String id) async {
    try {
      final DocumentSnapshot doc = await _productsCollection.doc(id).get();

      if (doc.exists) {
        // If the document exists, create a Product object from its data
        final data = doc.data() as Map<String, dynamic>;
        return Product.fromFirestore(data, doc.id);
      }
    } catch (e) {
      // If any error occurs (e.g., network issue), print it
      print('Error fetching product: $e');
    }
    // If the document doesn't exist or an error occurred, return null
    return null;
  }
}