import 'package:drivingbehavior/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  bool _isAgreed = false;

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'Terms & Conditions',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Understand your rights\nand responsibilities',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.secondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 4,
                  radius: const Radius.circular(10),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0), // Beri ruang untuk scrollbar
                      child: Text(
                        "Lorem ipsum dolor sit amet consectetur. Adipiscing mollis lacus lectus interdum. Massa purus in dolor senectus eu pellentesque suspendisse.\n\n"
                        "Volutpat urna amet semper eget adipiscing ut. Vitae iaculis vestibulum suspendisse interdum. Massa purus metus senectus velit feugiat sed. Tincidunt ac at diam sit non faucibus.\n\n"
                        "Gravida egestas consectetur at proin massa aliquam. Faucibus magna nisl nulla congue. Tincidunt id viverra sit commodo eu nisl vulputate.\n\n"
                        "Lorem ipsum dolor sit amet consectetur. Adipiscing mollis lacus lectus interdum. Massa purus in dolor senectus eu pellentesque suspendisse.\n\n"
                        "Volutpat urna amet semper eget adipiscing ut. Vitae iaculis vestibulum suspendisse interdum. Massa purus metus senectus velit feugiat sed. Tincidunt ac at diam sit non faucibus.\n\n"
                        "Gravida egestas consectetur at proin massa aliquam. Faucibus magna nisl nulla congue. Tincidunt id viverra sit commodo eu nisl vulputate.",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.primary.withOpacity(0.8),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: () {
                setState(() {
                  _isAgreed = !_isAgreed;
                });
              },
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: _isAgreed ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    child: _isAgreed
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'I agree to the Terms & Conditions',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _isAgreed ? AppColors.primary : AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isAgreed ? () {
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isAgreed ? AppColors.primary : const Color(0xFF6B6B6B),
                  disabledBackgroundColor: const Color(0xFF6B6B6B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Next',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}