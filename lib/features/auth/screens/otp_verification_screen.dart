import 'dart:async';

import 'package:drivingbehavior/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _secondsRemaining = 23;
  late Timer _timer;
  bool _isButtonActive = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  void _checkValidation() {
    // Tombol aktif jika ke-4 kotak sudah diisi
    setState(() {
      _isButtonActive =
          _controllers.every((controller) => controller.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              'OTP Verification',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontSize: 35,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.poppins(
                  color: AppColors.bluelight,
                  fontSize: 16,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: "We've sent OTP to\n"),
                  TextSpan(
                    text: "dri*********ior@gmail.com",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: AppColors.bluelight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _buildOTPBox(index)),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '00:${_secondsRemaining.toString().padLeft(2, '0')} ',
                  style: GoogleFonts.poppins(
                    color: AppColors.bluelight,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: _secondsRemaining == 0
                      ? () {
                          setState(() => _secondsRemaining = 59);
                          _startTimer();
                        }
                      : null,
                  child: Text(
                    'Resent OTP',
                    style: GoogleFonts.poppins(
                      color: _secondsRemaining == 0
                          ? AppColors.primary
                          : AppColors.bluelight,
                      fontWeight: _secondsRemaining == 0
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            // Tombol Verification
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isButtonActive
                    ? () {
                        // Tambahkan logika verifikasi di sini
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonActive
                      ? AppColors.primary
                      : AppColors.bluelightL,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.bluelightL,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Verification',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPBox(int index) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _focusNodes[index].hasFocus
              ? AppColors.primary
              : AppColors.bluelight,
          width: 1,
        ),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.bluelight,
            ),
            counterText: "",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            _checkValidation();
            if (value.length == 1 && index < 3) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          },
        ),
      ),
    );
  }
}
