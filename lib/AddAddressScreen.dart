import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import 'package:trandtribe/Widgets/AddressField.dart';
import 'package:trandtribe/Widgets/RoundedButton.dart';


class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // automaticallyImplyLeading: false,
        centerTitle: true,

        scrolledUnderElevation: 0,
        title: const Text(
          "Add Address",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const Text("Address",style: TextStyle(fontWeight: FontWeight.bold),),
               const SizedBox(height: 15,),
            AddressTextField(
              controller: TextEditingController(), 
              suffixIcon:  Icon(IconsaxBold.location, color: Colors.grey.shade800,),
              text: "House no, street, area & city", 
              textInputType: TextInputType.name, 
              obscure: false),
              const SizedBox(height: 15,),
               const Text("Full Name", style: TextStyle(fontWeight: FontWeight.bold),),
               const SizedBox(height: 15,),
                AddressTextField(
              controller: TextEditingController(),            
              text: "Input full Name", 
              textInputType: TextInputType.name, 
              obscure: false),
                const SizedBox(height: 15,),
              const Text("Phone Number",style: TextStyle(fontWeight: FontWeight.bold),),
               const SizedBox(height: 15,),
               AddressTextField(
              controller: TextEditingController(), 
              text: "Input phone number", 
              textInputType: TextInputType.number, 
              obscure: false),
              const Spacer(),
              RoundedButton(title: "Save Address", onTap: (){}, width: double.infinity)
              
              ],
              
        ),
      ),
    );
  }
}