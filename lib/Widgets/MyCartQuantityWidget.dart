import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MyCartQuantityWidget extends StatefulWidget {
  const MyCartQuantityWidget({super.key});

  @override
  State<MyCartQuantityWidget> createState() => _MyCartQuantityWidgetState();
}

class _MyCartQuantityWidgetState extends State<MyCartQuantityWidget> {
  int currentNumber = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 80,
      decoration: BoxDecoration(

          // border: Border.all(
          //   color: Colors.black,
          //   width: 0.5,
          // ),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              if (currentNumber != 1) {
                setState(() {
                  currentNumber--;
                });
              }
            },
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5))),
              child: const Icon(
                size: 20,
                Iconsax.minus,
                // color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            currentNumber.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              setState(() {
                currentNumber++;
              });
            },
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              child: const Icon(
                size: 20,
                Iconsax.add,
                // color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
