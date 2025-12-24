import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rydyn/Driver/BottomnavigationBar/D_bottomnavigationbar.dart';
import 'package:rydyn/Driver/BottomnavigationBar/booking_details.dart';
import 'package:rydyn/Driver/BottomnavigationBar/new_driver_dashbaord.dart';
import 'package:rydyn/Driver/SharedPreferences/shared_preferences.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customButton.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';
import 'package:rydyn/Driver/Widgets/customoutlinedbutton.dart';
import 'package:rydyn/l10n/app_localizations.dart';
import 'package:rydyn/Driver/notifications/service.dart';
import 'package:rydyn/Driver/sidemenu/D_Sidemenu.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  bool isOnline = true;
  bool isDropLocation2Visible = false;
  PageController _pageController = PageController(viewportFraction: 1);
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  PageController _offerPageController = PageController(viewportFraction: 1);
  int _offerCurrentPage = 0;
  Timer? _offerAutoScrollTimer;

  PageController _watchPageController = PageController(viewportFraction: 1);
  int _watchCurrentPage = 0;
  Timer? _watchAutoScrollTimer;

  double totalEarnings = 0.0;
  bool isEarningsLoading = true;

  int _bounceIndex = 0;
  late Timer _iconTimer;

  Timer? _statusTimer;
  String? _lastKnownStatus;

  @override
  void initState() {
    super.initState();
    _loadOnlineStatus();
    // _fetchCars();
    // _startAutoScroll();
    _startOfferAutoScroll();
    _startIconBounce();
    _startStatusCheckService();
    // _fetchTotalEarnings();
  }

  void _startStatusCheckService() {
    _statusTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        final driverDocId = await SharedPrefServices.getDocId();
        if (driverDocId == null) return;

        final snap = await FirebaseFirestore.instance
            .collection("drivers")
            .doc(driverDocId)
            .get(const GetOptions(source: Source.server));

        final status = snap.data()?["status"];
        if (status == null) return;

        if (status == _lastKnownStatus) return;
        _lastKnownStatus = status;

        if (status == "Inactive") {
          _handleDriverDeactivated();
        }

        if (status == "Rejected") {
          _handleDriverRejected();
        }
      } catch (_) {}
    });
  }

  void _handleDriverDeactivated() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const NewDriverDashbaord()),
    );
  }

  void _handleDriverRejected() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const NewDriverDashbaord()),
    );
  }

  void _loadOnlineStatus() async {
    final status = await SharedPrefServices.getisOnline();
    setState(() {
      isOnline = status ?? false;
    });
  }

  int activeIndex = 0;

  List<Map<String, dynamic>> carList = [];

  void _startIconBounce() {
    _iconTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {
        _bounceIndex = (_bounceIndex + 1) % 3;
      });
    });
  }

  Future<void> _fetchTotalEarnings() async {
    try {
      final driverId = await SharedPrefServices.getUserId();
      if (driverId == null) return;

      final txSnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .orderBy('timestamp', descending: true)
          .get();

      double total = 0.0;

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
        final driverIdFromBooking = bookingData['driverId'] ?? '';

        final bookingStatus = bookingData['status'] ?? '';

        if (driverIdFromBooking == driverId &&
            tx['status'] == 'Success' &&
            bookingStatus != 'Cancelled') {
          total += (tx['amount'] ?? 0.0);
        }
      }

      setState(() {
        totalEarnings = total;
        isEarningsLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching earnings: $e");
      setState(() {
        isEarningsLoading = false;
      });
    }
  }

  Future<void> _fetchCars() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("bookings")
          .where('status', isEqualTo: 'New')
          .get();

      List<Map<String, dynamic>> loadedCars = await Future.wait(
        snapshot.docs.map((doc) async {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;

          if (data['createdAt'] != null && data['createdAt'] is Timestamp) {
            data['createdAt'] = (data['createdAt'] as Timestamp)
                .toDate()
                .toString();
          }

          if (data['vehicleId'] != null &&
              data['vehicleId'].toString().isNotEmpty) {
            DocumentSnapshot vehicleDoc = await FirebaseFirestore.instance
                .collection("vehicles")
                .doc(data['vehicleId'])
                .get();

            if (vehicleDoc.exists) {
              data['vehicleDetails'] =
                  vehicleDoc.data() as Map<String, dynamic>;
            } else {
              data['vehicleDetails'] = {};
            }
          } else {
            data['vehicleDetails'] = {};
          }

          data['pickup'] = data['pickup'] ?? 'NA';
          data['drop'] = data['drop'] ?? 'NA';
          data['date'] = data['date'] ?? 'NA';
          data['time'] = data['time'] ?? 'NA';
          data['status'] = data['status'] ?? 'NA';
          data['tripMode'] = data['tripMode'] ?? 'NA';
          data['tripTime'] = data['tripTime'] ?? 'NA';

          return data;
        }),
      );

      setState(() {
        carList = loadedCars;
      });

      if (carList.isNotEmpty) {
        var first = carList.first;
        debugPrint(" First Booking:");
        debugPrint("Pickup: ${first['pickup']}");
        debugPrint("Drop: ${first['drop']}");
        debugPrint("Date: ${first['date']}");
        debugPrint("Time: ${first['time']}");
        debugPrint("Status: ${first['status']}");
        debugPrint("Trip Mode: ${first['tripMode']}");
        debugPrint("Trip Time: ${first['tripTime']}");
        debugPrint("Vehicle ID: ${first['vehicleId'] ?? 'NA'}");

        var vehicle = first['vehicleDetails'] ?? {};
        debugPrint("Vehicle Brand: ${vehicle['brand'] ?? 'NA'}");
        debugPrint("Vehicle Model: ${vehicle['model'] ?? 'NA'}");
        debugPrint("Vehicle Number: ${vehicle['vehicleNumber'] ?? 'NA'}");
        debugPrint("Fuel Type: ${vehicle['fuelType'] ?? 'NA'}");
        debugPrint("Transmission: ${vehicle['transmission'] ?? 'NA'}");
        debugPrint("Category: ${vehicle['category'] ?? 'NA'}");

        if (vehicle['images'] != null &&
            vehicle['images'] is List &&
            vehicle['images'].isNotEmpty) {
          debugPrint("Vehicle Image: ${vehicle['images'][0]}");
        } else {
          debugPrint("Vehicle Image: NA");
        }
      } else {
        debugPrint("No bookings found.");
      }
    } catch (e) {
      debugPrint("Error fetching cars: $e");
    }
  }

  final fcmService = FCMService();
  Future<void> _updateBookingStatus(
    var car,
    String bookingId,
    String newStatus,
    String fcmtitleRideAccepted,
    String fcmbodyRideAccepted,
    String snackBarRideAccepted,
    String snackBarRideAcceptedFailed,
    String rideAlreadyTaken,
    String rideAlreadyTakenMessage,
    String snackBarRideAlreadyTaken,
    String okText,
    String failedToUpdateStatusText,
  ) async {
    try {
      final driverId = await SharedPrefServices.getUserId();
      final driverDocId = await SharedPrefServices.getDocId();
      final driverName =
          "${await SharedPrefServices.getFirstName()} ${await SharedPrefServices.getLastName()}";

      final bookingRef = FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId);

      bool isAccepted = false;

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snap = await transaction.get(bookingRef);

        if (!snap.exists) throw Exception('BOOKING_NOT_FOUND');

        final data = snap.data() as Map<String, dynamic>;
        final existingDriverId = (data['driverId'] ?? '') as String;

        if (existingDriverId.isNotEmpty && existingDriverId != driverId) {
          throw Exception('RIDE_ALREADY_TAKEN');
        }

        if (existingDriverId.isEmpty) {
          final random = Random();
          final ownerOTP = (1000 + random.nextInt(9000)).toString();

          transaction.update(bookingRef, {
            'status': newStatus,
            'driverdocId': driverDocId,
            'driverId': driverId,
            'driverName': driverName,
            'ownerOTP': ownerOTP,
            'statusHistory': FieldValue.arrayUnion([
              {
                'status': newStatus,
                'dateTime': DateTime.now().toIso8601String(),
              },
            ]),
          });

          isAccepted = true;
        }
      });

      if (!mounted) return;

      if (isAccepted) {
        final ownerId = car['ownerdocId'];
        print('ownerdocID $ownerId');
        if (ownerId != null) {
          final ownerSnap = await FirebaseFirestore.instance
              .collection('users')
              .doc(ownerId)
              .get();

          final ownerToken = ownerSnap.data()?['fcmToken'];
          print('ownerToken $ownerToken');
          if (ownerToken != null && ownerToken.isNotEmpty) {
            await fcmService.sendNotification(
              recipientFCMToken: ownerToken,
              title: fcmtitleRideAccepted,
              body: "$fcmbodyRideAccepted $driverName.",
            );
          }
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BookingDetails(bookingData: car, docId: car['id']),
          ),
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(snackBarRideAccepted)));
      }
    } catch (e) {
      debugPrint('Error updating booking status: $e');

      if (e.toString().contains('BOOKING_NOT_FOUND')) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackBarRideAcceptedFailed),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (e.toString().contains('RIDE_ALREADY_TAKEN')) {
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 35,
              vertical: 24,
            ),
            contentPadding: const EdgeInsets.all(20),

            content: SizedBox(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: rideAlreadyTaken,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textcolor: KblackColor,
                  ),

                  CustomText(
                    text: rideAlreadyTakenMessage,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textcolor: KblackColor,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => D_BottomNavigation(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: korangeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(okText, style: TextStyle(color: kwhiteColor)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        return;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$failedToUpdateStatusText $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _startOfferAutoScroll() {
    _offerAutoScrollTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_offerPageController.hasClients) {
        if (_offerCurrentPage < offerImages.length - 1) {
          _offerCurrentPage++;
        } else {
          _offerCurrentPage = 0;
        }

        _offerPageController.animateToPage(
          _offerCurrentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        if (_currentPage < carList.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<List<Map<String, dynamic>>> _attachVehicleDetails(
    List<QueryDocumentSnapshot> docs,
  ) async {
    return await Future.wait(
      docs.map((doc) async {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        if (data['vehicleId'] != null &&
            data['vehicleId'].toString().isNotEmpty) {
          DocumentSnapshot vehicleDoc = await FirebaseFirestore.instance
              .collection("vehicles")
              .doc(data['vehicleId'])
              .get();

          if (vehicleDoc.exists) {
            data['vehicleDetails'] = vehicleDoc.data() as Map<String, dynamic>;
          } else {
            data['vehicleDetails'] = {};
          }
        } else {
          data['vehicleDetails'] = {};
        }

        data['pickup'] = data['pickup'] ?? 'NA';
        data['drop'] = data['drop'] ?? 'NA';
        data['date'] = data['date'] ?? 'NA';
        data['time'] = data['time'] ?? 'NA';
        data['status'] = data['status'] ?? 'NA';
        data['tripMode'] = data['tripMode'] ?? 'NA';
        data['tripTime'] = data['tripTime'] ?? 'NA';

        return data;
      }),
    );
  }

  String formatDate(String date) {
    try {
      final dt = DateTime.parse(date);
      return '${dt.day.toString().padLeft(2, '0')}-'
          '${dt.month.toString().padLeft(2, '0')}-'
          '${dt.year}';
    } catch (e) {
      return date;
    }
  }

  void _showOnlineDialog(
    String title,
    String yesText,
    String noText,
    String online,
    String offline,
  ) {
    final nextStatus = isOnline ? offline : online;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(
            child: Text(
              '$title $nextStatus?',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: "inter",
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomCancelButton(
                  text: noText,
                  onPressed: () => Navigator.pop(context),
                ),

                CustomButton(
                  onPressed: () async {
                    Navigator.pop(context);

                    setState(() {
                      isOnline = !isOnline;
                    });

                    await SharedPrefServices.setisOnline(isOnline);

                    await _updateOnlineStatusOnServer(isOnline);
                  },

                  text: yesText,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateOnlineStatusOnServer(bool status) async {
    try {
      final driverId = await SharedPrefServices.getDocId();
      print(driverId);

      await FirebaseFirestore.instance
          .collection('drivers')
          .doc(driverId)
          .update({'isOnline': status});
    } catch (e) {
      print("Failed to update server: $e");
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    _watchPageController.dispose();
    _watchAutoScrollTimer?.cancel();
    _offerPageController.dispose();
    _offerAutoScrollTimer?.cancel();
    _iconTimer.cancel();
    super.dispose();
  }

  int selectedCarIndex = -1;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      drawer: const D_SideMenu(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Container(color: korangeColor),
                        Container(
                          decoration: BoxDecoration(
                            color: korangeColor,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16), // adjust radius
                              bottomRight: Radius.circular(16), // adjust radius
                            ),
                          ),
                        ),
                        Positioned(
                          top: 30,
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
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),
                                        child: Image.asset("images/Menu_D.png"),
                                      ),
                                    ),
                                  ),

                                  const Spacer(),

                                  GestureDetector(
                                    onTap: () {
                                      _showOnlineDialog(
                                        localizations.confirmOnlineStatus,
                                        localizations.yes,
                                        localizations.no,
                                        localizations.online,
                                        localizations.offline,
                                      );
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      width: 120,
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isOnline
                                            ? Colors.green.shade400
                                            : Colors.red.shade400,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Stack(
                                        children: [
                                          AnimatedAlign(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.easeInOut,
                                            alignment: isOnline
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: Container(
                                              width: 30,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                              child: Text(
                                                isOnline
                                                    ? localizations.online
                                                    : localizations.offline,
                                                style: const TextStyle(
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
                                  const Spacer(),
                                  const SizedBox(width: 12),

                                  // Help Icon
                                  // Container(
                                  //   padding: const EdgeInsets.all(10),
                                  //   decoration: BoxDecoration(
                                  //     shape: BoxShape.circle,

                                  //     border: Border.all(
                                  //       color: kwhiteColor,
                                  //       width: 1,
                                  //     ),
                                  //   ),
                                  //   child: Image.asset("images/contactUs.png"),
                                  //   // child:
                                  //   // const Icon(
                                  //   //   Icons.headphones,
                                  //   //   size: 24,
                                  //   //   color: kwhiteColor,
                                  //   // ),
                                  // ),
                                  Container(),
                                  const SizedBox(width: 12),
                                  // Notification Icon
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     // Navigator.push(
                                  //     //   context,
                                  //     //   MaterialPageRoute(
                                  //     //     builder: (_) => NotificationScreen(),
                                  //     //   ),
                                  //     // );
                                  //   },
                                  //   child: Container(
                                  //     padding: const EdgeInsets.all(10),
                                  //     decoration: BoxDecoration(
                                  //       shape: BoxShape.circle,
                                  //       // color: Colors.white,
                                  //       border: Border.all(
                                  //         color: KnotificationcircleColor,
                                  //         width: 1,
                                  //       ),
                                  //     ),
                                  //     child: Image.asset(
                                  //       'images/notification_D.png',
                                  //       width: 24,
                                  //       height: 24,
                                  //       fit: BoxFit.contain,
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Namaskaram + Guest
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: localizations.namaskaram,
                                    textcolor: kwhiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  CustomText(
                                    text:
                                        "${SharedPrefServices.getFirstName() ?? ''} ${SharedPrefServices.getLastName() ?? ''}",
                                    textcolor: kwhiteColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 190,
                          right: 12,
                          left: 12,
                          child: Container(
                            width: 350,
                            padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: kbordergreyColor,
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: KgreyorangeColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'images/payments.png',
                                          width: 28,
                                          height: 28,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: localizations.myEarnings,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            textcolor: kgreyColor,
                                          ),
                                          SizedBox(height: 1),
                                          StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection("transactions")
                                                .orderBy(
                                                  "timestamp",
                                                  descending: true,
                                                )
                                                .snapshots(),
                                            builder: (context, snap) {
                                              if (!snap.hasData) {
                                                return const Text(
                                                  "₹0.00",
                                                  style: TextStyle(
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.w700,
                                                    color: korangeColor,
                                                  ),
                                                );
                                              }

                                              final docs = snap.data!.docs;

                                              return StreamBuilder<
                                                QuerySnapshot
                                              >(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection("bookings")
                                                    .snapshots(),
                                                builder: (context, bookSnap) {
                                                  if (!bookSnap.hasData) {
                                                    return const Text(
                                                      "₹0.00",
                                                      style: TextStyle(
                                                        fontSize: 28,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: korangeColor,
                                                      ),
                                                    );
                                                  }

                                                  final bookingDocs =
                                                      bookSnap.data!.docs;

                                                  double total = 0.0;
                                                  final currentDriver =
                                                      SharedPrefServices.getUserId();

                                                  for (var tx in docs) {
                                                    final t =
                                                        tx.data()
                                                            as Map<
                                                              String,
                                                              dynamic
                                                            >;
                                                    final bookingId =
                                                        t["bookingDocId"];
                                                    if (bookingId == null)
                                                      continue;

                                                    QueryDocumentSnapshot?
                                                    matched;
                                                    try {
                                                      matched = bookingDocs
                                                          .firstWhere(
                                                            (b) =>
                                                                b.id ==
                                                                bookingId,
                                                          );
                                                    } catch (e) {
                                                      matched = null;
                                                    }

                                                    if (matched == null)
                                                      continue;

                                                    final book =
                                                        matched.data()
                                                            as Map<
                                                              String,
                                                              dynamic
                                                            >;

                                                    if (book["driverId"] ==
                                                            currentDriver &&
                                                        t["status"] ==
                                                            "Success" &&
                                                        book["status"] !=
                                                            "Cancelled") {
                                                      total +=
                                                          (t["amount"] ?? 0.0);
                                                    }
                                                  }

                                                  return AnimatedFlipCounter(
                                                    duration: const Duration(
                                                      milliseconds: 700,
                                                    ),
                                                    value: total,
                                                    prefix: "₹",
                                                    fractionDigits: 2,
                                                    thousandSeparator: ",",
                                                    textStyle: const TextStyle(
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: korangeColor,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 80),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    color: kwhiteColor,

                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(
                              text: localizations.myBookings,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              textcolor: KblackColor,
                            ),
                            // GestureDetector(
                            //   onTap: () {},
                            //   child: Text(
                            //     localizations.viewAll,
                            //     style: GoogleFonts.poppins(
                            //       fontSize: 12,
                            //       fontWeight: FontWeight.w400,
                            //       color: korangeColor,
                            //       decoration: TextDecoration.underline,
                            //       decorationColor: korangeColor,
                            //       decorationStyle: TextDecorationStyle.solid,
                            //       decorationThickness: 1.5,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(height: 20),

                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("bookings")
                              .where("status", isEqualTo: "New")
                              .snapshots(),
                          builder: (context, snap) {
                            if (!snap.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: korangeColor,
                                ),
                              );
                            }

                            final docs = snap.data!.docs;

                            if (docs.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No bookings available",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: kgreyColor,
                                  ),
                                ),
                              );
                            }

                            return FutureBuilder(
                              future: _attachVehicleDetails(docs),
                              builder: (context, vehSnap) {
                                if (!vehSnap.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: korangeColor,
                                    ),
                                  );
                                }

                                final carList = vehSnap.data!;

                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 170,
                                      child: PageView.builder(
                                        controller: _pageController,
                                        itemCount: docs.length,
                                        itemBuilder: (context, index) {
                                          final car = carList[index];
                                          final vehicle =
                                              car["vehicleDetails"] ?? {};

                                          final brandModelText =
                                              '${vehicle['brand'] ?? 'NA'} ${vehicle['model'] ?? 'NA'}';
                                          final extraHeight =
                                              brandModelText.length > 20
                                              ? 10.0
                                              : 0.0;

                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      BookingDetails(
                                                        bookingData: car,
                                                        docId: car['id'],
                                                      ),
                                                ),
                                              );
                                            },
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    right: 8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 1.5,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(7),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              width: 80,
                                                              height: 70,
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      16,
                                                                    ),
                                                                color: Colors
                                                                    .grey
                                                                    .shade100,
                                                              ),
                                                              child: Center(
                                                                child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                  child:
                                                                      (vehicle['images'] !=
                                                                              null &&
                                                                          vehicle['images']
                                                                              is List &&
                                                                          vehicle['images']
                                                                              .isNotEmpty)
                                                                      ? Image.network(
                                                                          vehicle['images'][0],
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          width:
                                                                              130,
                                                                          errorBuilder:
                                                                              (
                                                                                context,
                                                                                error,
                                                                                stackTrace,
                                                                              ) => const Icon(
                                                                                Icons.car_crash,
                                                                              ),
                                                                        )
                                                                      : const Icon(
                                                                          Icons
                                                                              .directions_car,
                                                                        ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 8,
                                                                  ),
                                                                  CustomText(
                                                                    text:
                                                                        '${vehicle['brand'] ?? 'NA'} ${vehicle['model'] ?? 'NA'}',
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    textcolor:
                                                                        KblackColor,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Image.asset(
                                                                        'images/onTime.png',
                                                                        width:
                                                                            14,
                                                                        height:
                                                                            14,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            2,
                                                                      ),
                                                                      CustomText(
                                                                        text:
                                                                            '${car['date'] != null ? formatDate(car['date']) : 'NA'},',
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        textcolor:
                                                                            kseegreyColor,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            2,
                                                                      ),
                                                                      CustomText(
                                                                        text:
                                                                            car['time'] ??
                                                                            'NA',
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        textcolor:
                                                                            kseegreyColor,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      CustomText(
                                                                        text:
                                                                            '${car['distance'] ?? '45 Km'}',
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        textcolor:
                                                                            kseegreyColor,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                size: 18,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        DottedLine(
                                                          dashColor:
                                                              kbordergreyColor,
                                                          dashLength: 10,
                                                          dashGapLength: 6,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Expanded(
                                                              child: ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      KbtngreenColor,
                                                                ),
                                                                onPressed: () async {
                                                                  final isOnline =
                                                                      await SharedPrefServices.getisOnline();

                                                                  if (!isOnline) {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (context) => AlertDialog(
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                            15,
                                                                          ),
                                                                        ),
                                                                        title: Center(
                                                                          child: CustomText(
                                                                            text:
                                                                                localizations.cannotAcceptBooking,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            textcolor:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        content: CustomText(
                                                                          text:
                                                                              localizations.turnOnlineFirst,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          textcolor:
                                                                              Colors.black,
                                                                        ),
                                                                        actions: [
                                                                          CustomButton(
                                                                            text:
                                                                                localizations.ok,
                                                                            onPressed: () {
                                                                              Navigator.pop(
                                                                                context,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (context) => AlertDialog(
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                            15,
                                                                          ),
                                                                        ),
                                                                        title: Center(
                                                                          child: CustomText(
                                                                            text:
                                                                                localizations.confirmRide,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            textcolor:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        content: CustomText(
                                                                          text:
                                                                              localizations.acceptRideQuestion,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          textcolor:
                                                                              Colors.black,
                                                                        ),
                                                                        actions: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              CustomCancelButton(
                                                                                text: localizations.no,
                                                                                onPressed: () {
                                                                                  Navigator.pop(
                                                                                    context,
                                                                                  );
                                                                                },
                                                                              ),
                                                                              CustomButton(
                                                                                text: localizations.yes,
                                                                                onPressed: () {
                                                                                  _updateBookingStatus(
                                                                                    car,
                                                                                    car['id'],
                                                                                    'Accepted',
                                                                                    localizations.rideAccepted,
                                                                                    localizations.rideAcceptedBy,
                                                                                    localizations.rideAcceptedSuccess,
                                                                                    localizations.bookingNotFound,

                                                                                    localizations.rideAlreadyTaken,
                                                                                    localizations.rideAlreadyTakenByOther,
                                                                                    localizations.failedToUpdateStatus,
                                                                                    localizations.ok,
                                                                                    localizations.failedToUpdateStatus,
                                                                                  );
                                                                                },
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                child: Text(
                                                                  localizations
                                                                      .accept,
                                                                  style: TextStyle(
                                                                    color:
                                                                        kwhiteColor,
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
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    const SizedBox(height: 15),

                                    SmoothPageIndicator(
                                      controller: _pageController,
                                      count: docs.length,
                                      effect: WormEffect(
                                        dotHeight: 6,
                                        dotWidth: 30,
                                        activeDotColor: korangeColor,
                                        dotColor: Colors.grey.shade300,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  Divider(height: 4, color: KdeviderColor, thickness: 5),

                  SizedBox(height: 30),

                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    color: kwhiteColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            localizations.home_prem + ' ✨',
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: KbottomnaviconColor,
                              letterSpacing: -1.0,
                            ),
                            textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false,
                              applyHeightToLastDescent: false,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: localizations.home_india,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              textcolor: KbottomnaviconColor,
                            ),
                            SizedBox(width: 10),
                            Image.asset(
                              'images/flag.png',
                              width: 21,
                              height: 17,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(color: korangeColor),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: KdeviderColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: CustomText(
        text: text,
        fontSize: 10,
        fontWeight: FontWeight.w300,
        textcolor: KblackColor,
      ),
    );
  }
}

final List<String> offerImages = [
  'images/offer.png',
  'images/offer.png',
  'images/offer.png',
];

List<CarModel> carList = [
  CarModel(
    imagePath: 'images/swift.png',
    name: 'Maruti Swift Dzire VXI',
    kmsDriven: '76,225 km',
    transmission: 'Manual',
    fuelType: 'Petrol',
    price: '₹7,957',
  ),
  CarModel(
    imagePath: 'images/mahindra.png',
    name: 'Mahindra MARAZZO M2 7STR',
    kmsDriven: '45,120 km',
    transmission: 'Automatic',
    fuelType: 'Diesel',
    price: '₹9,995',
  ),
  CarModel(
    imagePath: 'images/tata.png',
    name: 'Tata Nexon XZ+',
    kmsDriven: '60,000 km',
    transmission: 'Manual',
    fuelType: 'Petrol',
    price: '₹9,100',
  ),
];

class CarModel {
  final String imagePath;
  final String name;
  final String kmsDriven;
  final String transmission;
  final String fuelType;
  final String price;

  CarModel({
    required this.imagePath,
    required this.name,
    required this.kmsDriven,
    required this.transmission,
    required this.fuelType,
    required this.price,
  });
}
