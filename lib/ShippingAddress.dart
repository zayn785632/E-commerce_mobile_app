import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trandtribe/AddAddressScreen.dart';
import 'package:trandtribe/Widgets/RoundedButton.dart';
import 'Card/AddressCard.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});
  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final _addressStream = Supabase.instance.client
      .from('addresses')
      .stream(primaryKey: ['id']).order('created_at');
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FB),
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text('Shipping Address',
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: Color(0xFF18181A))),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _addressStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFFF5E1F)));
                final addresses = snapshot.data!;
                if (addresses.isEmpty) {
                  return const Center(
                      child: Text("No addresses found.\nAdd one below!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final addr = addresses[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: AddressCard(
                        name: addr['full_name'],
                        phone: addr['phone'],
                        address: addr['address_line'],
                        isSelected: selectedId == addr['id'],
                        onTap: () => setState(() => selectedId = addr['id']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5))
            ]),
            child: RoundedButton(
              title: "Add New Address",
              onTap: () => Get.to(() => const AddAddressScreen(),
                  transition: Transition.downToUp),
              width: double.infinity,
            ),
          )
        ],
      ),
    );
  }
}
