import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants.dart';
import '../../models/vehicle.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.onTap,
    required this.onSetActive,
  });

  final Vehicle vehicle;
  final VoidCallback onTap;
  final VoidCallback onSetActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: kSpaceMD),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(kRadiusLG),
          border: Border.all(
            color: vehicle.isActive ? kPrimaryGreen : kSurfaceGreen,
            width: vehicle.isActive ? 2.0 : 1.0,
          ),
        ),
        padding: const EdgeInsets.all(kSpaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kSpaceSM,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: vehicle.isActive ? kPrimaryAmber : kSurfaceGreen,
                    borderRadius: BorderRadius.circular(kRadiusSM),
                  ),
                  child: Text(
                    vehicle.isActive ? 'Active' : 'Inactive',
                    style: GoogleFonts.poppins(
                      fontSize: kFontXS,
                      fontWeight: FontWeight.w600,
                      color: vehicle.isActive ? kPrimaryGreen : kTextMuted,
                    ),
                  ),
                ),
                const Icon(Icons.directions_car, color: kPrimaryGreen, size: 28),
              ],
            ),
            const SizedBox(height: kSpaceSM),
            Text(
              vehicle.displayName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: kFontBase,
                fontWeight: FontWeight.w600,
                color: kPrimaryGreen,
              ),
            ),
            const SizedBox(height: kSpaceSM),
            _InfoRow(icon: Icons.local_gas_station_outlined, text: vehicle.fuelType),
            const SizedBox(height: 4),
            _InfoRow(
              icon: Icons.water_drop_outlined,
              text: '${vehicle.tankCapacityL.toStringAsFixed(0)}L tank',
            ),
            const SizedBox(height: 4),
            _InfoRow(
              icon: Icons.speed_outlined,
              text: '${vehicle.ratedConsumptionL100km.toStringAsFixed(1)} L/100km',
            ),
            const SizedBox(height: kSpaceMD),
            if (!vehicle.isActive)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onSetActive,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kPrimaryGreen, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Set as Active',
                    style: GoogleFonts.poppins(
                      fontSize: kFontSM,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryGreen,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kSurfaceGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Currently Active',
                  style: GoogleFonts.poppins(
                    fontSize: kFontSM,
                    fontWeight: FontWeight.w600,
                    color: kAccentGreen,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: kTextMuted, size: 14),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: kFontXS, color: kTextMuted),
        ),
      ],
    );
  }
}
