import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- YOUR APP IMPORTS ---
import 'package:trandtribe/Widgets/BottomNavBar.dart'; // Standard Customer App
import 'package:trandtribe/Admin/AdminDashboard.dart'; // Premium Admin Center

class RoleGateway extends StatefulWidget {
  const RoleGateway({super.key});

  @override
  State<RoleGateway> createState() => _RoleGatewayState();
}

class _RoleGatewayState extends State<RoleGateway> {
  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final user = Supabase.instance.client.auth.currentUser;

    // If somehow no user is found, send them to the regular app
    if (user == null || user.email == null) {
      Get.offAll(() => const BottomNavBar());
      return;
    }

    try {
      // 1. Fetch the user's role from the database
      final response = await Supabase.instance.client
          .from('user_roles')
          .select('role')
          .eq('email', user.email!)
          .maybeSingle();

      // 2. Default to 'user' if they aren't in the table
      String role = response != null ? response['role'] : 'user';

      print("🟢 LOGIN SUCCESS: ${user.email} is logging in as: $role");

      // 3. ROUTE TO COMPLETELY DIFFERENT APPS BASED ON ROLE
      if (role == 'admin') {
        Get.offAll(() => const AdminDashboard(), transition: Transition.fadeIn);
      } else if (role == 'delivery') {
        // We will build the Delivery Dashboard next!
        Get.snackbar("Notice", "Delivery Dashboard coming soon!",
            backgroundColor: const Color(0xFF18181A), colorText: Colors.white);
        Get.offAll(() => const BottomNavBar(), transition: Transition.fadeIn);
      } else {
        // Regular User -> Standard App
        Get.offAll(() => const BottomNavBar(), transition: Transition.fadeIn);
      }
    } catch (e) {
      print("🔴 ROLE GATEWAY ERROR: $e"); // Check your terminal if it fails!
      // Fallback to User App if database fails to connect
      Get.offAll(() => const BottomNavBar(), transition: Transition.fadeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF18181A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFFF5E1F)),
            SizedBox(height: 24),
            Text("Authenticating Workspace...",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2)),
          ],
        ),
      ),
    );
  }
}
