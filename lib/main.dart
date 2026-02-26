import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:nyzoridecaptain/Driver/BottomnavigationBar/D_bottomnavigationbar.dart';
import 'package:nyzoridecaptain/Driver/D_Models/Driver_ViewModel.dart';
import 'package:nyzoridecaptain/Driver/Login/loginScreen.dart';
import 'package:nyzoridecaptain/Driver/SharedPreferences/shared_preferences.dart';
import 'package:nyzoridecaptain/l10n/app_localizations.dart';
import 'package:nyzoridecaptain/Driver/notifications/firebase_api.dart';
import 'package:nyzoridecaptain/Driver/services/locale_provider.dart';
import 'package:nyzoridecaptain/Driver/services/repository.dart';
import 'package:nyzoridecaptain/Driver/viewmodels/login_viewmodel.dart';
import 'package:nyzoridecaptain/Driver/viewmodels/register_viewmodel.dart';
import 'package:nyzoridecaptain/firebase_options.dart';
import 'package:nyzoridecaptain/splashscreen/splashScreen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('BG message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefServices.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await Geolocator.requestPermission();
  await Geolocator.isLocationServiceEnabled();
  await _requestNotificationPermission();
  await FirebaseApi().initNotifications();
  _setupNotificationListeners();

  if (Platform.isAndroid) {
    print("Running on Android");
  } else if (Platform.isIOS) {
    await FirebaseApi().iosNotifications();
    print("Running on iOS");
  }
  runApp(const MyApp());
}

void _setupNotificationListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.data['route'] != null) {
      navigatorKey.currentState?.pushNamed(message.data['route']);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.data['route'] != null) {
      navigatorKey.currentState?.pushNamed(message.data['route']);
    }
  });
}

Future<void> _requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RegisterViewModel(RepositoryData()),
        ),
        ChangeNotifierProvider(create: (_) => LoginViewModel(RepositoryData())),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => DriverViewModel()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              textTheme: GoogleFonts.poppinsTextTheme(),
              useMaterial3: true,
              dropdownMenuTheme: DropdownMenuThemeData(
                menuStyle: MenuStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                  elevation: MaterialStatePropertyAll(4),
                ),
              ),
            ),
            locale: localeProvider.locale,
            supportedLocales: const [Locale('en'), Locale('hi'), Locale('te')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/dashboard': (context) => D_BottomNavigation(),
              '/login': (context) => const LoginScreen(),
            },
          );
        },
      ),
    );
  }
}
