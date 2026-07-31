import 'package:flutter/material.dart';
import 'package:another_stepper/another_stepper.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  List<StepperData> stepperData = [
    StepperData(
        title: StepperText("Order Placed"),
        subtitle: StepperText("Your order has been placed."),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(100)),
          child: const Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
        )),
    StepperData(
        title: StepperText("Processing"),
        subtitle: StepperText("Your order is been processed."),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(100)),
          child: const Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
        )),
    StepperData(
        title: StepperText("Shipped"),
        subtitle: StepperText("Your order has been shipped."),
        iconWidget: Container(
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(100)),
          child: const Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
        )),
    StepperData(
        title: StepperText("Delivered"),
        subtitle: StepperText("Your order has been delivered."),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(100)),
          child: const Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
        )),
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
          'Track Order',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: AnotherStepper(
          stepperList: stepperData,
          inActiveBarColor: Colors.grey,
          activeBarColor: Colors.blue,
          stepperDirection: Axis.vertical,
          iconHeight: 40,
          iconWidth: 40,
        ),
      ),
    );
  }
}
