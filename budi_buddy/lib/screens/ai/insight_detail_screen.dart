import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/router.dart';
import '../../widgets/auth/budibuddy_button.dart';

class InsightDetailScreen extends StatelessWidget {
  const InsightDetailScreen({super.key, required this.insightId});

  final String insightId;

  Map<String, String>? get _insight {
    for (final insight in MockData.aiInsights) {
      if (insight['id'] == insightId) return insight;
    }
    return null;
  }

  IconData _iconFor(String? icon) {
    switch (icon) {
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

  Color _colorFor(String? category) {
    switch (category) {
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

  Color _bgFor(String? category) {
    switch (category) {
      case 'spending':
      case 'tip':
        return kAmberTint;
      default:
        return kSurfaceGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final insight = _insight;

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
          'AI Insight',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kWhite,
          ),
        ),
      ),
      body: insight == null
          ? Center(
              child: Text(
                'Insight not found.',
                style: GoogleFonts.poppins(
                  fontSize: kFontSM,
                  color: kTextMuted,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(kSpaceMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: _bgFor(insight['category']),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Icon(
                      _iconFor(insight['icon']),
                      color: _colorFor(insight['category']),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: kSpaceMD),
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
                      (insight['category'] ?? '').toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: kFontXS,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryGreen,
                        letterSpacing: 0.08,
                      ),
                    ),
                  ),
                  const SizedBox(height: kSpaceMD),
                  Text(
                    insight['summary'] ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: kFontLG,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryGreen,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: kSpaceMD),
                  Text(
                    insight['detail'] ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: kFontSM,
                      color: kTextSecondary,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: kSpaceLG),
                  BudiBuddyButton(
                    label: 'Discuss with BudiBuddy AI',
                    icon: Icons.chat_outlined,
                    onPressed: () => context.go(RoutePaths.ai),
                  ),
                ],
              ),
            ),
    );
  }
}
