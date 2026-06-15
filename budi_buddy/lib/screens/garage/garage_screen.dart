import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/router.dart';
import '../../models/vehicle.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/auth/budibuddy_button.dart';
import '../../widgets/garage/vehicle_card.dart';

class GarageScreen extends StatelessWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleProvider>(
      builder: (context, vehicleProvider, _) {
        final vehicles = vehicleProvider.vehicles;
        final activeVehicle = vehicleProvider.activeVehicle;

        return Scaffold(
          backgroundColor: kNeutralBg,
          appBar: AppBar(
            backgroundColor: kPrimaryGreen,
            elevation: 0,
            title: Text(
              'My Garage',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kWhite,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline, color: kWhite),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tap a vehicle card to view full details'),
                    ),
                  );
                },
              ),
            ],
          ),
          body: vehicles.isEmpty
              ? _buildEmptyState(context)
              : _buildVehicleList(context, vehicleProvider, vehicles, activeVehicle),
          floatingActionButton: vehicles.isEmpty
              ? null
              : FloatingActionButton.extended(
                  backgroundColor: kPrimaryAmber,
                  onPressed: () => context.push(RoutePaths.addVehicle),
                  icon: const Icon(Icons.add, color: kPrimaryGreen),
                  label: Text(
                    'Add Vehicle',
                    style: GoogleFonts.poppins(
                      fontSize: kFontSM,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryGreen,
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kSpaceLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.directions_car_outlined, color: kTextMuted, size: 64),
            const SizedBox(height: kSpaceMD),
            Text(
              'No vehicles yet',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kTextSecondary,
              ),
            ),
            const SizedBox(height: kSpaceXS),
            Text(
              'Add your first vehicle to get started.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13, color: kTextMuted),
            ),
            const SizedBox(height: kSpaceLG),
            BudiBuddyButton(
              label: 'Add Vehicle',
              icon: Icons.add,
              onPressed: () => context.push(RoutePaths.addVehicle),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleList(
    BuildContext context,
    VehicleProvider vehicleProvider,
    List<Vehicle> vehicles,
    Vehicle? activeVehicle,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kSpaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR VEHICLES',
            style: GoogleFonts.poppins(
              fontSize: kFontXS,
              fontWeight: FontWeight.w500,
              color: kTextMuted,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${vehicles.length} vehicle${vehicles.length == 1 ? '' : 's'} registered',
            style: GoogleFonts.poppins(fontSize: kFontSM, color: kTextSecondary),
          ),
          const SizedBox(height: kSpaceSM),
          SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return VehicleCard(
                  vehicle: vehicle,
                  onTap: () => context.push('/garage/${vehicle.id}'),
                  onSetActive: () => vehicleProvider.setActiveVehicle(vehicle.id),
                );
              },
            ),
          ),
          if (activeVehicle != null) ...[
            const SizedBox(height: kSpaceLG),
            Text(
              'ACTIVE VEHICLE DETAILS',
              style: GoogleFonts.poppins(
                fontSize: kFontXS,
                fontWeight: FontWeight.w500,
                color: kTextMuted,
                letterSpacing: 0.08,
              ),
            ),
            const SizedBox(height: kSpaceSM),
            _buildActiveVehicleCard(context, activeVehicle),
          ],
          const SizedBox(height: kSpaceLG),
        ],
      ),
    );
  }

  Widget _buildActiveVehicleCard(BuildContext context, Vehicle vehicle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kSpaceMD),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kSurfaceGreen),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: kSurfaceGreen,
                  borderRadius: BorderRadius.circular(kRadiusMD),
                ),
                child: const Icon(Icons.directions_car, color: kPrimaryGreen, size: 28),
              ),
              const SizedBox(width: kSpaceMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.displayName,
                      style: GoogleFonts.poppins(
                        fontSize: kFontBase,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryGreen,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${vehicle.engineCapacityCC}cc • ${vehicle.fuelType}',
                      style: GoogleFonts.poppins(fontSize: kFontXS, color: kTextMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpaceMD),
          const Divider(color: kSurfaceGreen),
          const SizedBox(height: kSpaceSM),
          Row(
            children: [
              _specItem('Tank', '${vehicle.tankCapacityL.toStringAsFixed(0)}L'),
              _specItem(
                'Rated Economy',
                '${vehicle.ratedConsumptionL100km.toStringAsFixed(1)} L/100km',
              ),
              _specItem('Year', '${vehicle.year}'),
            ],
          ),
          const SizedBox(height: kSpaceMD),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/garage/${vehicle.id}'),
                  child: Text(
                    'View Details',
                    style: GoogleFonts.poppins(
                      fontSize: kFontSM,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: kSpaceSM),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: kPrimaryGreen),
                  onPressed: () => context.push(RoutePaths.addVehicle),
                  child: Text(
                    'Add Vehicle',
                    style: GoogleFonts.poppins(
                      fontSize: kFontSM,
                      fontWeight: FontWeight.w600,
                      color: kWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _specItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: kFontSM,
              fontWeight: FontWeight.w600,
              color: kPrimaryGreen,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: kFontXS, color: kTextMuted),
          ),
        ],
      ),
    );
  }
}
