import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

Future<String> getPreferenceKey(
  String key, {
  bool clearOnLogout = true,
}) async {
  String result = key;
  return result;
}

// ignore: public_member_api_docs
Future<String?> getString(String key, bool clearOnLogout) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs
      .getString(await getPreferenceKey(key, clearOnLogout: clearOnLogout));
}

Future<void> setString(String key, String value, bool clearOnLogut) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(
      await getPreferenceKey(key, clearOnLogout: clearOnLogut), value);
}

Future<int> getInt(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(await getPreferenceKey(key)) ?? 0;
}

Future<void> setInt(String key, int value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(await getPreferenceKey(key), value);
}

Future<bool> getBool(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(await getPreferenceKey(key)) ?? false;
}

Future<void> setBool(String key, bool value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(await getPreferenceKey(key), value);
}

Future<List<String>> getStringList(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(await getPreferenceKey(key)) ?? <String>[];
}

Future<void> setStringList(String key, List<String> value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(await getPreferenceKey(key), value);
}
