import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';
import 'premium_bottom_sheet.dart';

class PremiumBanner extends StatelessWidget {
  const PremiumBanner({
    super.key,
    this.title = 'Unlock Premium Driving Insights',
    this.description =
        'Get deeper trip analytics, AI-powered coaching, and unlimited reports with BudiBuddy Premium.',
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimaryAmber, kDeepAmber],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(kRadiusLG),
      ),
      padding: const EdgeInsets.all(kSpaceMD),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: kWhite.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(
              Icons.workspace_premium,
              color: kWhite,
              size: 24,
            ),
          ),
          const SizedBox(width: kSpaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: kFontMD,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: kFontXS,
                    color: kPrimaryGreen.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: kSpaceSM),
                GestureDetector(
                  onTap: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const PremiumBottomSheet(),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPrimaryGreen,
                      borderRadius: BorderRadius.circular(kRadiusXL),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    child: Text(
                      'Upgrade Now',
                      style: GoogleFonts.poppins(
                        fontSize: kFontXS,
                        fontWeight: FontWeight.w700,
                        color: kWhite,
                      ),
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
