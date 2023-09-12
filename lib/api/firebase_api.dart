import 'dart:convert';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/screen/Follower_Following.dart';
import 'package:Plastic4trade/screen/Notifications.dart';
import 'package:Plastic4trade/utill/constant.dart';

import '../main.dart';
import '../screen/Blog.dart';
import '../screen/BussinessProfile.dart';
import '../screen/Buyer_sell_detail.dart';
import '../screen/Exhibition.dart';
import '../screen/Liveprice.dart';
import '../screen/Tutorial_Videos.dart';
import '../screen/Videos.dart';
import '../screen/other_user_profile.dart';
import '../widget/MainScreen.dart';
import 'dart:io' show Platform;

class FirebaseApi {
  final _androidchannel = AndroidNotificationChannel(
      'high_impotance_channel', 'High Importance Notification',
      description: 'This channel is used for importance notification',
      importance: Importance.defaultImportance);
  final _localNotification = FlutterLocalNotificationsPlugin();
  late BuildContext _context;

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Title : ${message.notification?.title}');
    print('Body : ${message.notification?.body}');
    print('PayLoad: ${message.data}');
    // var data = json.decode(message.payload ?? '');
    // notificationPayload.value = message.data;

    //notification_redirect(message.data,context);
    // Navigator.push(
    //     _context,
    //     MaterialPageRoute(
    //         builder: (context) => other_user_profile(int.parse('14969'))));
  }

  void handleMessage(RemoteMessage message, context) {
    print('Title : ${message.notification?.title}');
    print('Body : ${message.notification?.body}');
    print('data $message');
    print('PayLoad: ${message.data}');
    _context = context;
    notification_redirect(message.data, _context);
  }

  Future initPushNotification(BuildContext context) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (FirebaseMessaging.instance.isAutoInitEnabled) {
      print('User granted permission');
    } else {
      print('User declined permission or has not yet responded');
    }

    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        print('inside open');
        //Fluttertoast.showToast(msg: 'APP Terminate ');
        _context = context;
        notification_redirect(value!.data, _context);
      }
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    /* FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('inside open');
     _context=context;
      notification_redirect(message.data,_context);

    },);*/
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Extract data from the message payload
      //String pageToOpen = message.data['page'];

      // Use Navigator to navigate to the desired page
      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainScreen(3)));
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //_context=context;
      // Fluttertoast.showToast(msg: 'i m notification');
      final notification = message.notification;
      Fluttertoast.showToast(
          msg: 'notification.title${notification!.title.toString()}');
      print('notification.title${notification!.title.toString()}');
      if (notification == null) return;
      print('notification.title');
      print(message.data);
      Fluttertoast.showToast(msg: 'i m notification');

      _localNotification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidchannel.id, _androidchannel.name,
                  channelDescription: _androidchannel.description,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                  styleInformation: const DefaultStyleInformation(true, true),
                  icon: '@drawable/ic_launcher'),
              iOS: const IOSNotificationDetails()),
          payload: jsonEncode(message.toMap()),);
      RemoteNotification? remoteNotification = message.notification;
      AndroidNotification? notification1 = message.notification?.android;
      if (notification1 != null) {
        /*  show_notification(notification.title,
            notification.body,
            message.data);*/
      }
      print('ese ${message.notification!.bodyLocKey.toString()}');
      print('ese ${message.notification!.title}');
      print('ese ${message.notification!.body}');
      print('ese ${message.notification!.android!.clickAction}');

      /*show_notification(notification.title,
        notification.body,
       message.data);*/
    });
  }

  Future<void> initNOtification(BuildContext context) async {
    if (Platform.isAndroid) {
      print('Android ');
      await Firebase.initializeApp();
      final _firebaseMessaging = FirebaseMessaging.instance;
      await _firebaseMessaging.requestPermission();
      final FCMToken = await _firebaseMessaging
          .getToken(
              vapidKey:
                  "BC4eLOdjJWopUE-NEu_WCFLlByPe5-K5_AljnUINqx4QL7RmA3W5lC-__7WDfEWPJF0nVk05xpD3d4JjdrGnfVA")
          .then((value) => value);
      constanst.fcm_token = FCMToken.toString();
      print('Token $FCMToken');
    } else if (Platform.isIOS) {
      await Firebase.initializeApp();
      final _firebaseMessaging = FirebaseMessaging.instance;
      await _firebaseMessaging.requestPermission();
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      final APNSToken =
          await _firebaseMessaging.getToken().then((value) => value);
      constanst.APNSToken = APNSToken.toString();
      print('APNSToken $APNSToken');
      /* */ //);
    }
    initPushNotification(context);
    initLocalNotification(context);
    //FirebaseMessaging.instance.getInitialMessage().then((handleBackgroundMessage)
  }

  show_notification(String? title, String? body, Map<String, dynamic> data) {
    /* showOverlayNotification((context) {
      return GestureDetector(
        onTap: () {
          notification_redirect(data,_context!);
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
          child: SafeArea(
            child: ListTile(
              leading: SizedBox.fromSize(
                  size: const Size(40, 40),
                  child: ClipOval(
                      child:Image.asset('assets/plastic4trade logo final 1 (2).png',height: 40,width: 50,),*/ /* Container(
                        color: Colors.black,
                      )*/ /*
                  )),
              title: Text('Plastic4trade',style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'assets\fonst\Metropolis-Black.otf',
                  color: Colors.black)),
              subtitle: Text(data['title']!,style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400,color:  Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),),
             */ /* trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    OverlaySupportEntry.of(context)?.dismiss();
                  }),*/ /*
            ),
          ),
        ),
      );
    }, duration: Duration(milliseconds: 4000));*/
  }

  notification_redirect(Map<String, dynamic> data, BuildContext context) async {
    String notification_type = data['type'];
    String post_type = data['post_type'];
    String user_id = data['user_id'];
    String post_id = data['postId'];

    print('post type');
    print(notification_type);
    print(user_id);
    print(post_id);
    print('fughirudghiuhg:::::::::');
    if (notification_type == "profile like") {
      print('hello:::::::::');
      if (user_id.toString().isNotEmpty) {
        print('=============');
        // Navigator.of(_context).push(MaterialPageRoute(builder: (context) => other_user_profile(int.parse(user_id.toString()))));
        try {
          await Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>
                      other_user_profile(int.parse(user_id.toString()))));
        } catch (e, stackTrace) {
          // Handle the exception or error
          // Fluttertoast.showToast(msg:'Exception: $e');
          // Fluttertoast.showToast(msg:'Stack trace: $stackTrace');
          print('Exception: $e');
          print('Stack trace: $stackTrace');
        }
      } else {
        print('11111111');
      }
    } else if (notification_type== "follower_profile_like") {

      if (user_id.toString().isNotEmpty) {
        await Navigator.push(
            _context,
            new MaterialPageRoute(
                builder: (context) =>
                    other_user_profile(int.parse(user_id.toString()))));
      }
    } else if (notification_type == "profile_review") {
      print("leelkwopr");
      if (user_id.toString().isNotEmpty) {
        await Navigator.push(
            _context,
            new MaterialPageRoute(
                builder: (context) => bussinessprofile()));
      }
    } else if (notification_type.toString() == "Business profile dislike") {
      if (user_id.toString().isNotEmpty) {
        await Navigator.push(
            _context,
            new MaterialPageRoute(
                builder: (context) =>
                    other_user_profile(int.parse(user_id.toString()))));
      }
    } else if (notification_type.toString() == "post like") {
      print("123");
      if (post_type.toString() == "SalePost") {
        print("12345");
        if (post_id.toString().isNotEmpty) {
          await Navigator.push(
              _context,
              new MaterialPageRoute(
                  builder: (context) =>Buyer_sell_detail(
                      post_type: 'SalePost', prod_id: post_id)));

        }
      }else  {
        print("1234466");
        if (post_type.toString() == "BuyPost") {
          print("75678");
          if (post_id.toString().isNotEmpty) {
            await Navigator.push(
                _context,
                new MaterialPageRoute(
                    builder: (context) => Buyer_sell_detail(
                        post_type: 'BuyPost', prod_id: post_id)));
          }
        }
      }
    }  else if (notification_type.toString() == "followuser") {
      if (user_id.toString().isNotEmpty) {
        /* Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => other_user_profile(int.parse(user_id.toString()))));*/
        await Navigator.push(
            _context,
            new MaterialPageRoute(
                builder: (context) => follower()));
      }
    } else if (notification_type.toString() == "unfollowuser") {
      if (user_id.toString().isNotEmpty) {
        await Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => follower()));
      }
    } else if (notification_type.toString() == "profile_review") {
      if (user_id.toString().isNotEmpty) {
        Navigator.push(
            _context,
            MaterialPageRoute(
                builder: (context) =>
                    other_user_profile(int.parse(user_id.toString()))));
      }
    } else if (notification_type.toString() == "live_price") {
      // if(result.profileUserId.toString().isNotEmpty){
      Navigator.push(
          _context, MaterialPageRoute(builder: (context) => LivepriceScreen()));
      // }
    } else if (notification_type.toString() == "quick_news_notification") {
      // if(result.profileUserId.toString().isNotEmpty){
      Navigator.push(
          _context, MaterialPageRoute(builder: (context) => MainScreen(3)));
      // }
    } else if (notification_type.toString() == "news") {
      // if(result.profileUserId.toString().isNotEmpty){
      Navigator.push(
          _context, MaterialPageRoute(builder: (context) => MainScreen(3)));
      // }
    } else if (notification_type.toString() == "blog") {
      // if(result.profileUserId.toString().isNotEmpty){
      Navigator.push(_context, MaterialPageRoute(builder: (context) => Blog()));
      // }
    } else if (notification_type.toString() == "video") {
      // if(result.profileUserId.toString().isNotEmpty){
      Navigator.push(
          _context, MaterialPageRoute(builder: (context) => Videos()));
      // }
    } else if (notification_type.toString() == "banner") {
      // if(result.profileUserId.toString().isNotEmpty){
      Navigator.push(
          _context, MaterialPageRoute(builder: (context) => MainScreen(0)));
      // }
    } else if (notification_type.toString() == "tutorial_video") {
      // if(result.profileUserId.toString().isNotEmpty){
      Navigator.push(
          _context, MaterialPageRoute(builder: (context) => Tutorial_Videos()));
      // }
    } else if (notification_type.toString() == "exhibition") {
      // if(result.profileUserId.toString().isNotEmpty){
      Navigator.push(
          _context, MaterialPageRoute(builder: (context) => Exhibition()));
      // }
    } else if (notification_type.toString() == "quicknews") {
      // if(result.profileUserId.toString().isNotEmpty){
      Navigator.push(
          _context, MaterialPageRoute(builder: (context) => MainScreen(3)));
      // }
    }
  }

  Future initLocalNotification(context) async {
    const iOS = IOSInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const setting = InitializationSettings(android: android, iOS: iOS);
    await _localNotification.initialize(
      setting,
      /*onSelectNotification: (payload) {
        final message=RemoteMessage.fromMap(jsonDecode(payload!));
        handleMessage(message,context);
      },*/
    );
    final platform = _localNotification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidchannel);
  }

  @pragma('vm:entry-point')
  static Future<String> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    print("Debug::::::2");

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    var handleMessage;
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    constanst.notificationtype=initialMessage?.data['type'];
    constanst.notiuser=initialMessage?.data['user_id'];
    constanst.notipostid=initialMessage?.data['postId'];
    constanst.notypost_type=initialMessage?.data['post_type'];
    print("object11:::${constanst.notipostid} ");
    print("object11:::${constanst.notificationtype} ");
    print("object:::${initialMessage?.data['type']}");
    print("object:::${initialMessage?.data.toString()}");
    return  initialMessage!.data.toString();
  }

  static Future _handleMessage(RemoteMessage? message) async {
    print('_handleMessage:::::::${message!.data}');
    print('message.data:::::::${message!.data}');
    //print('message.data:::::::${message.data['menuId'] == '1'}');
    //_handleMessage(message)
    // navigatorKey.currentState?.push(MaterialPageRoute(
    //   builder: (context) => MainScreen(3),
    // ));
    return 3;
    /*Navigator.push(navigatorKey.currentState.context, MaterialPageRoute(
      builder: (context) => MainScreen(3),
    ));*/
    //  navigatorKey.currentState?.pushNamed('/MainScreen(3)');

    /* if (message.data['menuId'] == '1') {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => TimeTablePage(),
        ),
      );
    } else if (message.data['menuId'] == '2') {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => PendingAttendance(),
        ),
      );
    } else if (message.data['menuId'] == '3') {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => StaffAttendanceSummary(),
        ),
      );
    } else if (message.data['menuId'] == '4') {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => SearchStudentScreen(),
        ),
      );
    } else if (message.data['menuId'] == '5') {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => LeaveBalanceScreen(),
        ),
      );
    } else if (message.data['menuId'] == '6') {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => LeaveApprove(),
        ),
      );
    } else if (message.data['menuId'] == '7') {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => LoadAlterApprove(),
        ),
      );
    } else if (message.data['menuId'] == '8') {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => DailyDiaryScreen(),
        ),
      );
    } else {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
    }*/
  }
}