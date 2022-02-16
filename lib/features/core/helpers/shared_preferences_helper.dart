// part of 'helpers.dart';

// // TODO(Abed): refactor this file.
// const String _clearOnLogoutPrefix = 'CLEAR_ON_LOGOUT_';
// const String _userPrefix = 'USER_ID_';

// Future<String> getPreferenceKey(
//   String key, {
//   bool isUserBase = false,
//   bool clearOnLogout = true,
// }) async {
//   String result = key;

//   if (clearOnLogout) {
//     result = '$_clearOnLogoutPrefix$result';
//   }

//   if (isUserBase) {
//     final String userPrefix = await _getUserPrefix();

//     result = '$userPrefix$result';
//   }

//   return result;
// }



// Future<int> getInt(String key) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getInt(await getPreferenceKey(key)) ?? 0;
// }

// Future<void> setInt(String key, int value) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setInt(await getPreferenceKey(key), value);
// }


