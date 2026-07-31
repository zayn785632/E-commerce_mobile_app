import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trandtribe/MyOrder/CompletedTabView.dart';
import 'package:trandtribe/MyOrder/OnGoingTabView.dart';

class MyOrderScreens extends StatelessWidget {
  const MyOrderScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          forceMaterialTransparency: false,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            "My Orders",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Iconsax.more,
                size: 25,
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Ongoing'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: const Expanded(
            child: TabBarView(
              children: [
                // Content for the "Ongoing" tab
                OnGoingTabView(),
                // Content for the "Completed" tab
                CompletedTabView(),
              ],
            ),
          ),
       
      ),
    );
  }
}
