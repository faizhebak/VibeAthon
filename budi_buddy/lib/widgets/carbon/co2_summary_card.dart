import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

class Co2SummaryCard extends StatelessWidget {
  const Co2SummaryCard({
    super.key,
    required this.co2Kg,
    required this.treesNeeded,
    required this.personalBest,
    required this.lastMonth,
  });

  final double co2Kg;
  final double treesNeeded;
  final double personalBest;
  final double lastMonth;

  @override
  Widget build(BuildContext context) {
    final isDown = co2Kg <= lastMonth;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kPrimaryGreen,
        borderRadius: BorderRadius.circular(kRadiusLG),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Month',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: kWhite.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        co2Kg.toStringAsFixed(1),
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryAmber,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6, left: 4),
                        child: Text(
                          ' kg CO₂',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: kWhite.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: kWhite.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(kRadiusMD),
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.eco, color: kPrimaryAmber, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: kWhite.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(kRadiusMD),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statItem(
                  'Trees to offset',
                  treesNeeded.toStringAsFixed(1),
                  Icons.park_outlined,
                ),
                _divider(),
                _statItem(
                  'Last month',
                  '${lastMonth.toStringAsFixed(1)} kg',
                  Icons.history_outlined,
                ),
                _divider(),
                _statItem(
                  'Personal best',
                  personalBest > 0
                      ? '${personalBest.toStringAsFixed(1)} kg'
                      : '--',
                  Icons.emoji_events_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                isDown ? Icons.trending_down : Icons.trending_up,
                size: 16,
                color: isDown ? kPrimaryAmber : kWhite.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isDown
                      ? 'Down ${(lastMonth - co2Kg).toStringAsFixed(1)} kg vs last month. Great progress!'
                      : 'Up ${(co2Kg - lastMonth).toStringAsFixed(1)} kg vs last month. Try the tips below.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isDown
                        ? kPrimaryAmber
                        : kWhite.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: kWhite.withValues(alpha: 0.7), size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kWhite,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: kWhite.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      color: kWhite.withValues(alpha: 0.2),
    );
  }
}
