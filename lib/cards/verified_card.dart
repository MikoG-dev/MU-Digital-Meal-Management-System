import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mu_meal/model/studentModel.dart';

class VerifiedCard extends StatelessWidget {
  final StudentModel studentModel;
  VerifiedCard({super.key, required this.studentModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15),
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
                  details(),
                  const SizedBox(
                    height: 20,
                  ),
                  okBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget details() {
    var ts = const TextStyle(fontSize: 21);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Name: ${studentModel.name}", style: ts),
        Text("ID No: ${studentModel.idNo}", style: ts),
        Text("Gender: ${studentModel.gender}", style: ts),
        Text("Entry Year: ${studentModel.entryYear}", style: ts),
        Text("Program: ${studentModel.program}", style: ts),
      ],
    );
  }

  Widget profile() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Simplifies border radius for a circle
        color: Colors.blue,
        image: (studentModel.image != null && studentModel.image!.isNotEmpty)
            ? DecorationImage(
                image: FileImage(File(studentModel.image!)),
                fit: BoxFit.cover,
                onError: (_, __) {}, // Prevents crashes
              )
            : null,
      ),
      child: (studentModel.image == null)
          ? const Icon(
              Icons.person_2_outlined,
              size: 100,
              color: Colors.white,
            )
          : null,
    );
  }

  Widget verified() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle,
          size: 35,
          color: Colors.green,
        ),
        Text(
          "Verified",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ],
    );
  }

  Widget okBtn() {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.green),
        child: const Text(
          "Ok",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
