import 'dart:math';
import 'package:flutter/material.dart';

class WaterProgressCard extends StatefulWidget {
  final double currentLiters;
  final double goalLiters;

  const WaterProgressCard({
    super.key,
    required this.currentLiters,
    required this.goalLiters,
  });

  @override
  State<WaterProgressCard> createState() => _WaterProgressCardState();
}

class _WaterProgressCardState extends State<WaterProgressCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  double get progress {
    if (widget.goalLiters <= 0) return 0;
    return (widget.currentLiters / widget.goalLiters).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasGoal = widget.goalLiters > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meta de água',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.water_drop, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Água consumida',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 14),

            SizedBox(
              height: 42,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: WaterWavePainter(
                        progress: progress,
                        animationValue: _controller.value,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceContainerHighest,
                        waterColor: Colors.blue,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),
            Text(
              !hasGoal
                  ? 'Preencha suas informações nutricionais para calcular'
                  : '${widget.currentLiters.toStringAsFixed(1)}L / ${widget.goalLiters.toStringAsFixed(1)}L por dia',
            ),
          ],
        ),
      ),
    );
  }
}

class WaterWavePainter extends CustomPainter {
  final double progress;
  final double animationValue;
  final Color backgroundColor;
  final Color waterColor;

  WaterWavePainter({
    required this.progress,
    required this.animationValue,
    required this.backgroundColor,
    required this.waterColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final waterHeight = size.height * (1 - progress);
    final waveAmplitude = 5.0;
    final waveLength = size.width / 1.5;
    final phase = animationValue * 2 * pi;

    final path = Path();
    path.moveTo(0, waterHeight);

    for (double x = 0; x <= size.width; x++) {
      final y = waterHeight +
          sin((x / waveLength * 2 * pi) + phase) * waveAmplitude;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final waterPaint = Paint()
      ..color = waterColor.withOpacity(0.75)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, waterPaint);

    final highlightPath = Path();
    highlightPath.moveTo(0, waterHeight + 6);

    for (double x = 0; x <= size.width; x++) {
      final y = waterHeight +
          6 +
          sin((x / waveLength * 2 * pi) + phase + pi) * 3;
      highlightPath.lineTo(x, y);
    }

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant WaterWavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.animationValue != animationValue;
  }
}