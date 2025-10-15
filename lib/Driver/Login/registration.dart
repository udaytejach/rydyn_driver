import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:country_picker/country_picker.dart';

import 'package:provider/provider.dart';
import 'package:libphonenumber_plugin/libphonenumber_plugin.dart';
import 'package:rydyn/Driver/DriverLogin/driverRegistrationpage.dart';
import 'package:rydyn/Driver/Login/loginScreen.dart';
import 'package:rydyn/Driver/Login/otpscreen.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customButton.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';
import 'package:rydyn/Driver/Widgets/customTextField.dart';
import 'package:rydyn/Driver/Widgets/mobileNumberInputField.dart';
import 'package:rydyn/Driver/viewmodels/register_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "India",
    e164Key: "",
  );

  bool isValidName(String name) {
    final n = name.trim();
    return n.isNotEmpty;
  }

  bool isValidEmail(String email) {
    final pattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return pattern.hasMatch(email.trim());
  }

  Future<bool> isValidPhone(String phone, String countryCode) async {
    try {
      final bool? isValid = await PhoneNumberUtil.isValidPhoneNumber(
        phone,
        countryCode,
      );
      print("Phone validation result for $phone [$countryCode] → $isValid");
      return isValid ?? false;
    } catch (e) {
      print("Phone validation error: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final vm = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: "It only takes a minute to get started.",
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  textcolor: korangeColor,
                ),
                const SizedBox(height: 10),
                CustomText(
                  text: "Quick. Simple. Hassle-free registration.",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textcolor: kgreyColor,
                ),
                const SizedBox(height: 50),

                CustomTextField(
                  controller: firstnameController,
                  labelText: 'First Name',
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  controller: lastnameController,
                  labelText: 'Last Name',
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: emailController,
                  labelText: 'Email ID',
                ),
                const SizedBox(height: 20),

                PhoneNumberInputField(
                  controller: phoneController,
                  selectedCountry: selectedCountry,
                  onCountryChanged: (Country country) {
                    setState(() {
                      selectedCountry = country;
                    });
                  },
                ),
                const SizedBox(height: 40),

                vm.isLoading
                    ? const CircularProgressIndicator(color: korangeColor)
                    : CustomButton(
                        text: 'Register as Owner',
                        onPressed: () async {
                          final firstName = firstnameController.text.trim();
                          final lastName = lastnameController.text.trim();
                          final email = emailController.text.trim();
                          final phone = phoneController.text.trim();

                          print("Entered first name: $firstName");
                          print("Entered last name: $lastName");
                          print("Entered email: $email");
                          print("Entered phone: $phone");
                          print(
                            "Selected country: ${selectedCountry.name} (${selectedCountry.countryCode}) +${selectedCountry.phoneCode}",
                          );

                          // ✅ First name validation
                          if (!isValidName(firstName)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Please enter a valid first name",
                                ),
                              ),
                            );
                            return;
                          }

                          if (!isValidName(lastName)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please enter a valid last name"),
                              ),
                            );
                            return;
                          }

                          if (!isValidEmail(email)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Please enter a valid email address",
                                ),
                              ),
                            );
                            return;
                          }

                          final isValid = await isValidPhone(
                            phone,
                            selectedCountry.countryCode,
                          );
                          print("Phone validation result: $isValid");

                          if (!isValid) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Please enter a valid phone number for ${selectedCountry.name}",
                                ),
                              ),
                            );
                            return;
                          }

                          print(
                            "✅ All validations passed, proceeding with registration...",
                          );

                          try {
                            final ownerSnap = await FirebaseFirestore.instance
                                .collection('users')
                                .where('phone', isEqualTo: phone)
                                .limit(1)
                                .get();

                            if (ownerSnap.docs.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Mobile number already exists as Owner",
                                  ),
                                ),
                              );
                              return;
                            }

                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OtpScreen(
                                    phoneNumber: phoneController.text.trim(),
                                    firstName: firstName,
                                    lastName: lastName,
                                    email: email,
                                    countryCode: selectedCountry.countryCode,
                                    isTestOtp: true,
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $e")),
                            );
                          } finally {}
                        },

                        width: 220,
                        height: 53,
                      ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "You have an account? ",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textcolor: kgreyColor,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: CustomText(
                        text: "Sign In",
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        textcolor: korangeColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                CustomButton(
                  text: 'Register as Driver',
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DriverRegistrationPage(),
                      ),
                    );
                  },
                  width: 220,
                  height: 53,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
