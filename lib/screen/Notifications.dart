/// ignore_for_file: camel_case_types, non_constant_identifier_names, unnecessary_null_comparison, unrelated_type_equality_checks, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:Plastic4trade/model/GetNotification.dart' as getnotifi;
import 'package:Plastic4trade/model/GetadminNotification.dart' as admin_getnotifi;
import 'package:Plastic4trade/screen/Blog.dart';
import 'package:Plastic4trade/screen/BussinessProfile.dart';
import 'package:Plastic4trade/screen/Buyer_sell_detail.dart';
import 'package:Plastic4trade/screen/Exhibition.dart';
import 'package:Plastic4trade/screen/Liveprice.dart';
import 'package:Plastic4trade/screen/NotificationSettingsScreen.dart';
import 'package:Plastic4trade/screen/Tutorial_Videos.dart';
import 'package:Plastic4trade/screen/Videos.dart';
import 'package:Plastic4trade/screen/other_user_profile.dart';
import 'package:Plastic4trade/widget/MainScreen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';

class notification extends StatefulWidget {
  const notification({Key? key}) : super(key: key);

  @override
  State<notification> createState() => _NotificationState();
}

class _NotificationState extends State<notification>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<admin_getnotifi.Result> getallnotifydata = [];
  List<getnotifi.Result>  getnotifydata = [];
  List<admin_getnotifi.Result> unread_getnotifydata = [];
  bool unread = false, isload = false, alldata = true, allNotification = true;
  String create_formattedDate = "", limit = "20";
  String read_status = "1";
  int offset = 0;
  int count = 0;
  int tabIndex = 0;
  final scrollercontroller = ScrollController();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    scrollercontroller.addListener(_scrollercontroller);
    checknetowork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Widget init() {
    return Scaffold(
      backgroundColor: const Color(0xFFDADADA),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: const Text(
          'Notifications',
          softWrap: false,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: 'Metropolis',
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const Notificationsetting()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/Setting.png',
                width: 31,
                height: 31,
              ),
            ),
          )
        ],
      ),
      body: isload == true
          ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10,top: 10,right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.8,
                      height: 45,
                      margin: const EdgeInsets.only(bottom: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                      ),
                      child: TabBar(
                        onTap: (value) {
                          if (value == 0){
                            allNotification = true;
                            unread = false;
                            alldata = false;
                          }
                          else if (value == 1) {
                            allNotification = false;
                            alldata = true;
                            unread = false;
                          } else if (value == 2) {
                            allNotification = false;
                            unread = true;
                            alldata = false;
                          }
                          setState(() {
                            tabIndex = value;
                          });
                        },
                        controller: _tabController,
                        // give the indicator a decoration (color and border radius)
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            25.0,
                          ),
                          color: const Color.fromARGB(255, 0, 91, 148),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black,
                        tabs: const [
                          // first tab [you can add an icon using the icon property]
                          Tab(
                            //text: 'Quick News',
                            child: Text(
                              'All',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Metropolis',
                              ),
                            ),
                          ),
                          Tab(
                            //text: 'Quick News',
                            child: Text(
                              'User',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Metropolis',
                              ),
                            ),
                          ),
                          // second tab [you can add an icon using the icon property]
                          Tab(
                            child: Text(
                              'Admin',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Metropolis',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    tabIndex != 2 ? Container(
                        //width: MediaQuery.of(context).size.width / 2.5,
                        height: 45,
                        margin: const EdgeInsets.only(bottom: 15, left: 20),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              get_allread();
                              getallnotifydata.clear();
                              getnotifydata.clear();
                              unread_getnotifydata.clear();
                              //isload = false;
                              _onLoading();
                              fetch_allNotification(offset: offset.toString(), limit: '20');
                              get_notification(read_status, offset.toString(), '20');
                              get_notification_unread(read_status, offset.toString(), '20');
                            });
                          },
                          child: Text(
                            'Mark all as read',
                            style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromARGB(255, 0, 91, 148),
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf')
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        )) : const SizedBox(),
                  ],
                ),
              ),
              // tab bar view here
              Expanded(
                child: TabBarView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _tabController,
                    // first tab bar view widget
                    children: [
                      allnotificationsetting(),
                      notificationsetting(),
                      notificationsetting_unread()
                    ]),
              ),
            ],
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
    );
  }

  void _scrollercontroller() {
    if (scrollercontroller.position.pixels ==
        scrollercontroller.position.maxScrollExtent) {
      if(allNotification){
        count++;
        if (count == 1) {
          offset = offset + 21;
        } else {
          offset = offset + 20;
        }
        _onLoading();
        fetch_allNotification(offset: offset.toString(), limit: limit);
      }

      else if (unread) {
        read_status = "0";

        count++;
        if (count == 1) {
          offset = offset + 21;
        } else {
          offset = offset + 20;
        }
        _onLoading();
        get_notification_unread(read_status, offset.toString(), limit);
      }
      else if (alldata) {
        count++;
        read_status = "";

        if (count == 1) {
          offset = offset + 21;
        }
        else {
          offset = offset + 20;
        }
        _onLoading();
        get_notification(read_status, offset.toString(), limit);
      }
    }
  }

  void _onLoading() {
    BuildContext dialogContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context; // Store the context in a variable
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SizedBox(
            width: 300.0,
            height: 150.0,
            child: Center(
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: Center(
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
              ),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(dialogContext).pop(); // Use dialogContext to close the dialog
      // Dialog closed
    });
  }

  Widget allnotificationsetting() {
    return getallnotifydata.isNotEmpty
        ?
    // FutureBuilder(
    //         builder: (context, snapshot) {
    //           if (snapshot.connectionState == ConnectionState.none &&
    //               snapshot.hasData == null) {
    //             return const Center(
    //               child: CircularProgressIndicator(),
    //             );
    //           }
    //           if (snapshot.hasError) {
    //             return Text('Error: ${snapshot.error}');
    //           } else {
    //             return
    ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: getallnotifydata.length,
      padding: const EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
      controller: scrollercontroller,
      itemBuilder: (context, index) {
        admin_getnotifi.Result result = getallnotifydata[index];
        //DateFormat format = new DateFormat("dd-MM-yyyy HH:mm:ss");
        DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");

        var curret_date = format.parse(
          result.time.toString(),
        );

        DateTime? dt1 = DateTime.parse(
          curret_date.toString(),
        );

         print(result.isRead);
        create_formattedDate = dt1 != null
            ? DateFormat('dd MMMM, yyyy hh:mm aaa ').format(dt1)
            : "";
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: ShapeDecoration(
                color: result.isAdminNotificationTable == "1" ?
                result.isRead == 0 ? Colors.white.withOpacity(0.5) : Colors.white : result.isRead == 1 ? Colors.white.withOpacity(0.5) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.05),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3FA6A6A6),
                    blurRadius: 16.32,
                    offset: Offset(0, 3.26),
                    spreadRadius: 0,
                  )]),
            child: SlidableAutoCloseBehavior(
              child: Slidable(
                direction: Axis.horizontal,
                endActionPane: ActionPane(
                  motion: const BehindMotion(),
                  extentRatio: 0.25,
                  children: [
                    Expanded(
                      // flex: 1,
                      child: Container(
                        //height: 180,
                        // margin: const EdgeInsets.symmetric(
                        //     horizontal: 8, vertical: 4.8),
                        color: Colors.red.shade600,
                        child: Column(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if(result.isAdminNotificationTable == "1"){
                                          adminremove_notification(result.notificationId.toString(),);
                                          }else{
                                            remove_notification(result.notificationId.toString(),);
                                          }
                                          getallnotifydata.clear();
                                          getnotifydata.clear();
                                          unread_getnotifydata.clear();
                                          _onLoading();
                                          fetch_allNotification(offset: offset.toString(), limit: '20');
                                          get_notification(read_status, offset.toString(), '20');
                                          get_notification_unread(read_status, offset.toString(), '20');
                                        });
                                        //getallnotifydata.removeAt(index);
                                      },
                                      icon: Image.asset(
                                          'assets/delete2.png',
                                          color: Colors.white,
                                          width: 30,
                                          height: 30),
                                    ),
                                    const Text(
                                      'Remove',
                                      style: TextStyle(
                                          fontSize: 9,
                                          fontWeight:
                                          FontWeight.w600,
                                          color:
                                          Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    print("notificationType:-${result.notificationType}");
                    if (result.notificationType.toString().toLowerCase() == "profile like") {
                      if (result.fromUserId
                          .toString()
                          .isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  other_user_profile(int.parse(
                                    result.fromUserId.toString(),
                                  )),
                            ));
                      }
                    } else if (result.notificationType.toString().toLowerCase() ==
                        "follower_profile_like") {
                      if (result.fromUserId
                          .toString()
                          .isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  other_user_profile(int.parse(
                                    result.fromUserId.toString(),
                                  )),
                            ));
                      }
                    } else if (result.notificationType
                        .toString().toLowerCase() ==
                        "profile_review") {
                      if (result.fromUserId
                          .toString()
                          .isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const bussinessprofile(),
                            ));
                      }
                    } else if (result.notificationType
                        .toString().toLowerCase() ==
                        "business profile dislike") {
                      if (result.fromUserId
                          .toString()
                          .isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  other_user_profile(int.parse(
                                    result.fromUserId.toString(),
                                  )),
                            ));
                      }
                    } else if (result.notificationType
                        .toString().toLowerCase() ==
                        "salepost") {
                      if (result.salepostId
                          .toString()
                          .isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Buyer_sell_detail(
                                    post_type: 'SalePost',
                                    prod_id: result.salepostId,
                                  ),
                            ));
                      }
                    } else if (result.notificationType
                        .toString().toLowerCase() ==
                        "buypost") {
                      if (result.buypostId
                          .toString()
                          .isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Buyer_sell_detail(
                                    post_type: 'BuyPost',
                                    prod_id: result.salepostId,
                                  ),
                            ));
                      }
                    } else if (result.notificationType
                        .toString().toLowerCase() ==
                        "followuser") {
                      if (result.fromUserId
                          .toString()
                          .isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  other_user_profile(int.parse(
                                    result.fromUserId.toString(),
                                  )),
                            ));
                      }
                    } else if (result.notificationType
                        .toString().toLowerCase() ==
                        "unfollowuser") {
                      if (result.fromUserId
                          .toString()
                          .isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  other_user_profile(int.parse(
                                    result.fromUserId.toString(),
                                  )),
                            ));
                      }
                    }
                    /*else if(result.notificationType.toString()=="profile_review"){
                                    if(result.profileUserId.toString().isNotEmpty){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => other_user_profile(int.parse(result.profileUserId.toString(),)),));
                                    }
                                  }*/
                    else if (result.notificationType
                        .toString().toLowerCase() ==
                        "live_price") {
                      // if(result.profileUserId.toString().isNotEmpty){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const LivepriceScreen(),
                          ));
                      // }
                    } else if (result.notificationType
                        .toString().toLowerCase() ==
                        "quicknews") {
                      // if(result.profileUserId.toString().isNotEmpty){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(3),
                          ));
                      // }
                    } else if (result.notificationType
                        .toString().toLowerCase() ==
                        "quick_news_notification") {
                      // if(result.profileUserId.toString().isNotEmpty){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(3),
                          ));
                      // }
                    } else if (result.notificationType
                        .toString().toLowerCase() ==
                        "quicknews") {
                      // if(result.profileUserId.toString().isNotEmpty){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(3),
                          ));
                      // }
                    } else if (result.notificationType
                        .toString().toLowerCase() ==
                        "news") {
                      // if(result.profileUserId.toString().isNotEmpty){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(3),
                          ));
                      // }
                    } else if (result.notificationType
                        .toString().toLowerCase() ==
                        "blog") {
                      // if(result.profileUserId.toString().isNotEmpty){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Blog(),
                          ));
                      // }
                    } else if (result.notificationType
                        .toString().toLowerCase() ==
                        "video") {
                      // if(result.profileUserId.toString().isNotEmpty){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const Videos(),
                          ));
                      // }
                    } else if (result.notificationType
                        .toString().toLowerCase() ==
                        "tutorial_video") {
                      // if(result.profileUserId.toString().isNotEmpty){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const Tutorial_Videos(),
                          ));
                      // }
                    } else if (result.notificationType
                        .toString().toLowerCase() ==
                        "exhibition") {
                      // if(result.profileUserId.toString().isNotEmpty){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const Exhibition(),
                          ));
                      // }
                    } else if (result.notificationType
                        .toString().toLowerCase() ==
                        "banner") {
                      // if(result.profileUserId.toString().isNotEmpty){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(0),
                          ));
                      // }
                    }
                  },
                  child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 75,
                        width: 80,
                        //margin: EdgeInsets.symmetric(horizontal:10.0 ,vertical: 15),
                        margin: const EdgeInsets.all(5.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          // color: Color.fromARGB(255, 0, 91, 148)
                          //   color: result.isRead=="0"?Colors.white:Colors.white70,
                        ),
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius:
                          BorderRadius.circular(10),
                          // Image border
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(48),
                            // Image radius

                            child: Image(
                              errorBuilder:
                                  (context, object, trace) {
                                return Image.asset(
                                    'assets/plastic4trade logo final 1 (2).png');
                              },
                              image: NetworkImage(
                                  result.profilepic.toString()
                                //data[index]['member_image'] ?? '',
                              ),
                              width: MediaQuery.of(context)
                                  .size
                                  .width /
                                  1.2,
                              /*   width: MediaQuery.of(context)
                                              .size
                                              .width,*/
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                            width: MediaQuery.of(context)
                                .size
                                .width /
                                1.8,
                            child: Text(
                              result.heading.toString(),
                              style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight:
                                  FontWeight.w700,
                                  color: Color.fromARGB(
                                      255, 0, 91, 148),
                                  fontFamily:
                                  'assets/fonst/Metropolis-Black.otf')
                                  .copyWith(
                                  fontSize: 12,
                                  color: Colors.black),
                              maxLines: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                            child: Text(create_formattedDate,
                                style: const TextStyle(
                                    fontSize: 13.0,
                                    fontWeight:
                                    FontWeight.w500,
                                    fontFamily:
                                    'assets/fonst/Metropolis-Black.otf')
                                    .copyWith(
                                    fontSize: 11,
                                    color: Colors.black),
                                maxLines: 1,
                                softWrap: false),
                          ),
                          SizedBox(
                            height: 25,
                            child: Row(
                              children: [
                                SizedBox(
                                  //width: 20,
                                  child: Image.asset(
                                      'assets/plastic4trade logo final 1 (2).png'),
                                ),
                                result.fromUserId.toString() == 0
                                    ? Text(result.name.toString(),
                                    style: const TextStyle(
                                        fontSize:
                                        13.0,
                                        fontWeight:
                                        FontWeight
                                            .w500,
                                        fontFamily:
                                        'assets/fonst/Metropolis-Black.otf')
                                        .copyWith(
                                        fontSize: 11,
                                        color: Colors
                                            .black),
                                    maxLines: 1,
                                    softWrap: false)
                                    : Text(result.name.toString(),
                                    style: const TextStyle(
                                        fontSize:
                                        13.0,
                                        fontWeight:
                                        FontWeight
                                            .w500,
                                        fontFamily:
                                        'assets/fonst/Metropolis-Black.otf')
                                        .copyWith(
                                        fontSize: 11,
                                        color:
                                        Colors.black),
                                    maxLines: 1,
                                    softWrap: false),
                              ],
                            ),
                          ),
                        ],
                      ),
                      result.isAdminNotificationTable == "1" ? result.isRead == 1
                          ? Container(
                        alignment:
                        Alignment.bottomRight,
                        margin: const EdgeInsets.only(
                            left: 30, top: 60),
                        child: const Align(
                          alignment: Alignment.bottomLeft,
                          child: Icon(
                            Icons.circle_rounded,
                            size: 10,
                            color: Color(0xFF005C94),
                          ),
                        ),
                      )
                          : Container() :
                      result.isRead == 0
                          ? Container(
                        alignment:
                        Alignment.bottomRight,
                        margin: const EdgeInsets.only(
                            left: 30, top: 60),
                        child: const Align(
                          alignment: Alignment.bottomLeft,
                          child: Icon(
                            Icons.circle_rounded,
                            size: 10,
                            color: Color(0xFF005C94),
                          ),
                        ),
                      )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    )
    // }
    // },
    // )
        : const Text('Not data Found');
  }

  Widget notificationsetting() {
    return
      // FutureBuilder(
      //   //future: load_subcategory(),
      //   builder: (context, snapshot) {
      // if (snapshot.connectionState == ConnectionState.none &&
      //     snapshot.hasData == null) {
      //   return const Center(
      //     child: CircularProgressIndicator(),
      //   );
      // }
      // if (snapshot.hasError) {
      //   return Text('Error: ${snapshot.error}');
      // } else {
      //   //List<dynamic> users = snapshot.data as List<dynamic>;
      //   return
          ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollercontroller,
            itemCount: getnotifydata.length,
            padding: const EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
            itemBuilder: (context, index) {
              getnotifi.Result result = getnotifydata[index];
              //DateFormat format = new DateFormat("dd-MM-yyyy HH:mm:ss");
              DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");

              var currentDate = format.parse(
                result.time.toString(),
              );

              DateTime? dt1 = DateTime.parse(
                currentDate.toString(),
              );

               print(result.isRead);
              create_formattedDate = dt1 != null
                  ? DateFormat('dd MMMM, yyyy hh:mm aaa ').format(dt1)
                  : "";
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: ShapeDecoration(
                      color: result.isRead == "1" ? Colors.white.withOpacity(0.5) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.05),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3FA6A6A6),
                          blurRadius: 16.32,
                          offset: Offset(0, 3.26),
                          spreadRadius: 0,
                        )]),
                  child: SlidableAutoCloseBehavior(
                    child: Slidable(
                      direction: Axis.horizontal,
                      endActionPane: ActionPane(
                        motion: const BehindMotion(),
                        extentRatio: 0.25,
                        children: [
                          Expanded(
                            // flex: 1,
                            child: Container(
                              //height: 180,

                              // margin: const EdgeInsets.symmetric(
                              //     horizontal: 8, vertical: 4.8),
                              color: Colors.red.shade600,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              remove_notification(result.notificationId.toString(),);
                                              /* getnotifydata.removeAt(index);
                                              unread_getnotifydata.removeAt(index);
                                              setState(() {

                                              });*/
                                              getallnotifydata.clear();
                                              getnotifydata.clear();
                                              unread_getnotifydata.clear();
                                              _onLoading();
                                              fetch_allNotification(offset: offset.toString(), limit: '20');
                                              get_notification(read_status, offset.toString(), '20');
                                              get_notification_unread(read_status, offset.toString(), '20');
                                            },
                                            icon: Image.asset(
                                                'assets/delete2.png',
                                                color: Colors.white,
                                                width: 30,
                                                height: 30),
                                          ),
                                          const Text(
                                            'Remove',
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight:
                                                    FontWeight.w600,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (result.notificationType.toString().toLowerCase() == "profile like") {
                            if (result.fromUserId.toString().isNotEmpty) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        other_user_profile(int.parse(
                                      result.fromUserId.toString(),
                                    )),
                                  ));
                            }
                          } else if (result.notificationType.toString().toLowerCase() ==
                              "follower_profile_like") {
                            if (result.fromUserId.toString().isNotEmpty) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        other_user_profile(int.parse(
                                      result.fromUserId.toString(),
                                    )),
                                  ));
                            }
                          } else if (result.notificationType.toString().toLowerCase() ==
                              "profile_review") {
                            if (result.fromUserId.toString().isNotEmpty) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const bussinessprofile(),
                                  ));
                            }
                          } else if (result.notificationType.toString().toLowerCase() ==
                              "business profile dislike") {
                            if (result.fromUserId.toString().isNotEmpty) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        other_user_profile(int.parse(
                                      result.fromUserId.toString(),
                                    )),
                                  ));
                            }
                          } else if (result.notificationType.toString().toLowerCase() ==
                              "salepost") {
                            if (result.salepostId.toString().isNotEmpty) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Buyer_sell_detail(
                                      post_type: 'SalePost',
                                      prod_id: result.salepostId,
                                    ),
                                  ));
                            }
                          } else if (result.notificationType.toString().toLowerCase() ==
                              "buypost") {
                            if (result.buypostId.toString().isNotEmpty) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Buyer_sell_detail(
                                      post_type: 'BuyPost',
                                      prod_id: result.salepostId,
                                    ),
                                  ));
                            }
                          } else if (result.notificationType.toString().toLowerCase() ==
                              "followuser") {
                            if (result.fromUserId.toString().isNotEmpty) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        other_user_profile(int.parse(
                                      result.fromUserId.toString(),
                                    )),
                                  ));
                            }
                          } else if (result.notificationType.toString().toLowerCase() ==
                              "unfollowuser") {
                            if (result.fromUserId.toString().isNotEmpty) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        other_user_profile(int.parse(
                                      result.fromUserId.toString(),
                                    )),
                                  ));
                            }
                          } else if (result.notificationType.toString().toLowerCase() ==
                              "profile_review") {
                            if (result.profileUserId
                                .toString()
                                .isNotEmpty) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        other_user_profile(int.parse(
                                      result.profileUserId.toString(),
                                    )),
                                  ));
                            }
                          } else if (result.notificationType.toString().toLowerCase() ==
                              "live_price") {
                            // if(result.profileUserId.toString().isNotEmpty){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LivepriceScreen(),
                                ));
                            // }
                          } else if (result.notificationType.toString().toLowerCase() ==
                              "quick_news_notification") {
                            // if(result.profileUserId.toString().isNotEmpty){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainScreen(3),
                                ));
                            // }
                          } else if (result.notificationType.toString().toLowerCase() ==
                              "news") {
                            // if(result.profileUserId.toString().isNotEmpty){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainScreen(3),
                                ));
                            // }
                          } else if (result.notificationType.toString().toLowerCase() ==
                              "blog") {
                            // if(result.profileUserId.toString().isNotEmpty){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Blog(),
                                ));
                            // }
                          } else if (result.notificationType.toString().toLowerCase() ==
                              "video") {
                            // if(result.profileUserId.toString().isNotEmpty){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Videos(),
                                ));
                            // }
                          } else if (result.notificationType.toString().toLowerCase() ==
                              "banner") {
                            // if(result.profileUserId.toString().isNotEmpty){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainScreen(0),
                                ));
                            // }
                          } else if (result.notificationType.toString().toLowerCase() ==
                              "tutorial_video") {
                            // if(result.profileUserId.toString().isNotEmpty){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const Tutorial_Videos(),
                                ));
                            // }
                          } else if (result.notificationType.toString().toLowerCase() ==
                              "exhibition") {
                            // if(result.profileUserId.toString().isNotEmpty){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const Exhibition(),
                                ));
                            // }
                          }
                        },
                        child: Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment:
                                CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 75,
                                width: 80,
                                //margin: EdgeInsets.symmetric(horizontal:10.0 ,vertical: 15),
                                margin: const EdgeInsets.all(5.0),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  // color: Color.fromARGB(255, 0, 91, 148)
                                  //   color: result.isRead=="0"?Colors.white:Colors.white70,
                                ),
                                child: ClipRRect(
                                  clipBehavior: Clip.antiAlias,
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  // Image border
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(48),
                                    // Image radius

                                    child: Image(
                                      errorBuilder:
                                          (context, object, trace) {
                                        return Image.asset(
                                            'assets/plastic4trade logo final 1 (2).png');
                                      },
                                      image: NetworkImage(
                                          result.profilepic.toString()
                                          //data[index]['member_image'] ?? '',
                                          ),
                                      width: MediaQuery.of(context)
                                              .size
                                              .width /
                                          1.2,
                                      /*   width: MediaQuery.of(context)
                                            .size
                                            .width,*/
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  /*  SizedBox(
                                            height: 20,
                                            child: Text(
                                                result.heading
                                                    .toString(),
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .displayLarge
                                                    ?.copyWith(
                                                    fontSize: 12,
                                                    color: Colors
                                                        .black),
                                                maxLines: 1,
                                                softWrap: false),
                                          ),*/
                                  SizedBox(
                                    height: 20,
                                    width: MediaQuery.of(context)
                                            .size
                                            .width /
                                        1.8,
                                    child: Text(
                                      result.heading.toString(),
                                      style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight:
                                                  FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf')
                                          .copyWith(
                                              fontSize: 12,
                                              color: Colors.black),
                                      maxLines: 1,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                    child: Text(create_formattedDate,
                                        style: const TextStyle(
                                                fontSize: 13.0,
                                                fontWeight:
                                                    FontWeight.w500,
                                                fontFamily:
                                                    'assets/fonst/Metropolis-Black.otf')
                                            .copyWith(
                                                fontSize: 11,
                                                color: Colors.black),
                                        maxLines: 1,
                                        softWrap: false),
                                  ),
                                  SizedBox(
                                    height: 25,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          //width: 20,
                                          child: Image.asset(
                                              'assets/plastic4trade logo final 1 (2).png'),
                                        ),
                                        result.fromUserId.toString() == "0"
                                            ? Text(
                                                result.name.toString(),
                                                style: const TextStyle(
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight
                                                                .w500,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf')
                                                    .copyWith(
                                                        fontSize: 11,
                                                        color: Colors
                                                            .black),
                                                maxLines: 1,
                                                softWrap: false)
                                            : Text(
                                                result.name.toString(),
                                                style: const TextStyle(
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight
                                                                .w500,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf')
                                                    .copyWith(
                                                        fontSize: 11,
                                                        color: Colors
                                                            .black),
                                                maxLines: 1,
                                                softWrap: false),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              result.isRead == "0"
                                  ? Container(
                                      alignment: Alignment.bottomRight,
                                      margin: const EdgeInsets.only(
                                          left: 30, top: 60),
                                      child: const Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Icon(
                                          Icons.circle_rounded,
                                          size: 10,
                                          color: Color(0xFF005C94),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ]),
                      ),
                    ),
                  ),
                ),
              );
            }
    );
  }

  Widget notificationsetting_unread() {
    return unread_getnotifydata.isNotEmpty
        ?
    // FutureBuilder(
    //         builder: (context, snapshot) {
    //           if (snapshot.connectionState == ConnectionState.none &&
    //               snapshot.hasData == null) {
    //             return const Center(
    //               child: CircularProgressIndicator(),
    //             );
    //           }
    //           if (snapshot.hasError) {
    //             return Text('Error: ${snapshot.error}');
    //           } else {
    //             return
                  ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: unread_getnotifydata.length,
                  padding: const EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
                  controller: scrollercontroller,
                  itemBuilder: (context, index) {
                    admin_getnotifi.Result result = unread_getnotifydata[index];
                    //DateFormat format = new DateFormat("dd-MM-yyyy HH:mm:ss");
                    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");

                    var curret_date = format.parse(
                      result.time.toString(),
                    );

                    DateTime? dt1 = DateTime.parse(
                      curret_date.toString(),
                    );

                    // print(dt1);
                    create_formattedDate = dt1 != null
                        ? DateFormat('dd MMMM, yyyy hh:mm aaa ').format(dt1)
                        : "";
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: ShapeDecoration(
                            color: result.isRead == 0 ? Colors.white.withOpacity(0.5) : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.05),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x3FA6A6A6),
                                blurRadius: 16.32,
                                offset: Offset(0, 3.26),
                                spreadRadius: 0,
                              )]),
                        child: SlidableAutoCloseBehavior(
                          child: Slidable(
                            direction: Axis.horizontal,
                            endActionPane: ActionPane(
                              motion: const BehindMotion(),
                              extentRatio: 0.25,
                              children: [
                                Expanded(
                                  // flex: 1,
                                  child: Container(
                                    //height: 180,

                                    // margin: const EdgeInsets.symmetric(
                                    //     horizontal: 8, vertical: 4.8),
                                    color: Colors.red.shade600,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      adminremove_notification(
                                                        result.notificationId.toString(),
                                                      );
                                                      getnotifydata.clear();
                                                      unread_getnotifydata.clear();
                                                     // isload = false;
                                                      _onLoading();
                                                      fetch_allNotification(offset: offset.toString(), limit: '20');
                                                      get_notification(read_status, offset.toString(), '20');
                                                      get_notification_unread(read_status, offset.toString(), '20');
                                                    },
                                                    icon: Image.asset(
                                                        'assets/delete2.png',
                                                        color: Colors.white,
                                                        width: 30,
                                                        height: 30),
                                                  ),
                                                  const Text(
                                                    'Remove',
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Colors.white),
                                                  )
                                                ],
                                              ),
                                            ),
                                            onTap: () {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if (result.notificationType.toString().toLowerCase() ==
                                    "profile like") {
                                  if (result.fromUserId
                                      .toString()
                                      .isNotEmpty) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              other_user_profile(int.parse(
                                            result.fromUserId.toString(),
                                          )),
                                        ));
                                  }
                                } else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "follower_profile_like") {
                                  if (result.fromUserId
                                      .toString()
                                      .isNotEmpty) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              other_user_profile(int.parse(
                                            result.fromUserId.toString(),
                                          )),
                                        ));
                                  }
                                } else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "profile_review") {
                                  if (result.fromUserId
                                      .toString()
                                      .isNotEmpty) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const bussinessprofile(),
                                        ));
                                  }
                                } else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "business profile dislike") {
                                  if (result.fromUserId
                                      .toString()
                                      .isNotEmpty) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              other_user_profile(int.parse(
                                            result.fromUserId.toString(),
                                          )),
                                        ));
                                  }
                                } else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "salepost") {
                                  if (result.salepostId
                                      .toString()
                                      .isNotEmpty) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Buyer_sell_detail(
                                            post_type: 'SalePost',
                                            prod_id: result.salepostId,
                                          ),
                                        ));
                                  }
                                } else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "buypost") {
                                  if (result.buypostId
                                      .toString()
                                      .isNotEmpty) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Buyer_sell_detail(
                                            post_type: 'BuyPost',
                                            prod_id: result.salepostId,
                                          ),
                                        ));
                                  }
                                } else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "followuser") {
                                  if (result.fromUserId
                                      .toString()
                                      .isNotEmpty) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              other_user_profile(int.parse(
                                            result.fromUserId.toString(),
                                          )),
                                        ));
                                  }
                                } else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "unfollowuser") {
                                  if (result.fromUserId
                                      .toString()
                                      .isNotEmpty) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              other_user_profile(int.parse(
                                            result.fromUserId.toString(),
                                          )),
                                        ));
                                  }
                                }
                                /*else if(result.notificationType.toString()=="profile_review"){
                                    if(result.profileUserId.toString().isNotEmpty){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => other_user_profile(int.parse(result.profileUserId.toString(),)),));
                                    }
                                  }*/
                                else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "live_price") {
                                  // if(result.profileUserId.toString().isNotEmpty){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LivepriceScreen(),
                                      ));
                                  // }
                                } else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "quicknews") {
                                  // if(result.profileUserId.toString().isNotEmpty){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainScreen(3),
                                      ));
                                  // }
                                } else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "quick_news_notification") {
                                  // if(result.profileUserId.toString().isNotEmpty){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainScreen(3),
                                      ));
                                  // }
                                } else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "quicknews") {
                                  // if(result.profileUserId.toString().isNotEmpty){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainScreen(3),
                                      ));
                                  // }
                                } else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "news") {
                                  // if(result.profileUserId.toString().isNotEmpty){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainScreen(3),
                                      ));
                                  // }
                                } else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "blog") {
                                  // if(result.profileUserId.toString().isNotEmpty){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Blog(),
                                      ));
                                  // }
                                } else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "video") {
                                  // if(result.profileUserId.toString().isNotEmpty){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Videos(),
                                      ));
                                  // }
                                } else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "tutorial_video") {
                                  // if(result.profileUserId.toString().isNotEmpty){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Tutorial_Videos(),
                                      ));
                                  // }
                                } else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "exhibition") {
                                  // if(result.profileUserId.toString().isNotEmpty){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Exhibition(),
                                      ));
                                  // }
                                } else if (result.notificationType
                                        .toString().toLowerCase() ==
                                    "banner") {
                                  // if(result.profileUserId.toString().isNotEmpty){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainScreen(0),
                                      ));
                                  // }
                                }
                              },
                              child: Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 75,
                                    width: 80,
                                    //margin: EdgeInsets.symmetric(horizontal:10.0 ,vertical: 15),
                                    margin: const EdgeInsets.all(5.0),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      // color: Color.fromARGB(255, 0, 91, 148)
                                      //   color: result.isRead=="0"?Colors.white:Colors.white70,
                                    ),
                                    child: ClipRRect(
                                      clipBehavior: Clip.antiAlias,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      // Image border
                                      child: SizedBox.fromSize(
                                        size: const Size.fromRadius(48),
                                        // Image radius

                                        child: Image(
                                          errorBuilder:
                                              (context, object, trace) {
                                            return Image.asset(
                                                'assets/plastic4trade logo final 1 (2).png');
                                          },
                                          image: NetworkImage(
                                              result.profilepic.toString()
                                              //data[index]['member_image'] ?? '',
                                              ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.2,
                                          /*   width: MediaQuery.of(context)
                                              .size
                                              .width,*/
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: MediaQuery.of(context)
                                                .size
                                                .width /
                                            1.8,
                                        child: Text(
                                          result.heading.toString(),
                                          style: const TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight:
                                                      FontWeight.w700,
                                                  color: Color.fromARGB(
                                                      255, 0, 91, 148),
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-Black.otf')
                                              .copyWith(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                          maxLines: 1,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                        child: Text(create_formattedDate,
                                            style: const TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf')
                                                .copyWith(
                                                    fontSize: 11,
                                                    color: Colors.black),
                                            maxLines: 1,
                                            softWrap: false),
                                      ),
                                      SizedBox(
                                        height: 25,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              //width: 20,
                                              child: Image.asset(
                                                  'assets/plastic4trade logo final 1 (2).png'),
                                            ),
                                            result.fromUserId.toString() == 0
                                                ? Text(result.name.toString(),
                                                    style: const TextStyle(
                                                            fontSize:
                                                                13.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                            fontFamily:
                                                                'assets/fonst/Metropolis-Black.otf')
                                                        .copyWith(
                                                            fontSize: 11,
                                                            color: Colors
                                                                .black),
                                                    maxLines: 1,
                                                    softWrap: false)
                                                : Text(result.name.toString(),
                                                    style: const TextStyle(
                                                            fontSize:
                                                                13.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                            fontFamily:
                                                                'assets/fonst/Metropolis-Black.otf')
                                                        .copyWith(
                                                            fontSize: 11,
                                                            color:
                                                                Colors.black),
                                                    maxLines: 1,
                                                    softWrap: false),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  result.isRead == 1
                                      ? Container(
                                          alignment:
                                              Alignment.bottomRight,
                                          margin: const EdgeInsets.only(
                                              left: 30, top: 60),
                                          child: const Align(
                                            alignment:
                                                Alignment.bottomLeft,
                                            child: Icon(
                                              Icons.circle_rounded,
                                              size: 10,
                                              color: Color(0xFF005C94),
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
             // }
           // },
         // )
        : const Text('Not data Found');
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      fetch_allNotification(offset: offset.toString(),limit: '20');
      get_notification(read_status, offset.toString(), '20');
      read_status = "0";
      get_notification_unread(read_status, offset.toString(), '20');
    }
  }

  Future<void> fetch_allNotification({
    required String offset,
    required String limit}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getAllnotification(
        userId: pref.getString('user_id').toString(),
        userToken: pref.getString('api_token').toString(),
        offset: offset,
        limit: limit);

    var jsonarray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonarray = res['result'];

        //
        for (var data in jsonarray) {
          admin_getnotifi.Result record = admin_getnotifi.Result(
              notificationId: data['notificationId'],
              blogId: data['blog_id'],
              newsId: data['news_id'],
              type: data['type'],
              advertiseId: data['advertise_id'],
              buypostId: data['buypost_id'],
              description: data['description'],

              fromUserId: data['from_user_id'] != null ? int.parse(data['from_user_id'].toString()) : 0,
              heading: data['heading'],
              livepriceId: data['liveprice_id'],
              notificationType: data['notification_type'],
              //otherImage: data['other_image'],
              postImage: data['post_image'],
              profilepic: data['profilepic'],
              salepostId: data['salepost_id'],
              time: data['time'],
              name: data['name'],
              isAdminNotificationTable: data['is_admin_notification_table'],
              isRead: data['is_read'] != null ? int.parse(data['is_read'].toString()) : 2,
          );

          getallnotifydata.add(record);
        }
        isload = true;
        if (mounted) {
          setState(() {});
        }
      }
    } else if (res['status'] == 2) {
      isload = true;
    } else {
      isload = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
  }

  Future<void> get_notification(
      String isread, String offset, String limit) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getnotification(pref.getString('user_id').toString(),
        pref.getString('api_token').toString(), isread, offset, limit);

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];

        for (var data in jsonArray) {
          getnotifi.Result record = getnotifi.Result(
              notificationId: data['notificationId'],
              blogId: data['blog_id'],
              newsId: data['news_id'],
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
              time: data['time'],
              name: data['name'],
              isRead: data['is_read']);

          getnotifydata.add(record);
        }

        if (mounted) {
          setState(() {});
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonArray;
  }

  Future<void> get_notification_unread(
      String isread, String offset, String limit) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getadminnotification(pref.getString('user_id').toString(),
        pref.getString('api_token').toString(), isread, offset, limit);

    var jsonarray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonarray = res['result'];

        //
        for (var data in jsonarray) {
          admin_getnotifi.Result record = admin_getnotifi.Result(
              notificationId: data['notificationId'],
              blogId: data['blog_id'],
              newsId: data['news_id'],
              type: data['type'],
              advertiseId: data['advertise_id'],
              buypostId: data['buypost_id'],
              description: data['description'],
              fromUserId: data['from_user_id'],
              heading: data['heading'],
              livepriceId: data['liveprice_id'],
              notificationType: data['notification_type'],
              otherImage: data['other_image'],
              postImage: data['post_image'],
              profilepic: data['profilepic'],
              salepostId: data['salepost_id'],
              time: data['time'],
              name: data['name'],
              isRead: data['is_read']);

          unread_getnotifydata.add(record);
        }
        isload = true;
        if (mounted) {
          setState(() {});
        }
      }
    } else if (res['status'] == 2) {
      isload = true;
    } else {
      isload = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
  }

  Future<void> remove_notification(String notify_id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await remove_noty(pref.getString('user_id').toString(),
        pref.getString('api_token').toString(), notify_id);

    if (res['status'] == 1) {
      setState(() {});
      if (mounted) {
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
  }

  Future<void> adminremove_notification(String notify_id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await adminremove_noty(pref.getString('user_id').toString(),
        pref.getString('api_token').toString(), notify_id);

    if (res['status'] == 1) {
      setState(() {});
      if (mounted) {
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
  }

  remove_item(notify_id) {
    final index = getnotifydata.indexWhere(
        (element) => element.notificationId.toString() == notify_id);

    setState(() {
      getnotifydata.removeAt(index);
    });

    setState(() {
      unread_getnotifydata.removeAt(index);
    });

    setState(() {});
  }

  Future<void> get_allread() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getread_all(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );

    if (res['status'] == 1) {
      isload = true;
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
  }
}
