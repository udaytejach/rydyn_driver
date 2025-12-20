import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('te')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Mana Driver'**
  String get appTitle;

  /// No description provided for @selectLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language.'**
  String get selectLanguageTitle;

  /// No description provided for @selectLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap to continue in your chosen language.'**
  String get selectLanguageSubtitle;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Mobile Number'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number to get started we\'ll send you an OTP for verification.'**
  String get loginSubtitle;

  /// No description provided for @checking.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get checking;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'You don’t have an account? '**
  String get noAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter mobile number'**
  String get enterMobileNumber;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again.'**
  String get invalidOtp;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Your OTP'**
  String get otpTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to '**
  String get otpSentTo;

  /// No description provided for @otpAutoFill.
  ///
  /// In en, this message translates to:
  /// **' this OTP will get auto entering'**
  String get otpAutoFill;

  /// No description provided for @didNotReceiveOtp.
  ///
  /// In en, this message translates to:
  /// **'You didn’t receive OTP? '**
  String get didNotReceiveOtp;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @bottomNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get bottomNavHome;

  /// No description provided for @bottomNavMyRides.
  ///
  /// In en, this message translates to:
  /// **'My Rides'**
  String get bottomNavMyRides;

  /// No description provided for @bottomNavTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get bottomNavTransactions;

  /// No description provided for @bottomNavMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get bottomNavMenu;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Namaskaram'**
  String get greeting;

  /// No description provided for @pickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickupLocation;

  /// No description provided for @enterPickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter pickup location'**
  String get enterPickupLocation;

  /// No description provided for @dropLocation.
  ///
  /// In en, this message translates to:
  /// **'Drop Location'**
  String get dropLocation;

  /// No description provided for @enterDropLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter drop location'**
  String get enterDropLocation;

  /// No description provided for @dropLocation2.
  ///
  /// In en, this message translates to:
  /// **'Drop Location 2'**
  String get dropLocation2;

  /// No description provided for @enterDropLocation2.
  ///
  /// In en, this message translates to:
  /// **'Enter drop location 2'**
  String get enterDropLocation2;

  /// No description provided for @bookADriver.
  ///
  /// In en, this message translates to:
  /// **'Book A Driver'**
  String get bookADriver;

  /// No description provided for @myVehicles.
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get myVehicles;

  /// No description provided for @viewVehicles.
  ///
  /// In en, this message translates to:
  /// **'View Vehicles'**
  String get viewVehicles;

  /// No description provided for @menumyAddress.
  ///
  /// In en, this message translates to:
  /// **'My Address'**
  String get menumyAddress;

  /// No description provided for @menuFavDrivers.
  ///
  /// In en, this message translates to:
  /// **'Favourite Drivers'**
  String get menuFavDrivers;

  /// No description provided for @menuUpdateMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Update Mobile Number'**
  String get menuUpdateMobileNumber;

  /// No description provided for @menuAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get menuAppLanguage;

  /// No description provided for @menuOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get menuOffers;

  /// No description provided for @menuReferaFriend.
  ///
  /// In en, this message translates to:
  /// **'Refer a Friend'**
  String get menuReferaFriend;

  /// No description provided for @menuTC.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get menuTC;

  /// No description provided for @menuHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get menuHelpSupport;

  /// No description provided for @menuCancelPolicy.
  ///
  /// In en, this message translates to:
  /// **'Cancellation policy'**
  String get menuCancelPolicy;

  /// No description provided for @menuAbtMD.
  ///
  /// In en, this message translates to:
  /// **'About Mana Driver'**
  String get menuAbtMD;

  /// No description provided for @menuDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get menuDeleteAccount;

  /// No description provided for @menuLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get menuLogout;

  /// No description provided for @menuEnterMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile'**
  String get menuEnterMobile;

  /// No description provided for @menuEnterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get menuEnterOTP;

  /// No description provided for @menuDontRecieved.
  ///
  /// In en, this message translates to:
  /// **'Don’t Received? '**
  String get menuDontRecieved;

  /// No description provided for @menuResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get menuResend;

  /// No description provided for @menuCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get menuCancel;

  /// No description provided for @menuUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get menuUpdate;

  /// No description provided for @menuDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get menuDelete;

  /// No description provided for @menuSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get menuSave;

  /// No description provided for @menuSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get menuSaving;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address,'**
  String get address;

  /// No description provided for @dummy_adres.
  ///
  /// In en, this message translates to:
  /// **'St.No.98, Main Rd, Near JLN House Serilingampally, Kondapur,  500084'**
  String get dummy_adres;

  /// No description provided for @add_new_Address.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get add_new_Address;

  /// No description provided for @fav_dummy_text.
  ///
  /// In en, this message translates to:
  /// **'You don’t Favourite Drivers at the moment please try after sometime.'**
  String get fav_dummy_text;

  /// No description provided for @offer_dummy_text.
  ///
  /// In en, this message translates to:
  /// **'You don’t have offers at the moment. Please try again later.'**
  String get offer_dummy_text;

  /// No description provided for @rat_Txt1.
  ///
  /// In en, this message translates to:
  /// **'Refer to your friend and get Rewards of 100/-'**
  String get rat_Txt1;

  /// No description provided for @rat_Txt2.
  ///
  /// In en, this message translates to:
  /// **'Send an invitation to a friend'**
  String get rat_Txt2;

  /// No description provided for @rat_Txt3.
  ///
  /// In en, this message translates to:
  /// **'Your friend signup'**
  String get rat_Txt3;

  /// No description provided for @rat_Txt4.
  ///
  /// In en, this message translates to:
  /// **'You’ll both get cash when your friend first book a ride'**
  String get rat_Txt4;

  /// No description provided for @rat_Txt5.
  ///
  /// In en, this message translates to:
  /// **'Send a Invitation'**
  String get rat_Txt5;

  /// No description provided for @tDt1.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get tDt1;

  /// No description provided for @tD_D1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to our app. By using this application, you agree to the following terms and conditions.'**
  String get tD_D1;

  /// No description provided for @tDt2.
  ///
  /// In en, this message translates to:
  /// **'2. User Obligations'**
  String get tDt2;

  /// No description provided for @tD_D2.
  ///
  /// In en, this message translates to:
  /// **'Users must ensure all information provided is accurate and must not misuse the service.'**
  String get tD_D2;

  /// No description provided for @tDt3.
  ///
  /// In en, this message translates to:
  /// **'3. Account Security'**
  String get tDt3;

  /// No description provided for @tD_D3.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for maintaining the confidentiality of your account credentials.'**
  String get tD_D3;

  /// No description provided for @tDt4.
  ///
  /// In en, this message translates to:
  /// **'4. Data Privacy'**
  String get tDt4;

  /// No description provided for @tD_D4.
  ///
  /// In en, this message translates to:
  /// **'We value your privacy. Your data is stored securely and handled as per our privacy policy.'**
  String get tD_D4;

  /// No description provided for @tDt5.
  ///
  /// In en, this message translates to:
  /// **'5. Intellectual Property'**
  String get tDt5;

  /// No description provided for @tD_D5.
  ///
  /// In en, this message translates to:
  /// **'All content in the app is protected by copyright and may not be reused without permission.'**
  String get tD_D5;

  /// No description provided for @tDt6.
  ///
  /// In en, this message translates to:
  /// **'6. Service Changes'**
  String get tDt6;

  /// No description provided for @tD_D6.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to modify or discontinue the service without notice.'**
  String get tD_D6;

  /// No description provided for @tDt7.
  ///
  /// In en, this message translates to:
  /// **'7. Termination'**
  String get tDt7;

  /// No description provided for @tD_D7.
  ///
  /// In en, this message translates to:
  /// **'We may suspend or terminate your access if you violate any terms outlined here.'**
  String get tD_D7;

  /// No description provided for @tDt8.
  ///
  /// In en, this message translates to:
  /// **'8. Third-party Links'**
  String get tDt8;

  /// No description provided for @tD_D8.
  ///
  /// In en, this message translates to:
  /// **'We may include links to third-party sites. We are not responsible for their content.'**
  String get tD_D8;

  /// No description provided for @tDt9.
  ///
  /// In en, this message translates to:
  /// **'9. Governing Law'**
  String get tDt9;

  /// No description provided for @tD_D9.
  ///
  /// In en, this message translates to:
  /// **'These terms shall be governed in accordance with the laws of your country or region.'**
  String get tD_D9;

  /// No description provided for @hS_t1.
  ///
  /// In en, this message translates to:
  /// **'How can I help you today?'**
  String get hS_t1;

  /// No description provided for @hS_t2.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get hS_t2;

  /// No description provided for @hS_t3.
  ///
  /// In en, this message translates to:
  /// **'For call'**
  String get hS_t3;

  /// No description provided for @hS_t4.
  ///
  /// In en, this message translates to:
  /// **'Send a mail'**
  String get hS_t4;

  /// No description provided for @cP_q1.
  ///
  /// In en, this message translates to:
  /// **'1. Free Cancellation Window'**
  String get cP_q1;

  /// No description provided for @cP_a1.
  ///
  /// In en, this message translates to:
  /// **'You can cancel your booking within 5 minutes of confirmation without any charges.'**
  String get cP_a1;

  /// No description provided for @cP_q2.
  ///
  /// In en, this message translates to:
  /// **'2. Cancellation After 5 Minutes'**
  String get cP_q2;

  /// No description provided for @cP_a2.
  ///
  /// In en, this message translates to:
  /// **'• 50 cancellation fee will be charged if:'**
  String get cP_a2;

  /// No description provided for @cP_a22.
  ///
  /// In en, this message translates to:
  /// **'• Driver already started the trip.'**
  String get cP_a22;

  /// No description provided for @cP_a23.
  ///
  /// In en, this message translates to:
  /// **'• Driver waited at your location for more than 10'**
  String get cP_a23;

  /// No description provided for @cP_q3.
  ///
  /// In en, this message translates to:
  /// **'3. No-Show Policy (Customer absent)'**
  String get cP_q3;

  /// No description provided for @cP_a3.
  ///
  /// In en, this message translates to:
  /// **'If customer is not available at pickup point even after 15 minutes, trip will be auto-cancelled. #100 will be charged as no-show'**
  String get cP_a3;

  /// No description provided for @cP_q4.
  ///
  /// In en, this message translates to:
  /// **'4. Driver Cancellation'**
  String get cP_q4;

  /// No description provided for @cP_a4.
  ///
  /// In en, this message translates to:
  /// **'If a driver cancels after accepting, we will reassign another driver. Repeated cancellations by drivers will lead to penalties and suspension.'**
  String get cP_a4;

  /// No description provided for @cP_q5.
  ///
  /// In en, this message translates to:
  /// **'5. Refund Timeline'**
  String get cP_q5;

  /// No description provided for @cP_a5.
  ///
  /// In en, this message translates to:
  /// **'If you paid online, eligible refunds will be processed within 3-5 business days.'**
  String get cP_a5;

  /// No description provided for @mDdisk.
  ///
  /// In en, this message translates to:
  /// **'Mana Driver - Mee Vahanam, Maa Driver!\nMana Driver is your trusted platform to book professional, verified drivers anytime you need. Whether it\'s a one-way ride, round trip, hourly booking, or outstation travel - we\'ve got you covered.'**
  String get mDdisk;

  /// No description provided for @dA_t1.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get dA_t1;

  /// No description provided for @dA_t2.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to delete your account?'**
  String get dA_t2;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @p_firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get p_firstName;

  /// No description provided for @p_lastName.
  ///
  /// In en, this message translates to:
  /// **'last Name'**
  String get p_lastName;

  /// No description provided for @p_email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get p_email;

  /// No description provided for @p_phoneNumner.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get p_phoneNumner;

  /// No description provided for @p_verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get p_verified;

  /// No description provided for @p_editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get p_editProfile;

  /// No description provided for @home_viewoffers.
  ///
  /// In en, this message translates to:
  /// **'View Offers'**
  String get home_viewoffers;

  /// No description provided for @home_watch.
  ///
  /// In en, this message translates to:
  /// **'Watch & Learn'**
  String get home_watch;

  /// No description provided for @home_prem.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM FEEL FOR DRIVER SERVICES'**
  String get home_prem;

  /// No description provided for @home_india.
  ///
  /// In en, this message translates to:
  /// **'Made in India'**
  String get home_india;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter Your OTP'**
  String get enterOtp;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **' OTP sent !!'**
  String get otpSent;

  /// No description provided for @noOtp.
  ///
  /// In en, this message translates to:
  /// **'You didn’t receive OTP? '**
  String get noOtp;

  /// No description provided for @resentOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resentOtp;

  /// No description provided for @fcmotptitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back, Captain!'**
  String get fcmotptitle;

  /// No description provided for @fcmotpbody.
  ///
  /// In en, this message translates to:
  /// **'You\'re now logged in and ready to go.'**
  String get fcmotpbody;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @namaskaram.
  ///
  /// In en, this message translates to:
  /// **'Namaskaram'**
  String get namaskaram;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @myEarnings.
  ///
  /// In en, this message translates to:
  /// **'My Earnings'**
  String get myEarnings;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @exitAppQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit the app?'**
  String get exitAppQuestion;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cannotAcceptBooking.
  ///
  /// In en, this message translates to:
  /// **'Cannot Accept Booking'**
  String get cannotAcceptBooking;

  /// No description provided for @turnOnlineFirst.
  ///
  /// In en, this message translates to:
  /// **'Please turn online first to accept bookings.'**
  String get turnOnlineFirst;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @confirmRide.
  ///
  /// In en, this message translates to:
  /// **'Confirm Ride'**
  String get confirmRide;

  /// No description provided for @acceptRideQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to accept this ride?'**
  String get acceptRideQuestion;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @rideAccepted.
  ///
  /// In en, this message translates to:
  /// **'Ride Accepted'**
  String get rideAccepted;

  /// No description provided for @rideAcceptedBy.
  ///
  /// In en, this message translates to:
  /// **'Your ride has been accepted by'**
  String get rideAcceptedBy;

  /// No description provided for @rideAcceptedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Ride accepted successfully!'**
  String get rideAcceptedSuccess;

  /// No description provided for @bookingNotFound.
  ///
  /// In en, this message translates to:
  /// **'Booking not found.'**
  String get bookingNotFound;

  /// No description provided for @rideAlreadyTaken.
  ///
  /// In en, this message translates to:
  /// **'Ride Already Taken'**
  String get rideAlreadyTaken;

  /// No description provided for @rideAlreadyTakenByOther.
  ///
  /// In en, this message translates to:
  /// **'This ride has already been accepted by another driver.'**
  String get rideAlreadyTakenByOther;

  /// No description provided for @failedToUpdateStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update status:'**
  String get failedToUpdateStatus;

  /// No description provided for @confirmOnlineStatus.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to be'**
  String get confirmOnlineStatus;

  /// No description provided for @yourBookings.
  ///
  /// In en, this message translates to:
  /// **'Your Bookings'**
  String get yourBookings;

  /// No description provided for @noAcceptedBookings.
  ///
  /// In en, this message translates to:
  /// **'No bookings available'**
  String get noAcceptedBookings;

  /// No description provided for @driver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driver;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @logoutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutQuestion;

  /// No description provided for @totalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total earnings'**
  String get totalEarnings;

  /// No description provided for @ridePaymentNote.
  ///
  /// In en, this message translates to:
  /// **'The ride payment will be auto-debited to your account once the customer pays for the booking in cash.'**
  String get ridePaymentNote;

  /// No description provided for @noTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No Transactions Found'**
  String get noTransactionsFound;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @basicDetails.
  ///
  /// In en, this message translates to:
  /// **'Basic Details'**
  String get basicDetails;

  /// No description provided for @bankDetails.
  ///
  /// In en, this message translates to:
  /// **'Bank Details'**
  String get bankDetails;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @lightPremium.
  ///
  /// In en, this message translates to:
  /// **'Light-Premium'**
  String get lightPremium;

  /// No description provided for @lightPremiumHeavy.
  ///
  /// In en, this message translates to:
  /// **'Light-Premium-Heavy'**
  String get lightPremiumHeavy;

  /// No description provided for @chooseVehicleType.
  ///
  /// In en, this message translates to:
  /// **'Choose Vehicle Type'**
  String get chooseVehicleType;

  /// No description provided for @licenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Licence Number'**
  String get licenceNumber;

  /// No description provided for @drivingLicenceFrontBack.
  ///
  /// In en, this message translates to:
  /// **' Driving Licence (Front & Back)'**
  String get drivingLicenceFrontBack;

  /// No description provided for @frontSide.
  ///
  /// In en, this message translates to:
  /// **'Front Side'**
  String get frontSide;

  /// No description provided for @backSide.
  ///
  /// In en, this message translates to:
  /// **'Back Side'**
  String get backSide;

  /// No description provided for @aadharFrontBack.
  ///
  /// In en, this message translates to:
  /// **' Aadhar Card (Front & Back)'**
  String get aadharFrontBack;

  /// No description provided for @ifsc.
  ///
  /// In en, this message translates to:
  /// **'IFSC'**
  String get ifsc;

  /// No description provided for @invalidIfscFormat.
  ///
  /// In en, this message translates to:
  /// **' Invalid IFSC Code Format.'**
  String get invalidIfscFormat;

  /// No description provided for @ifscMaxLength.
  ///
  /// In en, this message translates to:
  /// **'IFSC code cannot exceed 11 characters.'**
  String get ifscMaxLength;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// No description provided for @branch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branch;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @accountHolderName.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Name'**
  String get accountHolderName;

  /// No description provided for @selectImageFrom.
  ///
  /// In en, this message translates to:
  /// **'Select Image From'**
  String get selectImageFrom;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @rideDetails.
  ///
  /// In en, this message translates to:
  /// **'Ride Details'**
  String get rideDetails;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @unableToOpenDialer.
  ///
  /// In en, this message translates to:
  /// **'Unable to open dialer.'**
  String get unableToOpenDialer;

  /// No description provided for @ownerPhoneUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Owner phone number not available.'**
  String get ownerPhoneUnavailable;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @routeInformation.
  ///
  /// In en, this message translates to:
  /// **'Route Information'**
  String get routeInformation;

  /// No description provided for @dropLocation1.
  ///
  /// In en, this message translates to:
  /// **'Drop Location 1'**
  String get dropLocation1;

  /// No description provided for @eta.
  ///
  /// In en, this message translates to:
  /// **'ETA: '**
  String get eta;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @unableToOpenMaps.
  ///
  /// In en, this message translates to:
  /// **'Unable to open Google Maps.'**
  String get unableToOpenMaps;

  /// No description provided for @errorOpeningDirections.
  ///
  /// In en, this message translates to:
  /// **'Error opening directions:'**
  String get errorOpeningDirections;

  /// No description provided for @getDirections.
  ///
  /// In en, this message translates to:
  /// **'Get Directions'**
  String get getDirections;

  /// No description provided for @tripDetails.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get tripDetails;

  /// No description provided for @cityLimit.
  ///
  /// In en, this message translates to:
  /// **'City Limit: '**
  String get cityLimit;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @slotDetails.
  ///
  /// In en, this message translates to:
  /// **'Slot Details'**
  String get slotDetails;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departure;

  /// No description provided for @arrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get arrival;

  /// No description provided for @ownerDetails.
  ///
  /// In en, this message translates to:
  /// **'Owner Details'**
  String get ownerDetails;

  /// No description provided for @paymentSummary.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paymentSummary;

  /// No description provided for @servicePrice.
  ///
  /// In en, this message translates to:
  /// **'Service Price'**
  String get servicePrice;

  /// No description provided for @convenienceFee.
  ///
  /// In en, this message translates to:
  /// **'Convenience Fee'**
  String get convenienceFee;

  /// No description provided for @couponApplied.
  ///
  /// In en, this message translates to:
  /// **'Coupon Applied'**
  String get couponApplied;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// No description provided for @customerReview.
  ///
  /// In en, this message translates to:
  /// **'Customer Review'**
  String get customerReview;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating: '**
  String get rating;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback: '**
  String get feedback;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment: '**
  String get comment;

  /// No description provided for @cancelRide.
  ///
  /// In en, this message translates to:
  /// **'Cancel Ride'**
  String get cancelRide;

  /// No description provided for @cancelFree.
  ///
  /// In en, this message translates to:
  /// **'You can cancel this ride for FREE.\nAre you sure?'**
  String get cancelFree;

  /// No description provided for @cancelCharge.
  ///
  /// In en, this message translates to:
  /// **'Cancelling now will charge ₹39.\nDo you want to proceed?'**
  String get cancelCharge;

  /// No description provided for @pay39.
  ///
  /// In en, this message translates to:
  /// **'Pay ₹39.00'**
  String get pay39;

  /// No description provided for @cancelMyRide.
  ///
  /// In en, this message translates to:
  /// **'Cancel My Ride'**
  String get cancelMyRide;

  /// No description provided for @rideCancelled.
  ///
  /// In en, this message translates to:
  /// **'Ride Cancelled'**
  String get rideCancelled;

  /// No description provided for @waitingForPayment.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Payment'**
  String get waitingForPayment;

  /// No description provided for @paymentReceived.
  ///
  /// In en, this message translates to:
  /// **'Payment Received'**
  String get paymentReceived;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentFailed;

  /// No description provided for @waitingPaymentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Waiting for payment confirmation...'**
  String get waitingPaymentConfirmation;

  /// No description provided for @swipeCompleteRide.
  ///
  /// In en, this message translates to:
  /// **'Swipe to Complete Ride'**
  String get swipeCompleteRide;

  /// No description provided for @swipeStartRide.
  ///
  /// In en, this message translates to:
  /// **'Swipe to Start Ride'**
  String get swipeStartRide;

  /// No description provided for @completeRide.
  ///
  /// In en, this message translates to:
  /// **'Complete Ride'**
  String get completeRide;

  /// No description provided for @confirmCompleteRide.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to complete this ride?'**
  String get confirmCompleteRide;

  /// No description provided for @rideCompleted.
  ///
  /// In en, this message translates to:
  /// **'Ride Completed'**
  String get rideCompleted;

  /// No description provided for @rideCompletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your ride has been completed. Thank you for choosing Rydyn!'**
  String get rideCompletedMessage;

  /// No description provided for @rideCompletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Ride completed successfully!'**
  String get rideCompletedSuccess;

  /// No description provided for @cancellation.
  ///
  /// In en, this message translates to:
  /// **'Cancellation'**
  String get cancellation;

  /// No description provided for @cancelFreeShort.
  ///
  /// In en, this message translates to:
  /// **'You can cancel this ride for FREE.'**
  String get cancelFreeShort;

  /// No description provided for @cancelChargeShort.
  ///
  /// In en, this message translates to:
  /// **'Cancelling now will charge ₹39.'**
  String get cancelChargeShort;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @enterOtp4.
  ///
  /// In en, this message translates to:
  /// **'Enter 4-Digit OTP'**
  String get enterOtp4;

  /// No description provided for @invalidOtp4.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 4-digit OTP.'**
  String get invalidOtp4;

  /// No description provided for @rideStarted.
  ///
  /// In en, this message translates to:
  /// **'Ride Started'**
  String get rideStarted;

  /// No description provided for @rideStartedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your ride has started. Have a safe journey!'**
  String get rideStartedMessage;

  /// No description provided for @rideStartedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Ride started successfully — Safe drive!'**
  String get rideStartedSuccess;

  /// No description provided for @errorUpdatingStatus.
  ///
  /// In en, this message translates to:
  /// **'Error updating status: '**
  String get errorUpdatingStatus;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @drivingLicence.
  ///
  /// In en, this message translates to:
  /// **'Driving Licence'**
  String get drivingLicence;

  /// No description provided for @uploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get uploaded;

  /// No description provided for @notUploaded.
  ///
  /// In en, this message translates to:
  /// **'Not uploaded'**
  String get notUploaded;

  /// No description provided for @aadharCard.
  ///
  /// In en, this message translates to:
  /// **'Aadhar Card'**
  String get aadharCard;

  /// No description provided for @noImageAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Image Available'**
  String get noImageAvailable;

  /// No description provided for @failedToLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image'**
  String get failedToLoadImage;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'te': return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
