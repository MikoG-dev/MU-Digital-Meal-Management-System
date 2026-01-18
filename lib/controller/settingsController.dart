import 'package:get/get.dart';
import 'package:mu_meal/util/userprefs.dart';

class SettingsController extends GetxController {
  static RxnInt languageIndex = RxnInt();
  RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getLangIndex();
  }

  static void getLangIndex() async {
    var pref = UserPreferences();
    var lang = await pref.getLanguage();
    if (lang.split("_").first == 'en') {
      languageIndex.value = 0;
    } else if (lang.split("_").first == 'tg') {
      languageIndex.value = 1;
    }
    if (lang.split("_").first == 'am') {
      languageIndex.value = 2;
    }
  }
}
