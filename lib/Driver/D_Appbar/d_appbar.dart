import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nyzoridecaptain/Driver/SharedPreferences/shared_preferences.dart';
import 'package:nyzoridecaptain/Driver/Widgets/colors.dart';
import 'package:nyzoridecaptain/Driver/Widgets/customButton.dart';
import 'package:nyzoridecaptain/Driver/Widgets/customText.dart';
import 'package:nyzoridecaptain/Driver/Widgets/customoutlinedbutton.dart';

class DAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  const DAppbar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  State<DAppbar> createState() => _DAppbarState();
}

class _DAppbarState extends State<DAppbar> {
  bool isOnline = false;

  void _loadOnlineStatus() async {
    final status = await SharedPrefServices.getisOnline();
    setState(() {
      isOnline = status;
    });
  }

  void _showOnlineDialog() {
    final nextStatus = isOnline ? "Offline" : "Online";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(
            child: Text(
              'Are you sure you want to be $nextStatus?',
              style: const TextStyle(
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
                  text: 'No',
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
                  text: 'Yes',
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
      await FirebaseFirestore.instance
          .collection('drivers')
          .doc(SharedPrefServices.getDocId())
          .update({'isOnline': status});
    } catch (e) {
      print("Failed to update server: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // _loadOnlineStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    child: Image.asset("images/Menu_D.png", color: KblackColor),
                  ),
                ),
              ),
              const Spacer(),

              CustomText(
                text: widget.title,
                fontSize: 23,
                fontWeight: FontWeight.w600,
                textcolor: KblackColor,
              ),

              const Spacer(),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
        ],
      ),
    );
  }
}
