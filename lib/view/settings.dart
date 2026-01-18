import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mu_meal/controller/settingsController.dart';
import 'package:mu_meal/util/db.dart';
import 'package:mu_meal/util/fileImporter.dart';
import 'package:mu_meal/util/languageSelector.dart';

class Settings extends StatelessWidget {
  var controller = Get.put(SettingsController());
  Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("settings".tr),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  title: Text("Import Students Data".tr),
                  subtitle: Text("import cafe users".tr),
                  leading: const Icon(
                    Icons.download_outlined,
                    size: 25,
                  ),
                  onTap: () async {
                    await FileImporter.pickAndImportExcel(context);
                  },
                ),
                const Divider(),
                ListTile(
                  title: Text("Import Pictures of Students".tr),
                  subtitle: Text("import pictures for better verification".tr),
                  leading: const Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 25,
                  ),
                  onTap: () async {
                    await FileImporter.pickDirectory(context);
                  },
                ),
                const Divider(),
                ListTile(
                  title: Text("Export Report".tr),
                  subtitle: Text("export to get analysis".tr),
                  leading: const Icon(
                    Icons.upload_outlined,
                    size: 25,
                  ),
                  onTap: () async {
                    await DatabaseHelper.exportMealLogToExcel(context);
                  },
                ),
                const Divider(),
                ListTile(
                  title: Text("Clear Todays Serving".tr),
                  subtitle: Text("clear todays serving history".tr),
                  leading: const Icon(
                    Icons.clear_all_outlined,
                    size: 25,
                  ),
                  onTap: () async {
                    Get.dialog(dialogClear('serving'));
                  },
                ),
                const Divider(),
                ListTile(
                  title: Text("Clear All Data".tr),
                  subtitle: Text("Erase all the students data".tr),
                  leading: const Icon(
                    Icons.delete_forever_outlined,
                    size: 25,
                  ),
                  onTap: () async {
                    Get.dialog(dialogClear('all'));
                  },
                ),
                const Divider(),
                ListTile(
                  title: Text("Language".tr),
                  subtitle: Text("Change Language".tr),
                  leading: const Icon(
                    Icons.language,
                    size: 25,
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext c) =>
                            const LanguageSelector()).then((value) {});
                  },
                ),
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
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.65)),
              child: const Center(
                  child: SpinKitWave(
                color: Colors.orange,
                size: 40.0,
              )),
            ),
          ),
        ),
      ],
    );
  }

  Widget dialogClear(String db) {
    return AlertDialog(
      title: Text("Are you sure to clear?".tr),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "No".tr,
              style: const TextStyle(fontSize: 15, color: Colors.blue),
            )),
        TextButton(
            onPressed: () async {
              Get.back();
              if (db == 'all') {
                await DatabaseHelper.clearDatabase();
              } else {
                await DatabaseHelper.clearServingDatabase();
              }
            },
            child: Text(
              "Yes".tr,
              style: const TextStyle(fontSize: 15, color: Colors.blue),
            ))
      ],
    );
  }
}
