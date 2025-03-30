import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const String _seenIntroKey = "seenIntro";

  Future<void> setSeenIntro(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenIntroKey, value);
  }

  Future<bool> getSeenIntro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seenIntroKey) ?? false;
  }
}
