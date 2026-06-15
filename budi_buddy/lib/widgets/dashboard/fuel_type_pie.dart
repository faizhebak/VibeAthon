import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

class FuelTypePie extends StatelessWidget {
  const FuelTypePie({
    super.key,
    required this.fuelTypeData,
    this.centerLabel = 'Fuel Type',
    this.size,
  });

  final Map<String, double> fuelTypeData;
  final String centerLabel;
  final double? size;

  double get _total => fuelTypeData.values.fold(0.0, (a, b) => a + b);

  Color _colorForFuelType(String type) {
    switch (type) {
      case 'RON95':
        return kPrimaryGreen;
      case 'RON97':
        return kPrimaryAmber;
      case 'Diesel':
        return kGrayMid;
      default:
        return kAccentGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fuelTypeData.isEmpty || _total <= 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'No data available',
            style: GoogleFonts.poppins(fontSize: 13, color: kTextMuted),
          ),
        ),
      );
    }

    final chartSize = size ?? 180;

    return Column(
      children: [
        SizedBox(
          height: chartSize,
          width: chartSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 40,
                  sections: fuelTypeData.entries.map((entry) {
                    final percentage = entry.value / _total * 100;
                    return PieChartSectionData(
                      value: entry.value,
                      color: _colorForFuelType(entry.key),
                      radius: 55,
                      title: '${percentage.toStringAsFixed(0)}%',
                      titleStyle: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      titlePositionPercentageOffset: 0.6,
                    );
                  }).toList(),
                  pieTouchData: PieTouchData(enabled: false),
                ),
              ),
              Text(
                centerLabel,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: kTextMuted,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: fuelTypeData.entries.map((entry) {
            final percentage = entry.value / _total * 100;
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _colorForFuelType(entry.key),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    entry.key,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: kTextSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${percentage.toStringAsFixed(0)}%',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryGreen,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
