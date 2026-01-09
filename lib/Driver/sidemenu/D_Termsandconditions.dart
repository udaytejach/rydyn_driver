import 'package:flutter/material.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';

class D_TermsAndConditions extends StatelessWidget {
  const D_TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: CustomText(
                  text: 'Terms & Conditions',
                  textcolor: KblackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle("NYZO RIDE – DRIVER (CAPTAIN)"),

            const SizedBox(height: 20),

            sectionTitle("1. DRIVER ELIGIBILITY"),
            const SizedBox(height: 10),
            bullet("Driver must be at least 21 years of age."),
            bullet(
              "A valid driving license (LMV / HMV as applicable) is mandatory.",
            ),
            bullet("All documents submitted must be genuine and valid."),

            const SizedBox(height: 20),

            sectionTitle("2. NATURE OF THE PLATFORM"),
            const SizedBox(height: 10),
            bullet("Nyzo Ride is only a technology-based platform."),
            bullet("It connects vehicle owners and drivers."),
            bullet("Nyzo Ride is not:"),
            bullet("A vehicle owner"),
            bullet("A driver"),
            bullet("A transport operator"),

            const SizedBox(height: 20),

            sectionTitle("3. NO JOB OR EMPLOYMENT GUARANTEE"),
            const SizedBox(height: 10),
            bullet("Nyzo Ride does not provide jobs or employment."),
            bullet("Drivers are not employees of Nyzo Ride."),
            bullet("Trip availability is not guaranteed."),
            bullet(
              "Nyzo Ride does not promise fixed income, salary, or minimum trips.",
            ),

            const SizedBox(height: 20),

            sectionTitle("4. INDEPENDENT DRIVER STATUS"),
            const SizedBox(height: 10),
            bullet("Drivers act as independent service providers."),
            bullet("No employer–employee relationship is created."),
            bullet(
              "Benefits such as PF, ESI, leave, or insurance are not applicable.",
            ),
            bullet("Tax and legal compliance is driver’s responsibility."),

            const SizedBox(height: 20),

            sectionTitle("5. PRE-RIDE VEHICLE INSPECTION"),
            const SizedBox(height: 10),
            bullet("Before every ride, the driver must inspect the vehicle."),
            bullet(
              "Tyres, brakes, lights, mirrors, fuel level, and documents must be checked.",
            ),
            bullet(
              "If the vehicle is unsafe, the driver must not start the trip and inform the owner.",
            ),
            bullet(
              "Nyzo Ride is not responsible for vehicle condition or related issues.",
            ),

            const SizedBox(height: 20),

            sectionTitle("6. TRIP RESPONSIBILITIES"),
            const SizedBox(height: 10),
            bullet("Driver must reach the pickup location on time."),
            bullet("All traffic rules and local laws must be followed."),
            bullet(
              "The owner’s vehicle must be driven carefully and responsibly.",
            ),
            bullet(
              "Misbehavior, unsafe driving, or negligence is strictly prohibited.",
            ),

            const SizedBox(height: 20),

            sectionTitle("7. CANCELLATION POLICY"),
            const SizedBox(height: 10),
            bullet("Unnecessary cancellations by the driver must be avoided."),
            bullet("Frequent cancellations may lead to:"),
            bullet("Warning"),
            bullet("Temporary suspension"),
            bullet("Permanent account deactivation"),

            const SizedBox(height: 20),

            sectionTitle("8. PAYMENTS & EARNINGS"),
            const SizedBox(height: 10),
            bullet(
              "Earnings are credited only after successful trip completion.",
            ),
            bullet("Service charges may apply as per Nyzo Ride policy."),
            bullet("No payment will be made for fake or fraudulent trips."),

            const SizedBox(height: 20),

            sectionTitle("9. RATINGS & REVIEWS"),
            const SizedBox(height: 10),
            bullet(
              "Driver performance is evaluated based on ratings and feedback.",
            ),
            bullet(
              "Repeated low ratings or complaints may result in suspension or termination.",
            ),

            const SizedBox(height: 20),

            sectionTitle("10. PROHIBITED ACTIVITIES"),
            const SizedBox(height: 10),
            bullet(
              "Driving under the influence of alcohol or drugs is strictly prohibited.",
            ),
            bullet("Uploading fake documents is not allowed."),
            bullet("App misuse, fraud, abuse, or harassment is prohibited."),
            bullet("Misuse of Nyzo Ride branding is not permitted."),

            const SizedBox(height: 20),

            sectionTitle("11. INSURANCE & LIABILITY"),
            const SizedBox(height: 10),
            bullet(
              "Insurance coverage applies only if specifically provided by Nyzo Ride.",
            ),
            bullet(
              "Driver is responsible for accidents, fines, penalties, and violations.",
            ),
            bullet("Nyzo Ride is not directly liable for any such incidents."),

            const SizedBox(height: 20),

            sectionTitle("12. ACCOUNT SUSPENSION OR TERMINATION"),
            const SizedBox(height: 10),
            bullet(
              "Nyzo Ride reserves the right to suspend or terminate driver accounts for rule violations.",
            ),
            bullet(
              "Immediate action may be taken in case of legal issues or police complaints.",
            ),

            const SizedBox(height: 20),

            sectionTitle("13. DATA & PRIVACY"),
            const SizedBox(height: 10),
            bullet(
              "Driver personal data is used only for service-related purposes.",
            ),
            bullet(
              "Data will not be shared with third parties except as required by law.",
            ),

            const SizedBox(height: 20),

            sectionTitle("14. CHANGES TO TERMS"),
            const SizedBox(height: 10),
            bullet(
              "Nyzo Ride may modify these Terms & Conditions at any time.",
            ),
            bullet("Updates will be communicated through the app."),

            const SizedBox(height: 20),

            sectionTitle("15. LEGAL JURISDICTION"),
            const SizedBox(height: 10),
            bullet("These Terms are governed by Indian laws."),
            bullet("Any disputes shall be subject to Hyderabad jurisdiction."),

            const SizedBox(height: 20),

            sectionTitle("16. ACCEPTANCE"),
            const SizedBox(height: 10),

            bullet("By using the Nyzo Ride Driver App, you confirm that:"),
            bullet(
              "I have read, understood, and agreed to all the above Terms & Conditions.",
            ),
            bullet("CAPTAIN TERMS AND CONDITIONS OF NYZO RIDE"),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}



Widget bullet(String text) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("•  ", style: TextStyle(fontSize: 16)),
        Expanded(
          child: CustomText(
            text: text,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            textcolor: KblackColor,
          ),
        ),
      ],
    ),
  );
}

Widget sectionTitle(String text) {
  return CustomText(
    text: text,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    textcolor: KblackColor,
  );
}

// import 'package:flutter/material.dart';
// import 'package:rydyn/Driver/Widgets/colors.dart';
// import 'package:rydyn/Driver/Widgets/customText.dart';
// import 'package:rydyn/l10n/app_localizations.dart';

// class D_TermsAndConditions extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final localizations = AppLocalizations.of(context)!;

//     final List<Map<String, String>> conditions = [
//       {"title": localizations.tDt1, "description": localizations.tD_D1},
//       {"title": localizations.tDt2, "description": localizations.tD_D2},
//       {"title": localizations.tDt3, "description": localizations.tD_D3},
//       {"title": localizations.tDt4, "description": localizations.tD_D4},
//       {"title": localizations.tDt5, "description": localizations.tD_D5},
//       {"title": localizations.tDt6, "description": localizations.tD_D6},
//       {"title": localizations.tDt7, "description": localizations.tD_D7},
//       {"title": localizations.tDt8, "description": localizations.tD_D8},
//       {"title": localizations.tDt9, "description": localizations.tD_D9},
//     ];
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         automaticallyImplyLeading: false,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1.0),
//           child: Container(color: Colors.grey.shade300, height: 1.0),
//         ),
//         title: Padding(
//           padding: const EdgeInsets.only(bottom: 10.0, top: 5),
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: GestureDetector(
//                   behavior: HitTestBehavior.translucent,
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     width: 50,
//                     height: 50,
//                     alignment: Alignment.centerLeft,
//                     child: Image.asset(
//                       "images/chevronLeft.png",
//                       width: 24,
//                       height: 24,
//                     ),
//                   ),
//                 ),
//               ),
//               Center(
//                 child: CustomText(
//                   text: localizations.menuTC,
//                   textcolor: KblackColor,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 22,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: conditions.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText(
//                   text: conditions[index]['title']!,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   textcolor: KblackColor,
//                 ),
//                 SizedBox(height: 8),
//                 CustomText(
//                   text: conditions[index]['description']!,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w400,
//                   textcolor: kseegreyColor,
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
