import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/mock_data.dart';
import '../models/fuel_entry.dart';

class CarbonProvider extends ChangeNotifier {
  final bool _isLoading = false;

  bool get isLoading => _isLoading;

  double _co2FactorForFuelType(String fuelType) {
    return fuelType == 'Diesel'
        ? MockData.co2PerLitreDiesel
        : MockData.co2PerLitrePetrol;
  }

  double co2ForEntry(FuelEntry entry) {
    return entry.litres * _co2FactorForFuelType(entry.fuelType);
  }

  double totalCo2ForEntries(List<FuelEntry> entries) {
    if (entries.isEmpty) return 0.0;
    return entries.fold(0.0, (sum, e) => sum + co2ForEntry(e));
  }

  double treesNeededToOffset(double co2Kg) {
    final trees = co2Kg / MockData.co2PerTreePerYear;
    return double.parse(trees.toStringAsFixed(1));
  }

  double monthlyAverageCo2(List<FuelEntry> entries) {
    if (entries.isEmpty) return 0.0;
    final monthlyTotals = _monthlyTotals(entries);
    if (monthlyTotals.isEmpty) return 0.0;
    final total = monthlyTotals.values.fold(0.0, (sum, v) => sum + v);
    return total / monthlyTotals.length;
  }

  List<Map<String, dynamic>> monthlyCo2Breakdown(List<FuelEntry> entries) {
    final now = DateTime.now();
    final result = <Map<String, dynamic>>[];

    for (var i = 5; i >= 0; i--) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      final monthLabel = DateFormat('MMM').format(monthDate);
      final monthEntries = entries
          .where(
            (e) =>
                e.date.year == monthDate.year &&
                e.date.month == monthDate.month,
          )
          .toList();
      final co2 = totalCo2ForEntries(monthEntries);

      if (co2 > 0) {
        result.add({'month': monthLabel, 'co2': co2});
      } else {
        final fallback = MockData.monthlyCarbon.firstWhere(
          (m) => m['month'] == monthLabel,
          orElse: () => {'month': monthLabel, 'co2': 0.0},
        );
        result.add({'month': monthLabel, 'co2': fallback['co2'] as double});
      }
    }

    return result;
  }

  double co2ThisMonth(List<FuelEntry> entries) {
    final now = DateTime.now();
    final filtered = entries
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .toList();
    return totalCo2ForEntries(filtered);
  }

  double co2LastMonth(List<FuelEntry> entries) {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, 1);
    final filtered = entries
        .where(
          (e) =>
              e.date.year == lastMonth.year && e.date.month == lastMonth.month,
        )
        .toList();
    return totalCo2ForEntries(filtered);
  }

  double personalBestMonthlyCo2(List<FuelEntry> entries) {
    final monthlyTotals = _monthlyTotals(entries);
    if (monthlyTotals.isEmpty) return 0.0;
    return monthlyTotals.values.reduce((a, b) => a < b ? a : b);
  }

  Map<String, double> _monthlyTotals(List<FuelEntry> entries) {
    final monthlyTotals = <String, double>{};
    for (final entry in entries) {
      final key = '${entry.date.year}-${entry.date.month}';
      monthlyTotals[key] = (monthlyTotals[key] ?? 0.0) + co2ForEntry(entry);
    }
    return monthlyTotals;
  }
}
