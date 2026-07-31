import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trandtribe/Widgets/SearchField.dart';

import '../Widgets/CategoriesTabBar.dart';
import '../Widgets/AdminCategoryScreen.dart'; // <-- Added Admin Screen Import

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
        title: const Text(
          'Discover',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
        actions: [
          // Admin Panel Navigation Button
          IconButton(
            tooltip: 'Admin Area',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminCategoryScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.admin_panel_settings_outlined,
              color: Colors.black,
              size: 26,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Iconsax.notification_bing),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: SearchField(
                    controller: searchController,
                    text: "Search Here",
                    textInputType: TextInputType.text,
                    obscure: false,
                    prefixIcon: const Icon(Iconsax.search_normal_1),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Iconsax.sort,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: CategoriesTabBar(),
          ),
        ],
      ),
    );
  }
}
