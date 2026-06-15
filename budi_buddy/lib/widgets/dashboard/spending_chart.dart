import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

class SpendingChart extends StatelessWidget {
  const SpendingChart({super.key, required this.monthlyData, this.height});

  final List<Map<String, dynamic>> monthlyData;
  final double? height;

  double get _maxAmount {
    if (monthlyData.isEmpty) return 0;
    return monthlyData
        .map((e) => e['amount'] as double)
        .reduce((a, b) => a > b ? a : b);
  }

  double get _maxY {
    final max = _maxAmount;
    if (max <= 0) return 100;
    final roundedUp = (max / 100).ceil() * 100;
    return roundedUp + 50;
  }

  double get _horizontalInterval {
    final interval = _maxY / 4;
    final rounded = (interval / 50).round() * 50;
    return rounded <= 0 ? 50 : rounded.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    if (monthlyData.isEmpty) {
      return Container(
        height: height ?? 200,
        alignment: Alignment.center,
        child: Text(
          'No data available',
          style: GoogleFonts.poppins(fontSize: 13, color: kTextMuted),
        ),
      );
    }

    return SizedBox(
      height: height ?? 200,
      width: double.infinity,
      child: LineChart(_mainData()),
    );
  }

  LineChartData _mainData() {
    return LineChartData(
      minX: 0,
      maxX: (monthlyData.length - 1).toDouble(),
      minY: 0,
      maxY: _maxY,
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= monthlyData.length) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  monthlyData[index]['month'] as String,
                  style: GoogleFonts.poppins(fontSize: 11, color: kTextMuted),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 44,
            getTitlesWidget: (value, meta) {
              if (value == 0) return const SizedBox.shrink();
              return Text(
                'RM ${value.toInt()}',
                style: GoogleFonts.poppins(fontSize: 10, color: kTextMuted),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: _horizontalInterval,
        getDrawingHorizontalLine: (value) =>
            const FlLine(color: kSurfaceGreen, strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: monthlyData
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value['amount'] as double))
              .toList(),
          isCurved: true,
          curveSmoothness: 0.35,
          color: kPrimaryGreen,
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
              radius: 5,
              color: kPrimaryAmber,
              strokeColor: kPrimaryGreen,
              strokeWidth: 2,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            color: kPrimaryGreen.withValues(alpha: 0.08),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => kPrimaryGreen,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                'RM ${spot.y.toStringAsFixed(2)}',
                GoogleFonts.poppins(
                  color: kPrimaryAmber,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
