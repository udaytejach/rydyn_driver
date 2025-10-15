import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:rydyn/Driver/Login/loginScreen.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';
import 'package:rydyn/Driver/l10n/app_localizations.dart';
import 'package:rydyn/Driver/services/locale_provider.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final marginStart = screenWidth * 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final localizations = AppLocalizations.of(context)!;
            return Column(
              children: [
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: marginStart),
                        child: CustomText(
                          text: localizations.selectLanguageTitle,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          textcolor: korangeColor,
                        ),
                      ),
                      // const SizedBox(height: 10),
                      // Container(
                      //   margin: EdgeInsets.only(left: marginStart),
                      //   child: CustomText(
                      //     text: localizations.selectLanguageSubtitle,
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w400,
                      //     textcolor: kgreyColor,
                      //   ),
                      // ),
                      const SizedBox(height: 50),
                      SizedBox(
                        height: 58,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: selectedLanguage,
                          onChanged: (newValue) {
                            if (newValue == null) return;
                            setState(() {
                              selectedLanguage = newValue;
                            });
                            final localeProvider = Provider.of<LocaleProvider>(
                              context,
                              listen: false,
                            );
                            if (newValue == 'English') {
                              localeProvider.setLocale(const Locale('en'));
                            } else if (newValue == 'Hindi') {
                              localeProvider.setLocale(const Locale('hi'));
                            } else if (newValue == 'Telugu') {
                              localeProvider.setLocale(const Locale('te'));
                            }
                          },
                          items: [
                            DropdownMenuItem(
                              value: 'English',
                              child: Text('English'),
                            ),
                            DropdownMenuItem(
                              value: 'Telugu',
                              child: Text('తెలుగు'),
                            ),
                            DropdownMenuItem(
                              value: 'Hindi',
                              child: Text('हिन्दी'),
                            ),
                          ],
                          decoration: InputDecoration(
                            hintText: localizations.chooseLanguage,
                            hintStyle: GoogleFonts.poppins(
                              color: kseegreyColor,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            fillColor: kwhiteColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFD5D7DA),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFFD5D7DA),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Center(
                    child: SizedBox(
                      width: 220,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: korangeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(70),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: localizations.continueButton,
                              fontSize: 16,
                              textcolor: kwhiteColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
