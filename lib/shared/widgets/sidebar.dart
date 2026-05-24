import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../services/auth_service.dart';

class Sidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const Sidebar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isDarkMode,
    required this.onToggleTheme,
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
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Início'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.restaurant_outlined),
          selectedIcon: Icon(Icons.restaurant),
          label: Text('Refeições'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.water_drop_outlined),
          selectedIcon: Icon(Icons.water_drop),
          label: Text('Água'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.alarm_outlined),
          selectedIcon: Icon(Icons.alarm),
          label: Text('Alertas'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Perfil'),
        ),
      ],
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  onPressed: onToggleTheme,
                  icon: Icon(
                    isDarkMode ? Icons.wb_sunny : Icons.dark_mode,
                  ),
                  label: Text(
                    isDarkMode ? 'Modo claro' : 'Modo escuro',
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Sair'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}