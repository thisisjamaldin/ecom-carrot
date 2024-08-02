import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  SharedPreferences prefs = GetIt.I<SharedPreferences>();
  static const String _userToken = 'user_token';
  static const String _userId = 'user_id';
  static const String _pushToken = 'push_firebase_token';
  static const String _userEmail = 'user_email';
  static const String _userNumber = 'user_number';
  static const String _userName = 'user_name';

  void saveToken(String token) {
    prefs.setString(_userToken, token);
  }

  String getToken() {
    return prefs.getString(_userToken) ?? '';
  }

  void clearToken() {
    prefs.remove(_userToken);
  }

  void saveId(int id) {
    prefs.setInt(_userId, id);
  }

  int? getId() {
    return prefs.getInt(_userId);
  }

  void clearId() {
    prefs.remove(_userToken);
  }

  void savePushToken(String value) {
    prefs.setString(_pushToken, value);
  }

  String getPushToken() {
    return prefs.getString(_pushToken) ?? '';
  }

  void saveEmail(String value) {
    prefs.setString(_userEmail, value);
  }

  String getEmail() {
    return prefs.getString(_userEmail) ?? '';
  }

  void saveNumber(String value) {
    prefs.setString(_userNumber, value);
  }

  String getNumber() {
    return prefs.getString(_userNumber) ?? '';
  }

  void saveName(String value) {
    prefs.setString(_userName, value);
  }

  String getName() {
    return prefs.getString(_userName) ?? '';
  }
}
