import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyCartQuantityWidget extends StatefulWidget {
  final int cartId;
  final int initialQuantity;
  final Function(int) onUpdate;

  const MyCartQuantityWidget({
    super.key,
    required this.cartId,
    required this.initialQuantity,
    required this.onUpdate,
  });

  @override
  State<MyCartQuantityWidget> createState() => _MyCartQuantityWidgetState();
}

class _MyCartQuantityWidgetState extends State<MyCartQuantityWidget> {
  late int currentNumber;

  @override
  void initState() {
    super.initState();
    currentNumber = widget.initialQuantity;
  }

  Future<void> _updateDb(int newQty) async {
    setState(() => currentNumber = newQty);
    widget.onUpdate(newQty); // Instantly updates total price on Screen

    // Silently updates DB
    await Supabase.instance.client
        .from('cart')
        .update({'quantity': newQty}).eq('id', widget.cartId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              if (currentNumber > 1) _updateDb(currentNumber - 1);
            },
            child: Container(
              width: 32,
              alignment: Alignment.center,
              child:
                  const Icon(Iconsax.minus, size: 14, color: Color(0xFF18181A)),
            ),
          ),
          SizedBox(
            width: 20,
            child: Text(
              currentNumber.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: Color(0xFF18181A)),
            ),
          ),
          InkWell(
            onTap: () => _updateDb(currentNumber + 1),
            child: Container(
              width: 32,
              alignment: Alignment.center,
              child:
                  const Icon(Iconsax.add, size: 14, color: Color(0xFF18181A)),
            ),
          ),
        ],
      ),
    );
  }
}
