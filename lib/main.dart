import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mu_meal/util/languages.dart';
import 'package:mu_meal/util/userprefs.dart';
import 'package:mu_meal/view/mainNav.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static RxString lang = ''.obs;

  static UserPreferences pref = UserPreferences();

  _getThemeStatus() async {
    lang.value = await pref.getLanguage();
    await Get.updateLocale(Locale(lang.split('_').first, lang.split('_').last));
  }

  MyApp() {
    _getThemeStatus();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Mu Meal",
      translations: Languages(),
      locale: const Locale('en', "US"),
      fallbackLocale: const Locale('am', 'ET'),
      home: DecidePage(),
    );
  }
}

class DecidePage extends StatefulWidget {
  DecidePage({Key? key}) : super(key: key);

  @override
  State<DecidePage> createState() => _MyAppState();
}

class _MyAppState extends State<DecidePage> {
  final UserPreferences prefs = UserPreferences();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => const MainNav());
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              scale: 1.7,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "MU Meals",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(
              height: 50,
            ),
            const CircularProgressIndicator(
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
