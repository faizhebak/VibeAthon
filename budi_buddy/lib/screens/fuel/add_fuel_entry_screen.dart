import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../models/fuel_entry.dart';
import '../../providers/fuel_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/auth/budibuddy_button.dart';
import '../../widgets/auth/budibuddy_text_field.dart';

class AddFuelEntryScreen extends StatefulWidget {
  const AddFuelEntryScreen({super.key});

  @override
  State<AddFuelEntryScreen> createState() => _AddFuelEntryScreenState();
}

class _AddFuelEntryScreenState extends State<AddFuelEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _litresController = TextEditingController();
  final _priceController = TextEditingController();
  final _odometerController = TextEditingController();
  final _stationController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedFuelType = 'RON95';
  bool _isSaving = false;

  static const List<String> _fuelTypes = ['RON95', 'RON97', 'Diesel'];

  @override
  void initState() {
    super.initState();
    _litresController.addListener(_onFieldChanged);
    _priceController.addListener(_onFieldChanged);
    _odometerController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() => setState(() {});

  @override
  void dispose() {
    _litresController.removeListener(_onFieldChanged);
    _priceController.removeListener(_onFieldChanged);
    _odometerController.removeListener(_onFieldChanged);
    _litresController.dispose();
    _priceController.dispose();
    _odometerController.dispose();
    _stationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double get _totalCost {
    final litres = double.tryParse(_litresController.text.trim());
    final price = double.tryParse(_priceController.text.trim());
    if (litres == null || price == null) return 0.0;
    return litres * price;
  }

  double get _distanceSinceLastFill {
    final vehicleProvider = context.read<VehicleProvider>();
    final fuelProvider = context.read<FuelProvider>();
    final activeVehicle = vehicleProvider.activeVehicle;
    if (activeVehicle == null) return 0.0;

    final latest = fuelProvider.latestEntryForVehicle(activeVehicle.id);
    if (latest == null) return 0.0;

    final odometer = double.tryParse(_odometerController.text.trim());
    if (odometer == null) return 0.0;

    final distance = odometer - latest.odometerKm;
    return distance > 0 ? distance : 0.0;
  }

  double get _fuelEconomy {
    final litres = double.tryParse(_litresController.text.trim());
    final distance = _distanceSinceLastFill;
    if (distance > 0 && litres != null && litres > 0) {
      return distance / litres;
    }
    return 0.0;
  }

  double get _costPerKm {
    final distance = _distanceSinceLastFill;
    final totalCost = _totalCost;
    if (distance > 0 && totalCost > 0) {
      return totalCost / distance;
    }
    return 0.0;
  }

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
          'Log Fill-up',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kWhite,
          ),
        ),
      ),
      body: Consumer2<FuelProvider, VehicleProvider>(
        builder: (context, fuelProvider, vehicleProvider, _) {
          final activeVehicle = vehicleProvider.activeVehicle;

          if (activeVehicle == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No active vehicle. Please select a vehicle first.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: kFontMD, color: kTextSecondary),
                ),
              ),
            );
          }

          final latest = fuelProvider.latestEntryForVehicle(activeVehicle.id);
          final ratedKmL = 100 / activeVehicle.ratedConsumptionL100km;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: kSurfaceGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.directions_car, color: kPrimaryGreen, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Logging for ${activeVehicle.displayName}',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: kPrimaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kSurfaceGreen),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickDate,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: kSurfaceGreen, width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, color: kTextMuted, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    DateFormat('EEEE, d MMMM yyyy').format(_selectedDate),
                                    style: GoogleFonts.poppins(fontSize: 14, color: kTextPrimary),
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down, color: kTextMuted, size: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: kSurfaceGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedFuelType,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              prefixIcon: Icon(Icons.local_gas_station_outlined, color: kTextMuted),
                            ),
                            style: GoogleFonts.poppins(fontSize: 14, color: kPrimaryGreen),
                            icon: const Icon(Icons.keyboard_arrow_down, color: kPrimaryGreen),
                            items: _fuelTypes
                                .map((fuel) => DropdownMenuItem(value: fuel, child: Text(fuel)))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) setState(() => _selectedFuelType = value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'FILL-UP NUMBERS',
                    style: GoogleFonts.poppins(
                      fontSize: kFontXS,
                      fontWeight: FontWeight.w500,
                      color: kTextMuted,
                      letterSpacing: 0.08,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kSurfaceGreen),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: BudiBuddyTextField(
                                controller: _litresController,
                                label: 'Litres Added',
                                hint: 'e.g. 35.50',
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                prefixIcon: const Icon(Icons.water_drop_outlined, color: kTextMuted, size: 18),
                                validator: _positiveDoubleValidator,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: BudiBuddyTextField(
                                controller: _priceController,
                                label: 'Price per Litre (RM)',
                                hint: 'e.g. 2.05',
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text(
                                    'RM',
                                    style: GoogleFonts.poppins(fontSize: 13, color: kTextMuted),
                                  ),
                                ),
                                validator: _positiveDoubleValidator,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        BudiBuddyTextField(
                          controller: _odometerController,
                          label: 'Odometer Reading (km)',
                          hint: 'e.g. 84250',
                          keyboardType: TextInputType.number,
                          prefixIcon: const Icon(Icons.speed_outlined, color: kTextMuted, size: 18),
                          validator: (value) => _odometerValidator(value, latest),
                        ),
                        const SizedBox(height: 14),
                        BudiBuddyTextField(
                          controller: _stationController,
                          label: 'Station Name',
                          hint: 'e.g. Shell Kangkar Pulai',
                          prefixIcon: const Icon(Icons.location_on_outlined, color: kTextMuted, size: 18),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter the station name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        BudiBuddyTextField(
                          controller: _notesController,
                          label: 'Notes (optional)',
                          hint: 'Any additional notes...',
                          maxLines: 2,
                          prefixIcon: const Icon(Icons.notes_outlined, color: kTextMuted, size: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'CALCULATED SUMMARY',
                    style: GoogleFonts.poppins(
                      fontSize: kFontXS,
                      fontWeight: FontWeight.w500,
                      color: kTextMuted,
                      letterSpacing: 0.08,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kSurfaceGreen),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _summaryRow(
                          'Total Cost',
                          _totalCost > 0 ? 'RM ${_totalCost.toStringAsFixed(2)}' : '--',
                        ),
                        const Divider(height: 20, color: kSurfaceGreen),
                        _summaryRow(
                          'Distance Since Last Fill',
                          _distanceSinceLastFill > 0
                              ? '${_distanceSinceLastFill.toStringAsFixed(0)} km'
                              : 'First entry',
                        ),
                        const Divider(height: 20, color: kSurfaceGreen),
                        _summaryRow(
                          'Fuel Economy',
                          _fuelEconomy > 0 ? '${_fuelEconomy.toStringAsFixed(1)} km/L' : '--',
                        ),
                        const Divider(height: 20, color: kSurfaceGreen),
                        _summaryRow(
                          'Cost per km',
                          _costPerKm > 0 ? 'RM ${_costPerKm.toStringAsFixed(3)}' : '--',
                        ),
                        if (_fuelEconomy > 0) ...[
                          const SizedBox(height: 12),
                          _buildEfficiencyBanner(ratedKmL),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  BudiBuddyButton(
                    label: 'Save Entry',
                    icon: Icons.check,
                    isLoading: fuelProvider.isLoading || _isSaving,
                    onPressed: () => _submitEntry(activeVehicle.id),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, color: kTextSecondary)),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: kPrimaryGreen),
        ),
      ],
    );
  }

  Widget _buildEfficiencyBanner(double ratedKmL) {
    final isAboveRated = _fuelEconomy >= ratedKmL;
    final color = isAboveRated ? kAccentGreen : kDeepAmber;
    final message = isAboveRated
        ? "Great efficiency! Above your vehicle's rated economy."
        : 'Below rated economy (${ratedKmL.toStringAsFixed(1)} km/L). Consider smoother driving.';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kSurfaceGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(isAboveRated ? Icons.thumb_up_outlined : Icons.info_outlined, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(fontSize: 12, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submitEntry(String vehicleId) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final entry = FuelEntry(
      id: '',
      vehicleId: vehicleId,
      date: _selectedDate,
      fuelType: _selectedFuelType,
      litres: double.parse(_litresController.text.trim()),
      pricePerLitre: double.parse(_priceController.text.trim()),
      odometerKm: double.parse(_odometerController.text.trim()),
      stationName: _stationController.text.trim(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    await context.read<FuelProvider>().addEntry(entry);

    if (!mounted) return;

    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fill-up logged successfully!')),
    );
    context.pop();
  }

  String? _positiveDoubleValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final parsed = double.tryParse(value.trim());
    if (parsed == null) return 'Enter a valid number';
    if (parsed <= 0) return 'Must be greater than 0';
    return null;
  }

  String? _odometerValidator(String? value, FuelEntry? latest) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final odometer = double.tryParse(value.trim());
    if (odometer == null) return 'Enter a valid number';
    if (latest != null && odometer <= latest.odometerKm) {
      return 'Odometer must be higher than last entry (${latest.odometerKm.toStringAsFixed(0)} km)';
    }
    return null;
  }
}
