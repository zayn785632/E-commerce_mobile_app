import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:trandtribe/MyOrder/MyOrderScreen.dart';
import 'package:trandtribe/ShippingAddress.dart';
import 'package:trandtribe/SignIn&UpScreen/SignIn.dart';
import 'package:trandtribe/AdminOrdersScreen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String userName = "Loading...";
  String userEmail = "Loading...";
  bool isAdmin = false; // <-- 1. ADMIN LOCK VARIABLE

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null && mounted) {
      setState(() {
        userEmail = user.email ?? "No email linked";
        userName = user.userMetadata?['full_name'] ?? "TrendTribe Shopper";

        // --- 2. ADMIN AUTHENTICATION LOGIC ---
        // Change 'mostafa@gmail.com' to whatever email you use to test the Admin side!
        if (userEmail.toLowerCase() == 'mostafa@gmail.com' ||
            userEmail.toLowerCase() == 'admin@trendtribe.com') {
          isAdmin = true;
        }
      });
    }
  }

  Future<void> _signOut() async {
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
        automaticallyImplyLeading: false,
        title: const Text("Profile",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 26,
                color: Color(0xFF18181A))),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // --- HEADER PROFILE CARD ---
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 10))
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8ECEF),
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                  image: AssetImage(
                                      "assets/images/userprofile.png"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(userName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                            color: Color(0xFF18181A))),
                                    // Shows a cool VIP badge if the user is an admin
                                    if (isAdmin) ...[
                                      const SizedBox(width: 8),
                                      const Icon(Icons.verified,
                                          color: Color(0xFFFF5E1F), size: 16)
                                    ]
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(userEmail,
                                    style: const TextStyle(
                                        color: Color(0xFF8E8E93),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // --- FIRST MENU GROUP ---
            _buildAnimatedGroup(
              delay: 100,
              children: [
                _buildListTile("My Profile", Iconsax.user, () {}),
                _buildListTile(
                    "My Orders",
                    Iconsax.note_text,
                    () => Get.to(() => const MyOrderScreens(),
                        transition: Transition.cupertino)),

                // --- 3. DYNAMIC ADMIN DASHBOARD ---
                // This button ONLY renders if isAdmin is true!
                if (isAdmin)
                  _buildListTile(
                      "Store Admin Dashboard",
                      Iconsax.security_user,
                      () => Get.to(() => const AdminOrdersScreen(),
                          transition: Transition.downToUp)),

                _buildListTile(
                    "Shipping Address",
                    Iconsax.truck_fast,
                    () => Get.to(() => const ShippingAddressScreen(),
                        transition: Transition.cupertino)),
                _buildListTile("Payment Method", Iconsax.card, () {}),
                _buildListTile("Settings", Iconsax.setting_2, () {},
                    isLast: true),
              ],
            ),
            const SizedBox(height: 24),

            // --- SECOND MENU GROUP ---
            _buildAnimatedGroup(
              delay: 200,
              children: [
                _buildListTile("Help Center", Iconsax.call_calling, () {}),
                _buildListTile("Privacy & Policy", Iconsax.lock, () {}),
                _buildListTile("Sign Out", Iconsax.logout, _signOut,
                    isLast: true, isDestructive: true),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedGroup(
      {required int delay, required List<Widget> children}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF0F0F3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 15,
                      offset: const Offset(0, 5))
                ],
              ),
              child: Column(children: children),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListTile(String title, IconData icon, VoidCallback onTap,
      {bool isLast = false, bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: isDestructive
                          ? const Color(0xFFFF4B4B).withOpacity(0.1)
                          : const Color(0xFFF4F5F8),
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon,
                      size: 20,
                      color: isDestructive
                          ? const Color(0xFFFF4B4B)
                          : const Color(0xFF18181A)),
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: isDestructive
                                ? const Color(0xFFFF4B4B)
                                : const Color(0xFF18181A)))),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: isDestructive
                        ? Colors.transparent
                        : const Color(0xFFC7C7CC)),
              ],
            ),
          ),
          if (!isLast)
            const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFF0F0F3),
                indent: 60,
                endIndent: 20),
        ],
      ),
    );
  }
}
