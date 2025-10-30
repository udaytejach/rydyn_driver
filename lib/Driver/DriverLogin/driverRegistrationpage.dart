import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
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
              // 📸 Camera Option
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

              // 🖼️ Gallery Option
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

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DriverViewModel>(context);

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
                  text: "Basic Information",
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
                    labelText: "First Name",
                    controller: firstNameController,
                  ),
                  const SizedBox(height: 10),
                  D_CustomTextField(
                    labelText: "Last Name",
                    controller: lastNameController,
                  ),
                  const SizedBox(height: 10),
                  D_CustomTextField(
                    labelText: "Email",
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
                      labelText: "Date of Birth",
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today, size: 20),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
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
                  const Text(
                    "Preferences",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: korangeColor,
                    ),
                  ),

                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: vehicleType,
                    items: ["Light", "Medium", "Heavy"].map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => vehicleType = value),
                    decoration: InputDecoration(
                      labelText: "Vehicle Type",
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  D_CustomTextField(
                    labelText: "Driving Licence Number",
                    controller: licenceController,
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Upload Documents",
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
                              "Upload driver licence",
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
                                          : const Text("Upload Front"),
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
                                          : const Text("Upload Back"),
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
                  const Text(
                    "Bank Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: korangeColor,
                    ),
                  ),

                  const SizedBox(height: 10),
                  D_CustomTextField(
                    controller: ifscController,
                    labelText: "IFSC Code",

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
                    labelText: "Bank Name",
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  D_CustomTextField(
                    controller: branchController,
                    labelText: "Branch",
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),

                  D_CustomTextField(
                    controller: accountController,
                    labelText: "Account Number",
                  ),
                  const SizedBox(height: 10),
                  D_CustomTextField(
                    controller: holderController,
                    labelText: "Account Holder Name",
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
                          "I agree to the collection and use of my information as described in the Privacy Policy.",
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

                        final phone = phoneController.text.trim();

                        try {
                          final driverSnap = await FirebaseFirestore.instance
                              .collection('drivers')
                              .where('phone', isEqualTo: phone)
                              .limit(1)
                              .get();

                          if (driverSnap.docs.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Mobile number already exists as Driver",
                                ),
                              ),
                            );
                            return;
                          }

                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DriverOtpScreen(
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  email: emailController.text,
                                  phoneNumber: phone,
                                  countryCode: selectedCountry.countryCode,
                                  dob: dobController.text,
                                  vehicleType: vehicleType ?? "",
                                  licenceNumber: licenceController.text,
                                  profileImage: image,
                                  licenceFront: licenceFront,
                                  licenceBack: licenceBack,
                                  holderName: holderController.text,
                                  accountNumber: accountController.text,
                                  ifsc: ifscController.text,
                                  bankName: bankController.text,
                                  branchName: branchController.text,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Error: $e")));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: korangeColor,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          if (vm.isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
        ],
      ),
    );
  }

  bool _validateInputs() {
    if (firstNameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter first name")));
      return false;
    }
    if (lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter last name")));
      return false;
    }

    if (emailController.text.isEmpty ||
        !RegExp(
          r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}',
        ).hasMatch(emailController.text)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter valid email")));
      return false;
    }
    if (phoneController.text.isEmpty ||
        phoneController.text.length < 10 ||
        phoneController.text.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid phone number")),
      );
      return false;
    }
    if (dobController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date of birth")),
      );
      return false;
    }
    if (vehicleType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select vehicle type")),
      );
      return false;
    }

    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload profile image")),
      );
      return false;
    }
    if (!RegExp(r'^[0-9]{9,18}$').hasMatch(accountController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid Account Number (9–18 digits).'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }

    if (licenceController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(' Please enter a valid Licence Number.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }

    if (!RegExp(
      r'^[A-Z]{4}0[A-Z0-9]{6}$',
    ).hasMatch(ifscController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid IFSC Code format.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }
    if (holderController.text.isEmpty ||
        accountController.text.isEmpty ||
        ifscController.text.isEmpty ||
        bankController.text.isEmpty ||
        branchController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all bank details")),
      );
      return false;
    }
    if (!isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please accept privacy policy")),
      );
      return false;
    }
    return true;
  }
}
