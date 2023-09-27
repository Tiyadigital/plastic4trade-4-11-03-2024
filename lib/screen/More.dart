import 'dart:io';
import 'package:Plastic4trade/screen/Bussinessinfo.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utill/constant.dart';

import 'package:android_id/android_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:Plastic4trade/screen/Aboutplastic.dart';
import 'package:Plastic4trade/screen/Adwithus.dart';
import 'package:Plastic4trade/screen/Blog.dart';
import 'package:Plastic4trade/screen/CategoryScreen.dart';
import 'package:Plastic4trade/screen/ContactUs.dart';
import 'package:Plastic4trade/screen/HomePage.dart';
import 'package:Plastic4trade/screen/LoginScreen.dart';
import 'package:Plastic4trade/screen/ManageBuyPost.dart';
import 'package:Plastic4trade/screen/News.dart';
import 'package:Plastic4trade/screen/Premium.dart';
import 'package:Plastic4trade/screen/Videos.dart';
import 'package:Plastic4trade/screen/updateCategoryScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

import '../api/api_interface.dart';
import '../main.dart';
import '../model/Login.dart';
import '../model/common.dart';
import '../widget/HomeAppbar.dart';
import '../widget/MainScreen.dart';
import 'BussinessProfile.dart';
import 'Directory.dart';
import 'Exhibition.dart';
import 'ExhibitorScreen.dart';
import 'Favourite.dart';
import 'Follower_Following.dart';
import 'ManageSellPost.dart';
import 'NotificationSettingsScreen.dart';
import 'Premum_member.dart';
import 'Register2.dart';
import 'Tutorial_Videos.dart';
import 'dart:io' show Platform;
import 'dart:io' show Platform;

class more extends StatefulWidget {
  const more({Key? key}) : super(key: key);

  @override
  State<more> createState() => _moreState();
}

class Choice {
  const Choice({required this.title, required this.icon, required this.id});
  final String title;
  final String icon;
  final String id;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'Business & Profile ', icon: 'assets/shop.png', id: '1'),
   Choice(
      title: 'Manage Sell Posts', icon: 'assets/shopping-cart.png', id: '2'),
  Choice(title: 'Interests', icon: 'assets/bag-tick.png', id: '3'),
   Choice(title: 'Manage Buy Posts', icon: 'assets/bag-2.png', id: '4'),
   Choice(title: 'Favourites', icon: 'assets/heart-circle.png', id: '5'),
   Choice(
      title: 'Followers/Followings', icon: 'assets/profile-2user.png', id: '6'),
   Choice(title: 'Blog', icon: 'assets/document-text.png', id: '7'),
   Choice(title: 'News', icon: 'assets/clipboard-text.png', id: '8'),
   Choice(title: 'Videos', icon: 'assets/video.png', id: '9'),
   Choice(title: 'Exhibition', icon: 'assets/box.png', id: '10'),
   Choice(
      title: 'Directory', icon: 'assets/directbox-default.png', id: '11'),
   Choice(
      title: 'Tutorial Video', icon: 'assets/play-circle.png', id: '12'),
   Choice(title: 'Exhibitor', icon: 'assets/star.png', id: '13'),
   Choice(
      title: 'Premium Member', icon: 'assets/premium_mem.png', id: '14'),
   Choice(title: 'App Share', icon: 'assets/send-2.png', id: '15'),
   Choice(title: 'Premium Plan', icon: 'assets/award.png', id: '16'),
];

class _moreState extends State<more> {
  String? packageName;
  PackageInfo? packageInfo;
  String? version;
  String? username, business_name, image_url;
  bool? isload;
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  void initState() {
    // TODO: implement initState
    getPackage();
    //constanst.appopencount1=4;
    getProfiless();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('MORE_CLICKED::${constanst.isFromNotification}');
    if(constanst.isFromNotification){
      constanst.isFromNotification=false;
      redirectToBussinessProfileScreen(context);
    }
    return init();
  }

  Widget init() {
    return WillPopScope(
        onWillPop: () => _onbackpress(context),
        child: Scaffold(
          backgroundColor: Color(0xFFDADADA),
          body: isload == true
              ? SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.only(bottom: 3.0),
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 10.0, 5.0, 5.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Column(
                                        children: [
                                          Container(
                                              margin: EdgeInsets.all(5.0),
                                              height: 90,
                                              child: GestureDetector(
                                                onTap: () {
                                                  constanst.redirectpage =
                                                      "edit_profile";
                                                  /* constanst.productId=result.productId.toString();
                constanst.post_type=result.postType.toString();*/
                                                  //constanst.redirectpage="sale_buy";
                                                  print(constanst.appopencount);
                                                  print(
                                                      constanst.appopencount1);
                                                  print(constanst.isprofile);
                                                  print(constanst.iscategory);
                                                  if (constanst.appopencount ==
                                                      constanst.appopencount1) {
                                                    print(constanst.step);
                                                    if (
                                                        !constanst.isprofile) {
                                                      print(constanst.step);

                                                      redirectToBussinessProfileScreen(context);
                                                    } else if (constanst
                                                        .isprofile) {
                                                      showInformationDialog(
                                                          context);
                                                    } /*else if (constanst
                                                        .iscategory) {
                                                      //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'i m category');
                                                      categoryDialog(context);
                                                    } else if (constanst
                                                        .isgrade) {
                                                      categoryDialog(context);
                                                    } else if (constanst
                                                        .istype) {
                                                      categoryDialog(context);
                                                    } else if (constanst.step !=
                                                        11) {
                                                      addPostDialog(context);
                                                    }*/
                                                    /* else {
                   showInformationDialog(context);
                 }*/
                                                  } else {
                                                    if (constanst.isprofile) {
                                                      showInformationDialog(
                                                          context);
                                                    } else {
                                                      redirectToBussinessProfileScreen(context);
                                                    }
                                                  }/*eglse {
                                                    if (constanst.isprofile) {
                                                      showInformationDialog(
                                                          context);
                                                    } else if (constanst
                                                        .iscategory) {
                                                      //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'i m category');
                                                      categoryDialog(context);
                                                    } else if (constanst
                                                        .isgrade) {
                                                      categoryDialog(context);
                                                    } else if (constanst
                                                        .istype) {
                                                      categoryDialog(context);
                                                    } else if (constanst.step !=
                                                        11) {
                                                      addPostDialog(context);
                                                    } else if (!constanst
                                                            .isgrade &&
                                                        !constanst.istype &&
                                                        !constanst.iscategory &&
                                                        !constanst.isprofile &&
                                                        constanst.step == 11) {
                                                      print(constanst.step);

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                bussinessprofile(),
                                                          ));
                                                    }

                                                  }*/
                                                },
                                                child: Row(
                                                  children: [
                                                    image_url != null
                                                        ? Container(
                                                            width: 70.0,
                                                            height: 70.0,
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: const Color(
                                                                        0xff7c94b6),
                                                                    image:
                                                                        DecorationImage(
                                                                      image: NetworkImage(
                                                                          image_url
                                                                              .toString()),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(50.0))),
                                                          )
                                                        : Container(
                                                            width: 70.0,
                                                            height: 70.0,
                                                            decoration:
                                                                BoxDecoration(
                                                                    /*color: const Color(
                                                                0xff7c94b6),*/
                                                                    image:
                                                                        DecorationImage(
                                                                      image: AssetImage(
                                                                          'assets/plastic4trade logo final 1 (2).png'
                                                                              .toString()),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(50.0))),
                                                          ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 20.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start, // or CrossAxisAlignment.center
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            username!,
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets/fonts/Metropolis-Black.otf', // Fix the typo in 'fonts'
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 0.0),
                                                            child:
                                                                business_name !=
                                                                        null
                                                                    ? Text(
                                                                        business_name!,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16.0,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Colors.black,
                                                                          fontFamily:
                                                                              'assets/fonts/Metropolis-Black.otf', // Fix the typo in 'fonts'
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                    category(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ContactUs()));
                                      },
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.fromLTRB(
                                              5.0, 10.0, 8.0, 0.0),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Card(
                                                    elevation: 2,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ContactUs()));
                                                      },
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                                height: 55,
                                                                child: Center(
                                                                    child: Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: const [
                                                                      Align(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              EdgeInsets.only(left: 20.0),
                                                                          child: Text(
                                                                              'Contact Us/Feedback',
                                                                              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: 'assets\fonst\Metropolis-SemiBold.otf')),
                                                                        ),
                                                                      ),
                                                                    ]))),
                                                            IconButton(
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              ContactUs()));
                                                                },
                                                                icon: Image.asset(
                                                                    'assets/forward.png'))
                                                          ]),
                                                    ))
                                              ])),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Adwithus()));
                                      },
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.fromLTRB(
                                              5.0, 10.0, 8.0, 0.0),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Card(
                                                    elevation: 2,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                              height: 55,
                                                              child: Center(
                                                                  child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                    Align(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(left: 20.0),
                                                                        child: Text(
                                                                            'Advertise with us',
                                                                            style: TextStyle(
                                                                                fontSize: 14.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.black,
                                                                                fontFamily: 'assets\fonst\Metropolis-SemiBold.otf')),
                                                                      ),
                                                                    ),
                                                                  ]))),
                                                          IconButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Adwithus()));
                                                              },
                                                              icon: Image.asset(
                                                                  'assets/forward.png'))
                                                        ]))
                                              ])),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    aboutplastic()));
                                      },
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.fromLTRB(
                                              5.0, 5.0, 8.0, 0.0),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Card(
                                                    elevation: 2,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                              height: 55,
                                                              child: Center(
                                                                  child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                    Align(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(left: 20.0),
                                                                        child: Text(
                                                                            'About Plastic4trade',
                                                                            style: TextStyle(
                                                                                fontSize: 14.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.black,
                                                                                fontFamily: 'assets\fonst\Metropolis-SemiBold.otf')),
                                                                      ),
                                                                    ),
                                                                  ]))),
                                                          IconButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                aboutplastic()));
                                                              },
                                                              icon: Image.asset(
                                                                  'assets/forward.png'))
                                                        ]))
                                              ])),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Notificationsetting()));
                                      },
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.fromLTRB(
                                              5.0, 5.0, 8.0, 0.0),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Card(
                                                    elevation: 2,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                              height: 55,
                                                              child: Center(
                                                                  child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                    Align(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(left: 20.0),
                                                                        child: Text(
                                                                            'Notification Settings',
                                                                            style: TextStyle(
                                                                                fontSize: 14.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.black,
                                                                                fontFamily: 'assets\fonst\Metropolis-SemiBold.otf')),
                                                                      ),
                                                                    ),
                                                                  ]))),
                                                          IconButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Notificationsetting()));
                                                              },
                                                              icon: Image.asset(
                                                                  'assets/forward.png'))
                                                        ]))
                                              ])),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showlogoutDialog(context);
                                      },
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.fromLTRB(
                                              5.0, 5.0, 8.0, 0.0),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Card(
                                                    elevation: 2,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                              height: 55,
                                                              child: Center(
                                                                  child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: const [
                                                                    Align(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(left: 20.0),
                                                                        child: Text(
                                                                            'Logout',
                                                                            style: TextStyle(
                                                                                fontSize: 14.0,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.black,
                                                                                fontFamily: 'assets\fonst\Metropolis-SemiBold.otf')),
                                                                      ),
                                                                    ),
                                                                  ]))),
                                                          IconButton(
                                                              onPressed: () {
                                                                showlogoutDialog(
                                                                    context);
                                                              },
                                                              icon: Image.asset(
                                                                  'assets/forward.png'))
                                                        ]))
                                              ])),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child:  Center(
                                          child: Text(
                                            'Follow Plastic4trade',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.italic,
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf',
                                                color: Colors.black),
                                          ),
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.fromLTRB(
                                            5.0, 5.0, 8.0, 0.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: Image.asset(
                                                    'assets/whatsapp.png')),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Image.asset(
                                                    'assets/facebook.png')),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Image.asset(
                                                    'assets/instagram.png')),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Image.asset(
                                                    'assets/linkdin.png')),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Image.asset(
                                                    'assets/youtube.png')),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Image.asset(
                                                    'assets/Telegram.png')),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Image.asset(
                                                    'assets/Twitter.png')),
                                          ],
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.fromLTRB(
                                            5.0, 5.0, 8.0, 0.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'App Version $version  -1.4 ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                      'assets\fonst\Metropolis-Black.otf',
                                                  color: Colors.black,
                                                  fontSize: 13),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (Platform.isAndroid) {
                                                  _openGooglePlayStore();
                                                } else if (Platform.isIOS) {
                                                  _launchAppStore();
                                                }
                                              },
                                              child: Text(
                                                'Check Latest Update',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf',
                                                    fontSize: 13),
                                              ),
                                            )
                                          ],
                                        )),

                                    //SizedBox(height: 10,),
                                  ])),
                        ],
                      )))
              :Center(
              child: Platform.isAndroid
                  ? CircularProgressIndicator(
                value: null,
                strokeWidth: 2.0,
                color: Color.fromARGB(255, 0, 91, 148),
              )
                  : Platform.isIOS
                  ? CupertinoActivityIndicator(
                color: Color.fromARGB(255, 0, 91, 148),
                radius: 20,
                animating: true,
              )
                  : Container()),
          bottomNavigationBar: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0)),
                  color: Colors.white),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Exhibitor()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Text('Exhibitor',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'assets\fonst\Metropolis-Black.otf',
                              fontSize: 10)),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => premum_member()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Text('Premium Member',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'assets\fonst\Metropolis-Black.otf',
                                fontSize: 10)),
                      )),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Directory1()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Text('Directory',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: 'assets\fonst\Metropolis-Black.otf',
                                fontSize: 10)),
                      )),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text('App Share ',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'assets\fonst\Metropolis-Black.otf',
                            fontSize: 10)),
                  ),
                ],
              )),
        ));
  }

  void redirectToBussinessProfileScreen(BuildContext context) {
    Navigator.of(context,rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) =>
              const bussinessprofile(),
        ));
  }

  Future<bool> _onbackpress(BuildContext context) async {
    /* DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Show a toast or snackbar message to inform the user to tap again to exit
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tap again to exit')),
      );
      return Future.value(false);
    }
    SystemNavigator.pop();*/ // Close the app
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainScreen(0)));
    return Future.value(true);
  }

  void getPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
    version = packageInfo!.version;
    String buildNumber = packageInfo!.buildNumber;
    print(
        "App Name : ${appName}, App Package Name: ${packageName},App Version: ${version}, App build Number: ${buildNumber}");
  }

  Future<void> showlogoutDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return logout(context);
      },
    );
  }

  void _openGooglePlayStore() async {
    // Replace 'com.example.your_app_package' with your app's package name
    // final String packageName = 'com.example.your_app_package';
    final String url =
        'https://play.google.com/store/apps/details?id=$packageName';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  void _launchAppStore() async {
    String app_id="6450507332";
    final String appStoreUrl = 'https://itunes.apple.com/us/app/app_id'; // Replace with your app's App Store URL
    if (await canLaunch(appStoreUrl)) {
      await launch(appStoreUrl);
    } else {
      throw 'Could not launch $appStoreUrl';
    }
  }

  Widget logout(context) {
    BuildContext dialogContext = context;
    return Dialog(
      alignment: Alignment.bottomCenter,
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Text('Log Out',
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'assets\fonst\Metropolis-Black.otf')
                  ?.copyWith(fontSize: 23)),
          Divider(color: Colors.black26),
          SizedBox(
            height: 20,
          ),
          Text('Are You Sure Want To \n Log Out?',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'assets\fonst\Metropolis-Black.otf')
                  ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                height: 55,
                margin: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Color.fromARGB(255, 0, 91, 148)),
                  borderRadius: BorderRadius.circular(50.0),
                  // color: Color.fromARGB(255, 0, 91, 148)
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); //
                  },
                  child: Text('No',
                      style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 0, 91, 148),
                          fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                height: 55,
                margin: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(50.0),
                    color: Color.fromARGB(255, 0, 91, 148)),
                child: TextButton(
                  onPressed: () async {
                    clear();
                    if (Platform.isAndroid) {
                      const androidId = AndroidId();
                      constanst.android_device_id = (await androidId.getId())!;

                      print('android device');
                      print(constanst.android_device_id);
                      logout_android_device(
                          context, constanst.android_device_id);
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      await preferences.clear();
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    } else if (Platform.isIOS) {
                      final iosinfo = await deviceInfo.iosInfo;
                      constanst.devicename = iosinfo.name!;
                      constanst.ios_device_id = iosinfo.identifierForVendor!;
                      print(constanst.ios_device_id);
                      logout_android_device(context, constanst.ios_device_id);
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      await preferences.clear();
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    }
                  },
                  child: Text('Yes',
                      style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  logout_android_device(context, deviceid) async {
    Login login = Login();

    /*_onLoading();*/
    var res = await android_logout(deviceid);

    if (res['status'] == 1) {
      login = Login.fromJson(res);
      //  Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: res['message']);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();
    } else {
      Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: res['message']);
    }
  }

  Widget category() {
    return Padding(
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 0),
        child: FutureBuilder(
            //future: load_category(),
            builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            //List<dynamic> users = snapshot.data as List<dynamic>;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // crossAxisCount: 2,
                // mainAxisSpacing: 5,
                // crossAxisSpacing: 5,
                // childAspectRatio: .90,
                childAspectRatio: MediaQuery.of(context).size.aspectRatio * 4.0,
                mainAxisSpacing: 8.0,
                crossAxisCount: 2,
              ),
              physics: NeverScrollableScrollPhysics(),
              itemCount: choices.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Choice record = choices[index];
                return GestureDetector(
                  onTap: (() {
                    if (record.id == '1') {
                      if (constanst.appopencount == constanst.appopencount1) {
                        if (!constanst.isgrade &&
                            !constanst.istype &&
                            !constanst.iscategory &&
                            !constanst.isprofile &&
                            constanst.step == 11) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Bussinessinfo(),
                              ));
                        } else if (constanst.isprofile) {
                          showInformationDialog(context);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Bussinessinfo(),
                              ));
                        }
                      } else {
                        if (constanst.isprofile) {
                          showInformationDialog(context);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Bussinessinfo(),
                              ));
                        }
                      }
                    }
                    else if (record.id == '2') {
                      constanst.redirectpage = "Manage_Sell_Posts";

                      if (constanst.appopencount == constanst.appopencount1) {
                        print(constanst.step);
                        if (!constanst.isgrade &&
                            !constanst.istype &&
                            !constanst.iscategory &&
                            !constanst.isprofile &&
                            constanst.step == 11) {
                          print(constanst.step);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const managesellpost(Title: "Manage_Sell_Posts"),
                              ));
                        } else if (constanst.isprofile) {
                          showInformationDialog(context);
                        } else if (constanst.iscategory) {
                          categoryDialog(context);
                        } else if (constanst.isgrade) {
                          categoryDialog(context);
                        } else if (constanst.istype) {
                          categoryDialog(context);
                        } else if (constanst.step != 11) {
                          addPostDialog(context);
                        }
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const managesellpost(Title: "Manage_Sell_Posts"),
                            ));
                      }
                    }

                    else if (record.id == '3') {


                      constanst.redirectpage = "update_category";
                      if (constanst.appopencount == constanst.appopencount1) {
                        print(constanst.step);
                        if (!constanst.isgrade &&
                            !constanst.istype &&
                            !constanst.iscategory &&
                            !constanst.isprofile &&
                            constanst.step == 11) {
                          print(constanst.step);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateCategoryScreen(),
                              ));
                        } else if (constanst.isprofile) {
                          showInformationDialog(context);
                        } else if (constanst.iscategory) {
                          //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'i m category');
                          categoryDialog(context);
                        } else if (constanst.isgrade) {
                          categoryDialog(context);
                        } else if (constanst.istype) {
                          categoryDialog(context);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateCategoryScreen(),
                              ));
                        } /*else if (constanst.step != 11) {
                          addPostDialog(context);
                        }*/

                        /* else {
                   showInformationDialog(context);
                 }*/
                      } else {
                        if (constanst.isprofile) {
                          showInformationDialog(context);
                        } else if (constanst.iscategory) {
                          //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'i m category');
                          categoryDialog(context);
                        } else if (constanst.isgrade) {
                          categoryDialog(context);
                        } else if (constanst.istype) {
                          categoryDialog(context);
                        } else {
                          if (constanst.isprofile) {
                            showInformationDialog(context);
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateCategoryScreen(),
                                ));
                          }
                        }
                        /*else if (constanst.step != 11) {
                          addPostDialog(context);
                        } else if (!constanst.isgrade &&
                            !constanst.istype &&
                            !constanst.iscategory &&
                            !constanst.isprofile &&
                            constanst.step == 11) {
                          print(constanst.step);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateCategoryScreen(),
                              ));
                        }*/
                      }
                    }
                    else if (record.id == '4') {

                      constanst.redirectpage = "Manage_Buy_Posts";
                      if (constanst.appopencount == constanst.appopencount1) {
                        print(constanst.step);
                        if (!constanst.isgrade &&
                            !constanst.istype &&
                            !constanst.iscategory &&
                            !constanst.isprofile &&
                            constanst.step == 11) {
                          print(constanst.step);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    managebuypost(Title: "Manage_Buy_Posts"),
                              ));
                        } else if (constanst.isprofile) {
                          showInformationDialog(context);
                        } else if (constanst.iscategory) {
                          //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'i m category');
                          categoryDialog(context);
                        } else if (constanst.isgrade) {
                          categoryDialog(context);
                        } else if (constanst.istype) {
                          categoryDialog(context);
                        } else if (constanst.step != 11) {
                          addPostDialog(context);
                        }
                        /* else {
                   showInformationDialog(context);
                 }*/
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  managebuypost(Title: "Manage_Buy_Posts"),
                            ));

                      }
                    } else if (record.id == '5') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Favourite()));
                    } else if (record.id == '6') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => follower()));
                    } else if (record.id == '7') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Blog()));
                    } else if (record.id == '8') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen(3)));
                    } else if (record.id == '9') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Videos()));
                    } else if (record.id == '12') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Tutorial_Videos()));
                    } else if (record.id == '11') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Directory1()));
                    } else if (record.id == '10') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Exhibition()));
                    } else if (record.id == '13') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Exhibitor()));
                    } else if (record.id == '14') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => premum_member()));
                    } else if (record.id == '16') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Premiun()));
                    }
                  }),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(children: [
                      SizedBox(
                          height: 50,
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 0.0),
                                  child: Image(
                                    image: AssetImage(record.icon ?? ''
                                        //data[index]['member_image'] ?? '',
                                        ),
                                  )))),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                            child: Text(record.title,
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontFamily:
                                        'assets\fonst\Metropolis-SemiBold.otf'))),
                      )
                    ]),
                  ),
                );
              },
            );
          }

          return CircularProgressIndicator();
        }));
  }

  getProfiless() async {
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getbussinessprofile(
      _pref.getString('user_id').toString(),
      _pref.getString('api_token').toString(),
    );

    print(res);
    if (res['status'] == 1) {
      username = res['user']['username'];
      if (res['profile'] != null) {
        business_name = res['profile']['business_name'];

        image_url = res['user']['image_url'];
        _pref.setString('userImage', image_url!).toString();
        //constanst.image_url = res['user']['image_url'];
        // print('Image Url $image_url');
      }
      print('Image Url $image_url');
      isload = true;
      /* for(int i=0;i<stringList.length;i++){
      findcartItem(stringList[i].toString());
    }*/

      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(0)));*/
    } else {
      Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: res['message']);
      // Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: res['message']);
    }

    setState(() {});
  }

  void clear() {
    constanst.usernm = "";
    constanst.Bussiness_nature = "";
    constanst.Bussiness_nature_name = "";
    constanst.select_Bussiness_nature = "";
    constanst.lstBussiness_nature = [];
    constanst.lstBussiness_nature_name = [];
    constanst.selectcategory_id = [];
    constanst.selectbusstype_id = [];
    constanst.selectgrade_id = [];
    constanst.selectcolor_id = [];
    constanst.selectcolor_name = [];
    constanst.select_color_id = "";
    constanst.select_color_name = "";
    constanst.select_cat_id = "";
    constanst.select_cat_name = "";
    constanst.select_cat_idx;
    constanst.select_type_id = "";
    constanst.select_type_idx;
    constanst.select_type_name = "";
    constanst.select_grade_id = "";
    constanst.select_grade_name.clear();
    constanst.select_grade_idx;
    constanst.Product_color = "";
    constanst.select_prodcolor_idx;
    constanst.select = "";
    constanst.api_token = "";
    constanst.fcm_token = "";
    constanst.android_device_id = "";
    constanst.APNSToken = "";
    constanst.devicename = "";
    constanst.ios_device_id = "";
    constanst.userid = "";
    constanst.step = 0;
    constanst.appopencount = 0;
    constanst.appopencount1 = 1;
    constanst.imagesList = [];
    constanst.notification_count = 0;
    constanst.post_type = "";
    constanst.productId = "";
    constanst.redirectpage = "";
    constanst.catdata = [];
    constanst.itemsCheck = [];
    constanst.category_itemsCheck = [];
    constanst.category_itemsCheck1 = [];
    constanst.bussiness_type_itemsCheck = [];
    constanst.Type_itemsCheck = [];
    constanst.Type_itemsCheck1 = [];
    constanst.Grade_itemsCheck = [];
    constanst.Grade_itemsCheck1 = [];
    constanst.Color_itemsCheck = [];

    constanst.select_categotyId = [];
    constanst.select_categotyType = [];
    constanst.select_inserestlocation = [];

    // get Busssiness
    constanst.btype_data = [];
    constanst.bt_data = null;

    // Category Type
    constanst.cat_type_data = [];
    constanst.cat_typedata = null;
    constanst.select_typeId = [];

    // Category Grade

    constanst.cat_grade_data = [];
    constanst.cat_gradedata = null;
    constanst.select_gradeId = [];

    constanst.select_state = [];
    constanst.select_country = [];

    // Get Bussiness Profile

    constanst.isprofile = false;
    constanst.iscategory = false;
    constanst.istype = false;
    constanst.isgrade = false;
    constanst.getmyprofile;
    constanst.getuserprofile = null;

    // Get Colors

    constanst.colordata = [];
    constanst.colorsitemsCheck = [];
    constanst.color_data = null;

    // Get Unit

    constanst.unitdata = [];
    constanst.unit_data = null;

    constanst.lat = "";
    constanst.log = "";
    constanst.location = "";
    constanst.date = "";
    constanst.image_url = "";
  }
}
