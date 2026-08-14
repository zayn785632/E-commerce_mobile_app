import 'package:flutter/material.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  // Advanced Stepper Data styling
  List<StepperData> stepperData = [
    StepperData(
      title: StepperText("Order Placed",
          textStyle: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Color(0xFF18181A))),
      subtitle: StepperText("We have received your order.",
          textStyle: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 13,
              fontWeight: FontWeight.w500)),
      iconWidget: Container(
        decoration: const BoxDecoration(
            color: Color(0xFFFF5E1F), shape: BoxShape.circle),
        child: const Icon(Icons.check, color: Colors.white, size: 20),
      ),
    ),
    StepperData(
      title: StepperText("Processing",
          textStyle: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Color(0xFF18181A))),
      subtitle: StepperText("We are preparing your items.",
          textStyle: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 13,
              fontWeight: FontWeight.w500)),
      iconWidget: Container(
        decoration: const BoxDecoration(
            color: Color(0xFF18181A), shape: BoxShape.circle),
        child: const Icon(Iconsax.box, color: Colors.white, size: 18),
      ),
    ),
    StepperData(
      title: StepperText("Shipped",
          textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFFC7C7CC))),
      subtitle: StepperText("Handed over to courier.",
          textStyle: const TextStyle(
              color: Color(0xFFC7C7CC),
              fontSize: 13,
              fontWeight: FontWeight.w500)),
      iconWidget: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE8ECEF), width: 3),
            shape: BoxShape.circle),
      ),
    ),
    StepperData(
      title: StepperText("Delivered",
          textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Color(0xFFC7C7CC))),
      subtitle: StepperText("Package arrived.",
          textStyle: const TextStyle(
              color: Color(0xFFC7C7CC),
              fontSize: 13,
              fontWeight: FontWeight.w500)),
      iconWidget: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE8ECEF), width: 3),
            shape: BoxShape.circle),
      ),
    ),
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
        // FIXED: Changed onTap to onPressed
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: Color(0xFF18181A)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Track Order',
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              color: Color(0xFF18181A),
              letterSpacing: -0.5),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: AnotherStepper(
                  stepperList: stepperData,
                  inActiveBarColor: const Color(0xFFF4F5F8),
                  activeBarColor: const Color(0xFFFF5E1F),
                  stepperDirection: Axis.vertical,
                  iconHeight: 40,
                  iconWidth: 40,
                  verticalGap: 40,
                ),
              ),
            ),
          ),

          // Sticky Bottom "Back to Orders" button
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: const Offset(0, -10))
              ],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F5F8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text("Back to Orders",
                      style: TextStyle(
                          color: Color(0xFF18181A),
                          fontSize: 16,
                          fontWeight: FontWeight.w800)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
