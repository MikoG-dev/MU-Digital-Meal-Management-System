import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mu_meal/controller/settingsController.dart';
import 'package:mu_meal/util/db.dart';
import 'package:mu_meal/util/userprefs.dart';
import 'package:permission_handler/permission_handler.dart';

class FileImporter {
  static Future<void> pickAndImportExcel(BuildContext context) async {
    var controller = Get.find<SettingsController>();
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null) {
        controller.isLoading.value = true;
        File file = File(result.files.single.path!);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]!.rows.skip(1)) {
            // Skip headers
            if (row.length < 5) continue;

            String id = row[0]?.value.toString() ?? '';
            String name = row[1]?.value.toString() ?? '';
            String gender = row[2]?.value.toString() ?? '';
            String entryYear = row[3]?.value.toString() ?? '';
            String program = row[4]?.value.toString() ?? '';

            if (id.isNotEmpty) {
              await DatabaseHelper.insertUser(
                  id, name, gender, entryYear, program);
            }
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Excel data imported successfully!")),
        );
        controller.isLoading.value = false;
      }
    } catch (e) {
      controller.isLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to import Excel file.")),
      );
    }
  }

  static Future<void> pickDirectory(BuildContext context) async {
    //ask first
    if (await Permission.manageExternalStorage.request().isGranted) {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory != null) {
        // Save the selected directory path for later use
        var prefs = UserPreferences();
        await prefs.setImgPath(selectedDirectory);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Images path imported successfully!")),
        );
      }
    } else {
      await Permission.manageExternalStorage.request();
      Fluttertoast.showToast(msg: "Permission denied!");
    }
  }
}
