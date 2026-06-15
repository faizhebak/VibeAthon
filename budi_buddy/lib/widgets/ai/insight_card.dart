import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({super.key, required this.insight, required this.onTap});

  final Map<String, String> insight;
  final VoidCallback onTap;

  IconData get _icon {
    switch (insight['icon']) {
      case 'account_balance_wallet':
        return Icons.account_balance_wallet_outlined;
      case 'local_gas_station':
        return Icons.local_gas_station_outlined;
      case 'speed':
        return Icons.speed_outlined;
      case 'eco':
        return Icons.eco_outlined;
      case 'trending_down':
        return Icons.trending_down;
      case 'lightbulb':
        return Icons.lightbulb_outline;
      default:
        return Icons.insights_outlined;
    }
  }

  Color get _iconColor {
    switch (insight['category']) {
      case 'spending':
        return kDeepAmber;
      case 'refuel':
        return kAccentGreen;
      case 'driving':
        return kMidGreen;
      case 'carbon':
        return kPrimaryGreen;
      case 'economy':
        return kAccentGreen;
      case 'tip':
        return kPrimaryAmber;
      default:
        return kPrimaryGreen;
    }
  }

  Color get _iconBg {
    switch (insight['category']) {
      case 'spending':
        return kAmberTint;
      case 'tip':
        return kAmberTint;
      default:
        return kSurfaceGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(color: _iconBg, shape: BoxShape.circle),
              padding: const EdgeInsets.all(10),
              child: Icon(_icon, color: _iconColor, size: 20),
            ),
            const SizedBox(width: kSpaceMD),
            Expanded(
              child: Text(
                insight['summary'] ?? '',
                style: GoogleFonts.poppins(
                  fontSize: kFontSM,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryGreen,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(width: kSpaceSM),
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.arrow_forward_ios, size: 14, color: kTextMuted),
            ),
          ],
        ),
      ),
    );
  }
}
