import 'package:flutter/material.dart';

class RatingBarCustom extends StatefulWidget {
  final Function(double) onRatingChanged; // <-- THIS FIXES THE ERROR

  const RatingBarCustom({super.key, required this.onRatingChanged});

  @override
  _RatingBarCustomState createState() => _RatingBarCustomState();
}

class _RatingBarCustomState extends State<RatingBarCustom> {
  double _rating = 5.0; // Default to 5 stars

  void _setRating(double value) {
    setState(() => _rating = value);
    widget.onRatingChanged(value); // Send value back to parent
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        int starValue = index + 1;
        return IconButton(
          icon: Icon(
            _rating >= starValue ? Icons.star : Icons.star_border_outlined,
            size: 38,
          ),
          onPressed: () => _setRating(starValue.toDouble()),
          color: const Color(0xFFFF5E1F), // Signature orange stars
        );
      }),
    );
  }
}
