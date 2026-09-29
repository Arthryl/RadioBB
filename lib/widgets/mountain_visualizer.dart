import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MountainVisualizer extends StatefulWidget {
  final bool isPlaying;
  final double height;

  const MountainVisualizer({
    super.key,
    required this.isPlaying,
    this.height = 70,
  });

  @override
  State<MountainVisualizer> createState() => _MountainVisualizerState();
}

class _MountainVisualizerState extends State<MountainVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant MountainVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isPlaying && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(double.infinity, widget.height),
          painter: _MountainPainter(
            animationValue: _controller.value,
            isPlaying: widget.isPlaying,
          ),
        );
      },
    );
  }
}

class _MountainPainter extends CustomPainter {
  final double animationValue;
  final bool isPlaying;

  _MountainPainter({
    required this.animationValue,
    required this.isPlaying,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Tło górskie (warstwa 1 - soft cyan)
    final paintSoft = Paint()
      ..color = AppTheme.blueDeep.withOpacity(0.45)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Główna linia grani (warstwa 2 - neon cyan)
    final paintMain = Paint()
      ..color = isPlaying ? AppTheme.bluePrimary : AppTheme.blueDeep
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pathSoft = Path();
    final pathMain = Path();

    final points = 24;
    final dx = w / points;

    for (int i = 0; i <= points; i++) {
      final x = i * dx;
      final phase = animationValue * 2 * pi;

      // Sinusoidalne i górskie ukształtowanie
      final baseRidge = sin(i * 0.45) * 12 + cos(i * 0.8) * 8;
      final wave = isPlaying ? sin(phase + i * 0.6) * 14 : 0;
      final wave2 = isPlaying ? cos(phase + i * 0.45) * 10 : 0;

      final yMain = (h * 0.55) - baseRidge - wave;
      final ySoft = (h * 0.50) - (baseRidge * 0.8) + wave2;

      if (i == 0) {
        pathMain.moveTo(x, yMain);
        pathSoft.moveTo(x, ySoft);
      } else {
        pathMain.lineTo(x, yMain);
        pathSoft.lineTo(x, ySoft);
      }
    }

    canvas.drawPath(pathSoft, paintSoft);
    canvas.drawPath(pathMain, paintMain);
  }

  @override
  bool shouldRepaint(covariant _MountainPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isPlaying != isPlaying;
  }
}
