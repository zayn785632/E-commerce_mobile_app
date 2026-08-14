import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trandtribe/MyOrder/CompletedTabView.dart';
import 'package:trandtribe/MyOrder/OnGoingTabView.dart';
import 'package:trandtribe/Widgets/BottomNavBar.dart'; // Ensure this path is correct!

class MyOrderScreens extends StatelessWidget {
  const MyOrderScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9FB),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF9F9FB),
          forceMaterialTransparency: false,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left_2, color: Color(0xFF18181A)),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "My Orders",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: Color(0xFF18181A),
                letterSpacing: -0.5),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Iconsax.more, size: 25, color: Color(0xFF18181A)),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Color(0xFFFF5E1F),
            labelColor: Color(0xFFFF5E1F),
            unselectedLabelColor: Color(0xFF8E8E93),
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            unselectedLabelStyle:
                TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            dividerColor: Color(0xFFE8ECEF),
            tabs: [
              Tab(text: 'Ongoing'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        // --- THE FIX: REMOVED THE 'EXPANDED' WIDGET HERE ---
        body: const TabBarView(
          children: [
            OnGoingTabView(),
            CompletedTabView(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, -5))
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: 3,
            selectedItemColor: const Color(0xFFFF5E1F),
            unselectedItemColor: const Color(0xFF8E8E93),
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            onTap: (index) {
              Get.offAll(() => const BottomNavBar(),
                  transition: Transition.fadeIn);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Iconsax.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Iconsax.heart), label: "Saved"),
              BottomNavigationBarItem(
                  icon: Icon(Iconsax.shopping_cart), label: "Cart"),
              BottomNavigationBarItem(
                  icon: Icon(Iconsax.user), label: "Profile"),
            ],
          ),
        ),
      ),
    );
  }
}
