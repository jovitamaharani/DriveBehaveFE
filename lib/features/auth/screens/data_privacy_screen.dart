import 'package:drivingbehavior/core/constants/app_colors.dart';
import 'package:drivingbehavior/features/auth/screens/terms_conditions_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DataPrivacyScreen extends StatefulWidget {
  const DataPrivacyScreen({super.key});

  @override
  State<DataPrivacyScreen> createState() => _DataPrivacyScreenState();
}

class _DataPrivacyScreenState extends State<DataPrivacyScreen> {
  final List<Map<String, dynamic>> _privacyItems = [
    {'text': 'Lorem ipsum dolor sit amet consectetur.', 'isChecked': false},
    {'text': 'Lorem ipsum dolor sit amet consectetur.', 'isChecked': false},
    {'text': 'Lorem ipsum dolor sit amet consectetur.', 'isChecked': false},
    {'text': 'Lorem ipsum dolor sit amet consectetur.', 'isChecked': false},
    {'text': 'Lorem ipsum dolor sit amet consectetur.', 'isChecked': false},
  ];

  @override
  Widget build(BuildContext context) {
    bool isAnyChecked = _privacyItems.any((item) => item['isChecked'] == true);

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
            const SizedBox(height: 20),
            Text(
              'Data & Privacy',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You can choose which data\nyou want to share.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.secondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),

            Expanded(
              child: ListView.builder(
                itemCount: _privacyItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _privacyItems[index]['isChecked'] =
                              !_privacyItems[index]['isChecked'];
                        });
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: _privacyItems[index]['isChecked']
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: _privacyItems[index]['isChecked']
                                ? const Icon(Icons.check,
                                    size: 16, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              _privacyItems[index]['text'],
                              style: GoogleFonts.poppins(
                                color: AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.info_outline, size: 14, color: AppColors.secondary),
                const SizedBox(width: 5),
                Text(
                  'You can change this later on profile',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isAnyChecked
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TermsConditionsScreen()));
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAnyChecked
                      ? AppColors.primary
                      : const Color(0xFF6B6B6B),
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
