// TODO(Abed): refactor this file.
import 'package:shared_preferences/shared_preferences.dart';

const String _clearOnLogoutPrefix = 'CLEAR_ON_LOGOUT_';
const String _userPrefix = 'USER_ID_';

Future<String> getPreferenceKey(
  String key, {
  bool isUserBase = false,
  bool clearOnLogout = true,
}) async {
  String result = key;

  if (clearOnLogout) {
    result = '$_clearOnLogoutPrefix$result';
  }

  if (isUserBase) {
    // final String userPrefix = await _getUserPrefix();

    // result = '$userPrefix$result';
  }

  return result;
}

Future<List<Map<String, dynamic>?>> getClearOnLogoutPreferences() async {
  final List<String> keys = await _getClearOnLogoutKeys();
  final List<Map<String, dynamic>?> result = <Map<String, dynamic>?>[];
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (keys.isNotEmpty) {
    for (final String key in keys) {
      result.add(prefs.get(key) as Map<String, dynamic>?);
    }
  }

  return result;
}

// Future<List<Map<String, dynamic>?>> getUserPreferences() async {
//   final List<String> keys = await _getUserKeys();
//   final List<Map<String, dynamic>?> result = <Map<String, dynamic>?>[];
//   final SharedPreferences prefs = await SharedPreferences.getInstance();

//   if (keys.isNotEmpty) {
//     for (final String key in keys) {
//       result.add(prefs.get(key) as Map<String, dynamic>?);
//     }
//   }

//   return result;
// }

Future<void> clearOnLogoutPreferences() async {
  final List<String> keys = await _getClearOnLogoutKeys();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (keys.isNotEmpty) {
    for (final String key in keys) {
      await prefs.remove(key);
    }
  }
}

// Future<void> clearUserPreferences() async {
//   final List<String> keys = await _getUserKeys();
//   final SharedPreferences prefs = await SharedPreferences.getInstance();

//   if (keys.isNotEmpty) {
//     for (final String key in keys) {
//       await prefs.remove(key);
//     }
//   }
// }

// Future<String> _getUserPrefix() async {
//   final String? userId = await SecureStorage().getDefaultUserId();
//   return '$_userPrefix${userId}_';
// }

Future<List<String>> _getClearOnLogoutKeys() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs
      .getKeys()
      .where((String item) => item.contains(_clearOnLogoutPrefix))
      .toList();
}

// Future<List<String>> _getUserKeys() async {
//   final String userPrefix = await _getUserPrefix();
//   final SharedPreferences prefs = await SharedPreferences.getInstance();

//   return prefs
//       .getKeys()
//       .where((String item) => item.contains(userPrefix))
//       .toList();
// }

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
