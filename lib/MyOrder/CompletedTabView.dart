import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trandtribe/Card/CompletedCard.dart';
import 'package:trandtribe/Product.dart';

class CompletedTabView extends StatelessWidget {
  const CompletedTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Fetch only items from orders that are marked 'Delivered'
    final completedFuture = Supabase.instance.client
        .from('order_items')
        .select('*, orders!inner(status), products(*)')
        .eq('orders.status', 'Delivered')
        .order('id', ascending: false);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: completedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF5E1F)));
        }

        final data = snapshot.data ?? [];
        if (data.isEmpty) {
          return const Center(
              child: Text("You have no completed orders yet.",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w600)));
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: data.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CompletedCard(
                    product: Product.fromMap(item['products']),
                    size: item['size'],
                    quantity: item['quantity'],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
