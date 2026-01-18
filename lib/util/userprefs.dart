import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String saveKey = 'saved';
  static const String tokenKey = 'token';
  static const String langKey = 'language_key';
  static const String ipKey = 'ipaddress';
  static const String usernameKey = 'username';
  static const String idKey = 'id';
  static const String imageKey = 'imageKey';
  static const String themeKey = 'theme_key';
  static const String phonenumberKey = 'phone_number';
  static const String versionKey = 'versionKey';
  static const String imagekey = 'imagesKey';
  static const String bannerKey = 'bannerKey';
  static const String isInterrupKey = 'isInterrupKey';
  static const String invKey = 'InvitationKey';
  static const String passportKey = 'PassportKey';
  static const String walletKey = 'walletKey';

  Future setUserName(String username) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(usernameKey, username);
  }

  Future<String> getUserName() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    dynamic obj = preferences.getString(usernameKey) ?? "";
    return obj;
  }

  Future setImgPath(String role) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(imagekey, role);
  }

  Future<String> getImgPath() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    dynamic obj = preferences.getString(imagekey) ?? "";
    return obj;
  }

  Future setPhoneNumber(String middlename) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(phonenumberKey, middlename);
  }

  Future<String> getPhoneNumber() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    dynamic obj = preferences.getString(phonenumberKey) ?? "";
    return obj;
  }

  Future setUserId(String id) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(idKey, id);
  }

  Future<String> getUserId() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    dynamic obj = preferences.getString(idKey) ?? "";
    return obj;
  }

  Future setTheme(bool theme) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(themeKey, theme);
  }

  Future<bool> getTheme() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    dynamic obj = preferences.getBool(themeKey) ?? true;
    return obj;
  }

  Future setProfileImage(String image) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(imageKey, image);
  }

  Future<String> getProfileImage() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    dynamic obj = preferences.getString(imageKey) ?? "";
    return obj;
  }

  Future setBannerImage(String image) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(bannerKey, image);
  }

  Future<String> getBannerImage() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    dynamic obj = preferences.getString(bannerKey) ?? "";
    return obj;
  }

  Future setSaved(bool saved) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(saveKey, saved);
  }

  Future<bool> getSaved() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    dynamic obj = preferences.getBool(saveKey) ?? false;
    return obj;
  }

  Future setInterrupted(String saved) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(isInterrupKey, saved);
  }

  Future<String> getInterrupted() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    dynamic obj = preferences.getString(isInterrupKey) ?? '';
    return obj;
  }

  Future setLanguage(String language) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(langKey, language);
  }

  Future<String> getLanguage() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String obj = preferences.getString(langKey) ?? "en_US";
    return obj;
  }
}
