// ignore_for_file: non_constant_identifier_names, camel_case_types, must_be_immutable, unnecessary_null_comparison, depend_on_referenced_packages, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, avoid_print, invalid_return_type_for_catch_error

import 'dart:developer';
import 'dart:io';

import 'package:Plastic4trade/model/GetSalePostList.dart' as homepost;
import 'package:Plastic4trade/model/Get_likeUser.dart' as like;
import 'package:Plastic4trade/model/Get_shareUser.dart' as share_pro;
import 'package:Plastic4trade/model/Get_viewUser.dart' as view_pro;
import 'package:Plastic4trade/model/other_user_follower.dart' as getfllow;
import 'package:Plastic4trade/model/other_user_following.dart' as getfllowing;
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
import 'Buyer_sell_detail.dart';
import 'ChartDetail.dart';
import 'Review.dart';

int? following_count, followers_count;

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
      pan_number;

  String? First_currency = "", Second_currency = "", Third_currency = "";
  String? First_currency_sign = "",
      Second_currency_sign = "",
      Third_currency_sign = "";
  int? view_count,
      like,
      reviews_count,
      following_count,
      followers_count,
      is_prime;
  bool? isload;
  GetSalePostList salePostList = GetSalePostList();
  GetSalePostList buyPostList = GetSalePostList();
  int offset = 0;
  int count = 0;
  String profileid = "", post_count = "0";
  String? packageName;
  PackageInfo? packageInfo;
  List<homepost.PostColor> colors = [];
  List<homepost.Result> salepostlist_data = [];
  List<homepost.Result> buypostlist_data = [];
  List<homepost.Result>? resultList;

  @override
  void initState() {
    _parentController = TabController(length: 2, vsync: this);
    _childController = TabController(length: 2, vsync: this,initialIndex: buypostlist_data.isEmpty ? 1 : 0);
    scrollercontroller.addListener(_scrollercontroller);
    checknetowork();
    super.initState();
  }

  @override
  void dispose() {
    _parentController.dispose();
    _childController.dispose();
    super.dispose();
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      print("USER ID === ${widget.user_id}");
      getPackage();
      getProfiless();
      get_buypostlist();
      get_salepostlist();
    }
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Widget init() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Business Profile',
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
      ),
      body: isload == true
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
                  child: Column(children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5.0, left: 2.0, right: 5.0),
                      height: 140,
                      child: Row(
                        children: [
                          Column(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 110.0,
                                height: 110.0,
                                decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      image_url.toString(),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: OvalBorder(
                                    side: BorderSide(
                                      width: 3,
                                      strokeAlign: BorderSide.strokeAlignOutside,
                                      color: (is_prime == 0) ? const Color(0xFF005C94) :  const Color(0xFFFFC107),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 54,
                                height: 17,
                                alignment: Alignment.center,
                                //padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: (is_prime == 0) ? const Color(0xFF005C94) :  const Color(0xFFFFC107),
                                ),
                                child: Text(
                                  (is_prime == 0) ? "Free" : 'Premium',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: (is_prime == 0) ? Colors.white : Colors.black,
                                    fontSize: 10,
                                    fontFamily:
                                    'assets/fonst/Metropolis-SemiBold.otf',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width /
                                        1.9,
                                child: Text(
                                  business_name.toString(),
                                  softWrap: false,
                                  style: const TextStyle(
                                    overflow: TextOverflow.visible,
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    fontFamily:
                                        'assets/fonst/Metropolis-SemiBold.otf',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              SizedBox(
                                width: MediaQuery.of(context).size.width /1.8,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const ImageIcon(
                                          AssetImage('assets/user.png'),
                                        ),
                                        const SizedBox(width: 5),
                                        SizedBox(
                                          //width: MediaQuery.of(context).size.width/2.3,
                                          child: Text(
                                              username.toString(),
                                              //softWrap: true,
                                              style: const TextStyle(
                                                overflow: TextOverflow
                                                    .visible,
                                                fontSize: 16.0,
                                                fontWeight:
                                                    FontWeight.w400,
                                                color: Colors.black,
                                                fontFamily:
                                                    'assets/fonst/Metropolis-SemiBold.otf',
                                              ),
                                              softWrap: false,
                                              maxLines: 1,
                                              overflow: TextOverflow
                                                  .ellipsis),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const ImageIcon(
                                          AssetImage('assets/call.png'),
                                        ),
                                        const SizedBox(width: 5),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.5,
                                          child: GestureDetector(
                                            onTap: () => launchUrl(
                                              Uri.parse(
                                                  'tel:$countryCode$usermbl'
                                                      ///$countryCode + $usermbl'
                                              ),
                                              mode: LaunchMode
                                                  .externalApplication,
                                            ),
                                            child: Text('$countryCode$usermbl',
                                              overflow:
                                                  TextOverflow.visible,
                                              softWrap: false,
                                              maxLines: 1,
                                              // countryCode.toString() +
                                              //     usermbl.toString(),
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
                                        const ImageIcon(
                                          AssetImage(
                                              'assets/location.png'),
                                        ),
                                        const SizedBox(width: 5),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.2,
                                          child: Text(
                                            address.toString(),
                                            softWrap: false,
                                            style: const TextStyle(
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              fontSize: 16.0,
                                              fontWeight:
                                                  FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-SemiBold.otf',
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(
                                    5.0, 10.0, 5.0, 5.0),
                                child: Row(
                                  children: [
                                    verify_status == "1"
                                        ? const Row(children: [
                                            Text('Unverified',
                                              style: TextStyle(
                                                color: Color(0xFF3175E0),
                                                fontSize: 13,
                                                fontFamily: 'Metropolis',
                                                fontWeight: FontWeight.w600,
                                                height: 0.17,
                                                letterSpacing: -0.24,
                                              ),
                                            ),
                                          ])
                                        : verify_status == "2"
                                            ? const Row(
                                                children: [
                                                  Image(
                                                    image: AssetImage(
                                                        'assets/verify.png'),
                                                  ),
                                                  Text('Verified',
                                                    style: TextStyle(
                                                      color: Color(0xFF3175E0),
                                                      fontSize: 13,
                                                      fontFamily: 'Metropolis',
                                                      fontWeight: FontWeight.w600,
                                                      height: 0.17,
                                                      letterSpacing: -0.24,
                                                    ),
                                                    ),
                                                ],
                                              )
                                            : verify_status == "3"
                                                ? const Row(
                                                    children: [
                                                      Image(
                                                        image: AssetImage(
                                                            'assets/verify.png'),
                                                      ),
                                                      Text(
                                                          'Verified',
                                                        style: TextStyle(
                                                          color: Color(0xFF3175E0),
                                                          fontSize: 13,
                                                          fontFamily: 'Metropolis',
                                                          fontWeight: FontWeight.w600,
                                                          height: 0.17,
                                                          letterSpacing: -0.24,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: 5),
                                                      Row(
                                                        children: [
                                                          Image(
                                                            image: AssetImage(
                                                                'assets/trust.png'),
                                                            height:
                                                                20,
                                                            width:
                                                                30,
                                                          ),
                                                          Text(
                                                              'Trusted',
                                                            style: TextStyle(
                                                              color: Color(0xFF3175E0),
                                                              fontSize: 13,
                                                              fontFamily: 'Metropolis',
                                                              fontWeight: FontWeight.w600,
                                                              height: 0.17,
                                                              letterSpacing: -0.24,
                                                            ),),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                : Container(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 104,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(255, 0, 91, 148),
                        ),
                        child: is_follow == "0"
                            ? GestureDetector(
                                onTap: () {
                                  followUnfollowUser("1");
                                  is_follow = "1";
                                  followers_count = followers_count! + 1;
                                  setState(() {});
                                },
                                child: const Center(
                                  child: Text('Follow',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Metropolis',
                                        fontWeight: FontWeight.w500,
                                        height: 0.10,
                                        letterSpacing: -0.24,
                                      ),),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  followUnfollowUser("0");
                                  is_follow = "0";
                                  followers_count = followers_count! - 1;
                                  setState(() {});
                                },
                                child: const Center(
                                  child: Text('Followed',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Metropolis',
                                        fontWeight: FontWeight.w500,
                                        height: 0.10,
                                        letterSpacing: -0.24,
                                      ),),
                                ),
                              ),
                      ),
                      GestureDetector(
                        onTap: () {
                          viewFollowerFollowing(context: context,tabIndex: 0);
                        },
                        child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                followers_count.toString(),
                                style: const TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontFamily: 'assets/fonst/Metropolis-SemiBold.otf'),
                              ),
                              const Text(
                                ' Followers',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontFamily:
                                        'assets/fonst/Metropolis-SemiBold.otf'),
                              ),
                            ]),
                      ),
                      GestureDetector(
                        onTap: () {
                          viewFollowerFollowing(context: context,tabIndex: 1);
                        },
                        child: Row(
                          children: [
                            Text(
                              following_count.toString(),
                              style: const TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-SemiBold.otf'),
                            ),
                            const Text(
                              ' Following',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-SemiBold.otf'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                          border: Border.all(color: Colors.black26,width: 1),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 4.2,
                          height: 25,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(

                                  builder: (_) => ChartDetail(
                                    profileid.toString(),
                                    username.toString(),
                                    image_url.toString(),
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                ImageIcon(
                                  AssetImage('assets/sms.png'),
                                ),
                                Text(
                                  ' Chat',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily:
                                          'assets/fonst/Metropolis-Black.otf',
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        margin: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26,width: 1),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 3.8,
                          height: 25,
                          child: GestureDetector(
                            onTap: () {
                              launchUrl(
                                Uri.parse('https://wa.me/$bussmbl'),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  ('assets/whatsapp.png'),
                                ),
                                const Text(
                                  'WhatsApp',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily:
                                          'assets/fonst/Metropolis-Black.otf',
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 26,
                            padding: const EdgeInsets.all(0),
                            onPressed: () => launchUrl(
                              Uri.parse(facebook_url!),
                              mode: LaunchMode.externalApplication,
                            ),
                            icon: Image.asset(
                              'assets/facebook.png',
                              width: 26,
                              height: 26,
                            ),
                          ),
                          IconButton(
                            iconSize: 26,
                            padding: const EdgeInsets.all(0),
                            onPressed: () => launchUrl(
                              Uri.parse(instagram_url!),
                              mode: LaunchMode.externalApplication,
                            ),
                            icon: Image.asset('assets/instagram.png', width: 26, height: 26,),
                          ),
                          IconButton(
                            iconSize: 26,
                            padding: const EdgeInsets.all(0),
                            onPressed: () => launchUrl(
                              Uri.parse(linkedin_url!),
                              mode: LaunchMode.externalApplication,
                            ),
                            icon: Image.asset('assets/linkdin.png',
                              width: 26,
                              height: 26,),
                          ),
                          IconButton(
                            iconSize: 26,
                            padding: const EdgeInsets.all(0),
                            onPressed: () => launchUrl(
                              Uri.parse(youtube_url!),
                              mode: LaunchMode.externalApplication,
                            ),
                            icon: Image.asset('assets/youtube.png',
                              width: 26,
                              height: 26,),
                          ),
                          IconButton(
                            iconSize: 26,
                            padding: const EdgeInsets.all(0),
                            onPressed: () => launchUrl(
                              Uri.parse(twitter_url!),
                              mode: LaunchMode.externalApplication,
                            ),
                            icon: Image.asset('assets/Twitter.png', width: 26, height: 26,),
                          ),
                        ],
                      )
                    ]),
                  ),
                ),
                const Divider(
                  color: Colors.black26,
                  height: 2.0,
                ),
                SizedBox(
                  height: 47,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          like == 0
                              ? GestureDetector(
                                  child: Image.asset(
                                    'assets/like.png',
                                    height: 17,
                                    width: 17,
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
                                    height: 17,
                                    width: 17,
                                  ),
                                  onTap: () {
                                    Profilelike();
                                    like = 0;
                                    int add = int.parse(like_count!);
                                    add--;
                                    like_count = add.toString();

                                    setState(() {});
                                  },
                                ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              ViewItem(context: context,tabIndex: 0);
                            },
                            child: Text(
                              'Like ($like_count)',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'assets/fonst/Metropolis-Black.otf',
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.24,
                              ),
                            ),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap : ()async{
                           var rev_count = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Review(profileid)));
                            if(rev_count != null){
                              reviews_count = int.parse(rev_count.toString());
                            }
                           print("reviews_count:-$reviews_count");
                           setState(() { });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/star.png',
                              color: Colors.black,
                              height: 17,
                              width: 17,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Reviews ($reviews_count)',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'assets/fonst/Metropolis-Black.otf',
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.24,
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ViewItem(context: context, tabIndex: 1);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.remove_red_eye_outlined,
                              color: Colors.black54,
                              size: 17,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Views ($view_count)',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'assets/fonst/Metropolis-Black.otf',
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.24,
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sharecount();
                          shareImage(
                            url: image_url.toString(),
                            UserName: username.toString(),
                            companyName: business_name.toString(),
                            number: bussmbl.toString(),
                            location: address.toString(),
                            gst: gst_number.toString(),
                            email: b_email.toString(),
                            natureOfBusiness: business_type.toString(),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/Send.png',
                              height: 14,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              'Share',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'assets/fonst/Metropolis-Black.otf',
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.24,
                              ),
                            )
                          ],
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
                  indicatorSize: TabBarIndicatorSize.tab,
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  //height: 300,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13.05),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x3FA6A6A6),
                                        blurRadius: 16.32,
                                        offset: Offset(0, 3.26),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Nature Of Business',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf',
                                              fontSize: 12,
                                              color: Colors.black26),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          business_type.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf',
                                              fontSize: 13,
                                              color: Colors.black),
                                        ),
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  'Business Phone',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          'assets/fonst/Metropolis-Black.otf',
                                                      fontSize: 12,
                                                      color: Colors.black26),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: GestureDetector(
                                                  onTap: () => launchUrl(
                                                    Uri.parse(
                                                        'tel:$b_countryCode + $bussmbl'),
                                                    mode: LaunchMode
                                                        .externalApplication,
                                                  ),
                                                  child: Text(
                                                    b_countryCode.toString() +
                                                        bussmbl.toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf',
                                                        fontSize: 13,
                                                        color: Colors.black),
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
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  'Business Email',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          'assets/fonst/Metropolis-Black.otf',
                                                      fontSize: 12,
                                                      color: Colors.black26),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: GestureDetector(
                                                  onTap: () => launchUrl(
                                                    Uri.parse(
                                                        'mailto:${b_email.toString()}'),
                                                    mode: LaunchMode
                                                        .externalApplication,
                                                  ),
                                                  child: Text(
                                                    b_email.toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf',
                                                        fontSize: 13,
                                                        color: Colors.black),
                                                  ),
                                                ),
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
                                        child: Text(
                                          'Website',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf',
                                              fontSize: 12,
                                              color: Colors.black26),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: GestureDetector(
                                          onTap: () {
                                            final urlString =
                                                website.toString();
                                            final formattedUrl = !urlString
                                                        .startsWith(
                                                            'http://') &&
                                                    !urlString
                                                        .startsWith('https://')
                                                ? 'https://$urlString'
                                                : urlString;
                                            launch(formattedUrl,
                                                    forceSafariVC: false,
                                                    forceWebView: false,
                                                    enableJavaScript: true)
                                                .catchError(
                                              (e) => print(
                                                  'Error launching URL: $e'),
                                            );
                                          },
                                          child: Text(
                                            website.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    'assets/fonst/Metropolis-Black.otf',
                                                fontSize: 13,
                                                color: Colors.black),
                                          ),
                                        ),
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
                                        child: Text(
                                          'About Your Business',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf',
                                              fontSize: 12,
                                              color: Colors.black26),
                                        ),
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
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Expanded(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    //height: 60,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13.05),
                                      ),
                                      shadows: [
                                        BoxShadow(
                                          color: Color(0x3FA6A6A6),
                                          blurRadius: 16.32,
                                          offset: Offset(0, 3.26),
                                          spreadRadius: 0,
                                        )
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(children: [
                                      const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Our Products',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf',
                                              fontSize: 12,
                                              color: Colors.black26),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          product_name.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf',
                                              fontSize: 13,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  //height: 320,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13.05),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x3FA6A6A6),
                                        blurRadius: 16.32,
                                        offset: Offset(0, 3.26),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'GST/VAT/TAX',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf',
                                              fontSize: 12,
                                              color: Colors.black26),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                          children: [
                                            gst_number != ""
                                                ? Icon(
                                                    Icons.check_circle_rounded,
                                                    color:
                                                        Colors.green.shade600,
                                                  )
                                                : Container(),
                                            Text(
                                              gst_number.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-Black.otf',
                                                  fontSize: 13,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
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
                                        child: Text(
                                          'Pan Number: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf',
                                              fontSize: 12,
                                              color: Colors.black26),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          pan_number != null  && pan_number.toString().isNotEmpty
                                              ? Icon(
                                                Icons.check_circle_rounded,
                                                color: Colors.green.shade600,
                                              )
                                              : Container(),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              pan_number.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-Black.otf',
                                                  fontSize: 13,
                                                  color: Colors.black),
                                            ),
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
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'IEC Number: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf',
                                              fontSize: 12,
                                              color: Colors.black26),
                                        ),
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
                                        ),
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
                                        child: Text(
                                          'Production Capacity',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf',
                                              fontSize: 12,
                                              color: Colors.black26),
                                        ),
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
                                        ),
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
                                        child: Text(
                                          'Annual Turnover',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf',
                                              fontSize: 12,
                                              color: Colors.black26),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                '2020 - 2021 :',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                              First_currency.toString()
                                                      .isNotEmpty
                                                  ? Text(
                                                      First_currency.toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf',
                                                          fontSize: 13,
                                                          color: Colors.black),
                                                    )
                                                  : Container(),
                                              First_currency_sign.toString()
                                                      .isEmpty
                                                  ? Text(
                                                      First_currency_sign
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf',
                                                          fontSize: 13,
                                                          color: Colors.black),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                '2021 - 2022 :',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                              Second_currency.toString()
                                                      .isNotEmpty
                                                  ? Text(
                                                      First_currency.toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf',
                                                          fontSize: 13,
                                                          color: Colors.black),
                                                    )
                                                  : Container(),
                                              Second_currency_sign.toString()
                                                      .isEmpty
                                                  ? Text(
                                                      Second_currency_sign
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf',
                                                          fontSize: 13,
                                                          color: Colors.black),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                '2022 - 2023 :',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                              Third_currency.toString()
                                                      .isNotEmpty
                                                  ? Text(
                                                      Third_currency.toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf',
                                                          fontSize: 13,
                                                          color: Colors.black),
                                                    )
                                                  : Container(),
                                              Third_currency_sign.toString()
                                                      .isEmpty
                                                  ? Text(
                                                      Third_currency_sign
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf',
                                                          fontSize: 13,
                                                          color: Colors.black),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ],
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
                                        child: Text(
                                          'Premises Type',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf',
                                              fontSize: 12,
                                              color: Colors.black26),
                                        ),
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
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
                      : Container(),
            ),
    );
  }

  Future<void> sharecount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await share_count(
      profileid.toString(),
      pref.getString('user_id').toString(),
    );

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
          indicatorSize: TabBarIndicatorSize.tab,
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
        ? GridView.builder(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                ),
              );
            }),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.05),
              ),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.05),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3FA6A6A6),
                      blurRadius: 16.32,
                      offset: Offset(0, 3.26),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                    children: [
                  Stack(fit: StackFit.passthrough, children: <Widget>[
                    Container(
                      height: 165,
                      width: 175,
                      margin: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        //color: Colors.black26,
                        borderRadius: BorderRadius.all(
                          Radius.circular(13.05),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13.05),
                        /*shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10.0),),*/
                        child: Image(
                          image: NetworkImage(
                            result.mainproductImage.toString(),
                          ),
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
                            Radius.circular(10.0),
                          ),
                        ),
                        // color: Color.fromARGB(0,255, 255, 255),
                        child: Text(
                          '₹${result.productPrice}',
                          style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w800,
                              fontFamily:
                                  'assets/fonst/Metropolis-Black.otf',
                              color: Colors.white),
                        ),
                      ),
                    ),
                    result.isPaidPost == 'Paid'
                        ? Positioned(
                            top: -10,
                            left: -30,
                            child: Container(
                              padding: const EdgeInsets.all(5),
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
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 10.0),
                          child: Text(result.postName.toString(),
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-SemiBold.otf'),
                              softWrap: false,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 10.0),
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
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                          child:
                              Text('${result.state},${result.country}',
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.grey,
                                    fontFamily: 'Metropolis',
                                  ),
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 10.0),
                          child: Text(
                            result.postType.toString(),
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontFamily: 'Metropolis',
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(0, 148, 95, 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
              ),
            ),
          );
        },
                        )
        : const Center(
            child: Text(
              'Buy Post not Found',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 91, 148),
              ),
            ),
          );
  }

  void _scrollercontroller() {
    if (scrollercontroller.position.pixels ==
        scrollercontroller.position.maxScrollExtent) {
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
      Navigator.of(dialogContext)
          .pop(); // Use dialogContext to close the dialog
      // Dialog closed
    });
  }

  Widget Sale_post() {
    return salepostlist_data.isNotEmpty
        ? GridView.builder(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: MediaQuery.of(context).size.height /
              1300, //MediaQuery.of(context).size.aspectRatio * 1.3,
          crossAxisCount: 2,
          mainAxisSpacing: 3.0,
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
                ),
              );
            }),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.05),
              ),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.05),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3FA6A6A6),
                      blurRadius: 16.32,
                      offset: Offset(0, 3.26),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                    children: [
                  Stack(fit: StackFit.passthrough, children: <Widget>[
                    Container(
                      height: 165,
                      width: 175,
                      margin: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        //color: Colors.black26,
                        borderRadius: BorderRadius.all(
                          Radius.circular(13.05),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(13.05)),
                        child: Image(
                          image: NetworkImage(
                            result.mainproductImage.toString(),
                          ),
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
                            Radius.circular(10.0),
                          ),
                        ),
                        // color: Color.fromARGB(0,255, 255, 255),
                        child: Text(
                          '₹${result.productPrice}',
                          style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w800,
                              fontFamily:
                                  'assets/fonst/Metropolis-Black.otf',
                              color: Colors.white),
                        ),
                      ),
                    ),
                    result.isPaidPost == 'Paid'
                        ? Positioned(
                            top: -10,
                            left: -30,
                            child: Container(
                              padding: const EdgeInsets.all(5),
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
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 10.0),
                          child: Text(result.postName.toString(),
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-SemiBold.otf'),
                              softWrap: false,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 10.0),
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
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 10.0),
                          child:
                              Text('${result.state},${result.country}',
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.grey,
                                    fontFamily: 'Metropolis',
                                  ),
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, left: 10.0),
                          child: Text(
                            result.postType.toString(),
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontFamily: 'Metropolis',
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(0, 148, 95, 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
              ),
            ),
          );
        },
                        )
        : const Center(
            child: Text(
              'Sale Post not Found',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 91, 148),
              ),
            ),
          );
  }

  getProfiless() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getbusinessprofileDetail(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
      widget.user_id.toString(),
    );

    log("RESPONSE === $res");

    if (res['status'] == 1) {
      print("profile:-${res['profile']}");
      profileid = res['profile']['user_id'] ?? "";
      username = res['user']['username'];
      instagram_url = res['profile']['instagram_link'] ?? "";
      youtube_url = res['profile']['youtube_link'] ?? "";
      facebook_url = res['profile']['facebook_link'] ?? "";
      linkedin_url = res['profile']['linkedin_link'] ?? "";
      twitter_url = res['profile']['twitter_link'] ?? "";
      telegram_url = res['profile']['telegram_link'] ?? "";
      business_phone_url = res['user']['business_phone'] ?? "";
      other_email_url = res['user']['other_email'] ?? "";
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

      view_count = res['profile']['view_count'];
      like = res['profile']['like_count'];
      reviews_count = res['profile']['reviews_count'];
      following_count = res['profile']['following_count'];
      followers_count = res['profile']['followers_count'];
      verify_status = res['profile']['verification_status'];
      like_count = res['profile']['like_counter'];
      is_follow = res['profile']['is_follow'];
      abot_buss = res['profile']['about_business'] ?? "";
      image_url = res['user']['image_url'];
      is_prime = res['user']['is_prime'];

      gst_number = res['profile']['gst_tax_vat'] ?? "";
      Premises_Type = res['profile']['premises'] ?? '';
      Annual_Turnover = res['profile']['annual_turnover'] ?? '';

      pan_number = res['profile']['pan_number'] ?? '';
      production_capacity = res['profile']['annualcapacity'] == null
          ? ""
          : res['profile']['annualcapacity']['name'] ?? '';
      ex_import_number = res['profile']['export_import_number'] ?? '';

      business_type = res['profile']['business_type_name'] ?? '';
      product_name = res['profile']['product_name'] ?? '';

      product_name = res['profile']['product_name'];
      if (res['profile']['annual_turnover'] != null) {
        First_currency_sign =
            res['profile']['annual_turnover']['currency_20_21'] ?? "";
        Second_currency_sign =
            res['profile']['annual_turnover']['currency_21_22'] ?? "";
        Third_currency_sign =
            res['profile']['annual_turnover']['currency_22_23'] ?? "";

        First_currency =
            res['profile']['annual_turnover']['amounts2021']['name'] ?? "";
        Second_currency =
            res['profile']['annual_turnover']['amounts2122']['name'] ?? "";
        Third_currency =
            res['profile']['annual_turnover']['amounts2223']['name'] ?? "";
      }
      isload = true;
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
      widget.user_id.toString(),
    );
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
        _childController.dispose();
        _childController = TabController(length: 2, vsync: this,initialIndex: buypostlist_data.isEmpty ? 1 : 0);
        isload = true;

        if (mounted) {
          setState(() {});
        }
      }
    } else {
      isload = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonArray;
  }

  Future<void> Profilelike() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await profile_like(
      profileid.toString(),
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );

    var jsonArray;

    if (res['status'] == 1) {
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonArray;
  }

  Future<void> followUnfollowUser(isFollow) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var response = await followUnfollow(
      isFollow.toString(),
      widget.user_id.toString(),
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );
    log("FOLLOW RESPONSE == $response");

    var jsonArray;

    if (response['status'] == 1) {
      Fluttertoast.showToast(msg: response['message']);
    } else {
      Fluttertoast.showToast(msg: response['message']);
    }
    setState(() {});
    return jsonArray;
  }

  get_salepostlist() async {
    salePostList = GetSalePostList();
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getsale_PostList(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
      '20',
      offset.toString(),
      widget.user_id.toString(),
    );
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

  void shareImage({
    required String url,
    required String UserName,
    required String companyName,
    required String number,
    required String location,
    required String natureOfBusiness,
    required String email,
    String? gst,

  }) async {
    final imageurl = url;
    final uri = Uri.parse(imageurl);
    final response = await http.get(uri);
    final bytes = response.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);
    await Share.shareFiles([path],
        text: UserName + "\n" + companyName + "\n" + number + "\n" + email + "\n" + location + "\n" + natureOfBusiness + "\n" + (gst != null && gst.isNotEmpty ? 'GST NO:-' : '') + gst.toString() +
            "\t" +
            "\n" +
            "\n" +
            'Plastic4trade is a Worldwide B2B Plastic Raw Material, Scrap, Machinery & Finished Goods Trading App: https://play.google.com/store/apps/details?id=' +
            packageName!);
  }

  List<Widget> buildWidgets(String text) {
    List<Widget> widgets = [];
    final lines = text.split('\n');

    for (var line in lines) {
      widgets.add(
        buildLineWidget(line),
      );
    }

    return widgets;
  }

  Widget buildLineWidget(String line) {
    final words = line.split(' ');

    List<Widget> lineWidgets = [];
    for (var word in words) {
      if (RegExp(r'https?://[^\s/$.?#].[^\s]*').hasMatch(word)) {
        // Handle links
        lineWidgets.add(
          GestureDetector(
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
          ),
        );
      } else if (RegExp(r'\b\d{10}\b').hasMatch(word)) {
        // Handle phone numbers
        String phoneNumber = RegExp(r'\b\d{10}\b').stringMatch(word)!;
        lineWidgets.add(
          GestureDetector(
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
          ),
        );
      } else if (word.endsWith('.com') || word.endsWith('.in')) {
        // Handle website URLs with .com or .in extension
        String url = word;
        if (!url.startsWith('http')) {
          url = 'http://$url';
        }
        lineWidgets.add(
          GestureDetector(
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
          ),
        );
      } else {
        // Handle regular text
        lineWidgets.add(
          Text(
            word,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }
      lineWidgets.add(
        const SizedBox(width: 4),
      ); // Add some spacing between words
    }
    return Wrap(
      direction: Axis.horizontal,
      // This ensures the children are laid out horizontally
      children: lineWidgets,
    );
  }

  ViewItem({required BuildContext context, int tabIndex = 0}) {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          // <-- SEE HERE
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize:
              0.60, // Initial height as a fraction of screen height
          builder: (BuildContext context, ScrollController scrollController) {
            return StatefulBuilder(
              builder: (context, setState) {
                return ViewWidget(
                  profileid: profileid.toString(),
                  tabIndex: tabIndex,
                );
              },
            );
          }),
    );
  }

  viewFollowerFollowing({required BuildContext context,required int tabIndex}) {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          // <-- SEE HERE
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize:
              0.60, // Initial height as a fraction of screen height
          builder: (BuildContext context, ScrollController scrollController) {
            return StatefulBuilder(
              builder: (context, setState) {
                return ViewFollowerFollowingList(userId: widget.user_id.toString(),tabIndex: tabIndex,);
              },
            );
          }),
    ).then(
      (value) {},
    );
  }
}

class ViewWidget extends StatefulWidget {
  String profileid;
  int tabIndex = 0;

  ViewWidget({Key? key,required this.profileid, required this.tabIndex,}) : super(key: key);

  @override
  State<ViewWidget> createState() => _ViewState();
}

class _ViewState extends State<ViewWidget> with SingleTickerProviderStateMixin {
  bool? isload;
  late TabController _tabController;
  List<like.Data> dataList = [];
  List<view_pro.Data> dataList1 = [];
  List<share_pro.Data> dataList2 = [];

  //List<Data> dataList2=[];
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.tabIndex);
    get_like();
    get_view();
    get_share();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  get_like() async {
    Get_likeUser common = Get_likeUser();

    var res = await get_profileliked_user(widget.profileid);

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
    var res = await get_profileviewd_user(widget.profileid);
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

    var res = await get_profiles_share(widget.profileid);

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
                indicatorSize: TabBarIndicatorSize.tab,
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
                        padding: const EdgeInsets.all(15),
                        shrinkWrap: true,
                        itemCount: dataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      other_user_profile(int.parse(dataList[index].userId!)),
                              ),);
                            },
                            child:Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image: dataList[index].imageUrl != null
                                            ? NetworkImage(
                                          dataList[index].imageUrl.toString(),
                                        )
                                            : const AssetImage('assets/more.png')
                                        as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      shape: const OvalBorder(),
                                    ),
                                  ),
                                  const SizedBox(width: 9,),
                                  Text(
                                    dataList[index].username ?? "Unknown",
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily:
                                        'assets/fonst/Metropolis-Black.otf'),),
                                ],
                              ),
                            ),
                          );
                        }),
                    
                    ListView.builder(
                      padding: const EdgeInsets.all(15),
                        shrinkWrap: true,
                        itemCount: dataList1.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      other_user_profile(int.parse(dataList1[index].userId.toString())),
                                ),);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image: dataList1[index].imageUrl != null
                                            ? NetworkImage(
                                          dataList1[index].imageUrl.toString(),
                                        )
                                            : const AssetImage('assets/more.png')
                                        as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      shape: const OvalBorder(),
                                    ),

                                    ),
                              const SizedBox(width: 9,),
                              Text(
                              dataList1[index].username ?? "Unknown",
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontFamily:
                                  'assets/fonst/Metropolis-Black.otf'),),
                                ],
                              ),
                            ),
                          );
                        }),
                    ListView.builder(
                        padding: const EdgeInsets.all(15),
                        shrinkWrap: true,
                        itemCount: dataList2.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      other_user_profile(int.parse(dataList2[index].userId.toString())),
                                ),);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image: dataList2[index].imageUrl != null
                                            ? NetworkImage(
                                          dataList2[index].imageUrl.toString(),
                                        )
                                            : const AssetImage('assets/more.png')
                                        as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      shape: const OvalBorder(),
                                    ),

                                  ),
                                  const SizedBox(width: 9,),
                                  Text(
                                    dataList2[index].username ?? "Unknown",
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily:
                                        'assets/fonst/Metropolis-Black.otf'),),
                                ],
                              ),
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

class ViewFollowerFollowingList extends StatefulWidget {
  String userId;
  late int tabIndex;

  ViewFollowerFollowingList({Key? key,required this.userId, required this.tabIndex}) : super(key: key);

  @override
  State<ViewFollowerFollowingList> createState() =>
      _ViewFollowerFollowingListState();
}

class _ViewFollowerFollowingListState extends State<ViewFollowerFollowingList>
    with SingleTickerProviderStateMixin {
  bool? isload;
  late TabController _tabController;
  List<getfllow.Result> getfollowdata = [];
  List<getfllowing.Result> getfllowingdata = [];

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this,initialIndex: widget.tabIndex);
    getFollower();
    getFollowing();
  }

  Future<void> getFollower() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getOtherUserFollowerLists(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        widget.userId);

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];
        followers_count = res['totalFollowers'];

        for (var data in jsonArray) {
          getfllow.Result record = getfllow.Result(
              isFollowing: data['is_following'],
              name: data['name'],
              id: data['id'],
              image: data['image'],
              status: data['Status']);

          getfollowdata.add(record);
          isload = true;
          setState(() {});
        }

        if (mounted) {
          setState(() {});
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    print("getfollowdata:-${getfollowdata.length}");
    return jsonArray;
  }


  Future<void> getFollowing() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getOtherUserFollowingList(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        widget.userId);

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];
        following_count = res['totalFollowing'];

        for (var data in jsonArray) {
          getfllowing.Result record = getfllowing.Result(
              name: data['name'],
              id: data['id'],
              image: data['image'],
              status: data['Status']);
          getfllowingdata.add(record);
        }

        if (mounted) {
          setState(() {});
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    print("getfllowingdata:-${getfllowingdata.length}");
    return jsonArray;
  }

  Future<void> followUnfollowUser(isFollow) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var response = await followUnfollow(
      isFollow.toString(),
      widget.userId,
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );

    log("FOLLOW RESPONSE == $response");

    var jsonArray;

    if (response['status'] == 1) {
      Fluttertoast.showToast(msg: response['message']);
    } else {
      Fluttertoast.showToast(msg: response['message']);
    }
    setState(() {});
    return jsonArray;
  }


  @override
  Widget build(BuildContext context) {
   //  widget.tabIndex = _tabController.index;
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
                indicatorSize: TabBarIndicatorSize.tab,
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Followers'),
                  Tab(text: 'Following'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: getfollowdata.length,
                      padding: const EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
                      itemBuilder: (context, index) {
                        print("data:-${getfollowdata.length}");
                        getfllow.Result result = getfollowdata[index];
                        return GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      5.0, 0, 15.0, 0.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 25,
                                    backgroundImage: result.image.toString() !=
                                            ''
                                        ? NetworkImage(
                                            result.image.toString(),
                                          ) as ImageProvider
                                        : const AssetImage(
                                            'assets/plastic4trade logo final 1 (2).png'),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    result.name.toString(),
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child:  Container(
                                    alignment: Alignment.center,
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: const BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 0, 91, 148),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                          ),
                                          height: 35,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              6.5,
                                          child: (result.isFollowing == 1) ? GestureDetector(
                                            onTap: () {
                                              followUnfollowUser("0");
                                              // is_follow = "0";
                                              setState(() {});
                                            },
                                            child: const Text(
                                              'followed',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                          ) : GestureDetector(
                                            onTap: () {
                                              followUnfollowUser("1");
                                              // is_follow = "1";
                                              setState(() {});
                                            },
                                            child: const Text(
                                              'follow',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: getfllowingdata.length,
                      padding: const EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
                      itemBuilder: (context, index) {
                        getfllowing.Result result = getfllowingdata[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          //height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    5.0, 0, 15.0, 0.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 25,
                                  backgroundImage: result.image.toString() !=
                                          ''
                                      ? NetworkImage(
                                          result.image.toString(),
                                        ) as ImageProvider
                                      : const AssetImage(
                                          'assets/plastic4trade logo final 1 (2).png'),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  result.name.toString(),
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontFamily:
                                          'assets/fonst/Metropolis-Black.otf'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child:  Container(
                                  alignment: Alignment.center,
                                        padding: const EdgeInsets.all(5.0),
                                        decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 0, 91, 148),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(50),
                                          ),
                                        ),
                                        height: 35,
                                        width: MediaQuery.of(context)
                                                .size
                                                .width /
                                            6.5,
                                        child: (result.isFollowing == 1) ? const Text(
                                          'followed',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        ) : const Text(
                                          'follow',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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

// Positioned(
// bottom: 10,
// right: 10,
// child: ListView.builder(
// padding: const EdgeInsets.all(0),
// physics: const NeverScrollableScrollPhysics(),
// scrollDirection: Axis.horizontal,
// shrinkWrap: true,
// itemCount: firstExhibitorImages.length,
// itemBuilder: (context,index) {
// return Container(
// width: 7,
// height: 7,
// decoration: BoxDecoration(
// color: imageIndex == index ? const Color(0xFF005C94) : Colors.white,
// shape: BoxShape.circle
// ),
// );}),
// ),