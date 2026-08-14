import 'package:flutter/material.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:iconsax/iconsax.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  // Define Stepper Data dynamically
  List<StepperData> stepperData = [
    StepperData(
        title: StepperText("Order Placed",
            textStyle:
                const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        subtitle: StepperText("We have received your order.",
            textStyle: const TextStyle(color: Colors.grey)),
        iconWidget: Container(
            decoration: const BoxDecoration(
                color: Color(0xFFFF5E1F), shape: BoxShape.circle),
            child: const Icon(Iconsax.tick_circle, color: Colors.white))),
    StepperData(
        title: StepperText("Processing",
            textStyle:
                const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        subtitle: StepperText("We are preparing your items.",
            textStyle: const TextStyle(color: Colors.grey)),
        iconWidget: Container(
            decoration: const BoxDecoration(
                color: Color(0xFF18181A), shape: BoxShape.circle),
            child: const Icon(Iconsax.box, color: Colors.white, size: 16))),
    StepperData(
        title: StepperText("Shipped",
            textStyle: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, color: Colors.grey)),
        subtitle: StepperText("Handed over to courier.",
            textStyle: const TextStyle(color: Colors.grey)),
        iconWidget: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 2),
                shape: BoxShape.circle))),
    StepperData(
        title: StepperText("Delivered",
            textStyle: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, color: Colors.grey)),
        subtitle: StepperText("Package arrived.",
            textStyle: const TextStyle(color: Colors.grey)),
        iconWidget: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 2),
                shape: BoxShape.circle))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text('Track Order',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: AnotherStepper(
          stepperList: stepperData,
          inActiveBarColor: const Color(0xFFF4F5F8),
          activeBarColor: const Color(0xFFFF5E1F),
          stepperDirection: Axis.vertical,
          iconHeight: 40,
          iconWidth: 40,
        ),
      ),
    );
  }
}
