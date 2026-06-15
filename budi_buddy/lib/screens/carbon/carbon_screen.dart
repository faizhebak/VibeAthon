import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/router.dart';
import '../../providers/carbon_provider.dart';
import '../../providers/fuel_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/carbon/co2_summary_card.dart';
import '../../widgets/carbon/emission_chart.dart';
import '../../widgets/carbon/reduction_tip_card.dart';
import '../../widgets/common/premium_banner.dart';

class CarbonScreen extends StatelessWidget {
  const CarbonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activeVehicle = context.watch<VehicleProvider>().activeVehicle;
    final entries = context.watch<FuelProvider>().entriesForVehicle(
      activeVehicle?.id ?? '',
    );
    final carbonProvider = context.read<CarbonProvider>();

    final co2ThisMonth = carbonProvider.co2ThisMonth(entries);
    final co2LastMonth = carbonProvider.co2LastMonth(entries);
    final treesNeeded = carbonProvider.treesNeededToOffset(co2ThisMonth);
    final personalBest = carbonProvider.personalBestMonthlyCo2(entries);
    final monthlyBreakdown = carbonProvider.monthlyCo2Breakdown(entries);

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
          'Carbon Footprint',
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
            Co2SummaryCard(
              co2Kg: co2ThisMonth,
              treesNeeded: treesNeeded,
              personalBest: personalBest,
              lastMonth: co2LastMonth,
            ),
            const SizedBox(height: kSpaceLG),
            const PremiumBanner(
              title: 'Unlock Carbon Insights',
              description:
                  'Get detailed emission breakdowns, offset suggestions, and personalised reduction plans with BudiBuddy Premium.',
            ),
            const SizedBox(height: kSpaceLG),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const _SectionLabel(text: 'Emissions Trend'),
                GestureDetector(
                  onTap: () => context.push(RoutePaths.carbonDetail),
                  child: Row(
                    children: [
                      Text(
                        'View Details',
                        style: GoogleFonts.poppins(
                          fontSize: kFontXS,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryGreen,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 10,
                        color: kPrimaryGreen,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
            const _SectionLabel(text: 'Reduction Tips'),
            const SizedBox(height: kSpaceSM),
            for (final tip in MockData.carbonReductionTips) ...[
              ReductionTipCard(tip: tip),
              const SizedBox(height: kSpaceSM),
            ],
          ],
        ),
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
