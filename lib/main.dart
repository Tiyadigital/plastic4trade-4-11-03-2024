// @dart=2.19
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';
import 'package:Plastic4trade/utill/AppLifecycleObserver.dart';
import 'package:android_id/android_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/api/firebase_api.dart';
import 'package:Plastic4trade/screen/Blog.dart';
import 'package:Plastic4trade/screen/BussinessProfile.dart';
import 'package:Plastic4trade/screen/Buyer_sell_detail.dart';
import 'package:Plastic4trade/screen/Follower_Following.dart';
import 'package:Plastic4trade/screen/HomePage.dart';
import 'package:Plastic4trade/screen/Liveprice.dart';
import 'package:Plastic4trade/screen/Videos.dart';
import 'package:Plastic4trade/screen/other_user_profile.dart';
import 'package:Plastic4trade/widget/MainScreen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'api/api_interface.dart';
import 'model/Login.dart';
import 'utill/constant.dart';
import 'dart:io' show Platform;

import 'screen/LoginScreen.dart';
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
        // Android-specific code
        //print('device id $deviceId');
        //if(constanst.fcm_token!=null || constanst.fcm_token.isEmpty) {
        const androidId = AndroidId();
        constanst.android_device_id = (await androidId.getId())!;

        print('android device');
        print(constanst.android_device_id);
        //add_android_device();


        // }
      }
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;
      /*await FirebaseMessaging.instance.requestPermission();


*/
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
          sound: true, badge: true, alert: true);
      if (notification != null && android != null) {
        await _showNotification(
          title: notification.title ?? '',
          body: notification.body ?? '',
        );
      }

      /* name: 'plastic4Trade',*/
      /* name: 'plastic4Trade',
          options: FirebaseOptions(
          apiKey: "AIzaSyCTqG3cUX04ACxu1U4tRhfTrI_odai_ZPY",
          appId: "1:929685037367:android:4ee71ab0f0e0608492fab2",
          messagingSenderId: "929685037367",
          projectId: "plastic4trade-55372",
          databaseURL: "https://plastic4trade-55372-default-rtdb.firebaseio.com"));*/
    } else if (Platform.isIOS) {
      await Firebase.initializeApp(
        /* options: FirebaseOptions(
              apiKey: "AIzaSyCTqG3cUX04ACxu1U4tRhfTrI_odai_ZPY",
              appId: "1:929685037367:ios:2ff9d0954f9bc0e292fab2",
              messagingSenderId: "929685037367",
              projectId: "plastic4trade-55372",
              databaseURL: "https://plastic4trade-55372-default-rtdb.firebaseio.com/")*/
      );
      /* final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        await _showNotification(

          title: notification.title ?? '',
          body: notification.body ?? '',
        );
      }*/
      /* name: 'plastic4Trade',*/
      /*);*/
      if (Platform.isIOS) {
        //  if (constanst.APNSToken != null || constanst.fcm_token.isEmpty) {
        print('ios device');
        final iosinfo = await deviceInfo.iosInfo;
        constanst.devicename =iosinfo.name!;
        constanst.ios_device_id = iosinfo.identifierForVendor!;
        print('ios device_id ${constanst.ios_device_id}');
        //add_ios_device();


        //  }
      }
    }
  }
}
add_android_device() async {
  Login login1 = Login();

  /*_onLoading();*/
  var res = await androidDevice_Register(
      constanst.usernm.toString());
  print('Inside Api ');
  if (res['status'] == 1) {
    login1 = Login.fromJson(res);

    /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(0)));*/
    /*  Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => MainScreen(0)),
        ModalRoute.withName('/'));*/
    Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: res['message']);
  } else {
    Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: res['message']);
  }
}

add_ios_device() async {
  Login login1 = Login();

  /*_onLoading();*/
  var res = await iosDevice_Register();

  if (res['status'] == 1) {
    login1 = Login.fromJson(res);

    Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: res['message']);
    /* SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString('user_id', login.result!.userid.toString());
    _pref.setString('name', login.result!.userName.toString());
    _pref.setString('email', login.result!.email.toString());
    _pref.setString('phone', login.result!.phoneno.toString());
    _pref.setString('api_token', login.result!.userToken.toString());
    _pref.setString('step', login.result!.stepCounter.toString());

    _pref.setString('userImage', login.result!.userImage.toString());
    _pref.setBool('islogin', true);
    Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen(0)));*/
  } else {
    Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: res['message']);
  }
}

// ValueNotifier<Map<String, dynamic>?> notificationPayload = ValueNotifier(null);


Future<void> _showNotification(
    {required String title, required String body}) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'high_impotance_channel',
    'High Importance Notification',
    channelDescription: 'This channel is used for importance notification',

  );
  NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  int notificationId = Random().nextInt(100000);
  final _androidchannel =  AndroidNotificationChannel(
      'high_impotance_channel',
      'High Importance Notification',
      description: 'This channel is used for importance notification',
      importance: Importance.defaultImportance);

}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //WidgetsBinding.instance.addObserver(AppLifecycleObserver());
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsBinding.instance!.addPostFrameCallback((_) async {
    int appOpenCount =  getAppOpenCount() as int ;
    // appOpenCount++;
    saveAppOpenCount(appOpenCount);
    /*  Fluttertoast.showToast(timeInSecForIosWeb: 2,
      msg: 'Welcome to the app!',
      gravity: ToastGravity.CENTER,
    );*/
  });
  //await Firebase.initializeApp();
  //runApp(const MyApp());
  runApp(MyApp()
  );
}

Future<int>  getAppOpenCount() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  constanst.appopencount=prefs.getInt('appOpenCount') ?? 1;
  // Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'rtt ${constanst.appopencount}');
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

        Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'rfsrsfrfr');
        print('jfjjfrfjfjkfg');
        print(payload);
      }
    },
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //await FirebaseApi().initLocalNotification(context);

  // APIs.getSelfInfo();
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    init(context);
    //Firebase.initializeApp();
   // FirebaseApi().initPushNotification(context);
    return MaterialApp(
      title: 'Flutter Demo',
      /*onGenerateRoute:
      navigatorKey: navigatorKey,*/
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: const Color.fromARGB(255, 0, 91, 148),
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
        fontFamily: 'Metropolis',



        textTheme: const TextTheme(
            titleLarge: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontFamily: 'assets\fonst\Metropolis-Black.otf'),
            titleMedium: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'assets\fonst\Metropolis-Black.otf'),
            titleSmall: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 0, 91, 148),
                fontFamily: 'assets\fonst\Metropolis-Black.otf'),
            bodyMedium: TextStyle(
                fontSize: 15.0,
                fontFamily: 'assets\fonst\Metropolis-Black.otf',
                color: Color.fromARGB(255, 0, 91, 148)),
            bodySmall: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
              fontFamily: 'assets\fonst\Metropolis-Black.otf',
            ),
            bodyLarge: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'assets\fonst\Metropolis-Black.otf'),
            displayLarge: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 0, 91, 148),
                fontFamily: 'assets\fonst\Metropolis-Black.otf'),
            displaySmall: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'assets\fonst\Metropolis-Black.otf'),
            displayMedium: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'assets\fonst\Metropolis-Black.otf'),
            headlineSmall: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'assets\fonst\Metropolis-Black.otf'),
            headlineMedium: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'),
            labelSmall: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: 'assets\fonst\Metropolis-Black.otf')),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

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
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          //height: MediaQuery.of(context).size.width,
          // width: MediaQuery.of(context).size.height,
            children: [
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

  startTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, registerpage);
  }

  void registerpage() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    if (_pref.getBool('islogin') != true) {
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
