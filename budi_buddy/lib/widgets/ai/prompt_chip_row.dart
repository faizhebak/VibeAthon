import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

class PromptChipRow extends StatelessWidget {
  const PromptChipRow({
    super.key,
    required this.prompts,
    required this.onSelect,
  });

  final List<String> prompts;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: prompts.length,
        separatorBuilder: (context, index) => const SizedBox(width: kSpaceSM),
        itemBuilder: (context, index) {
          final prompt = prompts[index];
          return GestureDetector(
            onTap: () => onSelect(prompt),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: kSpaceMD,
                vertical: kSpaceSM,
              ),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(kRadiusXL),
                border: Border.all(color: kSurfaceGreen),
              ),
              child: Text(
                prompt,
                style: GoogleFonts.poppins(
                  fontSize: kFontXS,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryGreen,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
