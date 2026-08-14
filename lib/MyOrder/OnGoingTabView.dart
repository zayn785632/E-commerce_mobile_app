import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trandtribe/Product.dart';
import '../Card/OnGoingCard.dart';

class OnGoingTabView extends StatelessWidget {
  const OnGoingTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Real SQL Join: Get items from orders that are Processing or Shipped
    final ongoingFuture = Supabase.instance.client
        .from('order_items')
        .select('*, orders!inner(status), products(*)')
        .inFilter('orders.status', ['Processing', 'Shipped']).order('id',
            ascending: false);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ongoingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF5E1F)));
        }

        final data = snapshot.data ?? [];
        if (data.isEmpty) {
          return const Center(
              child: Text("You have no ongoing orders.",
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
                  child: OngoingCard(
                    product: Product.fromMap(item['products']),
                    size: item['size'],
                    quantity: item['quantity'],
                    status: item['orders']
                        ['status'], // "Processing" or "Shipped"
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
