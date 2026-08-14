import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Ensure these imports match your project structure!
import 'package:trandtribe/Card/MyCartCard.dart';
import 'package:trandtribe/Product.dart';
import 'package:trandtribe/PaymentScreen.dart'; // Navigates to our new Payment Screen!

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCart();
  }

  // Fetch the cart items from Supabase
  Future<void> _fetchCart() async {
    try {
      final data = await Supabase.instance.client
          .from('cart')
          .select('id, size, quantity, products(*)');

      if (mounted) {
        setState(() {
          cartItems = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // Remove item locally when swiped (Database deletion happens inside MyCartCard)
  void _removeItem(int index) {
    setState(() => cartItems.removeAt(index));
  }

  // Update quantity locally when + / - is pressed
  void _updateQuantity(int index, int newQty) {
    setState(() => cartItems[index]['quantity'] = newQty);
  }

  // Update size locally when changed from bottom sheet
  void _updateSize(int index, String newSize) {
    setState(() => cartItems[index]['size'] = newSize);
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic Calculations
    double subTotal = 0.0;
    for (var item in cartItems) {
      subTotal += (item['products']['price'] * item['quantity']);
    }
    double shippingFee = cartItems.isNotEmpty ? 2.95 : 0.0;
    double grandTotal = subTotal + shippingFee;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF9F9FB), // Very subtle off-white for contrast
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FB),
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text("Your Bag",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                letterSpacing: -0.5,
                color: Color(0xFF18181A))),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF5E1F)))
          : Column(
              children: [
                Expanded(
                  child: cartItems.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10))
                                  ]),
                              child: const Icon(Iconsax.bag_cross_1,
                                  size: 60, color: Color(0xFFD1D1D6)),
                            ),
                            const SizedBox(height: 24),
                            const Text("Your bag is empty",
                                style: TextStyle(
                                    color: Color(0xFF18181A),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            const Text(
                                "Looks like you haven't added\nanything to your bag yet.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF8E8E93),
                                    fontSize: 15,
                                    height: 1.5)),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(24, 10, 24, 0),
                              child: Row(
                                children: [
                                  Icon(Iconsax.info_circle,
                                      size: 14, color: Color(0xFF8E8E93)),
                                  SizedBox(width: 8),
                                  Text("Swipe left on an item to remove it",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF8E8E93))),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.all(20),
                                physics: const BouncingScrollPhysics(),
                                itemCount: cartItems.length,
                                itemBuilder: (context, index) {
                                  final item = cartItems[index];
                                  final product =
                                      Product.fromMap(item['products']);

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: MyCartCard(
                                      cartId: item['id'],
                                      product: product,
                                      initialSize: item['size'],
                                      quantity: item['quantity'],
                                      onDelete: () => _removeItem(index),
                                      onQuantityUpdate: (newQty) =>
                                          _updateQuantity(index, newQty),
                                      onSizeUpdate: (newSize) =>
                                          _updateSize(index, newSize),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                ),

                // Premium Floating Receipt View (Only shows if cart has items)
                if (cartItems.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(32)),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFF0F1117).withOpacity(0.08),
                            blurRadius: 30,
                            offset: const Offset(0, -10))
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Subtotal",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF8E8E93),
                                      fontWeight: FontWeight.w600)),
                              Text("EUR ${subTotal.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF18181A),
                                      fontWeight: FontWeight.w800)),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Shipping",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF8E8E93),
                                      fontWeight: FontWeight.w600)),
                              Text("EUR ${shippingFee.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF18181A),
                                      fontWeight: FontWeight.w800)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Divider(
                                color: const Color(0xFFE8ECEF).withOpacity(0.5),
                                thickness: 1.5,
                                height: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text("Total",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF18181A),
                                      fontWeight: FontWeight.w800)),
                              Text("EUR ${grandTotal.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFFFF5E1F),
                                      letterSpacing: -0.5)),
                            ],
                          ),
                          const SizedBox(height: 28),

                          // --- NAVIGATE TO NEW PAYMENT SCREEN ---
                          GestureDetector(
                            onTap: () {
                              if (cartItems.isEmpty) return;

                              Get.to(
                                () => PaymentScreen(
                                  cartItems: cartItems,
                                  grandTotal: grandTotal,
                                  subTotal: subTotal,
                                  shippingFee: shippingFee,
                                ),
                                transition: Transition.rightToLeftWithFade,
                              );
                            },
                            child: Container(
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFF18181A),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0xFF18181A)
                                          .withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8))
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Proceed to Checkout",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5)),
                                  SizedBox(width: 8),
                                  Icon(Iconsax.arrow_right_1,
                                      color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
