import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trandtribe/MyOrder/ReviewScreens.dart';
import 'package:trandtribe/Product.dart'; // Make sure to import your Product model!

class CompletedCard extends StatelessWidget {
  final Product product; // 1. Require a Product object for this card

  const CompletedCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    // Safely get the first image from the product
    String imageUrl = product.images.isNotEmpty ? product.images[0] : "";

    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 3)),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 100,
              width: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF6F6F9), // Placeholder color
                // 2. Load the image dynamically from Supabase
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name, // 3. Dynamic Product Name
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Quantity: 1",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(
                    "Size: M",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const Spacer(),
                  Text(
                    "EUR ${product.price.toStringAsFixed(2)}", // 4. Dynamic Price
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                // 5. THE FIX: Pass the dynamic product straight to the Review Screen!
                Get.to(() => ReviewScreen(product: product));
              },
              child: Container(
                height: 35,
                width: 95,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8)),
                child: const Center(
                  child: Text(
                    "Review",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
