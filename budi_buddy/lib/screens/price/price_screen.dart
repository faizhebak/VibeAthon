import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/router.dart';
import '../../models/fuel_price.dart';
import '../../widgets/price/fuel_price_card.dart';
import '../../widgets/price/price_trend_chart.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String _selectedFuelType = 'RON97';
  final Set<String> _visibleFuelTypes = {'RON95', 'RON97', 'Diesel'};

  @override
  Widget build(BuildContext context) {
    final List<FuelPrice> priceHistory = MockData.fuelPrices;
    final FuelPrice currentWeek = priceHistory.last;
    final FuelPrice previousWeek = priceHistory[priceHistory.length - 2];

    return Scaffold(
      backgroundColor: kNeutralBg,
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        elevation: 0,
        title: Text(
          'Fuel Prices',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kWhite,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: kWhite),
            onPressed: () => _showInfoDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.recommend_outlined, color: kWhite),
            tooltip: 'Refuel Advisor',
            onPressed: () => context.push(RoutePaths.refuelAdvisor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(currentWeek),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceCardsSection(currentWeek, previousWeek),
                  const SizedBox(height: 24),
                  _buildAdvisorBanner(context),
                  const SizedBox(height: 24),
                  _buildTrendChartSection(priceHistory),
                  const SizedBox(height: 24),
                  _buildDeepDiveSection(priceHistory, currentWeek),
                  const SizedBox(height: 24),
                  _buildHistoryTableSection(priceHistory, currentWeek),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(FuelPrice currentWeek) {
    final weekEnd = currentWeek.weekStartDate.add(const Duration(days: 6));
    return Container(
      width: double.infinity,
      color: kPrimaryGreen,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CURRENT WEEK',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: kWhite.withValues(alpha: 0.7),
                  letterSpacing: 0.08,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${DateFormat('d MMM yyyy').format(currentWeek.weekStartDate)} – '
                '${DateFormat('d MMM yyyy').format(weekEnd)}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: kWhite,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: kPrimaryAmber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(kRadiusMD),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: kPrimaryAmber,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Live Prices',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryAmber,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCardsSection(FuelPrice currentWeek, FuelPrice previousWeek) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "THIS WEEK'S PRICES",
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: kTextMuted,
            letterSpacing: 0.08,
          ),
        ),
        const SizedBox(height: 10),
        FuelPriceCard(
          fuelType: 'RON95',
          currentPrice: currentWeek.ron95,
          previousPrice: previousWeek.ron95,
          isSelected: _selectedFuelType == 'RON95',
          priceLevel: _computePriceLevel('RON95'),
          onTap: () => setState(() => _selectedFuelType = 'RON95'),
        ),
        const SizedBox(height: 10),
        FuelPriceCard(
          fuelType: 'RON97',
          currentPrice: currentWeek.ron97,
          previousPrice: previousWeek.ron97,
          isSelected: _selectedFuelType == 'RON97',
          priceLevel: _computePriceLevel('RON97'),
          onTap: () => setState(() => _selectedFuelType = 'RON97'),
        ),
        const SizedBox(height: 10),
        FuelPriceCard(
          fuelType: 'Diesel',
          currentPrice: currentWeek.diesel,
          previousPrice: previousWeek.diesel,
          isSelected: _selectedFuelType == 'Diesel',
          priceLevel: _computePriceLevel('Diesel'),
          onTap: () => setState(() => _selectedFuelType = 'Diesel'),
        ),
      ],
    );
  }

  Widget _buildAdvisorBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RoutePaths.refuelAdvisor),
      child: Container(
        decoration: BoxDecoration(
          color: kPrimaryGreen,
          borderRadius: BorderRadius.circular(kRadiusLG),
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
                    'Should you fill up now?',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Get a personalised refuel recommendation',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: kWhite.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: kPrimaryAmber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        child: Text(
                          'Get Advice >',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: kPrimaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.electric_bolt, color: kPrimaryAmber, size: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendChartSection(List<FuelPrice> priceHistory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '12-Week Price Trend',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: kPrimaryGreen,
              ),
            ),
            GestureDetector(
              onTap: () => _showChartInfoDialog(context),
              child: const Icon(
                Icons.help_outline,
                color: kTextMuted,
                size: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(kRadiusLG),
            border: Border.all(color: kSurfaceGreen),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  _toggleChip('RON95', kPrimaryGreen),
                  const SizedBox(width: 8),
                  _toggleChip('RON97', kPrimaryAmber),
                  const SizedBox(width: 8),
                  _toggleChip('Diesel', kGrayMid),
                ],
              ),
              const SizedBox(height: 16),
              PriceTrendChart(
                priceHistory: priceHistory,
                visibleFuelTypes: _visibleFuelTypes,
                height: 220,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_visibleFuelTypes.contains('RON95'))
                    _legendItem('RON95', kPrimaryGreen),
                  if (_visibleFuelTypes.contains('RON97')) ...[
                    const SizedBox(width: 16),
                    _legendItem('RON97', kPrimaryAmber),
                  ],
                  if (_visibleFuelTypes.contains('Diesel')) ...[
                    const SizedBox(width: 16),
                    _legendItem('Diesel', kGrayMid),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeepDiveSection(
    List<FuelPrice> priceHistory,
    FuelPrice currentWeek,
  ) {
    final prices = priceHistory.map((p) {
      switch (_selectedFuelType) {
        case 'RON95':
          return p.ron95;
        case 'RON97':
          return p.ron97;
        default:
          return p.diesel;
      }
    }).toList();

    final minPrice = prices.reduce(math.min);
    final maxPrice = prices.reduce(math.max);
    final avgPrice = prices.reduce((a, b) => a + b) / prices.length;
    final currentPrice = _selectedFuelType == 'RON95'
        ? currentWeek.ron95
        : _selectedFuelType == 'RON97'
            ? currentWeek.ron97
            : currentWeek.diesel;
    final changeFromAvg = currentPrice - avgPrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Analysis: $_selectedFuelType',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: kPrimaryGreen,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(kRadiusLG),
            border: Border.all(color: kSurfaceGreen),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _priceStatItem(
                    '12-Week Low',
                    'RM ${minPrice.toStringAsFixed(2)}',
                    kAccentGreen,
                  ),
                  _dividerVertical(),
                  _priceStatItem(
                    'Average',
                    'RM ${avgPrice.toStringAsFixed(2)}',
                    kPrimaryGreen,
                  ),
                  _dividerVertical(),
                  _priceStatItem(
                    '12-Week High',
                    'RM ${maxPrice.toStringAsFixed(2)}',
                    kError,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: changeFromAvg > 0
                      ? kErrorSurface
                      : changeFromAvg < 0
                          ? kSurfaceGreen
                          : kNeutralBg,
                  borderRadius: BorderRadius.circular(kRadiusMD),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      changeFromAvg > 0
                          ? Icons.trending_up
                          : changeFromAvg < 0
                              ? Icons.trending_down
                              : Icons.trending_flat,
                      color: changeFromAvg > 0
                          ? kError
                          : changeFromAvg < 0
                              ? kAccentGreen
                              : kTextMuted,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        changeFromAvg > 0
                            ? 'Current price is RM ${changeFromAvg.abs().toStringAsFixed(2)} above the 12-week average.'
                            : changeFromAvg < 0
                                ? 'Current price is RM ${changeFromAvg.abs().toStringAsFixed(2)} below the 12-week average — relatively good time to fill up.'
                                : 'Current price is exactly at the 12-week average.',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: changeFromAvg > 0
                              ? kError
                              : changeFromAvg < 0
                                  ? kAccentGreen
                                  : kTextMuted,
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

  Widget _buildHistoryTableSection(
    List<FuelPrice> priceHistory,
    FuelPrice currentWeek,
  ) {
    final reversed = priceHistory.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weekly Price History',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: kPrimaryGreen,
              ),
            ),
            Text(
              'Last 12 weeks',
              style: GoogleFonts.poppins(fontSize: 11, color: kTextMuted),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(kRadiusLG),
            border: Border.all(color: kSurfaceGreen),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                color: kSurfaceGreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Week',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryGreen,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'RON95',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryGreen,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'RON97',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryGreen,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Diesel',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              for (var index = 0; index < reversed.length; index++)
                _buildHistoryRow(reversed[index], index, currentWeek),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryRow(FuelPrice entry, int index, FuelPrice currentWeek) {
    final isCurrentWeek = entry == currentWeek;
    return Container(
      decoration: BoxDecoration(
        color: isCurrentWeek
            ? kSurfaceGreen
            : index % 2 == 0
                ? kWhite
                : kNeutralBg.withValues(alpha: 0.3),
        border: const Border(
          bottom: BorderSide(color: kSurfaceGreen, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('d MMM').format(entry.weekStartDate),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: kPrimaryGreen,
                  ),
                ),
                if (isCurrentWeek) ...[
                  const SizedBox(width: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimaryGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    child: Text(
                      'Now',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: kWhite,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'RM ${entry.ron95.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12, color: kPrimaryGreen),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'RM ${entry.ron97.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12, color: kDeepAmber),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'RM ${entry.diesel.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12, color: kGrayMid),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleChip(String fuelType, Color color) {
    final isVisible = _visibleFuelTypes.contains(fuelType);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isVisible) {
            if (_visibleFuelTypes.length > 1) {
              _visibleFuelTypes.remove(fuelType);
            }
          } else {
            _visibleFuelTypes.add(fuelType);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isVisible ? color.withValues(alpha: 0.15) : kNeutralBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isVisible ? color : kSurfaceGreen),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isVisible ? color : kTextMuted,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              fuelType,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isVisible ? color : kTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.poppins(fontSize: 11, color: kTextMuted)),
      ],
    );
  }

  Widget _priceStatItem(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 11, color: kTextMuted),
        ),
      ],
    );
  }

  Widget _dividerVertical() {
    return Container(width: 1, height: 40, color: kSurfaceGreen);
  }

  PriceLevel _computePriceLevel(String fuelType) {
    if (fuelType == 'RON95') return PriceLevel.cheap;

    final priceHistory = MockData.fuelPrices;
    final currentWeek = priceHistory.last;
    final values = priceHistory
        .map((p) => fuelType == 'RON97' ? p.ron97 : p.diesel)
        .toList();
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final current = fuelType == 'RON97' ? currentWeek.ron97 : currentWeek.diesel;

    if (current <= minValue + (maxValue - minValue) * 0.33) return PriceLevel.cheap;
    if (current <= minValue + (maxValue - minValue) * 0.66) return PriceLevel.mid;
    return PriceLevel.high;
  }

  void _showInfoDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'About Fuel Prices',
          style: GoogleFonts.poppins(
            fontSize: kFontMD,
            fontWeight: FontWeight.w600,
            color: kPrimaryGreen,
          ),
        ),
        content: Text(
          'RON95 prices are fixed by the Malaysian government and revised '
          'weekly. RON97 and Diesel prices fluctuate based on global oil '
          'market conditions. Price revisions are announced every Friday '
          'and take effect on Saturday midnight.',
          style: GoogleFonts.poppins(fontSize: kFontSM, color: kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Got it',
              style: GoogleFonts.poppins(
                color: kPrimaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showChartInfoDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'About This Chart',
          style: GoogleFonts.poppins(
            fontSize: kFontMD,
            fontWeight: FontWeight.w600,
            color: kPrimaryGreen,
          ),
        ),
        content: Text(
          'This chart shows how RON95, RON97, and Diesel prices have moved '
          'over the last 12 weeks. Tap the chips above to show or hide each '
          'fuel type, and tap a point on the chart to see its exact price.',
          style: GoogleFonts.poppins(fontSize: kFontSM, color: kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Got it',
              style: GoogleFonts.poppins(
                color: kPrimaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
