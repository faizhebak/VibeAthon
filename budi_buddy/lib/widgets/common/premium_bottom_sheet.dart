import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

class PremiumBottomSheet extends StatelessWidget {
  const PremiumBottomSheet({super.key});

  static const List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.analytics_outlined,
      'title': 'Advanced Trip Analytics',
      'description':
          'Deep dives into every trip with detailed driving behaviour breakdowns.',
    },
    {
      'icon': Icons.auto_awesome_outlined,
      'title': 'AI-Powered Coaching',
      'description':
          'Personalised tips and feedback based on your unique driving patterns.',
    },
    {
      'icon': Icons.bar_chart_outlined,
      'title': 'Unlimited Reports & Exports',
      'description':
          'Export your fuel and driving data anytime, with no limits.',
    },
    {
      'icon': Icons.notifications_active_outlined,
      'title': 'Priority Price Alerts',
      'description':
          'Be the first to know about fuel price changes near you.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(kRadiusXL),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: kSurfaceGreen,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: kSpaceMD),
                Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: kAmberTint,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.workspace_premium,
                        color: kDeepAmber,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: kSpaceMD),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BudiBuddy Premium',
                            style: GoogleFonts.poppins(
                              fontSize: kFontLG,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryGreen,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Unlock the full driving experience',
                            style: GoogleFonts.poppins(
                              fontSize: kFontSM,
                              color: kTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpaceLG),
                for (final feature in _features) ...[
                  _featureRow(feature),
                  const SizedBox(height: kSpaceMD),
                ],
                const SizedBox(height: kSpaceXS),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryAmber,
                      foregroundColor: kPrimaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kRadiusMD),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      final messenger = ScaffoldMessenger.of(sheetContext);
                      Navigator.of(sheetContext).pop();
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            'Premium upgrade is coming soon!',
                            style: GoogleFonts.poppins(color: kWhite),
                          ),
                          backgroundColor: kPrimaryGreen,
                        ),
                      );
                    },
                    child: Text(
                      'Upgrade Now',
                      style: GoogleFonts.poppins(
                        fontSize: kFontBase,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: kSpaceSM),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    child: Text(
                      'Maybe later',
                      style: GoogleFonts.poppins(
                        fontSize: kFontSM,
                        color: kTextMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _featureRow(Map<String, dynamic> feature) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: kSurfaceGreen,
            borderRadius: BorderRadius.circular(kRadiusSM),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(
            feature['icon'] as IconData,
            color: kPrimaryGreen,
            size: 18,
          ),
        ),
        const SizedBox(width: kSpaceMD),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feature['title'] as String,
                style: GoogleFonts.poppins(
                  fontSize: kFontMD,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryGreen,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                feature['description'] as String,
                style: GoogleFonts.poppins(
                  fontSize: kFontXS,
                  color: kTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
