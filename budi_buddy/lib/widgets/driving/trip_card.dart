import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/constants.dart';
import '../../models/trip_record.dart';

class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip, required this.onTap});

  final TripRecord trip;
  final VoidCallback onTap;

  Color get _scoreColor {
    final score = trip.efficiencyScore;
    if (score >= 85) return kAccentGreen;
    if (score >= 70) return kPrimaryGreen;
    if (score >= 55) return kDeepAmber;
    return kError;
  }

  double get _kmPerLitre {
    if (trip.fuelUsedL <= 0) return 0.0;
    return trip.distanceKm / trip.fuelUsedL;
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = _scoreColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(kRadiusLG),
          border: Border.all(color: kSurfaceGreen),
        ),
        padding: const EdgeInsets.all(kSpaceMD),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: scoreColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.directions_car_outlined,
                color: scoreColor,
                size: 22,
              ),
            ),
            const SizedBox(width: kSpaceMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('d MMM yyyy, h:mm a').format(trip.date),
                    style: GoogleFonts.poppins(
                      fontSize: kFontSM,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${trip.distanceKm.toStringAsFixed(1)} km  •  '
                    '${trip.durationMinutes} min  •  '
                    '${_kmPerLitre.toStringAsFixed(1)} km/L',
                    style: GoogleFonts.poppins(
                      fontSize: kFontXS,
                      color: kTextMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: kSpaceSM),
            Container(
              decoration: BoxDecoration(
                color: scoreColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(kRadiusMD),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                '${trip.efficiencyScore}',
                style: GoogleFonts.poppins(
                  fontSize: kFontBase,
                  fontWeight: FontWeight.w700,
                  color: scoreColor,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: kTextMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
