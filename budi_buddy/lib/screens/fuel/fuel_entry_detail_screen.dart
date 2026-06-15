import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../models/fuel_entry.dart';
import '../../models/vehicle.dart';
import '../../providers/fuel_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/fuel/fuel_stat_row.dart';

class FuelEntryDetailScreen extends StatelessWidget {
  const FuelEntryDetailScreen({super.key, required this.entryId});

  final String entryId;

  @override
  Widget build(BuildContext context) {
    return Consumer2<FuelProvider, VehicleProvider>(
      builder: (context, fuelProvider, vehicleProvider, _) {
        final entry = _findEntry(fuelProvider, entryId);

        if (entry == null) {
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
                'Entry Not Found',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kWhite,
                ),
              ),
            ),
            body: Center(
              child: Text(
                'This entry no longer exists.',
                style: GoogleFonts.poppins(fontSize: kFontMD, color: kTextSecondary),
              ),
            ),
          );
        }

        final previous = fuelProvider.previousEntryForVehicle(entry.vehicleId, entry.id);
        final economy = fuelProvider.computeFuelEconomy(entry, previous);
        final distance = fuelProvider.computeDistanceSinceLastFill(entry, previous);
        final costPerKm = fuelProvider.computeCostPerKm(entry, previous);
        final vehicle = _findVehicle(vehicleProvider, entry.vehicleId);

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
              'Fill-up Details',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kWhite,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: kWhite),
                onPressed: () => _showDeleteDialog(context, fuelProvider, entry.id),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroCard(entry),
                const SizedBox(height: 20),
                Text(
                  'PERFORMANCE',
                  style: GoogleFonts.poppins(
                    fontSize: kFontXS,
                    fontWeight: FontWeight.w500,
                    color: kTextMuted,
                    letterSpacing: 0.08,
                  ),
                ),
                const SizedBox(height: 10),
                FuelStatRow(
                  stats: [
                    FuelStat(
                      label: 'Fuel Economy',
                      value: economy > 0 ? '${economy.toStringAsFixed(1)} km/L' : 'N/A',
                      icon: Icons.speed_outlined,
                      valueColor: economy > 0 ? kPrimaryGreen : kTextMuted,
                    ),
                    FuelStat(
                      label: 'Distance',
                      value: distance > 0 ? '${distance.toStringAsFixed(0)} km' : 'N/A',
                      icon: Icons.straighten_outlined,
                      valueColor: distance > 0 ? kPrimaryGreen : kTextMuted,
                    ),
                    FuelStat(
                      label: 'Cost per km',
                      value: costPerKm > 0 ? 'RM ${costPerKm.toStringAsFixed(3)}' : 'N/A',
                      icon: Icons.attach_money_outlined,
                      valueColor: costPerKm > 0 ? kPrimaryGreen : kTextMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (economy > 0 && vehicle != null) ...[
                  _buildEfficiencyComparison(economy, vehicle),
                  const SizedBox(height: 16),
                ],
                Text(
                  'FILL-UP DETAILS',
                  style: GoogleFonts.poppins(
                    fontSize: kFontXS,
                    fontWeight: FontWeight.w500,
                    color: kTextMuted,
                    letterSpacing: 0.08,
                  ),
                ),
                const SizedBox(height: 10),
                _buildFillUpDetails(entry),
                const SizedBox(height: 16),
                if (previous != null) ...[
                  Text(
                    'PREVIOUS FILL-UP',
                    style: GoogleFonts.poppins(
                      fontSize: kFontXS,
                      fontWeight: FontWeight.w500,
                      color: kTextMuted,
                      letterSpacing: 0.08,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildPreviousEntry(previous),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroCard(FuelEntry entry) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kPrimaryGreen,
        borderRadius: BorderRadius.circular(kRadiusXL),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Cost',
                    style: GoogleFonts.poppins(fontSize: 12, color: kWhite.withValues(alpha: 0.7)),
                  ),
                  Text(
                    'RM ${entry.totalCost.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryAmber,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: kPrimaryAmber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.local_gas_station, color: kPrimaryAmber, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            entry.stationName,
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: kWhite),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('EEEE, d MMMM yyyy').format(entry.date),
            style: GoogleFonts.poppins(fontSize: 12, color: kWhite.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: kWhite.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${entry.litres.toStringAsFixed(2)} L',
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: kWhite),
                ),
                Text(
                  'RM ${entry.pricePerLitre.toStringAsFixed(2)}/L',
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: kWhite),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: kPrimaryAmber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: Text(
                    entry.fuelType,
                    style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: kPrimaryGreen),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyComparison(double economy, Vehicle vehicle) {
    final ratedKmL = 100 / vehicle.ratedConsumptionL100km;
    final diff = economy - ratedKmL;
    final isAboveRated = diff >= 0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kSurfaceGreen),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'vs Rated Economy',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: kPrimaryGreen),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      economy.toStringAsFixed(1),
                      style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: kPrimaryGreen),
                    ),
                    Text(
                      'km/L achieved',
                      style: GoogleFonts.poppins(fontSize: 11, color: kTextMuted),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: kSurfaceGreen),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      ratedKmL.toStringAsFixed(1),
                      style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: kDeepAmber),
                    ),
                    Text(
                      'km/L rated',
                      style: GoogleFonts.poppins(fontSize: 11, color: kTextMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isAboveRated ? kSurfaceGreen : kErrorSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  isAboveRated ? Icons.trending_up : Icons.trending_down,
                  size: 16,
                  color: isAboveRated ? kAccentGreen : kError,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    isAboveRated
                        ? '+${diff.toStringAsFixed(1)} km/L above rated — excellent driving!'
                        : '${diff.toStringAsFixed(1)} km/L below rated — try smoother acceleration.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isAboveRated ? kAccentGreen : kError,
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

  Widget _buildFillUpDetails(FuelEntry entry) {
    final rows = <Widget>[
      _detailRow(Icons.location_on_outlined, 'Station', entry.stationName),
      _detailRow(Icons.calendar_today_outlined, 'Date', DateFormat('d MMMM yyyy').format(entry.date)),
      _detailRow(Icons.speed_outlined, 'Odometer', '${entry.odometerKm.toStringAsFixed(0)} km'),
      _detailRow(Icons.water_drop_outlined, 'Litres', '${entry.litres.toStringAsFixed(2)} L'),
      _detailRow(Icons.attach_money_outlined, 'Price per Litre', 'RM ${entry.pricePerLitre.toStringAsFixed(2)}'),
      _detailRow(Icons.local_gas_station_outlined, 'Fuel Type', entry.fuelType),
      if (entry.notes != null && entry.notes!.isNotEmpty)
        _detailRow(Icons.notes_outlined, 'Notes', entry.notes!),
    ];

    final children = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      children.add(rows[i]);
      if (i != rows.length - 1) {
        children.add(const Divider(height: 20, color: kSurfaceGreen));
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kSurfaceGreen),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(children: children),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: kTextMuted, size: 16),
        const SizedBox(width: 12),
        Text(label, style: GoogleFonts.poppins(fontSize: 13, color: kTextSecondary)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: kPrimaryGreen),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviousEntry(FuelEntry previous) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kSurfaceGreen),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.history, color: kTextMuted, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  previous.stationName,
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: kPrimaryGreen),
                ),
                Text(
                  DateFormat('d MMM yyyy').format(previous.date),
                  style: GoogleFonts.poppins(fontSize: 12, color: kTextMuted),
                ),
              ],
            ),
          ),
          Text(
            '${previous.odometerKm.toStringAsFixed(0)} km',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: kTextSecondary),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, FuelProvider fuelProvider, String entryId) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Delete Entry?',
          style: GoogleFonts.poppins(fontSize: kFontMD, fontWeight: FontWeight.w600, color: kPrimaryGreen),
        ),
        content: Text(
          'This fill-up record will be permanently removed.',
          style: GoogleFonts.poppins(fontSize: kFontSM, color: kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Cancel', style: GoogleFonts.poppins(color: kTextSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kError),
            onPressed: () {
              fuelProvider.deleteEntry(entryId);
              Navigator.of(dialogContext).pop();
              context.pop();
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: kWhite),
            ),
          ),
        ],
      ),
    );
  }

  FuelEntry? _findEntry(FuelProvider fuelProvider, String id) {
    for (final entry in fuelProvider.allEntries) {
      if (entry.id == id) return entry;
    }
    return null;
  }

  Vehicle? _findVehicle(VehicleProvider vehicleProvider, String id) {
    for (final vehicle in vehicleProvider.vehicles) {
      if (vehicle.id == id) return vehicle;
    }
    return null;
  }
}
