import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

enum BudiBuddyButtonVariant { primary, secondary, ghost }

class BudiBuddyButton extends StatelessWidget {
  const BudiBuddyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = BudiBuddyButtonVariant.primary,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final BudiBuddyButtonVariant variant;
  final bool isLoading;
  final bool fullWidth;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

    Widget child;
    if (isLoading) {
      final indicatorColor = variant == BudiBuddyButtonVariant.primary
          ? kPrimaryAmber
          : kPrimaryGreen;
      child = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
        ),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label, style: textStyle),
        ],
      );
    } else {
      child = Text(label, style: textStyle);
    }

    final Widget button;
    switch (variant) {
      case BudiBuddyButtonVariant.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryGreen,
            foregroundColor: kWhite,
            textStyle: textStyle,
          ),
          child: child,
        );
        break;
      case BudiBuddyButtonVariant.secondary:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: kPrimaryGreen,
            side: const BorderSide(color: kPrimaryGreen, width: 1.5),
            textStyle: textStyle,
          ),
          child: child,
        );
        break;
      case BudiBuddyButtonVariant.ghost:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: kPrimaryGreen,
            textStyle: textStyle,
          ),
          child: child,
        );
        break;
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
