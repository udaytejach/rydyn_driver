import 'package:flutter/material.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';
import 'package:rydyn/l10n/app_localizations.dart';

class D_TermsAndConditions extends StatelessWidget {
  const D_TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
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
            sectionTitle(localizations.driverTermsTitle),

            const SizedBox(height: 20),

            sectionTitle(localizations.driverEligibility),
            const SizedBox(height: 10),
            bullet(localizations.driverEligibilityAge),
            bullet(localizations.driverEligibilityLicense),
            bullet(localizations.driverEligibilityDocuments),

            const SizedBox(height: 20),

            sectionTitle(localizations.platformNature),
            const SizedBox(height: 10),
            bullet(localizations.platformNatureDesc1),
            bullet(localizations.platformNatureDesc2),
            bullet(localizations.platformNatureNotOwner),
            bullet(localizations.platformNatureNotDriver),
            bullet(localizations.platformNatureNotOperator),

            const SizedBox(height: 20),

            sectionTitle(localizations.noJobGuarantee),
            const SizedBox(height: 10),
            bullet(localizations.nyzoNoJobs),
            bullet(localizations.driversNotEmployees),
            bullet(localizations.tripAvailabilityNotGuaranteed),
            bullet(localizations.nyzoNoFixedIncome),

            const SizedBox(height: 20),

            sectionTitle(localizations.independentDriverStatus),
            const SizedBox(height: 10),
            bullet(localizations.driversIndependentProviders),
            bullet(localizations.noEmployerEmployeeRelation),
            bullet(localizations.noBenefitsApplicable),
            bullet(localizations.taxComplianceDriver),

            const SizedBox(height: 20),

            sectionTitle(localizations.preRideInspection),
            const SizedBox(height: 10),
            bullet(localizations.driverMustInspectVehicle),
            bullet(localizations.inspectionChecklist),
            bullet(localizations.unsafeVehicleNoTrip),
            bullet(localizations.nyzoNotResponsibleVehicle),

            const SizedBox(height: 20),

            sectionTitle(localizations.tripResponsibilities),
            const SizedBox(height: 10),
            bullet(localizations.driverOnTimePickup),
            bullet(localizations.followTrafficRules),
            bullet(localizations.driveCarefullyResponsibly),
            bullet(localizations.misbehaviorProhibited),

            const SizedBox(height: 20),

            sectionTitle(localizations.cancellationPolicy),
            const SizedBox(height: 10),
            bullet(localizations.avoidUnnecessaryCancellations),
            bullet(localizations.frequentCancellationsLeadTo),
            bullet(localizations.cancellationWarning),
            bullet(localizations.cancellationTemporarySuspension),
            bullet(localizations.cancellationPermanentDeactivation),

            const SizedBox(height: 20),

            sectionTitle(localizations.paymentsEarnings),
            const SizedBox(height: 10),
            bullet(localizations.earningsAfterCompletion),
            bullet(localizations.serviceChargesPolicy),
            bullet(localizations.noPaymentFraudTrips),

            const SizedBox(height: 20),

            sectionTitle(localizations.ratingsReviews),
            const SizedBox(height: 10),
            bullet(localizations.driverPerformanceEvaluated),
            bullet(localizations.lowRatingsSuspension),

            const SizedBox(height: 20),

            sectionTitle(localizations.prohibitedActivities),
            const SizedBox(height: 10),
            bullet(localizations.noAlcoholDrugsDriving),
            bullet(localizations.noFakeDocuments),
            bullet(localizations.noAppMisuseFraud),
            bullet(localizations.noBrandMisuse),

            const SizedBox(height: 20),

            sectionTitle(localizations.insuranceLiability),
            const SizedBox(height: 10),
            bullet(localizations.insuranceCoverageProvided),
            bullet(localizations.driverResponsibleAccidents),
            bullet(localizations.nyzoNotLiableIncidents),

            const SizedBox(height: 20),

            sectionTitle(localizations.accountSuspensionTermination),
            const SizedBox(height: 10),
            bullet(localizations.nyzoSuspendTerminateAccounts),
            bullet(localizations.immediateActionLegalIssues),

            const SizedBox(height: 20),

            sectionTitle(localizations.dataPrivacy),
            const SizedBox(height: 10),
            bullet(localizations.driverDataServicePurpose),
            bullet(localizations.dataSharedByLaw),

            const SizedBox(height: 20),

            sectionTitle(localizations.changesToTerms),
            const SizedBox(height: 10),
            bullet(localizations.nyzoModifyTerms),
            bullet(localizations.updatesCommunicatedApp),

            const SizedBox(height: 20),

            sectionTitle(localizations.legalJurisdiction),
            const SizedBox(height: 10),
            bullet(localizations.termsGovernedIndianLaw),
            bullet(localizations.disputesHyderabadJurisdiction),

            const SizedBox(height: 20),

            sectionTitle(localizations.acceptance),
            const SizedBox(height: 10),
            bullet(localizations.driverAcceptanceConfirm),
            bullet(localizations.driverAcceptanceQuote),
            bullet(localizations.captainTermsTitle),

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
            fontWeight: FontWeight.w400,
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
    fontSize: 15,
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
