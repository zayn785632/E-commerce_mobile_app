import 'package:flutter/material.dart';

class SizeSelectionWidget extends StatefulWidget {
  const SizeSelectionWidget({super.key});

  @override
  _SizeSelectionWidgetState createState() => _SizeSelectionWidgetState();
}

class _SizeSelectionWidgetState extends State<SizeSelectionWidget> {
  String _selectedSize = 'M'; // Default size

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildSizeContainer('S', 50.0),
        const SizedBox(
          width: 10,
        ),
        _buildSizeContainer('M', 50.0),
        const SizedBox(
          width: 10,
        ),
        _buildSizeContainer('L', 50.0),
        const SizedBox(
          width: 10,
        ),
        _buildSizeContainer('XL', 50.0),
      ],
    );
  }

  Widget _buildSizeContainer(String size, double sizeBoxWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;
        });
      },
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black54, width: 0.5), // Add a black outline
          color: _selectedSize == size ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignment: Alignment.center,
        child: Text(
          size,
          style: TextStyle(
              color: _selectedSize == size ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
