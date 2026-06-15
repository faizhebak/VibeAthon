import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../models/fuel_entry.dart';
import '../../providers/carbon_provider.dart';
import '../../providers/fuel_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/carbon/emission_chart.dart';
import '../../widgets/common/premium_banner.dart';

class CarbonDetailScreen extends StatelessWidget {
  const CarbonDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activeVehicle = context.watch<VehicleProvider>().activeVehicle;
    final entries = context.watch<FuelProvider>().entriesForVehicle(
      activeVehicle?.id ?? '',
    );
    final carbonProvider = context.read<CarbonProvider>();

    final totalCo2 = carbonProvider.totalCo2ForEntries(entries);
    final treesNeeded = carbonProvider.treesNeededToOffset(totalCo2);
    final monthlyAvg = carbonProvider.monthlyAverageCo2(entries);
    final monthlyBreakdown = carbonProvider.monthlyCo2Breakdown(entries);

    final sortedEntries = [...entries]
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      backgroundColor: kNeutralBg,
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kWhite),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Emission Details',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kWhite,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kSpaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCard(totalCo2, monthlyAvg, treesNeeded),
            const SizedBox(height: kSpaceLG),
            const _SectionLabel(text: 'Tree Offset Visualiser'),
            const SizedBox(height: kSpaceSM),
            _buildTreeVisualiser(treesNeeded),
            const SizedBox(height: kSpaceLG),
            const _SectionLabel(text: '6-Month Trend'),
            const SizedBox(height: kSpaceSM),
            Container(
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(kRadiusLG),
                border: Border.all(color: kSurfaceGreen),
              ),
              padding: const EdgeInsets.all(kSpaceMD),
              child: EmissionChart(monthlyData: monthlyBreakdown),
            ),
            const SizedBox(height: kSpaceLG),
            const PremiumBanner(
              title: 'Unlock Full Emission History',
              description:
                  'See entry-by-entry CO2 contributions, export reports, and get AI-powered offset recommendations with BudiBuddy Premium.',
            ),
            const SizedBox(height: kSpaceLG),
            const _SectionLabel(text: 'Emission by Fuel Entry'),
            const SizedBox(height: kSpaceSM),
            if (sortedEntries.isEmpty)
              _buildEmptyEntries()
            else
              _buildEntryTable(sortedEntries, carbonProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(
    double totalCo2,
    double monthlyAvg,
    double treesNeeded,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kSpaceMD),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kSurfaceGreen),
      ),
      child: Row(
        children: [
          Expanded(
            child: _statTile(
              Icons.cloud_outlined,
              'Total CO2',
              '${totalCo2.toStringAsFixed(1)} kg',
            ),
          ),
          Expanded(
            child: _statTile(
              Icons.show_chart,
              'Monthly Avg',
              '${monthlyAvg.toStringAsFixed(1)} kg',
            ),
          ),
          Expanded(
            child: _statTile(
              Icons.park_outlined,
              'Trees Needed',
              treesNeeded.toStringAsFixed(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: kPrimaryGreen, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: kFontMD,
            fontWeight: FontWeight.w700,
            color: kPrimaryGreen,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: kFontXS, color: kTextMuted),
        ),
      ],
    );
  }

  Widget _buildTreeVisualiser(double treesNeeded) {
    final treeCount = treesNeeded.ceil();
    final displayCount = math.min(treeCount, 10);
    final overflow = treeCount - displayCount;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kSurfaceGreen),
      ),
      padding: const EdgeInsets.all(kSpaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You would need approximately ${treesNeeded.toStringAsFixed(1)} trees growing for one year to offset this footprint.',
            style: GoogleFonts.poppins(
              fontSize: kFontSM,
              color: kTextSecondary,
            ),
          ),
          const SizedBox(height: kSpaceMD),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < displayCount; i++)
                const Icon(Icons.park, color: kAccentGreen, size: 28),
              if (overflow > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: kSurfaceGreen,
                    borderRadius: BorderRadius.circular(kRadiusSM),
                  ),
                  child: Text(
                    '+$overflow more',
                    style: GoogleFonts.poppins(
                      fontSize: kFontXS,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryGreen,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEntryTable(
    List<FuelEntry> entries,
    CarbonProvider carbonProvider,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kSurfaceGreen),
      ),
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            _entryRow(entries[i], carbonProvider),
            if (i != entries.length - 1)
              const Divider(color: kSurfaceGreen, height: 1),
          ],
        ],
      ),
    );
  }

  Widget _entryRow(FuelEntry entry, CarbonProvider carbonProvider) {
    final co2 = carbonProvider.co2ForEntry(entry);
    final isDiesel = entry.fuelType == 'Diesel';
    return Padding(
      padding: const EdgeInsets.all(kSpaceMD),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: kSurfaceGreen,
              borderRadius: BorderRadius.circular(kRadiusSM),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              isDiesel
                  ? Icons.local_shipping_outlined
                  : Icons.local_gas_station_outlined,
              color: isDiesel ? kGrayMid : kPrimaryGreen,
              size: 18,
            ),
          ),
          const SizedBox(width: kSpaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('d MMM yyyy').format(entry.date),
                  style: GoogleFonts.poppins(
                    fontSize: kFontSM,
                    fontWeight: FontWeight.w600,
                    color: kTextPrimary,
                  ),
                ),
                Text(
                  '${entry.fuelType} • ${entry.litres.toStringAsFixed(1)} L',
                  style: GoogleFonts.poppins(
                    fontSize: kFontXS,
                    color: kTextMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${co2.toStringAsFixed(2)} kg',
            style: GoogleFonts.poppins(
              fontSize: kFontSM,
              fontWeight: FontWeight.w700,
              color: kPrimaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyEntries() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kSpaceLG),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kSurfaceGreen),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.local_gas_station_outlined,
            color: kTextMuted,
            size: 32,
          ),
          const SizedBox(height: kSpaceSM),
          Text(
            'No fuel entries recorded yet.',
            style: GoogleFonts.poppins(fontSize: kFontSM, color: kTextMuted),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: kFontXS,
        fontWeight: FontWeight.w600,
        color: kTextMuted,
        letterSpacing: 0.08,
      ),
    );
  }
}
