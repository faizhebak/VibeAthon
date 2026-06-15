import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

class EfficiencyScoreRing extends StatelessWidget {
  const EfficiencyScoreRing({
    super.key,
    required this.score,
    this.size = 120,
    this.strokeWidth = 12,
  });

  final int score;
  final double size;
  final double strokeWidth;

  Color get _scoreColor {
    if (score >= 85) return kAccentGreen;
    if (score >= 70) return kPrimaryGreen;
    if (score >= 55) return kDeepAmber;
    return kError;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _EfficiencyRingPainter(
          score: score,
          color: _scoreColor,
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: GoogleFonts.poppins(
                  fontSize: kFontXXL,
                  fontWeight: FontWeight.w700,
                  color: _scoreColor,
                ),
              ),
              Text(
                '/ 100',
                style: GoogleFonts.poppins(
                  fontSize: kFontXS,
                  color: kTextMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EfficiencyRingPainter extends CustomPainter {
  _EfficiencyRingPainter({
    required this.score,
    required this.color,
    required this.strokeWidth,
  });

  final int score;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = kSurfaceGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final foregroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final clampedScore = score.clamp(0, 100);
    final sweepAngle = 2 * pi * (clampedScore / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _EfficiencyRingPainter oldDelegate) {
    return oldDelegate.score != score ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
