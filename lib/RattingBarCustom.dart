import 'package:flutter/material.dart';

class RatingBarCustom extends StatefulWidget {
  const RatingBarCustom({super.key});

  @override
  _RatingBarCustomState createState() => _RatingBarCustomState();
}

class _RatingBarCustomState extends State<RatingBarCustom> {
  double _rating = 0.0;

  void _setRating(double value) {
    setState(() {
      _rating = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                _rating >= 1 ? Icons.star : Icons.star_border_outlined,
                size: 30,
              ),
              onPressed: () => _setRating(1),
              color: _rating >= 1 ? Colors.orange : Colors.orange,
            ),
            IconButton(
              icon: Icon(
                _rating >= 2 ? Icons.star : Icons.star_border_outlined,
                size: 30,
              ),
              onPressed: () => _setRating(2),
              color: _rating >= 2 ? Colors.orange : Colors.orange,
            ),
            IconButton(
              icon: Icon(
                _rating >= 3 ? Icons.star : Icons.star_border_outlined,
                size: 30,
              ),
              onPressed: () => _setRating(3),
              color: _rating >= 3 ? Colors.orange : Colors.orange,
            ),
            IconButton(
              icon: Icon(
                _rating >= 4 ? Icons.star : Icons.star_border_outlined,
                size: 30,
              ),
              onPressed: () => _setRating(4),
              color: _rating >= 4 ? Colors.orange : Colors.orange,
            ),
            IconButton(
              icon: Icon(
                _rating >= 5 ? Icons.star : Icons.star_border_outlined,
                size: 30,
              ),
              onPressed: () => _setRating(5),
              color: _rating >= 5 ? Colors.orange : Colors.orange,
            ),
          ],
        ),
      ],
    );
  }
}
