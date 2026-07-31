import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'Card/ReviewsCard.dart';

// ignore: must_be_immutable
class SeeReviewsScreen extends StatelessWidget {
  SeeReviewsScreen({super.key});

  // Define your ratings and corresponding percentages
  List<Map<String, dynamic>> ratingsData = [
    {"name": "Excellent", "percent": 0.9, "color": Colors.green.shade600},
    {"name": "Good", "percent": 0.7, "color": Colors.lightGreen},
    {"name": "Average", "percent": 0.5, "color": Colors.yellow.shade600},
    {"name": "Below Average", "percent": 0.3, "color": Colors.orange.shade600},
    {"name": "Poor", "percent": 0.2, "color": Colors.red.shade600},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: false,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Reviews',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const Text(
                "4.0",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 35),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 20,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 20,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 20,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 20,
                  ),
                  Icon(
                    Icons.star_border_outlined,
                    color: Colors.orange,
                    size: 20,
                  ),
                ],
              ),
                const SizedBox(height: 10),
               const Text(
                "based on 46 reviews",
                
              ),
               const SizedBox(height: 20),
              for (var rating in ratingsData)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      rating["name"],
                    ),
                    LinearPercentIndicator(
                      percent: rating["percent"],
                      lineHeight: 6.0,
                      animation: true,
                      animationDuration: 1000,
                      progressColor: rating["color"],
                      barRadius: const Radius.circular(10),
                      curve: Curves.linear,
                      width: Get.height * 0.28,
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              const Divider(
                thickness: 0.5,
              ),
              const SizedBox(height: 20),
              const ReviewsCard(),
              const SizedBox(height: 20),
              const ReviewsCard(),
              const SizedBox(height: 20),
              const ReviewsCard(),
              const SizedBox(height: 20),
              const ReviewsCard(),
            ],
          ),
        ),
      ),
    );
  }
}
