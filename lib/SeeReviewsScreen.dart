import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Product.dart';
import 'MyOrder/ReviewScreens.dart'; // Corrected path to where your ReviewScreens is located

class SeeReviewsScreen extends StatelessWidget {
  final Product product;
  const SeeReviewsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final reviewsStream = Supabase.instance.client
        .from('reviews')
        .stream(primaryKey: ['id'])
        .eq('product_id', product.id)
        .order('created_at', ascending: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Community Reviews',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      // FIXED: Changed onTap to onPressed
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF18181A),
        icon: const Icon(Iconsax.edit, color: Colors.white),
        label: const Text("Write a Review",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => Get.to(() => ReviewScreen(product: product)),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: reviewsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF5E1F)));
          }

          final reviews = snapshot.data ?? [];

          if (reviews.isEmpty) {
            return const Center(
              child: Text("No reviews yet.\nBe the first to review this!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
            );
          }

          // FIXED: Added curly braces for the 'for' loop warning
          double totalRating = 0;
          for (var r in reviews) {
            totalRating += r['rating'];
          }
          double averageRating = totalRating / reviews.length;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 48,
                          color: Color(0xFF18181A)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < averageRating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color(0xFFFF5E1F),
                          size: 24,
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text("Based on ${reviews.length} review(s)",
                        style: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const Divider(color: Color(0xFFF0F0F3)),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: reviews.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 40, color: Color(0xFFF0F0F3)),
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Color(0xFFF4F5F8),
                              child:
                                  Icon(Iconsax.user, color: Color(0xFF18181A)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(review['user_name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15)),
                                  Row(
                                    children: List.generate(5, (starIndex) {
                                      return Icon(
                                        starIndex < review['rating']
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: const Color(0xFFFF5E1F),
                                        size: 14,
                                      );
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          review['comment'],
                          style: const TextStyle(
                              color: Color(0xFF6E6E73), height: 1.5),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
