// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:trandtribe/BtmNavBarScreens/MyCartScreen.dart';
// import 'package:trandtribe/BtmNavBarScreens/SettingsScreen.dart';

// import 'package:trandtribe/MyOrderScreen.dart';
// import 'package:trandtribe/ShippingAddress.dart';
// import 'package:trandtribe/SignIn&UpScreen/SignIn.dart';

// import 'package:trandtribe/Widgets/ProfileElements.dart';
// import 'package:trandtribe/Widgets/SettingsElements.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         forceMaterialTransparency: false,
//         automaticallyImplyLeading: false,
//         scrolledUnderElevation: 0,
//         // centerTitle: true,
//         actions: [IconButton(onPressed: (){}, icon: Icon(Iconsax.more))],
//         title: const Text(
//           "Profile",
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           child: Column(
//             children: [
//               Container(
//                 height: 90,
//                 width: 90,
//                 decoration: BoxDecoration(
//                     color: Colors.amber,
//                     borderRadius: BorderRadius.circular(150),
//                     image: const DecorationImage(
//                         image: AssetImage(
//                           "assets/images/userprofile.png",
//                         ),
//                         fit: BoxFit.fill)),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               const Text(
//                 "User Name",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const Text(
//                 "username007z@gmail.com",
//                 style: TextStyle(color: Colors.black54),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               ProfileElements(
//                 onTap: () {
                
//                 },
//                 title: 'My Account',
//                 icon: Iconsax.frame_1,
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               ProfileElements(
//                 onTap: () {
//                   Get.to(MyOrderScreens());
//                 },
//                 title: 'My Orders',
//                 icon: Iconsax.menu_board,
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//                ProfileElements(
//                 onTap: () {Get.to(ShippingAddressScreen());},
//                 title: 'Shipping Address',
//                 icon: Iconsax.truck_fast,
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               ProfileElements(
//                 onTap: () {},
//                 title: 'Payment Method',
//                 icon: Iconsax.card,
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
             
//               // ProfileElements(
//               //   onTap: () {
//               //     Get.to(MyCartScreen());
//               //   },
//               //   title: 'My Cart',
//               //   icon: Iconsax.shopping_cart,
//               // ),
//               // const SizedBox(
//               //   height: 5,
//               // ),
              
//               ProfileElements(
//                 onTap: () {Get.to(SettingsScreen());},
//                 title: 'Settings',
//                 icon: Iconsax.setting_2,
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               ProfileElements(
//                 onTap: () {},
//                 title: 'Help Center',
//                 icon: Iconsax.call_calling,
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               ProfileElements(
//                 onTap: () {},
//                 title: 'Privacy & Policy',
//                 icon: Iconsax.lock,
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               ProfileElements(
//                 onTap: () {
//                   Get.to(SignIn());
//                 },
//                 title: 'Sign Out',
//                 icon: Iconsax.logout,
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
