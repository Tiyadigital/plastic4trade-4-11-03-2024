// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names, use_build_context_synchronously, empty_catches

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:Plastic4trade/screen/Follower_Following.dart';
import 'package:Plastic4trade/utill/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../screen/Blog.dart';
import '../screen/BussinessProfile.dart';
import '../screen/Buyer_sell_detail.dart';
import '../screen/Exhibition.dart';
import '../screen/Liveprice.dart';
import '../screen/Tutorial_Videos.dart';
import '../screen/Videos.dart';
import '../screen/other_user_profile.dart';
import '../widget/MainScreen.dart';

class FirebaseApi {
  final _androidchannel = const AndroidNotificationChannel(
      'high_impotance_channel', 'High Importance Notification',
      description: 'This channel is used for importance notification',
      importance: Importance.defaultImportance);
  final _localNotification = FlutterLocalNotificationsPlugin();
  late BuildContext _context;

  Future<void> handleBackgroundMessage(RemoteMessage message) async {

  }

  void handleMessage(RemoteMessage message, context) {
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
    } else {}

    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        _context = context;
        notification_redirect(value.data, _context);
      }
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      Fluttertoast.showToast(
          timeInSecForIosWeb: 2,
          msg: 'notification.title${notification!.title.toString()}',
      );
      if (notification == null) return;
      Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: 'i m notification');

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
        payload: jsonEncode(message.toMap()),
      );
      AndroidNotification? notification1 = message.notification?.android;
      if (notification1 != null) {}
    });
  }

  Future<void> initNOtification(BuildContext context) async {
    if (Platform.isAndroid) {
      await Firebase.initializeApp();
      final firebaseMessaging = FirebaseMessaging.instance;
      await firebaseMessaging.requestPermission();
      final FCMToken = await firebaseMessaging
          .getToken(
              vapidKey:
                  "BC4eLOdjJWopUE-NEu_WCFLlByPe5-K5_AljnUINqx4QL7RmA3W5lC-__7WDfEWPJF0nVk05xpD3d4JjdrGnfVA")
          .then((value) => value);
      constanst.fcm_token = FCMToken.toString();
    } else if (Platform.isIOS) {
      await Firebase.initializeApp();
      final firebaseMessaging0 = FirebaseMessaging.instance;
      await firebaseMessaging0.requestPermission();
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      final APNSToken =
          await firebaseMessaging0.getToken().then((value) => value);
      constanst.APNSToken = APNSToken.toString();
    }
    initPushNotification(context);
    initLocalNotification(context);
  }

  show_notification(String? title, String? body, Map<String, dynamic> data) {}

  notification_redirect(Map<String, dynamic> data, BuildContext context) async {
    String notification_type = data['type'];
    String post_type = data['post_type'];
    String user_id = data['user_id'];
    String post_id = data['postId'];

    if (notification_type == "profile like") {
      if (user_id.toString().isNotEmpty) {
        try {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      other_user_profile(int.parse(user_id.toString()))));
        } catch (e) {}
      } else {}
    } else if (notification_type == "follower_profile_like") {
      if (user_id.toString().isNotEmpty) {
        await Navigator.push(
            _context,
            MaterialPageRoute(
                builder: (context) =>
                    other_user_profile(int.parse(user_id.toString()))));
      }
    } else if (notification_type == "profile_review") {
      if (user_id.toString().isNotEmpty) {
        await Navigator.push(_context,
            MaterialPageRoute(builder: (context) => const bussinessprofile()));
      }
    } else if (notification_type.toString() == "Business profile dislike") {
      if (user_id.toString().isNotEmpty) {
        await Navigator.push(
            _context,
            MaterialPageRoute(
                builder: (context) =>
                    other_user_profile(int.parse(user_id.toString()))));
      }
    } else if (notification_type.toString() == "post like") {
      if (post_type.toString() == "SalePost") {
        if (post_id.toString().isNotEmpty) {
          await Navigator.push(
              _context,
              MaterialPageRoute(
                  builder: (context) => Buyer_sell_detail(
                      post_type: 'SalePost', prod_id: post_id)));
        }
      } else {
        if (post_type.toString() == "BuyPost") {
          if (post_id.toString().isNotEmpty) {
            await Navigator.push(
                _context,
                MaterialPageRoute(
                    builder: (context) => Buyer_sell_detail(
                        post_type: 'BuyPost', prod_id: post_id)));
          }
        }
      }
    } else if (notification_type.toString() == "followuser") {
      if (user_id.toString().isNotEmpty) {
        await Navigator.push(
            _context,
            MaterialPageRoute(
                builder: (context) => const follower(
                      initialIndex: 0,
                    )));
      }
    } else if (notification_type.toString() == "unfollowuser") {
      if (user_id.toString().isNotEmpty) {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const follower(
                      initialIndex: 0,
                    )));
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
      Navigator.push(_context,
          MaterialPageRoute(builder: (context) => const LivepriceScreen()));
    } else if (notification_type.toString() == "quick_news_notification") {
      Navigator.push(
          _context, MaterialPageRoute(builder: (context) => MainScreen(3)));
    } else if (notification_type.toString() == "news") {
      Navigator.push(
          _context, MaterialPageRoute(builder: (context) => MainScreen(3)));
    } else if (notification_type.toString() == "blog") {
      Navigator.push(
          _context, MaterialPageRoute(builder: (context) => const Blog()));
    } else if (notification_type.toString() == "video") {
      Navigator.push(
          _context, MaterialPageRoute(builder: (context) => const Videos()));
    } else if (notification_type.toString() == "banner") {
      Navigator.push(
          _context, MaterialPageRoute(builder: (context) => MainScreen(0)));
    } else if (notification_type.toString() == "tutorial_video") {
      Navigator.push(_context,
          MaterialPageRoute(builder: (context) => const Tutorial_Videos()));
    } else if (notification_type.toString() == "exhibition") {
      Navigator.push(_context,
          MaterialPageRoute(builder: (context) => const Exhibition()));
    } else if (notification_type.toString() == "quicknews") {
      Navigator.push(
          _context, MaterialPageRoute(builder: (context) => MainScreen(3)));
    }
  }

  Future initLocalNotification(context) async {
    const iOS = IOSInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const setting = InitializationSettings(android: android, iOS: iOS);
    await _localNotification.initialize(
      setting,
    );
    final platform = _localNotification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidchannel);
  }

  @pragma('vm:entry-point')
  static Future<String> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    constanst.notificationtype = initialMessage?.data['type'];
    constanst.notiuser = initialMessage?.data['user_id'];
    constanst.notipostid = initialMessage?.data['postId'];
    constanst.notypost_type = initialMessage?.data['post_type'];
    return initialMessage!.data.toString();
  }

  static Future _handleMessage(RemoteMessage? message) async {
    return 3;
  }
}
