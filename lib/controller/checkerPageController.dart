import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mu_meal/util/db.dart';

class CheckerpageController extends GetxController {
  String mealType;
  CheckerpageController({required this.mealType});
  final TextEditingController inputController = TextEditingController(
    text: "UGR/",
  );
  RxBool isLoading = RxBool(false);

  RxInt servedNo = RxInt(0);
  RxInt left = RxInt(0);
  RxInt totalNo = RxInt(0);
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkMealCount();
  }

  void checkMealCount() async {
    totalNo.value = await DatabaseHelper.getTotalStudents();
    servedNo.value = await DatabaseHelper.countMealsByType(mealType);
    left.value = totalNo.value - servedNo.value;
  }

  Future verifyStudent(String mealType) async {
    isLoading.value = true;
    String studentId = inputController.text.trim();
    if (studentId != "UGR/") {
      await DatabaseHelper.verifyAndLogMeal(studentId, mealType);
      inputController.text = "UGR/";
      checkMealCount();
    } else {
      Fluttertoast.showToast(msg: "Please enter the ID No first");
    }
    isLoading.value = false;
  }
}
