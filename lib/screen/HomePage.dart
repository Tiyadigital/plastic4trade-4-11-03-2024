// ignore_for_file: unnecessary_null_comparison, empty_catches, non_constant_identifier_names, prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Plastic4trade/model/GetCategory.dart' as cat;
import 'package:Plastic4trade/model/getBannerImage.dart' as img;
import 'package:Plastic4trade/model/getHomePost.dart' as homepost;
import 'package:Plastic4trade/model/getHomePostSearch.dart' as homesearch;
import 'package:Plastic4trade/screen/AddPost.dart';
import 'package:Plastic4trade/screen/Buyer_sell_detail.dart';
import 'package:Plastic4trade/screen/GradeScreen.dart';
import 'package:Plastic4trade/widget/FilterScreen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../api/api_interface.dart';
import '../constroller/GetCategoryController.dart';
import '../constroller/Getmybusinessprofile.dart';
import '../utill/constant.dart';
import '../widget/HomeAppbar.dart';
import '../widget/MainScreen.dart';
import 'Blog.dart';
import 'BussinessProfile.dart';
import 'Exhibition.dart';
import 'Follower_Following.dart';
import 'Liveprice.dart';
import 'Tutorial_Videos.dart';
import 'Videos.dart';
import 'other_user_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0, _defaultChoiceIndex = -1;
  DateTime? currentBackPressTime;
  bool loadmore = false;
  final scrollercontroller = ScrollController();
  List<img.Result> banner_img = [];
  List<homepost.Result> homepost_data = [];
  List<homesearch.Result> homepostsearch_data = [];
  WebViewController? web_controller;
  int offset = 0;
  int count = 0;
  late String lat = "";
  int appopencount = 0;
  String? location, search;
  late String log = "";
  String quicknews = "data";
  bool isload = false;
  String googleApikey = "AIzaSyCyqsD3OPUWGJ5AWbN3iKbUzQGs3Q-ZlPE";
  String category_filter_id = '',
      category_id = '""',
      grade_id = '',
      type_id = '',
      bussinesstype = '',
      post_type = '';
  final TextEditingController _loc = TextEditingController();
  final TextEditingController _search = TextEditingController();
  Dio dio = Dio();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final _androidchannel = const AndroidNotificationChannel(
      'high_impotance_channel', 'High Importance Notification',
      description: 'This channel is used for importance notification',
      importance: Importance.max);
  final _localNotification = FlutterLocalNotificationsPlugin();
  final PageController controller = PageController(initialPage: 0);

  @override
  void initState() {
    // TODO: implement initState
    _loc.text = constanst.location.toString();
    super.initState();

    scrollercontroller.addListener(_scrollercontroller);
    Clear_date();
    checknetowork();
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Widget init() {
    return WillPopScope(
        onWillPop: () => _onbackpress(context),
        child: Scaffold(
          backgroundColor: const Color(0xFFDADADA),
          body: isload == true
              ? Column(mainAxisSize: MainAxisSize.min, children: [
                  horiztallist(),
                  const SizedBox(
                    height: 3,
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(40.0),
                                    bottomRight: Radius.circular(40.0),
                                    topLeft: Radius.circular(40.0),
                                    bottomLeft: Radius.circular(40.0)),
                                color: Colors.white),
                            height: 40,
                            margin: const EdgeInsets.only(left: 8.0),
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                child: TextField(
                                  controller: _loc,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  readOnly: true,
                                  onTap: () async {
                                    var place = await PlacesAutocomplete.show(
                                        context: context,
                                        apiKey: googleApikey,
                                        mode: Mode.overlay,
                                        types: ['(cities)'],
                                        strictbounds: false,
                                        onError: (err) {
                                        });

                                    if (place != null) {
                                      setState(() {
                                        location = place.description.toString();
                                        constanst.location =
                                            place.description.toString();
                                        _loc.text = location!;
                                      });

                                      //form google_maps_webservice package
                                      final plist = GoogleMapsPlaces(
                                        apiKey: googleApikey,
                                        apiHeaders:
                                            await const GoogleApiHeaders()
                                                .getHeaders(),
                                        //from google_api_headers package
                                      );
                                      String placeid = place.placeId ?? "0";
                                      final detail = await plist
                                          .getDetailsByPlaceId(placeid);

                                      final geometry = detail.result.geometry!;
                                      constanst.lat =
                                          geometry.location.lat.toString();

                                      constanst.log =
                                          geometry.location.lng.toString();
                                      homepost_data.clear();
                                      count = 0;
                                      offset = 0;
                                      //get_HomePostSearch();
                                      WidgetsBinding
                                          .instance.focusManager.primaryFocus
                                          ?.unfocus();
                                      _onLoading();
                                      get_HomePost();
                                      setState(() {});
                                    }
                                  },
                                  textAlign: TextAlign.start,
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 1.0),
                                    prefixIconConstraints:
                                        const BoxConstraints(minWidth: 24),
                                    suffixIconConstraints:
                                        const BoxConstraints(minWidth: 24),
                                    prefixIcon: const Padding(
                                      padding:
                                          EdgeInsets.only(right: 2, left: 2),
                                      child: Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.black45,
                                        size: 23,
                                      ),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        _loc.clear();
                                        count = 0;
                                        offset = 0;
                                        constanst.lat = "";
                                        constanst.log = "";
                                        homepost_data.clear();
                                        _onLoading();
                                        get_HomePost();
                                        setState(() {});
                                      },
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.only(right: 2, left: 2),
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.black45,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    hintText: 'Location',
                                    hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontFamily:
                                          'assets/fonst/Metropolis-Black.otf',
                                    ),
                                    alignLabelWithHint: true,
                                  ),
                                  onChanged: (value) {},
                                ))),
                        Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(40.0),
                                    bottomRight: Radius.circular(40.0),
                                    topLeft: Radius.circular(40.0),
                                    bottomLeft: Radius.circular(40.0)),
                                color: Colors.white),
                            height: 40,
                            margin: const EdgeInsets.only(left: 6.0),
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                child: TextField(
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  controller: _search,
                                  textAlign: TextAlign.start,
                                  textInputAction: TextInputAction.search,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIconConstraints:
                                          BoxConstraints(minWidth: 24),
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 1.0),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.only(
                                            right: 5.0, left: 5.0),
                                        child: Icon(
                                          Icons.search,
                                          color: Colors.black45,
                                          size: 25,
                                        ),
                                      ),
                                      hintText: 'Search',
                                      hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets/fonst/Metropolis-Black.otf')),
                                  onSubmitted: (value) {
                                    WidgetsBinding
                                        .instance.focusManager.primaryFocus
                                        ?.unfocus();
                                    homepost_data.clear();
                                    count = 0;
                                    offset = 0;
                                    _onLoading();
                                    get_HomePost();
                                    setState(() {});
                                  },
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      WidgetsBinding
                                          .instance.focusManager.primaryFocus
                                          ?.unfocus();
                                      _search.clear();
                                      count = 0;
                                      offset = 0;
                                      homepost_data.clear();
                                      _onLoading();
                                      get_HomePost();
                                      setState(() {});
                                    }
                                  },
                                ))),
                        GestureDetector(
                          onTap: () {
                            ViewItem(context);
                          },
                          child: Container(
                            height: 70,
                            margin: const EdgeInsets.only(
                                bottom: 4.0, left: 1.2, top: 2.0),
                            padding: const EdgeInsets.all(3.0),
                            width: MediaQuery.of(context).size.width / 11,
                            // padding: EdgeInsets.only(right: 5),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: const Icon(
                              Icons.filter_alt,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                        controller: scrollercontroller,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            slider_home(),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 20,
                              child: Marquee(
                                text: quicknews.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.0,
                                    color: Colors.black),
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                blankSpace: 20.0,
                                velocity: 100.0,
                                pauseAfterRound: const Duration(seconds: 1),
                                startPadding: 10.0,
                                accelerationDuration:
                                    const Duration(seconds: 1),
                                accelerationCurve: Curves.linear,
                                decelerationDuration:
                                    const Duration(milliseconds: 500),
                                decelerationCurve: Curves.easeOut,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            category()
                          ],
                        )),
                  ),
                ])
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
          floatingActionButton: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage("assets/floating_back.png")),
                borderRadius: BorderRadius.circular(30)),
            child: IconButton(
              onPressed: () {
                constanst.redirectpage = "add_post";
                if (constanst.appopencount == constanst.appopencount1) {
                  if (!constanst.isgrade &&
                      !constanst.istype &&
                      !constanst.iscategory &&
                      !constanst.isprofile) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddPost(),
                        ));
                  } else if (constanst.isprofile) {
                    showInformationDialog(context);
                  } else if (constanst.iscategory) {
                    constanst.redirectpage = "add_cat";
                    categoryDialog(context);
                  } else if (constanst.isgrade) {
                    constanst.redirectpage = "add_type";
                    categoryDialog(context);
                  } else if (constanst.istype) {
                    constanst.redirectpage = "add_grade";
                    categoryDialog(context);
                  }
                } else {
                  if (constanst.isprofile) {
                    showInformationDialog(context);
                  } else if (constanst.iscategory) {
                    constanst.redirectpage = "add_cat";
                    categoryDialog(context);
                  } else if (constanst.isgrade) {
                    constanst.redirectpage = "add_type";
                    categoryDialog(context);
                  } else if (constanst.istype) {
                    constanst.redirectpage = "add_grade";
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Grade(),
                        ));
                  }  else if (!constanst.isgrade &&
                      !constanst.istype &&
                      !constanst.iscategory &&
                      !constanst.isprofile) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddPost(),
                        ));
                  }
                }
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 40),
            ),
            //
          ),
        ));
  }

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<bool> _onbackpress(BuildContext context) async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showCustomToast(context);
      return Future.value(false);
    }
    SystemNavigator.pop(); // Close the app
    return Future.value(true);
  }

  void showCustomToast(BuildContext context) {
    OverlayState overlay = Overlay.of(context);
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        bottom: 50.0,
        left: 40,
        width: MediaQuery.of(context).size.width / 1.35,
        height: 45,
        child: Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.symmetric(horizontal: 32.0),
          padding: const EdgeInsets.fromLTRB(3.0, 8.0, 3.0, 8.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 70,
                width: 50,
                child: Image.asset(
                  "assets/plastic4trade logo final 1 (2).png",
                  width: 70,
                ),
              ),
              const SizedBox(width: 8.0),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: const Text(
                    'Please tap again to exit',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf',
                        color: Colors.white,
                        fontSize: 14.0,
                        decoration: TextDecoration.none),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Wait for the toast duration and remove the overlay entry
    Future.delayed(const Duration(seconds: 2)).then((value) {
      overlayEntry.remove();
    });
  }

  Widget horiztallist() {
    return Container(
        height: 50,
        color: Colors.white,
        //margin: EdgeInsets.only(top: 5.0),
        //margin: EdgeInsets.fromLTRB(10, 2.0, 0.0, 0),
        child: FutureBuilder(

            //future: load_subcategory(),
            builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            //List<dynamic> users = snapshot.data as List<dynamic>;
            return ListView.builder(
                shrinkWrap: false,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: constanst.catdata.length,
                itemBuilder: (context, index) {
                  cat.Result result = constanst.catdata[index];
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Wrap(spacing: 6.0, runSpacing: 6.0, children: <
                          Widget>[
                        ChoiceChip(
                          label: Text(
                              constanst.catdata[index].categoryName.toString()),
                          selected: _defaultChoiceIndex == index,
                          selectedColor: const Color.fromARGB(255, 0, 91, 148),
                          onSelected: (bool selected) {
                            setState(() {
                              _defaultChoiceIndex = selected ? index : -1;
                              if (_defaultChoiceIndex == -1) {
                                category_filter_id = "";
                                homepost_data.clear();
                                _onLoading();
                                get_HomePost();
                              } else {
                                category_filter_id =
                                    result.categoryId.toString();
                                homepost_data.clear();
                                _onLoading();
                                get_HomePost();
                              }
                            });
                          },
                          backgroundColor: const Color.fromARGB(255, 236, 232, 232),
                          labelStyle: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-Black.otf')
                              .copyWith(
                                  color: _defaultChoiceIndex == index
                                      ? Colors.white
                                      : Colors.black),
                          labelPadding: const EdgeInsets.symmetric(horizontal: 14.0),
                          /*shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),*/
                        )
                      ]));
                });
          }
        }));
  }

  Widget slider_home() {
    return SizedBox(
        height: 200.0,
        child: Container(
          color: Colors.grey,
          child: PageView.builder(
            controller: controller,
            itemCount: banner_img.length,
            itemBuilder: (context, index) {
              img.Result record = banner_img[index];
              return record.bannertype == 'image'
                  ? ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  child: Image.network(record.bannerImage.toString(),
                      fit: BoxFit.fill, width: 2500.0),
                    )
                  : web_view(record.bannerImage.toString());
            },
          ),
        ));
  }

  Widget? web_view(String imageurl) {
    web_controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(imageurl));
    return WebViewWidget(controller: web_controller as WebViewController);
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
            ));
      },
    );

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(dialogContext)
          .pop(); // Use dialogContext to close the dialog
    });
  }

  Widget category() {
    return FutureBuilder(
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
        return LayoutBuilder(builder: (context, constraints) {
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // childAspectRatio:MediaQuery.of(context).size.height < 750 ? .50: MediaQuery.of(context).size.height < 825 ? .65 :MediaQuery.of(context).size.height < 850 ? .62 : MediaQuery.of(context).size.height < 800 ? .73: .619,
              childAspectRatio: MediaQuery.of(context).size.width / 620,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: homepost_data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              homepost.Result result = homepost_data[index];

              return GestureDetector(
                onTap: (() {
                  constanst.productId = result.productId.toString();
                  constanst.post_type = result.postType.toString();
                  constanst.redirectpage = "sale_buy";

                  if (constanst.appopencount == constanst.appopencount1) {

                    if (!constanst.isgrade &&
                        !constanst.istype &&
                        !constanst.iscategory &&
                        !constanst.isprofile &&
                        constanst.step == 11) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Buyer_sell_detail(
                                prod_id: result.productId.toString(),
                                post_type: result.postType.toString()),
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
                  } else if (constanst.isprofile) {
                    showInformationDialog(context);
                  } else if (constanst.appopencount ==
                      constanst.appopencount1) {
                    categoryDialog(context);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Buyer_sell_detail(
                              prod_id: result.productId.toString(),
                              post_type: result.postType.toString()),
                        ));
                  }
                }),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(children: [
                    Stack(
                      fit: StackFit.passthrough,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height / 4.8,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            // color: Color.fromARGB(0,255, 255, 255),
                            child: Text('₹${result.productPrice}',
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
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
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
                              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                              child: Text(
                                  '${result.categoryName} | ${result.productGrade}',
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
                              padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                              child: Text(
                                  '${result.state}, ${result.country}',
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
                                padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                                child: result.postType.toString() == "BuyPost"
                                    ? const Text(
                                        'Buy Post',
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontFamily: 'Metropolis',
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Color.fromRGBO(0, 148, 95, 1)),
                                      )
                                    : result.postType.toString() == "SalePost"
                                        ? const Text(
                                            "Sale Post",
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontFamily: 'Metropolis',
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(
                                                    0, 148, 95, 1)),
                                          )
                                        : Container())),
                      ],
                    )
                  ]),
                ),
              );
            },
          );
        });
      }
    });
  }

  void _scrollercontroller() {
    if (scrollercontroller.position.pixels ==
        scrollercontroller.position.maxScrollExtent) {
      loadmore = false;

      if (homepost_data.isNotEmpty) {
        count++;
        if (count == 1) {
          offset = offset + 21;
        } else {
          offset = offset + 20;
        }
        _onLoading();
        get_HomePost();
      } else if (homepostsearch_data.isNotEmpty) {
        count++;
        if (count == 1) {
          offset = offset + 21;
        } else {
          offset = offset + 20;
        }
        _onLoading();
        get_HomePostSearch();
      }
    }
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
                0.85, // Initial height as a fraction of screen height
            builder: (BuildContext context, ScrollController scrollController) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return const FilterScreen();
                },
              );
            })).then(
      (value) {
        _loc.text = constanst.location.toString();
        category_filter_id = constanst.select_categotyId.join(",");
        type_id = constanst.select_typeId.join(",");
        grade_id = constanst.select_gradeId.join(",");
        bussinesstype = constanst.selectbusstype_id.join(",");

        post_type = constanst.select_categotyType.join(",");

        homepost_data.clear();
        _onLoading();

        get_HomePost();
        constanst.select_categotyId.clear();
        constanst.select_typeId.clear();
        constanst.select_gradeId.clear();
        constanst.selectbusstype_id.clear();
        constanst.select_categotyType.clear();

        setState(() {});
      },
    );
  }

  getBussinessProfile() async {
    GetmybusinessprofileController bt = GetmybusinessprofileController();
    SharedPreferences pref = await SharedPreferences.getInstance();
    constanst.getmyprofile = bt.Getmybusiness_profile(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString());

  }

  getBussinessProfile1() async {
    String apiUrl = 'https://www.plastic4trade.com/api/getmybusinessprofile';
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> requestData = {
      'userId': pref.getString('user_id').toString(),
      'userToken': pref.getString('api_token').toString(),
      // Add any other required parameters
    };
    Response response;
    try {
      response = await dio.post(apiUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          // Successful response
          // Process the response data
        } else {
          // Handle other status codes
        }
      } else {
        // Dio request error
      }
    } catch (e) {
    }
  }

  void get_categorylist() async {
    GetCategoryController bt = GetCategoryController();
    constanst.cat_data = bt.setlogin();

    constanst.cat_data!.then((value) {
      for (var item in value) {
        constanst.catdata.add(item);
      }
      setState(() {});
    });
  }

  void get_categorylist1() async {
    Dio dio = Dio();
    try {
      Response response =
          await dio.get('https://www.plastic4trade.com/api/getCategoryList');

      // Handle the response data
      if (response.statusCode == 200) {
        // API call was successful
        // Process the data
      } else {
        // API call failed
      }
    } catch (e) {
      // Handle any errors that occurred during the API call
    }
  }

  get_Slider() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getSlider(pref.getString('user_id').toString(),
        pref.getString('api_token').toString());
    var jsonarray;
    if (res['status'] == 1) {
      jsonarray = res['result'];

      for (var data in jsonarray) {
        img.Result record = img.Result(
            bannertype: data['bannertype'], bannerImage: data['BannerImage']);
        banner_img.add(record);
      }
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
  }

  getquicknews() async {

    var res = await gethomequicknew();
    var jsonarray;
    if (res['status'] == 1) {
      quicknews = res['result'];

      isload = true;
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
  }

  getQuick() async {
    String url =
        "https://www.plastic4trade.com/api/getHomeQuickNewsList"; // Replace with your API endpoint URL

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      // API call successful
      // Process the data as needed
    } else {
      // API call failed
    }
  }

  get_HomePost() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getHome_Post(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
      offset.toString(),
      category_id,
      category_filter_id,
      grade_id,
      type_id,
      bussinesstype,
      post_type,
      constanst.lat,
      constanst.log,
      _search.text.toString(),
    );
    var jsonArray;
    if (res['status'] == 1) {
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
              mainproductImage: data['mainproductImage']);

          homepost_data.add(record);
          loadmore = true;
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

  void fetchData() async {
    try {
      Response response = await dio.get(
          'https://www.plastic4trade.com/api/getHomePost?userId=14969&userToken=0a1d9eb634ed272eb897bfcbb9a8f8b1&category_id=""&limit=0&offset=20');
      if (response.statusCode == 200) {
        // Request was successful
        // Process the data here
      } else {
        // Handle error cases
      }
    } catch (e) {
      // Handle exceptions
    }
  }

  get_HomePostSearch() async {

    var res = await getHomeSearch_Post(lat.toString(), log.toString(),
        _search.text.toString(), '20', offset.toString());
    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];

        for (var data in jsonArray) {
          homesearch.Result record = homesearch.Result(
              postName: data['PostName'],
              categoryName: data['CategoryName'],
              productGrade: data['ProductGrade'],
              currency: data['Currency'],
              productPrice: data['ProductPrice'],
              state: data['State'],
              country: data['Country'],
              postType: data['PostType'],
              isPaidPost: data['is_paid_post'],
              productType: data['ProductType'],
              productId: data['productId'],
              mainproductImage: data['mainproductImage']);
          homepostsearch_data.add(record);
          loadmore = true;
        }
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonArray;
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      _loc.text = constanst.location.toString();
      SharedPreferences pref = await SharedPreferences.getInstance();
      constanst.step = int.parse(pref.getString('step').toString());
      // DateTime startTime = DateTime.now();
      get_categorylist();
      getBussinessProfile();
      get_Slider();

      get_HomePost();
      getquicknews();
      Firebase_init();
    }
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification != null) {
    }
  }

  Firebase_init() async {
    if (Platform.isAndroid) {
      await Firebase.initializeApp();

      final firebaseMessaging0 = FirebaseMessaging.instance;
      await firebaseMessaging0.requestPermission();
      final FCMToken = await firebaseMessaging0
          .getToken(
              vapidKey:
                  "BC4eLOdjJWopUE-NEu_WCFLlByPe5-K5_AljnUINqx4QL7RmA3W5lC-__7WDfEWPJF0nVk05xpD3d4JjdrGnfVA")
          .then((value) => value);
      constanst.fcm_token = FCMToken.toString();
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isIOS) {
      await Firebase.initializeApp();
      final firebaseMessaging = FirebaseMessaging.instance;
      await firebaseMessaging.requestPermission();
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      final APNSToken =
          await firebaseMessaging.getToken().then((value) => value);
      constanst.APNSToken = APNSToken.toString();
      /* */ //);
    }
    if (FirebaseMessaging.instance.isAutoInitEnabled) {
    } else {
    }
    FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true);
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
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsios);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        // ignore: unnecessary_non_null_assertion
        final message = RemoteMessage.fromMap(jsonDecode(payload!));
        String notificationType = message.data['type'];
        String userId = message.data['user_id'];

        if (notificationType.toString() == "profile like") {
          if (userId.toString().isNotEmpty) {
            // Navigator.of(_context).push(MaterialPageRoute(builder: (context) => other_user_profile(int.parse(user_id.toString()))));
            try {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          other_user_profile(int.parse(userId.toString()))));
            } catch (e) {
            }
          } else {
          }
        } else if (notificationType.toString() == "Business profile dislike") {
          if (userId.toString().isNotEmpty) {
            // Navigator.of(_context).push(MaterialPageRoute(builder: (context) => other_user_profile(int.parse(user_id.toString()))));
            try {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          other_user_profile(int.parse(userId.toString()))));
            } catch (e) {}
          } else {
          }
        } else if (message.data['type'] == 'profile_review') {
          try {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const bussinessprofile()));
          } catch (e) {}
        } else if (message.data['type'] == 'follower_profile_like') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => other_user_profile(
                      int.parse(constanst.notiuser.toString()))));
        } else if (message.data['type'] == 'Business profile dislike') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => other_user_profile(
                      int.parse(constanst.notiuser.toString()))));
        } else if (message.data['type'] == "post like") {
          if (constanst.notypost_type.toString() == "SalePost") {
            if (constanst.notipostid.toString().isNotEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Buyer_sell_detail(
                          post_type: 'SalePost',
                          prod_id: constanst.notipostid)));
            }
          } else {
            if (constanst.notypost_type.toString() == "BuyPost") {
              if (constanst.notipostid.toString().isNotEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Buyer_sell_detail(
                            post_type: 'BuyPost',
                            prod_id: constanst.notipostid)));
              }
            }
          }
        } else if (message.data['type'] == "unfollowuser") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const follower(initialIndex: 0,)));
        } else if (message.data['type'] == "followuser") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const follower(initialIndex: 0,)));
        } else if (message.data['type'] == "profile_review") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => other_user_profile(
                      int.parse(constanst.notiuser.toString()))));
        } else if (message.data['type'] == "live_price") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LivepriceScreen()));
        } else if (message.data['type'] == "quick_news_notification") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen(3)));
        } else if (message.data['type'] == "news") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen(3)));
        } else if (message.data['type'] == "blog") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Blog()));
        } else if (message.data['type'] == "video") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Videos()));
        } else if (message.data['type'] == "banner") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen(0)));
        } else if (message.data['type'] == "tutorial_video") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Tutorial_Videos()));
        } else if (message.data['type'] == "exhibition") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Exhibition()));
        } else if (message.data['type'] == "quicknews") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen(3)));
        }
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {}
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {

        String userId = message.data['user_id'];
        if (message.data['type'] == 'profile like') {
          try {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        other_user_profile(int.parse(userId.toString()))));
          } catch (e) {

          }
        } else if (message.data['type'] == 'profile_review') {
          try {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const bussinessprofile()));
          } catch (e) {

          }
        } else if (message.data['type'] == 'follower_profile_like') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => other_user_profile(
                      int.parse(constanst.notiuser.toString()))));
        } else if (message.data['type'] == 'Business profile dislike') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => other_user_profile(
                      int.parse(constanst.notiuser.toString()))));
        } else if (message.data['type'] == "post like") {
          if (message.data['post_type'] == "SalePost") {
            if (message.data['postId'].toString().isNotEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Buyer_sell_detail(
                          post_type: 'SalePost',
                          prod_id: message.data['postId'])));
            }
          } else {
            if (message.data['post_type'] == "BuyPost") {
              if (message.data['postId'].toString().isNotEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Buyer_sell_detail(
                            post_type: 'BuyPost',
                            prod_id: message.data['postId'])));
              }
            }
          }
        } else if (message.data['type'] == "unfollowuser") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const follower(initialIndex: 0,)));
        } else if (message.data['type'] == "followuser") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const follower(initialIndex: 0,)));
        } else if (message.data['type'] == "profile_review") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => other_user_profile(
                      int.parse(constanst.notiuser.toString()))));
        } else if (message.data['type'] == "live_price") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LivepriceScreen()));
        } else if (message.data['type'] == "quick_news_notification") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen(3)));
        } else if (message.data['type'] == "news") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen(3)));
        } else if (message.data['type'] == "blog") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Blog()));
        } else if (message.data['type'] == "video") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Videos()));
        } else if (message.data['type'] == "banner") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen(0)));
        } else if (message.data['type'] == "tutorial_video") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Tutorial_Videos()));
        } else if (message.data['type'] == "exhibition") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Exhibition()));
        } else if (message.data['type'] == "quicknews") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen(3)));
        }
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      //_context=context;
      final notification = message.notification;
      if (notification == null) return;
      final localNotificationImplementation =
          _localNotification.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (localNotificationImplementation != null) {
        localNotificationImplementation
            .createNotificationChannel(_androidchannel);
      }
      _localNotification.show(
        notification.hashCode,
        notification.title ?? '',
        notification.body ?? '',
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidchannel.id, // Provide a default value
            _androidchannel.name, // Provide a default value
            channelDescription:
                _androidchannel.description ?? 'Default Channel Description',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            styleInformation: const DefaultStyleInformation(true, true),
            icon: '@drawable/ic_launcher',
          ),
          iOS: const IOSNotificationDetails(),
        ),
        payload: jsonEncode(message.toMap()),
      );
      AndroidNotification? notification1 = message.notification?.android;
      if (notification1 != null) {
      }

    });

  }

  Clear_date() {
    constanst.catdata.clear();
  }
}
