import 'package:drivingbehavior/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isObscured = true;
  bool _isConfirmObscured = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _usernameController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _emailController.text.isNotEmpty &&
          _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    // Judul diubah jadi Sign Up
                    Center(
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.poppins(
                          color: AppColors.primary,
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        'Let\'s start your journey with us',
                        style: GoogleFonts.poppins(
                          color: AppColors.secondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 45),

                    _buildInputField(
                      controller: _emailController,
                      hint: 'Email',
                      icon: Icons.mail_outline,
                    ),

                    const SizedBox(height: 18),

                    _buildInputField(
                      controller: _usernameController,
                      hint: 'Username',
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 18),

                    _buildInputField(
                      controller: _passwordController,
                      hint: 'Password',
                      icon: Icons.key_outlined,
                      isPassword: true,
                      isObscured: _isObscured,
                      onToggle: () =>
                          setState(() => _isObscured = !_isObscured),
                    ),

                    const SizedBox(height: 18),

                    _buildInputField(
                      controller: _confirmPasswordController,
                      hint: 'Confirm Password',
                      icon: Icons.key_outlined,
                      isPassword: true,
                      isObscured: _isConfirmObscured,
                      onToggle: () => setState(
                          () => _isConfirmObscured = !_isConfirmObscured),
                    ),

                    const SizedBox(height: 50),

                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isFormValid ? () {} : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormValid
                              ? AppColors.primary
                              : const Color.fromARGB(255, 255, 255, 255),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                          disabledBackgroundColor: const Color(0xFF6B6B6B),
                          disabledForegroundColor: Colors.white,
                        ),
                        child: Text(
                          'Create Account',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: GoogleFonts.poppins(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Kembali ke Sign In
                          },
                          child: Text(
                            'Sign in here',
                            style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isObscured = false,
    VoidCallback? onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bluelightL,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: TextField(
          controller: controller,
          obscureText: isPassword ? isObscured : false,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            prefixIconConstraints: const BoxConstraints(minWidth: 40),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    onPressed: onToggle,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
          ),
        ),
      ),
    );
  }
}
