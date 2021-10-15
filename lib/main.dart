import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sam_rider_app/driver_src/ui/pages/dashboard.dart';
import 'package:sam_rider_app/driver_src/util/Constants.dart';
import 'package:sam_rider_app/src/blocs/auth_bloc.dart';
import 'package:sam_rider_app/src/fire_base/firebase_dataref.dart';
import 'package:sam_rider_app/src/ui/pages/chat.dart';
import 'package:sam_rider_app/src/ui/pages/checkout.dart';
import 'package:sam_rider_app/src/ui/pages/faq.dart';
import 'package:sam_rider_app/src/ui/pages/add_payment_method.dart';
import 'package:sam_rider_app/src/ui/pages/driver_list.dart';
import 'package:sam_rider_app/src/ui/pages/driver_profile.dart';
import 'package:sam_rider_app/src/ui/pages/help.dart';
import 'package:sam_rider_app/src/ui/pages/job_location_pick.dart';
import 'package:sam_rider_app/src/ui/pages/intro.dart';
import 'package:sam_rider_app/src/ui/pages/login.dart';
import 'package:sam_rider_app/src/ui//pages/add_card.dart';
import 'package:sam_rider_app/src/ui/pages/payment.dart';
import 'package:sam_rider_app/src/ui/pages/privacy.dart';
import 'package:sam_rider_app/src/ui/pages/register.dart';
import 'package:sam_rider_app/src/ui/pages/request_details.dart';
import 'package:sam_rider_app/src/ui/pages/select_car_size.dart';
import 'package:sam_rider_app/src/ui/pages/select_duration.dart';
import 'package:sam_rider_app/src/ui/pages/select_issue.dart';
import 'package:sam_rider_app/src/ui/pages/select_weight.dart';
import 'package:sam_rider_app/src/ui/pages/settings.dart';
import 'package:sam_rider_app/src/ui/pages/termsofservice.dart';
import 'package:sam_rider_app/src/ui/pages/verify_number.dart';
import 'package:sam_rider_app/src/ui/pages/welcome.dart';
import 'package:sam_rider_app/src/ui/pages/home.dart';
import 'package:sam_rider_app/src/ui/pages/your_current_trip.dart';
import 'package:sam_rider_app/src/ui/pages/your_trips.dart';
import 'package:sam_rider_app/src/ui/pages/your_trips_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'driver_src/ui/pages/account.dart';
import 'driver_src/ui/pages/chat.dart';
import 'driver_src/ui/pages/driver_info.dart';
import 'driver_src/ui/pages/driver_picture.dart';
import 'driver_src/ui/pages/earnings.dart';
import 'driver_src/ui/pages/earnings_details.dart';
import 'driver_src/ui/pages/edit_profile.dart';
import 'driver_src/ui/pages/home.dart';
import 'driver_src/ui/pages/intro.dart';
import 'driver_src/ui/pages/license_info.dart';
import 'driver_src/ui/pages/license_picture.dart';
import 'driver_src/ui/pages/login.dart';
import 'driver_src/ui/pages/notifications.dart';
import 'driver_src/ui/pages/privacy.dart';
import 'driver_src/ui/pages/profile.dart';
import 'driver_src/ui/pages/promotions.dart';
import 'driver_src/ui/pages/recent_transactions.dart';
import 'driver_src/ui/pages/register.dart';
import 'driver_src/ui/pages/register_final.dart';
import 'driver_src/ui/pages/requests_list.dart';
import 'driver_src/ui/pages/select_car_size.dart';
import 'driver_src/ui/pages/termsofservice.dart';
import 'driver_src/ui/pages/verify_number.dart';
import 'driver_src/ui/pages/welcome.dart';
import 'src/ui/pages/profile.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'SAM_channel', // id
  'SAM', // title
  'Driver has arrived at your location', // description
  importance: Importance.max,
);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Constants.prefs = await SharedPreferences.getInstance();

  await Firebase.initializeApp();
  await setupNotification();
  // FireDataRef dataRef = FireDataRef();
  // dataRef.initConfig();
  runApp(MyApp(
      AuthBloc(),
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SAM Rider',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: Constants.prefs.getString("USER_TYPE") == "RIDER" ? '/rider_welcome' : (Constants.prefs.getString("USER_TYPE") == "DRIVER" ? '/driver_welcome' : '/'),
        routes: {
          '/home': (context) => HomePage(),
          '/': (context) => DashboardPage(),
          '/joblocation': (context) => JobLocationPickPage(),
          '/rider_welcome': (context) => WelcomePage(),
          '/intro': (context) => IntroPage(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => RegisterPage(),
          '/verify_phone': (context) => VerificationPage(),
          '/payment': (context) => PaymentPage(),
          '/add_payment': (context) => AddPaymentMethodPage(),
          '/add_card': (context) => AddCardPage(),
          '/your_current_trip': (context) => YourCurrentTripPage(),
          '/your_trips_list': (context) => YourTripsList(),
          '/your_trip': (context) => YourTripPage(),
          '/select_issue': (context) => SelectIssuePage(),
          '/help': (context) => HelpPage(),
          '/settings': (context) => SettingsPage(),
          '/profile': (context) => ProfilePage(),
          '/privacy': (context) => PrivacyPage(),
          '/termsofservice': (context) => TermsOfServicePage(),
          '/select_duration': (context) => SelectDurationPage(),
          '/driver_profile': (context) => DriverProfilePage(),
          '/driver_list': (context) => DriverListPage(),
          '/select_car_size': (context) => SelectCarSizePage(),
          '/select_weight': (context) => SelectWeightPage(),
          '/request_details': (context) => RequestDetailsPage(),
          '/faq': (context) => FAQPage(),
          '/checkout': (context) => CheckoutPage(),
          '/chat': (context) => Chat(),

          '/driver_home': (context) => Driver_MyHomePage(),
          '/driver_welcome': (context) => Driver_WelcomePage(),
          '/driver_intro': (context) => Driver_IntroPage(),
          '/notifications': (context) => Driver_NotificationsPage(),
          '/earnings': (context) => Driver_EarningsPage(),
          '/earnings_details': (context) => Driver_EarningsDetailsPage(),
          '/recent_transactions': (context) => Driver_RecentTransactionsPage(),
          '/account': (context) => Driver_AccountPage(),
          '/edit_profile': (context) => Driver_EditProfilePage(),
          '/driver_select_car_size': (context) => Driver_SelectCarSizePage(),
          '/promotions': (context) => Driver_PromotionsPage(),
          '/driver_login': (context) => Driver_LoginPage(),
          '/driver_signup': (context) => Driver_RegisterPage(),
          '/driver_driver_profile': (context) => Driver_ProfilePage(),
          '/driver_privacy': (context) => Driver_PrivacyPage(),
          '/driver_termsofservice': (context) => Driver_TermsOfServicePage(),
          // '/request_details': (context) => RequestDetailsPage(),
          '/request_lists': (context) => Driver_RequestsListPage(),
          '/driver_chat': (context) => Driver_Chat(),
          '/driver_info' : (context) => Driver_DriverInfoPage(),//Old
          '/license_info' : (context) => Driver_LicenseInfoPage(),
          '/verify_number' : (context) => Driver_VerificationPage(),
          '/driver_picture' : (context) => Driver_DriverImagePage(),//Old
          '/license_picture':(context) => Driver_LicenseImageFrontPage(),
          '/register_final':(context) => Driver_FinalRegistrationPage(),
        },
      )));
}

Future<void> setupNotification() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
      AndroidInitializationSettings("@drawable/sam_logo");
  var initializationSettingsIOs = IOSInitializationSettings();
  var initSettings = InitializationSettings(android: initializationSettingsAndroid,iOS: initializationSettingsIOs);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Firebase: "+message.notification.body.toString());
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification.android;
    if (notification != null && android != null) {
        showNotification(message.notification.body.toString(),
            flutterLocalNotificationsPlugin);
    }
  });
}

void showNotification( v, flp) async {
  var android = AndroidNotificationDetails(
      'SAM', 'SAM_Channel', 'SAM',
      priority: Priority.high, importance: Importance.max,);
  var platform = NotificationDetails(android: android);
  await flp.show(0, 'SAM Rider', '$v', platform);
}


class MyApp extends InheritedWidget {
  final AuthBloc authBloc;
  final Widget child;

  MyApp(this.authBloc, this.child) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }


  static MyApp of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyApp>();
  }
}
