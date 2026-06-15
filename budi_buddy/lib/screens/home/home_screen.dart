import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/router.dart';
import '../../models/vehicle.dart';
import '../../providers/auth_provider.dart';
import '../../providers/fuel_provider.dart';
import '../../providers/vehicle_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser =
        context.watch<AuthProvider>().currentUser ?? MockData.currentUser;
    final vehicleProvider = context.watch<VehicleProvider>();
    final fuelProvider = context.watch<FuelProvider>();
    final activeVehicle = vehicleProvider.activeVehicle;

    final currentPrices = MockData.fuelPrices.last;

    final monthStart = DateTime(DateTime.now().year, DateTime.now().month, 1);
    final monthlySpend = activeVehicle == null
        ? 0.0
        : fuelProvider.totalSpendingForVehicle(activeVehicle.id, from: monthStart);
    final avgEconomy = activeVehicle == null
        ? 0.0
        : fuelProvider.averageFuelEconomyForVehicle(activeVehicle.id);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.go(RoutePaths.profile),
          child: Padding(
            padding: const EdgeInsets.all(kSpaceSM),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: kPrimaryAmber,
              child: Text(
                currentUser.avatarInitials,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryGreen,
                ),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome back, ${currentUser.name.split(' ').first}',
              style: GoogleFonts.poppins(
                fontSize: kFontXS,
                color: kWhite.withValues(alpha: 0.7),
              ),
            ),
            Text(
              activeVehicle?.displayName ?? 'No vehicle selected',
              style: GoogleFonts.poppins(
                fontSize: kFontMD,
                fontWeight: FontWeight.w600,
                color: kWhite,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: kSpaceSM),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: kWhite),
                  onPressed: () => context.go(RoutePaths.notifications),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: kError,
                      borderRadius: BorderRadius.circular(kRadiusSM),
                    ),
                    child: Text(
                      '3',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: kWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kSpaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (activeVehicle != null) _buildActiveVehicleCard(context, activeVehicle),
            _SectionLabel(text: 'Summary this month'),
            const SizedBox(height: kSpaceSM),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'This Month',
                    value: 'RM ${monthlySpend.toStringAsFixed(2)}',
                    subtitle: '+8% vs last month',
                    subtitleColor: kError,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Fuel Economy',
                    value: '${avgEconomy.toStringAsFixed(1)} km/L',
                    subtitle: 'Overall average',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(
                  child: _StatCard(
                    label: 'CO₂ This Month',
                    value: '68 kg',
                    subtitle: '2.31 kg/L petrol',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Cost per KM',
                    value: 'RM 0.18',
                    subtitle: 'RON95 @ RM2.05',
                  ),
                ),
              ],
            ),
            const SizedBox(height: kSpaceLG),
            _SectionLabel(text: 'Latest Fill-up'),
            const SizedBox(height: kSpaceSM),
            _buildLatestFillUpCard(context, fuelProvider, activeVehicle),
            const SizedBox(height: kSpaceLG),
            GestureDetector(
              onTap: () => context.push(RoutePaths.price),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SectionLabel(text: "This Week's Fuel Prices"),
                      const Icon(
                        Icons.chevron_right,
                        color: kTextMuted,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: kSpaceSM),
                  Row(
                    children: [
                      Expanded(
                        child: _PricePill(
                          label: 'RON95',
                          price: 'RM ${currentPrices.ron95.toStringAsFixed(2)}',
                          backgroundColor: kSurfaceGreen,
                          priceColor: kPrimaryGreen,
                        ),
                      ),
                      const SizedBox(width: kSpaceSM),
                      Expanded(
                        child: _PricePill(
                          label: 'RON97',
                          price: 'RM ${currentPrices.ron97.toStringAsFixed(2)}',
                          backgroundColor: kAmberTint,
                          priceColor: kDeepAmber,
                        ),
                      ),
                      const SizedBox(width: kSpaceSM),
                      Expanded(
                        child: _PricePill(
                          label: 'Diesel',
                          price: 'RM ${currentPrices.diesel.toStringAsFixed(2)}',
                          backgroundColor: kNeutralBg,
                          priceColor: kTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpaceLG),
            _SectionLabel(text: 'AI BudiBuddy'),
            const SizedBox(height: kSpaceSM),
            GestureDetector(
              onTap: () => context.go(RoutePaths.ai),
              child: Container(
                padding: const EdgeInsets.all(kSpaceMD),
                decoration: BoxDecoration(
                  color: kPrimaryGreen,
                  borderRadius: BorderRadius.circular(kRadiusLG),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.smart_toy, color: kPrimaryAmber, size: 28),
                    const SizedBox(width: kSpaceMD),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Latest insight',
                            style: GoogleFonts.poppins(
                              fontSize: kFontSM,
                              color: kWhite,
                            ),
                          ),
                          const SizedBox(height: kSpaceXS),
                          Text(
                            MockData.aiInsights.first['summary']!,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: kWhite,
                            ),
                          ),
                          const SizedBox(height: kSpaceSM),
                          Text(
                            'Ask AI >',
                            style: GoogleFonts.poppins(
                              fontSize: kFontSM,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryAmber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveVehicleCard(BuildContext context, Vehicle activeVehicle) {
    return Container(
      margin: const EdgeInsets.only(bottom: kSpaceMD),
      padding: const EdgeInsets.symmetric(
        horizontal: kSpaceMD,
        vertical: kSpaceSM,
      ),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kSurfaceGreen),
      ),
      child: Row(
        children: [
          const Icon(Icons.directions_car, color: kPrimaryGreen, size: 20),
          const SizedBox(width: kSpaceSM),
          Expanded(
            child: Text(
              activeVehicle.displayName,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: kFontSM,
                fontWeight: FontWeight.w600,
                color: kPrimaryGreen,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: kSpaceSM, vertical: 2),
            decoration: BoxDecoration(
              color: kPrimaryAmber,
              borderRadius: BorderRadius.circular(kRadiusSM),
            ),
            child: Text(
              'Active',
              style: GoogleFonts.poppins(
                fontSize: kFontXS,
                fontWeight: FontWeight.w600,
                color: kPrimaryGreen,
              ),
            ),
          ),
          const SizedBox(width: kSpaceSM),
          GestureDetector(
            onTap: () => context.go(RoutePaths.garage),
            child: Text(
              'Change >',
              style: GoogleFonts.poppins(
                fontSize: kFontXS,
                color: kPrimaryGreen,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestFillUpCard(
    BuildContext context,
    FuelProvider fuelProvider,
    Vehicle? activeVehicle,
  ) {
    if (activeVehicle == null) return const SizedBox.shrink();

    final latest = fuelProvider.latestEntryForVehicle(activeVehicle.id);

    if (latest == null) {
      return GestureDetector(
        onTap: () => context.push(RoutePaths.addFuel),
        child: Container(
          padding: const EdgeInsets.all(kSpaceMD),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kSurfaceGreen),
          ),
          child: Row(
            children: [
              const Icon(Icons.local_gas_station_outlined, color: kTextMuted, size: 24),
              const SizedBox(width: kSpaceMD),
              Expanded(
                child: Text(
                  'No fill-ups logged yet. Tap to add your first.',
                  style: GoogleFonts.poppins(fontSize: kFontSM, color: kTextSecondary),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: kTextMuted, size: 14),
            ],
          ),
        ),
      );
    }

    final previous = fuelProvider.previousEntryForVehicle(activeVehicle.id, latest.id);
    final economy = fuelProvider.computeFuelEconomy(latest, previous);

    return GestureDetector(
      onTap: () => context.push('/fuel/${latest.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border(left: BorderSide(color: kPrimaryGreen, width: 3)),
        ),
        padding: const EdgeInsets.all(14),
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
                      latest.stationName,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryGreen,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      DateFormat('d MMM yyyy').format(latest.date),
                      style: GoogleFonts.poppins(fontSize: 11, color: kTextMuted),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'RM ${latest.totalCost.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryGreen,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${latest.litres.toStringAsFixed(1)} L',
                      style: GoogleFonts.poppins(fontSize: 11, color: kTextSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: kSurfaceGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    latest.fuelType,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryGreen,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (economy > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: kAmberTint,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${economy.toStringAsFixed(1)} km/L',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: kDeepAmber,
                      ),
                    ),
                  ),
                const Spacer(),
                Text(
                  'View details >',
                  style: GoogleFonts.poppins(fontSize: 11, color: kPrimaryGreen),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall,
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    this.subtitleColor = kTextSecondary,
  });

  final String label;
  final String value;
  final String subtitle;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kSurfaceGreen,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: kFontSM,
              fontWeight: FontWeight.w500,
              color: kTextSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: kFontXL,
              fontWeight: FontWeight.w600,
              color: kPrimaryGreen,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(fontSize: kFontXS, color: subtitleColor),
          ),
        ],
      ),
    );
  }
}

class _PricePill extends StatelessWidget {
  const _PricePill({
    required this.label,
    required this.price,
    required this.backgroundColor,
    required this.priceColor,
  });

  final String label;
  final String price;
  final Color backgroundColor;
  final Color priceColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: kFontXS,
              fontWeight: FontWeight.w500,
              color: kTextSecondary,
            ),
          ),
          const SizedBox(height: kSpaceXS),
          Text(
            price,
            style: GoogleFonts.poppins(
              fontSize: kFontLG,
              fontWeight: FontWeight.w600,
              color: priceColor,
            ),
          ),
        ],
      ),
    );
  }
}
