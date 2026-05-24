import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_data.dart';
import 'auth_service.dart';

class AppStorageService {
  static Future<String?> _getUserKey() async {
    final email = await AuthService.getCurrentUserEmail();

    if (email == null) return null;

    return 'foodpilot_data_$email';
  }

  static Future<void> saveData({
    required UserProfile profile,
    required List<MealEntry> meals,
    required List<HealthAlert> alerts,
    required double consumedWaterLiters,
    required double dailyWaterGoalLiters,
  }) async {
    final key = await _getUserKey();
    if (key == null) return;

    final prefs = await SharedPreferences.getInstance();

    final data = {
      'profile': profile.toJson(),
      'meals': meals.map((meal) => meal.toJson()).toList(),
      'alerts': alerts.map((alert) => alert.toJson()).toList(),
      'consumedWaterLiters': consumedWaterLiters,
      'dailyWaterGoalLiters': dailyWaterGoalLiters,
    };

    await prefs.setString(key, jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> loadData() async {
    final key = await _getUserKey();
    if (key == null) return null;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);

    if (jsonString == null) return null;

    return jsonDecode(jsonString);
  }
}