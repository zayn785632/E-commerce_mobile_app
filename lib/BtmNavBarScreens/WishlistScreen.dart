import 'package:flutter/material.dart';
import 'package:trandtribe/Card/WishListCard.dart';

import 'package:trandtribe/MyProducts.dart';
import 'package:trandtribe/Product.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Product> allProducts = MyProducts.getAllProducts();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        scrolledUnderElevation: 0,
        title: const Text(
          "My Wishlist",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        // actions: const [
        //   Padding(
        //     padding: EdgeInsets.only(right: 20),
        //     child: Icon(Iconsax.notification_bing),
        //   )
        // ],
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              WishListCard(),
              SizedBox(
                height: 15,
              ),
              WishListCard(),
            ],
          ),
        ),
      ),
    );
  }
}
