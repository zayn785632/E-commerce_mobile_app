import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Product.dart';

class WishListCard extends StatelessWidget {
  final int wishlistId;
  final Product product;
  final VoidCallback onDelete;

  const WishListCard({
    super.key,
    required this.wishlistId,
    required this.product,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    String imageUrl = product.images.isNotEmpty ? product.images[0] : "";

    return Dismissible(
      key: ValueKey(wishlistId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        // Delete from Database dynamically
        await Supabase.instance.client
            .from('wishlist')
            .delete()
            .eq('id', wishlistId);
        onDelete();
      },
      background: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFF5E1F), // Orange swipe to delete
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: const Icon(Iconsax.trash, color: Colors.white, size: 28),
      ),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF0F0F3)),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF0F1117).withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 5)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F9),
                  borderRadius: BorderRadius.circular(12),
                  image: imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(imageUrl), fit: BoxFit.cover)
                      : null,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: Color(0xFF18181A)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.category.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(
                      "EUR ${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: Color(0xFF18181A)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
