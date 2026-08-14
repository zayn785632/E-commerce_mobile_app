import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SettingsElements extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData icon;
  final bool isDestructive;

  const SettingsElements(
      {super.key,
      required this.title,
      required this.onTap,
      required this.icon,
      this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isDestructive
                      ? const Color(0xFFFF4B4B).withValues(alpha: 0.1)
                      : const Color(0xFFF4F5F8),
                ),
                child: Icon(icon,
                    size: 20,
                    color: isDestructive
                        ? const Color(0xFFFF4B4B)
                        : const Color(0xFF18181A)),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: isDestructive
                        ? const Color(0xFFFF4B4B)
                        : const Color(0xFF18181A)),
              )
            ],
          ),
          Icon(Iconsax.arrow_right_3,
              size: 16, color: const Color(0xFF8E8E93).withValues(alpha: 0.5))
        ],
      ),
    );
  }
}
