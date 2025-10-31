//
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rydyn/Driver/BottomnavigationBar/D_bottomnavigationbar.dart';
import 'package:rydyn/Driver/BottomnavigationBar/chat_screen.dart';
import 'package:rydyn/Driver/DriverDahboard/driverDashboard.dart';
import 'package:rydyn/Driver/SharedPreferences/shared_preferences.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:geolocator/geolocator.dart';

class BookingDetails extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  final docId;

  const BookingDetails({
    super.key,
    required this.bookingData,
    required this.docId,
  });

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  late Map<String, dynamic> data;
  Map<String, dynamic>? vehicleData;
  Map<String, dynamic>? ownerData;

  @override
  void initState() {
    super.initState();
    data = widget.bookingData;
    fetchVehicleData();
    fetchOwnerData();
    // getPaymentStatus(widget.docId);
    print(widget.docId);
  }

  void fetchVehicleData() async {
    String vehicleId = widget.bookingData['vehicleId'] ?? '';
    if (vehicleId.isNotEmpty) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('vehicles')
          .doc(vehicleId)
          .get();

      if (snapshot.exists) {
        setState(() {
          vehicleData = snapshot.data() as Map<String, dynamic>;
        });
      }
    }
  }

  void fetchOwnerData() async {
    String ownerId = widget.bookingData['ownerdocId'] ?? '';

    print('ownerId: $ownerId');

    if (ownerId.isNotEmpty) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(ownerId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        debugPrint(" Fetched Owner Data: $data");

        setState(() {
          ownerData = data;
        });
      } else {
        debugPrint("No owner data found for ownerId: $ownerId");
      }
    } else {
      debugPrint("Owner ID is empty");
    }
  }

  Future<void> _openMapWithCurrentLocation(
    String pickupLat,
    String pickupLng,
  ) async {
    try {
      // Get user’s current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double currentLat = position.latitude;
      double currentLng = position.longitude;

      final Uri googleMapsUrl = Uri.parse(
        "https://www.google.com/maps/dir/?api=1&origin=$currentLat,$currentLng&destination=$pickupLat,$pickupLng&travelmode=driving",
      );

      // Check if can launch
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Could not open Google Maps."),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      print("Error opening map: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Location permission denied or not available."),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<String> getPaymentStatus(String bookingDocId) async {
    try {
      final txSnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('bookingDocId', isEqualTo: bookingDocId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (txSnapshot.docs.isEmpty) {
        return 'Waiting for Payment';
      }

      final txData = txSnapshot.docs.first.data();
      final status = txData['status'] ?? '';

      if (status == 'Success') {
        return 'Payment Received';
      } else if (status == 'Failed') {
        return 'Payment Failed';
      } else {
        return 'Waiting for Payment';
      }
    } catch (e) {
      print('Error checking payment: $e');
      return 'Waiting for Payment';
    }
  }

  @override
  Widget build(BuildContext context) {
    print('docid');
    print(widget.docId);
    String ownerFullName =
        (ownerData != null
                ? "${ownerData!['firstName'] ?? ''} ${ownerData!['lastName'] ?? ''}"
                : 'Owner Name')
            .trim();
    String ownerEmail = ownerData != null
        ? "${ownerData!['email'] ?? ''}"
        : 'Owner Email';

    String ownerContact = ownerData != null
        ? "${ownerData!['phone'] ?? ''}"
        : 'Owner Phone';
    String vehicleName = vehicleData != null
        ? "${vehicleData!['brand'] ?? ''} ${vehicleData!['model'] ?? ''}"
        : 'Vehicle Name';
    String transmission = vehicleData != null
        ? "${vehicleData!['transmission'] ?? ''}"
        : 'Transmission';
    String category = vehicleData != null
        ? "${vehicleData!['category'] ?? ''}"
        : 'Category';
    String vehicleImage =
        vehicleData != null &&
            vehicleData!['images'] != null &&
            vehicleData!['images'].isNotEmpty
        ? vehicleData!['images'][0]
        : 'images/swift.png';
    String driverName = data['driverName'] ?? 'Driver not assigned';
    String driverPhone = data['driverPhone'] ?? '+91 XXXXX XXXXX';
    String driverEmail = data['driverEmail'] ?? 'example@email.com';
    String pickupLocation = data['pickup'] ?? '';
    String distance = data['distance'] ?? '';
    String duration = data['duration'] ?? '';
    String tripMode = data['tripMode'] ?? '';
    String tripTime = data['tripTime'] ?? '';
    String citylimithours = data['cityLimitHours'].toString();
    String dropLocation = data['drop'] ?? '';
    String drop2Location = data['drop2'] ?? '';
    String date = data['date'] ?? 'DD/MM/YYYY';
    String time = data['time'] ?? 'HH:MM';
    String servicePrice = data['servicePrice']?.toString() ?? '0.00';
    String addonPrice = data['addonPrice']?.toString() ?? '0.00';
    String taxes = data['taxes']?.toString() ?? '0.00';
    String walletPoints = data['walletPoints']?.toString() ?? '0.00';
    String totalPrice = data['fare']?.toString() ?? '0.00';
    String status = data['status'] ?? '';
    String OwnerOTP = data['ownerOTP'].toString();
    String pickupLat = data['pickupLat'].toString();
    String pickupLng = data['pickupLng'].toString();
    String dropLat = data['dropLat'].toString();
    String dropLng = data['dropLng'].toString();
    String drop2Lat = data['drop2Lat'].toString();
    String drop2Lng = data['drop2Lng'].toString();

    String _calculateETA(String time, String duration) {
      try {
        final pickupTime = DateFormat("h:mm a").parse(time);

        int totalMinutes = 0;

        if (duration.contains("hr")) {
          final hourMatch = RegExp(r'(\d+)\s*hr').firstMatch(duration);
          if (hourMatch != null) {
            totalMinutes += int.parse(hourMatch.group(1)!) * 60;
          }
        }

        if (duration.contains("min")) {
          final minMatch = RegExp(r'(\d+)\s*min').firstMatch(duration);
          if (minMatch != null) {
            totalMinutes += int.parse(minMatch.group(1)!);
          }
        }

        final eta = pickupTime.add(Duration(minutes: totalMinutes));

        final formattedETA = DateFormat("h:mm a").format(eta);

        if (eta.day > pickupTime.day) {
          return "$formattedETA";
        }

        return formattedETA;
      } catch (e) {
        print("ETA calculation error: $e");
        return "--";
      }
    }

    bool isPaymentReceived = false;

    return Scaffold(
      backgroundColor: Colors.white,
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
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    "images/chevronLeft.png",
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              Center(
                child: CustomText(
                  text: "Ride Details",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(
                right: 15,
                left: 15,
                top: 8,
                bottom: 8,
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kbordergreyColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: kbordergreyColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kbordergreyColor, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: vehicleImage.startsWith('http')
                            ? Image.network(vehicleImage, fit: BoxFit.cover)
                            : Image.asset(vehicleImage, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: vehicleName,
                            textcolor: KblackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          // Row(
                          //   children: [
                          //     CustomText(
                          //       text: transmission,
                          //       textcolor: kgreyColor,
                          //       fontWeight: FontWeight.w400,
                          //       fontSize: 12,
                          //     ),
                          //     Text(' | ', style: TextStyle(color: kgreyColor)),
                          //     CustomText(
                          //       text: category,
                          //       textcolor: kgreyColor,
                          //       fontWeight: FontWeight.w400,
                          //       fontSize: 12,
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "View Vehicle Details",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: korangeColor,
                                decoration: TextDecoration.underline,
                                decorationColor: korangeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 5),

            if (status == 'Accepted' || status == 'Ongoing')
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                bookingId: widget.docId,
                                driverId: SharedPrefServices.getUserId()
                                    .toString(),
                                ownerId: data['ownerId'],
                                ownerName: ownerFullName,
                                ownerProfile: ownerData?['profilePic'] ?? '',
                              ),
                            ),
                          );
                        },

                        icon: const Icon(
                          Icons.chat,
                          color: Colors.grey,
                          size: 20,
                        ),
                        label: const Text(
                          "Chat",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final ownerPhone = ownerData?['phone'] ?? '';
                          if (ownerPhone.isNotEmpty) {
                            final Uri callUri = Uri(
                              scheme: 'tel',
                              path: ownerPhone,
                            );
                            if (await canLaunchUrl(callUri)) {
                              await launchUrl(callUri);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Unable to open dialer."),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Owner phone number not available.",
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: const Text(
                          "Call",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: korangeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 0,
                bottom: 10,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "Route Information",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textcolor: korangeColor,
                    ),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildDot(Colors.green),
                            const SizedBox(width: 10),
                            const CustomText(
                              text: "Pickup Location",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              textcolor: Colors.green,
                            ),

                            const SizedBox(width: 6),
                            const Icon(
                              Icons.access_time,
                              size: 15,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            CustomText(
                              text: time,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              textcolor: Colors.grey,
                            ),
                          ],
                        ),

                        GestureDetector(
                          onTap: () {
                            _openMapWithCurrentLocation(pickupLat, pickupLng);
                          },
                          child: const Icon(
                            Icons.pin_drop,
                            size: 22,
                            color: KredColor,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        top: 0,
                        bottom: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          CustomText(
                            text: pickupLocation,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            textcolor: KblackColor,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildDot(
                              drop2Location.isEmpty ? KredColor : korangeColor,
                            ),
                            const SizedBox(width: 10),
                            CustomText(
                              text: drop2Location.isEmpty
                                  ? "Drop Location"
                                  : "Drop Location 1",
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              textcolor: drop2Location.isEmpty
                                  ? KredColor
                                  : korangeColor,
                            ),

                            if (drop2Location.isEmpty) ...[
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.access_time,
                                size: 15,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              CustomText(
                                text: "ETA: ${_calculateETA(time, duration)}",
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                textcolor: Colors.grey,
                              ),
                            ],
                          ],
                        ),

                        GestureDetector(
                          onTap: () {
                            _openMapWithCurrentLocation(dropLat, dropLng);
                          },
                          child: const Icon(
                            Icons.pin_drop,
                            size: 22,
                            color: KredColor,
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        top: 5,
                        bottom: 10,
                      ),
                      child: CustomText(
                        text: dropLocation,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        textcolor: KblackColor,
                      ),
                    ),

                    if (drop2Location.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  _buildDot(Colors.red),
                                  const SizedBox(width: 8),
                                  const CustomText(
                                    text: "Drop Location 2",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    textcolor: KredColor,
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.access_time,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  CustomText(
                                    text:
                                        "ETA: ${_calculateETA(time, duration)}",
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    textcolor: Colors.grey,
                                  ),
                                ],
                              ),

                              GestureDetector(
                                onTap: () {
                                  _openMapWithCurrentLocation(
                                    drop2Lat,
                                    drop2Lng,
                                  );
                                },
                                child: const Icon(
                                  Icons.pin_drop,
                                  size: 22,
                                  color: KredColor,
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              top: 5,
                              bottom: 10,
                            ),
                            child: CustomText(
                              text: drop2Location,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 15),
                    DottedLine(dashColor: kbordergreyColor, dashLength: 7),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const CustomText(
                              text: "Distance",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textcolor: kseegreyColor,
                            ),
                            const SizedBox(height: 4),
                            CustomText(
                              text: distance,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              textcolor: KblackColor,
                            ),
                          ],
                        ),
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                        Column(
                          children: [
                            CustomText(
                              text: "Duration",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              textcolor: kseegreyColor,
                            ),
                            SizedBox(height: 4),
                            CustomText(
                              text: duration,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              textcolor: KblackColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DottedLine(dashColor: kbordergreyColor, dashLength: 7),

                    const SizedBox(height: 15),

                    Center(
                      child: SizedBox(
                        width: 180,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: korangeColor,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),

                          onPressed: () async {
                            String destinationLat = drop2Location.isNotEmpty
                                ? drop2Lat
                                : dropLat;
                            String destinationLng = drop2Location.isNotEmpty
                                ? drop2Lng
                                : dropLng;

                            try {
                              LocationPermission permission =
                                  await Geolocator.checkPermission();
                              if (permission == LocationPermission.denied) {
                                permission =
                                    await Geolocator.requestPermission();
                              }

                              Position position =
                                  await Geolocator.getCurrentPosition(
                                    desiredAccuracy: LocationAccuracy.high,
                                  );

                              double currentLat = position.latitude;
                              double currentLng = position.longitude;

                              final Uri googleMapsUrl = Uri.parse(
                                "https://www.google.com/maps/dir/?api=1"
                                "&origin=$currentLat,$currentLng"
                                "&destination=$destinationLat,$destinationLng"
                                "&travelmode=driving",
                              );

                              if (await canLaunchUrl(googleMapsUrl)) {
                                await launchUrl(
                                  googleMapsUrl,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Unable to open Google Maps.",
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            } catch (e) {
                              print("Error getting directions: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Error opening directions: ${e.toString()}",
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          },

                          child: const CustomText(
                            text: "Get Directions",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            textcolor: kwhiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: "Trip Details",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textcolor: korangeColor,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Image.asset(
                              "images/calender_drvr.png",
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 8),
                            CustomText(
                              text: tripMode,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Image.asset(
                              "images/time.png",
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 8),
                            CustomText(
                              text: tripTime,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor,
                            ),
                          ],
                        ),
                        if (tripMode == "City Limits" &&
                            citylimithours.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Image.asset(
                                "images/time.png",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                text: 'City Limit : $citylimithours Hours',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textcolor: KblackColor,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: "Slot Details",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textcolor: korangeColor,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Image.asset(
                              "images/calender_drvr.png",
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 8),
                            CustomText(
                              text: date,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Image.asset(
                              "images/time.png",
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 8),
                            CustomText(
                              text: time,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: "Owner Details",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textcolor: korangeColor,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Image.asset(
                              "images/person.png",
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 8),
                            CustomText(
                              text: ownerFullName,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Image.asset(
                              "images/email_drvr.png",
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 8),
                            CustomText(
                              text: ownerEmail,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Image.asset(
                              "images/call_drvr.png",
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 8),
                            CustomText(
                              text: ownerContact,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: "Payment Summary",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textcolor: korangeColor,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CustomText(
                              text: "Service Price",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor,
                            ),
                            CustomText(
                              text:
                                  "₹${(double.tryParse(totalPrice) ?? 0).toStringAsFixed(2)}",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CustomText(
                              text: "Add-on’s",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor,
                            ),
                            CustomText(
                              text: "₹$addonPrice",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CustomText(
                              text: "Fee & Taxes",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor,
                            ),
                            CustomText(
                              text: "₹$taxes",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CustomText(
                              text: "Wallet Points",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor,
                            ),
                            CustomText(
                              text: "₹$walletPoints",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textcolor: KblackColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const DottedLine(dashColor: kseegreyColor),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CustomText(
                              text: "Total Price",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              textcolor: korangeColor,
                            ),
                            CustomText(
                              text:
                                  "₹${(double.tryParse(totalPrice) ?? 0).toStringAsFixed(2)}",

                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              textcolor: korangeColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const DottedLine(dashColor: kseegreyColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: status == 'Completed'
          ? FutureBuilder<String>(
              future: getPaymentStatus(widget.docId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 50,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                String paymentStatus = snapshot.data!;
                Color buttonColor;

                if (paymentStatus == 'Payment Received') {
                  buttonColor = Colors.green;
                } else if (paymentStatus == 'Payment Failed') {
                  buttonColor = Colors.red;
                } else {
                  buttonColor = Colors.orange;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {
                        if (paymentStatus == 'Waiting for Payment') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Waiting for payment confirmation...',
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        paymentStatus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : (status == 'Accepted' || status == 'Ongoing')
          ? Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: SizedBox(
                height: 55,
                child: SlideAction(
                  outerColor: status == 'Ongoing'
                      ? korangeresponseColor
                      : Colors.green,
                  innerColor: Colors.white,
                  borderRadius: 30,
                  elevation: 4,
                  sliderButtonIconPadding: 11,
                  sliderButtonIcon: Icon(
                    Icons.arrow_forward_ios,
                    color: status == 'Ongoing'
                        ? korangeresponseColor
                        : Colors.green,
                    size: 20,
                  ),
                  text: status == 'Ongoing'
                      ? "Swipe to Complete Ride"
                      : "Swipe to Start Ride",
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  onSubmit: () async {
                    await Future.delayed(const Duration(milliseconds: 400));

                    if (status == 'Ongoing') {
                      // Complete ride logic
                    } else if (status == 'Accepted') {
                      _showOtpDialog(context, OwnerOTP, widget.docId);
                    }
                  },
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  void _showOtpDialog(BuildContext context, String ownerOTP, String docID) {
    final TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(
            child: CustomText(
              text: "Enter 4-Digit OTP",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textcolor: korangeColor,
            ),
          ),
          backgroundColor: kwhiteColor,
          content: TextField(
            controller: otpController,
            maxLength: 4,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              counterText: "",
              hintText: "••••",
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: korangeColor, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: korangeColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: korangeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
              ),
              onPressed: () async {
                String enteredOTP = otpController.text.trim();

                if (enteredOTP.isEmpty || enteredOTP.length != 4) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a valid 4-digit OTP."),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                if (enteredOTP == ownerOTP) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('bookings')
                        .doc(docID)
                        .update({'status': 'Ongoing'});

                    Navigator.pop(context);

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => D_BottomNavigation()),
                      (route) => false,
                    );

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green.shade600,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Ride started successfully — Safe drive! 🚗💨",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error updating status: $e"),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Invalid OTP. Please try again."),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: const Text(
                "Confirm",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
    );
  }

  // Widget _buildDot(Color color) {
  //   return Container(
  //     width: 7,
  //     height: 7,
  //     decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  //   );
  // }
}

Widget _buildCard(
  BuildContext context, {
  required String imagePath,
  required String text,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: Container(
        height: 54,
        padding: const EdgeInsets.only(right: 10, left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kbordergreyColor),
        ),
        child: Row(
          children: [
            Image.asset(imagePath, height: 20, width: 20),
            SizedBox(width: 12),
            Expanded(
              child: CustomText(
                text: text,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textcolor: KblackColor,
              ),
            ),
            Image.asset('images/chevronRight.png', height: 18, width: 18),
          ],
        ),
      ),
    ),
  );
}
