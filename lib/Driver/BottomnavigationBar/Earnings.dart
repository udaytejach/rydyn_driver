import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rydyn/Driver/SharedPreferences/shared_preferences.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';
import 'package:rydyn/Driver/sidemenu/D_Sidemenu.dart';
import 'package:rydyn/l10n/app_localizations.dart';

class MyEarnings extends StatefulWidget {
  const MyEarnings({super.key});

  @override
  State<MyEarnings> createState() => _MyEarningsState();
}

class _MyEarningsState extends State<MyEarnings> {
  String? currentUserId;
  double totalEarnings = 0.0;

  Map<String, Map<String, dynamic>> ownerDetails = {};

  @override
  void initState() {
    super.initState();
    _loadUser();
    loadAllOwners();
  }

  Future<void> loadAllOwners() async {
    final snap = await FirebaseFirestore.instance.collection('users').get();

    for (var doc in snap.docs) {
      ownerDetails[doc.id] = doc.data();
    }
  }

  Future<void> _loadUser() async {
    currentUserId = await SharedPrefServices.getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      drawer: const D_SideMenu(),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 250,
                child: ClipPath(
                  clipper: VShapeClipper(),
                  child: Container(
                    width: double.infinity,
                    color: klightorangecolor,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        CustomText(
                          text: localizations.totalEarnings,
                          textcolor: korangeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        const SizedBox(height: 4),

                        CustomText(
                          text: "₹${totalEarnings.toStringAsFixed(2)}",
                          textcolor: korangeColor,
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                        ),

                        const SizedBox(height: 5),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CustomText(
                            text: localizations.ridePaymentNote,
                            textcolor: korangeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 20,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: korangeresponseColor,
                              width: 1,
                            ),
                          ),
                          child: Image.asset(
                            "images/Menu_D.png",
                            color: KblackColor,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    CustomText(
                      text: localizations.myEarnings,
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      textcolor: KblackColor,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.transactions,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kbordergreyColor, width: 1.0),
                  ),
                  child: const Icon(Icons.filter_list, size: 20),
                ),
              ],
            ),
          ),

          currentUserId == null
              ? const CircularProgressIndicator(color: korangeColor)
              : Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('transactions')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(color: korangeColor),
                        );
                      }

                      final txDocs = snap.data!.docs;

                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('bookings')
                            .snapshots(),
                        builder: (context, bookSnap) {
                          if (!bookSnap.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: korangeColor,
                              ),
                            );
                          }

                          final bookingDocs = bookSnap.data!.docs;

                          List<Map<String, dynamic>> finalList = [];
                          double total = 0.0;

                          for (var tx in txDocs) {
                            final data = tx.data() as Map<String, dynamic>;
                            final bookingId = data['bookingDocId'] ?? "";

                            if (bookingId.isEmpty) continue;

                            final match = bookingDocs.where(
                              (b) => b.id == bookingId,
                            );

                            if (match.isEmpty) continue;

                            final book =
                                match.first.data() as Map<String, dynamic>;

                            if (book['driverId'] != currentUserId) continue;

                            data['bookingStatus'] = book['status'] ?? "";

                            final ownerDocId = book['ownerdocId'] ?? "";

                            if (data['bookingStatus'] != "Cancelled" &&
                                ownerDocId.isNotEmpty) {
                              final owner = ownerDetails[ownerDocId];

                              if (owner != null) {
                                data['ownerName'] =
                                    "${owner['firstName']} ${owner['lastName']}";
                              } else {
                                data['ownerName'] = "Rydyn Admin";
                              }
                            } else {
                              data['ownerName'] = "Rydyn Admin";
                            }

                            if (data['status'] == "Success" &&
                                data['bookingStatus'] != "Cancelled") {
                              total += data['amount'] ?? 0.0;
                            }

                            finalList.add(data);
                          }

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() => totalEarnings = total);
                            }
                          });

                          if (finalList.isEmpty) {
                            return Center(
                              child: CustomText(
                                text: localizations.noTransactionsFound,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                textcolor: KblackColor,
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: finalList.length,
                            itemBuilder: (context, index) {
                              final tx = finalList[index];
                              final time = (tx['timestamp'] as Timestamp)
                                  .toDate();
                              final date =
                                  "${time.day} ${_monthName(time.month)}";

                              final amount = tx['amount'] ?? 0.0;
                              final bookingStatus = tx['bookingStatus'] ?? "";
                              final method = tx['paymentMethod'] ?? 'UPI';

                              String label = bookingStatus == "Cancelled"
                                  ? "Debited"
                                  : "Credited";

                              Color labelColor = bookingStatus == "Cancelled"
                                  ? Colors.red
                                  : Colors.green;

                              return Card(
                                color: kwhiteColor,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: kbordergreyColor,
                                    width: 1.0,
                                  ),
                                ),
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: kcirclegrey,
                                        child: Image.asset(
                                          "images/download.png",
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tx['ownerName'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: korangeColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                          IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                CustomText(
                                                  text: method,
                                                  fontSize: 12,
                                                  textcolor: kseegreyColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                const VerticalDivider(
                                                  color: kseegreyColor,
                                                  width: 16,
                                                ),
                                                CustomText(
                                                  text: date,
                                                  fontSize: 12,
                                                  textcolor: kseegreyColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const Spacer(),

                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "₹${amount.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              color: korangeColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),

                                          Text(
                                            label,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: labelColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return m[month - 1];
  }
}

class VShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();
    p.lineTo(0, size.height - 30);
    p.lineTo(size.width / 2, size.height);
    p.lineTo(size.width, size.height - 30);
    p.lineTo(size.width, 0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(oldClipper) => false;
}
