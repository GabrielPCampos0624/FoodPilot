import 'package:flutter/material.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/water_progress_card.dart';

class WaterScreen extends StatefulWidget {
  final double consumedWaterLiters;
  final double dailyWaterGoalLiters;
  final void Function(double liters) onAddWater;
  final VoidCallback onResetWater;

  const WaterScreen({
    super.key,
    required this.consumedWaterLiters,
    required this.dailyWaterGoalLiters,
    required this.onAddWater,
    required this.onResetWater,
  });

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  final waterController = TextEditingController();

  void addCustomWater() {
    final value = double.tryParse(waterController.text.replaceAll(',', '.'));

    if (value == null || value <= 0) return;

    widget.onAddWater(value / 1000);
    waterController.clear();
  }

  @override
  void dispose() {
    waterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.dailyWaterGoalLiters - widget.consumedWaterLiters;

    return Scaffold(
      appBar: AppBar(title: const Text('Água')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.water_drop, size: 90, color: Colors.blue),
            const SizedBox(height: 20),
            WaterProgressCard(
              currentLiters: widget.consumedWaterLiters,
              goalLiters: widget.dailyWaterGoalLiters,
            ),
            const SizedBox(height: 16),
            Text(
              remaining <= 0
                  ? 'Meta diária concluída!'
                  : 'Faltam ${remaining.toStringAsFixed(1)}L para sua meta',
            ),
            const SizedBox(height: 24),
            TextField(
              controller: waterController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade ingerida em ml',
                hintText: 'Ex: 350',
                prefixIcon: Icon(Icons.local_drink),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Adicionar água',
              onPressed: addCustomWater,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: widget.onResetWater,
              icon: const Icon(Icons.refresh),
              label: const Text('Resetar consumo'),
            ),
          ],
        ),
      ),
    );
  }
}