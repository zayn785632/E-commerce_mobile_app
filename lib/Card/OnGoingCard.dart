import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trandtribe/MyOrder/TrackOrderScreen.dart';
import 'package:trandtribe/Product.dart';

class OngoingCard extends StatelessWidget {
  final Product product;
  final String size;
  final int quantity;
  final String status;

  const OngoingCard(
      {super.key,
      required this.product,
      required this.size,
      required this.quantity,
      required this.status});

  @override
  Widget build(BuildContext context) {
    String imageUrl = product.images.isNotEmpty ? product.images[0] : "";

    return Container(
      height: 130,
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
                  const SizedBox(height: 8),
                  // Dynamic Live Status Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFF5E1F).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(status.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFF5E1F),
                            letterSpacing: 0.5)),
                  ),
                  const Spacer(),
                  Text("EUR ${(product.price * quantity).toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 16)),
                ],
              ),
            ),
            InkWell(
              onTap: () => Get.to(() => const TrackOrderScreen(),
                  transition: Transition.rightToLeftWithFade),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 38,
                width: 100,
                decoration: BoxDecoration(
                    color: const Color(0xFF18181A),
                    borderRadius: BorderRadius.circular(12)),
                child: const Center(
                    child: Text("Track Order",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
