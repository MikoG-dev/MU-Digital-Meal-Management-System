import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxnString phoneNoError = RxnString();
  RxnString passwordError = RxnString();
  String phoneNumber = '';
  String phoneCode = '';
  RxString isoCode = RxString('US');
}
