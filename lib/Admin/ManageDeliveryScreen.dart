import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // NEW IMPORT

class ManageDeliveryScreen extends StatefulWidget {
  const ManageDeliveryScreen({super.key});
  @override
  State<ManageDeliveryScreen> createState() => _ManageDeliveryScreenState();
}

class _ManageDeliveryScreenState extends State<ManageDeliveryScreen> {
  final _emailCtrl = TextEditingController();
  final _stream = Supabase.instance.client
      .from('user_roles')
      .stream(primaryKey: ['id']).eq('role', 'delivery');
  bool isAdding = false;

  Future<void> _addDeliveryRider() async {
    final riderEmail = _emailCtrl.text.trim().toLowerCase();
    if (riderEmail.isEmpty) return;

    setState(() => isAdding = true);

    try {
      // 1. Add to Supabase
      await Supabase.instance.client.from('user_roles').insert({
        'email': riderEmail,
        'role': 'delivery',
      });

      _emailCtrl.clear();
      Get.snackbar("Success", "Delivery rider added to database!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);

      // 2. Launch Automated Email Invite
      final String subject = Uri.encodeComponent(
          "You're invited to the TrendTribe Delivery Team! 🚚");
      final String body = Uri.encodeComponent("Hello!\n\n"
          "You have been officially added as a Delivery Rider for TrendTribe.\n\n"
          "To get started, please download the TrendTribe app and Sign Up using this exact email address ($riderEmail).\n\n"
          "Because you are registered in our system, the app will automatically log you into your dedicated Delivery Dashboard once your account is created.\n\n"
          "Welcome to the team!\n"
          "- TrendTribe Admin");

      final Uri emailLaunchUri =
          Uri.parse("mailto:$riderEmail?subject=$subject&body=$body");

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        Get.snackbar("Notice",
            "Could not open your mail app, but the rider was successfully added.",
            backgroundColor: Colors.amber.shade700, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar(
          "Notice", "This user already has a role or the email is invalid.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      setState(() => isAdding = false);
    }
  }

  Future<void> _removeRider(int id) async {
    await Supabase.instance.client.from('user_roles').delete().eq('id', id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FB),
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Iconsax.arrow_left_2, color: Color(0xFF18181A)),
            onPressed: () => Get.back()),
        title: const Text("Delivery Team",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                color: Color(0xFF18181A))),
      ),
      body: Column(
        children: [
          // --- ADD RIDER PANEL ---
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF0F1117).withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Assign New Rider",
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                const SizedBox(height: 8),
                const Text(
                    "We will automatically draft an invite email to send to this rider with instructions.",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        height: 1.4,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF4F5F8),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: const Color(0xFFE8ECEF), width: 1.5)),
                        child: TextField(
                          controller: _emailCtrl,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "rider@email.com",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: isAdding ? null : _addDeliveryRider,
                      child: Container(
                        height: 52, width: 52,
                        decoration: BoxDecoration(
                            color: const Color(0xFF18181A),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      const Color(0xFF18181A).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5))
                            ]),
                        child: isAdding
                            ? const Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Icon(Iconsax.send_1,
                                color: Colors.white,
                                size: 20), // Changed icon to a 'send' icon
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

          // --- LIST OF RIDERS ---
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFFF5E1F)));
                final riders = snapshot.data!;
                if (riders.isEmpty)
                  return const Center(
                      child: Text("No delivery personnel assigned.",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600)));

                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  physics: const BouncingScrollPhysics(),
                  itemCount: riders.length,
                  itemBuilder: (context, index) {
                    final rider = riders[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFFF0F0F3), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                                color:
                                    const Color(0xFF0F1117).withOpacity(0.02),
                                blurRadius: 15,
                                offset: const Offset(0, 5))
                          ]),
                      child: Row(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                                color: const Color(0xFF34C759).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14)),
                            child: const Icon(Iconsax.truck_fast,
                                color: Color(0xFF34C759), size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Active Rider",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF8E8E93),
                                      fontWeight: FontWeight.w700)),
                              Text(rider['email'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      color: Color(0xFF18181A))),
                            ],
                          )),
                          IconButton(
                            onPressed: () => _removeRider(rider['id']),
                            icon: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFFF4B4B).withOpacity(0.1),
                                  shape: BoxShape.circle),
                              child: const Icon(Iconsax.trash,
                                  color: Color(0xFFFF4B4B), size: 16),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
