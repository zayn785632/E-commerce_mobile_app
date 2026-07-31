// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileElements extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData? icon;
  const ProfileElements({
    super.key,
    required this.onTap,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          elevation: 0.5,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                            color: Colors.black),
                        child: Icon(
                          icon,
                          size: 20,
                          color: Colors.white,
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
        ),
      ),
    );
  }
}
