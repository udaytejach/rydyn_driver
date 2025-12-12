import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:rydyn/Driver/BottomnavigationBar/D_bottomnavigationbar.dart';
import 'package:rydyn/Driver/BottomnavigationBar/new_driver_dashbaord.dart';
import 'package:rydyn/Driver/Login/selectLanguage.dart';
import 'package:rydyn/Driver/SharedPreferences/shared_preferences.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customButton.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';
import 'package:rydyn/Driver/notifications/service.dart';
import 'package:rydyn/Driver/viewmodels/login_viewmodel.dart';

class OtpLogin extends StatefulWidget {
  final String phoneNumber;

  const OtpLogin({super.key, required this.phoneNumber});

  @override
  State<OtpLogin> createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLogin> {
  final TextEditingController otpController = TextEditingController();
  bool _isLoading = false;
  final FCMService fcmService = FCMService();

  Future<void> fetchServiceKeys() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection("serviceKeys")
          .doc('p5xZLhdsUezpgluOIzSY')
          .get();

      if (!snap.exists) {
        print("Service keys document not found");
        return;
      }

      final data = snap.data()!;

      await SharedPrefServices.setAuthProvider(data["authProvider"] ?? "");
      await SharedPrefServices.setAuthUri(data["authUri"] ?? "");
      await SharedPrefServices.setClientEmail(data["clientEmail"] ?? "");
      await SharedPrefServices.setClientId(data["clientId"] ?? "");
      await SharedPrefServices.setClientUrl(data["clientUrl"] ?? "");
      await SharedPrefServices.setPrimaryKey(data["primaryKey"] ?? "");
      await SharedPrefServices.setPrivateKey(data["privateKey"] ?? "");
      await SharedPrefServices.setTokenUri(data["tokenUri"] ?? "");
      await SharedPrefServices.setUniverseDomain(data["universeDomain"] ?? "");

      print("Service keys saved to SharedPreferences!");

      print("authProvider      : ${SharedPrefServices.getAuthProvider()}");
      print("authUri           : ${SharedPrefServices.getAuthUri()}");
      print("clientEmail       : ${SharedPrefServices.getClientEmail()}");
      print("clientId          : ${SharedPrefServices.getClientId()}");
      print("clientUrl         : ${SharedPrefServices.getClientUrl()}");
      print("primaryKey        : ${SharedPrefServices.getPrimaryKey()}");
      print("privateKey        : ${SharedPrefServices.getPrivateKey()}");
      print("tokenUri          : ${SharedPrefServices.getTokenUri()}");
      print("universeDomain    : ${SharedPrefServices.getUniverseDomain()}");
    } catch (e) {
      print("Error loading service keys: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Column(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Enter Your OTP",
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            textcolor: korangeColor,
                          ),
                          const SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: kgreyColor,
                              ),
                              children: [
                                const TextSpan(text: "OTP sent to "),
                                TextSpan(
                                  text: widget.phoneNumber,
                                  style: TextStyle(color: korangeColor),
                                ),
                                const TextSpan(
                                  text: " this OTP will get auto entering",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                          Pinput(
                            controller: otpController,
                            length: 4,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            defaultPinTheme: PinTheme(
                              width: 60,
                              height: 60,
                              textStyle: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: KblackColor,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: kbordergreyColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                            focusedPinTheme: PinTheme(
                              width: 60,
                              height: 60,
                              textStyle: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: korangeColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: kgreyColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "You didn’t receive OTP? ",
                                  ),
                                  TextSpan(
                                    text: "Resend OTP",
                                    style: TextStyle(
                                      color: korangeColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    _isLoading
                        ? const CircularProgressIndicator(color: korangeColor)
                        : CustomButton(
                            text: 'Verify OTP',
                            onPressed: () async {
                              setState(() => _isLoading = true);

                              try {
                                final vm = context.read<LoginViewModel>();

                                await vm.fetchLoggedInUser(widget.phoneNumber);
                                await fetchServiceKeys();
                                final role =
                                    await SharedPrefServices.getRoleCode();

                                final status =
                                    await SharedPrefServices.getStatus();

                                if (!mounted) return;

                                // if (status == "Inactive") {
                                //   setState(() => _isLoading = false);
                                //   showDialog(
                                //     context: context,
                                //     builder: (context) {
                                //       return AlertDialog(
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.circular(
                                //             10,
                                //           ),
                                //         ),
                                //         content: Text(
                                //           "Your status is inactive. Please contact the admin to update your account status.",
                                //           style: GoogleFonts.poppins(
                                //             color: Colors.black,
                                //             fontSize: 14,
                                //             fontWeight: FontWeight.w500,
                                //           ),
                                //         ),
                                //         title: Center(
                                //           child: Text(
                                //             "Account Inactive",
                                //             style: GoogleFonts.poppins(
                                //               color: korangeColor,
                                //               fontSize: 15,
                                //               fontWeight: FontWeight.w600,
                                //             ),
                                //           ),
                                //         ),

                                //         actions: [
                                //           TextButton(
                                //             onPressed: () {
                                //               Navigator.pop(context);
                                //             },
                                //             child: Text(
                                //               'OK',
                                //               style: GoogleFonts.poppins(
                                //                 color: korangeColor,
                                //                 fontSize: 14,
                                //                 fontWeight: FontWeight.w600,
                                //               ),
                                //             ),
                                //           ),
                                //         ],
                                //       );
                                //     },
                                //   );

                                //   return;
                                // }
                                if (status == "Inactive" ||
                                    status == "Rejected") {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => NewDriverDashbaord(),
                                    ),
                                  );
                                  return;
                                }

                                if (role == "Driver") {
                                  final docId = SharedPrefServices.getDocId();

                                  if (docId != null && docId.isNotEmpty) {
                                    final snap = await FirebaseFirestore
                                        .instance
                                        .collection("drivers")
                                        .doc(docId)
                                        .get();

                                    if (snap.exists) {
                                      final driverToken =
                                          snap.data()?["fcmToken"] ?? "";

                                      if (driverToken.isNotEmpty) {
                                        await fcmService.sendNotification(
                                          recipientFCMToken: driverToken,
                                          title: "Welcome Back,Captain!",
                                          body:
                                              "You're now logged in and ready to go.",
                                        );
                                        print(
                                          "Login success notification sent!",
                                        );
                                      }
                                    }
                                  }
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => D_BottomNavigation(),
                                    ),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LanguageSelectionScreen(),
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
                            height: 53,
                          ),

                    const SizedBox(height: 32),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
