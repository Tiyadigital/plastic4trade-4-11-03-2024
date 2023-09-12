import 'dart:io';
import 'package:Plastic4trade/screen/BussinessProfile.dart';
import 'package:Plastic4trade/screen/Bussinessinfo.dart';
import 'package:Plastic4trade/screen/other_user_profile.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/model/GetNotificationcount.dart';
import 'package:Plastic4trade/screen/More.dart';
import 'package:Plastic4trade/screen/News.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_interface.dart';
import '../api/firebase_api.dart';
import '../main.dart';
import '../model/GetNotification.dart';
import '../screen/Blog.dart';
import '../screen/BuyerPost.dart';
import '../screen/Buyer_sell_detail.dart';
import '../screen/Exhibition.dart';
import '../screen/Follower_Following.dart';
import '../screen/HomePage.dart';
import '../screen/Liveprice.dart';
import '../screen/LoginScreen.dart';
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
  //int selectedIndex = 0;
  String title = 'Home';
  bool load = false;
  DateTime? currentBackPressTime;
  String notificationMessge = 'Notification Waiting ';
  List<Widget> pagelist = <Widget>[
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

  /* Future<void> init_noti(BuildContext context) async {
    await FirebaseApi().initNOtification(context);

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsios =
    IOSInitializationSettings(
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

          Fluttertoast.showToast(msg: 'rfsrsfrfr');
          print('jfjjfrfjfjkfg');
          print(payload);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Bussinessinfo()));
        }
      },
    );
    await FirebaseApi().initLocalNotification(context);

    // APIs.getSelfInfo();
  }*/
  Widget init(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 218, 218),
      appBar: CustomeApp(title),
      body: /*load==true?*/ pagelist[widget.select_idx],
      /*:const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 0, 91, 148),)),*/
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
      //isprofile=true;
    } else {
      get_notification();
      print("Debug::::::1");
      print("select_idx::::${widget.select_idx}");
      var result = await FirebaseApi.setupInteractedMessage();

      print("result:::${result}");
      /*  Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));*/

      constanst.isFromNotification = true;
      if(constanst.notificationtype=="profile like"){
        print("jsdsd");
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
        print("hfuihdgiufhrghdriugiorh");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    follower()));
      } else if(constanst.notificationtype=="followuser") {
        print("hfuihdgiufhrghdriugiorh");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    follower()));
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
                    LivepriceScreen()));
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
                    Blog()));
      }else if(constanst.notificationtype=="video") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Videos()));
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
                    Tutorial_Videos()));
      }else if(constanst.notificationtype=="exhibition") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Exhibition()));
      }else if(constanst.notificationtype=="quicknews") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MainScreen(3)));
      }
      print("MORE_NOTIFICATION_VALUE:::${constanst.isFromNotification}");

      // final BottomNavigationBar navigationBar =
      //     bottomNavKey.currentWidget as BottomNavigationBar;
      // navigationBar.onTap!(4);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => MainScreen(3),
      //     ));



      // get_data();
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

/*  Future<bool> _onbackpress(BuildContext context) async {
    bool exitapp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Are you want exit App ?'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      exit(0);
                    },
                    child: const Text('Yes')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No')),
              ]);
        });
    return exitapp ?? false;
  }*/
  Future<void> get_notification() async {
    GetNotificationcount getsimmilar = GetNotificationcount();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await count_notify(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());
    // constanst.image_url=_pref.getString('userImage').toString();
    // print('fdffrgr ${constanst.image_url}');
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = GetNotificationcount.fromJson(res);

      constanst.notification_count = res['NotificationCount'];
      setState(() {});
      //load=true;

      //
      /*for (var data in jsonarray) {

          getnotifi.Result record = getnotifi.Result(
              notificationId: data['notificationId'],
              blogId: data['blog_id'],
              newsId:data['news_id'] ,
              type: data['type'],
              advertiseId: data['advertise_id'],
              buypostId: data['buypost_id'],
              description: data['description'],
              followId: data['follow_id'],
              fromUserId: data['from_user_id'],
              heading: data['heading'],
              isFollow: data['is_follow'],
              livepriceId: data['liveprice_id'],
              notificationType: data['notification_type'],
              otherImage: data['other_image'],
              postImage: data['post_image'],
              profilepic: data['profilepic'],
              salepostId: data['salepost_id'],
              time:data['time'],
              name: data['name'],
              isRead: data['is_read']






          );

          getnotifydata.add(record);
          //loadmore = true;
        }
        isload=true;
        print(getnotifydata);*/
      if (mounted) {
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
    setState(() {});
  }
}
