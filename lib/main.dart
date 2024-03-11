// @dart=2.19
// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:async';
import 'dart:io' show Platform;

import 'package:Plastic4trade/api/firebase_api.dart';
import 'package:Plastic4trade/widget/MainScreen.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/api_interface.dart';
import 'screen/LoginScreen.dart';
import 'utill/constant.dart';

final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        name: 'Plastic4Trade',
        options: const FirebaseOptions(
            apiKey: "AIzaSyCTqG3cUX04ACxu1U4tRhfTrI_odai_ZPY",
            appId: "1:929685037367:web:9b8d8a76c75d902292fab2",
            messagingSenderId: "929685037367",
            projectId: "plastic4trade-55372"));
  } else {
    if (Platform.isAndroid) {
      await Firebase.initializeApp();
      if (Platform.isAndroid) {
        const androidId = AndroidId();
        constanst.android_device_id = (await androidId.getId())!;
      }
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              sound: true, badge: true, alert: true);
      if (notification != null && android != null) {
        await _showNotification(
          title: notification.title ?? '',
          body: notification.body ?? '',
        );
      }
    } else if (Platform.isIOS) {
      await Firebase.initializeApp();

      if (Platform.isIOS) {
        final iosinfo = await deviceInfo.iosInfo;
        constanst.devicename = iosinfo.name;
        constanst.ios_device_id = iosinfo.identifierForVendor!;
      }
    }
  }
}

add_android_device() async {
  var res = await androidDevice_Register(constanst.usernm.toString());
  if (res['status'] == 1) {
    Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: res['message']);
  } else {
    Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: res['message']);
  }
}

add_ios_device() async {
  var res = await iosDevice_Register();

  if (res['status'] == 1) {
    Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: res['message']);
  } else {
    Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: res['message']);
  }
}

Future<void> _showNotification(
    {required String title, required String body}) async {}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    var appOpenCount = await getAppOpenCount();
    saveAppOpenCount(appOpenCount);
  });

  runApp(const MyApp());
}

Future<int> getAppOpenCount() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  constanst.appopencount = prefs.getInt('appOpenCount') ?? 1;

  return prefs.getInt('appOpenCount') ?? 0;
}

Future<void> saveAppOpenCount(int count) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('appOpenCount', count);
}

Future<void> init(BuildContext context) async {
  await FirebaseApi().initNOtification(context);

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');

   IOSInitializationSettings initializationSettingsios =
   const IOSInitializationSettings(
    defaultPresentBadge: true,
    defaultPresentAlert: true,
    defaultPresentSound: true,
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsios);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? payload) async {
      if (payload != null) {
        Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: 'rfsrsfrfr');
      }
    },
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}



final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    init(context);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: 'Metropolis',
        textTheme: const TextTheme(
            titleLarge: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontFamily: 'assets/fonst/Metropolis-Black.otf'),
            titleMedium: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'assets/fonst/Metropolis-Black.otf'),
            titleSmall: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 0, 91, 148),
                fontFamily: 'assets/fonst/Metropolis-Black.otf'),
            bodyMedium: TextStyle(
                fontSize: 15.0,
                fontFamily: 'assets/fonst/Metropolis-Black.otf',
                color: Color.fromARGB(255, 0, 91, 148)),
            bodySmall: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
              fontFamily: 'assets/fonst/Metropolis-Black.otf',
            ),
            bodyLarge: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'assets/fonst/Metropolis-Black.otf'),
            displayLarge: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 0, 91, 148),

                fontFamily: 'assets/fonst/Metropolis-Black.otf'),
            displaySmall: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'assets/fonst/Metropolis-Black.otf'),
            displayMedium: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'assets/fonst/Metropolis-Black.otf'),
            headlineSmall: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'assets/fonst/Metropolis-Black.otf'),
            headlineMedium: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: 'assets/fonst/Metropolis-SemiBold.otf'),
            labelSmall: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: 'assets/fonst/Metropolis-Black.otf')),
        // colorScheme: ColorScheme.fromSwatch()
        //     .copyWith(secondary: const Color.fromARGB(255, 0, 91, 148)),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin fltNotification;

  String notificationMessge = 'Notification Waiting ';
  String token = "";

  @override
  void initState() {
    super.initState();
    initPermissions();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Center(
            child: Image.asset('assets/plastic4trade logo final.png',
                alignment: Alignment.center),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              'assets/image 1.png',
              alignment: Alignment.center,
              width: 300,
            ),
          )
        ]),
      ),
    );
  }

  initPermissions() async {

    PermissionStatus notificationStatus = await Permission.notification.request();

    if (notificationStatus.isGranted) {
      print("All permissions granted.");
    } else {
      print("One or more permissions were rejected.");
    }
  }

  startTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, registerpage);
  }

  void registerpage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getBool('islogin') != true) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(0),
          ));
    }
  }
}
