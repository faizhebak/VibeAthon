import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../models/vehicle.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/auth/budibuddy_button.dart';
import '../../widgets/auth/budibuddy_text_field.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _variantController = TextEditingController();
  final _yearController = TextEditingController();
  final _engineCapacityController = TextEditingController();
  final _tankCapacityController = TextEditingController();
  final _ratedConsumptionController = TextEditingController();

  String _selectedFuelType = 'RON95';
  bool _isAiLoading = false;
  bool _aiFormFilled = false;
  bool _isSaving = false;
  XFile? _pickedImage;

  static const List<String> _fuelTypes = ['RON95', 'RON97', 'Diesel'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _variantController.dispose();
    _yearController.dispose();
    _engineCapacityController.dispose();
    _tankCapacityController.dispose();
    _ratedConsumptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNeutralBg,
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        elevation: 0,
        title: Text(
          'Add Vehicle',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kWhite,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: kPrimaryAmber,
          indicatorWeight: 3,
          labelColor: kWhite,
          unselectedLabelColor: kWhite.withValues(alpha: 0.5),
          labelStyle: GoogleFonts.poppins(
            fontSize: kFontSM,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Manual Entry'),
            Tab(text: 'AI Photo'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildManualTab(),
          _buildAITab(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Manual Entry tab
  // ---------------------------------------------------------------------
  Widget _buildManualTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kSpaceMD),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VEHICLE INFORMATION',
              style: GoogleFonts.poppins(
                fontSize: kFontXS,
                fontWeight: FontWeight.w500,
                color: kTextMuted,
                letterSpacing: 0.08,
              ),
            ),
            const SizedBox(height: kSpaceSM),
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
                          hint: 'e.g. Perodua',
                          validator: _requiredValidator,
                        ),
                      ),
                      const SizedBox(width: kSpaceSM),
                      Expanded(
                        child: BudiBuddyTextField(
                          controller: _modelController,
                          label: 'Model',
                          hint: 'e.g. Myvi',
                          validator: _requiredValidator,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: kSpaceMD),
                  BudiBuddyTextField(
                    controller: _variantController,
                    label: 'Variant',
                    hint: 'e.g. 1.5 AV',
                    validator: _requiredValidator,
                  ),
                  const SizedBox(height: kSpaceMD),
                  Row(
                    children: [
                      Expanded(
                        child: BudiBuddyTextField(
                          controller: _yearController,
                          label: 'Year',
                          hint: 'e.g. 2021',
                          keyboardType: TextInputType.number,
                          validator: _yearValidator,
                        ),
                      ),
                      const SizedBox(width: kSpaceSM),
                      Expanded(
                        child: BudiBuddyTextField(
                          controller: _engineCapacityController,
                          label: 'Engine (cc)',
                          hint: 'e.g. 1500',
                          keyboardType: TextInputType.number,
                          validator: _intValidator,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpaceLG),
            Text(
              'FUEL & CAPACITY',
              style: GoogleFonts.poppins(
                fontSize: kFontXS,
                fontWeight: FontWeight.w500,
                color: kTextMuted,
                letterSpacing: 0.08,
              ),
            ),
            const SizedBox(height: kSpaceSM),
            Container(
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(kRadiusLG),
                border: Border.all(color: kSurfaceGreen),
              ),
              padding: const EdgeInsets.all(kSpaceMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fuel Type',
                    style: GoogleFonts.poppins(
                      fontSize: kFontSM,
                      fontWeight: FontWeight.w500,
                      color: kTextSecondary,
                    ),
                  ),
                  const SizedBox(height: kSpaceXS),
                  Container(
                    decoration: BoxDecoration(
                      color: kSurfaceGreen,
                      borderRadius: BorderRadius.circular(kRadiusMD),
                    ),
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedFuelType,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: kFontMD,
                        color: kPrimaryGreen,
                      ),
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
                          label: 'Tank Capacity (L)',
                          hint: 'e.g. 35',
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: _doubleValidator,
                        ),
                      ),
                      const SizedBox(width: kSpaceSM),
                      Expanded(
                        child: BudiBuddyTextField(
                          controller: _ratedConsumptionController,
                          label: 'Rated (L/100km)',
                          hint: 'e.g. 5.9',
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
            BudiBuddyButton(
              label: 'Save Vehicle',
              icon: Icons.check,
              isLoading: _isSaving,
              onPressed: _submitManualForm,
            ),
            const SizedBox(height: kSpaceLG),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // AI Photo tab
  // ---------------------------------------------------------------------
  Widget _buildAITab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kSpaceMD),
      child: Column(
        children: [
          if (_pickedImage == null)
            _buildUploadPrompt()
          else if (_isAiLoading)
            _buildAiLoading()
          else if (_aiFormFilled)
            _buildAiResult(),
        ],
      ),
    );
  }

  Widget _buildUploadPrompt() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kSurfaceGreen,
          borderRadius: BorderRadius.circular(kRadiusLG),
          border: Border.all(color: kAccentGreen.withValues(alpha: 0.5), width: 1.5),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_a_photo_outlined, color: kAccentGreen, size: 40),
              const SizedBox(height: kSpaceSM),
              Text(
                'Tap to take a photo or upload',
                style: GoogleFonts.poppins(
                  fontSize: kFontMD,
                  fontWeight: FontWeight.w500,
                  color: kPrimaryGreen,
                ),
              ),
              const SizedBox(height: kSpaceXS),
              Text(
                'AI will auto-detect your vehicle details',
                style: GoogleFonts.poppins(fontSize: kFontXS, color: kTextMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiLoading() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(kRadiusLG),
          child: Image.file(
            File(_pickedImage!.path),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: kSpaceMD),
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
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryAmber),
                    ),
                  ),
                  const SizedBox(width: kSpaceSM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analysing your vehicle...',
                          style: GoogleFonts.poppins(
                            fontSize: kFontMD,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryGreen,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'AI is detecting make, model and specs',
                          style: GoogleFonts.poppins(fontSize: kFontXS, color: kTextMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: kSpaceMD),
              _shimmerRow(),
              _shimmerRow(),
              _shimmerRow(),
              _shimmerRow(widthFactor: 0.6),
            ],
          ),
        ),
      ],
    );
  }

  Widget _shimmerRow({double widthFactor = 1.0}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kSpaceSM),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: widthFactor,
        child: Container(
          height: 14,
          decoration: BoxDecoration(
            color: kSurfaceGreen,
            borderRadius: BorderRadius.circular(kRadiusSM),
          ),
        ),
      ),
    );
  }

  Widget _buildAiResult() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(kRadiusLG),
          child: Image.file(
            File(_pickedImage!.path),
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: kSpaceSM),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: kAccentGreen, size: 16),
            const SizedBox(width: kSpaceXS),
            Text(
              'Vehicle detected successfully',
              style: GoogleFonts.poppins(
                fontSize: kFontXS,
                fontWeight: FontWeight.w500,
                color: kAccentGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: kSpaceMD),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detected Details',
                    style: GoogleFonts.poppins(
                      fontSize: kFontSM,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryGreen,
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Text(
                      'Retake',
                      style: GoogleFonts.poppins(
                        fontSize: kFontXS,
                        color: kPrimaryGreen,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: kSpaceMD),
              _detailRow('Make', _makeController.text),
              _detailRow('Model', _modelController.text),
              _detailRow('Variant', _variantController.text),
              _detailRow('Year', _yearController.text),
              _detailRow('Engine', '${_engineCapacityController.text} cc'),
              _detailRow('Fuel Type', _selectedFuelType),
              _detailRow('Tank', '${_tankCapacityController.text} L'),
              _detailRow('Rated Consumption', '${_ratedConsumptionController.text} L/100km'),
            ],
          ),
        ),
        const SizedBox(height: kSpaceMD),
        Text(
          'You can fine-tune these details in the Manual Entry tab.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: kFontXS, color: kTextMuted),
        ),
        const SizedBox(height: kSpaceMD),
        BudiBuddyButton(
          label: 'Save Vehicle',
          icon: Icons.check,
          isLoading: _isSaving,
          onPressed: _submitAiForm,
        ),
        const SizedBox(height: kSpaceLG),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kSpaceSM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: kFontSM, color: kTextSecondary)),
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
  // Actions
  // ---------------------------------------------------------------------
  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: kWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusLG)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: kSpaceSM),
              Text(
                'Add a Vehicle Photo',
                style: GoogleFonts.poppins(
                  fontSize: kFontMD,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryGreen,
                ),
              ),
              const SizedBox(height: kSpaceSM),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: kPrimaryGreen),
                title: Text(
                  'Take a Photo',
                  style: GoogleFonts.poppins(fontSize: kFontBase, color: kPrimaryGreen),
                ),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: kPrimaryGreen),
                title: Text(
                  'Choose from Gallery',
                  style: GoogleFonts.poppins(fontSize: kFontBase, color: kPrimaryGreen),
                ),
                onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
              ),
              const SizedBox(height: kSpaceSM),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image == null) return;

    setState(() {
      _pickedImage = image;
      _isAiLoading = true;
      _aiFormFilled = false;
    });

    await Future.delayed(const Duration(seconds: 2));

    _makeController.text = 'Perodua';
    _modelController.text = 'Myvi';
    _variantController.text = '1.5 AV';
    _yearController.text = '2022';
    _engineCapacityController.text = '1500';
    _tankCapacityController.text = '35';
    _ratedConsumptionController.text = '5.9';
    _selectedFuelType = 'RON95';

    if (!mounted) return;

    setState(() {
      _isAiLoading = false;
      _aiFormFilled = true;
    });
  }

  Future<void> _submitManualForm() async {
    if (!_formKey.currentState!.validate()) return;
    await _saveVehicle();
  }

  Future<void> _submitAiForm() async {
    await _saveVehicle();
  }

  Future<void> _saveVehicle() async {
    setState(() => _isSaving = true);

    final vehicle = Vehicle(
      id: '',
      make: _makeController.text.trim(),
      model: _modelController.text.trim(),
      variant: _variantController.text.trim(),
      year: int.parse(_yearController.text.trim()),
      engineCapacityCC: int.parse(_engineCapacityController.text.trim()),
      fuelType: _selectedFuelType,
      tankCapacityL: double.parse(_tankCapacityController.text.trim()),
      ratedConsumptionL100km: double.parse(_ratedConsumptionController.text.trim()),
      isActive: false,
    );

    await context.read<VehicleProvider>().addVehicle(vehicle);

    if (!mounted) return;

    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vehicle added successfully!')),
    );
    context.pop();
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
