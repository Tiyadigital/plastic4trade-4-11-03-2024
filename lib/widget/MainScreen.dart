// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';
import 'package:Plastic4trade/screen/BussinessProfile.dart';
import 'package:Plastic4trade/screen/other_user_profile.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/model/GetNotificationcount.dart';
import 'package:Plastic4trade/screen/More.dart';
import 'package:Plastic4trade/screen/News.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_interface.dart';
import '../api/firebase_api.dart';
import '../screen/Blog.dart';
import '../screen/BuyerPost.dart';
import '../screen/Buyer_sell_detail.dart';
import '../screen/Exhibition.dart';
import '../screen/Follower_Following.dart';
import '../screen/HomePage.dart';
import '../screen/Liveprice.dart';
import '../screen/SalePost.dart';
import '../screen/Tutorial_Videos.dart';
import '../screen/Videos.dart';
import 'HomeAppbar.dart';
import 'bottombar.dart';
import 'dart:ui';
import '../utill/constant.dart';

class MainScreen extends StatefulWidget {
  int select_idx;

  MainScreen(this.select_idx, {Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String title = 'Home';
  bool load = false;
  DateTime? currentBackPressTime;
  String notificationMessge = 'Notification Waiting ';
  List<Widget> pagelist = const  <Widget>[
    HomePage(),
    SalePost(),
    BuyerPost(),
    News(),
    more()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checknetowork();
  }

  @override
  Widget build(BuildContext context) {
    return init(context);
  }

  Widget init(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 218, 218),
      appBar: CustomeApp(title),
      body: pagelist[widget.select_idx],
      bottomNavigationBar: BottomMenu(
        selectedIndex: widget.select_idx,
        onClicked: onClicked,
      ),
    );
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');

    } else {
      get_notification();

      var result = await FirebaseApi.setupInteractedMessage();

      constanst.isFromNotification = true;
      if(constanst.notificationtype=="profile like"){

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => other_user_profile(int.parse(constanst.notiuser.toString()),
            )));
      }else if(constanst.notificationtype=="follower_profile_like"){

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    other_user_profile(int.parse(constanst.notiuser.toString()))));
      }else if(constanst.notificationtype=="profile_review"){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
              bussinessprofile()));

      }else if(constanst.notificationtype=="Business profile dislike"){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    other_user_profile(int.parse(constanst.notiuser.toString()))));
      }else if(constanst.notificationtype=="post like"){

        if ( constanst.notypost_type.toString() == "SalePost") {
          if (constanst.notipostid.toString().isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Buyer_sell_detail(
                            post_type: 'SalePost', prod_id: constanst.notipostid)));

          }
        } else  {
          if ( constanst.notypost_type.toString() == "BuyPost") {
            if (constanst.notipostid
                .toString()
                .isNotEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Buyer_sell_detail(
                              post_type: 'BuyPost', prod_id: constanst.notipostid)));
            }
          }
        }


      }else if(constanst.notificationtype=="unfollowuser") {

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    follower()));
      } else if(constanst.notificationtype=="followuser") {

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const follower()));
      }else if(constanst.notificationtype=="profile_review") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    other_user_profile(int.parse(constanst.notiuser.toString()))));
      }else if(constanst.notificationtype=="live_price") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const LivepriceScreen()));
      }else if(constanst.notificationtype=="quick_news_notification") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MainScreen(3)));
      }else if(constanst.notificationtype=="news") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MainScreen(3)));
      }else if(constanst.notificationtype=="blog") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const Blog()));
      }else if(constanst.notificationtype=="video") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const Videos()));
      }else if(constanst.notificationtype=="banner") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MainScreen(0)));
      }else if(constanst.notificationtype=="tutorial_video") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const Tutorial_Videos()));
      }else if(constanst.notificationtype=="exhibition") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const Exhibition()));
      }else if(constanst.notificationtype=="quicknews") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MainScreen(3)));
      }


    }
  }

  void onClicked(int index) {
    setState(() {
      widget.select_idx = index;
      if (widget.select_idx == 0) {
        title = 'Home';
      } else if (widget.select_idx == 1) {
        title = 'Saller';
      } else if (widget.select_idx == 2) {
        title = 'Buyer';
      } else if (widget.select_idx == 3) {
        title = 'News';
      } else if (widget.select_idx == 4) {
        title = 'More';
      }
    });
  }

  Future<bool> _onbackpress(BuildContext context) async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Show a toast or snackbar message to inform the user to tap again to exit
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tap again to exit')),
      );
      return Future.value(false);
    }
    SystemNavigator.pop(); // Close the app
    return Future.value(true);
  }

  Future<void> get_notification() async {
    GetNotificationcount getsimmilar = GetNotificationcount();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await count_notify(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());

    var jsonarray;
    if (res['status'] == 1) {
      getsimmilar = GetNotificationcount.fromJson(res);

      constanst.notification_count = res['NotificationCount'];
      setState(() {});
      if (mounted) {
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;

  }
}
