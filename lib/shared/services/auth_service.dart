import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user_email';

  static Future<List<Map<String, dynamic>>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson == null) return [];

    final List decoded = jsonDecode(usersJson);
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> _saveUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  static Future<bool> emailExists(String email) async {
    final users = await _getUsers();

    return users.any(
      (user) => user['email'].toString().toLowerCase() == email.toLowerCase(),
    );
  }

  static Future<void> register(String email, String password) async {
    final users = await _getUsers();

    users.add({
      'email': email,
      'password': password,
    });

    await _saveUsers(users);
  }

  static Future<bool> login(String email, String password) async {
    final users = await _getUsers();

    final success = users.any(
      (user) =>
          user['email'].toString().toLowerCase() == email.toLowerCase() &&
          user['password'] == password,
    );

    if (success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserKey, email.toLowerCase());
    }

    return success;
  }

  static Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  static Future<bool> isRegistered() async {
    final users = await _getUsers();
    return users.isNotEmpty;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }
}