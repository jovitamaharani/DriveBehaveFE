import 'package:drivingbehavior/features/auth/screens/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const SensorDemoApp());
}

class SensorDemoApp extends StatelessWidget {
  const SensorDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),

      // home: const SplashScreen(),
      home: const OTPVerificationScreen(),
    );
  }
}
