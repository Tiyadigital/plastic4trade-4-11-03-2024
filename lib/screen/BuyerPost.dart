// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:io';

import 'package:Plastic4trade/model/GetCategory.dart' as cat;
import 'package:Plastic4trade/model/getBuyPost.dart' as buyerpost;
import 'package:Plastic4trade/model/getHomePostSearch.dart' as homesearch;
import 'package:Plastic4trade/widget/HomeAppbar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';
import '../constroller/GetCategoryController.dart';
import '../constroller/Getmybusinessprofile.dart';
import '../utill/constant.dart';
import '../widget/FilterScreen.dart';
import '../widget/MainScreen.dart';
import 'AddPost.dart';
import 'Buyer_sell_detail.dart';
import 'GradeScreen.dart';
import 'Register2.dart';

class BuyerPost extends StatefulWidget {
  const BuyerPost({Key? key}) : super(key: key);

  @override
  State<BuyerPost> createState() => _BuyerPostState();
}

class _BuyerPostState extends State<BuyerPost> {
  int selectedIndex = 0, _defaultChoiceIndex = -1;
  bool isload = false;
  int offset = 0;
  int count = 0;
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

  final TextEditingController _loc = TextEditingController();
  final TextEditingController _search = TextEditingController();

  List<buyerpost.Result> buyerpost_data = [];

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
        backgroundColor: const Color(0xFFDADADA),
        body: isload == true
            ? RefreshIndicator(
              displacement: 50,
              color: const Color(0xFF005C94),
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: ()async{},
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                                  bottomLeft: Radius.circular(40.0),
                                ),
                                color: Colors.white),
                            height: 40,
                            margin: const EdgeInsets.only(left: 8.0),
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: TextField(
                                controller: _loc,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                                readOnly: true,
                                onTap: () async {
                                  var place = await PlacesAutocomplete.show(
                                      context: context,
                                      apiKey: googleApikey,
                                      mode: Mode.overlay,
                                      types: ['(cities)'],
                                      onError: (err) {});

                                  if (place != null) {
                                    setState(() {
                                      location = place.description.toString();
                                      constanst.location =
                                          place.description.toString();
                                      _loc.text = location!;
                                    });

                                    final plist = GoogleMapsPlaces(
                                      apiKey: googleApikey,
                                      apiHeaders: await const GoogleApiHeaders()
                                          .getHeaders(),
                                    );
                                    String placeid = place.placeId ?? "0";
                                    final detail =
                                        await plist.getDetailsByPlaceId(placeid);

                                    final geometry = detail.result.geometry!;
                                    constanst.lat =
                                        geometry.location.lat.toString();

                                    constanst.log =
                                        geometry.location.lng.toString();
                                    buyerpost_data.clear();
                                    count = 0;
                                    offset = 0;
                                    WidgetsBinding
                                        .instance.focusManager.primaryFocus
                                        ?.unfocus();
                                    _onLoading();
                                    get_buyerPost();
                                    setState(() {});
                                  }
                                },
                                textInputAction: TextInputAction.search,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIconConstraints:
                                      const BoxConstraints(minWidth: 24),
                                  suffixIconConstraints:
                                      const BoxConstraints(minWidth: 24),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(right: 2, left: 2),
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
                                      buyerpost_data.clear();
                                      _onLoading();
                                      get_buyerPost();
                                      setState(() {});
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(right: 2, left: 2),
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
                                          'assets/fonst/Metropolis-Black.otf'),
                                ),
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(40.0),
                                  bottomRight: Radius.circular(40.0),
                                  topLeft: Radius.circular(40.0),
                                  bottomLeft: Radius.circular(40.0),
                                ),
                                color: Colors.white),
                            height: 40,
                            margin: const EdgeInsets.only(left: 6.0),
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: TextField(
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                                controller: _search,
                                textInputAction: TextInputAction.search,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  prefixIconConstraints:
                                      BoxConstraints(minWidth: 24),
                                  prefixIcon: Padding(
                                    padding:
                                        EdgeInsets.only(right: 5.0, left: 5.0),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.black45,
                                      size: 20,
                                    ),
                                  ),
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontFamily:
                                          'assets/fonst/Metropolis-Black.otf'),
                                ),
                                onSubmitted: (value) {
                                  WidgetsBinding
                                      .instance.focusManager.primaryFocus
                                      ?.unfocus();
                                  buyerpost_data.clear();
                                  count = 0;
                                  offset = 0;
                                  _onLoading();
                                  get_buyerPost();
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
                                    buyerpost_data.clear();
                                    _onLoading();
                                    get_buyerPost();
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ViewItem(context);
                            },
                            child: Container(
                              height: 45,
                              margin: const EdgeInsets.only(
                                  bottom: 3.0, left: 1.2, top: 3.0),
                              width: MediaQuery.of(context).size.width / 11.2,
                              // padding: EdgeInsets.only(right: 5),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: const Icon(
                                Icons.filter_alt,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    category()
                  ],
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
        floatingActionButton: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/floating_back.png"),
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: IconButton(
            onPressed: () async{
              constanst.redirectpage = "add_post";
              SharedPreferences pref = await SharedPreferences.getInstance();
             if(pref.getBool('isWithoutLogin') == true){
               showLoginDialog(context);
             }else{
               if (constanst.appopencount == constanst.appopencount1) {
                 if (!constanst.isgrade &&
                     !constanst.istype &&
                     !constanst.iscategory &&
                     !constanst.isprofile) {
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => const AddPost(),
                     ),
                   );
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
               }
               else {
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
                     ),
                   );
                 } else if (!constanst.isgrade &&
                     !constanst.istype &&
                     !constanst.iscategory &&
                     !constanst.isprofile) {
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => const AddPost(),
                     ),
                   );
                 }
               }
             }
            },
            icon: const Icon(Icons.add, color: Colors.white, size: 40),
          ),
        ),
      ),
    );
  }

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget horiztallist() {
    return Container(
      height: 50,
      color: Colors.white,
      child: FutureBuilder(
        future: constanst.cat_data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          else {
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
                  child: Wrap(
                    spacing: 6.0,
                    runSpacing: 6.0,
                    children: [
                      ChoiceChip(
                        label: Text(
                          constanst.catdata[index].categoryName.toString(),
                        ),
                        selected: _defaultChoiceIndex == index,
                        selectedColor: const Color.fromARGB(255, 0, 91, 148),
                        onSelected: (bool selected) {
                          setState(() {
                            _defaultChoiceIndex = selected ? index : -1;
                            if (_defaultChoiceIndex == -1) {
                              category_filter_id = "";
                              buyerpost_data.clear();
                              _onLoading();
                              get_buyerPost();
                            } else {
                              category_filter_id = result.categoryId.toString();
                              buyerpost_data.clear();
                              _onLoading();
                              get_buyerPost();
                            }
                          });
                        },
                        // padding: EdgeInsets.all(5),
                        backgroundColor:
                            const Color.fromARGB(255, 236, 232, 232),
                        labelStyle: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily: 'assets/fonst/Metropolis-Black.otf')
                            .copyWith(
                                color: _defaultChoiceIndex == index
                                    ? Colors.white
                                    : Colors.black),
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 14.0),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
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
        ),
      ),
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
          }),
    ).then(
      (value) {
        _loc.text = constanst.location.toString();
        category_filter_id = constanst.select_categotyId.join(",");
        type_id = constanst.select_typeId.join(",");
        grade_id = constanst.select_gradeId.join(",");
        bussinesstype = constanst.selectbusstype_id.join(",");

        post_type = constanst.select_categotyType.join(",");

        buyerpost_data.clear();
        _onLoading();

        get_buyerPost();
        constanst.select_categotyId.clear();
        constanst.select_typeId.clear();
        constanst.select_gradeId.clear();
        constanst.selectbusstype_id.clear();
        constanst.select_categotyType.clear();

        setState(() {});
      },
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

  Widget category() {
    return buyerpost_data.isNotEmpty
        ? Expanded(
            child:GridView.builder(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: MediaQuery.of(context).size.width /
                    620, //MediaQuery.of(context).size.aspectRatio * 1.3,
                mainAxisSpacing: 3.0,
                crossAxisCount: 2,
              ),
                physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollercontroller,
                itemCount: buyerpost_data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  buyerpost.Result result = buyerpost_data[index];
                  return GestureDetector(
                    onTap: (() async{
                      constanst.productId = result.productId.toString();
                      constanst.post_type = result.postType.toString();
                      constanst.redirectpage = "sale_buy";
                      SharedPreferences pref = await SharedPreferences.getInstance();
                      if(pref.getBool('isWithoutLogin') == true){
                        showLoginDialog(context);
                      }else{
                        if (constanst.appopencount ==
                            constanst.appopencount1) {
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
                                  post_type: result.postType.toString(),
                                ),
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
                          } else if (constanst.step != 11) {
                            addPostDialog(context);
                          }
                        } else if (constanst.isprofile) {
                          showInformationDialog(context);
                        } else if(!constanst.isgrade &&
                            !constanst.istype &&
                            !constanst.iscategory &&
                            !constanst.isprofile &&
                            constanst.step == 11){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Buyer_sell_detail(
                                prod_id: result.productId.toString(),
                                post_type: result.postType.toString(),
                              ),
                            ),
                          );
                        }else {
                          categoryDialog(context);
                        }
                      }
                    }),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.05),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(13.05)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x3FA6A6A6),
                              blurRadius: 16.32,
                              offset: Offset(0, 3.26),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Column(children: [
                          Stack(children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 165,
                                width: 175,
                                margin: const EdgeInsets.all(5.0),
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
                                  ),
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
                                      '${result.categoryName} | ${result.productGrade}',
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
                                      '${result.state}, ${result.country}',
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
                                  child: result.postType.toString() ==
                                      "BuyPost"
                                      ? const Text(
                                    'Buy Post',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: 'Metropolis',
                                      fontWeight: FontWeight.w600,
                                      color:
                                      Color.fromRGBO(0, 148, 95, 1),
                                    ),
                                  )
                                      : result.postType.toString() ==
                                      "SalePost"
                                      ? const Text(
                                    "Sale Post",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontFamily: 'Metropolis',
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(
                                          0, 148, 95, 1),
                                    ),
                                  )
                                      : Container(),
                                ),
                              ),
                            ],
                          )
                        ]),
                      ),
                    ),
                  );
                },
              ),
          )
        : Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: MediaQuery.of(context).size.height /
                    1250, //MediaQuery.of(context).size.aspectRatio * 1.3,
                mainAxisSpacing: 3.0,
                crossAxisCount: 2,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollercontroller,
              itemCount: homepostsearch_data.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                homesearch.Result result = homepostsearch_data[index];
                return GestureDetector(
                  onTap: (() async{
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    constanst.redirectpage == "sale_buy";
                    if(pref.getBool('isWithoutLogin') == true){
                      showLoginDialog(context);
                    }else{
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
                                post_type: result.postType.toString(),
                              ),
                            ),
                          );
                        } else if (!constanst.iscategory) {
                          showInformationDialog(context);
                        } else if (!constanst.isgrade) {
                          showInformationDialog(context);
                        } else if (!constanst.istype) {
                          showInformationDialog(context);
                        } else if (constanst.step != 11) {
                          showInformationDialog(context);
                        } else {
                          showInformationDialog(context);
                        }
                      }
                      else {
                        if (!constanst.isprofile) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Buyer_sell_detail(
                                prod_id: result.productId.toString(),
                                post_type: result.postType.toString(),
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register2(),
                            ),
                          );
                        }
                      }
                    }
                  }),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(children: [
                      Stack(fit: StackFit.passthrough, children: <Widget>[
                        Container(
                          height: 165,
                          width: 175,
                          margin: const EdgeInsets.all(5.0),
                          decoration: const BoxDecoration(
                            //color: Colors.black26,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
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
                                  top: 10.0, left: 10.0),
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
                                  top: 10.0, left: 10.0),
                              child: Text(result.productGrade.toString(),
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
                                  top: 10.0, left: 10.0),
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
                        ],
                      )
                    ]),
                  ),
                );
              },
            ),
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

  void _scrollercontroller() {
    if (scrollercontroller.position.pixels ==
        scrollercontroller.position.maxScrollExtent) {
      loadmore = false;

      if (buyerpost_data.isNotEmpty) {
        count++;
        if (count == 1) {
          offset = offset + 21;
        } else {
          offset = offset + 20;
        }
        _onLoading();
        get_buyerPost();
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

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
          timeInSecForIosWeb: 2, msg: 'Internet Connection not available');
    } else {

      if(pref.getBool('isWithoutLogin') == true){
        getBuyPostWithoutLogin();
        get_categorylist();
      }else{
        get_categorylist();
        getBussinessProfile();
        get_buyerPost();
      }
    }
  }

  get_HomePostSearch() async {
    var res = await getbuysearch_Post(
      lat.toString(),
      log.toString(),
      _search.text.toString(),
      '20',
      offset.toString(),
    );
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
      Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: res['message']);
    }
    return jsonArray;
  }

  Clear_date() {
    constanst.catdata.clear();
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
    //
  }

  getBussinessProfile() async {
    GetmybusinessprofileController bt = GetmybusinessprofileController();
    SharedPreferences pref = await SharedPreferences.getInstance();
    constanst.getmyprofile = bt.Getmybusiness_profile(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );
  }

  get_buyerPost() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getBuyer_Post(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
      '20',
      offset.toString(),
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
    print("resdata:-$res");
    if (res['status'] == 1) {
      jsonArray = res['result'];

      for (var data in jsonArray) {
        buyerpost.Result record = buyerpost.Result(
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
        buyerpost_data.add(record);
        loadmore = true;
        isload = true;
      }
      setState(() {});
    } else {
      Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: res['message']);
    }
    return jsonArray;
  }

  getBuyPostWithoutLogin() async{

    var res = await buyPostWithoutLogin();

    var jsonArray;
    if (res['status'] == 1) {
      jsonArray = res['result'];

      for (var data in jsonArray) {
        buyerpost.Result record = buyerpost.Result(
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
        buyerpost_data.add(record);
        loadmore = true;
        isload = true;
      }
      setState(() {});
    } else {
      Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: res['message']);
    }
    return jsonArray;
  }
}
