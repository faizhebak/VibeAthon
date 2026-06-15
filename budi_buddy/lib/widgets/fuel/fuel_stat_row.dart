import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

class FuelStat {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const FuelStat({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });
}

class FuelStatRow extends StatelessWidget {
  const FuelStatRow({super.key, required this.stats});

  final List<FuelStat> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kSurfaceGreen),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map(_statItem).toList(),
      ),
    );
  }

  Widget _statItem(FuelStat stat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: kSurfaceGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(stat.icon, color: kPrimaryGreen, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          stat.value,
          style: GoogleFonts.poppins(
            fontSize: kFontMD,
            fontWeight: FontWeight.w600,
            color: stat.valueColor ?? kPrimaryGreen,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          stat.label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: kFontXS, color: kTextMuted),
        ),
      ],
    );
  }
}
