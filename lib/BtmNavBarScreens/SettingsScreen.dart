import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trandtribe/MyOrder/MyOrderScreen.dart';
import 'package:trandtribe/ShippingAddress.dart';
import 'package:trandtribe/SignIn&UpScreen/SignIn.dart';
import 'package:trandtribe/Widgets/SettingsElements.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 1. Create variables to hold the dynamic data
  String userName = "Loading...";
  String userEmail = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 2. Fetch the current logged-in user from Supabase
  void _loadUserData() {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      setState(() {
        // Read the email and the custom full_name metadata we saved during signup
        userEmail = user.email ?? "No email linked";
        userName = user.userMetadata?['full_name'] ?? "TrendTribe Shopper";
      });
    }
  }

  // 3. Create the Sign Out function
  Future<void> _signOut() async {
    await Supabase.instance.client.auth.signOut();
    // Get.offAll removes all previous screens so they can't press "back" to enter the app
    Get.offAll(() => const SignIn());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: false,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: AssetImage(
                              "assets/images/userprofile.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      // 4. Inject the dynamic variables into the UI
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              overflow: TextOverflow
                                  .ellipsis, // Prevents overflow if name is long
                            ),
                            Text(
                              userEmail,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SettingsElements(
                          title: "My Profile",
                          icon: IconsaxBold.user,
                          onTap: () {}),
                      const SizedBox(
                        height: 10,
                      ),
                      SettingsElements(
                          title: "My Orders",
                          icon: IconsaxBold.menu_board,
                          onTap: () {
                            Get.to(() => const MyOrderScreens());
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      SettingsElements(
                        title: "Shipping Address",
                        icon: IconsaxBold.truck,
                        onTap: () {
                          Get.to(() => const ShippingAddressScreen());
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SettingsElements(
                          title: "Payment Method",
                          icon: IconsaxBold.card,
                          onTap: () {}),
                      const SizedBox(
                        height: 10,
                      ),
                      SettingsElements(
                          title: 'Settings',
                          icon: IconsaxBold.setting_2,
                          onTap: () {}),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SettingsElements(
                        onTap: () {},
                        title: 'Help Center',
                        icon: IconsaxBold.call_calling,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SettingsElements(
                          title: 'Privacy & Policy',
                          icon: IconsaxBold.lock,
                          onTap: () {}),
                      const SizedBox(
                        height: 10,
                      ),
                      // 5. Connect the Sign Out button to our dynamic function
                      SettingsElements(
                        title: 'Sign Out',
                        icon: IconsaxBold.logout,
                        onTap: _signOut,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
