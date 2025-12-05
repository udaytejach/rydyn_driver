import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rydyn/Driver/Login/loginScreen.dart';
import 'package:rydyn/Driver/SharedPreferences/shared_preferences.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';
import 'package:rydyn/Driver/sidemenu/Driverprofilepage.dart';

class NewDriverDashbaord extends StatefulWidget {
  const NewDriverDashbaord({super.key});

  @override
  State<NewDriverDashbaord> createState() => _NewDriverDashbaordState();
}

class _NewDriverDashbaordState extends State<NewDriverDashbaord> {
  @override
  final status = SharedPrefServices.getStatus() ?? "";
  final rejectReason = SharedPrefServices.getrejectReason() ?? "";

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: kwhiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: KblackColor, width: 1),
                          ),
                          child: Image.asset(
                            "images/Menu_D.png",
                            color: KblackColor,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    const CustomText(
                      text: "Captain Dashboard",
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      textcolor: KblackColor,
                    ),

                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 10),

                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.centerLeft,
                  children: [
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                      height: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        backgroundColor: kwhiteColor,
        body: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Namaskaram",
                textcolor: KblackColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              CustomText(
                text:
                    "${SharedPrefServices.getFirstName() ?? ''} ${SharedPrefServices.getLastName() ?? ''}",
                textcolor: KblackColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 10),

              SizedBox(height: 30),
              Center(
                child: Card(
                  elevation: 1.5,
                  color: Colors.grey.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          status == "Rejected"
                              ? Icons.error_outline
                              : Icons.access_time_filled,
                          size: 48,
                          color: status == "Rejected"
                              ? korangeColor
                              : korangeColor,
                        ),

                        const SizedBox(height: 16),
                        Text(
                          status == "Rejected" ? "Rejected" : "Please Wait",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          status == "Rejected"
                              ? (rejectReason.isNotEmpty
                                    ? rejectReason
                                    : "Your application has been rejected.")
                              : "Your documents are under processing. Please wait to get your account activated.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: 15),

                        if (status == "Rejected")
                          SizedBox(
                            height: 45,
                            width: 250,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: korangeColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DriversProfilescreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Resubmit Documents",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: korangeColor,
                    ),
                    onPressed: () {
                      SharedPrefServices.clearUserFromSharedPrefs();

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
