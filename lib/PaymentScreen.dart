import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trandtribe/MyOrder/MyOrderScreen.dart';

class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double grandTotal;
  final double subTotal;
  final double shippingFee;

  const PaymentScreen({
    super.key,
    required this.cartItems,
    required this.grandTotal,
    required this.subTotal,
    required this.shippingFee,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'Credit Card';

  // The actual checkout transaction logic
  void _processCheckout() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) => _PaymentBottomSheet(
        total: widget.grandTotal,
        paymentMethod: selectedPaymentMethod,
        onComplete: () async {
          try {
            // 1. Create the Master Order
            final orderResponse = await Supabase.instance.client
                .from('orders')
                .insert({
                  'total_amount': widget.grandTotal,
                  'status': 'Processing',
                })
                .select('id')
                .single();

            final int newOrderId = orderResponse['id'];

            // 2. Transfer Cart Items to Order Items
            for (var item in widget.cartItems) {
              await Supabase.instance.client.from('order_items').insert({
                'order_id': newOrderId,
                'product_id': item['products']['id'],
                'size': item['size'],
                'quantity': item['quantity'],
                'price': item['products']['price'],
              });
              // 3. Clear the item from the Cart
              await Supabase.instance.client
                  .from('cart')
                  .delete()
                  .eq('id', item['id']);
            }

            // 4. Navigate to Orders Screen
            Get.offAll(() => const MyOrderScreens(),
                transition: Transition.zoom);
            Get.snackbar("Order Confirmed!",
                "Your order #$newOrderId is now processing via $selectedPaymentMethod.",
                backgroundColor: Colors.green,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP);
          } catch (e) {
            Get.back();
            Get.snackbar("Error", "Checkout failed. Please try again.",
                backgroundColor: Colors.redAccent, colorText: Colors.white);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FB),
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text("Checkout",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: Color(0xFF18181A))),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Payment Method",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF18181A))),
                  const SizedBox(height: 16),

                  // Animated Payment Options
                  _buildPaymentOption(
                      title: "Credit / Debit Card",
                      subtitle: "Visa, Mastercard, AMEX",
                      icon: Iconsax.card,
                      methodId: "Credit Card"),
                  const SizedBox(height: 12),
                  _buildPaymentOption(
                      title: "Apple Pay",
                      subtitle: "Fast & Secure",
                      icon: Icons.apple,
                      methodId: "Apple Pay"),
                  const SizedBox(height: 12),
                  _buildPaymentOption(
                      title: "PayPal",
                      subtitle: "Pay with your PayPal balance",
                      icon: Icons.paypal,
                      methodId: "PayPal"),
                  const SizedBox(height: 12),
                  _buildPaymentOption(
                      title: "Cash on Delivery",
                      subtitle: "Pay when you receive the package",
                      icon: Iconsax.money_send,
                      methodId: "Cash on Delivery"),

                  const SizedBox(height: 40),
                  const Text("Order Summary",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF18181A))),
                  const SizedBox(height: 16),

                  // Order Summary Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF0F0F3)),
                      boxShadow: [
                        BoxShadow(
                            color:
                                const Color(0xFF0F1117).withValues(alpha: 0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 5))
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Items",
                                  style: TextStyle(
                                      color: Color(0xFF8E8E93),
                                      fontWeight: FontWeight.w600)),
                              Text("${widget.cartItems.length}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800))
                            ]),
                        const SizedBox(height: 12),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Subtotal",
                                  style: TextStyle(
                                      color: Color(0xFF8E8E93),
                                      fontWeight: FontWeight.w600)),
                              Text("EUR ${widget.subTotal.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800))
                            ]),
                        const SizedBox(height: 12),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Shipping",
                                  style: TextStyle(
                                      color: Color(0xFF8E8E93),
                                      fontWeight: FontWeight.w600)),
                              Text(
                                  "EUR ${widget.shippingFee.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800))
                            ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Bottom Action Bar
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF0F1117).withValues(alpha: 0.08),
                    blurRadius: 30,
                    offset: const Offset(0, -10))
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Total Payment",
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8E8E93),
                              fontWeight: FontWeight.w700)),
                      Text("EUR ${widget.grandTotal.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFF5E1F))),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _processCheckout,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF18181A),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF18181A)
                                  .withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8))
                        ],
                      ),
                      child: const Center(
                        child: Text("Pay Now",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Interactive Payment Option Card
  Widget _buildPaymentOption(
      {required String title,
      required String subtitle,
      required IconData icon,
      required String methodId}) {
    bool isSelected = selectedPaymentMethod == methodId;

    return GestureDetector(
      onTap: () => setState(() => selectedPaymentMethod = methodId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF5E1F).withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isSelected
                  ? const Color(0xFFFF5E1F)
                  : const Color(0xFFF0F0F3),
              width: 2),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                      color: const Color(0xFF0F1117).withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFF5E1F)
                    : const Color(0xFFF4F5F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: isSelected ? Colors.white : const Color(0xFF18181A),
                  size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFF5E1F)
                        : Colors.grey.shade300,
                    width: isSelected ? 7 : 2),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Payment Processing Bottom Sheet Simulator
class _PaymentBottomSheet extends StatefulWidget {
  final double total;
  final String paymentMethod;
  final VoidCallback onComplete;
  const _PaymentBottomSheet(
      {required this.total,
      required this.paymentMethod,
      required this.onComplete});

  @override
  State<_PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<_PaymentBottomSheet> {
  bool isProcessing = true;

  @override
  void initState() {
    super.initState();
    _simulateGateway();
  }

  void _simulateGateway() async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate Bank API delay
    if (mounted) setState(() => isProcessing = false);
    await Future.delayed(
        const Duration(milliseconds: 1500)); // Show success tick
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.2), blurRadius: 40)
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: isProcessing
                ? const CircularProgressIndicator(
                    key: ValueKey(1), color: Color(0xFFFF5E1F), strokeWidth: 3)
                : const Icon(Icons.check_circle_rounded,
                    key: ValueKey(2), color: Colors.green, size: 60),
          ),
          const SizedBox(height: 24),
          Text(isProcessing ? "Processing Payment..." : "Payment Successful",
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(
              isProcessing
                  ? "Connecting securely via ${widget.paymentMethod}."
                  : "EUR ${widget.total.toStringAsFixed(2)} paid successfully.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  height: 1.4)),
        ],
      ),
    );
  }
}
