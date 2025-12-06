import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rydyn/Driver/BottomnavigationBar/D_bottomnavigationbar.dart';
import 'package:rydyn/Driver/BottomnavigationBar/new_driver_dashbaord.dart';
import 'package:rydyn/Driver/D_Models/Driver_ViewModel.dart';
import 'package:rydyn/Driver/SharedPreferences/shared_preferences.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';
import 'package:rydyn/Driver/Widgets/customTextField.dart';
import 'package:rydyn/Driver/l10n/app_localizations.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:http/http.dart' as http;

class DriversProfilescreen extends StatefulWidget {
  const DriversProfilescreen({super.key});

  @override
  State<DriversProfilescreen> createState() => _DriversProfilescreenState();
}

class _DriversProfilescreenState extends State<DriversProfilescreen> {
  bool isLoading = false;

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController licenceController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();

  final TextEditingController holderController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController branchController = TextEditingController();

  String? profileUrl;
  String? licenceFrontUrl;
  String? licenceBackUrl;
  String? aadharFront;
  String? aadharBack;
  File? image;
  bool isPrimary = false;
  bool isEditing = true;
  String currentStatus = "";

  @override
  void initState() {
    super.initState();
    _loadDriverDetails();
    currentStatus = SharedPrefServices.getStatus() ?? "";
  }

  bool isValidIfsc(String code) {
    return RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(code);
  }

  Future<void> _loadDriverDetails() async {
    firstnameController.text = await SharedPrefServices.getFirstName() ?? '';
    lastnameController.text = await SharedPrefServices.getLastName() ?? '';
    emailController.text = await SharedPrefServices.getEmail() ?? '';
    phoneController.text = await SharedPrefServices.getNumber() ?? '';
    dobController.text = await SharedPrefServices.getdob() ?? '';
    licenceController.text = await SharedPrefServices.getdrivingLicence() ?? '';
    vehicleController.text = await SharedPrefServices.getvehicletypee() ?? '';
    licenceFrontUrl = await SharedPrefServices.getlicenceFront() ?? '';
    licenceBackUrl = await SharedPrefServices.getlicenceBack() ?? '';
    aadharFront = await SharedPrefServices.getaadharFront() ?? '';
    aadharBack = await SharedPrefServices.getaadharBack() ?? '';
    holderController.text =
        await SharedPrefServices.getaccountHolderName() ?? '';
    accountController.text = await SharedPrefServices.getaccountNumber() ?? '';
    ifscController.text = await SharedPrefServices.getifscCode() ?? '';
    bankController.text = await SharedPrefServices.getbankNmae() ?? '';
    branchController.text = await SharedPrefServices.getbranchName() ?? '';
    profileUrl = await SharedPrefServices.getProfileImage() ?? '';

    setState(() {});
  }

  String _getUserInitials() {
    final first = firstnameController.text;
    final last = lastnameController.text;
    return '${first.isNotEmpty ? first[0].toUpperCase() : ''}${last.isNotEmpty ? last[0].toUpperCase() : ''}';
  }

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  Future<String?> _uploadProfileImage(File imageFile) async {
    try {
      final phoneNumber = await SharedPrefServices.getNumber();

      final oldProfileUrl = await SharedPrefServices.getProfileImage();

      if (phoneNumber == null || phoneNumber.isEmpty) {
        debugPrint("Phone number not found for upload.");
        return null;
      }

      final fileName = '${phoneNumber}_profile.jpg';
      final ref = FirebaseStorage.instance
          .ref()
          .child('drivers')
          .child(fileName);

      if (oldProfileUrl != null && oldProfileUrl.isNotEmpty) {
        try {
          final oldRef = FirebaseStorage.instance.refFromURL(oldProfileUrl);
          await oldRef.delete();
          debugPrint(" Old profile image deleted successfully");
        } catch (e) {
          debugPrint(" profile image delete failed: $e");
        }
      }

      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      debugPrint(" Profile Image URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      debugPrint("Image upload failed: $e");
      return null;
    }
  }

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

  Future<String?> _uploadLicenceImage({
    required File imageFile,
    required String type,
    required String? oldUrl,
  }) async {
    try {
      final phoneNumber = await SharedPrefServices.getNumber();

      if (phoneNumber == null || phoneNumber.isEmpty) {
        debugPrint("Phone number not found for licence upload.");
        return null;
      }

      final fileName = '${phoneNumber}_licence_$type.jpg';
      final ref = FirebaseStorage.instance
          .ref()
          .child('drivers')
          .child(fileName);

      if (oldUrl != null && oldUrl.isNotEmpty) {
        try {
          final oldRef = FirebaseStorage.instance.refFromURL(oldUrl);
          await oldRef.delete();
          debugPrint("Deleted old licence $type image successfully");
        } catch (e) {
          debugPrint("Failed to delete old licence $type: $e");
        }
      }

      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      debugPrint("Uploaded licence $type image: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      debugPrint("Licence image upload failed: $e");
      return null;
    }
  }

  Future<String?> _uploadAadhar({
    required File imageFile,
    required String type,
    required String? oldUrl,
  }) async {
    try {
      final phoneNumber = await SharedPrefServices.getNumber();

      if (phoneNumber == null || phoneNumber.isEmpty) {
        debugPrint("Phone number not found for aadhar upload.");
        return null;
      }

      final fileName = '${phoneNumber}_aadhar_$type.jpg';
      final ref = FirebaseStorage.instance
          .ref()
          .child('drivers')
          .child(fileName);

      if (oldUrl != null && oldUrl.isNotEmpty) {
        try {
          final oldRef = FirebaseStorage.instance.refFromURL(oldUrl);
          await oldRef.delete();
          debugPrint("Deleted old aadhar $type image successfully");
        } catch (e) {
          debugPrint("Failed to delete old aadhar $type: $e");
        }
      }

      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      debugPrint("Uploaded aadhar $type image: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      debugPrint("Aadhar image upload failed: $e");
      return null;
    }
  }

  Future<void> verifyBankAccount(
    BuildContext context,
    String ifsc,
    String accountNumber,
  ) async {
    const keyId = 'rzp_test_RZa3mGbco9w4Ms';
    const keySecret = 'p7BUzEwN0Jl73drzwuSqXsh7';

    final basicAuth = 'Basic ' + base64Encode(utf8.encode('$keyId:$keySecret'));

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.razorpay.com/v1/fund_accounts/validation'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': basicAuth,
        },
        body: json.encode({
          "account": {"account_number": accountNumber, "ifsc": ifsc},
        }),
      );

      print(" Razorpay Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final valid = data['valid'] ?? false;
        final accountName = data['account']?['name'] ?? '';

        if (valid) {
          setState(() {
            holderController.text = accountName;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Account Verified: $accountName'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          setState(() {
            holderController.clear();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid account number or IFSC.')),
          );
        }
      } else {
        print('Razorpay error: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Razorpay Error: ${response.body}'),
            backgroundColor: Colors.orangeAccent,
          ),
        );
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error verifying account: $e'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateDriverDetails() async {
    final firstName =
        firstnameController.text.trim()[0].toUpperCase() +
        firstnameController.text.trim().substring(1);
    final lastName = lastnameController.text.trim();
    final email = emailController.text.trim();
    final dob = dobController.text.trim();
    final vehicleType = vehicleController.text.trim();
    final licenceNumber = licenceController.text.trim();
    final ifsc = ifscController.text.trim().toUpperCase();
    final bank = bankController.text.trim();
    final branch = branchController.text.trim();
    final holder = holderController.text.trim();
    final account = accountController.text.trim();
    final currentStatus = SharedPrefServices.getStatus() ?? "";

    // if (firstName.isEmpty ||
    //     lastName.isEmpty ||
    //     email.isEmpty ||
    //     dob.isEmpty ||
    //     vehicleType.isEmpty ||
    //     licenceNumber.isEmpty ||
    //     ifsc.isEmpty ||
    //     bank.isEmpty ||
    //     branch.isEmpty ||
    //     holder.isEmpty ||
    //     account.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Please fill all required fields before updating.'),
    //     ),
    //   );
    //   return;
    // }
    if (firstName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter first name.")));
      return;
    }

    if (firstName.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("First name must have at least 2 letters."),
        ),
      );
      return;
    }

    if (lastName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter last name.")));
      return;
    }

    if (phoneController.text.isEmpty ||
        phoneController.text.length < 10 ||
        phoneController.text.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid phone number.")),
      );
      return;
    }
    if (dobController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date of birth.")),
      );
      return;
    }
    if (vehicleType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select vehicle type.")),
      );
      return;
    }

    if (image == null && (profileUrl == null || profileUrl!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload profile image.")),
      );
      return;
    }

    if (licenceFrontUrl == null ||
        licenceFrontUrl!.isEmpty ||
        licenceBackUrl == null ||
        licenceBackUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload Licence Front & Back.')),
      );
      return;
    }

    if (aadharFront == null ||
        aadharFront!.isEmpty ||
        aadharBack == null ||
        aadharBack!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload Aadhar Front & Back.')),
      );
      return;
    }

    if (licenceController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(' Please enter a valid Licence Number.')),
      );
      return;
    }
    final dlRegex = RegExp(r'^[A-Z]{2}[0-9]{2}[0-9]{4}[0-9]{7}$');

    if (!dlRegex.hasMatch(licenceController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid Driving Licence Format (e.g., TS0920201234567)',
          ),
        ),
      );
      return;
    }

    // if (firstName.length < 2 || holder.length < 2) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text(' Names must have at least 2 characters.'),
    //     ),
    //   );
    //   return;
    // }

    // if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text(' Please enter a valid email address.')),
    //   );
    //   return;
    // }

    if (licenceNumber.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(' Please enter a valid Licence Number.')),
      );
      return;
    }

    if (ifscController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter IFSC code.")));
      return;
    }
    if (!RegExp(
      r'^[A-Z]{4}0[A-Z0-9]{6}$',
    ).hasMatch(ifscController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid IFSC Code format.')),
      );
      return;
    }
    if (ifscController.text.isNotEmpty && accountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter Account Number.")),
      );
      return;
    }
    if (!RegExp(r'^[0-9]{9,18}$').hasMatch(accountController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid Account Number (9–18 digits).'),
        ),
      );
      return;
    }

    if (holderController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter the account holder's name."),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final driverId = await SharedPrefServices.getDocId();
      if (driverId == null) return;

      String? uploadedProfileUrl = profileUrl;
      if (image != null) {
        uploadedProfileUrl = await _uploadProfileImage(image!);
      }

      String? uploadedLicenceFrontUrl = licenceFrontUrl;
      if (licenceFrontUrl != null && !licenceFrontUrl!.startsWith('http')) {
        uploadedLicenceFrontUrl = await _uploadLicenceImage(
          imageFile: File(licenceFrontUrl!),
          type: 'front',
          oldUrl: licenceFrontUrl,
        );
      }

      String? uploadedLicenceBackUrl = licenceBackUrl;
      if (licenceBackUrl != null && !licenceBackUrl!.startsWith('http')) {
        uploadedLicenceBackUrl = await _uploadLicenceImage(
          imageFile: File(licenceBackUrl!),
          type: 'back',
          oldUrl: licenceBackUrl,
        );
      }

      String? uploadAadharFront = aadharFront;
      if (aadharFront != null && !aadharFront!.startsWith('http')) {
        uploadAadharFront = await _uploadAadhar(
          imageFile: File(aadharFront!),
          type: 'front',
          oldUrl: aadharFront,
        );
      }

      String? uploadAadharBack = aadharBack;
      if (aadharBack != null && !aadharBack!.startsWith('http')) {
        uploadAadharBack = await _uploadAadhar(
          imageFile: File(aadharBack!),
          type: 'back',
          oldUrl: aadharBack,
        );
      }

      await FirebaseFirestore.instance
          .collection('drivers')
          .doc(driverId)
          .update({
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'dob': dob,
            'vehicleType': vehicleType,
            'licenceNumber': licenceNumber,
            'licenceFrontUrl': uploadedLicenceFrontUrl,
            'licenceBackUrl': uploadedLicenceBackUrl,
            'profileUrl': uploadedProfileUrl,
            'aadharFrontUrl': uploadAadharFront,
            'aadharBackUrl': uploadAadharBack,
            'bankAccount': {
              'bankName': bank,
              'branch': branch,
              'holderName': holder,
              'accountNumber': account,
              'ifsc': ifsc,
            },
            if (currentStatus == "Rejected") 'status': "Inactive",
            'rejectReason': '',
          });

      await SharedPrefServices.setFirstName(firstName);
      await SharedPrefServices.setLastName(lastName);
      await SharedPrefServices.setEmail(email);
      await SharedPrefServices.setDOB(dob);
      await SharedPrefServices.setdrivingLicence(licenceNumber);
      await SharedPrefServices.setvehicleType(vehicleType);
      await SharedPrefServices.setbankNmae(bank);
      await SharedPrefServices.setaccountHolderName(holder);
      await SharedPrefServices.setifscCode(ifsc);
      await SharedPrefServices.setbranchName(branch);
      await SharedPrefServices.setaccountNumber(account);
      await SharedPrefServices.setlicenceFront(uploadedLicenceFrontUrl!);
      await SharedPrefServices.setlicenceBack(uploadedLicenceBackUrl!);
      await SharedPrefServices.setaadharFront(uploadAadharFront!);
      await SharedPrefServices.setaadharBack(uploadAadharBack!);
      if (currentStatus == "Rejected") {
        await SharedPrefServices.setStatus("Inactive");
      }

      if (uploadedProfileUrl != null) {
        await SharedPrefServices.setProfileImage(uploadedProfileUrl);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(" Profile updated successfully")),
      );

      await Future.delayed(const Duration(seconds: 1));
      if (currentStatus == "Rejected") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NewDriverDashbaord()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => D_BottomNavigation()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint("Error updating driver details: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(" Update failed: $e")));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

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
    final localizations = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          "images/chevronLeft.png",
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      localizations.profile,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.edit, color: korangeColor),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              bottom: const TabBar(
                labelColor: korangeColor,
                unselectedLabelColor: kseegreyColor,
                indicatorColor: korangeColor,
                tabs: [
                  Tab(text: "Basic Details"),
                  Tab(text: "Bank Details"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: KlightgreyColor,
                              backgroundImage: image != null
                                  ? FileImage(image!)
                                  : (profileUrl != null &&
                                        profileUrl!.isNotEmpty)
                                  ? NetworkImage(profileUrl!) as ImageProvider
                                  : null,
                              child:
                                  (image == null &&
                                      (profileUrl == null ||
                                          profileUrl!.isEmpty))
                                  ? Text(
                                      _getUserInitials(),
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFC7D5E7),
                                      ),
                                    )
                                  : null,
                            ),
                            if (isEditing)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: CircleAvatar(
                                    backgroundColor: korangeColor,
                                    radius: 18,
                                    child: Image.asset("images/camera.png"),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: firstnameController,
                        labelText: localizations.p_firstName,
                        readOnly: !isEditing,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: lastnameController,
                        labelText: localizations.p_lastName,
                        readOnly: !isEditing,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: emailController,
                        labelText: localizations.p_email,
                        readOnly: !isEditing,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: phoneController,
                        labelText: localizations.p_phoneNumner,
                        readOnly: true,
                      ),
                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: isEditing
                            ? () async {
                                DateTime initialDate = DateTime.now();
                                if (dobController.text.isNotEmpty) {
                                  try {
                                    final parts = dobController.text.split('-');
                                    if (parts.length == 3) {
                                      final day = int.parse(parts[0]);
                                      final month = int.parse(parts[1]);
                                      final year = int.parse(parts[2]);
                                      initialDate = DateTime(year, month, day);
                                    }
                                  } catch (e) {
                                    debugPrint("Invalid date format: $e");
                                  }
                                }
                                final currentDate = DateTime.now();
                                final lastAllowedDate = DateTime(
                                  currentDate.year - 18,
                                  currentDate.month,
                                  currentDate.day,
                                );

                                // Show date picker
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: initialDate,
                                  firstDate: DateTime(1950),
                                  lastDate: lastAllowedDate,
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: korangeColor,
                                          onPrimary: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedDate != null) {
                                  final formatted =
                                      "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                                  setState(() {
                                    dobController.text = formatted;
                                  });
                                }
                              }
                            : null,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: dobController,
                            labelText: "Date of Birth",
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          value:
                              [
                                'Light',
                                'Light-Premium',
                                'Light-Premium-Heavy',
                              ].contains(vehicleController.text)
                              ? vehicleController.text
                              : null,

                          hint: Text(
                            "Choose Vehicle Type",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'Light',
                              child: Text('Light'),
                            ),
                            DropdownMenuItem(
                              value: 'Light-Premium',
                              child: Text('Light-Premium'),
                            ),
                            DropdownMenuItem(
                              value: 'Light-Premium-Heavy',
                              child: Text('Light-Premium-Heavy'),
                            ),
                            // DropdownMenuItem(value: 'All', child: Text('All')),
                          ],
                          onChanged: isEditing
                              ? (value) {
                                  setState(() {
                                    vehicleController.text = value!;
                                  });
                                }
                              : null,

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

                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: licenceController,
                        labelText: "Licence Number",
                        readOnly: !isEditing,
                        inputFormatters: [UpperCaseTextFormatter()],
                        validator: validateDLNumber,
                      ),
                      const SizedBox(height: 10),
                      CustomText(
                        text: " Driving Licence (Front & Back)",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        textcolor: KblackColor,
                      ),
                      const SizedBox(height: 10),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    color: Colors.grey.shade100,
                                    image:
                                        (licenceFrontUrl != null &&
                                            licenceFrontUrl!.isNotEmpty)
                                        ? DecorationImage(
                                            image:
                                                licenceFrontUrl!.startsWith(
                                                  'http',
                                                )
                                                ? NetworkImage(licenceFrontUrl!)
                                                : FileImage(
                                                        File(licenceFrontUrl!),
                                                      )
                                                      as ImageProvider,
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child:
                                      (licenceFrontUrl == null ||
                                          licenceFrontUrl!.isEmpty)
                                      ? const Center(
                                          child: Text(
                                            "Front Side",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),

                                if (isEditing)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (currentStatus == "Rejected") {
                                          if (licenceFrontUrl != null &&
                                              licenceFrontUrl!.isNotEmpty) {
                                            setState(() {
                                              licenceFrontUrl = "";
                                            });
                                          } else {
                                            pickLicenceImage(isFront: true);
                                          }
                                        } else {
                                          pickLicenceImage(isFront: true);
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor:
                                            currentStatus == "Rejected"
                                            ? (licenceFrontUrl != null &&
                                                      licenceFrontUrl!
                                                          .isNotEmpty
                                                  ? Colors.red
                                                  : korangeColor)
                                            : korangeColor,

                                        child: Icon(
                                          currentStatus == "Rejected"
                                              ? (licenceFrontUrl != null &&
                                                        licenceFrontUrl!
                                                            .isNotEmpty
                                                    ? Icons.delete
                                                    : Icons.add)
                                              : Icons.edit,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 15),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    color: Colors.grey.shade100,
                                    image:
                                        (licenceBackUrl != null &&
                                            licenceBackUrl!.isNotEmpty)
                                        ? DecorationImage(
                                            image:
                                                licenceBackUrl!.startsWith(
                                                  'http',
                                                )
                                                ? NetworkImage(licenceBackUrl!)
                                                : FileImage(
                                                        File(licenceBackUrl!),
                                                      )
                                                      as ImageProvider,
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child:
                                      (licenceBackUrl == null ||
                                          licenceBackUrl!.isEmpty)
                                      ? const Center(
                                          child: Text(
                                            "Back Side",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),

                                if (isEditing)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (currentStatus == "Rejected") {
                                          if (licenceBackUrl != null &&
                                              licenceBackUrl!.isNotEmpty) {
                                            setState(() {
                                              licenceBackUrl = "";
                                            });
                                          } else {
                                            pickLicenceImage(isFront: false);
                                          }
                                        } else {
                                          pickLicenceImage(isFront: false);
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor:
                                            currentStatus == "Rejected"
                                            ? (licenceBackUrl != null &&
                                                      licenceBackUrl!.isNotEmpty
                                                  ? Colors.red
                                                  : korangeColor)
                                            : korangeColor,

                                        child: Icon(
                                          currentStatus == "Rejected"
                                              ? (licenceBackUrl != null &&
                                                        licenceBackUrl!
                                                            .isNotEmpty
                                                    ? Icons.delete
                                                    : Icons.add)
                                              : Icons.edit,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),
                      CustomText(
                        text: " Aadhar Card (Front & Back)",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        textcolor: KblackColor,
                      ),
                      const SizedBox(height: 10),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    color: Colors.grey.shade100,
                                    image:
                                        (aadharFront != null &&
                                            aadharFront!.isNotEmpty)
                                        ? DecorationImage(
                                            image:
                                                aadharFront!.startsWith('http')
                                                ? NetworkImage(aadharFront!)
                                                : FileImage(File(aadharFront!))
                                                      as ImageProvider,
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child:
                                      (aadharFront == null ||
                                          aadharFront!.isEmpty)
                                      ? const Center(
                                          child: Text(
                                            "Front Side",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),

                                if (isEditing)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (currentStatus == "Rejected") {
                                          if (aadharFront != null &&
                                              aadharFront!.isNotEmpty) {
                                            setState(() {
                                              aadharFront = "";
                                            });
                                          } else {
                                            pickAadharImage(isFront: true);
                                          }
                                        } else {
                                          pickAadharImage(isFront: true);
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor:
                                            currentStatus == "Rejected"
                                            ? (aadharFront != null &&
                                                      aadharFront!.isNotEmpty
                                                  ? Colors.red
                                                  : korangeColor)
                                            : korangeColor,
                                        child: Icon(
                                          currentStatus == "Rejected"
                                              ? (aadharFront != null &&
                                                        aadharFront!.isNotEmpty
                                                    ? Icons.delete
                                                    : Icons.add)
                                              : Icons.edit,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 15),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    color: Colors.grey.shade100,
                                    image:
                                        (aadharBack != null &&
                                            aadharBack!.isNotEmpty)
                                        ? DecorationImage(
                                            image:
                                                aadharBack!.startsWith('http')
                                                ? NetworkImage(aadharBack!)
                                                : FileImage(File(aadharBack!))
                                                      as ImageProvider,
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child:
                                      (aadharBack == null ||
                                          aadharBack!.isEmpty)
                                      ? const Center(
                                          child: Text(
                                            "Back Side",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),

                                if (isEditing)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (currentStatus == "Rejected") {
                                          if (aadharBack != null &&
                                              aadharBack!.isNotEmpty) {
                                            setState(() {
                                              aadharBack = "";
                                            });
                                          } else {
                                            pickAadharImage(isFront: false);
                                          }
                                        } else {
                                          pickAadharImage(isFront: false);
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor:
                                            currentStatus == "Rejected"
                                            ? (aadharBack != null &&
                                                      aadharBack!.isNotEmpty
                                                  ? Colors.red
                                                  : korangeColor)
                                            : korangeColor,
                                        child: Icon(
                                          currentStatus == "Rejected"
                                              ? (aadharBack != null &&
                                                        aadharBack!.isNotEmpty
                                                    ? Icons.delete
                                                    : Icons.add)
                                              : Icons.edit,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    color: kwhiteColor,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Bank Details",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: ifscController,
                            labelText: "IFSC",
                            readOnly: !isEditing,
                            inputFormatters: [UpperCaseTextFormatter()],
                            onChanged: (value) async {
                              final code = value.toUpperCase().trim();

                              if (code.isEmpty || code.length < 11) {
                                setState(() {
                                  bankController.clear();
                                  branchController.clear();
                                  accountController.clear();
                                  holderController.clear();
                                });
                                return;
                              }

                              if (code.length == 11) {
                                if (isValidIfsc(code)) {
                                  await fetchIfscDetails(code);
                                } else {
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        ' Invalid IFSC Code Format.',
                                      ),
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
                          CustomTextField(
                            controller: bankController,
                            labelText: "Bank Name",
                            readOnly: true,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: branchController,
                            labelText: "Branch",
                            readOnly: true,
                          ),
                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: accountController,
                            labelText: "Account Number",
                            readOnly: !isEditing,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: holderController,
                            labelText: "Account Holder Name",
                            readOnly: !isEditing,
                          ),

                          SizedBox(height: 20),
                          Center(
                            child: SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  updateDriverDetails();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: korangeColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text(
                                  "Update",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(korangeColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> pickLicenceImage({required bool isFront}) async {
    if (!isEditing) return;

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Center(
          child: Text(
            "Select Image From",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                        licenceFrontUrl = picked.path;
                      } else {
                        licenceBackUrl = picked.path;
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
                        licenceFrontUrl = picked.path;
                      } else {
                        licenceBackUrl = picked.path;
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

  Future<void> pickAadharImage({required bool isFront}) async {
    if (!isEditing) return;

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Center(
          child: Text(
            "Select Image From",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /// CAMERA
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
                        aadharFront = picked.path;
                      } else {
                        aadharBack = picked.path;
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

              /// GALLERY
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
                        aadharFront = picked.path;
                      } else {
                        aadharBack = picked.path;
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
