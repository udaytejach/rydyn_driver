import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:rydyn/Driver/BottomnavigationBar/D_bottomnavigationbar.dart';
import 'package:rydyn/Driver/BottomnavigationBar/booking_details.dart';
import 'package:rydyn/Driver/D_Appbar/d_appbar.dart';
import 'package:rydyn/Driver/SharedPreferences/shared_preferences.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customButton.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';
import 'package:rydyn/Driver/Widgets/customoutlinedbutton.dart';
import 'package:rydyn/Driver/sidemenu/D_Sidemenu.dart';
import 'dart:math';

class D_Bookings extends StatefulWidget {
  const D_Bookings({super.key});

  @override
  State<D_Bookings> createState() => _D_BookingsState();
}

class _D_BookingsState extends State<D_Bookings> with TickerProviderStateMixin {
  late AnimationController _bikeAnimationController;
  late Animation<double> _bikeAnimation;

  @override
  void initState() {
    super.initState();

    _bikeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: false);

    _bikeAnimation = Tween<double>(begin: 0, end: 500).animate(
      CurvedAnimation(parent: _bikeAnimationController, curve: Curves.linear),
    );

    // _fetchCars();
  }

  @override
  void dispose() {
    _bikeAnimationController.dispose();
    super.dispose();
  }

  int selectedIndex = 0;
  final List<String> buttonLabels = [
    "Upcoming",
    "Accepted",
    "Ongoing",
    "Completed",
    "Cancelled",
  ];
  List<Map<String, dynamic>> carList = [];
  Future<void> _updateBookingStatus(
    var car,
    String bookingId,
    String newStatus,
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BookingDetails(bookingData: car, docId: car['id']),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride accepted successfully!')),
        );
      }
    } catch (e) {
      debugPrint('Error updating booking status: $e');

      if (e.toString().contains('BOOKING_NOT_FOUND')) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking not found.'),
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
                  const CustomText(
                    text: 'Ride Already Taken',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textcolor: KblackColor,
                  ),

                  const CustomText(
                    text:
                        'This ride has already been accepted by another driver.',
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
                      child: const Text(
                        "OK",
                        style: TextStyle(color: kwhiteColor),
                      ),
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
          content: Text('Failed to update status: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  List<Map<String, dynamic>> get filteredCars {
    String status = '';
    switch (selectedIndex) {
      case 0:
        status = 'New';
        break;
      case 1:
        status = 'Accepted';
        break;
      case 2:
        status = 'Ongoing';
        break;
      case 3:
        status = 'Completed';
        break;

      case 4:
        status = 'Cancelled';
        break;
    }
    return carList.where((car) => car['status'] == status).toList();
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

  bool isInitialLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const D_SideMenu(),
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
                    text: "My Bookings",
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    textcolor: KblackColor,
                  ),

                  const Spacer(),
                ],
              ),
              const SizedBox(height: 20),

              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  Divider(color: Colors.grey.shade300, thickness: 1, height: 1),

                  AnimatedBuilder(
                    animation: _bikeAnimationController,
                    builder: (context, child) {
                      return Positioned(
                        left: _bikeAnimation.value,
                        child: Transform.translate(
                          offset: Offset(0, -10),
                          child: const Icon(
                            Icons.local_shipping,
                            color: korangeColor,
                            size: 30,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15, right: 15, left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(buttonLabels.length, (index) {
                    final isSelected = selectedIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: isSelected
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: korangeColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () =>
                                  setState(() => selectedIndex = index),
                              child: Text(
                                buttonLabels[index],
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          : OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: korangeColor),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () =>
                                  setState(() => selectedIndex = index),
                              child: Text(
                                buttonLabels[index],
                                style: const TextStyle(color: korangeColor),
                              ),
                            ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Your Bookings",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: KblackColor,
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("bookings")
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: korangeColor),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          "No bookings available",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      );
                    }

                    final List<Map<String, dynamic>> carList = snapshot
                        .data!
                        .docs
                        .map((doc) {
                          var data = doc.data() as Map<String, dynamic>;
                          data['id'] = doc.id;
                          return data;
                        })
                        .toList();

                    String status = '';
                    switch (selectedIndex) {
                      case 0:
                        status = 'New';
                        break;
                      case 1:
                        status = 'Accepted';
                        break;
                      case 2:
                        status = 'Ongoing';
                        break;
                      case 3:
                        status = 'Completed';
                        break;

                      case 4:
                        status = 'Cancelled';
                        break;
                    }
                    final myDriverDocId = SharedPrefServices.getDocId()
                        .toString();

                    // final filteredCars = carList
                    //     .where((car) => car['status'] == status)
                    //     .toList();
                    final filteredCars = carList.where((car) {
                      if (status == "New") {
                        return car['status'] == status;
                      }

                      return car['status'] == status &&
                          car['driverdocId'] == myDriverDocId;
                    }).toList();

                    if (filteredCars.isEmpty) {
                      return Center(
                        child: Text(
                          "No ${buttonLabels[selectedIndex]} bookings available",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      );
                    }

                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: Future.wait(
                        filteredCars.map((car) async {
                          final vehicleDoc = await FirebaseFirestore.instance
                              .collection('vehicles')
                              .doc(car['vehicleId'])
                              .get();

                          final vehicle = vehicleDoc.data() ?? {};
                          return {...car, 'vehicleDetails': vehicle};
                        }),
                      ),
                      builder: (context, vehicleSnapshot) {
                        if (vehicleSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: korangeColor,
                            ),
                          );
                        }

                        final carsWithVehicles = vehicleSnapshot.data ?? [];

                        return ListView.separated(
                          itemCount: carsWithVehicles.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final car = carsWithVehicles[index];
                            final vehicle = car['vehicleDetails'] ?? {};

                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BookingDetails(
                                          bookingData: car,
                                          docId: car['id'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 80,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: Colors.grey.shade100,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child:
                                                    (vehicle['images'] !=
                                                            null &&
                                                        vehicle['images']
                                                            is List &&
                                                        vehicle['images']
                                                            .isNotEmpty)
                                                    ? Image.network(
                                                        vehicle['images'][0],
                                                        fit: BoxFit.cover,
                                                        width: 130,
                                                        errorBuilder:
                                                            (
                                                              _,
                                                              __,
                                                              ___,
                                                            ) => const Icon(
                                                              Icons.car_crash,
                                                            ),
                                                      )
                                                    : const Icon(
                                                        Icons.directions_car,
                                                      ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    text:
                                                        '${vehicle['brand'] ?? 'NA'} ${vehicle['model'] ?? 'NA'}',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    textcolor: KblackColor,
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        'images/onTime.png',
                                                        width: 14,
                                                        height: 14,
                                                      ),
                                                      const SizedBox(width: 2),
                                                      CustomText(
                                                        text:
                                                            '${car['date'] != null ? formatDate(car['date']) : 'NA'},',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        textcolor:
                                                            kseegreyColor,
                                                      ),
                                                      const SizedBox(width: 2),
                                                      CustomText(
                                                        text:
                                                            car['time'] ?? 'NA',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        textcolor:
                                                            kseegreyColor,
                                                      ),
                                                      CustomText(
                                                        text:
                                                            ' . ${car['distance'] ?? ''}',
                                                        fontSize: 12,
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
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        if (car['status'] == 'New') ...[
                                          DottedLine(
                                            dashColor: kbordergreyColor,
                                            dashLength: 10,
                                            dashGapLength: 6,
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              // Expanded(
                                              //   child: OutlinedButton(
                                              //     style:
                                              //         OutlinedButton.styleFrom(
                                              //           side: const BorderSide(
                                              //             color:
                                              //                 KorangeColorNew,
                                              //           ),
                                              //         ),
                                              //     onPressed: () {},
                                              //     child: const CustomText(
                                              //       text: "Decline",
                                              //       textcolor: KorangeColorNew,
                                              //       fontSize: 12,
                                              //       fontWeight: FontWeight.w500,
                                              //     ),
                                              //   ),
                                              // ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            KbtngreenColor,
                                                      ),
                                                  onPressed: () async {
                                                    final isOnline =
                                                        await SharedPrefServices.getisOnline();

                                                    if (!isOnline) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  15,
                                                                ),
                                                          ),
                                                          title: const Center(
                                                            child: CustomText(
                                                              text:
                                                                  "Cannot Accept Booking",
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              textcolor:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          content: const CustomText(
                                                            text:
                                                                'Please turn online first to accept bookings.',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            textcolor:
                                                                Colors.black,
                                                          ),
                                                          actions: [
                                                            CustomButton(
                                                              text: 'OK',
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
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  15,
                                                                ),
                                                          ),
                                                          title: const Center(
                                                            child: CustomText(
                                                              text:
                                                                  "Confirm Ride",
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              textcolor:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          content: const CustomText(
                                                            text:
                                                                "Are you sure you want to accept this ride?",
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            textcolor:
                                                                Colors.black,
                                                          ),
                                                          actions: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                CustomCancelButton(
                                                                  text: 'No',
                                                                  onPressed: () {
                                                                    print(
                                                                      car['id'],
                                                                    );
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                  },
                                                                ),
                                                                CustomButton(
                                                                  text: 'Yes',
                                                                  onPressed: () {
                                                                    _updateBookingStatus(
                                                                      car,
                                                                      car['id'],
                                                                      'Accepted',
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
                                                  child: const Text(
                                                    "Accept",
                                                    style: TextStyle(
                                                      color: kwhiteColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
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
        ),
      ),
    );
  }
}

// Future<void> _updateBookingStatus(String bookingId, String newStatus) async {
  //   try {
  //     final driverId = await SharedPrefServices.getUserId();
  //     final driverDocId = await SharedPrefServices.getDocId();
  //     final driverName =
  //         "${await SharedPrefServices.getFirstName()} ${await SharedPrefServices.getLastName()}";

  //     final bookingRef = FirebaseFirestore.instance
  //         .collection('bookings')
  //         .doc(bookingId);
  //     final bookingSnap = await bookingRef.get();

  //     if (!bookingSnap.exists) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(const SnackBar(content: Text('Booking not found.')));
  //       return;
  //     }

  //     final bookingData = bookingSnap.data() as Map<String, dynamic>;
  //     final existingDriverId = bookingData['driverId'] ?? '';

  //     if (existingDriverId.isNotEmpty && existingDriverId != driverId) {
  //       showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(15),
  //           ),
  //           title: const Center(
  //             child: Text(
  //               "Ride Already Taken",
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //           content: const Text(
  //             "This ride has already been accepted by another driver.",
  //             textAlign: TextAlign.center,
  //           ),
  //           actions: [
  //             Center(
  //               child: ElevatedButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: korangeColor,
  //                 ),
  //                 child: const Text("OK", style: TextStyle(color: kwhiteColor)),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //       return;
  //     }

  //     final random = Random();
  //     final ownerOTP = 1000 + random.nextInt(9000);

  //     await bookingRef.update({
  //       'status': newStatus,
  //       'driverdocId': driverDocId,
  //       'driverId': driverId,
  //       'driverName': driverName,
  //       'ownerOTP': ownerOTP.toString(),
  //       'statusHistory': FieldValue.arrayUnion([
  //         {'status': newStatus, 'dateTime': DateTime.now().toIso8601String()},
  //       ]),
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Ride accepted successfully!'),
  //         backgroundColor: Colors.orange,
  //       ),
  //     );
  //   } catch (e) {
  //     debugPrint('Error updating booking status: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to update status: $e'),
  //         backgroundColor: Colors.redAccent,
  //       ),
  //     );
  //   }
  // }




