import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rydyn/Driver/SharedPreferences/shared_preferences.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';
import 'package:rydyn/Driver/sidemenu/D_Sidemenu.dart';

class MyEarnings extends StatefulWidget {
  const MyEarnings({super.key});

  @override
  State<MyEarnings> createState() => _MyEarningsState();
}

class _MyEarningsState extends State<MyEarnings> {
  String? currentUserId;
  bool isLoading = true;
  List<Map<String, dynamic>> transactions = [];
  double totalEarnings = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final userId = await SharedPrefServices.getUserId();
    setState(() {
      currentUserId = userId;
      isLoading = true;
    });

    final txSnapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .get();

    List<Map<String, dynamic>> userTransactions = [];

    for (var txDoc in txSnapshot.docs) {
      final tx = txDoc.data();
      final bookingDocId = tx['bookingDocId'] ?? '';

      if (bookingDocId.isEmpty) continue;

      final bookingSnap = await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingDocId)
          .get();

      if (!bookingSnap.exists) continue;

      final bookingData = bookingSnap.data()!;
      final driverId = bookingData['driverId'] ?? '';
      final ownerId = bookingData['ownerId'] ?? '';
      final ownerDocId = bookingData['ownerdocId'] ?? '';

      // Only include if the logged-in driver is part of it
      if (userId == driverId) {
        String ownerName = await _getOwnerName(ownerDocId);
        tx['ownerName'] = ownerName;
        userTransactions.add(tx);
      }
    }

    // Calculate total earnings
    double total = userTransactions
        .where((tx) => tx['status'] == 'Success')
        .fold(0.0, (sum, tx) => sum + (tx['amount'] ?? 0.0));

    setState(() {
      transactions = userTransactions;
      totalEarnings = total;
      isLoading = false;
    });
  }

  Future<String> _getOwnerName(String ownerDocId) async {
    if (ownerDocId.isEmpty) return "Unknown Owner";
    final userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(ownerDocId)
        .get();
    if (!userSnap.exists) return "Unknown Owner";

    final userData = userSnap.data()!;
    final firstName = userData['firstName'] ?? '';
    final lastName = userData['lastName'] ?? '';
    return "$firstName $lastName".trim().isEmpty
        ? "Unknown Owner"
        : "$firstName $lastName".trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const D_SideMenu(),
      body: Column(
        children: [
          // 🔹 Top Orange Header (Unchanged)
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
                        const CustomText(
                          text: "Total earnings",
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
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CustomText(
                            text:
                                "The ride payment will be auto-debited to your account once the customer pays for the booking in cash.",
                            textcolor: korangeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 16,
                right: 16,
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
                        const CustomText(
                          text: 'My Earnings',
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                          textcolor: KblackColor,
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 24),
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
                  "Transactions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kbordergreyColor, width: 1.0),
                  ),
                  child: const Icon(
                    Icons.filter_list,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: CircularProgressIndicator(color: korangeColor),
            ),

          if (!isLoading && transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: CustomText(
                text: "No Transactions Found",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                textcolor: KblackColor,
              ),
            ),

          if (!isLoading && transactions.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  final ownerName = tx['ownerName'] ?? 'Unknown Owner';
                  final amount = tx['amount'] ?? 0.0;
                  final status = tx['status'] ?? 'Pending';
                  final paymentMethod = tx['paymentMethod'] ?? 'UPI';
                  final timestamp = tx['timestamp'] != null
                      ? (tx['timestamp'] as Timestamp).toDate()
                      : DateTime.now();

                  final dateString =
                      "${timestamp.day} ${_monthName(timestamp.month)}";

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
                            child: Image.asset("images/download.png"),
                          ),
                          const SizedBox(width: 12),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ownerName,
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
                                      text: paymentMethod,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      textcolor: kseegreyColor,
                                    ),

                                    const VerticalDivider(
                                      color: kseegreyColor,
                                      thickness: 1,
                                      width: 16,
                                    ),
                                    CustomText(
                                      text: dateString,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      textcolor: kseegreyColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          // Container(
                          //   width: 1,
                          //   height: 40,
                          //   color: Colors.grey.shade300,
                          //   margin: const EdgeInsets.symmetric(horizontal: 12),
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
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
                                status == "Success" ? "Credited" : "Failed",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: status == "Success"
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
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
    return months[month - 1];
  }
}

class VShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
