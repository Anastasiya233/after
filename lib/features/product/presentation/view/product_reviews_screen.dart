import 'package:flutter/material.dart';

class ProductReviewsScreen extends StatefulWidget {
  const ProductReviewsScreen({super.key});

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ProductReviewsScreen')),
      body: const Center(child: Text('Отзывы товара')),
    );
  }
}