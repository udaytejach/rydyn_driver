import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyzoridecaptain/Driver/BottomnavigationBar/D_Bookings.dart';
import 'package:nyzoridecaptain/Driver/BottomnavigationBar/Earnings.dart';
import 'package:nyzoridecaptain/Driver/DriverDahboard/driverDashboard.dart';
import 'package:nyzoridecaptain/Driver/Widgets/colors.dart';
import 'package:nyzoridecaptain/l10n/app_localizations.dart';
import 'package:nyzoridecaptain/Driver/sidemenu/D_Helpandsupport.dart';

class D_BottomNavigation extends StatefulWidget {
  @override
  State<D_BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<D_BottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DriverDashboard(),
    D_Bookings(),
    MyEarnings(),
    D_HelpAndSupport(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem _buildNavItem(
    String label,
    String imagePath,
    int index,
  ) {
    final isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 32,
            height: 32,
            color: isSelected ? korangeColor : KbottomnaviconColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? korangeColor : KbottomnaviconColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        bool exitApp = await _showExitDialog(
          context,
          localizations.exitAppQuestion,
          localizations.cancel,
          localizations.exit,
        );
        if (exitApp) {
          Navigator.of(context).pop(true);
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: _screens[_selectedIndex],
          bottomNavigationBar: Container(
            height: 95,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              items: [
                _buildNavItem(
                  localizations.bottomNavHome,
                  'images/D_Home.png',
                  0,
                ),
                _buildNavItem(localizations.bookings, 'images/my_rides.png', 1),
                _buildNavItem(
                  localizations.earnings,
                  'images/D_Earnings.png',
                  2,
                ),
                _buildNavItem(localizations.help, 'images/contactUs.png', 3),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              showSelectedLabels: false,
              showUnselectedLabels: false,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(
    BuildContext context,
    String question,
    String cancel,
    String dialogexit,
  ) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Text(
              question,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  cancel,
                  style: GoogleFonts.poppins(
                    color: korangeColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  exit(0);
                },
                child: Text(
                  dialogexit,
                  style: GoogleFonts.poppins(
                    color: korangeColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
}
