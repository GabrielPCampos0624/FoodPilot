import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

class FoodPilotApp extends StatefulWidget {
  const FoodPilotApp({super.key});

  @override
  State<FoodPilotApp> createState() => _FoodPilotAppState();
}

class _FoodPilotAppState extends State<FoodPilotApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodPilot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRoutes.login,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return AppRoutes.getPage(
              routeName: settings.name ?? AppRoutes.login,
              isDarkMode: isDarkMode,
              onToggleTheme: toggleTheme,
            );
          },
        );
      },
    );
  }
}