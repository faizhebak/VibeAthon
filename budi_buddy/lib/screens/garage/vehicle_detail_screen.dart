import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../models/vehicle.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/auth/budibuddy_text_field.dart';

class VehicleDetailScreen extends StatefulWidget {
  const VehicleDetailScreen({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _variantController = TextEditingController();
  final _yearController = TextEditingController();
  final _engineCapacityController = TextEditingController();
  final _tankCapacityController = TextEditingController();
  final _ratedConsumptionController = TextEditingController();
  String _selectedFuelType = 'RON95';

  static const List<String> _fuelTypes = ['RON95', 'RON97', 'Diesel'];

  @override
  void initState() {
    super.initState();
    final vehicles = context.read<VehicleProvider>().vehicles;
    final index = vehicles.indexWhere((v) => v.id == widget.vehicleId);
    if (index == -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pop();
      });
    } else {
      _populateControllers(vehicles[index]);
    }
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _variantController.dispose();
    _yearController.dispose();
    _engineCapacityController.dispose();
    _tankCapacityController.dispose();
    _ratedConsumptionController.dispose();
    super.dispose();
  }

  void _populateControllers(Vehicle vehicle) {
    _makeController.text = vehicle.make;
    _modelController.text = vehicle.model;
    _variantController.text = vehicle.variant;
    _yearController.text = vehicle.year.toString();
    _engineCapacityController.text = vehicle.engineCapacityCC.toString();
    _tankCapacityController.text = vehicle.tankCapacityL.toString();
    _ratedConsumptionController.text = vehicle.ratedConsumptionL100km.toString();
    _selectedFuelType = vehicle.fuelType;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleProvider>(
      builder: (context, vehicleProvider, _) {
        final vehicles = vehicleProvider.vehicles;
        final index = vehicles.indexWhere((v) => v.id == widget.vehicleId);

        if (index == -1) {
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
                'Vehicle',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kWhite,
                ),
              ),
            ),
            body: Center(
              child: Text(
                'Vehicle not found.',
                style: GoogleFonts.poppins(fontSize: kFontBase, color: kTextSecondary),
              ),
            ),
          );
        }

        final vehicle = vehicles[index];

        return Scaffold(
          backgroundColor: kNeutralBg,
          appBar: AppBar(
            backgroundColor: kPrimaryGreen,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: kWhite),
              onPressed: () {
                if (_isEditing) {
                  setState(() => _isEditing = false);
                } else {
                  context.pop();
                }
              },
            ),
            title: Text(
              _isEditing ? 'Edit Vehicle' : vehicle.displayName,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kWhite,
              ),
            ),
            actions: _isEditing
                ? null
                : [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: kWhite),
                      onPressed: () {
                        _populateControllers(vehicle);
                        setState(() => _isEditing = true);
                      },
                    ),
                  ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(kSpaceMD),
            child: _isEditing ? _buildEditMode(vehicle) : _buildViewMode(vehicle),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------
  // View mode
  // ---------------------------------------------------------------------
  Widget _buildViewMode(Vehicle vehicle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(kRadiusLG),
            border: Border.all(color: kSurfaceGreen),
          ),
          padding: const EdgeInsets.all(kSpaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: kSurfaceGreen,
                      borderRadius: BorderRadius.circular(kRadiusMD),
                    ),
                    child: const Icon(Icons.directions_car, color: kPrimaryGreen, size: 32),
                  ),
                  const SizedBox(width: kSpaceMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.displayName,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (vehicle.isActive)
                          Row(
                            children: [
                              const Icon(Icons.check_circle, color: kAccentGreen, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Active Vehicle',
                                style: GoogleFonts.poppins(
                                  fontSize: kFontXS,
                                  fontWeight: FontWeight.w500,
                                  color: kAccentGreen,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            'Not active',
                            style: GoogleFonts.poppins(fontSize: kFontXS, color: kTextMuted),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 28, color: kSurfaceGreen),
              Text(
                'SPECIFICATIONS',
                style: GoogleFonts.poppins(
                  fontSize: kFontXS,
                  fontWeight: FontWeight.w500,
                  color: kTextMuted,
                  letterSpacing: 0.08,
                ),
              ),
              const SizedBox(height: kSpaceSM),
              _specRow('Make', vehicle.make),
              _specRow('Model', vehicle.model),
              _specRow('Variant', vehicle.variant),
              _specRow('Year', vehicle.year.toString()),
              _specRow('Engine Capacity', '${vehicle.engineCapacityCC} cc'),
              _specRow('Fuel Type', vehicle.fuelType),
              _specRow('Tank Capacity', '${vehicle.tankCapacityL.toStringAsFixed(0)} L'),
              _specRow(
                'Rated Consumption',
                '${vehicle.ratedConsumptionL100km.toStringAsFixed(1)} L/100km',
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: kSpaceLG),
        if (!vehicle.isActive)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryGreen),
              onPressed: () {
                context.read<VehicleProvider>().setActiveVehicle(vehicle.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${vehicle.displayName} is now your active vehicle.')),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: kSpaceXS),
                child: Text(
                  'Set as Active Vehicle',
                  style: GoogleFonts.poppins(
                    fontSize: kFontBase,
                    fontWeight: FontWeight.w600,
                    color: kWhite,
                  ),
                ),
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(kSpaceMD),
            decoration: BoxDecoration(
              color: kSurfaceGreen,
              borderRadius: BorderRadius.circular(kRadiusMD),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: kAccentGreen, size: 18),
                const SizedBox(width: kSpaceSM),
                Text(
                  'This is your active vehicle',
                  style: GoogleFonts.poppins(
                    fontSize: kFontBase,
                    fontWeight: FontWeight.w500,
                    color: kAccentGreen,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: kSpaceMD),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _showDeleteDialog(vehicle),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: kError, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: kSpaceSM),
            ),
            child: Text(
              'Delete Vehicle',
              style: GoogleFonts.poppins(
                fontSize: kFontBase,
                fontWeight: FontWeight.w600,
                color: kError,
              ),
            ),
          ),
        ),
        const SizedBox(height: kSpaceLG),
      ],
    );
  }

  Widget _specRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : kSpaceSM),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(fontSize: kFontSM, color: kTextSecondary),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: kFontSM,
              fontWeight: FontWeight.w600,
              color: kPrimaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Edit mode
  // ---------------------------------------------------------------------
  Widget _buildEditMode(Vehicle vehicle) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(kRadiusLG),
              border: Border.all(color: kSurfaceGreen),
            ),
            padding: const EdgeInsets.all(kSpaceMD),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: BudiBuddyTextField(
                        controller: _makeController,
                        label: 'Make',
                        validator: _requiredValidator,
                      ),
                    ),
                    const SizedBox(width: kSpaceSM),
                    Expanded(
                      child: BudiBuddyTextField(
                        controller: _modelController,
                        label: 'Model',
                        validator: _requiredValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpaceMD),
                BudiBuddyTextField(
                  controller: _variantController,
                  label: 'Variant',
                  validator: _requiredValidator,
                ),
                const SizedBox(height: kSpaceMD),
                Row(
                  children: [
                    Expanded(
                      child: BudiBuddyTextField(
                        controller: _yearController,
                        label: 'Year',
                        keyboardType: TextInputType.number,
                        validator: _yearValidator,
                      ),
                    ),
                    const SizedBox(width: kSpaceSM),
                    Expanded(
                      child: BudiBuddyTextField(
                        controller: _engineCapacityController,
                        label: 'Engine (cc)',
                        keyboardType: TextInputType.number,
                        validator: _intValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpaceMD),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Fuel Type',
                    style: GoogleFonts.poppins(
                      fontSize: kFontSM,
                      fontWeight: FontWeight.w500,
                      color: kTextSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: kSpaceXS),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kSurfaceGreen,
                    borderRadius: BorderRadius.circular(kRadiusMD),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedFuelType,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: GoogleFonts.poppins(fontSize: kFontMD, color: kPrimaryGreen),
                    icon: const Icon(Icons.keyboard_arrow_down, color: kPrimaryGreen),
                    items: _fuelTypes
                        .map((fuel) => DropdownMenuItem(value: fuel, child: Text(fuel)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedFuelType = value);
                    },
                  ),
                ),
                const SizedBox(height: kSpaceMD),
                Row(
                  children: [
                    Expanded(
                      child: BudiBuddyTextField(
                        controller: _tankCapacityController,
                        label: 'Tank (L)',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: _doubleValidator,
                      ),
                    ),
                    const SizedBox(width: kSpaceSM),
                    Expanded(
                      child: BudiBuddyTextField(
                        controller: _ratedConsumptionController,
                        label: 'L/100km',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: _doubleValidator,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: kSpaceLG),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _isEditing = false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: kSpaceSM),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontSize: kFontBase,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: kSpaceSM),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: kSpaceSM),
                  ),
                  onPressed: () => _submitEdit(vehicle),
                  child: Text(
                    'Save Changes',
                    style: GoogleFonts.poppins(
                      fontSize: kFontBase,
                      fontWeight: FontWeight.w600,
                      color: kWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpaceLG),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------
  Future<void> _submitEdit(Vehicle vehicle) async {
    if (!_formKey.currentState!.validate()) return;

    final updated = vehicle.copyWith(
      make: _makeController.text.trim(),
      model: _modelController.text.trim(),
      variant: _variantController.text.trim(),
      year: int.parse(_yearController.text.trim()),
      engineCapacityCC: int.parse(_engineCapacityController.text.trim()),
      fuelType: _selectedFuelType,
      tankCapacityL: double.parse(_tankCapacityController.text.trim()),
      ratedConsumptionL100km: double.parse(_ratedConsumptionController.text.trim()),
    );

    await context.read<VehicleProvider>().updateVehicle(updated);

    if (!mounted) return;

    setState(() => _isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vehicle updated successfully.')),
    );
  }

  void _showDeleteDialog(Vehicle vehicle) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Delete Vehicle?',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kPrimaryGreen,
            ),
          ),
          content: Text(
            'This will permanently remove ${vehicle.displayName} from your garage. This action cannot be undone.',
            style: GoogleFonts.poppins(fontSize: kFontSM, color: kTextSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontSize: kFontSM,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryGreen,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kError),
              onPressed: () {
                context.read<VehicleProvider>().deleteVehicle(vehicle.id);
                Navigator.of(dialogContext).pop();
                context.pop();
              },
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(
                  fontSize: kFontSM,
                  fontWeight: FontWeight.w600,
                  color: kWhite,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------
  // Validators
  // ---------------------------------------------------------------------
  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    return null;
  }

  String? _yearValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    final year = int.tryParse(value.trim());
    if (year == null) return 'Enter a valid year';
    if (year < 1990 || year > 2026) return 'Enter a year between 1990 and 2026';
    return null;
  }

  String? _intValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    if (int.tryParse(value.trim()) == null) return 'Enter a valid number';
    return null;
  }

  String? _doubleValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required';
    if (double.tryParse(value.trim()) == null) return 'Enter a valid number';
    return null;
  }
}
