import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mu_meal/controller/checkerPageController.dart';
import 'package:mu_meal/util/Gconstants.dart';
import 'package:mu_meal/util/idInputFormatter.dart';
import 'package:mu_meal/view/qr_scanner.dart';

class CheckerPage extends StatelessWidget {
  String mealType;
  CheckerPage({super.key, required this.mealType});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CheckerpageController(mealType: mealType));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Verify $mealType".tr),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  children: [
                    idInput(controller),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      "--------- OR ---------",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    scanQrBtn(),
                    const SizedBox(
                      height: 50,
                    ),
                    report(controller),
                  ],
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: controller.isLoading.value,
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.65)),
                  child: const Center(
                      child: SpinKitWave(
                    color: Colors.orange,
                    size: 40.0,
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget idInput(CheckerpageController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: Get.width * 0.73,
            child: TextField(
              controller: controller.inputController,
              onChanged: (value) {},
              decoration: const InputDecoration(
                labelText: 'ID No',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [IDInputFormatter()],
            ),
          ),
          IconButton(
              onPressed: () async {
                await controller.verifyStudent(mealType);
              },
              icon: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 55, 157, 241),
                      borderRadius: BorderRadius.circular(7)),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ))),
        ],
      ),
    );
  }

  Widget scanQrBtn() {
    return InkWell(
      onTap: () {
        Get.to(() => QrScanner(
              mealType: mealType,
            ));
      },
      child: Container(
        width: Get.width * 0.75,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: GlobalColors.spinColors),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.qr_code,
              color: Colors.white,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              'Scan QR'.tr,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget report(CheckerpageController controller) {
    return Column(
      children: [
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.15,
            mainAxisSpacing: 17,
            crossAxisSpacing: 17,
          ),
          children: [
            Obx(
              () => reportCard(
                title: "Served Students".tr,
                gradient: GlobalColors.webColors,
                no: controller.servedNo.value,
              ),
            ),
            Obx(
              () => reportCard(
                  title: "Students left".tr,
                  gradient: GlobalColors.videoColors,
                  no: controller.left.value),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Container(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total Students".tr,
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
              Obx(
                () => Text(
                  controller.totalNo.value.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget reportCard(
      {required List<Color> gradient, required String title, required no}) {
    return Container(
      width: 50,
      height: 140,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          //color: bgColor,
          gradient: LinearGradient(
            colors: gradient,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0.6,
              blurRadius: 10,
              offset: const Offset(7, 10),
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title.toUpperCase(),
            overflow: TextOverflow.fade,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            no.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
