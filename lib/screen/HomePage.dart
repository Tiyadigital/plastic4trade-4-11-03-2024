import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Plastic4trade/screen/CategoryScreen.dart';
import 'package:Plastic4trade/screen/GradeScreen.dart';
import 'package:Plastic4trade/screen/Type.dart';
import 'package:Plastic4trade/widget/AddPost_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:Plastic4trade/screen/AddPost.dart';
import 'package:Plastic4trade/screen/Buyer_sell_detail.dart';
import 'package:marquee/marquee.dart';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../api/api_interface.dart';
import '../constroller/GetCategoryController.dart';
import '../constroller/Getmybusinessprofile.dart';
import '../main.dart';
import '../model/GetNotification.dart';
import '../model/Getmybusinessprofile.dart';
import '../model/common.dart';
import '../model/getBannerImage.dart';
import '../model/getHomePost.dart';
import '../model/getHomePostSearch.dart';
import '../utill/constant.dart';
import 'package:Plastic4trade/widget/FilterScreen.dart';
import 'package:Plastic4trade/model/getBannerImage.dart' as img;
import 'package:Plastic4trade/model/getHomePost.dart' as homepost;
import 'package:Plastic4trade/model/getHomePostSearch.dart' as homesearch;
import 'package:Plastic4trade/model/GetCategory.dart' as cat;

import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../widget/HomeAppbar.dart';
import '../widget/MainScreen.dart';
import 'Blog.dart';
import 'BussinessProfile.dart';
import 'Exhibition.dart';
import 'Follower_Following.dart';
import 'Liveprice.dart';
import 'Register2.dart';
import '../model/gethome_quicknews.dart';
import 'Tutorial_Videos.dart';
import 'Videos.dart';
import 'demo.dart';
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
  TextEditingController _loc = TextEditingController();
  TextEditingController _search = TextEditingController();
  Timer? _timer;
  Dio dio = Dio();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final _androidchannel = AndroidNotificationChannel(
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
          backgroundColor: Color(0xFFDADADA),
          body: isload == true
              ? Column(mainAxisSize: MainAxisSize.min, children: [
                  horiztallist(),
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                    height: 50,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(40.0),
                                    bottomRight: Radius.circular(40.0),
                                    topLeft: Radius.circular(40.0),
                                    bottomLeft: Radius.circular(40.0)),
                                color: Colors.white),
                            height: 40,
                            margin: EdgeInsets.only(left: 8.0),
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Padding(
                                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                child: TextField(
                                  controller: _loc,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  readOnly: true,
                                  onTap: () async {
                                    var place = await PlacesAutocomplete.show(
                                        context: context,
                                        apiKey: googleApikey,
                                        mode: Mode.overlay,
                                        types: ['(cities)'],
                                        strictbounds: false,
                                        // components: [Component(Component.country, 'np')],
                                        //google_map_webservice package
                                        onError: (err) {
                                          print(err);
                                        });

                                    if (place != null) {
                                      setState(() {
                                        location = place.description.toString();
                                        constanst.location =
                                            place.description.toString();
                                        _loc.text = location!;

                                        /*

                                  List<String> list = place.description.toString().split(",");
                                  list.length>2?state =list[1].toString():state ='';
                                  list.length>=3?country =list[2].toString():country ='';
                                  city=list[0];
                                  print(list);
                                  print(state);
                                  print(city);
                                  print(country);

                                  _color5=Colors.green.shade600;
                                  // print(location);
                                  setState(() {

                                  });*/
                                      });

                                      //form google_maps_webservice package
                                      final plist = GoogleMapsPlaces(
                                        apiKey: googleApikey,
                                        apiHeaders: await GoogleApiHeaders()
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
                                      print(constanst.log);
                                      homepost_data.clear();
                                      count = 0;
                                      offset = 0;
                                      //get_HomePostSearch();
                                      WidgetsBinding
                                          .instance?.focusManager.primaryFocus
                                          ?.unfocus();
                                      _onLoading();
                                      get_HomePost();
                                      setState(() {});
                                      // var newlatlang = LatLng(lat, log);

                                      //move map camera to selected place with animation
                                      //mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                                    }
                                  },
                                  textAlign: TextAlign.start,
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 1.0),
                                    prefixIconConstraints:
                                        BoxConstraints(minWidth: 24),
                                    suffixIconConstraints:
                                        BoxConstraints(minWidth: 24),
                                    prefixIcon: Padding(
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
                                      child: Padding(
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
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontFamily:
                                          'assets\fonst\Metropolis-Black.otf',
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
                            margin: EdgeInsets.only(left: 6.0),
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Padding(
                                padding: EdgeInsets.only(left: 5.0, right: 5.0),
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
                                              'assets\fonst\Metropolis-Black.otf')),
                                  onSubmitted: (value) {
                                    WidgetsBinding
                                        .instance?.focusManager.primaryFocus
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
                                          .instance?.focusManager.primaryFocus
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
                                margin: EdgeInsets.only(
                                    bottom: 4.0, left: 1.2, top: 2.0),
                                padding: EdgeInsets.all(3.0),
                                width: MediaQuery.of(context).size.width / 11,
                                // padding: EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Icon(
                                  Icons.filter_alt,
                                  color: Colors.black,
                                )))
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                        controller: scrollercontroller,
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            slider_home(),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 20,
                              child: Marquee(
                                text: quicknews.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.0,
                                    color: Colors.black),
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                blankSpace: 20.0,
                                velocity: 100.0,
                                pauseAfterRound: Duration(seconds: 1),
                                startPadding: 10.0,
                                accelerationDuration: Duration(seconds: 1),
                                accelerationCurve: Curves.linear,
                                decelerationDuration:
                                    Duration(milliseconds: 500),
                                decelerationCurve: Curves.easeOut,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            category()
                          ],
                        )),
                  ),
                  // Flexible(
                  //     child: Marquee(
                  //       text: 'The quick brown fox jumps over the lazy dog',
                  //       style: TextStyle(fontWeight: FontWeight.bold, fontSize:20),
                  //       scrollAxis: Axis.horizontal, //scroll direction
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       blankSpace: 20.0,
                  //       velocity: 50.0, //speed
                  //       pauseAfterRound: Duration(seconds: 1),
                  //       startPadding: 10.0,
                  //       accelerationDuration: Duration(seconds: 1),
                  //       accelerationCurve: Curves.linear,
                  //       decelerationDuration: Duration(milliseconds: 500),
                  //       decelerationCurve: Curves.easeOut,
                  //     )
                  // ),
                ])
              : Center(
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
          floatingActionButton: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/floating_back.png")),
                borderRadius: BorderRadius.circular(30)),
            child: IconButton(
              onPressed: () {
                constanst.redirectpage = "add_post";
                /* constanst.productId=result.productId.toString();
                constanst.post_type=result.postType.toString();*/
                //constanst.redirectpage="sale_buy";
                print(constanst.appopencount);
                print(constanst.appopencount1);
                print(constanst.isprofile);
                print(constanst.iscategory);
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
                          builder: (context) => AddPost(),
                        ));
                  } else if (constanst.isprofile) {
                    showInformationDialog(context);
                  } else if (constanst.iscategory) {
                    constanst.redirectpage = "add_cat";
                    //Fluttertoast.showToast(msg: 'i m category');
                    categoryDialog(context);
                  } else if (constanst.isgrade) {
                    constanst.redirectpage = "add_type";
                    categoryDialog(context);
                  } else if (constanst.istype) {
                    constanst.redirectpage = "add_grade";
                    categoryDialog(context);
                  } else if (constanst.step != 11) {
                    addPostDialog(context);
                  }
                  /* else {
                   showInformationDialog(context);
                 }*/
                } else {
                  if (constanst.isprofile) {
                    showInformationDialog(context);
                  } else if (constanst.iscategory) {
                    constanst.redirectpage = "add_cat";
                    //Fluttertoast.showToast(msg: 'i m category');
                    //categoryDialog(context);
                   /* Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryScreen(),
                        ));*/
                    categoryDialog(context);
                  } else if (constanst.isgrade) {
                    constanst.redirectpage = "add_type";
                   /* Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Type(),
                        ));*/
                    categoryDialog(context);
                    //categoryDialog(context);
                  } else if (constanst.istype) {
                    constanst.redirectpage = "add_grade";
                    //categoryDialog(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Grade(),
                        ));
                  } else if (constanst.step != 11) {
                    // addPostDialog(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPost(),
                        ));
                  } else if (!constanst.isgrade &&
                      !constanst.istype &&
                      !constanst.iscategory &&
                      !constanst.isprofile &&
                      constanst.step == 11) {
                    print(constanst.step);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPost(),
                        ));
                  }
                }
              },
              icon: Icon(Icons.add, color: Colors.white, size: 40),
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
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Show a toast or snackbar message to inform the user to tap again to exit
      /* ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tap again to exit')),
      );*/
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
          margin: EdgeInsets.symmetric(horizontal: 32.0),
          padding: EdgeInsets.fromLTRB(3.0, 8.0, 3.0, 8.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 70,
                width: 50,
                // margin: EdgeInsets.all(5.0),
                /* decoration: BoxDecoration(
                                          //color: Colors.black26,
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(30.0))),*/
                child: Image.asset(
                  "assets/plastic4trade logo final 1 (2).png",

                  //fit: BoxFit.fitHeight,
                  // height: 100,
                  width: 70,
                ),
              ),
              SizedBox(width: 8.0),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Text(
                    'Please tap again to exit',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'assets\fonst\Metropolis-Black.otf',
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
    Future.delayed(Duration(seconds: 2)).then((value) {
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
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            //List<dynamic> users = snapshot.data as List<dynamic>;
            return ListView.builder(
                shrinkWrap: false,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: constanst.catdata.length,
                itemBuilder: (context, index) {
                  cat.Result result = constanst.catdata[index];
                  return Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Wrap(spacing: 6.0, runSpacing: 6.0, children: <
                          Widget>[
                        ChoiceChip(
                          label: Text(
                              constanst.catdata[index].categoryName.toString()),
                          selected: _defaultChoiceIndex == index,
                          selectedColor: Color.fromARGB(255, 0, 91, 148),
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
                          // padding: EdgeInsets.all(5),
                          backgroundColor: Color.fromARGB(255, 236, 232, 232),
                          labelStyle: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets\fonst\Metropolis-Black.otf')
                              ?.copyWith(
                                  color: _defaultChoiceIndex == index
                                      ? Colors.white
                                      : Colors.black),
                          labelPadding: EdgeInsets.symmetric(horizontal: 14.0),
                          /*shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),*/
                        )
                      ]));
                });
          }
        }));
  }

  /*Widget slider() {
    return GFCarousel(
      autoPlay: true,
      pagerSize: 2.0,
      viewportFraction: 1.0,
      aspectRatio: 2,
      // hasPagination: true,
      //
      // activeIndicator: Colors.lightBlue,

      items: imageList.map(
        (url) {
          return Container(
            //margin: EdgeInsets.fromLTRB(5, 0, 5,0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              child: Image.asset(url, fit: BoxFit.cover, width: 2500.0),
            ),
          );
        },
      ).toList(),
      onPageChanged: (index) {
        setState(() {
          index;
          //cat_data.clear();
        });
      },
    );

  }*/

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
                  ? Container(
                      child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      child: Image.network(record.bannerImage.toString(),
                          fit: BoxFit.fill, width: 2500.0),
                    ))
                  : web_view(record.bannerImage.toString());

              new Center(
                child: new Text(record.bannerImage.toString()),
              );
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
          /* onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },*/
        ),
      )
      ..loadRequest(Uri.parse(imageurl));
    return Container(
      /*child: WebView(
          zoomEnabled: true ,
          initialUrl: imageurl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController){
            web_controller = webViewController;
          },
        )*/
      child: WebViewWidget(controller: web_controller as WebViewController),
    );
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
                              : Container()),
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
            ));
      },
    );

    Future.delayed(const Duration(seconds: 5), () {
      print('exit');
      Navigator.of(dialogContext)
          .pop(); // Use dialogContext to close the dialog
      print('exit1'); // Dialog closed
    });
  }

  /* double calculateAspectRatio(BuildContext context) {
    // Define your desired aspect ratio
    double desiredAspectRatio = 0.5;

    // Calculate available width
    double screenWidth = MediaQuery.of(context).size.width;
    double crossAxisSpacing = 15; // Adjust this based on your actual spacing
    int crossAxisCount = 2; // Adjust this based on your actual cross axis count
    double availableWidth = screenWidth - ((crossAxisCount - 1) * crossAxisSpacing);

    // Calculate width per child based on the available width and desired aspect ratio
    double childWidth = availableWidth / crossAxisCount;
    double childHeight = childWidth / desiredAspectRatio;

    // Return the calculated aspect ratio
    return childWidth / childHeight;
  }*/

  Widget category() {
    return FutureBuilder(
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
        return LayoutBuilder(builder: (context, constraints) {
          return GridView.builder(
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // childAspectRatio:MediaQuery.of(context).size.height < 750 ? .50: MediaQuery.of(context).size.height < 825 ? .65 :MediaQuery.of(context).size.height < 850 ? .62 : MediaQuery.of(context).size.height < 800 ? .73: .619,
              childAspectRatio: MediaQuery.of(context).size.width / 620,
            ),
            physics: NeverScrollableScrollPhysics(),
            itemCount: homepost_data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              homepost.Result result = homepost_data[index];
              return GestureDetector(
                onTap: (() {
                  constanst.productId = result.productId.toString();
                  constanst.post_type = result.postType.toString();
                  constanst.redirectpage = "sale_buy";
                  print(constanst.appopencount);
                  print(constanst.appopencount1);

                  print(constanst.isprofile);
                  print(constanst.iscategory);
                  print(constanst.istype);
                  print(constanst.isgrade);
                  if (constanst.appopencount == constanst.appopencount1) {
                    Fluttertoast.showToast(msg: "123");
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
                            builder: (context) => Buyer_sell_detail(
                                prod_id: result.productId.toString(),
                                post_type: result.postType.toString()),
                          ));
                    } else if (constanst.isprofile) {
                      showInformationDialog(context);
                    } else if (constanst.iscategory) {
                      //Fluttertoast.showToast(msg: 'i m category');
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
                    if (!constanst.isgrade &&
                        !constanst.istype &&
                        !constanst.iscategory &&
                        !constanst.isprofile &&
                        constanst.step == 11) {
                      print(constanst.step);

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
                      //Fluttertoast.showToast(msg: 'i m category');
                      categoryDialog(context);
                    } else if (constanst.isgrade) {
                      categoryDialog(context);
                    } else if (constanst.istype) {
                      categoryDialog(context);
                    } else if (constanst.step != 11) {
                      addPostDialog(context);
                    }
                    /* if (constanst.isprofile) {
                   showInformationDialog(context);
                 } else if (constanst.iscategory) {
                   //Fluttertoast.showToast(msg: 'i m category');
                   categoryDialog(context);
                 } else if (constanst.isgrade) {
                   categoryDialog(context);
                 } else if (constanst.istype) {
                   categoryDialog(context);
                 } else if (constanst.step != 11) {
                   addPostDialog(context);
                 } else if (!constanst.isgrade &&
                     !constanst.istype &&
                     !constanst.iscategory &&
                     !constanst.isprofile && constanst.step == 11) {
                   print(constanst.step);

                   Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) =>
                             Buyer_sell_detail(
                                 prod_id: result.productId.toString(),
                                 post_type: result.postType.toString()),
                       ));
                */ /*   Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) =>
                             demo()));*/ /*
                 }*/
                  }
                }),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(children: [
                    Stack(fit: StackFit.passthrough, children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 4.8,
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
                        /* child:Image(
                        errorBuilder: (context, object, trace) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(
                                  255, 223, 220, 220),
                            ),
                          );
                        },
                        image: NetworkImage(result.mainproductImage.toString()),fit: BoxFit.cover,width: 170,height: 150,
                    ),*/
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5.0),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 0, 148, 95),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          // color: Color.fromARGB(0,255, 255, 255),
                          child: Text('₹' + result.productPrice.toString(),
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
                              padding: EdgeInsets.only(top: 10.0, left: 10.0),
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
                              padding: EdgeInsets.only(top: 10.0, left: 10.0),
                              child: Text(
                                  result.categoryName.toString() +
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
                              padding: EdgeInsets.only(top: 10.0, left: 10.0),
                              child: Text(
                                  result.state.toString() +
                                      ', ' +
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
                                padding: EdgeInsets.only(top: 10.0, left: 10.0),
                                child: result.postType.toString() == "BuyPost"
                                    ? Text(
                                        'Buy Post',
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontFamily: 'Metropolis',
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Color.fromRGBO(0, 148, 95, 1)),
                                      )
                                    : result.postType.toString() == "SalePost"
                                        ? Text(
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

        return CircularProgressIndicator();
      }
    });
    /*: Expanded(
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
                  padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    // crossAxisCount: 2,
                    // mainAxisSpacing: 5,
                    // crossAxisSpacing: 5,
                    // childAspectRatio: .90,
                    childAspectRatio: MediaQuery.of(context).size.height /
                        1250, //MediaQuery.of(context).size.aspectRatio * 1.3,
                    mainAxisSpacing: 3.0,
                    crossAxisCount: 2,
                  ),
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: scrollercontroller,
                  itemCount: homepostsearch_data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    homesearch.Result result = homepostsearch_data[index];
                    return GestureDetector(
                      onTap: (() {
                        if (!constanst.isgrade &&
                            !constanst.istype &&
                            !constanst.iscategory &&
                            !constanst.isprofile) {
                          print(constanst.step);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Buyer_sell_detail(
                                  prod_id: result.productId.toString(),
                                  post_type: result.postType.toString(),
                                ),
                              ));
                        } else {
                          showInformationDialog(context);
                        }
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
                                */ /*shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10.0)),*/ /*
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
                                      */ /*decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0))),*/ /*
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
                                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'),
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
            }),
          );*/
  }

  void _scrollercontroller() {
    if (scrollercontroller.position.pixels ==
        scrollercontroller.position.maxScrollExtent) {
      loadmore = false;

      if (homepost_data.isNotEmpty) {
        print('hello');
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
    } /*else{
      print('hello');
    }*/
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
                  return FilterScreen();
                },
              );
            })).then(
      (value) {
        print(constanst.location);
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
    /* Getmybusinessprofile register = Getmybusinessprofile();
    SharedPreferences _pref = await SharedPreferences.getInstance();


    var res = await getbussinessprofile(_pref.getString('user_id').toString(),
      _pref.getString('api_token').toString(),);

    if (res['status'] == 1) {
      register = Getmybusinessprofile.fromJson(res);
      if(register.profile==null){
        constanst.isprofile=true;
      }else if(register.user!.categoryId.isEmpty){
        constanst.iscategory=true;
      }else if(register.user!.typeId.isEmpty){
        constanst.istype=true;
      }else if(register.user!.gradeId.isEmpty){
        constanst.isgrade=true;
      }
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res['message']);

      setState(() {});
    }*/
    GetmybusinessprofileController bt = await GetmybusinessprofileController();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    constanst.getmyprofile = bt.Getmybusiness_profile(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());

    // setState(() {});
    // print(constanst.btype_data);
  }

  getBussinessProfile1() async {
    String apiUrl = 'https://www.plastic4trade.com/api/getmybusinessprofile';
    SharedPreferences _pref = await SharedPreferences.getInstance();
    Map<String, dynamic> requestData = {
      'userId': _pref.getString('user_id').toString(),
      'userToken': _pref.getString('api_token').toString(),
      // Add any other required parameters
    };
    Response response;
    try {
      response = await dio.post(apiUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          // Successful response
          Map<String, dynamic> responseData = response.data;
          // Process the response data
        } else {
          // Handle other status codes
          print('Request failed with status code: ${response.statusCode}');
        }
      } else {
        // Dio request error
        print('Dio request error');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void get_categorylist() async {
    GetCategoryController bt = await GetCategoryController();
    constanst.cat_data = bt.setlogin();

    constanst.cat_data!.then((value) {
      if (value != null) {
        for (var item in value) {
          constanst.catdata.add(item);
        }
      }

      setState(() {});
    });
    //
  }

  void get_categorylist1() async {
    Dio dio = Dio();
    try {
      Response response =
          await dio.get('https://www.plastic4trade.com/api/getCategoryList');

      // Handle the response data
      if (response.statusCode == 200) {
        // API call was successful
        var data = response.data;
        // Process the data
      } else {
        // API call failed
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occurred during the API call
      print('Error: $e');
    }
  }

  get_Slider() async {
    getBannerImage getcoloregory = getBannerImage();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getSlider(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getcoloregory = getBannerImage.fromJson(res);
      jsonarray = res['result'];
      print(jsonarray);

      for (var data in jsonarray) {
        img.Result record = img.Result(
            bannertype: data['bannertype'], bannerImage: data['BannerImage']);
        banner_img.add(record);
      }
      print(banner_img);
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
    setState(() {});
  }

  getquicknews() async {
    gethome_quicknews quicknes = gethome_quicknews();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await gethomequicknew();
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      quicknes = gethome_quicknews.fromJson(res);
      quicknews = res['result'];
      print(jsonarray);

/*
      for (var data in jsonarray) {
        img.Result record = img.Result(
            bannertype: data['bannertype'], bannerImage: data['BannerImage']);
        banner_img.add(record);
      }
      print(banner_img);*/
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
      var data = response.data;
      // Process the data as needed
      print(data);
    } else {
      // API call failed
      print('API call failed with status code ${response.statusCode}');
    }
  }

  get_HomePost() async {
    getHomePost gethomepost = getHomePost();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getHome_Post(
      _pref.getString('user_id').toString(),
      _pref.getString('api_token').toString(),
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
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      gethomepost = getHomePost.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];
        print(jsonarray);

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
              mainproductImage: data['mainproductImage']);

          homepost_data.add(record);
          loadmore = true;
        }
        print(homepost_data);
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
  }

  void fetchData() async {
    try {
      Response response = await dio.get(
          'https://www.plastic4trade.com/api/getHomePost?userId=14969&userToken=0a1d9eb634ed272eb897bfcbb9a8f8b1&category_id=""&limit=0&offset=20');
      if (response.statusCode == 200) {
        // Request was successful
        var data = response.data;
        // Process the data here
      } else {
        // Handle error cases
      }
    } catch (e) {
      // Handle exceptions
    }
  }

  get_HomePostSearch() async {
    getHomePostSearch gethomepostsearch = getHomePostSearch();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getHomeSearch_Post(lat.toString(), log.toString(),
        _search.text.toString(), '20', offset.toString());
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      gethomepostsearch = getHomePostSearch.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];
        print(jsonarray);

        for (var data in jsonarray) {
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
        print(homepostsearch_data);
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
    setState(() {});
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      _loc.text = constanst.location.toString();
      SharedPreferences _pref = await SharedPreferences.getInstance();
      constanst.step = int.parse(_pref.getString('step').toString());
      // DateTime startTime = DateTime.now();
      get_categorylist();
      getBussinessProfile();
      get_Slider();
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      //getSlider1();
      get_HomePost();
      getquicknews();
      Firebase_init();
      //DateTime endTime = DateTime.now();
      // Duration duration = endTime.difference(startTime);

      // Print the duration in milliseconds
      //print('using http API call took ${duration.inMilliseconds} inMilliseconds');

      // get_data();
    }
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print(message.notification);
    final notification = message.notification;
    if (notification != null) {
      print('Title : ${notification.title}');
      print('Body : ${notification.body}');
    }
    if (message.data != null) {
      print('PayLoad: ${message.data}');
      // You can perform further processing with the data here
    }

    //notification_redirect(message.data, context); // Are you sure 'context' is properly initialized here?
  }

  Firebase_init() async {
    if (Platform.isAndroid) {
      print('Android ');
      await Firebase.initializeApp();

      final _firebaseMessaging = FirebaseMessaging.instance;
      await _firebaseMessaging.requestPermission();
      final FCMToken = await _firebaseMessaging
          .getToken(
              vapidKey:
                  "BC4eLOdjJWopUE-NEu_WCFLlByPe5-K5_AljnUINqx4QL7RmA3W5lC-__7WDfEWPJF0nVk05xpD3d4JjdrGnfVA")
          .then((value) => value);
      constanst.fcm_token = FCMToken.toString();
      print('Token $FCMToken');
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isIOS) {
      await Firebase.initializeApp();
      final _firebaseMessaging = FirebaseMessaging.instance;
      await _firebaseMessaging.requestPermission();
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      final APNSToken =
          await _firebaseMessaging.getToken().then((value) => value);
      constanst.APNSToken = APNSToken.toString();
      print('APNSToken $APNSToken');
      /* */ //);
    }
    if (FirebaseMessaging.instance.isAutoInitEnabled) {
      print('User granted permission');
    } else {
      print('User declined permission or has not yet responded');
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
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsios);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        print(payload);
        final message = RemoteMessage.fromMap(jsonDecode(payload!));
        String notification_type = message.data['type'];
        String post_type = message.data['post_type'];
        String user_id = message.data['user_id'];
        String post_id = message.data['postId'];

        print('post type');
        print(notification_type);
        print(user_id);
        print(post_id);
        if (notification_type.toString() == "profile like") {
          if (user_id.toString().isNotEmpty) {
            print('=============');
            // Navigator.of(_context).push(MaterialPageRoute(builder: (context) => other_user_profile(int.parse(user_id.toString()))));
            try {
              await Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          other_user_profile(int.parse(user_id.toString()))));
            } catch (e, stackTrace) {
              // Handle the exception or error
              // Fluttertoast.showToast(msg:'Exception: $e');
              // Fluttertoast.showToast(msg:'Stack trace: $stackTrace');
              print('Exception: $e');
              print('Stack trace: $stackTrace');
            }
          } else {
            print('11111111');
          }
        } else if (notification_type.toString() == "Business profile dislike") {
          if (user_id.toString().isNotEmpty) {
            print('=============');
            // Navigator.of(_context).push(MaterialPageRoute(builder: (context) => other_user_profile(int.parse(user_id.toString()))));
            try {
              await Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          other_user_profile(int.parse(user_id.toString()))));
            } catch (e, stackTrace) {
              // Handle the exception or error
              // Fluttertoast.showToast(msg:'Exception: $e');
              // Fluttertoast.showToast(msg:'Stack trace: $stackTrace');
              print('Exception: $e');
              print('Stack trace: $stackTrace');
            }
          } else {
            print('11111111');
          }
        }
       else if (message.data['type'] == 'profile_review') {
          print("kjdis");
          try {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => bussinessprofile()));
          } catch (e, stackTrace) {
            // Handle the exception or error
            // Fluttertoast.showToast(msg:'Exception: $e');
            // Fluttertoast.showToast(msg:'Stack trace: $stackTrace');
            print('Exception: $e');
            print('Stack trace: $stackTrace');
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
          print("gfdghf");
          if (constanst.notypost_type.toString() == "SalePost") {
            print("gfdghf1233");
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
              print("gfdghf");
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
          print("hfuihdgiufhrghdriugiorh");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => follower()));
        } else if (message.data['type'] == "followuser") {
          print("hfuihdgiufhrghdriugiorh");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => follower()));
        } else if (message.data['type'] == "profile_review") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => other_user_profile(
                      int.parse(constanst.notiuser.toString()))));
        } else if (message.data['type'] == "live_price") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LivepriceScreen()));
        } else if (message.data['type'] == "quick_news_notification") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen(3)));
        } else if (message.data['type'] == "news") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen(3)));
        } else if (message.data['type'] == "blog") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Blog()));
        } else if (message.data['type'] == "video") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Videos()));
        } else if (message.data['type'] == "banner") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen(0)));
        } else if (message.data['type'] == "tutorial_video") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Tutorial_Videos()));
        } else if (message.data['type'] == "exhibition") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Exhibition()));
        } else if (message.data['type'] == "quicknews") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen(3)));
        }
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        print('inside open');
        //Fluttertoast.showToast(msg: 'APP Terminate ');
        //_context = context;
        //notification_redirect(value!.data, _context);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print('inside open');
        // _context=context;
        // notification_redirect(message.data,_context);
        String notification_type = message.data['type'];
        String user_id = message.data['user_id'];
        print('saqwagrgr ${message.data}');
        if (message.data['type'] == 'profile like') {
          try {
            print('i m try');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        other_user_profile(int.parse(user_id.toString()))));
          } catch (e, stackTrace) {
            // Handle the exception or error
            // Fluttertoast.showToast(msg:'Exception: $e');
            // Fluttertoast.showToast(msg:'Stack trace: $stackTrace');
            print('Exception: $e');
            print('Stack trace: $stackTrace');
          }
        } else if (message.data['type'] == 'profile_review') {
          print("kjdis");
          try {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => bussinessprofile()));
          } catch (e, stackTrace) {
            // Handle the exception or error
            // Fluttertoast.showToast(msg:'Exception: $e');
            // Fluttertoast.showToast(msg:'Stack trace: $stackTrace');
            print('Exception: $e');
            print('Stack trace: $stackTrace');
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
          print("gfdghf");
          if (message.data['post_type'] == "SalePost") {
            print("gfdghf1233");
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
              print("gfdghf");
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
          print("hfuihdgiufhrghdriugiorh");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => follower()));
        } else if (message.data['type'] == "followuser") {
          print("hfuihdgiufhrghdriugiorh");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => follower()));
        } else if (message.data['type'] == "profile_review") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => other_user_profile(
                      int.parse(constanst.notiuser.toString()))));
        } else if (message.data['type'] == "live_price") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LivepriceScreen()));
        } else if (message.data['type'] == "quick_news_notification") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen(3)));
        } else if (message.data['type'] == "news") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen(3)));
        } else if (message.data['type'] == "blog") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Blog()));
        } else if (message.data['type'] == "video") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Videos()));
        } else if (message.data['type'] == "banner") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen(0)));
        } else if (message.data['type'] == "tutorial_video") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Tutorial_Videos()));
        } else if (message.data['type'] == "exhibition") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Exhibition()));
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
      print('notification.title');
      print(message);
      final localNotificationImplementation =
          _localNotification.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (localNotificationImplementation != null) {
        localNotificationImplementation
            .createNotificationChannel(_androidchannel);
      }
      print('Android channel');
      print(_androidchannel.id);
      print(_androidchannel.name);
      print(_androidchannel.description);
      _localNotification.show(
        notification.hashCode,
        notification.title ?? '',
        notification.body ?? '',
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidchannel.id ??
                'default_channel_id', // Provide a default value
            _androidchannel.name ??
                'Default Channel', // Provide a default value
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
      RemoteNotification? remoteNotification = message.notification;
      AndroidNotification? notification1 = message.notification?.android;
      if (notification1 != null) {
        /* show_notification(notification.title,
            notification.body,
            message.data);*/
      }
      print('esgrgghhghhjhjhj ${message}');

      /*show_notification(notification.title,
        notification.body,
       message.data);*/
    });

    // initPushNotification(context);
    //initLocalNotification(context);

    //FirebaseMessaging.instance.getInitialMessage().then((handleBackgroundMessage);
  }

  Clear_date() {
    constanst.catdata.clear();
  }
}
