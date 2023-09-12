import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:Plastic4trade/screen/Bussinessinfo.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:Plastic4trade/model/GetSalePostList.dart' as homepost;
import 'package:Plastic4trade/model/Get_likeUser.dart' as like;
import 'package:Plastic4trade/model/Get_viewUser.dart' as view_pro;
import 'package:Plastic4trade/model/Get_shareUser.dart' as share_pro;
import '../api/api_interface.dart';
import '../model/GetSalePostList.dart';
import '../model/Get_likeUser.dart';
import '../model/Get_shareUser.dart';
import '../model/Get_viewUser.dart';
import '../model/common.dart';
import '../widget/HomeAppbar.dart';
import 'Buyer_sell_detail.dart';
import 'EditBussinessProfile.dart';
import 'Review.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class other_user_profile extends StatefulWidget {
  int user_id;
  other_user_profile(this.user_id, {Key? key}) : super(key: key);

  @override
  State<other_user_profile> createState() => _bussinessprofileState();
}

class _bussinessprofileState extends State<other_user_profile>
    with TickerProviderStateMixin {
  late TabController _parentController;
  late TabController _childController;
  final scrollercontroller = ScrollController();
  String? username,
      email,
      countryCode,
      b_countryCode,
      business_name,
      image_url,
      website,
      address,
      like_count,
      bussmbl,
      usermbl,
      b_email,
      product_name,
      verify_status;
  String? ex_import_number,
      production_capacity,
      gst_number,
      Annual_Turnover,
      Premises_Type,
      business_type,
      is_follow,
      abot_buss,
      pan_number;
  String? First_currency="",Second_currency="",Third_currency="";
  String? First_currency_sign="",Second_currency_sign="",Third_currency_sign="";
  int? view_count, like, reviews_count, following_count, followers_count;
  bool? isload;
  GetSalePostList salePostList = new GetSalePostList();
  GetSalePostList buyPostList = new GetSalePostList();
  int offset = 0;
  int count = 0;
  String? profileid, post_count = "0";
  String? packageName;
  PackageInfo? packageInfo;
  List<homepost.PostColor> colors = [];
  List<homepost.Result> salepostlist_data = [];
  List<homepost.Result> buypostlist_data = [];
  List<homepost.Result>? resultList;

  @override
  void initState() {
    _parentController = TabController(length: 2, vsync: this);
    _childController = TabController(length: 2, vsync: this);
    scrollercontroller.addListener(_scrollercontroller);
    checknetowork();
    super.initState();
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      getPackage();
      getProfiless();
      get_buypostlist();
      get_salepostlist();
      // get_buypostlist();
      // get_salepostlist();

      // get_data();
    }
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Widget init() {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: const Text('Business Profile',
              softWrap: false,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontFamily: 'Metropolis',
              )),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: isload == true
            ? Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
                      child: Column(children: [
                        Column(children: [
                          Container(
                              //width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 0.0),
                              child: Column(children: [
                                Column(children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 5.0, left: 2.0, right: 5.0),
                                    height: 140,
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center, // Align children in the center horizontally
                                          children: [
                                            Container(
                                              width: 110.0,
                                              height: 110.0,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff7c94b6),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      image_url.toString()),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(50.0)),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xffFFC107),
                                                  width: 2.0,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              // Adjust alignment and padding of the "Premium" label
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: const Color(0xffFFC107),
                                              ),
                                              child: Text(
                                                'Premium',
                                                style: TextStyle(fontSize: 9),
                                              ),
                                            ),
                                          ],
                                        ),
                                        //SizedBox(width: 10), // Add spacing between the two columns
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start, // Align children to the start (left) side
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                business_name.toString(),
                                                softWrap: false,
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.visible,
                                                  fontSize: 19.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets\fonst\Metropolis-SemiBold.otf',
                                                ),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.9,
                                            ),
                                            SizedBox(
                                                height:
                                                    2), // Add spacing between the business name and contact details
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.8,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start, // Align children to the start (left) side
                                                children: [
                                                  Row(
                                                    children: [
                                                      ImageIcon(AssetImage(
                                                          'assets/user.png')),
                                                      SizedBox(width: 5),
                                                      SizedBox(
                                                        //width: MediaQuery.of(context).size.width/2.3,
                                                        child: Text(
                                                            username.toString(),
                                                            //softWrap: true,
                                                            style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-SemiBold.otf',
                                                            ),
                                                            softWrap: false,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      ImageIcon(AssetImage(
                                                          'assets/call.png')),
                                                      SizedBox(width: 5),
                                                      SizedBox(
                                                        width: MediaQuery.of(context).size.width/3.5,
                                                        child: Text(
                                                          overflow: TextOverflow.visible,
                                                          softWrap: false,maxLines: 1,
                                                          countryCode
                                                                  .toString() +
                                                              usermbl
                                                                  .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'assets\fonst\Metropolis-SemiBold.otf',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      ImageIcon(AssetImage(
                                                          'assets/location.png')),
                                                      SizedBox(width: 5),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.2,
                                                        child: Text(
                                                          address.toString(),
                                                          softWrap: false,
                                                          style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'assets\fonst\Metropolis-SemiBold.otf',
                                                          ),
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow.clip,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    5.0, 5.0, 5.0, 5.0),
                                                child: Row(children: [
                                                  Column(
                                                    children: [
                                                      verify_status == "1"
                                                          ? Row(children: [
                                                              /* Image(
                                                            image: AssetImage(
                                                                'assets/verify.png')),*/
                                                              Text(
                                                                  'Unverified'),
                                                            ])
                                                          : verify_status == "2"
                                                              ? Row(
                                                                  children: [
                                                                    Image(
                                                                        image: AssetImage(
                                                                            'assets/verify.png')),
                                                                    Text(
                                                                        'Unverified'),
                                                                  ],
                                                                )
                                                              : verify_status ==
                                                                      "3"
                                                                  ? Row(
                                                                      children: [
                                                                        Image(
                                                                            image:
                                                                                AssetImage('assets/verify.png')),
                                                                        Text(
                                                                            'Unverified'),
                                                                        SizedBox(
                                                                            width:
                                                                                5),
                                                                        Row(
                                                                          children: [
                                                                            Image(
                                                                              image: AssetImage('assets/trust.png'),
                                                                              height: 20,
                                                                              width: 30,
                                                                            ),
                                                                            Text('Trusted'),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    )
                                                                  : Container()
                                                    ],
                                                  ),
                                                ])),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),

                                //category(),

                                //SizedBox(height: 10,),
                              ])),
                        ]),

                        //category(),

                        //SizedBox(height: 10,),
                      ])),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            /* Image(
                    image: AssetImage('assets/follwe.png'), width: 100),*/
                            Container(
                                height: 25,
                                width: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromARGB(255, 0, 91, 148),
                                ),
                                child: is_follow == "0"
                                    ? Center(
                                        child: Text('Follow',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                            textAlign: TextAlign.center),
                                      )
                                    : Center(
                                        child: Text('Followed',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                            textAlign: TextAlign.center),
                                      )),
                            Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(followers_count.toString(),
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets\fonst\Metropolis-SemiBold.otf')),
                                  Text('Followers',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets\fonst\Metropolis-SemiBold.otf')),
                                ]),
                            Row(children: [
                              Text(following_count.toString(),
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontFamily:
                                          'assets\fonst\Metropolis-SemiBold.otf')),
                              Text('Following',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontFamily:
                                      'assets\fonst\Metropolis-SemiBold.otf')),
                            ])
                          ])),
                  Container(
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      height: 60,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            Container(
                                padding: EdgeInsets.all(5.0),
                                margin: EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                ),
                                child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 4.2,
                                    height: 25,
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                            onTap: () {},
                                            child: ImageIcon(
                                                AssetImage('assets/sms.png'))),
                                        Text('Message',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf',
                                                fontSize: 14,
                                                color: Colors.black)),
                                      ],
                                    ))),
                            Container(
                                padding: EdgeInsets.all(5.0),
                                margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                ),
                                child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3.8,
                                    height: 25,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {},
                                            child: Image.asset(
                                                ('assets/whatsapp.png'))),
                                        Text('WhatsApp',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf',
                                                fontSize: 14,
                                                color: Colors.black)),
                                      ],
                                    ))),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {},
                                    child: Image.asset(
                                      'assets/facebook.png',
                                      width: 30,
                                      height: 30,
                                    )),
                                IconButton(
                                    onPressed: () {},
                                    icon: Image.asset('assets/instagram.png')),
                                IconButton(
                                    onPressed: () {},
                                    icon: Image.asset('assets/linkdin.png')),
                                IconButton(
                                    onPressed: () {},
                                    icon: Image.asset('assets/youtube.png')),
                                IconButton(
                                    onPressed: () {},
                                    icon: Image.asset('assets/Twitter.png')),
                              ],
                            )
                          ]))),
                  Divider(
                    color: Colors.black26,
                    height: 2.0,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                          height: 40,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 6.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                    onTap: () {},
                                    child: like == 0
                                        ? GestureDetector(
                                            child: Image.asset(
                                              'assets/like.png',
                                              height: 20,
                                              width: 20,
                                            ),
                                            onTap: () {
                                              Profilelike();
                                              like = 1;
                                              int add = int.parse(like_count!);
                                              add++;
                                              like_count = add.toString();

                                              setState(() {});
                                            },
                                          )
                                        : GestureDetector(
                                            child: Image.asset(
                                              'assets/like1.png',
                                              height: 20,
                                              width: 20,
                                            ),
                                            onTap: () {
                                              Profilelike();
                                              like = 0;
                                              int add = int.parse(like_count!);
                                              add--;
                                              like_count = add.toString();

                                              setState(() {});
                                            },
                                          )),
                                SizedBox(
                                  width: 2,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    ViewItem(context);
                                  },
                                  child: Text('Like ($like_count)',
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        fontFamily: 'Metropolis',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                          height: 40,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => review(
                                                  profileid.toString())));
                                    },
                                    child: Image.asset(
                                      'assets/star.png',
                                      color: Colors.black,
                                    )),
                                SizedBox(
                                  width: 2,
                                ),
                                Text('Reviews ($reviews_count)',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      fontFamily: 'Metropolis',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          height: 40,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 4.3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      ViewItem(context);
                                    },
                                    child: Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.black54,
                                    )),
                                Text('Views ($view_count)',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      fontFamily: 'Metropolis',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          height: 40,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 5.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      sharecount();
                                      shareImage(
                                          url: image_url.toString(),
                                          title: business_name.toString());
                                    },
                                    child: Image.asset(
                                      'assets/Send.png',
                                      height: 15,
                                    )),
                                SizedBox(
                                  width: 2,
                                ),
                                GestureDetector(
                                  child: Text('Share',
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        fontFamily: 'Metropolis',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
                                  onTap: () {
                                    ViewItem(context);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black26,
                    height: 2.0,
                  ),
                  /* _tabSection(context),*/
                  /* LikeWidget1()*/
                  TabBar(
                    controller: _parentController,
                    tabs: [
                      Tab(text: 'Product Catalogue ($post_count)'),
                      Tab(text: 'Business Info'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _parentController,
                      children: [
                        _subtabSection(context),
                        Container(
                            margin: EdgeInsets.all(20.0),
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                                child: Column(
                              children: [
                                Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      //height: 300,
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Nature Of Business',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  business_type.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'assets\fonst\Metropolis-Black.otf',
                                                      fontSize: 13,
                                                      color: Colors.black))),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Divider(
                                            height: 1.0,
                                            color: Colors.black26,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        'Business Phone',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                'assets\fonst\Metropolis-Black.otf',
                                                            fontSize: 12,
                                                            color: Colors
                                                                .black26)),
                                                  ),
                                                  Align(
                                                      alignment: Alignment
                                                          .topLeft,
                                                      child: Text(
                                                          b_countryCode
                                                                  .toString() +
                                                              bussmbl
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-Black.otf',
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black)))
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        'Business Email',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                'assets\fonst\Metropolis-Black.otf',
                                                            fontSize: 12,
                                                            color: Colors
                                                                .black26)),
                                                  ),
                                                  Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                          b_email.toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-Black.otf',
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black)))
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Divider(
                                            height: 1.0,
                                            color: Colors.black26,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Website',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(website.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'assets\fonst\Metropolis-Black.otf',
                                                      fontSize: 13,
                                                      color: Colors.black))),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Divider(
                                            height: 1.0,
                                            color: Colors.black26,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('About Your Business',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                abot_buss.toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf',
                                                    fontSize: 13,
                                                    color: Colors.black),
                                              )),
                                        ],
                                      ),
                                    )),
                                Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Expanded(
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          //height: 60,
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text('Our Products',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontFamily:
                                                          'assets\fonst\Metropolis-Black.otf',
                                                      fontSize: 12,
                                                      color: Colors.black26)),
                                            ),
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    product_name.toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            'assets\fonst\Metropolis-Black.otf',
                                                        fontSize: 13,
                                                        color: Colors.black))),
                                          ])),
                                    )),
                                // Card(
                                //     shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(10)),
                                //     child: Container(
                                //         width: MediaQuery.of(context).size.width,
                                //         height: 60,
                                //         padding: EdgeInsets.all(10.0),
                                //         child: Column(children: [
                                //           Align(
                                //             alignment: Alignment.topLeft,
                                //             child: Text('IEC Number: ',
                                //                 style: TextStyle(
                                //                     fontWeight: FontWeight.w400,
                                //                     fontFamily:
                                //                     'assets\fonst\Metropolis-Black.otf',
                                //                     fontSize: 12,
                                //                     color: Colors.black)),
                                //           ),
                                //           Align(
                                //               alignment: Alignment.topLeft,
                                //               child: Text('3242432432',
                                //                   style: TextStyle(
                                //                       fontWeight: FontWeight.w500,
                                //                       fontFamily:
                                //                       'assets\fonst\Metropolis-Black.otf',
                                //                       fontSize: 13,
                                //                       color: Colors.black))),
                                //           Align(
                                //             alignment: Alignment.topLeft,
                                //             child: Text('Our Products',
                                //                 style: TextStyle(
                                //                     fontWeight: FontWeight.w400,
                                //                     fontFamily:
                                //                     'assets\fonst\Metropolis-Black.otf',
                                //                     fontSize: 12,
                                //                     color: Colors.black)),
                                //           ),
                                //           Align(
                                //               alignment: Alignment.topLeft,
                                //               child: Text('IFB Yellow ABS, IFB Red ABS',
                                //                   style: TextStyle(
                                //                       fontWeight: FontWeight.w500,
                                //                       fontFamily:
                                //                       'assets\fonst\Metropolis-Black.otf',
                                //                       fontSize: 13,
                                //                       color: Colors.black))),
                                //           Align(
                                //             alignment: Alignment.topLeft,
                                //             child: Text('Our Products',
                                //                 style: TextStyle(
                                //                     fontWeight: FontWeight.w400,
                                //                     fontFamily:
                                //                     'assets\fonst\Metropolis-Black.otf',
                                //                     fontSize: 12,
                                //                     color: Colors.black)),
                                //           ),
                                //           Align(
                                //               alignment: Alignment.topLeft,
                                //               child: Text('IFB Yellow ABS, IFB Red ABS',
                                //                   style: TextStyle(
                                //                       fontWeight: FontWeight.w500,
                                //                       fontFamily:
                                //                       'assets\fonst\Metropolis-Black.otf',
                                //                       fontSize: 13,
                                //                       color: Colors.black))),
                                //           Align(
                                //             alignment: Alignment.topLeft,
                                //             child: Text('Our Products',
                                //                 style: TextStyle(
                                //                     fontWeight: FontWeight.w400,
                                //                     fontFamily:
                                //                     'assets\fonst\Metropolis-Black.otf',
                                //                     fontSize: 12,
                                //                     color: Colors.black)),
                                //           ),
                                //           Align(
                                //               alignment: Alignment.topLeft,
                                //               child: Text('IFB Yellow ABS, IFB Red ABS',
                                //                   style: TextStyle(
                                //                       fontWeight: FontWeight.w500,
                                //                       fontFamily:
                                //                       'assets\fonst\Metropolis-Black.otf',
                                //                       fontSize: 13,
                                //                       color: Colors.black))),
                                //           Align(
                                //             alignment: Alignment.topLeft,
                                //             child: Text('Our Products',
                                //                 style: TextStyle(
                                //                     fontWeight: FontWeight.w400,
                                //                     fontFamily:
                                //                     'assets\fonst\Metropolis-Black.otf',
                                //                     fontSize: 12,
                                //                     color: Colors.black)),
                                //           ),
                                //           Align(
                                //               alignment: Alignment.topLeft,
                                //               child: Text('IFB Yellow ABS, IFB Red ABS',
                                //                   style: TextStyle(
                                //                       fontWeight: FontWeight.w500,
                                //                       fontFamily:
                                //                       'assets\fonst\Metropolis-Black.otf',
                                //                       fontSize: 13,
                                //                       color: Colors.black))),
                                //         ])))
                                Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      //height: 320,
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('GST/VAT/TAX',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  gst_number != ""
                                                      ? Icon(
                                                    Icons
                                                        .check_circle_rounded,
                                                    color: Colors
                                                        .green.shade600,
                                                  )
                                                      : Container(),
                                                  Text(gst_number.toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontFamily:
                                                          'assets\fonst\Metropolis-Black.otf',
                                                          fontSize: 13,
                                                          color: Colors.black)),
                                                ],
                                              )),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Divider(
                                            height: 1.0,
                                            color: Colors.black26,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Pan Number: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Row(
                                            children: [
                                              pan_number!.isEmpty
                                                  ? Container()
                                                  : Icon(
                                                      Icons
                                                          .check_circle_rounded,
                                                      color:
                                                          Colors.green.shade600,
                                                    ),
                                              Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                      pan_number.toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets\fonst\Metropolis-Black.otf',
                                                          fontSize: 13,
                                                          color:
                                                              Colors.black))),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Divider(
                                            height: 1.0,
                                            color: Colors.black26,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('IEC Number: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                ex_import_number.toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf',
                                                    fontSize: 13,
                                                    color: Colors.black),
                                              )),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Divider(
                                            height: 1.0,
                                            color: Colors.black26,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Production Capacity',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                production_capacity.toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf',
                                                    fontSize: 13,
                                                    color: Colors.black),
                                              )),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Divider(
                                            height: 1.0,
                                            color: Colors.black26,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Annual Turnover',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text('2020 - 2021 :',style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily:
                                                      'assets\fonst\Metropolis-Black.otf',
                                                      fontSize: 14,
                                                      color: Colors.black)),

                                                  First_currency.toString().isNotEmpty?
                                                  Text(First_currency.toString(),style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily:
                                                      'assets\fonst\Metropolis-Black.otf',
                                                      fontSize: 13,
                                                      color: Colors.black)):Container(),


                                                  First_currency_sign.toString().isEmpty?
                                                  Text(First_currency_sign.toString(),style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily:
                                                      'assets\fonst\Metropolis-Black.otf',
                                                      fontSize: 13,
                                                      color: Colors.black))
                                                      :Container()


                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text('2021 - 2022 :',style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily:
                                                      'assets\fonst\Metropolis-Black.otf',
                                                      fontSize: 14,
                                                      color: Colors.black)),
                                                  First_currency.toString().isNotEmpty?
                                                  Text(First_currency.toString(),style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily:
                                                      'assets\fonst\Metropolis-Black.otf',
                                                      fontSize: 13,
                                                      color: Colors.black)):Container(),


                                                  Second_currency_sign.toString().isEmpty?
                                                  Text(Second_currency_sign.toString(),style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily:
                                                      'assets\fonst\Metropolis-Black.otf',
                                                      fontSize: 13,
                                                      color: Colors.black))
                                                      :Container()
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text('2022 - 2023 :',style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily:
                                                      'assets\fonst\Metropolis-Black.otf',
                                                      fontSize: 14,
                                                      color: Colors.black)),
                                                  Third_currency.toString().isNotEmpty?
                                                  Text(Third_currency.toString(),style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily:
                                                      'assets\fonst\Metropolis-Black.otf',
                                                      fontSize: 13,
                                                      color: Colors.black)):Container(),


                                                  Third_currency_sign.toString().isEmpty?
                                                  Text(Third_currency_sign.toString(),style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily:
                                                      'assets\fonst\Metropolis-Black.otf',
                                                      fontSize: 13,
                                                      color: Colors.black))
                                                      :Container()
                                                ],
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            height: 1.0,
                                            color: Colors.black26,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Premises Type',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                Premises_Type.toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf',
                                                    fontSize: 13,
                                                    color: Colors.black),
                                              )),
                                        ],
                                      ),
                                    )),
                              ],
                            )))
                      ],
                    ),
                  ),
                ],
              )
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
                : Container()),);
  }

  Future<void> sharecount() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await share_count(
        profileid.toString(), _pref.getString('user_id').toString());

    print(res);
    if (res['status'] == 1) {
      //getsimmilar = Get_deteteDocument.fromJson(res);
      // Fluttertoast.showToast(msg: res['message']);
      // remove_item(notify_id)

      if (mounted) {
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
  }

  Widget _subtabSection(BuildContext context) {
    return Container(
      child: Column(children: [
        Container(
          margin: EdgeInsets.all(10.0),
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              25.0,
            ),
          ),
          child: TabBar(
            controller: _childController,
            physics: AlwaysScrollableScrollPhysics(),
            // give the indicator a decoration (color and border radius)
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(
                25.0,
              ),
              color: Color.fromARGB(255, 0, 91, 148),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            tabs: [
              // first tab [you can add an icon using the icon property]
              Tab(
                //text: 'Quick News',
                child: Text(
                  'Buy Posts',
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
                  'Sell Posts',
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
        Expanded(
            child: TabBarView(
                // physics: (),
                physics: AlwaysScrollableScrollPhysics(),
                controller: _childController,
                // first tab bar view widget
                children: [
              Buyer_post(),
              Sale_post()
              /*news()*/
            ])

            // second tab bar view widget
            ),
      ]),
    );
  }

  Widget Buyer_post() {
    return buypostlist_data.isNotEmpty
        ? Container(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
                //future: load_category(),
                builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                //List<dynamic> users = snapshot.data as List<dynamic>;
                return GridView.builder(
                  padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    // crossAxisCount: 2,
                    // mainAxisSpacing: 5,
                    // crossAxisSpacing: 5,
                    // childAspectRatio: .90,
                    childAspectRatio: MediaQuery.of(context).size.height /
                        1300, //MediaQuery.of(context).size.aspectRatio * 1.3,
                    mainAxisSpacing: 3.0,
                    crossAxisCount: 2,
                  ),
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: scrollercontroller,
                  itemCount: buypostlist_data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    homepost.Result result = buypostlist_data[index];
                    return GestureDetector(
                      onTap: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Buyer_sell_detail(
                                prod_id: result.productId.toString(),
                                post_type: result.postType.toString(),
                              ),
                            ));
                      }),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(children: [
                          Stack(fit: StackFit.passthrough, children: <Widget>[
                            Container(
                              height: 165,
                              width: 175,
                              margin: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  //color: Colors.black26,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                /*shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10.0)),*/
                                child: Image(
                                  image: NetworkImage(
                                      result.mainproductImage.toString()),
                                  fit: BoxFit.cover,
                                  height: 150,
                                  width: 170,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 0, 148, 95),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                // color: Color.fromARGB(0,255, 255, 255),
                                child: Text(
                                    '₹' + result.productPrice.toString(),
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w800,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf',
                                        color: Colors.white)),
                              ),
                            ),
                            result.isPaidPost == 'Paid'
                                ? Positioned(
                                    top: -10,
                                    left: -30,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      /*decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0))),*/
                                      // color: Color.fromARGB(0,255, 255, 255),
                                      //child: Text('Paid', style: TextStyle(color: Colors.white)),
                                      child: Image.asset(
                                        'assets/PaidPost.png',
                                        height: 50,
                                        width: 100,
                                      ),
                                    ),
                                  )
                                : Container()
                          ]),
                          Column(
                          //  crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(result.postName.toString(),
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets\fonst\Metropolis-SemiBold.otf'),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)),
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                        result.productType.toString() +
                                            ' | ' +
                                            result.productGrade.toString(),
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.grey,
                                          fontFamily: 'Metropolis',
                                        ),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                        result.state.toString() +
                                            ',' +
                                            result.country.toString(),
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.grey,
                                          fontFamily: 'Metropolis',
                                        ),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                      result.postType.toString(),
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontFamily: 'Metropolis',
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromRGBO(0, 148, 95, 1)),
                                    ),
                                  )),
                            ],
                          )
                        ]),
                      ),
                    );
                  },
                );
              }

              return CircularProgressIndicator();
            }))
        : Center(
            child: Text('Buy Post not Found',
                style: TextStyle(color: Color.fromARGB(255, 0, 91, 148))),
          );
  }

  void _scrollercontroller() {
    if (scrollercontroller.position.pixels ==
        scrollercontroller.position.maxScrollExtent) {
      // loadmore = false;
      if (_childController.index == 0) {
        if (salepostlist_data.isNotEmpty) {
          count++;
          if (count == 1) {
            offset = offset + 31;
          } else {
            offset = offset + 20;
          }
          _onLoading();
          get_salepostlist();
        }
      } else if (_childController.index == 1) {
        if (buypostlist_data.isNotEmpty) {
          count++;
          if (count == 1) {
            offset = offset + 31;
          } else {
            offset = offset + 20;
          }
          _onLoading();
          get_buypostlist();
        }
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
                        : Container()
                ),
              ),
            ),
          ), /*Container(
            child: Stack(
              children: <Widget>[
                Container(
                  width: 300.0,
                  height: 150.0,
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    width: 300.0,
                    height: 150.0,
                    alignment: AlignmentDirectional.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const
                      */ /*  Container(
                          margin: const EdgeInsets.only(top: 25.0),
                          child: Center(
                            child: Text(
                              "loading.. wait...",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),*/ /*
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )*/
        );
      },
    );

    Future.delayed(const Duration(seconds: 5), () {
      print('exit');
      Navigator.of(dialogContext)
          .pop(); // Use dialogContext to close the dialog
      print('exit1'); // Dialog closed
    });
  }

  Widget Sale_post() {
    return salepostlist_data.isNotEmpty
        ? Container(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
                //future: load_category(),
                builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                //List<dynamic> users = snapshot.data as List<dynamic>;
                return GridView.builder(
                  padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    // crossAxisCount: 2,
                    // mainAxisSpacing: 5,
                    // crossAxisSpacing: 5,
                    // childAspectRatio: .90,
                    childAspectRatio: MediaQuery.of(context).size.height /
                        1300, //MediaQuery.of(context).size.aspectRatio * 1.3,
                    mainAxisSpacing: 3.0,
                    crossAxisCount: 2,
                  ),
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: scrollercontroller,
                  itemCount: salepostlist_data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    homepost.Result result = salepostlist_data[index];
                    return GestureDetector(
                      onTap: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Buyer_sell_detail(
                                prod_id: result.productId.toString(),
                                post_type: result.postType.toString(),
                              ),
                            ));
                      }),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(children: [
                          Stack(fit: StackFit.passthrough, children: <Widget>[
                            Container(
                              height: 165,
                              width: 175,
                              margin: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  //color: Colors.black26,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                /*shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10.0)),*/
                                child: Image(
                                  image: NetworkImage(
                                      result.mainproductImage.toString()),
                                  fit: BoxFit.cover,
                                  height: 150,
                                  width: 170,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 0, 148, 95),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                // color: Color.fromARGB(0,255, 255, 255),
                                child: Text(
                                    '₹' + result.productPrice.toString(),
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w800,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf',
                                        color: Colors.white)),
                              ),
                            ),
                            result.isPaidPost == 'Paid'
                                ? Positioned(
                                    top: -10,
                                    left: -30,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      /*decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0))),*/
                                      // color: Color.fromARGB(0,255, 255, 255),
                                      //child: Text('Paid', style: TextStyle(color: Colors.white)),
                                      child: Image.asset(
                                        'assets/PaidPost.png',
                                        height: 50,
                                        width: 100,
                                      ),
                                    ),
                                  )
                                : Container()
                          ]),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(result.postName.toString(),
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets\fonst\Metropolis-SemiBold.otf'),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)),
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                        result.productType.toString() +
                                            ' | ' +
                                            result.productGrade.toString(),
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.grey,
                                          fontFamily: 'Metropolis',
                                        ),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                        result.state.toString() +
                                            ',' +
                                            result.country.toString(),
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.grey,
                                          fontFamily: 'Metropolis',
                                        ),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                      result.postType.toString(),
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontFamily: 'Metropolis',
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromRGBO(0, 148, 95, 1)),
                                    ),
                                  )),
                            ],
                          )
                        ]),
                      ),
                    );
                  },
                );
              }

              return CircularProgressIndicator();
            }))
        : Center(
            child: Text('Sale Post not Found',
                style: TextStyle(color: Color.fromARGB(255, 0, 91, 148))),
          );
  }

  getProfiless() async {
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getbusinessprofileDetail(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        widget.user_id.toString());

    print(res);
    if (res['status'] == 1) {
      profileid = res['profile']['user_id'];
      username = res['user']['username'];
      business_name = res['profile']['business_name'];

      email = res['user']['email'] == null ? "" : res['user']['email'];
      b_email = res['profile']['other_email'] == null
          ? ""
          : res['profile']['other_email'];
      website =
          res['profile']['website'] == null ? "" : res['profile']['website'];
      bussmbl = res['profile']['business_phone'] == null
          ? ""
          : res['profile']['business_phone'];
      usermbl = res['user']['phoneno'] == null ? "" : res['user']['phoneno'];
      address = res['profile']['address'];
      post_count = res['profile']['post_count'];
      b_countryCode = res['profile']['countryCode'];
      countryCode = res['user']['countryCode'];

      view_count = res['profile']['view_count'];
      like = res['profile']['like_count'];
      reviews_count = res['profile']['reviews_count'];
      following_count = res['profile']['following_count'];
      followers_count = res['profile']['followers_count'];
      verify_status = res['profile']['verification_status'];
      like_count = res['profile']['like_counter'];
      is_follow = res['profile']['is_follow'];
      abot_buss = res['profile']['about_business'] == null
          ? ""
          : res['profile']['about_business'];
      image_url = res['user']['image_url'];

      gst_number = res['profile']['gst_tax_vat'] == null
          ? ""
          : res['profile']['gst_tax_vat'];
      Premises_Type =
          res['profile']['premises'] == null ? '' : res['profile']['premises'];
      Annual_Turnover = res['profile']['annual_turnover'] == null
          ? ''
          : res['profile']['annual_turnover'];

      pan_number = res['profile']['pan_number'] == null
          ? ''
          : res['profile']['pan_number'];
      production_capacity = res['profile']['annualcapacity'] == null
          ? ""
          : res['profile']['annualcapacity']['name'] == null
              ? ''
              : res['profile']['annualcapacity']['name'];
      ex_import_number = res['profile']['export_import_number'] == null
          ? ''
          : res['profile']['export_import_number'];

      business_type = res['profile']['business_type_name'] == null
          ? ''
          : res['profile']['business_type_name'];
      product_name = res['profile']['product_name'] == null
          ? ''
          : res['profile']['product_name'];

      product_name = res['profile']['product_name'];
      if(res['profile']['annual_turnover']!=null) {

        First_currency_sign = res['profile']['annual_turnover']['currency_20_21']==null?"":res['profile']['annual_turnover']['currency_20_21'];
        print(First_currency_sign);
        Second_currency_sign =
        res['profile']['annual_turnover']['currency_21_22']==null?"":res['profile']['annual_turnover']['currency_21_22'];
        Third_currency_sign =
        res['profile']['annual_turnover']['currency_22_23']==null?"":res['profile']['annual_turnover']['currency_22_23'];

        First_currency =
        res['profile']['annual_turnover']['amounts2021']['name']==null?"":res['profile']['annual_turnover']['amounts2021']['name'];
        Second_currency =
        res['profile']['annual_turnover']['amounts2122']['name']==null?"":res['profile']['annual_turnover']['amounts2122']['name'];
        Third_currency =
        res['profile']['annual_turnover']['amounts2223']['name']==null?"":res['profile']['annual_turnover']['amounts2223']['name'];
      }
      print('profile $profileid');
      isload = true;
      /* for(int i=0;i<stringList.length;i++){
      findcartItem(stringList[i].toString());
    }*/

      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(0)));*/
    } else {
      Fluttertoast.showToast(msg: res['message']);
      // Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {});
  }

  get_buypostlist() async {
    buyPostList = GetSalePostList();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getbuy_PostList(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        '20',
        offset.toString(),
        widget.user_id.toString());
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      buyPostList = GetSalePostList.fromJson(res);

      if (res['result'] != null) {
        jsonarray = res['result'];
        print(jsonarray);

        var color_array;
        for (var data in jsonarray) {
          homepost.Result record = homepost.Result(
              postName: data['PostName'],
              categoryName: data['CategoryName'],
              productGrade: data['ProductGrade'],
              currency: data['Currency'],
              productPrice: data['ProductPrice'],
              state: data['State'],
              country: data['Country'],
              postType: data['PostType'],
              isPaidPost: data['is_paid_post'],
              productId: data['productId'],
              productType: data['ProductType'],
              unit: data['Unit'],
              postQuntity: data['PostQuntity'],
              productStatus: data['product_status'],
              /* postColor: data['PostColor'],*/
              mainproductImage: data['mainproductImage']);

          buypostlist_data.add(record);
        }

        print(color_array);

        isload = true;
        print(buypostlist_data);
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      isload = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }

  Future<void> Profilelike() async {
    common_par getsimmilar = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await profile_like(
        profileid.toString(),
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = common_par.fromJson(res);
      // Fluttertoast.showToast(msg: res['message']);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }

  ViewItem(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          // <-- SEE HERE
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        )),
        builder: (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize:
                0.60, // Initial height as a fraction of screen height
            builder: (BuildContext context, ScrollController scrollController) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return ViewWidget(profileid.toString());
                },
              );
            })).then(
      (value) {
        /*String color = constanst.select_color_name.toString();
        var arr = color.split(',');
        print(arr);
        var stringList = arr.join(",");
        _prodcolor.text = stringList.toString();*/
      },
    );
  }

  get_salepostlist() async {
    salePostList = GetSalePostList();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getsale_PostList(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        '20',
        offset.toString(),
        widget.user_id.toString());
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      salePostList = GetSalePostList.fromJson(res);

      if (res['result'] != null) {
        jsonarray = res['result'];
        print(jsonarray);

        var color_array;
        for (var data in jsonarray) {
          homepost.Result record = homepost.Result(
              postName: data['PostName'],
              categoryName: data['CategoryName'],
              productGrade: data['ProductGrade'],
              currency: data['Currency'],
              productPrice: data['ProductPrice'],
              state: data['State'],
              country: data['Country'],
              postType: data['PostType'],
              isPaidPost: data['is_paid_post'],
              productId: data['productId'],
              productType: data['ProductType'],
              unit: data['Unit'],
              postQuntity: data['PostQuntity'],
              productStatus: data['product_status'],
              /* postColor: data['PostColor'],*/
              mainproductImage: data['mainproductImage']);

          salepostlist_data.add(record);
        }

        print(color_array);

        isload = true;
        print(salepostlist_data);
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      isload = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }

  void getPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
    String version = packageInfo!.version;
    String buildNumber = packageInfo!.buildNumber;
    print(
        "App Name : ${appName}, App Package Name: ${packageName},App Version: ${version}, App build Number: ${buildNumber}");
  }

  void shareImage({required String url, required String title}) async {
    final imageurl = url;
    final uri = Uri.parse(imageurl);
    final response = await http.get(uri);
    final bytes = response.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);
    await Share.shareFiles([path],
        text: title +
            "\t" +
            "\n" +
            "\n" +
            'Plastic4trade is a Worldwide B2B Plastic Raw Material, Scrap, Machinery & Finished Goods Trading App: https://play.google.com/store/apps/details?id=' +
            packageName!);
  }
}

class ViewWidget extends StatefulWidget {
  String profileid;
  ViewWidget(this.profileid, {Key? key}) : super(key: key);

  @override
  State<ViewWidget> createState() => _ViewState();
}

class _ViewState extends State<ViewWidget> with SingleTickerProviderStateMixin {
  int? _radioValue = 0;
  int? _managerValue = 0;
  String? assignedName;
  bool? isload;
  late TabController _tabController;
  List<like.Data> dataList = [];
  List<view_pro.Data> dataList1 = [];
  List<share_pro.Data> dataList2 = [];
  //List<Data> dataList2=[];
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 3, vsync: this);
    get_like();
    get_view();
    get_share();
  }

  get_like() async {
    Get_likeUser common = Get_likeUser();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await get_profileliked_user(widget.profileid);

    print(res);
    if (res['status'] == 1) {
      common = Get_likeUser.fromJson(res);
      dataList = common.data ?? [];
      print(dataList);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {});
  }

  get_view() async {
    Get_viewUser common = Get_viewUser();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var res = await get_profileviewd_user(widget.profileid);
    print(res);
    if (res['status'] == 1) {
      common = Get_viewUser.fromJson(res);
      dataList1 = common.data ?? [];
      print(dataList1);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {});
  }

  get_share() async {
    Get_shareUser common = Get_shareUser();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await get_profiles_share(widget.profileid);

    print(res);
    if (res['status'] == 1) {
      common = Get_shareUser.fromJson(res);
      dataList2 = common.data ?? [];
      print(dataList2);
      isload = true;
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isload == true
        ? Column(
            children: [
              SizedBox(height: 5),
              Image.asset(
                'assets/hori_line.png',
                width: 150,
                height: 5,
              ),
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Like'),
                  Tab(text: 'View'),
                  Tab(text: 'Share'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    /* ListView.builder(
                  shrinkWrap: true,
                  itemCount: view.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(like[index].title,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                      leading:   CircleAvatar(
                        radius: 16.0,
                        backgroundImage:
                        AssetImage(view[index].icon) as ImageProvider,
                        //File imageFile = File(pickedFile.path);

                        backgroundColor: Color.fromARGB(255, 240, 238, 238),
                      ),
                    );
                  }),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: view.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(like[index].title,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                      leading:   CircleAvatar(
                        radius: 16.0,
                        backgroundImage:
                        AssetImage(view[index].icon) as ImageProvider,
                        //File imageFile = File(pickedFile.path);

                        backgroundColor: Color.fromARGB(255, 240, 238, 238),
                      ),
                    );
                  }),
             ,*/

                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: dataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(dataList[index].username.toString(),
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily:
                                        'assets\fonst\Metropolis-Black.otf')),
                            leading: CircleAvatar(
                              radius: 16.0,
                              backgroundImage: NetworkImage(dataList[index]
                                  .imageUrl
                                  .toString()), //File imageFile = File(pickedFile.path);

                              backgroundColor:
                                  Color.fromARGB(255, 240, 238, 238),
                            ),
                          );
                        }),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: dataList1.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: dataList1[index].username != null
                                ? Text(dataList1[index].username.toString(),
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf'))
                                : Text('unknow',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf')),
                            leading: CircleAvatar(
                              radius: 16.0,
                              backgroundImage: dataList1[index].imageUrl != null
                                  ? NetworkImage(
                                      dataList1[index].imageUrl.toString())
                                  : AssetImage('assets/more.png')
                                      as ImageProvider,
                              backgroundColor:
                                  Color.fromARGB(255, 240, 238, 238),
                            ),
                          );
                        }),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: dataList2.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(dataList2[index].username.toString(),
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily:
                                        'assets\fonst\Metropolis-Black.otf')),
                            leading: CircleAvatar(
                              radius: 16.0,
                              backgroundImage: NetworkImage(
                                  dataList2[index].imageUrl.toString()),

                              //File imageFile = File(pickedFile.path);

                              backgroundColor:
                                  Color.fromARGB(255, 240, 238, 238),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
