import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trandtribe/Card/WishListCard.dart';
import 'package:trandtribe/Product.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  // Fetch Wishlist joined with Products table
  final _wishlistFuture = Supabase.instance.client
      .from('wishlist')
      .select('id, product_id, products(*)');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: const Text(
          "My Wishlist",
          style: TextStyle(
              fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: -0.5),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _wishlistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF5E1F)));
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final wishlistItems = snapshot.data ?? [];

          if (wishlistItems.isEmpty) {
            return const Center(
              child: Text(
                "Your wishlist is empty.",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: wishlistItems.length,
            itemBuilder: (context, index) {
              final item = wishlistItems[index];
              // Convert the joined product data back into our Product model
              final product = Product.fromMap(item['products']);

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: WishListCard(
                  wishlistId: item['id'],
                  product: product,
                  onDelete: () {
                    setState(() {
                      wishlistItems.removeAt(index);
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
