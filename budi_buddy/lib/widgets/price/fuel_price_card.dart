import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';

enum PriceLevel { cheap, mid, high }

class FuelPriceCard extends StatelessWidget {
  const FuelPriceCard({
    super.key,
    required this.fuelType,
    required this.currentPrice,
    required this.previousPrice,
    required this.isSelected,
    required this.onTap,
    this.priceLevel = PriceLevel.mid,
  });

  final String fuelType;
  final double currentPrice;
  final double previousPrice;
  final bool isSelected;
  final VoidCallback onTap;
  final PriceLevel priceLevel;

  @override
  Widget build(BuildContext context) {
    final priceChange = currentPrice - previousPrice;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? _bgColorForLevel(priceLevel) : kWhite,
          borderRadius: BorderRadius.circular(kRadiusLG),
          border: Border.all(
            color: isSelected
                ? _borderColorForLevel(priceLevel)
                : kSurfaceGreen,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
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
                        fuelType,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? _textColorForLevel(priceLevel)
                              : kTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'RM ${currentPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? _textColorForLevel(priceLevel)
                              : kPrimaryGreen,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _iconBgForLevel(priceLevel, isSelected),
                          borderRadius: BorderRadius.circular(kRadiusMD),
                        ),
                        child: Icon(
                          _iconForLevel(priceLevel),
                          color: _iconColorForLevel(priceLevel, isSelected),
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: _badgeBgForLevel(priceLevel),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        child: Text(
                          _labelForLevel(priceLevel),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _badgeTextForLevel(priceLevel),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(
                color: isSelected
                    ? _borderColorForLevel(priceLevel).withValues(alpha: 0.3)
                    : kSurfaceGreen,
                height: 1,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        priceChange > 0
                            ? Icons.arrow_upward
                            : priceChange < 0
                                ? Icons.arrow_downward
                                : Icons.remove,
                        size: 14,
                        color: priceChange > 0
                            ? kError
                            : priceChange < 0
                                ? kAccentGreen
                                : kTextMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _priceChangeText(currentPrice, previousPrice),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: priceChange > 0
                              ? kError
                              : priceChange < 0
                                  ? kAccentGreen
                                  : kTextMuted,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'vs last week',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: isSelected
                          ? _textColorForLevel(priceLevel)
                              .withValues(alpha: 0.7)
                          : kTextMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _priceChangeText(double current, double previous) {
    final diff = current - previous;
    if (diff == 0) return 'No change';
    if (diff > 0) return '+RM ${diff.toStringAsFixed(2)}';
    return '-RM ${diff.abs().toStringAsFixed(2)}';
  }

  Color _bgColorForLevel(PriceLevel level) {
    switch (level) {
      case PriceLevel.cheap:
        return kSurfaceGreen;
      case PriceLevel.mid:
        return kAmberTint;
      case PriceLevel.high:
        return kErrorSurface;
    }
  }

  Color _borderColorForLevel(PriceLevel level) {
    switch (level) {
      case PriceLevel.cheap:
        return kAccentGreen;
      case PriceLevel.mid:
        return kDeepAmber;
      case PriceLevel.high:
        return kError;
    }
  }

  Color _textColorForLevel(PriceLevel level) {
    switch (level) {
      case PriceLevel.cheap:
        return kPrimaryGreen;
      case PriceLevel.mid:
        return kDeepAmberText;
      case PriceLevel.high:
        return kError;
    }
  }

  Color _iconBgForLevel(PriceLevel level, bool isSelected) {
    if (isSelected) return kWhite.withValues(alpha: 0.3);
    switch (level) {
      case PriceLevel.cheap:
        return kSurfaceGreen;
      case PriceLevel.mid:
        return kAmberTint;
      case PriceLevel.high:
        return kErrorSurface;
    }
  }

  Color _iconColorForLevel(PriceLevel level, bool isSelected) {
    switch (level) {
      case PriceLevel.cheap:
        return kAccentGreen;
      case PriceLevel.mid:
        return kDeepAmber;
      case PriceLevel.high:
        return kError;
    }
  }

  IconData _iconForLevel(PriceLevel level) {
    switch (level) {
      case PriceLevel.cheap:
        return Icons.thumb_up_outlined;
      case PriceLevel.mid:
        return Icons.trending_flat_outlined;
      case PriceLevel.high:
        return Icons.warning_amber_outlined;
    }
  }

  Color _badgeBgForLevel(PriceLevel level) {
    switch (level) {
      case PriceLevel.cheap:
        return kAccentGreen.withValues(alpha: 0.15);
      case PriceLevel.mid:
        return kDeepAmber.withValues(alpha: 0.15);
      case PriceLevel.high:
        return kError.withValues(alpha: 0.15);
    }
  }

  Color _badgeTextForLevel(PriceLevel level) {
    switch (level) {
      case PriceLevel.cheap:
        return kAccentGreen;
      case PriceLevel.mid:
        return kDeepAmber;
      case PriceLevel.high:
        return kError;
    }
  }

  String _labelForLevel(PriceLevel level) {
    switch (level) {
      case PriceLevel.cheap:
        return 'LOW';
      case PriceLevel.mid:
        return 'MID';
      case PriceLevel.high:
        return 'HIGH';
    }
  }
}
