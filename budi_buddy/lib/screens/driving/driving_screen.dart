import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/router.dart';
import '../../models/trip_record.dart';
import '../../providers/driving_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/common/premium_banner.dart';
import '../../widgets/driving/efficiency_score_ring.dart';
import '../../widgets/driving/tip_card.dart';
import '../../widgets/driving/trip_card.dart';

class DrivingScreen extends StatelessWidget {
  const DrivingScreen({super.key});

  Color _scoreColor(int score) {
    if (score >= 85) return kAccentGreen;
    if (score >= 70) return kPrimaryGreen;
    if (score >= 55) return kDeepAmber;
    return kError;
  }

  String _gradeForScore(int score) {
    if (score >= 90) return 'A';
    if (score >= 85) return 'A-';
    if (score >= 80) return 'B+';
    if (score >= 70) return 'B';
    if (score >= 60) return 'C';
    return 'D';
  }

  @override
  Widget build(BuildContext context) {
    final drivingProvider = context.watch<DrivingProvider>();
    final activeVehicle = context.watch<VehicleProvider>().activeVehicle;

    final trips = activeVehicle == null
        ? <TripRecord>[]
        : drivingProvider.tripsForVehicle(activeVehicle.id);

    final overallScore = drivingProvider.overallEfficiencyScore;
    final scoreColor = _scoreColor(overallScore);

    final totalDistance = trips.fold<double>(
      0,
      (sum, t) => sum + t.distanceKm,
    );
    final avgSpeed = trips.isEmpty
        ? 0.0
        : trips.fold<double>(0, (sum, t) => sum + t.avgSpeedKmh) /
            trips.length;

    return Scaffold(
      backgroundColor: kNeutralBg,
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        elevation: 0,
        title: Text(
          'Driving Analysis',
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
            _buildScoreCard(
              drivingProvider,
              overallScore,
              scoreColor,
              trips.length,
              totalDistance,
              avgSpeed,
            ),
            const SizedBox(height: kSpaceLG),
            const PremiumBanner(),
            const SizedBox(height: kSpaceLG),
            const _SectionLabel(text: 'Trip History'),
            const SizedBox(height: kSpaceSM),
            if (trips.isEmpty)
              _buildEmptyTrips()
            else
              for (final trip in trips) ...[
                TripCard(
                  trip: trip,
                  onTap: () => context.push('${RoutePaths.driving}/${trip.id}'),
                ),
                const SizedBox(height: kSpaceSM),
              ],
            const SizedBox(height: kSpaceLG),
            const _SectionLabel(text: 'Tips to Improve Efficiency'),
            const SizedBox(height: kSpaceSM),
            for (final tip in drivingProvider.drivingTips) ...[
              TipCard(tip: tip),
              const SizedBox(height: kSpaceSM),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(
    DrivingProvider provider,
    int score,
    Color scoreColor,
    int tripCount,
    double totalDistance,
    double avgSpeed,
  ) {
    final grade = _gradeForScore(score);
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EfficiencyScoreRing(score: score),
              const SizedBox(width: kSpaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Efficiency Score',
                          style: GoogleFonts.poppins(
                            fontSize: kFontMD,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryGreen,
                          ),
                        ),
                        const SizedBox(width: kSpaceSM),
                        Container(
                          decoration: BoxDecoration(
                            color: scoreColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(kRadiusSM),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: Text(
                            'Grade $grade',
                            style: GoogleFonts.poppins(
                              fontSize: kFontXS,
                              fontWeight: FontWeight.w700,
                              color: scoreColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: kSpaceXS),
                    Text(
                      provider.efficiencyFeedback,
                      style: GoogleFonts.poppins(
                        fontSize: kFontXS,
                        color: kTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpaceMD),
          const Divider(color: kSurfaceGreen, height: 1),
          const SizedBox(height: kSpaceMD),
          Row(
            children: [
              Expanded(child: _statItem('Trips', '$tripCount')),
              Expanded(
                child: _statItem(
                  'Total Distance',
                  '${totalDistance.toStringAsFixed(1)} km',
                ),
              ),
              Expanded(
                child: _statItem(
                  'Avg Speed',
                  '${avgSpeed.toStringAsFixed(0)} km/h',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: kFontBase,
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

  Widget _buildEmptyTrips() {
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
            Icons.directions_car_outlined,
            color: kTextMuted,
            size: 32,
          ),
          const SizedBox(height: kSpaceSM),
          Text(
            'No trips recorded yet.',
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
