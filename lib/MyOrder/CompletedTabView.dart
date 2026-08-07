import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trandtribe/Card/CompletedCard.dart';
import 'package:trandtribe/Product.dart';

class CompletedTabView extends StatelessWidget {
  const CompletedTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch a few products from the database to act as our "Completed Orders"
    // so you can test the Review functionality dynamically!
    final completedOrdersFuture = Supabase.instance.client
        .from('products')
        .select()
        .limit(4); // Fetching 4 products as mock completed orders

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: completedOrdersFuture,
      builder: (context, snapshot) {
        // 1. Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }

        // 2. Error State
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        // 3. Empty State
        final data = snapshot.data ?? [];
        if (data.isEmpty) {
          return const Center(
            child: Text(
              "You have no completed orders yet.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        // 4. Success State - Render the dynamic CompletedCards
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: data.map((item) {
                // Convert Supabase database row into our Product model
                final product = Product.fromMap(item);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  // PASS THE DYNAMIC PRODUCT INTO THE CARD HERE
                  child: CompletedCard(product: product),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
