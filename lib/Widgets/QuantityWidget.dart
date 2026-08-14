import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class QuantityWidget extends StatefulWidget {
  final Function(int) onQuantityChanged; // Passes data to parent
  const QuantityWidget({super.key, required this.onQuantityChanged});

  @override
  State<QuantityWidget> createState() => _QuantityWidgetState();
}

class _QuantityWidgetState extends State<QuantityWidget> {
  int currentNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F8),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              if (currentNumber > 1) {
                setState(() => currentNumber--);
                widget.onQuantityChanged(currentNumber); // Trigger callback
              }
            },
            icon: const Icon(Iconsax.minus, size: 18, color: Color(0xFF18181A)),
          ),
          Text(
            currentNumber.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: Color(0xFF18181A)),
          ),
          IconButton(
            onPressed: () {
              setState(() => currentNumber++);
              widget.onQuantityChanged(currentNumber); // Trigger callback
            },
            icon: const Icon(Iconsax.add, size: 18, color: Color(0xFF18181A)),
          ),
        ],
      ),
    );
  }
}
