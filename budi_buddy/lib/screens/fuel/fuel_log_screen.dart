import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/router.dart';
import '../../providers/fuel_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/auth/budibuddy_button.dart';
import '../../widgets/fuel/fuel_entry_card.dart';

class FuelLogScreen extends StatelessWidget {
  const FuelLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNeutralBg,
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        elevation: 0,
        title: Text(
          'Fuel Log',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kWhite,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: kWhite),
            onPressed: () => context.push(RoutePaths.addFuel),
          ),
        ],
      ),
      body: Consumer2<FuelProvider, VehicleProvider>(
        builder: (context, fuelProvider, vehicleProvider, _) {
          final activeVehicle = vehicleProvider.activeVehicle;

          if (activeVehicle == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No active vehicle selected. Please add a vehicle first.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: kFontMD, color: kTextSecondary),
                ),
              ),
            );
          }

          final entries = fuelProvider.entriesForVehicle(activeVehicle.id);

          return Column(
            children: [
              Container(
                width: double.infinity,
                color: kPrimaryGreen,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total entries',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: kWhite.withValues(alpha: 0.7),
                          ),
                        ),
                        Text(
                          '${entries.length} fill-ups',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: kWhite,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Total spent',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: kWhite.withValues(alpha: 0.7),
                          ),
                        ),
                        Text(
                          'RM ${fuelProvider.totalSpendingForVehicle(activeVehicle.id).toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: kPrimaryAmber,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                color: kSurfaceGreen,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.directions_car, color: kPrimaryGreen, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Showing entries for ${activeVehicle.displayName}',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: 12, color: kPrimaryGreen),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go(RoutePaths.garage),
                      child: Text(
                        'Switch >',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: kPrimaryGreen,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: entries.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          final previous = fuelProvider.previousEntryForVehicle(
                            activeVehicle.id,
                            entry.id,
                          );
                          final economy = fuelProvider.computeFuelEconomy(entry, previous);
                          final distance = fuelProvider.computeDistanceSinceLastFill(
                            entry,
                            previous,
                          );

                          return Dismissible(
                            key: Key(entry.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              decoration: BoxDecoration(
                                color: kError,
                                borderRadius: BorderRadius.circular(kRadiusLG),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.delete, color: kWhite),
                                  Text(
                                    'Delete',
                                    style: GoogleFonts.poppins(fontSize: 11, color: kWhite),
                                  ),
                                ],
                              ),
                            ),
                            confirmDismiss: (_) => _confirmDelete(context),
                            onDismissed: (_) {
                              fuelProvider.deleteEntry(entry.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Entry deleted.')),
                              );
                            },
                            child: FuelEntryCard(
                              entry: entry,
                              previousEntry: previous,
                              fuelEconomyKmL: economy,
                              distanceKm: distance,
                              onTap: () => context.push('/fuel/${entry.id}'),
                              onDelete: () async {
                                final confirmed = await _confirmDelete(context);
                                if (!confirmed) return;
                                fuelProvider.deleteEntry(entry.id);
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Entry deleted.')),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryAmber,
        onPressed: () => context.push(RoutePaths.addFuel),
        icon: const Icon(Icons.add, color: kPrimaryGreen),
        label: Text(
          'Log Fill-up',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: kPrimaryGreen,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kSpaceLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_gas_station_outlined, color: kTextMuted, size: 56),
            const SizedBox(height: 16),
            Text(
              'No fuel entries yet',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kTextSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Log your first fill-up to start tracking.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13, color: kTextMuted),
            ),
            const SizedBox(height: 24),
            BudiBuddyButton(
              label: 'Log Fill-up',
              icon: Icons.add,
              onPressed: () => context.push(RoutePaths.addFuel),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Delete this entry?',
          style: GoogleFonts.poppins(
            fontSize: kFontMD,
            fontWeight: FontWeight.w600,
            color: kPrimaryGreen,
          ),
        ),
        content: Text(
          'This fill-up record will be permanently removed. This action cannot be undone.',
          style: GoogleFonts.poppins(fontSize: kFontSM, color: kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: kTextSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(color: kError, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
