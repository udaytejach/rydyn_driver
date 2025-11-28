import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:rydyn/Driver/BottomnavigationBar/D_bottomnavigationbar.dart';
import 'package:rydyn/Driver/D_Models/Driver_Model.dart';
import 'package:rydyn/Driver/D_Models/Driver_ViewModel.dart';
import 'package:rydyn/Driver/Login/loginScreen.dart';
import 'package:rydyn/Driver/SharedPreferences/shared_preferences.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customButton.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';

class DriverOtpScreen extends StatefulWidget {
  final String firstName,
      lastName,
      email,
      phoneNumber,
      dob,
      vehicleType,
      licenceNumber;
  final String countryCode;
  final File? profileImage, licenceFront, licenceBack, aadharFront, aadharBack;
  final String holderName, accountNumber, ifsc, bankName, branchName;

  const DriverOtpScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    required this.vehicleType,
    required this.licenceNumber,
    this.profileImage,
    this.licenceFront,
    this.licenceBack,
    this.aadharFront,
    this.aadharBack,
    required this.holderName,
    required this.accountNumber,
    required this.ifsc,
    required this.bankName,
    required this.branchName,
    required this.countryCode,
  });

  @override
  State<DriverOtpScreen> createState() => _DriverOtpScreenState();
}

class _DriverOtpScreenState extends State<DriverOtpScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  Future<void> _verifyOtp() async {
    if (otpController.text.trim() != "1234") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
      return;
    }

    setState(() => isLoading = true);

    try {
      final vm = Provider.of<DriverViewModel>(context, listen: false);

      final now = DateTime.now();
      final formattedId = "Driver_${DateFormat('yyyyMMddHHmmss').format(now)}";
      vm.driver.userId = formattedId;
      vm.driver.isOnline = false;
      vm.driver.firstName = widget.firstName;
      vm.driver.lastName = widget.lastName;
      vm.driver.email = widget.email;
      vm.driver.countryCode = widget.countryCode;
      vm.driver.phone = widget.phoneNumber;
      vm.driver.dob = widget.dob;
      vm.driver.vehicleType = widget.vehicleType;
      vm.driver.licenceNumber = widget.licenceNumber;
      vm.driver.roleCode = "Driver";
      vm.driver.status = 'Inactive';

      if (widget.profileImage != null) {
        vm.driver.profileUrl = await vm.uploadImage(
          widget.profileImage!,
          "drivers/${vm.driver.phone}_profile.jpg",
        );
      }
      if (widget.licenceFront != null) {
        vm.driver.licenceFrontUrl = await vm.uploadImage(
          widget.licenceFront!,
          "drivers/${vm.driver.phone}_licence_front.jpg",
        );
      }
      if (widget.licenceBack != null) {
        vm.driver.licenceBackUrl = await vm.uploadImage(
          widget.licenceBack!,
          "drivers/${vm.driver.phone}_licence_back.jpg",
        );
      }

      if (widget.aadharFront != null) {
        vm.driver.aadharFrontUrl = await vm.uploadImage(
          widget.aadharFront!,
          "drivers/${vm.driver.phone}_licence_front.jpg",
        );
      }
      if (widget.aadharBack != null) {
        vm.driver.aadharBackUrl = await vm.uploadImage(
          widget.aadharBack!,
          "drivers/${vm.driver.phone}_licence_back.jpg",
        );
      }

      vm.driver.bankAccount = BankAccount(
        holderName: widget.holderName,
        accountNumber: widget.accountNumber,
        ifsc: widget.ifsc,
        bankName: widget.bankName,
        branch: widget.branchName,
      );

      final docRef = await vm.saveDriver();

      await SharedPrefServices.setRoleCode("Driver");
      await SharedPrefServices.setStatus("Inactive");
      await SharedPrefServices.setUserId(vm.driver.userId ?? "");
      await SharedPrefServices.setProfileImage(vm.driver.profileUrl ?? "");
      await SharedPrefServices.setFirstName(widget.firstName);
      await SharedPrefServices.setLastName(widget.lastName);
      await SharedPrefServices.setisOnline(false);
      await SharedPrefServices.setEmail(widget.email);
      await SharedPrefServices.setNumber(widget.phoneNumber);
      await SharedPrefServices.setCountryCode(
        widget.countryCode,
      ); // fixed India code
      await SharedPrefServices.setDOB(widget.dob);
      await SharedPrefServices.setvehicleType(widget.vehicleType);
      await SharedPrefServices.setdrivingLicence(widget.licenceNumber);
      await SharedPrefServices.setlicenceFront(vm.driver.licenceFrontUrl ?? "");
      await SharedPrefServices.setlicenceBack(vm.driver.licenceBackUrl ?? "");

      await SharedPrefServices.setbankNmae(widget.bankName);
      await SharedPrefServices.setaccountNumber(widget.accountNumber);
      await SharedPrefServices.setaccountHolderName(widget.holderName);
      await SharedPrefServices.setbranchName(widget.branchName);
      await SharedPrefServices.setifscCode(widget.ifsc);

      await SharedPrefServices.setislogged(true);

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: Text(
                "Please login to continue",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              title: Center(
                child: Text(
                  "Registration Successful",
                  style: GoogleFonts.poppins(
                    color: korangeColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                    );
                  },
                  child: Text(
                    'OK',
                    style: GoogleFonts.poppins(
                      color: korangeColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
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
                                color: korangeColor,
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
                    isLoading
                        ? const CircularProgressIndicator(color: korangeColor)
                        : CustomButton(
                            text: 'Verify OTP',
                            onPressed: _verifyOtp,
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
