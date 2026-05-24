import 'dart:async';
import 'package:flutter/material.dart';

import '../features/dashboard/dashboard_screen.dart';
import '../features/meals/meals_screen.dart';
import '../features/water/water_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/reminders/reminders_screen.dart';

import '../shared/models/app_data.dart';
import '../shared/services/app_storage_service.dart';
import '../shared/services/notification_service.dart';
import '../shared/widgets/mobile_nav.dart';
import '../shared/widgets/sidebar.dart';

class ResponsiveLayout extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const ResponsiveLayout({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  int index = 0;

  double consumedWaterLiters = 0;
  double dailyWaterGoalLiters = 0;

  final List<MealEntry> meals = [];
  final List<HealthAlert> alerts = [];
  final UserProfile profile = UserProfile();

  Timer? notificationTimer;
  final Set<String> notifiedAlerts = {};

  @override
  void initState() {
    super.initState();
    loadSavedData();
    startAlertListener();
  }

  @override
  void dispose() {
    notificationTimer?.cancel();
    super.dispose();
  }

  String? extractAlertTime(String alertType) {
    final parts = alertType.split(' • ');

    if (parts.length < 2) return null;

    final time = parts[1].trim();

    if (time == 'Sem horário') return null;

    return time;
  }

  void startAlertListener() {
    notificationTimer?.cancel();

    notificationTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) async {
        final now = DateTime.now();

        final currentHour = now.hour.toString().padLeft(2, '0');
        final currentMinute = now.minute.toString().padLeft(2, '0');
        final currentTime = '$currentHour:$currentMinute';

        for (final alert in alerts) {
          final alertTime = extractAlertTime(alert.type);

          if (alertTime == null) continue;

          if (alertTime == currentTime) {
            final notificationKey =
                '${alert.title}-$alertTime-${now.day}-${now.month}-${now.year}';

            if (!notifiedAlerts.contains(notificationKey)) {
              notifiedAlerts.add(notificationKey);

              await NotificationService.showNotification(
                title: alert.title,
                body: alert.message.isEmpty
                    ? 'Você possui um alerta agendado.'
                    : alert.message,
              );
            }
          }
        }
      },
    );
  }

  Future<void> loadSavedData() async {
    final data = await AppStorageService.loadData();

    if (data == null) return;

    setState(() {
      final profileData = data['profile'];

      if (profileData != null) {
        final savedProfile = UserProfile.fromJson(profileData);

        profile.name = savedProfile.name;
        profile.age = savedProfile.age;
        profile.weight = savedProfile.weight;
        profile.height = savedProfile.height;
        profile.gender = savedProfile.gender;
        profile.goal = savedProfile.goal;
        profile.activityLevel = savedProfile.activityLevel;
        profile.calorieGoal = savedProfile.calorieGoal;
      }

      meals.clear();
      meals.addAll(
        (data['meals'] as List? ?? [])
            .map((item) => MealEntry.fromJson(item))
            .toList(),
      );

      alerts.clear();
      alerts.addAll(
        (data['alerts'] as List? ?? [])
            .map((item) => HealthAlert.fromJson(item))
            .toList(),
      );

      consumedWaterLiters =
          (data['consumedWaterLiters'] as num?)?.toDouble() ?? 0;

      dailyWaterGoalLiters =
          (data['dailyWaterGoalLiters'] as num?)?.toDouble() ?? 0;
    });
  }

  Future<void> saveCurrentData() async {
    await AppStorageService.saveData(
      profile: profile,
      meals: meals,
      alerts: alerts,
      consumedWaterLiters: consumedWaterLiters,
      dailyWaterGoalLiters: dailyWaterGoalLiters,
    );
  }

  void addWater(double liters) {
    setState(() {
      consumedWaterLiters += liters;

      if (dailyWaterGoalLiters > 0 &&
          consumedWaterLiters > dailyWaterGoalLiters) {
        consumedWaterLiters = dailyWaterGoalLiters;
      }
    });

    saveCurrentData();
  }

  void resetWater() {
    setState(() {
      consumedWaterLiters = 0;
    });

    saveCurrentData();
  }

  void addMeal(MealEntry meal) {
    setState(() {
      meals.add(meal);
    });

    saveCurrentData();
  }

  void removeMeal(int index) {
    setState(() {
      meals.removeAt(index);
    });

    saveCurrentData();
  }

  void clearMeals() {
    setState(() {
      meals.clear();
    });

    saveCurrentData();
  }

  void addAlert(HealthAlert alert) {
    setState(() {
      alerts.add(alert);
    });

    saveCurrentData();
  }

  void removeAlert(int index) {
    setState(() {
      alerts.removeAt(index);
    });

    saveCurrentData();
  }

  void updateProfile(UserProfile updatedProfile) {
    setState(() {
      profile.name = updatedProfile.name;
      profile.age = updatedProfile.age;
      profile.weight = updatedProfile.weight;
      profile.height = updatedProfile.height;
      profile.gender = updatedProfile.gender;
      profile.goal = updatedProfile.goal;
      profile.activityLevel = updatedProfile.activityLevel;
      profile.calorieGoal = updatedProfile.calorieGoal;

      final weight = double.tryParse(profile.weight.replaceAll(',', '.'));

      if (weight != null) {
        dailyWaterGoalLiters = (weight * 35) / 1000;

        if (consumedWaterLiters > dailyWaterGoalLiters) {
          consumedWaterLiters = dailyWaterGoalLiters;
        }
      }
    });

    saveCurrentData();
  }

  @override
  Widget build(BuildContext context) {
    final consumedCalories = meals.fold<double>(
      0,
      (total, meal) => total + meal.totalCalories,
    );

    final screens = [
      DashboardScreen(
        consumedWaterLiters: consumedWaterLiters,
        dailyWaterGoalLiters: dailyWaterGoalLiters,
        mealsCount: meals.length,
        alertsCount: alerts.length,
        profile: profile,
        consumedCalories: consumedCalories,
      ),
      MealsScreen(
        meals: meals,
        onAddMeal: addMeal,
        onRemoveMeal: removeMeal,
        onClearMeals: clearMeals,
      ),
      WaterScreen(
        consumedWaterLiters: consumedWaterLiters,
        dailyWaterGoalLiters: dailyWaterGoalLiters,
        onAddWater: addWater,
        onResetWater: resetWater,
      ),
      RemindersScreen(
        alerts: alerts,
        onAddAlert: addAlert,
        onRemoveAlert: removeAlert,
      ),
      ProfileScreen(
        profile: profile,
        onSaveProfile: updateProfile,
      ),
    ];

    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    if (isMobile) {
      return Scaffold(
        body: Stack(
          children: [
            screens[index],
            Positioned(
              top: 10,
              right: 10,
              child: SafeArea(
                child: IconButton(
                  onPressed: widget.onToggleTheme,
                  icon: Icon(
                    widget.isDarkMode ? Icons.wb_sunny : Icons.dark_mode,
                  ),
                  tooltip: widget.isDarkMode ? 'Modo claro' : 'Modo escuro',
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: MobileNav(
          currentIndex: index,
          onTap: (i) => setState(() => index = i),
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            currentIndex: index,
            onTap: (i) => setState(() => index = i),
            isDarkMode: widget.isDarkMode,
            onToggleTheme: widget.onToggleTheme,
          ),
          Expanded(child: screens[index]),
        ],
      ),
    );
  }
}