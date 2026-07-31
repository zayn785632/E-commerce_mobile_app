
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
             boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Home",
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade600),
                ),
                Icon(
                  Iconsax.more,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Row(
              children: [
                Icon(
                  Iconsax.location5,
                  size: 20,
                ),
                SizedBox(width: 10),
                Text("Rahman Nagar, 2no Gate, Chittagong")
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Row(
              children: [
                Icon(
                  IconsaxBold.frame,
                  size: 20,
                ),
                SizedBox(width: 10),
                Text(
                  "Uhlapru Marma",
                  style: TextStyle(fontWeight: FontWeight.w400),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Row(
              children: [
                Icon(
                  IconsaxBold.call_calling,
                  size: 18,
                ),
                SizedBox(width: 10),
                Text("+08801402388903")
              ],
            ),
          
          ],
        ),
        
      ),
    );
  }
}
