import 'dart:io';
import 'package:Plastic4trade/screen/Type.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Plastic4trade/model/getHomePostSearch.dart' as homesearch;
import '../api/api_interface.dart';
import '../constroller/GetCategoryController.dart';
import '../constroller/Getmybusinessprofile.dart';
import '../model/getHomePostSearch.dart';
import '../model/getSalePost.dart';
import '../utill/constant.dart';
import 'package:Plastic4trade/model/getSalePost.dart' as salepost;
import 'package:Plastic4trade/model/GetCategory.dart' as cat;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Plastic4trade/widget/HomeAppbar.dart';
import 'package:Plastic4trade/widget/bottombar.dart';

import '../widget/FilterScreen.dart';
import '../widget/MainScreen.dart';
import 'AddPost.dart';
import 'Buyer_sell_detail.dart';
import 'CategoryScreen.dart';
import 'GradeScreen.dart';
import 'Register2.dart';

class SalePost extends StatefulWidget {
  const SalePost({Key? key}) : super(key: key);

  @override
  State<SalePost> createState() => _SalePostState();
}

class _SalePostState extends State<SalePost> {
  int selectedIndex = 0, _defaultChoiceIndex = -1;
  List<salepost.Result> salepost_data = [];
  bool loadmore = false;
  final scrollercontroller = ScrollController();
  late String lat = "";
  String? location, search;
  late String log = "",
      category_filter_id = '',
      category_id = '""',
      grade_id = '',
      type_id = '',
      bussinesstype = '',
      post_type = '';
  List<homesearch.Result> homepostsearch_data = [];
  String googleApikey = "AIzaSyCyqsD3OPUWGJ5AWbN3iKbUzQGs3Q-ZlPE";
  TextEditingController _loc = TextEditingController();
  TextEditingController _search = TextEditingController();
  int offset = 0;
  int count = 0;
  bool isload = false;
  FocusNode nodeOne = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
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
                                  textAlign: TextAlign.start,
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
                                      print(constanst.lat);
                                    /*  WidgetsBinding
                                          .instance?.focusManager.primaryFocus
                                          ?.unfocus();*/
                                      salepost_data.clear();
                                      count = 0;
                                      offset = 0;
                                      //get_HomePostSearch();
                                      _onLoading();
                                      get_salePost();
                                      setState(() {});
                                      // var newlatlang = LatLng(lat, log);

                                      //move map camera to selected place with animation
                                      //mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                                    }
                                  },
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 0.80),
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
                                          size: 20,
                                        ),
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          _loc.clear();
                                          count = 0;
                                          offset = 0;
                                          constanst.lat = "";
                                          constanst.log = "";
                                          salepost_data.clear();
                                          _onLoading();
                                          get_salePost();
                                          setState(() {});
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 2, left: 2),
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.black45,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      hintText: 'Location',
                                      hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets\fonst\Metropolis-Black.otf')),
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
                                padding: EdgeInsets.only(left: 5.0, right: 5.0 ),
                                child: TextField(
                                  style: const TextStyle(color: Colors.black, fontSize: 14),
                                  controller: _search,
                                  textAlign: TextAlign.start,
                                  textInputAction: TextInputAction.search,

                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIconConstraints:

                                      BoxConstraints(minWidth: 24),
                                      contentPadding: EdgeInsets.symmetric(vertical: 1.0),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.only(right: 5.0,left: 5.0),
                                        child: Icon(
                                          Icons.search,
                                          color: Colors.black45,
                                          size: 25,
                                        ),
                                      ),
                                      hintText: 'Search',
                                      hintStyle:
                                      TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                                  onSubmitted: (value) {
                                   // WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                    //homepost_data.clear();
                                    count = 0;
                                    offset = 0;
                                    _onLoading();
                                  //  get_HomePost();
                                    setState(() {});
                                  },
                                  onTap: () {
                                    print('fdrrf');
                                  },
                                  onChanged: (value) {
                                    if(value.isEmpty){
                                      //WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                      _search.clear();
                                      count = 0;
                                      offset = 0;
                                      //homepost_data.clear();
                                      _onLoading();
                                     // get_HomePost();
                                      setState(() {});
                                    }
                                  },

                                ))),
                        GestureDetector(
                            onTap: () {
                              ViewItem(context);
                            },
                            child: Container(
                                height: 45,
                                margin: EdgeInsets.only(
                                    bottom: 3.0, left: 1.2, top: 3.0),
                                width: MediaQuery.of(context).size.width / 11.2,
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
                  category()
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
                if (constanst.appopencount == constanst.appopencount1) {
                  if (!constanst.isgrade &&
                      !constanst.istype &&
                      !constanst.iscategory &&
                      !constanst.isprofile &&
                      constanst.step == 11) {
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
                  } else if (constanst.step != 11) {
                    addPostDialog(context);
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
                  } else if (constanst.step != 11) {
                    addPostDialog(context);
                  } else if (!constanst.isgrade &&
                      !constanst.istype &&
                      !constanst.iscategory &&
                      !constanst.isprofile &&
                      constanst.step == 11) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddPost(),
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

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  ViewItem(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape:  RoundedRectangleBorder(
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

        salepost_data.clear();
        _onLoading();

        get_salePost();
        constanst.select_categotyId.clear();
        constanst.select_typeId.clear();
        constanst.select_gradeId.clear();
        constanst.selectbusstype_id.clear();
        constanst.select_categotyType.clear();

        setState(() {});
      },
    );
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
                                salepost_data.clear();
                                _onLoading();
                                get_salePost();
                              } else {
                                category_filter_id =
                                    result.categoryId.toString();
                                salepost_data.clear();
                                _onLoading();
                                get_salePost();
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

  Widget category() {
    return salepost_data.isNotEmpty
        ? Expanded(
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

                    childAspectRatio: MediaQuery.of(context).size.width /
                        620, //MediaQuery.of(context).size.aspectRatio * 1.3,
                    mainAxisSpacing: 3.0,
                    crossAxisCount: 2,
                  ),
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollercontroller,
                  itemCount: salepost_data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    salepost.Result result = salepost_data[index];
                    return GestureDetector(
                      onTap: (() {
                        constanst.productId = result.productId.toString();
                        constanst.post_type = result.postType.toString();
                        constanst.redirectpage = "sale_buy";


                        if (constanst.appopencount == constanst.appopencount1) {
                          print("APP OPEN 1st = ${constanst.appopencount}");
                          print("APP OPEN 1st = ${constanst.appopencount1}");

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
                        }
                        else if (constanst.isprofile) {
                          print("APP OPEN 2nd = ${constanst.appopencount}");
                          print("APP OPEN 2nd = ${constanst.appopencount1}");
                          showInformationDialog(context);
                        }else if(constanst.appopencount == constanst.appopencount1){
                          print("APP OPEN 3rd= ${constanst.appopencount}");
                          print("APP OPEN 3rd= ${constanst.appopencount1}");
                          categoryDialog(context);
                        }
                        else {
                          print("APP OPEN 4th= ${constanst.appopencount}");
                          print("APP OPEN 4th= ${constanst.appopencount1}");
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 5.0),
                                decoration: const BoxDecoration(
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
                                    padding:
                                        EdgeInsets.only(top: 10.0, left: 10.0),
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
              }

              return CircularProgressIndicator();
            }),
          )
        : Expanded(
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
                        1300, //MediaQuery.of(context).size.aspectRatio * 1.3,
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
                        constanst.productId = result.productId.toString();
                        constanst.post_type = result.postType.toString();
                        constanst.redirectpage = "sale_buy";
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
                          /* else {
                   showInformationDialog(context);
                 }*/
                        } else {
                          if (constanst.isprofile) {
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
                                        /* result.productType.toString() +
                                          ' | ' +*/
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
                              /* Align(
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
                                )),*/
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
          );
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      get_categorylist();
      getBussinessProfile();
      // constanst.appopencount1=2;
      get_salePost();
      // get_data();
    }
  }

  Clear_date() {
    constanst.catdata.clear();
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

  get_salePost() async {
    getSalePost getsalepost = getSalePost();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getSale_Post(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        '20',
        offset.toString(),
        category_filter_id,
        grade_id,
        type_id,
        bussinesstype,
        post_type,
        constanst.lat,
        constanst.log,
        _search.text.toString());
    var jsonarray;
    print(res);

    if (res['status'] == 1) {
      getsalepost = getSalePost.fromJson(res);
      jsonarray = res['result'];
      print(jsonarray);

      for (var data in jsonarray) {
        salepost.Result record = salepost.Result(
            postName: data['PostName'],
            categoryName: data['CategoryName'],
            productGrade: data['ProductGrade'],
            currency: data['Currency'],
            productPrice: data['ProductPrice'],
            state: data['State'],
            country: data['Country'],
            postType: data['PostType'],
            productId: data['productId'],
            isPaidPost: data['is_paid_post'],
            productType: data['ProductType'],
            mainproductImage: data['mainproductImage']);
        salepost_data.add(record);
        loadmore = true;
      }
      isload = true;
      print(salepost_data);
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res['message']);

    }
    return jsonarray;
    setState(() {});
  }

  void _scrollercontroller() {
    if (scrollercontroller.position.pixels ==
        scrollercontroller.position.maxScrollExtent) {
      loadmore = false;

      if (salepost_data.isNotEmpty) {
        count++;
        if (count == 1) {
          offset = offset + 21;
        } else {
          offset = offset + 20;
        }
        _onLoading();
        get_salePost();
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

    Future.delayed( Duration(seconds: 5), () {
      print('exit');
      Navigator.of(dialogContext)
          .pop(); // Use dialogContext to close the dialog
      print('exit1'); // Dialog closed
    });
  }

  get_HomePostSearch() async {
    getHomePostSearch gethomepostsearch = getHomePostSearch();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getsaleSearch_Post(lat.toString(), log.toString(),
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
}
