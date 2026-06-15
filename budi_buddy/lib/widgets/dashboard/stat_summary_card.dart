import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

enum TrendDirection { up, down, neutral }

class StatSummaryCard extends StatelessWidget {
  const StatSummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.valueColor,
    this.trend,
    this.trendColor,
    this.onTap,
  });

  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color? valueColor;
  final TrendDirection? trend;
  final Color? trendColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(kRadiusLG),
          border: Border.all(color: kSurfaceGreen, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: kSurfaceGreen,
                      borderRadius: BorderRadius.circular(kRadiusMD),
                    ),
                    child: Icon(icon, color: kPrimaryGreen, size: 18),
                  ),
                  if (trend != null)
                    Container(
                      decoration: BoxDecoration(
                        color: trendColor?.withValues(alpha: 0.12) ?? kSurfaceGreen,
                        borderRadius: BorderRadius.circular(kRadiusSM),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      child: Row(
                        children: [
                          Icon(
                            trend == TrendDirection.up
                                ? Icons.trending_up
                                : trend == TrendDirection.down
                                    ? Icons.trending_down
                                    : Icons.trending_flat,
                            size: 12,
                            color: trendColor ?? kTextMuted,
                          ),
                          const SizedBox(width: 2),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: kFontXXL,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? kPrimaryGreen,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: kFontSM,
                  fontWeight: FontWeight.w500,
                  color: kTextSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.poppins(fontSize: kFontXS, color: kTextMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
