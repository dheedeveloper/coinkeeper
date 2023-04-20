import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _singleton = StorageService._internal();

  factory StorageService() {
    return _singleton;
  }

  StorageService._internal();

  Future<void> setUserId(String id, String value) async {
    if (id != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(id, value);
    }
  }

  Future<String> getUserId(String key, {defaultValue = ''}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }



}