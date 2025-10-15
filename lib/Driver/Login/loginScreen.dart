import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:rydyn/Driver/DriverLogin/driverRegistrationpage.dart';
import 'package:rydyn/Driver/Login/otp_login.dart';
import 'package:rydyn/Driver/l10n/app_localizations.dart';
import 'package:rydyn/Driver/services/repository.dart';
import 'package:rydyn/Driver/viewmodels/login_viewmodel.dart';

import 'otpscreen.dart';
import '../Widgets/colors.dart';
import '../Widgets/customButton.dart';
import '../Widgets/customText.dart';
import '../Widgets/mobileNumberInputField.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(RepositoryData()),
      child: _LoginScreenBody(),
    );
  }
}

class _LoginScreenBody extends StatefulWidget {
  @override
  State<_LoginScreenBody> createState() => _LoginScreenBodyState();
}

// class _LoginScreenBodyState extends State<_LoginScreenBody> {
//   final TextEditingController phoneController = TextEditingController(
//     text: "8555005960",
//   );
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     final localizations = AppLocalizations.of(context)!;

//     final vm = context.watch<LoginViewModel>();
//     final state = vm.state;

//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) async {
//         if (didPop) return;
//         bool exitApp = await _showExitDialog(context);
//         if (exitApp) {
//           Navigator.of(context).pop(true);
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: Stack(
//             children: [
//               Column(
//                 children: [
//                   const Spacer(),

//                   CustomText(
//                     text: "Mana Driver",
//                     fontSize: 32,
//                     fontWeight: FontWeight.w700,
//                     textcolor: korangeColor,
//                   ),
//                   const Spacer(),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomText(
//                           text: localizations.loginTitle,
//                           fontSize: 32,
//                           fontWeight: FontWeight.w700,
//                           textcolor: korangeColor,
//                         ),
//                         // const SizedBox(height: 10),
//                         // CustomText(
//                         //   text: localizations.loginSubtitle,
//                         //   fontSize: 14,
//                         //   fontWeight: FontWeight.w400,
//                         //   textcolor: kgreyColor,
//                         // ),
//                         const SizedBox(height: 50),
//                         PhoneNumberInputField(
//                           controller: phoneController,
//                           selectedCountry: vm.selectedCountry,
//                           onCountryChanged: (Country country) {
//                             vm.setCountry(country);
//                           },
//                         ),
//                         if (state.errorMessage.isNotEmpty)
//                           Padding(
//                             padding: const EdgeInsets.only(top: 8),
//                             child: Text(
//                               state.errorMessage,
//                               style: const TextStyle(color: Colors.red),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                   const Spacer(),
//                   CustomButton(
//                     text: _isLoading
//                         ? localizations.checking
//                         : localizations.sendOtp,
//                     onPressed: _isLoading
//                         ? null
//                         : () async {
//                             final phoneNumber = phoneController.text.trim();
//                             if (phoneNumber.isEmpty) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text("Please enter mobile number"),
//                                 ),
//                               );
//                               return;
//                             }

//                             setState(() => _isLoading = true);

//                             try {
//                               final exists = await _checkUserExists(
//                                 phoneNumber,
//                               );

//                               if (exists) {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) =>
//                                         OtpLogin(phoneNumber: phoneNumber),
//                                     // OtpScreen(
//                                     //   phoneNumber: phoneNumber,
//                                     //   firstName:
//                                     //       vm.loggedInUser?['firstName'] ??
//                                     //       '',
//                                     //   lastName:
//                                     //       vm.loggedInUser?['lastName'] ??
//                                     //       '',
//                                     //   email:
//                                     //       vm.loggedInUser?['email'] ?? '',
//                                     //   countryCode:
//                                     //       vm.loggedInUser?['countryCode'] ??
//                                     //       '',
//                                     //   isTestOtp: true,
//                                     // ),
//                                   ),
//                                 );
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                     content: Text(
//                                       "User not found. Please register first.",
//                                     ),
//                                   ),
//                                 );
//                               }
//                             } catch (e) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text("Error: $e")),
//                               );
//                             } finally {
//                               setState(() => _isLoading = false);
//                             }
//                           },
//                     width: 220,
//                     height: 50,
//                   ),

//                   const SizedBox(height: 10),

//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 32),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CustomText(
//                           text: localizations.noAccount,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           textcolor: kgreyColor,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => RegisterScreen(),
//                               ),
//                             );
//                           },
//                           child: CustomText(
//                             text: localizations.register,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             textcolor: korangeColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Text(
//                     'APK Release v1.0.3',
//                     style: GoogleFonts.poppins(
//                       color: kgreyColor,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//               if (_isLoading)
//                 Center(child: CircularProgressIndicator(color: korangeColor)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Future<bool> _checkUserExists(String phoneNumber) async {
//   //   final driverSnap = await FirebaseFirestore.instance
//   //       .collection('drivers')
//   //       .where('phone', isEqualTo: phoneNumber)
//   //       .limit(1)
//   //       .get();

//   //   if (driverSnap.docs.isNotEmpty) return true;

//   //   final ownerSnap = await FirebaseFirestore.instance
//   //       .collection('users')
//   //       .where('phone', isEqualTo: phoneNumber)
//   //       .limit(1)
//   //       .get();

//   //   return ownerSnap.docs.isNotEmpty;
//   // }
//   Future<bool> _checkUserExists(String phoneNumber) async {
//     final driverSnap = await FirebaseFirestore.instance
//         .collection('drivers')
//         .where('phone', isEqualTo: phoneNumber)
//         .limit(1)
//         .get();

//     return driverSnap.docs.isNotEmpty;
//   }

//   Future<bool> _showExitDialog(BuildContext context) async {
//     return (await showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             content: Text(
//               'Do you want to exit the app ?',
//               style: GoogleFonts.poppins(
//                 color: Colors.black,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: Text(
//                   'Cancel',
//                   style: GoogleFonts.poppins(
//                     color: korangeColor,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(true);
//                   exit(0);
//                 },
//                 child: Text(
//                   'Exit',
//                   style: GoogleFonts.poppins(
//                     color: korangeColor,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )) ??
//         false;
//   }
// }
class _LoginScreenBodyState extends State<_LoginScreenBody> {
  final TextEditingController phoneController = TextEditingController(
    text: "8555005960",
  );
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final vm = context.watch<LoginViewModel>();
    final state = vm.state;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        bool exitApp = await _showExitDialog(context);
        if (exitApp) {
          Navigator.of(context).pop(true);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const Spacer(),
                  // CustomText(
                  //   text: "rydyn",
                  //   fontSize: 32,
                  //   fontWeight: FontWeight.w700,
                  //   textcolor: korangeColor,
                  // ),
                  Image.asset(
                    'images/rydyn.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: localizations.loginTitle,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          textcolor: korangeColor,
                        ),
                        const SizedBox(height: 50),
                        PhoneNumberInputField(
                          controller: phoneController,
                          selectedCountry: vm.selectedCountry,
                          onCountryChanged: (Country country) {
                            vm.setCountry(country);
                          },
                        ),
                        if (state.errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              state.errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    text: _isLoading
                        ? localizations.checking
                        : localizations.sendOtp,
                    onPressed: _isLoading
                        ? null
                        : () async {
                            final phoneNumber = phoneController.text.trim();
                            if (phoneNumber.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter mobile number"),
                                ),
                              );
                              return;
                            }

                            setState(() => _isLoading = true);

                            try {
                              final exists = await _checkUserExists(
                                phoneNumber,
                              );

                              if (exists) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        OtpLogin(phoneNumber: phoneNumber),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Driver not found. Please contact admin.",
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          },
                    width: 220,
                    height: 50,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: localizations.noAccount,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textcolor: kgreyColor,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DriverRegistrationPage(),
                              ),
                            );
                          },
                          child: CustomText(
                            text: localizations.register,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            textcolor: korangeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'APK Release v1.0.4',
                    style: GoogleFonts.poppins(
                      color: kgreyColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (_isLoading)
                Center(child: CircularProgressIndicator(color: korangeColor)),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _checkUserExists(String phoneNumber) async {
    final driverSnap = await FirebaseFirestore.instance
        .collection('drivers')
        .where('phone', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    return driverSnap.docs.isNotEmpty;
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Text(
              'Do you want to exit the app ?',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                    color: korangeColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  exit(0);
                },
                child: Text(
                  'Exit',
                  style: GoogleFonts.poppins(
                    color: korangeColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
}
