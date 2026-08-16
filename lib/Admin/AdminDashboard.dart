import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- YOUR APP IMPORTS ---
import 'package:trandtribe/SignIn&UpScreen/SignIn.dart';
import 'package:trandtribe/AdminOrdersScreen.dart';
import 'package:trandtribe/Widgets/AdminCategoryScreen.dart';
import 'package:trandtribe/Admin/ManageDeliveryScreen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Future<void> _adminSignOut() async {
    await Supabase.instance.client.auth.signOut();
    Get.offAll(() => const SignIn(), transition: Transition.fadeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FB),
        scrolledUnderElevation: 0,
        centerTitle: false,
        automaticallyImplyLeading:
            false, // Prevents back arrow since this is a root screen
        title: const Text("Command Center",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 26,
                color: Color(0xFF18181A),
                letterSpacing: -0.5)),
        actions: [
          IconButton(
            onPressed: _adminSignOut,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: const Color(0xFFFF4B4B).withOpacity(0.1),
                  shape: BoxShape.circle),
              child: const Icon(Iconsax.logout,
                  color: Color(0xFFFF4B4B), size: 20),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome back, Boss.",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF8E8E93),
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 30),

            // --- STAGGERED GRID DASHBOARD ---
            Expanded(
              child: GridView.count(
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  _buildAnimatedAdminCard(
                      delay: 100,
                      title: "Live\nOrders",
                      icon: Iconsax.box,
                      accentColor: const Color(0xFFFF5E1F),
                      onTap: () => Get.to(() => const AdminOrdersScreen(),
                          transition: Transition.zoom)),
                  _buildAnimatedAdminCard(
                      delay: 200,
                      title: "Manage\nCatalog",
                      icon: Iconsax.category,
                      accentColor: const Color(0xFF007AFF),
                      onTap: () => Get.to(() => const AdminCategoryScreen(),
                          transition: Transition.zoom)),
                  _buildAnimatedAdminCard(
                      delay: 300,
                      title: "Delivery\nTeam",
                      icon: Iconsax.truck_fast,
                      accentColor: const Color(0xFF34C759),
                      onTap: () => Get.to(() => const ManageDeliveryScreen(),
                          transition: Transition.zoom)),
                  _buildAnimatedAdminCard(
                      delay: 400,
                      title: "Store\nSettings",
                      icon: Iconsax.setting_2,
                      accentColor: const Color(0xFF8E8E93),
                      onTap: () {
                        Get.snackbar(
                            "Settings", "Store configuration coming soon.",
                            backgroundColor: const Color(0xFF18181A),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP);
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- REUSABLE ANIMATED GRID CARD ---
  Widget _buildAnimatedAdminCard(
      {required int delay,
      required String title,
      required IconData icon,
      required Color accentColor,
      required VoidCallback onTap}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border:
                      Border.all(color: const Color(0xFFF0F0F3), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF0F1117).withOpacity(0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 10))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16)),
                      child: Icon(icon, color: accentColor, size: 24),
                    ),
                    const Spacer(),
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Color(0xFF18181A),
                            height: 1.2,
                            letterSpacing: -0.5)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
