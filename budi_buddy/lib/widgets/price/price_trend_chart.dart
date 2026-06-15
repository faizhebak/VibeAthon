import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';
import '../../models/fuel_price.dart';

class PriceTrendChart extends StatelessWidget {
  const PriceTrendChart({
    super.key,
    required this.priceHistory,
    required this.visibleFuelTypes,
    this.height,
  });

  final List<FuelPrice> priceHistory;
  final Set<String> visibleFuelTypes;
  final double? height;

  @override
  Widget build(BuildContext context) {
    if (priceHistory.isEmpty) {
      return SizedBox(
        height: height ?? 220,
        child: Center(
          child: Text(
            'No price data available.',
            style: GoogleFonts.poppins(fontSize: 13, color: kTextMuted),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: height ?? 220,
          width: double.infinity,
          child: LineChart(_buildChartData()),
        ),
      ],
    );
  }

  List<double> get _visibleValues {
    final values = <double>[];
    for (final entry in priceHistory) {
      if (visibleFuelTypes.contains('RON95')) values.add(entry.ron95);
      if (visibleFuelTypes.contains('RON97')) values.add(entry.ron97);
      if (visibleFuelTypes.contains('Diesel')) values.add(entry.diesel);
    }
    return values;
  }

  double get _minY {
    final values = _visibleValues;
    if (values.isEmpty) return 1.90;
    final minCents = values.map((v) => (v * 100).round()).reduce(
          (a, b) => a < b ? a : b,
        ) -
        10;
    final flooredCents = (minCents / 5).floor() * 5;
    final result = flooredCents / 100;
    return result < 1.90 ? 1.90 : result;
  }

  double get _maxY {
    final values = _visibleValues;
    if (values.isEmpty) return 4.00;
    final maxCents = values.map((v) => (v * 100).round()).reduce(
              (a, b) => a > b ? a : b,
            ) +
        10;
    final ceiledCents = (maxCents / 5).ceil() * 5;
    final result = ceiledCents / 100;
    return result > 4.00 ? 4.00 : result;
  }

  LineChartData _buildChartData() {
    final minY = _minY;
    final maxY = _maxY;

    return LineChartData(
      minX: 0,
      maxX: (priceHistory.length - 1).toDouble(),
      minY: minY,
      maxY: maxY,
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 2,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= priceHistory.length) {
                return const SizedBox.shrink();
              }
              if (index % 2 != 0) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'W${index + 1}',
                  style: GoogleFonts.poppins(fontSize: 10, color: kTextMuted),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 48,
            interval: 0.10,
            getTitlesWidget: (value, meta) {
              final steps = ((value - minY) / 0.10).round();
              if (steps % 2 != 0) return const SizedBox.shrink();
              return Text(
                'RM ${value.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(fontSize: 9, color: kTextMuted),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 0.10,
        getDrawingHorizontalLine: (value) =>
            const FlLine(color: kSurfaceGreen, strokeWidth: 1),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: kSurfaceGreen, width: 1.0),
          left: BorderSide(color: kSurfaceGreen, width: 1.0),
        ),
      ),
      lineBarsData: [
        if (visibleFuelTypes.contains('RON95'))
          LineChartBarData(
            spots: priceHistory
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.ron95))
                .toList(),
            isCurved: false,
            color: kPrimaryGreen,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        if (visibleFuelTypes.contains('RON97'))
          LineChartBarData(
            spots: priceHistory
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.ron97))
                .toList(),
            isCurved: true,
            curveSmoothness: 0.3,
            color: kPrimaryAmber,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        if (visibleFuelTypes.contains('Diesel'))
          LineChartBarData(
            spots: priceHistory
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.diesel))
                .toList(),
            isCurved: true,
            curveSmoothness: 0.3,
            color: kGrayMid,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
      ],
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => kPrimaryGreen,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              String fuelLabel;
              if (spot.bar.color == kPrimaryGreen) {
                fuelLabel = 'RON95';
              } else if (spot.bar.color == kPrimaryAmber) {
                fuelLabel = 'RON97';
              } else {
                fuelLabel = 'Diesel';
              }
              return LineTooltipItem(
                '$fuelLabel\nRM ${spot.y.toStringAsFixed(2)}',
                GoogleFonts.poppins(
                  color: kPrimaryAmber,
                  fontSize: 11,
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
