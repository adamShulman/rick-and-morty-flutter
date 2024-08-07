
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsWrapper {

  Future<bool> saveDataFor(String key, String data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getDataFor(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearDataFor(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      return;
    }
  }
}