import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../models/fuel_entry.dart';
import '../../providers/fuel_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/auth/budibuddy_button.dart';
import '../../widgets/dashboard/spending_chart.dart';
import '../../widgets/dashboard/stat_summary_card.dart';

enum ReportPeriod { thisMonth, last3Months, last6Months, thisYear, custom }

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  ReportPeriod _selectedPeriod = ReportPeriod.last6Months;
  DateTime? _customFrom;
  DateTime? _customTo;

  String _periodLabel(ReportPeriod period) {
    switch (period) {
      case ReportPeriod.thisMonth:
        return 'This Month';
      case ReportPeriod.last3Months:
        return 'Last 3 Months';
      case ReportPeriod.last6Months:
        return 'Last 6 Months';
      case ReportPeriod.thisYear:
        return 'This Year';
      case ReportPeriod.custom:
        return 'Custom Range';
    }
  }

  DateTimeRange _dateRangeForPeriod(ReportPeriod period) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 23, 59, 59);
    switch (period) {
      case ReportPeriod.thisMonth:
        return DateTimeRange(start: DateTime(now.year, now.month, 1), end: today);
      case ReportPeriod.last3Months:
        return DateTimeRange(start: DateTime(now.year, now.month - 2, 1), end: today);
      case ReportPeriod.last6Months:
        return DateTimeRange(start: DateTime(now.year, now.month - 5, 1), end: today);
      case ReportPeriod.thisYear:
        return DateTimeRange(start: DateTime(now.year, 1, 1), end: today);
      case ReportPeriod.custom:
        final from = _customFrom ?? DateTime(now.year, now.month - 5, 1);
        final to = _customTo ?? today;
        return DateTimeRange(start: from, end: to);
    }
  }

  Future<void> _pickDate(bool isFrom) async {
    final now = DateTime.now();
    final initial = isFrom
        ? (_customFrom ?? DateTime(now.year, now.month - 5, 1))
        : (_customTo ?? now);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
    );
    if (picked == null) return;

    setState(() {
      if (isFrom) {
        _customFrom = picked;
        if (_customTo != null && _customTo!.isBefore(_customFrom!)) {
          _customTo = _customFrom;
        }
      } else {
        _customTo = picked;
        if (_customFrom != null && _customTo!.isBefore(_customFrom!)) {
          _customFrom = _customTo;
        }
      }
      _selectedPeriod = ReportPeriod.custom;
    });
  }

  void _simulateExport(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Export as $format coming soon.')),
    );
  }

  List<Map<String, dynamic>> _monthlyDataForEntries(
    List<FuelEntry> entries,
    DateTimeRange range,
  ) {
    final months = <DateTime>[];
    var cursor = DateTime(range.start.year, range.start.month, 1);
    final end = DateTime(range.end.year, range.end.month, 1);
    while (!cursor.isAfter(end)) {
      months.add(cursor);
      cursor = DateTime(cursor.year, cursor.month + 1, 1);
    }

    return months.map((m) {
      final next = DateTime(m.year, m.month + 1, 1);
      final amount = entries
          .where((e) => !e.date.isBefore(m) && e.date.isBefore(next))
          .fold(0.0, (sum, e) => sum + e.totalCost);
      return {'month': DateFormat('MMM').format(m), 'amount': amount};
    }).toList();
  }

  double _averageEconomyForEntries(
    FuelProvider fuelProvider,
    String vehicleId,
    List<FuelEntry> entries,
  ) {
    final economies = <double>[];
    for (final entry in entries) {
      final previous = fuelProvider.previousEntryForVehicle(vehicleId, entry.id);
      final economy = fuelProvider.computeFuelEconomy(entry, previous);
      if (economy > 0) economies.add(economy);
    }
    if (economies.isEmpty) return 0.0;
    return economies.reduce((a, b) => a + b) / economies.length;
  }

  Widget _periodChip(ReportPeriod period) {
    final isSelected = _selectedPeriod == period;
    return GestureDetector(
      onTap: () => setState(() => _selectedPeriod = period),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryGreen : kSurfaceGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _periodLabel(period),
          style: GoogleFonts.poppins(
            fontSize: kFontSM,
            fontWeight: FontWeight.w600,
            color: isSelected ? kWhite : kPrimaryGreen,
          ),
        ),
      ),
    );
  }

  Widget _dateField(String label, DateTime? date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(kRadiusMD),
          border: Border.all(color: kSurfaceGreen),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(fontSize: kFontXS, color: kTextMuted),
                ),
                Text(
                  date == null ? 'Select date' : DateFormat('d MMM yyyy').format(date),
                  style: GoogleFonts.poppins(
                    fontSize: kFontSM,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryGreen,
                  ),
                ),
              ],
            ),
            const Icon(Icons.calendar_today_outlined, size: 16, color: kPrimaryGreen),
          ],
        ),
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

  Widget _buildEntriesTable(List<FuelEntry> entries) {
    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No data available',
            style: GoogleFonts.poppins(fontSize: 13, color: kTextMuted),
          ),
        ),
      );
    }

    final totalLitres = entries.fold(0.0, (sum, e) => sum + e.litres);
    final totalCost = entries.fold(0.0, (sum, e) => sum + e.totalCost);

    final headerStyle = GoogleFonts.poppins(
      fontSize: kFontXS,
      fontWeight: FontWeight.w600,
      color: kWhite,
    );
    final rowStyle = GoogleFonts.poppins(fontSize: kFontXS, color: kTextSecondary);
    final footerStyle = GoogleFonts.poppins(
      fontSize: kFontXS,
      fontWeight: FontWeight.w700,
      color: kPrimaryGreen,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(kRadiusSM),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: kPrimaryGreen,
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('Date', style: headerStyle)),
                Expanded(flex: 4, child: Text('Station', style: headerStyle)),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Litres',
                    textAlign: TextAlign.right,
                    style: headerStyle,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Total',
                    textAlign: TextAlign.right,
                    style: headerStyle,
                  ),
                ),
              ],
            ),
          ),
          ...entries.asMap().entries.map((indexed) {
            final index = indexed.key;
            final entry = indexed.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              color: index.isEven ? kWhite : kSurfaceGreen,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(DateFormat('d MMM').format(entry.date), style: rowStyle),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      entry.stationName,
                      overflow: TextOverflow.ellipsis,
                      style: rowStyle,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.litres.toStringAsFixed(1),
                      textAlign: TextAlign.right,
                      style: rowStyle,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'RM ${entry.totalCost.toStringAsFixed(2)}',
                      textAlign: TextAlign.right,
                      style: rowStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: kPrimaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: kAmberTint,
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Text('Total', style: footerStyle),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    totalLitres.toStringAsFixed(1),
                    textAlign: TextAlign.right,
                    style: footerStyle,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'RM ${totalCost.toStringAsFixed(2)}',
                    textAlign: TextAlign.right,
                    style: footerStyle,
                  ),
                ),
              ],
            ),
          ),
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
          'Full Reports',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kWhite,
          ),
        ),
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

          final allEntries = fuelProvider.entriesForVehicle(activeVehicle.id);
          final range = _dateRangeForPeriod(_selectedPeriod);
          final filteredEntries = allEntries
              .where((e) => !e.date.isBefore(range.start) && !e.date.isAfter(range.end))
              .toList();

          final totalSpending = filteredEntries.fold(0.0, (sum, e) => sum + e.totalCost);
          final totalLitres = filteredEntries.fold(0.0, (sum, e) => sum + e.litres);
          final avgEconomy = _averageEconomyForEntries(
            fuelProvider,
            activeVehicle.id,
            filteredEntries,
          );

          final monthlyData = _monthlyDataForEntries(filteredEntries, range);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(kSpaceMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activeVehicle.displayName,
                  style: GoogleFonts.poppins(
                    fontSize: kFontMD,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryGreen,
                  ),
                ),
                const SizedBox(height: kSpaceMD),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ReportPeriod.values.map(_periodChip).toList(),
                  ),
                ),
                if (_selectedPeriod == ReportPeriod.custom) ...[
                  const SizedBox(height: kSpaceSM),
                  Row(
                    children: [
                      Expanded(
                        child: _dateField(
                          'From',
                          _customFrom,
                          () => _pickDate(true),
                        ),
                      ),
                      const SizedBox(width: kSpaceSM),
                      Expanded(
                        child: _dateField(
                          'To',
                          _customTo,
                          () => _pickDate(false),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: kSpaceLG),
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
                      label: 'Total Spending',
                      value: 'RM ${totalSpending.toStringAsFixed(2)}',
                      subtitle: _periodLabel(_selectedPeriod),
                      icon: Icons.account_balance_wallet_outlined,
                    ),
                    StatSummaryCard(
                      label: 'Total Litres',
                      value: '${totalLitres.toStringAsFixed(1)} L',
                      subtitle: _periodLabel(_selectedPeriod),
                      icon: Icons.local_gas_station_outlined,
                    ),
                    StatSummaryCard(
                      label: 'Fuel Economy',
                      value: '${avgEconomy.toStringAsFixed(1)} km/L',
                      subtitle: 'Average for period',
                      icon: Icons.speed_outlined,
                    ),
                    StatSummaryCard(
                      label: 'Fill-ups',
                      value: '${filteredEntries.length}',
                      subtitle: _periodLabel(_selectedPeriod),
                      icon: Icons.receipt_long_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: kSpaceLG),
                _sectionCard(
                  title: 'Spending Over Time',
                  child: SpendingChart(monthlyData: monthlyData, height: 160),
                ),
                const SizedBox(height: kSpaceLG),
                _sectionCard(
                  title: 'Fill-up History',
                  child: _buildEntriesTable(filteredEntries),
                ),
                const SizedBox(height: kSpaceLG),
                _sectionCard(
                  title: 'Export Report',
                  child: Row(
                    children: [
                      Expanded(
                        child: BudiBuddyButton(
                          label: 'Export as PDF',
                          icon: Icons.picture_as_pdf_outlined,
                          variant: BudiBuddyButtonVariant.secondary,
                          onPressed: () => _simulateExport('PDF'),
                        ),
                      ),
                      const SizedBox(width: kSpaceSM),
                      Expanded(
                        child: BudiBuddyButton(
                          label: 'Export as CSV',
                          icon: Icons.table_chart_outlined,
                          variant: BudiBuddyButtonVariant.secondary,
                          onPressed: () => _simulateExport('CSV'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kSpaceLG),
              ],
            ),
          );
        },
      ),
    );
  }
}
