import 'package:flutter/material.dart';


class ReviewsCard extends StatelessWidget {
  const ReviewsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                  image: AssetImage("assets/images/userprofile.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
               
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Ayushi",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 20,),
                          const Icon(Icons.star, color: Colors.orange, size: 20,),
                          const Icon(Icons.star, color: Colors.orange, size: 20,),
                          const Icon(Icons.star, color: Colors.orange, size: 20,),
                          const Icon(Icons.star_border_outlined, color: Colors.orange, size: 20,),
                          const SizedBox(width: 5,),
                          Text(
                    "4.0",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                        ],
                      )
                    ],
                  ),
                  const Spacer(), 
                  Text(
                    "20 mins ago",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          "The sun sets, painting the sky in hues of orange and pink, casting long shadows across the landscape as the world prepares for the night.",
          // Adjust the overflow behavior if necessary
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      ],
    );
  }
}
