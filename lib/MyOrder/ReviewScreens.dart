import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import '../Product.dart';
import '../RattingBarCustom.dart';
import '../Widgets/ReviewField.dart';
import '../Widgets/RoundedButton.dart';

class ReviewScreen extends StatefulWidget {
  final Product product; // REQUIRED PRODUCT FIX
  const ReviewScreen({super.key, required this.product});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController commentController = TextEditingController();
  double currentRating = 5.0;
  bool isSubmitting = false;

  Future<void> _submitReview() async {
    if (commentController.text.trim().isEmpty) {
      Get.snackbar("Oops!", "Please write a comment before submitting.");
      return;
    }

    setState(() => isSubmitting = true);

    try {
      await Supabase.instance.client.from('reviews').insert({
        'product_id': widget.product.id,
        'user_name': 'TrendTribe Member',
        'rating': currentRating,
        'comment': commentController.text.trim(),
      });

      Get.back(); // Go back to reviews list
      Get.snackbar("Success", "Your review has been posted!",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Could not submit review. Try again.");
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        widget.product.images.isNotEmpty ? widget.product.images[0] : "";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Write Review',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F9),
                    borderRadius: BorderRadius.circular(12),
                    image: imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(imageUrl), fit: BoxFit.cover)
                        : null,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    widget.product.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Center(
                child: Text("Score this product",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            const SizedBox(height: 10),
            RatingBarCustom(onRatingChanged: (val) => currentRating = val),
            const SizedBox(height: 30),
            const Text("Write your Review",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            ReviewField(
              controller: commentController,
              text: "What did you think of the fit and quality?",
              textInputType: TextInputType.text,
              obscure: false,
            ),
            const SizedBox(height: 30),
            RoundedButton(
              title: "Submit Review",
              loading: isSubmitting,
              onTap: _submitReview,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
