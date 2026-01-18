import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotVerified extends StatelessWidget {
  const NotVerified({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                profile(),
                const SizedBox(
                  height: 20,
                ),
                verified(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "The Student Doesn't Exist in the Cafe's Database".tr,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color.fromARGB(255, 140, 42, 35),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                tryagainBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profile() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(120),
        color: Colors.red,
      ),
      child: const Center(
        child: Icon(
          Icons.person_2_outlined,
          size: 100,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget verified() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.cancel_rounded,
          size: 35,
          color: Colors.red,
        ),
        Text(
          "Not Verified".tr,
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ],
    );
  }

  Widget tryagainBtn() {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.red),
        child: Text(
          "Try Again".tr,
          style: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
