import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/router.dart';
import '../../models/user_profile.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth/budibuddy_button.dart';
import '../../widgets/auth/budibuddy_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _budgetController;
  late String _selectedFuelType;
  bool _isEditing = false;

  static const List<String> _fuelTypes = ['RON95', 'RON97', 'Diesel'];

  @override
  void initState() {
    super.initState();
    final currentUser = context.read<AuthProvider>().currentUser;
    _nameController = TextEditingController(text: currentUser?.name ?? '');
    _budgetController = TextEditingController(
      text: currentUser?.monthlyBudget.toStringAsFixed(0) ?? '',
    );
    _selectedFuelType = currentUser?.preferredFuelType ?? 'RON95';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _resetFields(UserProfile? currentUser) {
    _nameController.text = currentUser?.name ?? '';
    _budgetController.text =
        currentUser?.monthlyBudget.toStringAsFixed(0) ?? '';
    _selectedFuelType = currentUser?.preferredFuelType ?? 'RON95';
  }

  Future<void> _handleSave(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;
    await auth.updateProfile(
      _nameController.text,
      _selectedFuelType,
      double.parse(_budgetController.text),
    );
    if (mounted) setState(() => _isEditing = false);
  }

  void _confirmSignOut(BuildContext context, AuthProvider auth) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sign Out?'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kError,
                foregroundColor: kWhite,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                auth.logout();
                context.go(RoutePaths.login);
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  Widget _profileRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: kTextMuted),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 11, color: kTextMuted),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kTextPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kPrimaryGreen),
          onPressed: () => context.go(RoutePaths.home),
        ),
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kPrimaryGreen,
          ),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: kPrimaryGreen),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: kSpaceLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  final currentUser = auth.currentUser;
                  return Column(
                    children: [
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 88,
                              height: 88,
                              decoration: const BoxDecoration(
                                color: kPrimaryGreen,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  currentUser?.avatarInitials ?? 'BB',
                                  style: GoogleFonts.poppins(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    color: kWhite,
                                  ),
                                ),
                              ),
                            ),
                            if (_isEditing)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: const BoxDecoration(
                                    color: kPrimaryAmber,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 14,
                                    color: kPrimaryGreen,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentUser?.name ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentUser?.email ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: kTextSecondary,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              Container(
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(kRadiusLG),
                  border: Border.all(color: kSurfaceGreen),
                ),
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      final currentUser = auth.currentUser;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_isEditing) ...[
                            BudiBuddyTextField(
                              controller: _nameController,
                              label: 'Full Name',
                              prefixIcon: const Icon(
                                Icons.person_outlined,
                                color: kTextMuted,
                                size: 20,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                          ],
                          _profileRow(
                            Icons.email_outlined,
                            'Email',
                            currentUser?.email ?? '-',
                          ),
                          const SizedBox(height: 16),
                          if (_isEditing) ...[
                            Text(
                              'Preferred Fuel Type',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: kTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
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
                                  fontSize: 14,
                                  color: kPrimaryGreen,
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: kPrimaryGreen,
                                ),
                                items: _fuelTypes
                                    .map(
                                      (fuel) => DropdownMenuItem(
                                        value: fuel,
                                        child: Text(fuel),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _selectedFuelType = value);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 14),
                          ] else ...[
                            _profileRow(
                              Icons.local_gas_station_outlined,
                              'Preferred Fuel',
                              currentUser?.preferredFuelType ?? '-',
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (_isEditing)
                            BudiBuddyTextField(
                              controller: _budgetController,
                              label: 'Monthly Budget (RM)',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your budget';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            )
                          else
                            _profileRow(
                              Icons.account_balance_wallet_outlined,
                              'Monthly Budget',
                              'RM ${currentUser?.monthlyBudget.toStringAsFixed(0) ?? '-'}',
                            ),
                          if (_isEditing) ...[
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: BudiBuddyButton(
                                    label: 'Cancel',
                                    variant: BudiBuddyButtonVariant.secondary,
                                    onPressed: () {
                                      setState(() {
                                        _resetFields(currentUser);
                                        _isEditing = false;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: BudiBuddyButton(
                                    label: 'Save',
                                    isLoading: auth.isLoading,
                                    onPressed: () => _handleSave(auth),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(kRadiusLG),
                  border: Border.all(color: kSurfaceGreen),
                ),
                child: Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return ListTile(
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: kErrorSurface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.logout,
                          color: kError,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        'Sign Out',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: kError,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: kError,
                        size: 14,
                      ),
                      onTap: () => _confirmSignOut(context, auth),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
