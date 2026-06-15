import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/router.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth/budibuddy_button.dart';
import '../../widgets/auth/budibuddy_text_field.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _budgetController = TextEditingController(text: '300');
  String _selectedFuelType = 'RON95';

  static const List<String> _fuelTypes = ['RON95', 'RON97', 'Diesel'];

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _handleGetStarted(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;
    await auth.completeProfileSetup(
      _selectedFuelType,
      double.parse(_budgetController.text),
    );
    if (mounted) context.go(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kNeutralBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: kSpaceLG),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    final currentUser = auth.currentUser;
                    return Column(
                      children: [
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: kPrimaryGreen,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                currentUser?.avatarInitials ?? 'BB',
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: kWhite,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Hi, ${currentUser?.name ?? 'there'}!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryGreen,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Let's set up your profile.",
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
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(kRadiusLG),
                    border: Border.all(color: kSurfaceGreen),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                      const SizedBox(height: 20),
                      Text(
                        'Monthly Budget (RM)',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: kTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BudiBuddyTextField(
                        controller: _budgetController,
                        label: 'e.g. 300',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 4),
                          child: Text(
                            'RM',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: kTextSecondary,
                            ),
                          ),
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return BudiBuddyButton(
                      label: 'Get Started',
                      icon: Icons.arrow_forward,
                      isLoading: auth.isLoading,
                      onPressed: () => _handleGetStarted(auth),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'You can change these settings later.',
                    style: GoogleFonts.poppins(fontSize: 12, color: kTextMuted),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
