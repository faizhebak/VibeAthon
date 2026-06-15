import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../models/trip_record.dart';
import '../../providers/driving_provider.dart';
import '../../widgets/driving/efficiency_score_ring.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key, required this.tripId});

  final String tripId;

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

  double _kmPerLitre(TripRecord trip) {
    if (trip.fuelUsedL <= 0) return 0.0;
    return trip.distanceKm / trip.fuelUsedL;
  }

  @override
  Widget build(BuildContext context) {
    final trip = context.watch<DrivingProvider>().tripById(tripId);

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
          'Trip Details',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kWhite,
          ),
        ),
      ),
      body: trip == null ? _buildNotFound() : _buildBody(trip),
    );
  }

  Widget _buildNotFound() {
    return Center(
      child: Text(
        'Trip not found.',
        style: GoogleFonts.poppins(fontSize: kFontSM, color: kTextMuted),
      ),
    );
  }

  Widget _buildBody(TripRecord trip) {
    final scoreColor = _scoreColor(trip.efficiencyScore);
    final grade = _gradeForScore(trip.efficiencyScore);
    final kmPerLitre = _kmPerLitre(trip);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(kSpaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScoreCard(trip, scoreColor, grade),
          const SizedBox(height: kSpaceLG),
          const _SectionLabel(text: 'Trip Summary'),
          const SizedBox(height: kSpaceSM),
          _buildStatsGrid(trip, kmPerLitre),
          const SizedBox(height: kSpaceLG),
          const _SectionLabel(text: 'Driving Behaviour'),
          const SizedBox(height: kSpaceSM),
          _buildBreakdownCard(trip),
          const SizedBox(height: kSpaceLG),
          const _SectionLabel(text: 'Feedback'),
          const SizedBox(height: kSpaceSM),
          _buildFeedbackCard(trip),
        ],
      ),
    );
  }

  Widget _buildScoreCard(TripRecord trip, Color scoreColor, String grade) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kSpaceMD),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kSurfaceGreen),
      ),
      child: Column(
        children: [
          Text(
            DateFormat('EEEE, d MMMM yyyy').format(trip.date),
            style: GoogleFonts.poppins(
              fontSize: kFontSM,
              fontWeight: FontWeight.w600,
              color: kPrimaryGreen,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat('h:mm a').format(trip.date),
            style: GoogleFonts.poppins(fontSize: kFontXS, color: kTextMuted),
          ),
          const SizedBox(height: kSpaceMD),
          EfficiencyScoreRing(score: trip.efficiencyScore, size: 140),
          const SizedBox(height: kSpaceMD),
          Container(
            decoration: BoxDecoration(
              color: scoreColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(kRadiusXL),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Text(
              'Grade $grade',
              style: GoogleFonts.poppins(
                fontSize: kFontSM,
                fontWeight: FontWeight.w700,
                color: scoreColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(TripRecord trip, double kmPerLitre) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kSurfaceGreen),
      ),
      padding: const EdgeInsets.all(kSpaceMD),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _statTile(
                  Icons.route_outlined,
                  'Distance',
                  '${trip.distanceKm.toStringAsFixed(1)} km',
                ),
              ),
              Expanded(
                child: _statTile(
                  Icons.timer_outlined,
                  'Duration',
                  '${trip.durationMinutes} min',
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpaceMD),
          Row(
            children: [
              Expanded(
                child: _statTile(
                  Icons.local_gas_station_outlined,
                  'Fuel Used',
                  '${trip.fuelUsedL.toStringAsFixed(1)} L',
                ),
              ),
              Expanded(
                child: _statTile(
                  Icons.speed_outlined,
                  'Avg Speed',
                  '${trip.avgSpeedKmh.toStringAsFixed(0)} km/h',
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpaceMD),
          Row(
            children: [
              Expanded(
                child: _statTile(
                  Icons.local_gas_station,
                  'Fuel Economy',
                  kmPerLitre > 0
                      ? '${kmPerLitre.toStringAsFixed(1)} km/L'
                      : '—',
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statTile(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: kPrimaryGreen, size: 20),
        const SizedBox(width: kSpaceSM),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: kFontMD,
                fontWeight: FontWeight.w600,
                color: kPrimaryGreen,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: kFontXS, color: kTextMuted),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBreakdownCard(TripRecord trip) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kSurfaceGreen),
      ),
      padding: const EdgeInsets.all(kSpaceMD),
      child: Column(
        children: [
          _breakdownRow('Acceleration', trip.accelerationScore),
          const SizedBox(height: kSpaceMD),
          _breakdownRow('Braking', trip.brakingScore),
          const SizedBox(height: kSpaceMD),
          _breakdownRow('Speed Consistency', trip.speedConsistencyScore),
        ],
      ),
    );
  }

  Widget _breakdownRow(String label, int score) {
    final color = _scoreColor(score);
    final value = (score / 100).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: kFontSM,
                fontWeight: FontWeight.w500,
                color: kPrimaryGreen,
              ),
            ),
            Text(
              '$score / 100',
              style: GoogleFonts.poppins(
                fontSize: kFontSM,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(kRadiusSM),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: kSurfaceGreen,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackCard(TripRecord trip) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kSurfaceGreen,
        borderRadius: BorderRadius.circular(kRadiusLG),
      ),
      padding: const EdgeInsets.all(kSpaceMD),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline, color: kPrimaryGreen, size: 20),
          const SizedBox(width: kSpaceSM),
          Expanded(
            child: Text(
              trip.feedbackMessage,
              style: GoogleFonts.poppins(
                fontSize: kFontSM,
                color: kPrimaryGreen,
              ),
            ),
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
