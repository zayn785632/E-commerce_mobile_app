import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trandtribe/Product.dart';
import 'package:trandtribe/Widgets/MyCartQuantityWidget.dart';

class MyCartCard extends StatefulWidget {
  final int cartId;
  final Product product;
  final String initialSize;
  final int quantity;
  final VoidCallback onDelete;
  final Function(int) onQuantityUpdate;
  final Function(String) onSizeUpdate;

  const MyCartCard({
    super.key,
    required this.cartId,
    required this.product,
    required this.initialSize,
    required this.quantity,
    required this.onDelete,
    required this.onQuantityUpdate,
    required this.onSizeUpdate,
  });

  @override
  State<MyCartCard> createState() => _MyCartCardState();
}

class _MyCartCardState extends State<MyCartCard> {
  late String currentSize;

  @override
  void initState() {
    super.initState();
    currentSize = widget.initialSize;
  }

  void _openSizePicker() {
    final sizes = ['S', 'M', 'L', 'XL'];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                        color: const Color(0xFFE8ECEF),
                        borderRadius: BorderRadius.circular(10))),
                const SizedBox(height: 24),
                const Text("Select Size",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  children: sizes.map((size) {
                    bool isSelected = currentSize == size;
                    return GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        setState(() => currentSize = size);
                        widget.onSizeUpdate(size);
                        await Supabase.instance.client
                            .from('cart')
                            .update({'size': size}).eq('id', widget.cartId);
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF18181A)
                                : const Color(0xFFF4F5F8),
                            borderRadius: BorderRadius.circular(16)),
                        alignment: Alignment.center,
                        child: Text(size,
                            style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF18181A),
                                fontWeight: FontWeight.w900,
                                fontSize: 16)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        widget.product.images.isNotEmpty ? widget.product.images[0] : "";

    return Dismissible(
      key: ValueKey(widget.cartId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await Supabase.instance.client
            .from('cart')
            .delete()
            .eq('id', widget.cartId);
        widget.onDelete();
      },
      background: Container(
        decoration: BoxDecoration(
            color: const Color(0xFFFF5E1F),
            borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Iconsax.trash, color: Colors.white, size: 28),
      ),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF0F0F3)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 5))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 80,
                height: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF6F6F9),
                    image: imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(imageUrl), fit: BoxFit.cover)
                        : null),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 15)),
                    const SizedBox(height: 6),

                    // --- HIGHLY VISIBLE INTERACTIVE SIZE CHANGER ---
                    GestureDetector(
                      onTap: _openSizePicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF4F5F8),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Size: $currentSize",
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF6E6E73))),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down_rounded,
                                size: 16, color: Color(0xFF18181A)),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("EUR ${widget.product.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 16)),
                        MyCartQuantityWidget(
                            cartId: widget.cartId,
                            initialQuantity: widget.quantity,
                            onUpdate: widget.onQuantityUpdate),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
