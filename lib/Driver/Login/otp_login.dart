import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
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
import 'package:rydyn/l10n/app_localizations.dart';
import 'package:rydyn/Driver/notifications/service.dart';
import 'package:rydyn/Driver/viewmodels/login_viewmodel.dart';

class OtpLogin extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpLogin({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<OtpLogin> createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLogin> {
  final TextEditingController otpController = TextEditingController();
  bool _isLoading = false;
  String? _currentVerificationId;
  bool _isResending = false;

  int _secondsLeft = 60;
  Timer? _timer;
  String? _otpErrorMessage;
  final FCMService fcmService = FCMService();

  Future<void> _resendOtp() async {
    if (_isResending) return;

    setState(() => _isResending = true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91${widget.phoneNumber}",
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {},

        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.message ?? "Resend failed")));
        },

        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _currentVerificationId = verificationId;
            _otpErrorMessage = null;
          });
          _startTimer();

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("OTP resent")));
        },

        codeAutoRetrievalTimeout: (_) {},
      );
    } finally {
      setState(() => _isResending = false);
    }
  }

  Future<void> fetchServiceKeys() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection("serviceKeys")
          .doc('dcpHt4KuF3dygNiwnCep')
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
      await SharedPrefServices.setRazorapiKey(data["razor_apiKey"] ?? "");
      await SharedPrefServices.setRazorsecretKey(data["razor_secretKey"] ?? "");

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
  void initState() {
    super.initState();
    print('OTP ${widget.verificationId}');
    _currentVerificationId = widget.verificationId;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 60);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
                            text: localizations.enterOtp,
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
                                TextSpan(
                                  text: widget.phoneNumber,
                                  style: TextStyle(color: korangeColor),
                                ),
                                TextSpan(text: localizations.otpSent),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                          Pinput(
                            controller: otpController,
                            length: 6,
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
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                            ),
                            focusedPinTheme: PinTheme(
                              margin: const EdgeInsets.symmetric(horizontal: 5),

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
                                  TextSpan(text: localizations.noOtp),
                                  TextSpan(
                                    text: _secondsLeft > 0
                                        ? "Resend OTP in 00:${_secondsLeft.toString().padLeft(2, '0')}"
                                        : "Resend OTP",
                                    style: TextStyle(
                                      color: _secondsLeft > 0
                                          ? kgreyColor
                                          : korangeColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: _secondsLeft > 0
                                        ? null
                                        : (TapGestureRecognizer()
                                            ..onTap = _resendOtp),
                                  ),

                                  // TextSpan(
                                  //   text: localizations.resendOtp,
                                  //   style: TextStyle(
                                  //     color: korangeColor,
                                  //     fontWeight: FontWeight.w600,
                                  //   ),
                                  // ),
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
                            text: localizations.verifyOtp,
                            onPressed: () async {
                              if (otpController.text.length != 6) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Enter valid OTP"),
                                  ),
                                );
                                return;
                              }

                              setState(() => _isLoading = true);

                              try {
                                final credential = PhoneAuthProvider.credential(
                                  // verificationId: widget.verificationId,
                                  verificationId: _currentVerificationId!,
                                  smsCode: otpController.text.trim(),
                                );

                                await FirebaseAuth.instance
                                    .signInWithCredential(credential);
                                final vm = context.read<LoginViewModel>();

                                await vm.fetchLoggedInUser(widget.phoneNumber);
                                await fetchServiceKeys();
                                final role =
                                    await SharedPrefServices.getRoleCode();

                                final status =
                                    await SharedPrefServices.getStatus();

                                if (!mounted) return;

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
                                          title: localizations.fcmotptitle,
                                          body: localizations.fcmotpbody,
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
                              } on FirebaseAuthException catch (e) {
                                String message =
                                    "OTP verification failed. Please try again.";

                                if (e.code == 'invalid-verification-code') {
                                  message = "Incorrect OTP. Please try again.";
                                } else if (e.code == 'session-expired') {
                                  message =
                                      "OTP expired. Please request a new one.";
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(message),
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 2),
                                  ),
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
