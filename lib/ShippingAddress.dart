import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trandtribe/AddAddressScreen.dart';
import 'package:trandtribe/Widgets/RoundedButton.dart';

import 'Card/AddressCard.dart';

class ShippingAddressScreen extends StatelessWidget {
  const ShippingAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: false,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Shipping Address',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        // actions: const [
        //   Padding(
        //     padding: EdgeInsets.only(right: 20),
        //     child: Icon(Iconsax.more),
        //   )
        // ],
      ),
      body: Column(
        children: [
          const Expanded(
              child: SingleChildScrollView(
                  child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                AddressCard(),
                SizedBox(
                  height: 15,
                ),
                AddressCard(),
              ],
            ),
          ))),

          // ignore: prefer_const_constructors

          Padding(
            padding: const EdgeInsets.all(20),
            child: RoundedButton(
                title: "Add Address",
                onTap: () {
                  Get.to(const AddAddressScreen());
                },
                width: double.infinity),
          )
        ],
      ),
    );
  }
}
