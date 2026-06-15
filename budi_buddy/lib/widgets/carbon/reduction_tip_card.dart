import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

class ReductionTipCard extends StatelessWidget {
  const ReductionTipCard({super.key, required this.tip});

  final Map<String, String> tip;

  IconData get _icon {
    switch (tip['icon']) {
      case 'speed':
        return Icons.speed;
      case 'ac_unit':
        return Icons.ac_unit;
      case 'tire_repair':
        return Icons.tire_repair;
      case 'route':
        return Icons.route;
      default:
        return Icons.eco;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kSurfaceGreen),
      ),
      padding: const EdgeInsets.all(kSpaceMD),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: kSurfaceGreen,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(_icon, color: kPrimaryGreen, size: 20),
          ),
          const SizedBox(width: kSpaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip['title'] ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: kFontSM,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip['description'] ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: kFontXS,
                    color: kTextSecondary,
                  ),
                ),
                const SizedBox(height: kSpaceSM),
                Container(
                  decoration: BoxDecoration(
                    color: kSurfaceGreen,
                    borderRadius: BorderRadius.circular(kRadiusXL),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: Text(
                    tip['saving'] ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: kFontXS,
                      fontWeight: FontWeight.w600,
                      color: kAccentGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
