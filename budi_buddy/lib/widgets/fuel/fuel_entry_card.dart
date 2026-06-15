import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/constants.dart';
import '../../models/fuel_entry.dart';

class FuelEntryCard extends StatelessWidget {
  const FuelEntryCard({
    super.key,
    required this.entry,
    required this.previousEntry,
    required this.fuelEconomyKmL,
    required this.distanceKm,
    required this.onTap,
    required this.onDelete,
  });

  final FuelEntry entry;
  final FuelEntry? previousEntry;
  final double fuelEconomyKmL;
  final double distanceKm;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(kRadiusLG),
          border: Border.all(color: kSurfaceGreen, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.stationName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryGreen,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          DateFormat('EEE, d MMM yyyy').format(entry.date),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: kTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'RM ${entry.totalCost.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryGreen,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${entry.litres.toStringAsFixed(2)} L',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: kTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 16, color: kSurfaceGreen),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statChip(
                    Icons.speed_outlined,
                    '${fuelEconomyKmL > 0 ? fuelEconomyKmL.toStringAsFixed(1) : '--'} km/L',
                  ),
                  _statChip(
                    Icons.straighten_outlined,
                    '${distanceKm > 0 ? distanceKm.toStringAsFixed(0) : '--'} km',
                  ),
                  _statChip(
                    Icons.attach_money_outlined,
                    'RM ${entry.pricePerLitre.toStringAsFixed(2)}/L',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _fuelTypeColor(entry.fuelType).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      entry.fuelType,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _fuelTypeColor(entry.fuelType),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: kTextMuted,
                      size: 18,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statChip(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: kTextMuted, size: 13),
        const SizedBox(width: 4),
        Text(value, style: GoogleFonts.poppins(fontSize: 12, color: kTextSecondary)),
      ],
    );
  }

  Color _fuelTypeColor(String fuelType) {
    switch (fuelType) {
      case 'RON95':
        return kPrimaryGreen;
      case 'RON97':
        return kDeepAmber;
      case 'Diesel':
        return kTextSecondary;
      default:
        return kPrimaryGreen;
    }
  }
}
