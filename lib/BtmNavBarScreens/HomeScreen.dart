import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trandtribe/Widgets/SearchField.dart';
import '../Widgets/CategoriesTabBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: const Text(
          'Discover',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 32,
            letterSpacing: -0.5,
            color: Color(0xFF18181A),
          ),
        ),
        actions: const [
          // Only the notification bell remains for a clean shopper UI
          Padding(
            padding: EdgeInsets.only(right: 24),
            child: Icon(Iconsax.notification_bing,
                color: Color(0xFF18181A), size: 26),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: SearchField(
                    controller: searchController,
                    text: "Search Here",
                    textInputType: TextInputType.text,
                    obscure: false,
                    prefixIcon:
                        const Icon(Iconsax.search_normal_1, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF18181A),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF18181A).withOpacity(0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: const Icon(
                    Iconsax.sort,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Expanded(
            child: CategoriesTabBar(),
          ),
        ],
      ),
    );
  }
}
