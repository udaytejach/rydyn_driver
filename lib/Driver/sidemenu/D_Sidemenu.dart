import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rydyn/Driver/Login/loginScreen.dart';
import 'package:rydyn/Driver/SharedPreferences/shared_preferences.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';
import 'package:rydyn/Driver/sidemenu/D_Helpandsupport.dart';
import 'package:rydyn/Driver/sidemenu/D_Termsandconditions.dart';
import 'package:rydyn/Driver/sidemenu/Driverprofilepage.dart';
import 'package:rydyn/Driver/sidemenu/MyDocuments.dart';
import 'package:rydyn/Driver/sidemenu/privacy_policy.dart';
import 'package:rydyn/l10n/app_localizations.dart';

class D_SideMenu extends StatelessWidget {
  const D_SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Drawer(
      backgroundColor: kwhiteColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: kwhiteColor,
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                SharedPrefServices.getProfileImage() != null &&
                                    SharedPrefServices.getProfileImage()!
                                        .isNotEmpty
                                ? NetworkImage(
                                    SharedPrefServices.getProfileImage()!,
                                  )
                                : null,
                          ),

                          Positioned(
                            bottom: -5,
                            right: 0,
                            child: Container(
                              // decoration: BoxDecoration(shape: BoxShape.circle),
                              padding: const EdgeInsets.all(2),
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundImage: const AssetImage(
                                  "images/verified.png",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DriversProfilescreen(),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text:
                                "${SharedPrefServices.getFirstName()} ${SharedPrefServices.getLastName()}",
                            textcolor: korangeColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomText(
                            text:
                                "${SharedPrefServices.getvehicletypee()} ${localizations.driver}",
                            textcolor: kseegreyColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Name
              ],
            ),
          ),

          const Divider(),

          ListTile(
            leading: Image.asset("images/documents.png"),
            title: CustomText(
              text: localizations.documents,
              textcolor: kcocoblack,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DocumentsPage()),
              );
            },
          ),
          ListTile(
            leading: Image.asset("images/help&support.png"),
            title: CustomText(
              text: localizations.helpSupport,
              textcolor: kcocoblack,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => D_HelpAndSupport()),
              );
            },
          ),
          ListTile(
            leading: Image.asset("images/Terms&conditions.png"),
            title: CustomText(
              text: localizations.termsConditions,
              textcolor: kcocoblack,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => D_TermsAndConditions()),
              );
            },
          ),
          ListTile(
            leading: Image.asset("images/privacy.png"),
            title: CustomText(
              text: localizations.privacyPolicy,
              textcolor: kcocoblack,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicy()),
              );
            },
          ),
          ListTile(
            leading: Image.asset("images/D_logout.png"),
            title: CustomText(
              text: localizations.menuLogout,
              textcolor: korangeColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(
            child: Text(
              localizations.logoutQuestion,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: "inter",
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: korangeColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    localizations.cancel,
                    style: TextStyle(color: korangeColor, fontFamily: "inter"),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('drivers')
                        .doc(SharedPrefServices.getDocId().toString())
                        .update({'fcmToken': ''});
                    SharedPrefServices.clearUserFromSharedPrefs();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: korangeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    localizations.menuLogout,
                    style: TextStyle(color: Colors.white, fontFamily: "inter"),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
