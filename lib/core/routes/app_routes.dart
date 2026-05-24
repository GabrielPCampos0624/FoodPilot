import 'package:flutter/material.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../layout/responsive_layout.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String home = '/home';

  static Widget getPage({
    required String routeName,
    required bool isDarkMode,
    required VoidCallback onToggleTheme,
  }) {
    switch (routeName) {
      case register:
        return const RegisterScreen();

      case home:
        return ResponsiveLayout(
          isDarkMode: isDarkMode,
          onToggleTheme: onToggleTheme,
        );

      case login:
      default:
        return LoginScreen(
          isDarkMode: isDarkMode,
          onToggleTheme: onToggleTheme,
        );
    }
  }
}