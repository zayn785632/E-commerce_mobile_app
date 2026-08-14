import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddressCard extends StatelessWidget {
  final String name;
  final String phone;
  final String address;
  final bool isSelected;
  final VoidCallback onTap;

  const AddressCard(
      {super.key,
      required this.name,
      required this.phone,
      required this.address,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF5E1F).withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected
                  ? const Color(0xFFFF5E1F)
                  : const Color(0xFFF0F0F3),
              width: 2),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                      color: const Color(0xFF0F1117).withValues(alpha: 0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 5))
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFF5E1F)
                          : Colors.grey.shade400,
                      width: isSelected ? 6 : 2)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: Color(0xFF18181A))),
                      const Icon(Iconsax.edit,
                          size: 16, color: Color(0xFF8E8E93)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(address,
                      style: const TextStyle(
                          color: Color(0xFF6E6E73), height: 1.4, fontSize: 13)),
                  const SizedBox(height: 8),
                  Text(phone,
                      style: const TextStyle(
                          color: Color(0xFF18181A),
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
