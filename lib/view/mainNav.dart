import 'package:flutter/material.dart';
import 'package:mu_meal/util/Gconstants.dart';
import 'package:get/get.dart';
import 'package:mu_meal/view/checker_page.dart';
import 'package:mu_meal/view/settings.dart';
import '../cards/card_btn.dart';

class MainNav extends StatelessWidget {
  const MainNav({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Column(
              children: [
                dashboard(),
                const SizedBox(
                  height: 45,
                ),
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.15,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 17,
                  ),
                  children: [
                    CardBtn(
                      title: "breakfast".tr,
                      image: "assets/breakfast.png",
                      onTap: () {
                        Get.to(() => CheckerPage(mealType: 'breakfast'));
                      },
                      gradient: GlobalColors.webColors,
                    ),
                    CardBtn(
                      title: "lunch".tr,
                      image: "assets/lunch.png",
                      onTap: () {
                        Get.to(() => CheckerPage(
                              mealType: 'lunch',
                            ));
                      },
                      gradient: GlobalColors.videoColors,
                    ),
                    CardBtn(
                      title: "dinner".tr,
                      image: "assets/dinner.png",
                      onTap: () {
                        Get.to(() => CheckerPage(
                              mealType: 'dinner',
                            ));
                      },
                      gradient: GlobalColors.adColors,
                    ),
                    CardBtn(
                      title: "settings".tr,
                      image: "assets/settings.png",
                      onTap: () {
                        Get.to(() => Settings());
                      },
                      gradient: GlobalColors.spinColors,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboard() {
    return Container(
        width: Get.width,
        height: 140,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: GlobalColors.adColors,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0.6,
                blurRadius: 10,
                offset: const Offset(7, 10),
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              scale: 3.5,
            ),
            const SizedBox(
              width: 20,
            ),
            Center(
              child: Text(
                "MU Meals".tr,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ));
  }
}
