import 'package:flutter/material.dart';
import 'package:rydyn/Driver/Login/loginScreen.dart';
import 'package:rydyn/Driver/SharedPreferences/shared_preferences.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';

class NewDriverDashbaord extends StatefulWidget {
  const NewDriverDashbaord({super.key});

  @override
  State<NewDriverDashbaord> createState() => _NewDriverDashbaordState();
}

class _NewDriverDashbaordState extends State<NewDriverDashbaord> {
  @override
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

              // Center(
              //   child: CustomText(
              //     text: "Your account registered successfully",
              //     textcolor: Colors.green,
              //     fontSize: 15,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
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
                          Icons.access_time_filled,
                          size: 48,
                          color: korangeColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Please Wait",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Your account has been registered successfully.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "It is currently under review and will be approved by the admin.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
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
