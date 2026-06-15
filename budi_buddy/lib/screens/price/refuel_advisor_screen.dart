import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../models/fuel_price.dart';
import '../../models/vehicle.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/auth/budibuddy_button.dart';

class RefuelAdvisorScreen extends StatefulWidget {
  const RefuelAdvisorScreen({super.key});

  @override
  State<RefuelAdvisorScreen> createState() => _RefuelAdvisorScreenState();
}

class _RefuelAdvisorScreenState extends State<RefuelAdvisorScreen> {
  double _fillPercentage = 100.0;

  @override
  Widget build(BuildContext context) {
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
          'Refuel Advisor',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kWhite,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_edu_outlined, color: kWhite),
            tooltip: 'How this works',
            onPressed: () => _showMethodologySheet(context),
          ),
        ],
      ),
      body: Consumer<VehicleProvider>(
        builder: (context, vehicleProvider, child) {
          final activeVehicle = vehicleProvider.activeVehicle;
          if (activeVehicle == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(kSpaceLG),
                child: Text(
                  'No active vehicle selected. Please add a vehicle in '
                  'Garage first.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: kTextSecondary,
                  ),
                ),
              ),
            );
          }

          final currentWeek = MockData.fuelPrices.last;
          final tankCapacity = activeVehicle.tankCapacityL;
          final recommendedLitres = tankCapacity * (_fillPercentage / 100);
          final fuelType = activeVehicle.fuelType;
          final pricePerLitre = fuelType == 'RON95'
              ? currentWeek.ron95
              : fuelType == 'RON97'
                  ? currentWeek.ron97
                  : currentWeek.diesel;
          final estimatedCost = recommendedLitres * pricePerLitre;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroCard(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCountdownSection(),
                      const SizedBox(height: 20),
                      _buildFillCalculatorSection(
                        activeVehicle,
                        tankCapacity,
                        recommendedLitres,
                        fuelType,
                        pricePerLitre,
                        estimatedCost,
                      ),
                      const SizedBox(height: 20),
                      _buildQuickPricesSection(currentWeek),
                      const SizedBox(height: 20),
                      _buildTipsSection(),
                      const SizedBox(height: 20),
                      _buildViewHistoryButton(context),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      color: kPrimaryGreen,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: kPrimaryAmber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(kRadiusMD),
                ),
                child: const Icon(
                  Icons.electric_bolt,
                  color: kPrimaryAmber,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our Recommendation',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: kWhite.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      MockData.refuelRecommendation,
                      maxLines: 2,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryAmber,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: kWhite.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(kRadiusLG),
            ),
            padding: const EdgeInsets.all(14),
            child: Text(
              MockData.refuelRecommendationReason,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: kWhite.withValues(alpha: 0.9),
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Confidence',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: kWhite.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${MockData.refuelConfidencePercent}%',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryAmber,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _confidenceBadge(MockData.refuelConfidencePercent),
                    ],
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 40,
                color: kWhite.withValues(alpha: 0.2),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Next Revision',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: kWhite.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${MockData.daysUntilNextRevision} days',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: kWhite,
                    ),
                  ),
                  Text(
                    MockData.nextRevisionDay,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: kWhite.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NEXT PRICE REVISION',
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: kTextMuted,
            letterSpacing: 0.08,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(kRadiusLG),
            border: Border.all(color: kSurfaceGreen),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prices revise every ${MockData.nextRevisionDay}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Today is '
                      '${DateFormat('EEEE, d MMMM yyyy').format(DateTime.now())}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: kTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: (7 - MockData.daysUntilNextRevision) / 7,
                      backgroundColor: kSurfaceGreen,
                      valueColor: const AlwaysStoppedAnimation(kPrimaryGreen),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(kRadiusSM),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Last revision',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: kTextMuted,
                          ),
                        ),
                        Text(
                          '${MockData.daysUntilNextRevision} days left',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: kSurfaceGreen,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${MockData.daysUntilNextRevision}',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryGreen,
                        ),
                      ),
                      Text(
                        'days',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: kTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFillCalculatorSection(
    Vehicle activeVehicle,
    double tankCapacity,
    double recommendedLitres,
    String fuelType,
    double pricePerLitre,
    double estimatedCost,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FILL CALCULATOR',
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: kTextMuted,
            letterSpacing: 0.08,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(kRadiusLG),
            border: Border.all(color: kSurfaceGreen),
          ),
          padding: const EdgeInsets.all(16),
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
                        'Active Vehicle',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: kTextMuted,
                        ),
                      ),
                      Text(
                        activeVehicle.displayName,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryGreen,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kSurfaceGreen,
                      borderRadius: BorderRadius.circular(kRadiusMD),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Text(
                      '${tankCapacity.toStringAsFixed(0)}L tank',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'How much do you want to fill?',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: kTextSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fill amount: ${_fillPercentage.toStringAsFixed(0)}%',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryGreen,
                    ),
                  ),
                  Text(
                    '${recommendedLitres.toStringAsFixed(1)} L',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kDeepAmber,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: kPrimaryGreen,
                  inactiveTrackColor: kSurfaceGreen,
                  thumbColor: kPrimaryAmber,
                  overlayColor: kPrimaryAmber.withValues(alpha: 0.2),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: _fillPercentage,
                  min: 10,
                  max: 100,
                  divisions: 9,
                  onChanged: (value) =>
                      setState(() => _fillPercentage = value),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('10%', style: GoogleFonts.poppins(fontSize: 10, color: kTextMuted)),
                  Text('25%', style: GoogleFonts.poppins(fontSize: 10, color: kTextMuted)),
                  Text('50%', style: GoogleFonts.poppins(fontSize: 10, color: kTextMuted)),
                  Text('75%', style: GoogleFonts.poppins(fontSize: 10, color: kTextMuted)),
                  Text('100%', style: GoogleFonts.poppins(fontSize: 10, color: kTextMuted)),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: kSurfaceGreen),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated Cost',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: kTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'RM ${estimatedCost.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryGreen,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        fuelType,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: kTextMuted,
                        ),
                      ),
                      Text(
                        'RM ${pricePerLitre.toStringAsFixed(2)}/L',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kDeepAmber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: kSurfaceGreen,
                  borderRadius: BorderRadius.circular(kRadiusMD),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: kPrimaryGreen, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Filling ${recommendedLitres.toStringAsFixed(1)}L of '
                        '$fuelType at current price before the revision '
                        'could save you up to RM '
                        '${(recommendedLitres * 0.15).toStringAsFixed(2)} '
                        'if prices rise.',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: kPrimaryGreen,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickPricesSection(FuelPrice currentWeek) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CURRENT PRICES AT A GLANCE',
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: kTextMuted,
            letterSpacing: 0.08,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _quickPriceCard('RON95', currentWeek.ron95, kPrimaryGreen),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _quickPriceCard('RON97', currentWeek.ron97, kDeepAmber),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _quickPriceCard('Diesel', currentWeek.diesel, kGrayMid),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MONEY-SAVING TIPS',
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: kTextMuted,
            letterSpacing: 0.08,
          ),
        ),
        const SizedBox(height: 10),
        _tipCard(
          Icons.schedule_outlined,
          'Fill up before Sunday midnight',
          'Price revisions take effect at midnight Saturday/Sunday. Filling '
              'up before then locks in the current price.',
        ),
        const SizedBox(height: 10),
        _tipCard(
          Icons.trending_down_outlined,
          'Fill more when prices are low',
          'When prices are below the 12-week average, consider filling up '
              'to 100% to maximise savings.',
        ),
        const SizedBox(height: 10),
        _tipCard(
          Icons.local_gas_station_outlined,
          'Use RON95 if your car allows',
          'RON95 is government-subsidised and significantly cheaper. Check '
              'your vehicle manual — many modern cars run fine on RON95.',
        ),
        const SizedBox(height: 10),
        _tipCard(
          Icons.speed_outlined,
          'Drive efficiently to stretch each tank',
          'Smooth acceleration and coasting can improve your fuel economy '
              'by up to 15%, effectively reducing your cost per km.',
        ),
      ],
    );
  }

  Widget _buildViewHistoryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.show_chart, color: kPrimaryGreen),
        label: Text(
          'View Full Price History',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: kPrimaryGreen,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: kPrimaryGreen),
          foregroundColor: kPrimaryGreen,
        ),
      ),
    );
  }

  Widget _confidenceBadge(int percent) {
    final color = percent >= 75
        ? kAccentGreen
        : percent >= 50
            ? kDeepAmber
            : kError;
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Text(
        percent >= 75
            ? 'High'
            : percent >= 50
                ? 'Medium'
                : 'Low',
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _quickPriceCard(String fuelType, double price, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            fuelType,
            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            'RM ${price.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: color),
          ),
          Text(
            'per litre',
            style: GoogleFonts.poppins(fontSize: 10, color: kTextMuted),
          ),
        ],
      ),
    );
  }

  Widget _tipCard(IconData icon, String title, String body) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kSurfaceGreen),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: kSurfaceGreen,
              borderRadius: BorderRadius.circular(kRadiusMD),
            ),
            child: Icon(icon, color: kPrimaryGreen, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: kTextSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMethodologySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: kWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusLG)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How the Refuel Advisor Works',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryGreen,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'The advisor analyses 12 weeks of historical price data '
                  'to detect trends. It looks for consecutive weekly '
                  'increases in RON97 and Diesel prices, as these often '
                  'precede a revision. The confidence score reflects how '
                  'consistent the trend has been — 3 or more weeks of '
                  'increases gives a high confidence score. This is a '
                  'predictive tool based on historical patterns only and '
                  'is not guaranteed.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: kTextSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                BudiBuddyButton(
                  label: 'Got it',
                  onPressed: () => Navigator.pop(sheetContext),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
