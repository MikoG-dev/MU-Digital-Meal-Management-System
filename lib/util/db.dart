import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mu_meal/cards/not_verified.dart';
import 'package:mu_meal/cards/twice_entering.dart';
import 'package:mu_meal/cards/verified_card.dart';
import 'package:mu_meal/controller/checkerPageController.dart';
import 'package:mu_meal/model/studentModel.dart';
import 'package:mu_meal/util/userprefs.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Initialize or get existing database
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    final path = await getDatabasesPath();
    _database = await openDatabase(
      join(path, 'meal_users.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            name TEXT,
            gender TEXT,
            entryYear TEXT,
            program TEXT
          )
        ''');
        await db.execute('''
    CREATE TABLE IF NOT EXISTS meal_logs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      student_id TEXT,
      meal_type TEXT,
      date TEXT,
      FOREIGN KEY (student_id) REFERENCES users (id) ON DELETE CASCADE
    )
  ''');
      },
    );
    return _database!;
  }

  // Insert a user into the database
  static Future<void> insertUser(String id, String name, String gender,
      String entryYear, String program) async {
    final db = await getDatabase();
    await db.insert(
      'users',
      {
        'id': id,
        'name': name,
        'gender': gender,
        'entryYear': entryYear,
        'program': program,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all users from the database
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await getDatabase();
    return await db.query('users');
  }

  static Future<StudentModel?> getUserById(String id) async {
    final db = await getDatabase();
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return StudentModel.fromMap(result.first); // Convert map to StudentModel
    } else {
      return null; // Return null if user is not found
    }
  }

  static Future<int> getTotalStudents() async {
    final db = await getDatabase();
    return Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM users')) ??
        0;
  }

  static Future<void> clearDatabase() async {
    final db = await getDatabase();
    await db.delete('users'); // Deletes all records from the users table
    await UserPreferences().setImgPath('');
    Fluttertoast.showToast(
        msg: "Full Database is cleared.", toastLength: Toast.LENGTH_LONG);
  }

  static Future<void> clearServingDatabase() async {
    final db = await getDatabase();
    await db.delete('meal_logs'); // Deletes all records from the users table
    Fluttertoast.showToast(
        msg: "Today's serving is cleared.", toastLength: Toast.LENGTH_LONG);
  }

  static Future<String> verifyAndLogMeal(String studentId, String mealType,
      {bool isQr = false}) async {
    final db = await getDatabase();
    var checkerController = Get.find<CheckerpageController>();
    // Check if student exists in the users table
    List<Map<String, dynamic>> userResult = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [studentId],
    );

    if (userResult.isEmpty) {
      if (isQr) {
        Get.off(() => const NotVerified());
        checkerController.checkMealCount();
      } else {
        Get.to(() => const NotVerified());
      }
      return "User doesn't exist in the database.";
    }

    // Get today's date (YYYY-MM-DD format)
    String today = DateTime.now().toIso8601String().split('T')[0];

    // Check if the student already ate this meal today
    List<Map<String, dynamic>> mealResult = await db.query(
      'meal_logs',
      where: 'student_id = ? AND meal_type = ? AND date = ?',
      whereArgs: [studentId, mealType, today],
    );

    if (mealResult.isNotEmpty) {
      if (isQr) {
        Get.off(() => const TwiceEntering());
        checkerController.checkMealCount();
      } else {
        Get.to(() => const TwiceEntering());
      }

      return "Access Denied! You have already taken $mealType today.";
    }

    // If not found, log the meal
    await db.insert('meal_logs', {
      'student_id': studentId,
      'meal_type': mealType,
      'date': today,
    });
    var student = await getUserById(studentId);
    var imagePath = await UserPreferences().getImgPath();
    student!.image = (imagePath.isNotEmpty)
        ? '$imagePath/${student.idNo.replaceAll('/', '')}.jpg'
        : null;
    if (isQr) {
      Get.off(() => VerifiedCard(studentModel: student));
      checkerController.checkMealCount();
    } else {
      Get.to(() => VerifiedCard(studentModel: student));
    }
    return "Meal Verified! Enjoy your $mealType.";
  }

  static Future<int> countMealsByType(String mealType) async {
    final db = await getDatabase();

    // Query to count the number of records for the given meal type
    List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT COUNT(*) as count
    FROM meal_logs
    WHERE meal_type = ?
  ''', [mealType]);

    // Return the count (if no records, return 0)
    return result.isNotEmpty ? result.first['count'] as int : 0;
  }

  static Future<String> exportMealLogToExcel(BuildContext context) async {
    final db = await getDatabase();

    // Query meal counts grouped by meal type and gender
    List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT meal_logs.meal_type, users.gender, COUNT(*) as count
    FROM meal_logs
    JOIN users ON meal_logs.student_id = users.id
    GROUP BY meal_logs.meal_type, users.gender
  ''');

    // Initialize meal data storage
    Map<String, Map<String, int>> mealData = {
      "breakfast": {"male": 0, "female": 0},
      "lunch": {"male": 0, "female": 0},
      "dinner": {"male": 0, "female": 0}
    };

    int totalMealsServed = 0;

    // Process query results
    for (var row in result) {
      String mealType = row['meal_type'];
      String gender = row['gender'].toLowerCase(); // Ensure lowercase
      int count = row['count'];

      mealData[mealType]?[gender] = count;
      totalMealsServed += count;
    }

    // Create Excel file
    var excel = Excel.createExcel();
    Sheet sheet = excel['Meal Log Report'];
    excel.delete('Sheet1');

    // Add headers
    sheet.appendRow([
      TextCellValue("Meal Type"),
      TextCellValue("Male Count"),
      TextCellValue("Female Count"),
      TextCellValue("Total Served")
    ]);

    // Add data for each meal type
    mealData.forEach((mealType, counts) {
      int maleCount = counts["male"] ?? 0;
      int femaleCount = counts["female"] ?? 0;
      int total = maleCount + femaleCount;
      sheet.appendRow([
        TextCellValue(mealType),
        IntCellValue(maleCount),
        IntCellValue(femaleCount),
        IntCellValue(total),
      ]);
    });

    // Add total meals served
    sheet.appendRow([]);
    sheet.appendRow(
        [TextCellValue("Total Meals Served"), IntCellValue(totalMealsServed)]);

    // Save file
    String today = DateTime.now().toIso8601String().split('T')[0];
    String filePath =
        "${"/storage/emulated/0/Download"}/meal_${today}_report.xlsx";
    File file = File(filePath);
    await file.writeAsBytes(excel.encode()!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Excel data exported successfully!")),
    );

    return filePath; // Return file path for sharing/downloading
  }
}
