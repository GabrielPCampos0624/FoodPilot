import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../services/auth_service.dart';

class MobileNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MobileNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Future<void> logout(BuildContext context) async {
    await AuthService.logout();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        if (index == 5) {
          logout(context);
          return;
        }

        onTap(index);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Início',
        ),
        NavigationDestination(
          icon: Icon(Icons.restaurant_outlined),
          selectedIcon: Icon(Icons.restaurant),
          label: 'Refeições',
        ),
        NavigationDestination(
          icon: Icon(Icons.water_drop_outlined),
          selectedIcon: Icon(Icons.water_drop),
          label: 'Água',
        ),
        NavigationDestination(
          icon: Icon(Icons.alarm_outlined),
          selectedIcon: Icon(Icons.alarm),
          label: 'Alertas',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
        NavigationDestination(
          icon: Icon(Icons.logout),
          label: 'Sair',
        ),
      ],
    );
  }
}
