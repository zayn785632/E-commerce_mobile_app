import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trandtribe/MyOrder/ReviewScreens.dart';
import 'package:trandtribe/Product.dart';

class CompletedCard extends StatelessWidget {
  final Product product;
  final String size;
  final int quantity;

  const CompletedCard(
      {super.key,
      required this.product,
      required this.size,
      required this.quantity});

  @override
  Widget build(BuildContext context) {
    String imageUrl = product.images.isNotEmpty ? product.images[0] : "";

    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0F0F3)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 5))
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: double.infinity,
              width: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF6F6F9),
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl), fit: BoxFit.cover)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text("Qty: $quantity",
                          style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(width: 10),
                      Text("Size: $size",
                          style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const Spacer(),
                  Text("EUR ${(product.price * quantity).toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 16)),
                ],
              ),
            ),
            InkWell(
              onTap: () => Get.to(() => ReviewScreen(product: product),
                  transition: Transition.downToUp),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 38,
                width: 95,
                decoration: BoxDecoration(
                    color: const Color(0xFF18181A),
                    borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.edit, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text("Review",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
