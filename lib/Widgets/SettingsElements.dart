import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SettingsElements extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData? icon;
  const SettingsElements(
      {super.key, required this.title, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200),
                    child: Icon(
                      icon,
                      size: 20,
                    )),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            const Icon(
              Iconsax.arrow_right_3,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}
