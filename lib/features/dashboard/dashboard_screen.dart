import 'package:flutter/material.dart';
import '../../shared/models/app_data.dart';
import '../../shared/widgets/info_card.dart';
import '../../shared/widgets/water_progress_card.dart';

class DashboardScreen extends StatelessWidget {
  final double consumedWaterLiters;
  final double dailyWaterGoalLiters;
  final int mealsCount;
  final int alertsCount;
  final UserProfile profile;
  final double consumedCalories;

  const DashboardScreen({
    super.key,
    required this.consumedWaterLiters,
    required this.dailyWaterGoalLiters,
    required this.mealsCount,
    required this.alertsCount,
    required this.profile,
    required this.consumedCalories,
  });

  String get mealsText {
    if (mealsCount == 0) return 'Nenhuma refeição';
    if (mealsCount == 1) return '1 refeição';
    return '$mealsCount refeições';
  }

  String get alertsText {
    if (alertsCount == 0) return 'Nenhum alerta';
    if (alertsCount == 1) return '1 alerta';
    return '$alertsCount alertas';
  }

  String get calorieGoalText {
    if (profile.calorieGoal == null) return 'Ainda não calculada';
    return '${profile.calorieGoal!.toStringAsFixed(0)} kcal/dia';
  }

  String get remainingCaloriesText {
    if (profile.calorieGoal == null) return 'Configure suas informações nutricionais';

    final remaining = profile.calorieGoal! - consumedCalories;

    if (remaining < 0) {
      return '${remaining.toStringAsFixed(0)} kcal';
    }

    return '${remaining.toStringAsFixed(0)} kcal restantes';
  }

  Color? get remainingCaloriesColor {
    if (profile.calorieGoal == null) return null;

    final remaining = profile.calorieGoal! - consumedCalories;

    if (remaining < 0) return Colors.red;

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final hasWaterGoal = dailyWaterGoalLiters > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodPilot'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            InfoCard(
              title: 'Meta calórica',
              value: calorieGoalText,
            ),
            InfoCard(
              title: 'Calorias consumidas',
              value: '${consumedCalories.toStringAsFixed(0)} kcal',
            ),
            InfoCard(
              title: 'Saldo calórico',
              value: remainingCaloriesText,
              valueColor: remainingCaloriesColor,
            ),
            InfoCard(
              title: 'Refeições registradas',
              value: mealsText,
            ),
            if (!hasWaterGoal)
              const InfoCard(
                title: 'Meta de água',
                value: 'Preencha suas informações nutricionais para calcular',
              )
            else
              WaterProgressCard(
                currentLiters: consumedWaterLiters,
                goalLiters: dailyWaterGoalLiters,
              ),
            InfoCard(
              title: 'Alertas ativos',
              value: alertsText,
            ),
          ],
        ),
      ),
    );
  }
}
