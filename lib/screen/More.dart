// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:io' show Platform;
import 'dart:io';

import 'package:Plastic4trade/screen/Aboutplastic.dart';
import 'package:Plastic4trade/screen/Adwithus.dart';
import 'package:Plastic4trade/screen/Blog.dart';
import 'package:Plastic4trade/screen/Bussinessinfo.dart';
import 'package:Plastic4trade/screen/ContactUs.dart';
import 'package:Plastic4trade/screen/LoginScreen.dart';
import 'package:Plastic4trade/screen/ManageBuyPost.dart';
import 'package:Plastic4trade/screen/Premium.dart';
import 'package:Plastic4trade/screen/Videos.dart';
import 'package:Plastic4trade/screen/updateCategoryScreen.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api_interface.dart';
import '../utill/constant.dart';
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
import 'Tutorial_Videos.dart';

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
  Choice(title: 'Manage Sell Posts', icon: 'assets/shopping-cart.png', id: '2'),
  Choice(title: 'Interests', icon: 'assets/bag-tick.png', id: '3'),
  Choice(title: 'Manage Buy Posts', icon: 'assets/bag-2.png', id: '4'),
  Choice(title: 'Favourites', icon: 'assets/heart-circle.png', id: '5'),
  Choice(
      title: 'Followers/Followings', icon: 'assets/profile-2user.png', id: '6'),
  Choice(title: 'Blog', icon: 'assets/document-text.png', id: '7'),
  Choice(title: 'News', icon: 'assets/clipboard-text.png', id: '8'),
  Choice(title: 'Videos', icon: 'assets/video.png', id: '9'),
  Choice(title: 'Exhibition', icon: 'assets/box.png', id: '10'),
  Choice(title: 'Directory', icon: 'assets/directbox-default.png', id: '11'),
  Choice(title: 'Tutorial Video', icon: 'assets/play-circle.png', id: '12'),
  Choice(title: 'Exhibitor', icon: 'assets/star.png', id: '13'),
  Choice(title: 'Premium Member', icon: 'assets/premium_mem.png', id: '14'),
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
    getProfiless();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (constanst.isFromNotification) {
      constanst.isFromNotification = false;
      redirectToBussinessProfileScreen(context);
    }
    return init();
  }

  Widget init() {
    return WillPopScope(
      onWillPop: () => _onbackpress(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFDADADA),
        body: isload == true
            ? SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 10.0, 5.0, 5.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5.0),
                                    height: 90,
                                    child: GestureDetector(
                                      onTap: () {
                                        constanst.redirectpage = "edit_profile";

                                        if (constanst.appopencount ==
                                            constanst.appopencount1) {
                                          if (!constanst.isprofile) {
                                            redirectToBussinessProfileScreen(
                                                context);
                                          } else if (constanst.isprofile) {
                                            showInformationDialog(context);
                                          }
                                        } else {
                                          if (constanst.isprofile) {
                                            showInformationDialog(context);
                                          } else {
                                            redirectToBussinessProfileScreen(
                                                context);
                                          }
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          image_url != null
                                              ? Container(
                                                  width: 70.0,
                                                  height: 70.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff7c94b6),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                        image_url.toString(),
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(50.0),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  width: 70.0,
                                                  height: 70.0,
                                                  decoration: BoxDecoration(
                                                    /*color: const Color(
                                                                0xff7c94b6),*/
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                        'assets/plastic4trade logo final 1 (2).png'
                                                            .toString(),
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(50.0),
                                                    ),
                                                  ),
                                                ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              // or CrossAxisAlignment.center
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  username!,
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'assets/fonts/Metropolis-Black.otf', // Fix the typo in 'fonts'
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0),
                                                  child: business_name != null
                                                      ? Text(
                                                          business_name!,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black,
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
                                    ),
                                  )
                                ],
                              ),
                            ),
                            category(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ContactUs(),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.fromLTRB(
                                    5.0, 10.0, 8.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ContactUs(),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              height: 55,
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Align(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20.0),
                                                        child: Text(
                                                          'Contact Us/Feedback',
                                                          style: TextStyle(
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets/fonst/Metropolis-SemiBold.otf'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ContactUs(),
                                                  ),
                                                );
                                              },
                                              icon: Image.asset(
                                                  'assets/forward.png'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Adwithus(),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.fromLTRB(
                                    5.0, 10.0, 8.0, 0.0),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
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
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20.0),
                                                          child: Text(
                                                            'Advertise with us',
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'assets/fonst/Metropolis-SemiBold.otf'),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Adwithus(),
                                                    ),
                                                  );
                                                },
                                                icon: Image.asset(
                                                    'assets/forward.png'),
                                              )
                                            ]),
                                      )
                                    ]),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const aboutplastic(),
                                    // builder: (context) => const AppTermsCondition(),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.fromLTRB(
                                    5.0, 5.0, 8.0, 0.0),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
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
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20.0),
                                                            child: Text(
                                                              'About Plastic4trade',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'assets/fonst/Metropolis-SemiBold.otf'),
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const aboutplastic(),
                                                    ),
                                                  );
                                                },
                                                icon: Image.asset(
                                                    'assets/forward.png'),
                                              )
                                            ]),
                                      )
                                    ]),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const Notificationsetting(),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.fromLTRB(
                                    5.0, 5.0, 8.0, 0.0),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
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
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20.0),
                                                            child: Text(
                                                              'Notification Settings',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'assets/fonst/Metropolis-SemiBold.otf'),
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Notificationsetting(),
                                                    ),
                                                  );
                                                },
                                                icon: Image.asset(
                                                    'assets/forward.png'),
                                              )
                                            ]),
                                      )
                                    ]),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showlogoutDialog(context);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.fromLTRB(
                                    5.0, 5.0, 8.0, 0.0),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
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
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20.0),
                                                            child: Text(
                                                              'Logout',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'assets/fonst/Metropolis-SemiBold.otf'),
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  showlogoutDialog(context);
                                                },
                                                icon: Image.asset(
                                                    'assets/forward.png'),
                                              )
                                            ]),
                                      )
                                    ]),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Center(
                                child: Text(
                                  'Follow Plastic4trade',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,
                                      fontFamily:
                                          'assets/fonst/Metropolis-Black.otf',
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  const EdgeInsets.fromLTRB(5.0, 5.0, 8.0, 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Image.asset('assets/whatsapp.png'),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Image.asset('assets/facebook.png'),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Image.asset('assets/instagram.png'),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Image.asset('assets/linkdin.png'),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Image.asset('assets/youtube.png'),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Image.asset('assets/Telegram.png'),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Image.asset('assets/Twitter.png'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  const EdgeInsets.fromLTRB(5.0, 5.0, 8.0, 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'App Version $version  -1.4 ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf',
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
                                    child: const Text(
                                      'Check Latest Update',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              'assets/fonst/Metropolis-Black.otf',
                                          fontSize: 13),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Platform.isAndroid
                    ? const CircularProgressIndicator(
                        value: null,
                        strokeWidth: 2.0,
                        color: Color.fromARGB(255, 0, 91, 148),
                      )
                    : Platform.isIOS
                        ? const CupertinoActivityIndicator(
                            color: Color.fromARGB(255, 0, 91, 148),
                            radius: 20,
                            animating: true,
                          )
                        : Container(),
              ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0),
              ),
              color: Colors.white),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Exhibitor(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Exhibitor',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf',
                        fontSize: 10),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const premum_member(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Premium Member',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf',
                        fontSize: 10),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Directory1(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Directory',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf',
                        fontSize: 10),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: const Text(
                  'App Share ',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf',
                      fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void redirectToBussinessProfileScreen(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => const bussinessprofile(),
      ),
    );
  }

  Future<bool> _onbackpress(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(0),
      ),
    );
    return Future.value(true);
  }

  void getPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
    packageName = packageInfo!.packageName;
    version = packageInfo!.version;
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
    final String url =
        'https://play.google.com/store/apps/details?id=$packageName';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchAppStore() async {
    const String appStoreUrl = 'https://itunes.apple.com/us/app/app_id';
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
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            'Log Out',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'assets/fonst/Metropolis-Black.otf')
                .copyWith(fontSize: 23),
          ),
          const Divider(color: Colors.black26),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Are You Sure Want To \n Log Out?',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'assets/fonst/Metropolis-Black.otf')
                .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                height: 55,
                margin: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color.fromARGB(255, 0, 91, 148),
                  ),
                  borderRadius: BorderRadius.circular(50.0),
                  // color: Color.fromARGB(255, 0, 91, 148)
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); //
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 0, 91, 148),
                        fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                height: 55,
                margin: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(50.0),
                  color: const Color.fromARGB(255, 0, 91, 148),
                ),
                child: TextButton(
                  onPressed: () async {
                    clear();
                    if (Platform.isAndroid) {
                      const androidId = AndroidId();
                      constanst.android_device_id = (await androidId.getId())!;

                      logout_android_device(
                          context, constanst.android_device_id);
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      await preferences.clear();
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    } else if (Platform.isIOS) {
                      final iosinfo = await deviceInfo.iosInfo;
                      constanst.devicename = iosinfo.name;
                      constanst.ios_device_id = iosinfo.identifierForVendor!;
                      logout_android_device(context, constanst.ios_device_id);
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      await preferences.clear();
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  logout_android_device(context, deviceid) async {
    var res = await android_logout(deviceid);

    if (res['status'] == 1) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();
    } else {
      Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: res['message']);
    }
  }

  Widget category() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 0),
      child: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: MediaQuery.of(context).size.aspectRatio * 4.0,
                mainAxisSpacing: 8.0,
                crossAxisCount: 2,
              ),
              physics: const NeverScrollableScrollPhysics(),
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
                            ),
                          );
                        } else if (constanst.isprofile) {
                          showInformationDialog(context);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Bussinessinfo(),
                            ),
                          );
                        }
                      } else {
                        if (constanst.isprofile) {
                          showInformationDialog(context);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Bussinessinfo(),
                            ),
                          );
                        }
                      }
                    } else if (record.id == '2') {
                      constanst.redirectpage = "Manage_Sell_Posts";

                      if (constanst.appopencount == constanst.appopencount1) {
                        if (!constanst.isgrade &&
                            !constanst.istype &&
                            !constanst.iscategory &&
                            !constanst.isprofile) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const managesellpost(
                                  Title: "Manage_Sell_Posts"),
                            ),
                          );
                        } else if (constanst.isprofile) {
                          showInformationDialog(context);
                        } else if (constanst.iscategory) {
                          categoryDialog(context);
                        } else if (constanst.isgrade) {
                          categoryDialog(context);
                        } else if (constanst.istype) {
                          categoryDialog(context);
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const managesellpost(
                                Title: "Manage_Sell_Posts"),
                          ),
                        );
                      }
                    } else if (record.id == '3') {
                      constanst.redirectpage = "update_category";
                      if (constanst.appopencount == constanst.appopencount1) {
                        if (!constanst.isgrade &&
                            !constanst.istype &&
                            !constanst.iscategory &&
                            !constanst.isprofile) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const UpdateCategoryScreen(),
                            ),
                          );
                        } else if (constanst.isprofile) {
                          showInformationDialog(context);
                        } else if (constanst.iscategory) {
                          categoryDialog(context);
                        } else if (constanst.isgrade) {
                          categoryDialog(context);
                        } else if (constanst.istype) {
                          categoryDialog(context);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const UpdateCategoryScreen(),
                            ),
                          );
                        }
                      } else {
                        if (constanst.isprofile) {
                          showInformationDialog(context);
                        } else if (constanst.iscategory) {
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
                                builder: (context) =>
                                    const UpdateCategoryScreen(),
                              ),
                            );
                          }
                        }
                      }
                    } else if (record.id == '4') {
                      constanst.redirectpage = "Manage_Buy_Posts";
                      if (constanst.appopencount == constanst.appopencount1) {
                        if (!constanst.isgrade &&
                            !constanst.istype &&
                            !constanst.iscategory &&
                            !constanst.isprofile) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const managebuypost(
                                  Title: "Manage_Buy_Posts"),
                            ),
                          );
                        } else if (constanst.isprofile) {
                          showInformationDialog(context);
                        } else if (constanst.iscategory) {
                          categoryDialog(context);
                        } else if (constanst.isgrade) {
                          categoryDialog(context);
                        } else if (constanst.istype) {
                          categoryDialog(context);
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const managebuypost(Title: "Manage_Buy_Posts"),
                          ),
                        );
                      }
                    } else if (record.id == '5') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Favourite(),
                        ),
                      );
                    } else if (record.id == '6') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const follower(
                            initialIndex: 1,
                          ),
                        ),
                      );
                    } else if (record.id == '7') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Blog(),
                        ),
                      );
                    } else if (record.id == '8') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(3),
                        ),
                      );
                    } else if (record.id == '9') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Videos(),
                        ),
                      );
                    } else if (record.id == '12') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Tutorial_Videos(),
                        ),
                      );
                    } else if (record.id == '11') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Directory1(),
                        ),
                      );
                    } else if (record.id == '10') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Exhibition(),
                        ),
                      );
                    } else if (record.id == '13') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Exhibitor(),
                        ),
                      );
                    } else if (record.id == '14') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const premum_member(),
                        ),
                      );
                    } else if (record.id == '16') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Premiun(),
                        ),
                      );
                    }
                  }),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 15.0, 0.0, 0.0),
                              child: Image(
                                image: AssetImage(record.icon),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 0.0),
                            child: Text(
                              record.title,
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-SemiBold.otf'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  getProfiless() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getbussinessprofile(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );

    if (res['status'] == 1) {
      username = res['user']['username'];
      if (res['profile'] != null) {
        business_name = res['profile']['business_name'];

        image_url = res['user']['image_url'];
        pref.setString('userImage', image_url!).toString();
      }
      isload = true;
    } else {
      Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: res['message']);
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
