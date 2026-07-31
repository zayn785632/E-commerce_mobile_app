import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  const CommonTextField({
    super.key,
    required this.controller,
    required this.text,
    required this.textInputType,
    required this.obscure,
    this.labelText,
    this.suffixIcon,
    this.decoration,
  });

  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool obscure;
  final Widget? suffixIcon;
  final String? labelText;
  final InputDecoration? decoration;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.07,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2),
        ],
      ),
      child: Center(
        child: TextFormField(
          obscureText: widget.obscure,
          controller: widget.controller,
          keyboardType: widget.textInputType,
          style: const TextStyle(
            fontSize: 15,
          ),
          decoration: widget.decoration ??
              InputDecoration(
                suffixIcon: widget.suffixIcon,
                hintText: widget.text,
                labelText: widget.labelText,
                border: InputBorder.none,
              ),
        ),
      ),
    );
  }
}
