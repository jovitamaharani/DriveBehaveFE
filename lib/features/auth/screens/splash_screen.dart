import 'package:drivingbehavior/core/constants/app_colors.dart';
import 'package:drivingbehavior/features/auth/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 65.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 6),
              Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'logo',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 4),
              Text(
                'Ready to Go?',
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              // const Text(
              //   'Ready to Go?',
              //   style: TextStyle(
              //     color: AppColors.primary,
              //     fontSize: 26,
              //     fontWeight: FontWeight.w900,
              //   ),
              // ),
              const SizedBox(height: 3),
              Text(
                'Track your trips and\ndriving insights safely with us.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    color: AppColors.secondary,
                    fontSize: 16,
                    height: 1.3,
                    fontWeight: FontWeight.w500),
              ),
              // const Spacer(flex: 1),
              const SizedBox(height: 45),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Start Now',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
