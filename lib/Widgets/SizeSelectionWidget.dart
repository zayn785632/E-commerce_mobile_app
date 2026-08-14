import 'package:flutter/material.dart';

class SizeSelectionWidget extends StatefulWidget {
  final Function(String) onSizeSelected; // Passes data to parent
  const SizeSelectionWidget({super.key, required this.onSizeSelected});

  @override
  _SizeSelectionWidgetState createState() => _SizeSelectionWidgetState();
}

class _SizeSelectionWidgetState extends State<SizeSelectionWidget> {
  String _selectedSize = 'M';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildSizeContainer('S'),
        const SizedBox(width: 12),
        _buildSizeContainer('M'),
        const SizedBox(width: 12),
        _buildSizeContainer('L'),
        const SizedBox(width: 12),
        _buildSizeContainer('XL'),
      ],
    );
  }

  Widget _buildSizeContainer(String size) {
    bool isSelected = _selectedSize == size;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedSize = size);
        widget.onSizeSelected(size); // Trigger callback
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 54.0,
        height: 54.0,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF18181A) : const Color(0xFFF4F5F8),
          borderRadius: BorderRadius.circular(14.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          size,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF18181A),
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
