import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mu_meal/controller/settingsController.dart';
import 'package:mu_meal/main.dart';
import 'package:mu_meal/util/userprefs.dart';

class LanguageSelector extends StatefulWidget {
  //final SettingsSettingsController SettingsController;
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SettingsController.getLangIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            children: [
              Text(
                "${'Choose language'.tr}:",
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Obx(
                () => RadioListTile<int>(
                  activeColor: Colors.blue,
                  value: 0,
                  groupValue: SettingsController.languageIndex.value,
                  onChanged: (value) {
                    SettingsController.languageIndex.value = value;
                    MyApp.lang.value = 'en_US';
                    Get.updateLocale(const Locale('en', 'US'));
                    saveLang('en_US');
                    Navigator.of(context).pop();
                  },
                  title: const Text("English"),
                ),
              ),
              Obx(
                () => RadioListTile<int>(
                  activeColor: Colors.blue,
                  value: 1,
                  groupValue: SettingsController.languageIndex.value,
                  onChanged: (value) {
                    SettingsController.languageIndex.value = value;
                    MyApp.lang.value = 'tg_ET';
                    Get.updateLocale(const Locale('tg', 'ET'));
                    saveLang('tg_ET');
                    Navigator.of(context).pop();
                  },
                  title: const Text("ትግርኛ"),
                ),
              ),
              Obx(
                () => RadioListTile<int>(
                  activeColor: Colors.blue,
                  value: 2,
                  groupValue: SettingsController.languageIndex.value,
                  onChanged: (value) {
                    SettingsController.languageIndex.value = value;
                    MyApp.lang.value = 'am_ET';
                    Get.updateLocale(const Locale('am', 'ET'));
                    saveLang('am_ET');
                    Navigator.of(context).pop();
                  },
                  title: const Text("አማርኛ"),
                ),
              )
            ],
          ),
        ),
      ),
      //  ),
    );
  }

  void saveLang(String lang) async {
    var pref = UserPreferences();
    await pref.setLanguage(lang);
  }
}
