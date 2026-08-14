import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trandtribe/SeeReviewsScreen.dart';
import 'package:trandtribe/Widgets/SizeSelectionWidget.dart';
import 'package:trandtribe/Product.dart';
import 'package:trandtribe/Widgets/Price&addcart.dart';
import 'package:trandtribe/Widgets/QuantityWidget.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int currentImage = 0;
  bool isFavorite = false;
  bool isChecking = true;

  // Track the user's cart selections!
  String selectedSize = 'M';
  int selectedQuantity = 1;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final response = await Supabase.instance.client
        .from('wishlist')
        .select('id')
        .eq('product_id', widget.product.id)
        .maybeSingle();

    if (mounted) {
      setState(() {
        isFavorite = response != null;
        isChecking = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() => isFavorite = !isFavorite);
    try {
      if (isFavorite) {
        await Supabase.instance.client
            .from('wishlist')
            .insert({'product_id': widget.product.id});
      } else {
        await Supabase.instance.client
            .from('wishlist')
            .delete()
            .eq('product_id', widget.product.id);
      }
    } catch (e) {
      setState(() => isFavorite = !isFavorite);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text("Details",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: isChecking
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: _toggleFavorite,
                    icon: Icon(
                      isFavorite ? Iconsax.heart5 : Iconsax.heart,
                      color: isFavorite
                          ? const Color(0xFFFF5E1F)
                          : const Color(0xFF18181A),
                      size: 26,
                    ),
                  ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.50,
                    width: double.infinity,
                    child: PageView.builder(
                      itemCount: widget.product.images.length,
                      onPageChanged: (value) =>
                          setState(() => currentImage = value),
                      itemBuilder: (context, index) {
                        return Container(
                          color: const Color(0xFFF6F6F9),
                          child: Image.network(widget.product.images[index],
                              fit: BoxFit.cover),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.product.images.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: currentImage == index ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: currentImage == index
                              ? const Color(0xFFFF5E1F)
                              : const Color(0xFFE8ECEF),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product.name,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF18181A),
                                height: 1.2)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Iconsax.star1,
                                color: Color(0xFFFF5E1F), size: 18),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () => Get.to(() =>
                                  SeeReviewsScreen(product: widget.product)),
                              child: const Text(
                                "Read & Write Reviews",
                                style: TextStyle(
                                    color: Color(0xFF18181A),
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(widget.product.description,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF6E6E73),
                                height: 1.6)),
                        const SizedBox(height: 30),
                        const Text("SELECT SIZE",
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.grey)),
                        const SizedBox(height: 12),
                        // Listen for size changes
                        SizeSelectionWidget(
                            onSizeSelected: (size) =>
                                setState(() => selectedSize = size)),
                        const SizedBox(height: 30),
                        const Text("QUANTITY",
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.grey)),
                        const SizedBox(height: 12),
                        // Listen for quantity changes
                        QuantityWidget(
                            onQuantityChanged: (qty) =>
                                setState(() => selectedQuantity = qty)),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Pass the dynamic selections to the button
          PriceAddCart(
              product: widget.product,
              selectedSize: selectedSize,
              selectedQuantity: selectedQuantity),
        ],
      ),
    );
  }
}
