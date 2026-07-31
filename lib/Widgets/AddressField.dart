import 'package:flutter/material.dart';

class AddressTextField extends StatefulWidget {
  const AddressTextField({
    super.key,
    required this.controller,
    required this.text,
    required this.textInputType,
    required this.obscure,
    this.labelText,
    this.suffixIcon,
    this.prefixIcon, // Add prefixIcon property
    this.decoration,
  });

  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool obscure;
  final Widget? suffixIcon;
  final Widget? prefixIcon; // Define prefixIcon
  final String? labelText;
  final InputDecoration? decoration;

  @override
  State<AddressTextField> createState() => _AddressTextFieldState();
}

class _AddressTextFieldState extends State<AddressTextField> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.07,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: TextFormField(
            decoration: widget.decoration ??
                InputDecoration(
                  hintText: widget.text,
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  labelText: widget.labelText,
                  border: InputBorder.none,
                  // prefixIcon: widget.prefixIcon, // Use prefixIcon
                  suffixIcon: widget.suffixIcon, // Use suffixIcon
                ),
            obscureText: widget.obscure,
            controller: widget.controller,
            keyboardType: widget.textInputType,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
