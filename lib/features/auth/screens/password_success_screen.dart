import 'package:drivingbehavior/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordSuccessScreen extends StatelessWidget {
  const PasswordSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.bluelightL,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, size: 80, color: Colors.white), 
              ),
            ),
            const SizedBox(height: 40),
            Text('Password Changed', 
              style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 26, fontWeight: FontWeight.w900)),
            const SizedBox(height: 15),
            Text(
              "We've changed your password,\nclick below to login with your\nnew password",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: AppColors.secondary, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                   Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: Text('Sign In Now', 
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}