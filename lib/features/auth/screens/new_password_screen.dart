import 'package:drivingbehavior/core/constants/app_colors.dart';
import 'package:drivingbehavior/features/auth/screens/password_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _isEightChars = false;
  bool _hasLetterAndNumber = false;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  void _validatePassword(String value) {
    setState(() {
      _isEightChars = value.length >= 8;
      _hasLetterAndNumber = value.contains(RegExp(r'[A-Za-z]')) &&
          value.contains(RegExp(r'[0-9]'));
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isFormValid = _isEightChars &&
        _hasLetterAndNumber &&
        (_passController.text == _confirmController.text);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text('New Password',
                style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text('Enter your new password',
                style: GoogleFonts.poppins(
                    color: AppColors.secondary, fontSize: 14)),
            const SizedBox(height: 50),

            _buildPasswordField(
              controller: _passController,
              hint: 'New Password',
              isObscure: _isObscureNew,
              onToggle: () {
                setState(() {
                  _isObscureNew = !_isObscureNew;
                });
              },
              onChanged: (val) => _validatePassword(val),
            ),

            const SizedBox(height: 20),

// Input Confirm New Password
            _buildPasswordField(
              controller: _confirmController,
              hint: 'Confirm New Password',
              isObscure: _isObscureConfirm, // Pakai variabel kedua
              onToggle: () {
                setState(() {
                  _isObscureConfirm =
                      !_isObscureConfirm; 
                });
              },
              onChanged: (val) => setState(() {}),
            ),
            const SizedBox(height: 25),

            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your new password must contain:',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                  const SizedBox(height: 10),
                  _buildValidationItem('At least 8 characters', _isEightChars),
                  _buildValidationItem('Combination of letters and numbers',
                      _hasLetterAndNumber),
                ],
              ),
            ),

            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isFormValid
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PasswordSuccessScreen()));
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isFormValid ? AppColors.primary : const Color(0xFF6B6B6B),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: Text('Done',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isObscure,
    required VoidCallback onToggle,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bluelightL,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        onChanged: onChanged,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              GoogleFonts.poppins(color: AppColors.secondary, fontSize: 14),
          prefixIcon: const Icon(Icons.vpn_key_outlined,
              color: AppColors.primary, size: 22),
          suffixIcon: IconButton(
            icon: Icon(
              isObscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.primary,
              size: 20,
            ),
            onPressed: onToggle,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }

  Widget _buildValidationItem(String text, bool isValid) {
    return Row(
      children: [
        Icon(isValid ? Icons.check_circle : Icons.check_circle_outline,
            size: 16, color: isValid ? AppColors.primary : AppColors.secondary),
        const SizedBox(width: 8),
        Text(text,
            style: GoogleFonts.poppins(
                fontSize: 12,
                color: isValid ? AppColors.primary : AppColors.secondary)),
      ],
    );
  }
}
