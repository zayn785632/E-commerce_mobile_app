import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trandtribe/Widgets/AddressField.dart';
import 'package:trandtribe/Widgets/RoundedButton.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});
  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addrCtrl = TextEditingController();
  bool isSaving = false;

  Future<void> _saveAddress() async {
    if (nameCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        addrCtrl.text.isEmpty) return;
    setState(() => isSaving = true);
    await Supabase.instance.client.from('addresses').insert({
      'full_name': nameCtrl.text.trim(),
      'phone': phoneCtrl.text.trim(),
      'address_line': addrCtrl.text.trim(),
    });
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("New Address",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddressTextField(
                controller: nameCtrl,
                text: "Full Name",
                textInputType: TextInputType.name,
                obscure: false),
            const SizedBox(height: 20),
            AddressTextField(
                controller: phoneCtrl,
                text: "Phone Number",
                textInputType: TextInputType.phone,
                obscure: false),
            const SizedBox(height: 20),
            AddressTextField(
                controller: addrCtrl,
                text: "House no, street, city",
                textInputType: TextInputType.streetAddress,
                obscure: false),
            const Spacer(),
            RoundedButton(
                title: "Save Address",
                loading: isSaving,
                onTap: _saveAddress,
                width: double.infinity),
          ],
        ),
      ),
    );
  }
}
