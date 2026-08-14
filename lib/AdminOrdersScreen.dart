import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  // Listen to live updates from the orders table!
  final _ordersStream = Supabase.instance.client
      .from('orders')
      .stream(primaryKey: ['id']).order('created_at', ascending: false);

  // Function to open the Status Manager Bottom Sheet
  void _manageOrderStatus(int orderId, String currentStatus) {
    final statuses = ['Processing', 'Shipped', 'Delivered'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                        color: const Color(0xFFE8ECEF),
                        borderRadius: BorderRadius.circular(10))),
                const SizedBox(height: 24),
                Text("Update Order #$orderId",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF18181A))),
                const SizedBox(height: 8),
                const Text("Select the new shipping status below.",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600)),
                const SizedBox(height: 24),
                ...statuses.map((status) {
                  bool isCurrent = currentStatus == status;
                  return GestureDetector(
                    onTap: () async {
                      Navigator.pop(context); // Close sheet
                      // --- UPDATE DATABASE ---
                      await Supabase.instance.client
                          .from('orders')
                          .update({'status': status}).eq('id', orderId);
                      Get.snackbar("Order Updated",
                          "Order #$orderId is now marked as $status.",
                          backgroundColor: const Color(0xFF18181A),
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? const Color(0xFF18181A)
                            : const Color(0xFFF4F5F8),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4))
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(status,
                              style: TextStyle(
                                  color: isCurrent
                                      ? Colors.white
                                      : const Color(0xFF18181A),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16)),
                          if (isCurrent)
                            const Icon(Icons.check_circle,
                                color: Color(0xFFFF5E1F), size: 20),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper to color-code the status badges
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Processing':
        return const Color(0xFFFF5E1F);
      case 'Shipped':
        return const Color(0xFF007AFF);
      case 'Delivered':
        return const Color(0xFF34C759);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FB),
        scrolledUnderElevation: 0,
        centerTitle: true,
        // FIXED THE TYPO HERE: Changed onTap to onPressed
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: Color(0xFF18181A)),
          onPressed: () => Get.back(),
        ),
        title: const Text("Admin Dashboard",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                color: Color(0xFF18181A),
                letterSpacing: -0.5)),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _ordersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF5E1F)));
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(
                child: Text("No orders found.",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)));
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderId = order['id'];
              final total = order['total_amount'];
              final status = order['status'];
              // Simple date format without extra packages
              final date = DateTime.parse(order['created_at'])
                  .toString()
                  .substring(0, 10);
              final statusColor = _getStatusColor(status);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF0F0F3)),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF0F1117).withOpacity(0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Order #$orderId",
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: Color(0xFF18181A))),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(status.toUpperCase(),
                              style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Iconsax.calendar_1,
                            size: 16, color: Color(0xFF8E8E93)),
                        const SizedBox(width: 6),
                        Text("Placed on $date",
                            style: const TextStyle(
                                color: Color(0xFF6E6E73),
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(
                          color: Color(0xFFF0F0F3), height: 1, thickness: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Total Amount",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF8E8E93),
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text("EUR ${total.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    color: Color(0xFF18181A))),
                          ],
                        ),
                        // The Admin Manage Button
                        GestureDetector(
                          onTap: () => _manageOrderStatus(orderId, status),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                                color: const Color(0xFF18181A),
                                borderRadius: BorderRadius.circular(12)),
                            child: const Row(
                              children: [
                                Text("Manage",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800)),
                                SizedBox(width: 6),
                                Icon(Iconsax.edit,
                                    color: Colors.white, size: 14),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
