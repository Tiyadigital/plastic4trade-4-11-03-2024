// ignore_for_file: avoid_print, camel_case_types, non_constant_identifier_names, invalid_return_type_for_catch_error, unnecessary_null_comparison, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';

import 'package:Plastic4trade/model/GetSalePostList.dart' as homepost;
import 'package:Plastic4trade/model/Get_likeUser.dart' as like;
import 'package:Plastic4trade/model/Get_shareUser.dart' as share_pro;
import 'package:Plastic4trade/model/Get_viewUser.dart' as view_pro;
import 'package:Plastic4trade/screen/Bussinessinfo.dart';
import 'package:Plastic4trade/utill/constant.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api_interface.dart';
import '../model/GetSalePostList.dart';
import '../model/Get_likeUser.dart';
import '../model/Get_shareUser.dart';
import '../model/Get_viewUser.dart';
import '../widget/MainScreen.dart';
import 'Buyer_sell_detail.dart';
import 'Follower_Following.dart';
import 'Review.dart';

class bussinessprofile extends StatefulWidget {
  const bussinessprofile({Key? key}) : super(key: key);

  @override
  State<bussinessprofile> createState() => _bussinessprofileState();
}

class _bussinessprofileState extends State<bussinessprofile>
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
      verify_status,
      instagram_url,
      youtube_url,
      facebook_url,
      linkedin_url,
      twitter_url,
      telegram_url,
      other_email_url,
      business_phone_url;
  String? ex_import_number,
      production_capacity,
      gst_number,
      Annual_Turnover,
      Premises_Type,
      business_type,
      is_follow,

      abot_buss,
      pan_number,
      product_name,
      firstyear_amount,
      secondyear_amount,
      thirdyear_amount;
  String? First_currency_sign = "",
      Second_currency_sign = "",
      Third_currency_sign = "";
  int? view_count, like, reviews_count, following_count, followers_count,is_prime;
  bool? isload;
  GetSalePostList salePostList = GetSalePostList();
  GetSalePostList buyPostList = GetSalePostList();
  int offset = 0, post_count = 0;
  int count = 0;
  String? profileid;
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
      Fluttertoast.showToast(
          timeInSecForIosWeb: 2, msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      getPackage();
      getProfiless();
      get_buypostlist();
      get_salepostlist();

      // get_data();
    }
  }

  @override
  Widget build(BuildContext context) {
    return init(context);
  }

  Widget init(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onbackpress(context),
      child: Scaffold(
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
          actions: [
            SizedBox(
                width: 45,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Bussinessinfo()));
                  },
                  icon: Image.asset(
                    'assets/edit.png',
                  ),
                )),
          ],
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
                      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 5.0, 0.0),
                      child: Column(children: [
                        Column(children: [
                          Container(
                            margin: const EdgeInsets.all(5.0),
                            height: 140,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // Align children in the center horizontally
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
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50.0)),
                                        border: Border.all(
                                          color: const Color(0xffFFC107),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // Adjust alignment and padding of the "Premium" label
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: const Color(0xffFFC107),
                                      ),
                                      child:  Text(
                                        (is_prime == 0) ? "Free":
                                        'Premium',
                                        style: const TextStyle(fontSize: 9),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    width:
                                        10), // Add spacing between the two columns
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // Align children to the start (left) side
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.1,
                                        child: Text(
                                          business_name.toString(),
                                          softWrap: true,
                                          style: const TextStyle(
                                            fontSize: 19.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets/fonst/Metropolis-SemiBold.otf',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      // Add spacing between the business name and contact details
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          // Align children to the start (left) side
                                          children: [
                                            Row(
                                              children: [
                                                const ImageIcon(AssetImage(
                                                    'assets/user.png')),
                                                const SizedBox(width: 5),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.3,
                                                  child: Text(
                                                    username.toString(),
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'assets/fonst/Metropolis-SemiBold.otf',
                                                    ),
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Row(
                                              children: [
                                                const ImageIcon(AssetImage(
                                                    'assets/call.png')),
                                                const SizedBox(width: 5),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.3,
                                                  child: GestureDetector(
                                                    onTap: () => launchUrl(
                                                      Uri.parse(
                                                          'tel:$countryCode + $usermbl'),
                                                      mode: LaunchMode
                                                          .externalApplication,
                                                    ),
                                                    child: Text(
                                                      softWrap: true,
                                                      countryCode.toString() +
                                                          usermbl.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-SemiBold.otf',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Row(
                                              children: [
                                                const ImageIcon(AssetImage(
                                                    'assets/location.png')),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.3,
                                                    child: Text(
                                                      address.toString(),
                                                      softWrap: true,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-SemiBold.otf',
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              5.0, 5.0, 5.0, 5.0),
                                          child: Row(children: [
                                            Column(
                                              children: [
                                                verify_status == "1"
                                                    ? Row(children: const [
                                                        Text('Unverified'),
                                                      ])
                                                    : verify_status == "2"
                                                        ? Row(
                                                            children: const [
                                                              Image(
                                                                  image: AssetImage(
                                                                      'assets/verify.png')),
                                                              Text(
                                                                  'Verified'),
                                                            ],
                                                          )
                                                        : verify_status == "3"
                                                            ? Row(
                                                                children: [
                                                                  const Image(
                                                                      image: AssetImage(
                                                                          'assets/verify.png')),
                                                                  const Text(
                                                                      'Verified'),
                                                                  const SizedBox(
                                                                      width: 5),
                                                                  Row(
                                                                    children: const [
                                                                      Image(
                                                                        image: AssetImage(
                                                                            'assets/trust.png'),
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            30,
                                                                      ),
                                                                      Text(
                                                                          'Trusted'),
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
                                ),
                              ],
                            ),
                          ),
                        ]),

                        //category(),

                        //SizedBox(height: 10,),
                      ])),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 55,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const follower(
                                      initialIndex: 0,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(followers_count.toString(),
                                        style: const TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets/fonst/Metropolis-SemiBold.otf')),
                                    const Text('Followers',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets/fonst/Metropolis-SemiBold.otf')),
                                  ]),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  const follower(
                                      initialIndex: 1,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(following_count.toString(),
                                      style: const TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets/fonst/Metropolis-SemiBold.otf')),
                                  const Text('Following',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets/fonst/Metropolis-SemiBold.otf')),
                                ],
                              ),
                            ),
                          ])),
                  Container(
                      margin: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      height: 60,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            Container(
                                padding: const EdgeInsets.all(5.0),
                                margin: const EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 0.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(18)),
                                ),
                                child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 4.2,
                                    height: 25,
                                    child: GestureDetector(
                                      // onTap: () => launchUrl(
                                      //   Uri.parse('mailto:$other_email_url!'),
                                      //   mode: LaunchMode.externalApplication,
                                      // ),
                                      child: Row(
                                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: const [
                                          ImageIcon(
                                              AssetImage('assets/sms.png')),
                                          Text(' Chat',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-Black.otf',
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    ))),
                            Container(
                                padding: const EdgeInsets.all(5.0),
                                margin: const EdgeInsets.fromLTRB(
                                    5.0, 0.0, 5.0, 0.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(18)),
                                ),
                                child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3.8,
                                    height: 25,
                                    child: GestureDetector(
                                      onTap: () {
                                        launchUrl(
                                          Uri.parse('https://wa.me/$bussmbl'),
                                          mode: LaunchMode.externalApplication,
                                        );

                                        // print("WHATSAPP LINK  ===  ${'https://wa.me/$bussmbl'}");
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(('assets/whatsapp.png')),
                                          const Text('WhatsApp',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-Black.otf',
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    ))),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () => launchUrl(
                                          Uri.parse(facebook_url!),
                                          mode: LaunchMode.externalApplication,
                                        ),
                                    child: Image.asset(
                                      'assets/facebook.png',
                                      width: 30,
                                      height: 30,
                                    )),
                                IconButton(
                                    onPressed: () => launchUrl(
                                          Uri.parse(instagram_url!),
                                          mode: LaunchMode.externalApplication,
                                        ),
                                    icon: Image.asset('assets/instagram.png')),
                                IconButton(
                                    onPressed: () => launchUrl(
                                          Uri.parse(linkedin_url!),
                                          mode: LaunchMode.externalApplication,
                                        ),
                                    icon: Image.asset('assets/linkdin.png')),
                                IconButton(
                                    onPressed: () => launchUrl(
                                          Uri.parse(youtube_url!),
                                          mode: LaunchMode.externalApplication,
                                        ),
                                    icon: Image.asset('assets/youtube.png')),
                                IconButton(
                                    onPressed: () => launchUrl(
                                          Uri.parse(twitter_url!),
                                          mode: LaunchMode.externalApplication,
                                        ),
                                    icon: Image.asset('assets/Twitter.png')),
                              ],
                            )
                          ]))),
                  const Divider(
                    color: Colors.black26,
                    height: 2.0,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          margin:
                              const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
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
                                const SizedBox(
                                  width: 2,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    ViewItem(context);
                                  },
                                  child: Text('Like ($like_count)',
                                      style: const TextStyle(
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
                          margin: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
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
                                              builder: (context) =>
                                                  review(profileid!)));
                                    },
                                    child: Image.asset(
                                      'assets/star.png',
                                      color: Colors.black,
                                    )),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text('Reviews ($reviews_count)',
                                    style: const TextStyle(
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
                          margin: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
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
                                    child: const Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.black54,
                                    )),
                                Text('Views ($view_count)',
                                    style: const TextStyle(
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
                          margin: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
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
                                const SizedBox(
                                  width: 2,
                                ),
                                GestureDetector(
                                  child: const Text('Share',
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
                  const Divider(
                    color: Colors.black26,
                    height: 2.0,
                  ),
                  TabBar(
                    controller: _parentController,
                    tabs: [
                      Tab(text: 'Product Catalogue ($post_count)'),
                      const Tab(text: 'Business Info'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _parentController,
                      children: [
                        _subtabSection(context),
                        Container(
                            margin: const EdgeInsets.all(20.0),
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
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Nature Of Business',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  business_type.toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'assets/fonst/Metropolis-Black.otf',
                                                      fontSize: 13,
                                                      color: Colors.black))),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const Divider(
                                            height: 1.0,
                                            color: Colors.black26,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                          'Business Phone',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  'assets/fonst/Metropolis-Black.otf',
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black26)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: GestureDetector(
                                                        onTap: () => launchUrl(
                                                          Uri.parse(
                                                              'tel:$b_countryCode + $bussmbl'),
                                                          mode: LaunchMode
                                                              .externalApplication,
                                                        ),
                                                        child: Text(
                                                            b_countryCode
                                                                    .toString() +
                                                                bussmbl
                                                                    .toString(),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'assets/fonst/Metropolis-Black.otf',
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        'Business Email',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                'assets/fonst/Metropolis-Black.otf',
                                                            fontSize: 12,
                                                            color: Colors
                                                                .black26)),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    child: Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: GestureDetector(
                                                          onTap: () =>
                                                              launchUrl(
                                                            Uri.parse(
                                                                'mailto:${b_email.toString()}'),
                                                            mode: LaunchMode
                                                                .externalApplication,
                                                          ),
                                                          child: Text(
                                                              b_email
                                                                  .toString(),
                                                              softWrap: true,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      'assets/fonst/Metropolis-Black.otf',
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black)),
                                                        )),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const Divider(
                                            height: 1.0,
                                            color: Colors.black26,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Website',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: GestureDetector(
                                                // onTap: () => launchUrl(
                                                //   Uri.parse(
                                                //       website.toString()),
                                                //   mode: LaunchMode
                                                //       .externalApplication,
                                                // ),
                                                onTap: () {
                                                  final urlString =
                                                      website.toString();
                                                  final formattedUrl = !urlString
                                                              .startsWith(
                                                                  'http://') &&
                                                          !urlString.startsWith(
                                                              'https://')
                                                      ? 'https://$urlString'
                                                      : urlString;

                                                  launch(formattedUrl,
                                                          forceSafariVC: false,
                                                          forceWebView: false,
                                                          enableJavaScript:
                                                              true)
                                                      .catchError((e) => print(
                                                          'Error launching URL: $e'));
                                                },
                                                child: Text(website.toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf',
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              )),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const Divider(
                                            height: 1.0,
                                            color: Colors.black26,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('About Your Business',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ...buildWidgets(abot_buss ?? ""),
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                                Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 60,
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(children: [
                                          const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Our Products',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Text(
                                                    product_name.toString(),
                                                    softWrap: true,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf',
                                                        fontSize: 13,
                                                        color: Colors.black)),
                                              )),
                                        ]))),
                                Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      //height: 320,
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('GST/VAT/TAX',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
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
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf',
                                                          fontSize: 13,
                                                          color: Colors.black)),
                                                ],
                                              )),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const Divider(
                                            height: 1.0,
                                            color: Colors.black26,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Pan Number: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Row(
                                            children: [
                                              pan_number == ""
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
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf',
                                                          fontSize: 13,
                                                          color:
                                                              Colors.black))),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const Divider(
                                            height: 1.0,
                                            color: Colors.black26,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('IEC Number: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                ex_import_number.toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
                                                    fontSize: 13,
                                                    color: Colors.black),
                                              )),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const Divider(
                                            height: 1.0,
                                            color: Colors.black26,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Production Capacity',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                production_capacity.toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
                                                    fontSize: 13,
                                                    color: Colors.black),
                                              )),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const Divider(
                                            height: 1.0,
                                            color: Colors.black26,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Annual Turnover',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                      '2020 - 2021 : $firstyear_amount',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf',
                                                          fontSize: 14,
                                                          color: Colors.black)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      '2021 - 2022 : $secondyear_amount',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf',
                                                          fontSize: 14,
                                                          color: Colors.black)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      '2022 - 2023 : $thirdyear_amount',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf',
                                                          fontSize: 14,
                                                          color: Colors.black)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const Divider(
                                            height: 1.0,
                                            color: Colors.black26,
                                          ),
                                          const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Premises Type',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
                                                    fontSize: 12,
                                                    color: Colors.black26)),
                                          ),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                Premises_Type.toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
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
                        : Container()),
      ),
    );
  }

  List<Widget> buildWidgets(String text) {
    List<Widget> widgets = [];
    final lines = text.split('\n');

    for (var line in lines) {
      widgets.add(buildLineWidget(line));
    }

    return widgets;
  }

  Widget buildLineWidget(String line) {
    final words = line.split(' ');

    List<Widget> lineWidgets = [];
    for (var word in words) {
      if (RegExp(r'https?://[^\s/$.?#].[^\s]*').hasMatch(word)) {
        // Handle links
        lineWidgets.add(GestureDetector(
          onTap: () async {
            if (await canLaunch(word)) {
              await launch(word);
            } else {
              throw 'Could not launch $word';
            }
          },
          child: Text(
            word,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ));
      } else if (RegExp(r'\b\d{10}\b').hasMatch(word)) {
        // Handle phone numbers
        String phoneNumber = RegExp(r'\b\d{10}\b').stringMatch(word)!;
        lineWidgets.add(GestureDetector(
          onTap: () async {
            final url = 'tel:$phoneNumber';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: Text(
            phoneNumber,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ));
      } else if (word.endsWith('.com') || word.endsWith('.in')) {
        // Handle website URLs with .com or .in extension
        String url = word;
        if (!url.startsWith('http')) {
          url = 'http://$url';
        }
        lineWidgets.add(GestureDetector(
          onTap: () async {
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: Text(
            word,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ));
      } else {
        // Handle regular text
        lineWidgets.add(Text(
          word,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ));
      }
      lineWidgets
          .add(const SizedBox(width: 4)); // Add some spacing between words
    }
    return Wrap(
      direction: Axis.horizontal,
      // This ensures the children are laid out horizontally
      children: lineWidgets,
    );
  }

  Future<void> sharecount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await share_count(pref.getString('user_id').toString(),
        pref.getString('user_id').toString());

    if (res['status'] == 1) {
      if (mounted) {
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
  }

  Widget _subtabSection(BuildContext context) {
    return Column(children: [
      Container(
        margin: const EdgeInsets.all(10.0),
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            25.0,
          ),
        ),
        child: TabBar(
          controller: _childController,
          physics: const AlwaysScrollableScrollPhysics(),
          // give the indicator a decoration (color and border radius)
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(
              25.0,
            ),
            color: const Color.fromARGB(255, 0, 91, 148),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          tabs: const [
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
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _childController,
              // first tab bar view widget
              children: [
            Buyer_post(),
            Sale_post()
            /*news()*/
          ])

          // second tab bar view widget
          ),
    ]);
  }

  Widget Buyer_post() {
    return buypostlist_data.isNotEmpty
        ? Container(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
                //future: load_category(),
                builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                //List<dynamic> users = snapshot.data as List<dynamic>;
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
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
                  physics: const AlwaysScrollableScrollPhysics(),
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
                              margin: const EdgeInsets.all(5.0),
                              decoration: const BoxDecoration(
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 5.0),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 0, 148, 95),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                // color: Color.fromARGB(0,255, 255, 255),
                                child: Text(
                                    '₹${result.productPrice}',
                                    style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w800,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf',
                                        color: Colors.white)),
                              ),
                            ),
                            result.isPaidPost == 'Paid'
                                ? Positioned(
                                    top: -10,
                                    left: -30,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
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
                                        const EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(result.postName.toString(),
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets/fonst/Metropolis-SemiBold.otf'),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)),
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                        '${result.productType} | ${result.productGrade}',
                                        style: const TextStyle(
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
                                        const EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                        '${result.state},${result.country}',
                                        style: const TextStyle(
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
                                        const EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                      result.postType.toString(),
                                      style: const TextStyle(
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

            }))
        : const Center(
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                            : Container()),
              ),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(dialogContext)
          .pop(); // Use dialogContext to close the dialog
      // Dialog closed
    });
  }

  Future<bool> _onbackpress(BuildContext context) async {
    if (constanst.isFromNotification) {
      constanst.isFromNotification = false;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(0)));
    }
    return Future.value(true);
  }

  Widget Sale_post() {
    return salepostlist_data.isNotEmpty
        ? Container(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
                //future: load_category(),
                builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                //List<dynamic> users = snapshot.data as List<dynamic>;
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
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
                  physics: const AlwaysScrollableScrollPhysics(),
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
                              margin: const EdgeInsets.all(5.0),
                              decoration: const BoxDecoration(
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 5.0),
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 0, 148, 95),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                // color: Color.fromARGB(0,255, 255, 255),
                                child: Text(
                                    '₹${result.productPrice}',
                                    style: const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w800,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf',
                                        color: Colors.white)),
                              ),
                            ),
                            result.isPaidPost == 'Paid'
                                ? Positioned(
                                    top: -10,
                                    left: -30,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
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
                                        const EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(result.postName.toString(),
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets/fonst/Metropolis-SemiBold.otf'),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)),
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                        '${result.productType} | ${result.productGrade}',
                                        style: const TextStyle(
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
                                        const EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                        '${result.state},${result.country}',
                                        style: const TextStyle(
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
                                        const EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                      result.postType.toString(),
                                      style: const TextStyle(
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
            }))
        : const Center(
            child: Text('Sale Post not Found',
                style: TextStyle(color: Color.fromARGB(255, 0, 91, 148))),
          );
  }

  getProfiless() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getbussinessprofile(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );

    if (res['status'] == 1) {
      profileid = res['profile']['user_id'];
      username = res['user']['username'];
      instagram_url = res['profile']['instagram_link'];
      youtube_url = res['profile']['youtube_link'];
      facebook_url = res['profile']['facebook_link'];
      linkedin_url = res['profile']['linkedin_link'];
      twitter_url = res['profile']['twitter_link'];
      telegram_url = res['profile']['telegram_link'];
      business_phone_url = res['user']['business_phone'];
      other_email_url = res['user']['other_email'];
      business_name = res['profile']['business_name'];

      email = res['user']['email'] ?? "";
      b_email = res['profile']['other_email'] ?? "";
      website = res['profile']['website'] ?? "";
      bussmbl = res['profile']['business_phone'] ?? "";
      usermbl = res['user']['phoneno'] ?? "";
      address = res['profile']['address'];
      post_count = res['profile']['post_count'];
      b_countryCode = res['profile']['countryCode'];
      countryCode = res['user']['countryCode'];

      // log("RESPONSE === $res");
      log("MOBILE NUMBER  === $business_phone_url");
      log("MOBILE NUMBER URL === $bussmbl");

      if (res['annual_turnover'] != null) {
        if (res['annual_turnover']['amounts2021'] != null) {
          firstyear_amount = res['annual_turnover']['amounts2021'] == null
              ? ""
              : res['annual_turnover']['amounts2021']['name'];
        } else {
          firstyear_amount = "";
        }
        if (res['annual_turnover']['amounts2122'] != null) {
          secondyear_amount = res['annual_turnover']['amounts2122'] == null
              ? ""
              : res['annual_turnover']['amounts2122']['name'];
        } else {
          secondyear_amount = "";
        }
        if (res['annual_turnover']['amounts2223'] != null) {
          thirdyear_amount = res['annual_turnover']['amounts2223'] == null
              ? ""
              : res['annual_turnover']['amounts2223']['name'];
        } else {
          thirdyear_amount = "";
        }

        First_currency_sign = res['annual_turnover']['currency_20_21'] ?? "";
        Second_currency_sign = res['annual_turnover']['currency_21_22'] ?? "";
        Third_currency_sign = res['annual_turnover']['currency_22_23'] ?? "";
      } else {
        firstyear_amount = '';
        secondyear_amount = '';
        thirdyear_amount = '';
        First_currency_sign = '';
        Second_currency_sign = '';
        Third_currency_sign = '';
      }

      view_count = res['profile']['view_count'];
      verify_status = res['profile']['verification_status'];
      like = res['profile']['like_count'];
      reviews_count = res['profile']['reviews_count'];
      following_count = res['profile']['following_count'];
      followers_count = res['profile']['followers_count'];

      like_count = res['profile']['like_counter'];
      is_follow = res['profile']['is_follow'];
      abot_buss = res['profile']['about_business'] ?? "";
      image_url = res['user']['image_url'];
      is_prime = res['user']['is_prime'];

      gst_number = res['profile']['gst_tax_vat'] ?? "";
      Premises_Type = res['profile']['premises'] ?? '';
      Annual_Turnover = res['profile']['annual_turnover'] ?? '';

      pan_number = res['profile']['pan_number'] ?? '';

      ex_import_number = res['profile']['export_import_number'] ?? '';

      if (res['profile']['production_capacity'] != null) {
        production_capacity = res['profile']['annualcapacity']['name'] ?? '';
      } else {
        production_capacity = '';
      }

      business_type = res['profile']['business_type_name'] ?? '';
      product_name = res['profile']['product_name'] ?? '';

      if (res['profile']['annual_turnover'] != null) {
        First_currency_sign =
            res['profile']['annual_turnover']['currency_20_21'] ?? "";
        Second_currency_sign =
            res['profile']['annual_turnover']['currency_21_22'] ?? "";
        Third_currency_sign =
            res['profile']['annual_turnover']['currency_22_23'] ?? "";
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {});
  }

  get_buypostlist() async {
    buyPostList = GetSalePostList();
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getbuy_PostList(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        '20',
        offset.toString(),
        pref.getString('user_id').toString());
    var jsonArray;
    if (res['status'] == 1) {
      buyPostList = GetSalePostList.fromJson(res);

      if (res['result'] != null) {
        jsonArray = res['result'];

        for (var data in jsonArray) {
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

        isload = true;
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      isload = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonArray;
  }

  Future<void> Profilelike() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await profile_like(
        profileid.toString(),
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString());

    var jsonArray;
    if (res['status'] == 1) {
      // Fluttertoast.showToast(msg: res['message']);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonArray;
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
                  return const ViewWidget();
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
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getsale_PostList(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        '20',
        offset.toString(),
        pref.getString('user_id').toString());
    var jsonArray;
    if (res['status'] == 1) {
      salePostList = GetSalePostList.fromJson(res);

      if (res['result'] != null) {
        jsonArray = res['result'];

        for (var data in jsonArray) {
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

        isload = true;
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      isload = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonArray;
  }

  void getPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
    packageName = packageInfo!.packageName;
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
  const ViewWidget({Key? key}) : super(key: key);

  @override
  State<ViewWidget> createState() => _ViewState();
}

class _ViewState extends State<ViewWidget> with SingleTickerProviderStateMixin {
  String? assignedName;
  bool? isload;
  late TabController _tabController;
  List<like.Data> dataList = [];
  List<view_pro.Data> dataList1 = [];
  List<share_pro.Data> dataList2 = [];

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _tabController = TabController(length: 3, vsync: this);
    get_like();
    get_view();
    get_share();
  }

  get_like() async {
    Get_likeUser common = Get_likeUser();
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res =
        await get_profileliked_user(pref.getString('user_id').toString());

    if (res['status'] == 1) {
      common = Get_likeUser.fromJson(res);
      dataList = common.data ?? [];
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {});
  }

  get_view() async {
    Get_viewUser common = Get_viewUser();
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res =
        await get_profileviewd_user(pref.getString('user_id').toString());
    if (res['status'] == 1) {
      common = Get_viewUser.fromJson(res);
      dataList1 = common.data ?? [];
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {});
  }

  get_share() async {
    Get_shareUser common = Get_shareUser();
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await get_profiles_share(pref.getString('user_id').toString());

    if (res['status'] == 1) {
      common = Get_shareUser.fromJson(res);
      dataList2 = common.data ?? [];
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
              const SizedBox(height: 5),
              Image.asset(
                'assets/hori_line.png',
                width: 150,
                height: 5,
              ),
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Like'),
                  Tab(text: 'View'),
                  Tab(text: 'Share'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: dataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(dataList[index].username.toString(),
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf')),
                            leading: CircleAvatar(
                              radius: 16.0,
                              backgroundImage: NetworkImage(
                                  dataList[index].imageUrl.toString()),
                              backgroundColor:
                                  const Color.fromARGB(255, 240, 238, 238),
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
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf'))
                                : const Text('unknow',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf')),
                            leading: CircleAvatar(
                              radius: 16.0,
                              backgroundImage: dataList1[index].imageUrl != null
                                  ? NetworkImage(
                                      dataList1[index].imageUrl.toString())
                                  : const AssetImage('assets/more.png')
                                      as ImageProvider,
                              backgroundColor:
                                  const Color.fromARGB(255, 240, 238, 238),
                            ),
                          );
                        }),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: dataList2.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(dataList2[index].username.toString(),
                                style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf')),
                            leading: CircleAvatar(
                              radius: 16.0,
                              backgroundImage: NetworkImage(
                                  dataList2[index].imageUrl.toString()),

                              //File imageFile = File(pickedFile.path);

                              backgroundColor:
                                  const Color.fromARGB(255, 240, 238, 238),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ],
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
