import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/router.dart';
import '../../models/fuel_entry.dart';
import '../../providers/fuel_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/auth/budibuddy_button.dart';
import '../../widgets/dashboard/fuel_type_pie.dart';
import '../../widgets/dashboard/monthly_bar_chart.dart';
import '../../widgets/dashboard/spending_chart.dart';
import '../../widgets/dashboard/stat_summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  double _co2FactorFor(String fuelType) {
    return fuelType == 'Diesel' ? 2.68 : 2.31;
  }

  double _totalCo2(List<FuelEntry> entries) {
    return entries.fold(0.0, (sum, e) => sum + e.litres * _co2FactorFor(e.fuelType));
  }

  List<Map<String, dynamic>> _monthlySpendingData(
    FuelProvider fuelProvider,
    String vehicleId,
  ) {
    final now = DateTime.now();
    final data = <Map<String, dynamic>>[];
    for (var i = 5; i >= 0; i--) {
      final monthDate = DateTime(now.year, now.month - i, 1);
      final nextMonth = DateTime(monthDate.year, monthDate.month + 1, 1);
      final amount = fuelProvider.allEntries
          .where((e) =>
              e.vehicleId == vehicleId &&
              !e.date.isBefore(monthDate) &&
              e.date.isBefore(nextMonth))
          .fold(0.0, (sum, e) => sum + e.totalCost);
      data.add({'month': DateFormat('MMM').format(monthDate), 'amount': amount});
    }

    final monthsWithData = data.where((m) => (m['amount'] as double) > 0).length;
    if (monthsWithData < 6) {
      for (var i = 0; i < data.length; i++) {
        if ((data[i]['amount'] as double) <= 0 && i < MockData.monthlySpending.length) {
          data[i] = {
            'month': data[i]['month'],
            'amount': MockData.monthlySpending[i]['amount'],
          };
        }
      }
    }
    return data;
  }

  Map<String, double> _fuelTypeData(List<FuelEntry> entries) {
    final data = <String, double>{};
    for (final e in entries) {
      data[e.fuelType] = (data[e.fuelType] ?? 0) + e.totalCost;
    }
    return data;
  }

  String _mostVisitedStation(List<FuelEntry> entries) {
    if (entries.isEmpty) return '-';
    final counts = <String, int>{};
    for (final e in entries) {
      counts[e.stationName] = (counts[e.stationName] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: kFontSM, color: kTextSecondary),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: kFontSM,
              fontWeight: FontWeight.w600,
              color: kPrimaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kSpaceMD),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kSurfaceGreen),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: kFontMD,
              fontWeight: FontWeight.w600,
              color: kPrimaryGreen,
            ),
          ),
          const SizedBox(height: kSpaceMD),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNeutralBg,
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        elevation: 0,
        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kWhite,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.assessment_outlined, color: kWhite),
            tooltip: 'Full Reports',
            onPressed: () => context.push(RoutePaths.reportsDetail),
          ),
        ],
      ),
      body: Consumer2<FuelProvider, VehicleProvider>(
        builder: (context, fuelProvider, vehicleProvider, _) {
          final activeVehicle = vehicleProvider.activeVehicle;

          if (activeVehicle == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No active vehicle selected. Please add a vehicle first.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: kFontMD, color: kTextSecondary),
                ),
              ),
            );
          }

          final entries = fuelProvider.entriesForVehicle(activeVehicle.id);

          final now = DateTime.now();
          final monthStart = DateTime(now.year, now.month, 1);
          final lastMonthStart = DateTime(now.year, now.month - 1, 1);

          final monthlySpend =
              fuelProvider.totalSpendingForVehicle(activeVehicle.id, from: monthStart);
          final lastMonthSpend = fuelProvider.totalSpendingForVehicle(
            activeVehicle.id,
            from: lastMonthStart,
            to: monthStart.subtract(const Duration(seconds: 1)),
          );

          final avgEconomy = fuelProvider.averageFuelEconomyForVehicle(activeVehicle.id);

          final thisMonthEntries =
              entries.where((e) => !e.date.isBefore(monthStart)).toList();
          final lastMonthEntries = entries
              .where((e) =>
                  !e.date.isBefore(lastMonthStart) && e.date.isBefore(monthStart))
              .toList();

          final co2ThisMonth = _totalCo2(thisMonthEntries);
          final co2LastMonth = _totalCo2(lastMonthEntries);

          final latest = fuelProvider.latestEntryForVehicle(activeVehicle.id);
          final previous = latest == null
              ? null
              : fuelProvider.previousEntryForVehicle(activeVehicle.id, latest.id);
          final costPerKm =
              latest == null ? 0.0 : fuelProvider.computeCostPerKm(latest, previous);

          final spendChangePercent = lastMonthSpend > 0
              ? ((monthlySpend - lastMonthSpend) / lastMonthSpend * 100)
              : 0.0;
          final co2ChangePercent = co2LastMonth > 0
              ? ((co2ThisMonth - co2LastMonth) / co2LastMonth * 100)
              : 0.0;

          final totalLitres = entries.fold(0.0, (sum, e) => sum + e.litres);
          final totalSpending = fuelProvider.totalSpendingForVehicle(activeVehicle.id);
          final avgPerFillUp = entries.isEmpty ? 0.0 : totalSpending / entries.length;

          final monthlyData = _monthlySpendingData(fuelProvider, activeVehicle.id);
          final fuelTypeData = _fuelTypeData(entries);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  color: kPrimaryGreen,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overview',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: kWhite.withValues(alpha: 0.7),
                        ),
                      ),
                      Text(
                        activeVehicle.displayName,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: kWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: kSurfaceGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.directions_car, color: kPrimaryGreen, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Showing data for ${activeVehicle.displayName}',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(fontSize: 12, color: kPrimaryGreen),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.go(RoutePaths.garage),
                        child: Text(
                          'Switch >',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: kPrimaryGreen,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(kSpaceMD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: kSpaceMD,
                          crossAxisSpacing: kSpaceMD,
                          childAspectRatio: 1.1,
                        ),
                        children: [
                          StatSummaryCard(
                            label: 'This Month',
                            value: 'RM ${monthlySpend.toStringAsFixed(2)}',
                            subtitle: lastMonthSpend > 0
                                ? '${spendChangePercent >= 0 ? '+' : ''}${spendChangePercent.toStringAsFixed(0)}% vs last month'
                                : 'No data for last month',
                            icon: Icons.account_balance_wallet_outlined,
                            trend: lastMonthSpend > 0
                                ? (spendChangePercent > 0
                                    ? TrendDirection.up
                                    : spendChangePercent < 0
                                        ? TrendDirection.down
                                        : TrendDirection.neutral)
                                : null,
                            trendColor:
                                spendChangePercent > 0 ? kError : kAccentGreen,
                          ),
                          StatSummaryCard(
                            label: 'Fuel Economy',
                            value: '${avgEconomy.toStringAsFixed(1)} km/L',
                            subtitle: 'Overall average',
                            icon: Icons.speed_outlined,
                          ),
                          StatSummaryCard(
                            label: 'CO₂ Emissions',
                            value: '${co2ThisMonth.toStringAsFixed(1)} kg',
                            subtitle: co2LastMonth > 0
                                ? '${co2ChangePercent >= 0 ? '+' : ''}${co2ChangePercent.toStringAsFixed(0)}% vs last month'
                                : 'This month',
                            icon: Icons.eco_outlined,
                            trend: co2LastMonth > 0
                                ? (co2ChangePercent > 0
                                    ? TrendDirection.up
                                    : co2ChangePercent < 0
                                        ? TrendDirection.down
                                        : TrendDirection.neutral)
                                : null,
                            trendColor: co2ChangePercent > 0 ? kError : kAccentGreen,
                          ),
                          StatSummaryCard(
                            label: 'Cost per KM',
                            value: 'RM ${costPerKm.toStringAsFixed(2)}',
                            subtitle: 'Latest fill-up',
                            icon: Icons.route_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: kSpaceLG),
                      _sectionCard(
                        title: 'Spending Trend',
                        child: SpendingChart(monthlyData: monthlyData),
                      ),
                      const SizedBox(height: kSpaceLG),
                      _sectionCard(
                        title: 'Monthly Comparison',
                        child: MonthlyBarChart(monthlyData: monthlyData),
                      ),
                      const SizedBox(height: kSpaceLG),
                      _sectionCard(
                        title: 'Fuel Type Breakdown',
                        child: FuelTypePie(fuelTypeData: fuelTypeData),
                      ),
                      const SizedBox(height: kSpaceLG),
                      _sectionCard(
                        title: 'Quick Summary',
                        child: Column(
                          children: [
                            _summaryRow('Total Fill-ups', '${entries.length}'),
                            _summaryRow(
                              'Total Litres',
                              '${totalLitres.toStringAsFixed(1)} L',
                            ),
                            _summaryRow(
                              'Total Spending',
                              'RM ${totalSpending.toStringAsFixed(2)}',
                            ),
                            _summaryRow(
                              'Average per Fill-up',
                              'RM ${avgPerFillUp.toStringAsFixed(2)}',
                            ),
                            _summaryRow(
                              'Most Visited Station',
                              _mostVisitedStation(entries),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: kSpaceLG),
                      BudiBuddyButton(
                        label: 'View Full Reports',
                        icon: Icons.bar_chart,
                        onPressed: () => context.push(RoutePaths.reportsDetail),
                      ),
                      const SizedBox(height: kSpaceLG),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
