import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rydyn/Driver/D_Models/Driver_ViewModel.dart';
import 'package:rydyn/Driver/DriverLogin/registrationotpscreen.dart';
import 'package:rydyn/Driver/Widgets/D_customTextfield.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';
import 'package:rydyn/Driver/Widgets/customTextField.dart';
import 'package:rydyn/Driver/Widgets/mobileNumberInputField.dart';
import 'package:rydyn/l10n/app_localizations.dart';

class DriverRegistrationPage extends StatefulWidget {
  const DriverRegistrationPage({super.key});

  @override
  State<DriverRegistrationPage> createState() => _DriverRegistrationPageState();
}

class _DriverRegistrationPageState extends State<DriverRegistrationPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final licenceController = TextEditingController();

  final holderController = TextEditingController();
  final accountController = TextEditingController();
  final ifscController = TextEditingController();
  final bankController = TextEditingController();
  final branchController = TextEditingController();

  String? vehicleType;
  // File? profileImage;

  bool isAgreed = false;

  File? image;
  void _pickImage() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Center(
          child: CustomText(
            text: "Select Image From",
            fontSize: 15,
            fontWeight: FontWeight.w500,
            textcolor: KblackColor,
          ),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  final pickedImage = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (pickedImage != null) {
                    setState(() {
                      image = File(pickedImage.path);
                    });
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.camera, size: 18, color: korangeColor),
                    const SizedBox(width: 8),
                    CustomText(
                      text: "Camera",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textcolor: Colors.black,
                    ),
                  ],
                ),
              ),

              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  final pickedImage = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (pickedImage != null) {
                    setState(() {
                      image = File(pickedImage.path);
                    });
                  }
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.photo_library,
                      size: 18,
                      color: korangeColor,
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      text: "Gallery",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textcolor: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  File? licenceFront;
  File? licenceBack;

  File? aadharFront;
  File? aadharBack;

  Future<void> _pickLicenceImage({required bool isFront}) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Center(
          child: Text(
            "Select Image From",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    setState(() {
                      if (isFront) {
                        licenceFront = File(picked.path);
                      } else {
                        licenceBack = File(picked.path);
                      }
                    });
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.camera_alt, color: korangeColor, size: 20),
                    SizedBox(width: 8),
                    Text("Camera"),
                  ],
                ),
              ),

              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    setState(() {
                      if (isFront) {
                        licenceFront = File(picked.path);
                      } else {
                        licenceBack = File(picked.path);
                      }
                    });
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.photo_library, color: korangeColor, size: 20),
                    SizedBox(width: 8),
                    Text("Gallery"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickedAadhar({required bool isFront}) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Center(
          child: Text(
            "Select Image From",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    setState(() {
                      if (isFront) {
                        aadharFront = File(picked.path);
                      } else {
                        aadharBack = File(picked.path);
                      }
                    });
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.camera_alt, color: korangeColor, size: 20),
                    SizedBox(width: 8),
                    Text("Camera"),
                  ],
                ),
              ),

              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (picked != null) {
                    setState(() {
                      if (isFront) {
                        aadharFront = File(picked.path);
                      } else {
                        aadharBack = File(picked.path);
                      }
                    });
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.photo_library, color: korangeColor, size: 20),
                    SizedBox(width: 8),
                    Text("Gallery"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool isValidIfsc(String code) {
    return RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(code);
  }

  bool isLoading = false;
  Future<void> fetchIfscDetails(String ifscCode) async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('https://ifsc.razorpay.com/$ifscCode'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print('Bank Name: ${data['BANK']}');
        print(' Branch Name: ${data['BRANCH']}');

        setState(() {
          bankController.text = data['BANK'] ?? '';
          branchController.text = data['BRANCH'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid IFSC Code. Please check and try again.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(' Error fetching IFSC details: $e'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    }
  }

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

  String? validateDLNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter Driving Licence Number";
    }

    final dlRegex = RegExp(r'^[A-Z]{2}[0-9]{2}[0-9]{4}[0-9]{7}$');

    if (!dlRegex.hasMatch(value)) {
      return "Invalid Driving Licence Format (e.g., TS0920201234567)";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 5),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(
                      "images/chevronLeft.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
              Center(
                child: CustomText(
                  text: localizations.basicInformation,
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: image != null
                              ? FileImage(image!)
                              : null,
                          child: image == null
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                )
                              : null,
                        ),

                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: () {
                              _pickImage();
                            },
                            child: const CircleAvatar(
                              backgroundColor: korangeColor,
                              radius: 18,
                              child: Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  D_CustomTextField(
                    labelText: localizations.firstName,
                    controller: firstNameController,
                  ),
                  const SizedBox(height: 10),
                  D_CustomTextField(
                    labelText: localizations.lastName,
                    controller: lastNameController,
                  ),
                  const SizedBox(height: 10),
                  D_CustomTextField(
                    labelText: localizations.email,
                    controller: emailController,
                  ),
                  const SizedBox(height: 10),
                  PhoneNumberInputField(
                    controller: phoneController,
                    selectedCountry: selectedCountry,
                    onCountryChanged: (Country country) {
                      setState(() {
                        selectedCountry = country;
                      });
                    },
                  ),
                  const SizedBox(height: 15),

                  TextField(
                    controller: dobController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: localizations.dateOfBirth,
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFD5D7DA)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFFD5D7DA),
                          width: 1,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.calendar_month,
                          size: 20,
                          color: Colors.grey,
                        ),
                        onPressed: () async {
                          final DateTime today = DateTime.now();
                          final DateTime maxAdultDate = DateTime(
                            today.year - 18,
                            today.month,
                            today.day,
                          );

                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: maxAdultDate,
                            firstDate: DateTime(1900),
                            lastDate: maxAdultDate,
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: korangeColor,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: korangeColor,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (picked != null) {
                            dobController.text = DateFormat(
                              "dd-MM-yyyy",
                            ).format(picked);
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  Text(
                    localizations.preferences,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: korangeColor,
                    ),
                  ),

                  const SizedBox(height: 10),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      value: vehicleType,

                      hint: Text(
                        localizations.chooseVehicleType,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: localizations.light,
                          child: Text(localizations.light),
                        ),
                        DropdownMenuItem(
                          value: localizations.lightPremium,
                          child: Text(localizations.lightPremium),
                        ),
                        DropdownMenuItem(
                          value: localizations.lightPremiumHeavy,
                          child: Text(localizations.lightPremiumHeavy),
                        ),
                        // DropdownMenuItem(value: 'All', child: Text('All')),
                      ],
                      onChanged: (value) => setState(() => vehicleType = value),
                      dropdownStyleData: DropdownStyleData(
                        direction: DropdownDirection.textDirection,
                        offset: const Offset(0, -5),
                        maxHeight: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                      ),

                      buttonStyleData: ButtonStyleData(
                        height: 58,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Color(0xFFD5D7DA)),
                        ),
                      ),

                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  D_CustomTextField(
                    labelText: localizations.drivingLicenceNumber,
                    controller: licenceController,
                    inputFormatters: [UpperCaseTextFormatter()],
                    validator: validateDLNumber,
                  ),

                  const SizedBox(height: 20),
                  Text(
                    localizations.uploadDocuments,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: korangeColor,
                    ),
                  ),

                  const SizedBox(height: 15),
                  Card(
                    color: kwhiteColor,

                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              localizations.uploadDriverLicence,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: korangeColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async =>
                                      await _pickLicenceImage(isFront: true),

                                  child: DottedBorder(
                                    options:
                                        const RoundedRectDottedBorderOptions(
                                          dashPattern: [6, 3],
                                          strokeWidth: 0.5,
                                          color: Colors.grey,
                                          padding: EdgeInsets.all(8),
                                          radius: Radius.circular(12),
                                        ),
                                    child: Container(
                                      height: 120,

                                      alignment: Alignment.center,
                                      child: licenceFront != null
                                          ? Image.file(
                                              licenceFront!,
                                              fit: BoxFit.cover,
                                            )
                                          : Text(localizations.uploadFront),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      _pickLicenceImage(isFront: false),
                                  child: DottedBorder(
                                    options:
                                        const RoundedRectDottedBorderOptions(
                                          dashPattern: [6, 3],
                                          strokeWidth: 0.5,
                                          color: Colors.grey,
                                          padding: EdgeInsets.all(8),
                                          radius: Radius.circular(12),
                                        ),
                                    child: Container(
                                      height: 120,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: licenceBack != null
                                          ? Image.file(
                                              licenceBack!,
                                              fit: BoxFit.cover,
                                            )
                                          : Text(localizations.uploadBack),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Card(
                    color: kwhiteColor,

                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              localizations.aadharCard,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: korangeColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async =>
                                      await _pickedAadhar(isFront: true),

                                  child: DottedBorder(
                                    options:
                                        const RoundedRectDottedBorderOptions(
                                          dashPattern: [6, 3],
                                          strokeWidth: 0.5,
                                          color: Colors.grey,
                                          padding: EdgeInsets.all(8),
                                          radius: Radius.circular(12),
                                        ),
                                    child: Container(
                                      height: 120,

                                      alignment: Alignment.center,
                                      child: aadharFront != null
                                          ? Image.file(
                                              aadharFront!,
                                              fit: BoxFit.cover,
                                            )
                                          : Text(localizations.uploadFront),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _pickedAadhar(isFront: false),
                                  child: DottedBorder(
                                    options:
                                        const RoundedRectDottedBorderOptions(
                                          dashPattern: [6, 3],
                                          strokeWidth: 0.5,
                                          color: Colors.grey,
                                          padding: EdgeInsets.all(8),
                                          radius: Radius.circular(12),
                                        ),
                                    child: Container(
                                      height: 120,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: aadharBack != null
                                          ? Image.file(
                                              aadharBack!,
                                              fit: BoxFit.cover,
                                            )
                                          : Text(localizations.uploadBack),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  Text(
                    localizations.bankDetails,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: korangeColor,
                    ),
                  ),

                  const SizedBox(height: 10),
                  D_CustomTextField(
                    controller: ifscController,
                    labelText: localizations.ifscCode,
                    inputFormatters: [UpperCaseTextFormatter()],
                    onChanged: (value) async {
                      final code = value.toUpperCase().trim();

                      if (code.isEmpty || code.length < 11) {
                        setState(() {
                          bankController.clear();
                          branchController.clear();
                        });
                        return;
                      }

                      if (code.length == 11) {
                        if (isValidIfsc(code)) {
                          await fetchIfscDetails(code);
                        } else {
                          setState(() {
                            bankController.clear();
                            branchController.clear();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(' Invalid IFSC Code Format.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }

                      if (code.length > 11) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'IFSC code cannot exceed 11 characters.',
                            ),
                            backgroundColor: Colors.orangeAccent,
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 10),
                  D_CustomTextField(
                    controller: bankController,
                    labelText: localizations.bankName,
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  D_CustomTextField(
                    controller: branchController,
                    labelText: localizations.branch,
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),

                  D_CustomTextField(
                    controller: accountController,
                    labelText: localizations.accountNumber,
                  ),
                  const SizedBox(height: 10),
                  D_CustomTextField(
                    controller: holderController,
                    labelText: localizations.accountHolderName,
                  ),

                  SizedBox(height: 20),

                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isAgreed,
                        checkColor: kwhiteColor,
                        fillColor: MaterialStateProperty.resolveWith<Color>((
                          states,
                        ) {
                          if (states.contains(MaterialState.selected)) {
                            return korangeColor;
                          }
                          return Colors.white;
                        }),
                        side: const BorderSide(color: korangeColor, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (value) {
                          setState(() => isAgreed = value ?? false);
                        },
                      ),

                      Expanded(
                        child: Text(
                          localizations.agreePrivacyPolicy,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_validateInputs()) return;
                        setState(() => isLoading = true);

                        String capitalize(String value) {
                          if (value.isEmpty) return value;
                          return value[0].toUpperCase() +
                              value.substring(1).toLowerCase();
                        }

                        final phone = phoneController.text.trim();

                        try {
                          final driverSnap = await FirebaseFirestore.instance
                              .collection('drivers')
                              .where('phone', isEqualTo: phone)
                              .limit(1)
                              .get();

                          if (driverSnap.docs.isNotEmpty) {
                            setState(() => isLoading = false);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: Center(
                                    child: Text(
                                      "Mobile Number Exists",
                                      style: GoogleFonts.poppins(
                                        color: korangeColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  content: Text(
                                    "This mobile number is already registered as a Driver.",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
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
                            return;
                          }

                          final ownerSnap = await FirebaseFirestore.instance
                              .collection('users')
                              .where('phone', isEqualTo: phone)
                              .limit(1)
                              .get();

                          if (ownerSnap.docs.isNotEmpty) {
                            setState(() => isLoading = false);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  title: Center(
                                    child: Text(
                                      "Mobile Number Exists",
                                      style: GoogleFonts.poppins(
                                        color: korangeColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  content: Text(
                                    "This mobile number is already registered as an Owner.",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
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
                            return;
                          }
                          if (!mounted) return;

                          final token = await FirebaseMessaging.instance
                              .getToken();
                          final String? fcmToken = token;

                          final String phoneNumberWithCode =
                              "+${selectedCountry.phoneCode}$phone";

                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: phoneNumberWithCode,
                            timeout: const Duration(seconds: 60),

                            verificationCompleted:
                                (PhoneAuthCredential credential) async {
                                  await FirebaseAuth.instance
                                      .signInWithCredential(credential);
                                },

                            verificationFailed: (FirebaseAuthException e) {
                              setState(() => isLoading = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.message ?? "OTP failed"),
                                ),
                              );
                            },

                            codeSent:
                                (String verificationId, int? resendToken) {
                                  if (!mounted) return;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DriverOtpScreen(
                                        verificationId: verificationId,
                                        fcmToken: fcmToken ?? "",
                                        firstName: capitalize(
                                          firstNameController.text,
                                        ),
                                        lastName: lastNameController.text,
                                        email: emailController.text,
                                        phoneNumber: phone,
                                        countryCode:
                                            selectedCountry.countryCode,
                                        dob: dobController.text,
                                        vehicleType: vehicleType ?? "",
                                        licenceNumber: licenceController.text,
                                        profileImage: image,
                                        licenceFront: licenceFront,
                                        licenceBack: licenceBack,
                                        aadharFront: aadharFront,
                                        aadharBack: aadharBack,
                                        holderName: holderController.text,
                                        accountNumber: accountController.text,
                                        ifsc: ifscController.text,
                                        bankName: bankController.text,
                                        branchName: branchController.text,
                                      ),
                                    ),
                                  );
                                },

                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
                        } catch (e) {
                          debugPrint("Error during registration: $e");
                          setState(() => isLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error during registration: $e"),
                            ),
                          );
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: korangeColor,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(
                        localizations.continueText,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
        ],
      ),
    );
  }

  bool isValidEmail(String email) {
    if (email.contains(' ')) return false;

    if (email != email.toLowerCase()) return false;

    final pattern = RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');

    return pattern.hasMatch(email);
  }

  bool _validateInputs() {
    if (firstNameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter first name.")));
      return false;
    }
    if (lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter last name.")));
      return false;
    }

    if (!isValidEmail(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email address")),
      );
      return false;
    }

    // if (emailController.text.isEmpty ||
    //     !RegExp(
    //       r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}',
    //     ).hasMatch(emailController.text)) {
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text("Please enter valid email")));
    //   return false;
    // }

    if (phoneController.text.isEmpty ||
        phoneController.text.length < 10 ||
        phoneController.text.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid phone number.")),
      );
      return false;
    }
    if (dobController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date of birth.")),
      );
      return false;
    }
    if (vehicleType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select vehicle type.")),
      );
      return false;
    }

    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload profile image.")),
      );
      return false;
    }

    if (licenceController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(' Please enter a valid Licence Number.')),
      );
      return false;
    }
    // final dlRegex = RegExp(r'^[A-Z]{2}[0-9]{2}[0-9]{4}[0-9]{7}$');
    final dlRegex = RegExp(r'^[A-Z]{2}[0-9]{2}[- ]?[0-9]{4}[- ]?[0-9]{7,10}$');

    if (!dlRegex.hasMatch(licenceController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid Driving Licence Format (e.g., TS0920201234567890)',
          ),
        ),
      );
      return false;
    }
    if (licenceFront == null || licenceBack == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload Licence Front & Back.')),
      );
      return false;
    }

    if (aadharFront == null || aadharBack == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload Aadhar Front & Back.')),
      );
      return false;
    }
    if (ifscController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter IFSC code.")));
      return false;
    }
    if (!RegExp(
      r'^[A-Z]{4}0[A-Z0-9]{6}$',
    ).hasMatch(ifscController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid IFSC Code format.')),
      );
      return false;
    }
    if (ifscController.text.isNotEmpty && accountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter Account Number.")),
      );
      return false;
    }
    if (!RegExp(r'^[0-9]{9,18}$').hasMatch(accountController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid Account Number (9–18 digits).'),
        ),
      );
      return false;
    }

    if (holderController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter the account holder's name."),
        ),
      );
      return false;
    }

    if (!isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please accept privacy policy.")),
      );
      return false;
    }
    return true;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
