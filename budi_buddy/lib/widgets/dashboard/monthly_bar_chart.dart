import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

class MonthlyBarChart extends StatefulWidget {
  const MonthlyBarChart({super.key, required this.monthlyData, this.selectedIndex});

  final List<Map<String, dynamic>> monthlyData;
  final int? selectedIndex;

  @override
  State<MonthlyBarChart> createState() => _MonthlyBarChartState();
}

class _MonthlyBarChartState extends State<MonthlyBarChart> {
  late int _touchedIndex;

  @override
  void initState() {
    super.initState();
    _touchedIndex = widget.selectedIndex ?? (widget.monthlyData.length - 1);
  }

  double get _maxAmount {
    if (widget.monthlyData.isEmpty) return 0;
    return widget.monthlyData
        .map((e) => e['amount'] as double)
        .reduce((a, b) => a > b ? a : b);
  }

  double get _maxY {
    final max = _maxAmount;
    if (max <= 0) return 100;
    final roundedUp = (max / 100).ceil() * 100;
    return roundedUp + 30;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.monthlyData.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Text(
          'No data available',
          style: GoogleFonts.poppins(fontSize: 13, color: kTextMuted),
        ),
      );
    }

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: BarChart(_mainData()),
    );
  }

  BarChartData _mainData() {
    return BarChartData(
      maxY: _maxY,
      barTouchData: BarTouchData(
        touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
          if (response != null && response.spot != null) {
            setState(() {
              _touchedIndex = response.spot!.touchedBarGroupIndex;
            });
          }
        },
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => kPrimaryGreen,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              'RM ${rod.toY.toStringAsFixed(0)}',
              GoogleFonts.poppins(
                color: kPrimaryAmber,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= widget.monthlyData.length) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  widget.monthlyData[index]['month'] as String,
                  style: GoogleFonts.poppins(fontSize: 11, color: kTextMuted),
                ),
              );
            },
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: widget.monthlyData.asMap().entries.map((e) {
        final isTouched = e.key == _touchedIndex;
        return BarChartGroupData(
          x: e.key,
          barRods: [
            BarChartRodData(
              toY: e.value['amount'] as double,
              color: isTouched ? kPrimaryAmber : kPrimaryGreen,
              width: 28,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: _maxY,
                color: kSurfaceGreen,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
