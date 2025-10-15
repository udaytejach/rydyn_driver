import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:rydyn/Driver/BottomnavigationBar/D_bottomnavigationbar.dart';
import 'package:rydyn/Driver/Login/selectLanguage.dart';
import 'package:rydyn/Driver/SharedPreferences/shared_preferences.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';
import 'package:rydyn/Driver/Widgets/customText.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:animated_text_kit/animated_text_kit.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateNext();
//   }

//   Future<void> _navigateNext() async {
//     await Future.delayed(const Duration(seconds: 3));

//     await SharedPrefServices.init();
//     bool isLoggedIn = SharedPrefServices.getislogged();
//     String role = SharedPrefServices.getRoleCode().toString();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       FocusManager.instance.primaryFocus?.unfocus();
//     });
//     print("isLoggedIn: $isLoggedIn");
//     print("role: $role");

//     if (isLoggedIn && role == "Driver") {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => D_BottomNavigation()),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => LanguageSelectionScreen()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     const colorizeColors = [
//       Colors.white,
//       Colors.white38,
//       Colors.grey,
//       Colors.orange,
//     ];

//     const colorizeTextStyle = TextStyle(
//       fontSize: 42.0,
//       fontWeight: FontWeight.bold,
//       fontFamily: 'Horizon',
//       letterSpacing: 1.5,
//     );

//     return Scaffold(
//       backgroundColor: korangeColor,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const SizedBox(),

//           Center(
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width * 0.8,
//               child: AnimatedTextKit(
//                 repeatForever: true,
//                 animatedTexts: [
//                   ColorizeAnimatedText(
//                     'Mana Driver',
//                     textStyle: colorizeTextStyle,
//                     colors: colorizeColors,
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//                 isRepeatingAnimation: true,
//                 pause: const Duration(milliseconds: 200),
//               ),
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.only(bottom: 40),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CustomText(
//                   text: 'Made in India',
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                   textcolor: kwhiteColor,
//                 ),
//                 const SizedBox(width: 5),
//                 Image.asset(
//                   'images/flag.png',
//                   width: 21,
//                   height: 17,
//                   fit: BoxFit.contain,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 3));

    await SharedPrefServices.init();
    bool isLoggedIn = SharedPrefServices.getislogged();
    String role = SharedPrefServices.getRoleCode().toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });

    print("isLoggedIn: $isLoggedIn");
    print("role: $role");

    if (isLoggedIn && role == "Driver") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => D_BottomNavigation()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LanguageSelectionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.white,
      Colors.white38,
      Colors.grey,
      Colors.orange,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 42.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Horizon',
      letterSpacing: 1.5,
    );

    return Scaffold(
      backgroundColor: korangeColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Center(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'rydyn',
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    isRepeatingAnimation: true,
                    pause: const Duration(milliseconds: 200),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: 'Made in India',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  textcolor: kwhiteColor,
                ),
                const SizedBox(width: 5),
                Image.asset(
                  'images/flag.png',
                  width: 21,
                  height: 17,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
