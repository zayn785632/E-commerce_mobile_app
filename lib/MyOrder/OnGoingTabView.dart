import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Card/OnGoingCard.dart';

class OnGoingTabView extends StatelessWidget {
  const OnGoingTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              OngoingCard(),
              SizedBox(height: 15,),
              OngoingCard(),
              
              
            ],
          ),
        ),
    );
  }
}

