import 'package:flutter/material.dart';

class ReviewField extends StatefulWidget {
  const ReviewField({
    super.key,
    required this.controller,
    required this.text,
    required this.textInputType,
    required this.obscure,
    this.labelText,
    this.decoration,
  });

  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool obscure;

  final String? labelText;
  final InputDecoration? decoration;

  @override
  State<ReviewField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<ReviewField> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.20,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: TextFormField(
          maxLength: 200,
          decoration: widget.decoration ??
              InputDecoration(
                hintStyle: TextStyle(color: Colors.grey.shade500),
                hintText: widget.text,
                labelText: widget.labelText,
                border: InputBorder.none,
              ),
          obscureText: widget.obscure,
          controller: widget.controller,
          keyboardType: widget.textInputType,
          style: const TextStyle(
            fontSize: 14,
          ),
          maxLines: 5,
        ),
      ),
    );
  }
}
