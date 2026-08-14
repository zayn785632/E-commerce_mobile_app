import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trandtribe/BtmNavBarScreens/MyCartScreen.dart';
import 'package:trandtribe/Product.dart';

class PriceAddCart extends StatefulWidget {
  final Product product;
  final String selectedSize;
  final int selectedQuantity;

  const PriceAddCart({
    super.key,
    required this.product,
    required this.selectedSize,
    required this.selectedQuantity,
  });

  @override
  State<PriceAddCart> createState() => _PriceAddCartState();
}

class _PriceAddCartState extends State<PriceAddCart> {
  bool isAdding = false;

  Future<void> _addToCart() async {
    setState(() => isAdding = true);
    try {
      await Supabase.instance.client.from('cart').insert({
        'product_id': widget.product.id,
        'size': widget.selectedSize,
        'quantity': widget.selectedQuantity,
      });

      Get.snackbar(
        "Added to Bag",
        "${widget.selectedQuantity}x ${widget.product.name} (Size: ${widget.selectedSize})",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF18181A),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        mainButton: TextButton(
          onPressed: () => Get.to(() => const MyCartScreen()),
          child: const Text("VIEW CART",
              style: TextStyle(color: Color(0xFFFF5E1F))),
        ),
      );
    } catch (e) {
      Get.snackbar("Error", "Could not add to cart.");
    } finally {
      setState(() => isAdding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, -5))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("TOTAL PRICE",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey,
                        letterSpacing: 1.0)),
                const SizedBox(height: 4),
                Text(
                  'EUR ${(widget.product.price * widget.selectedQuantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF18181A),
                      letterSpacing: -0.5),
                ),
              ],
            ),
            GestureDetector(
              onTap: isAdding ? null : _addToCart,
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFF18181A),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF18181A).withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 5))
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isAdding
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Color(0xFFFF5E1F), strokeWidth: 2))
                        : const Icon(Iconsax.bag_2,
                            color: Color(0xFFFF5E1F), size: 20),
                    const SizedBox(width: 10),
                    const Text("Add to Cart",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
