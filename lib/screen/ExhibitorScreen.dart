// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, prefer_typing_uninitialized_variables, unnecessary_null_comparison

import 'dart:io';

import 'package:Plastic4trade/model/GetCategory.dart' as cat;
import 'package:Plastic4trade/model/getExhibitor.dart' as exhibitor;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

import '../api/api_interface.dart';
import '../constroller/GetCategoryController.dart';
import '../utill/constant.dart';
import '../widget/FilterScreen.dart';
import '../widget/HomeAppbar.dart';

class Exhibitor extends StatefulWidget {
  const Exhibitor({Key? key}) : super(key: key);

  @override
  State<Exhibitor> createState() => _DirectoryState();
}

class _DirectoryState extends State<Exhibitor> {
  String category_id = '',
      grade_id = '',
      type_id = '',
      bussinesstype = '',
      post_type = '',
      lat = '',
      log = '';
  final PageController controller = PageController(initialPage: 0);
  List<dynamic>? exhibitorList;
  bool? isload;
  int selectedIndex = 0, _defaultChoiceIndex = -1;
  int offset = 0;
  List<exhibitor.Result> exhibitor_data = [];
  List<dynamic> resultList = [];
  List<dynamic> resultList1 = [];
  List<dynamic> resultList2 = [];
  var business_type;
  List<String>? ints;
  String? location, search;
  String googleApikey = "AIzaSyCyqsD3OPUWGJ5AWbN3iKbUzQGs3Q-ZlPE";

  final TextEditingController _loc = TextEditingController();
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    checknetowork();
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      get_categorylist();
      get_Exhibitorlist();

      // get_data();
    }
  }

  get_Exhibitorlist() async {
    var res = await get_exhibitor(
        offset.toString(),
        category_id,
        grade_id,
        type_id,
        bussinesstype,
        post_type,
        constanst.lat,
        constanst.log,
        _search.text.toString());

    print("RESPONSE == $res");

    var jsonArray;

    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];
        exhibitorList = res['result'];

        for (var data in jsonArray) {
          exhibitor.Result record = exhibitor.Result(
              username: data['username'],
              address: data['address'],
              businessName: data['business_name'],
              userImageUrl: data['user_image_url']);

          // business_type = data['business_type'];

          List<dynamic>? strs =
              (data["business_type"] as List).map((e) => e.toString()).toList();

          String str = strs.join(",");
          resultList.add(str);

          List<dynamic>? strs1 =
              (data["product_name"] as List).map((e) => e.toString()).toList();
          String str1 = strs1.join(",");
          resultList1.add(str1);

          List<dynamic>? strs2 =
              (data["images"] as List).map((e) => e.toString()).toList();

          String str3 = strs2.join(",");

          resultList2.add(str3);

          exhibitor_data.add(record);
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

  void get_categorylist() async {
    GetCategoryController bt = GetCategoryController();
    constanst.cat_data = bt.setlogin();

    constanst.cat_data!.then((value) {
      for (var item in value) {
        constanst.catdata.add(item);
      }
      isload = true;
      setState(() {});
    });
    //
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Widget init() {
    return Scaffold(
      backgroundColor: const Color(0xFFDADADA),
      appBar: CustomeApp('Exhibitor'),
      body: isload == true
          ? Column(children: [
              // give the tab bar a height [can change hheight to preferred height]
              Row(
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
                                  // components: [Component(Component.country, 'np')],
                                  //google_map_webservice package
                                  onError: (err) {});

                              if (place != null) {
                                setState(() {
                                  location = place.description.toString();
                                  _loc.text = location!;

                                  _onLoading();
                                  exhibitor_data.clear();
                                  get_Exhibitorlist();
                                });

                                //form google_maps_webservice package
                                final plist = GoogleMapsPlaces(
                                  apiKey: googleApikey,
                                  apiHeaders: await const GoogleApiHeaders()
                                      .getHeaders(),
                                  //from google_api_headers package
                                );
                                String placeid = place.placeId ?? "0";
                                final detail =
                                    await plist.getDetailsByPlaceId(placeid);

                                final geometry = detail.result.geometry!;
                                constanst.lat =
                                    geometry.location.lat.toString();

                                constanst.log =
                                    geometry.location.lng.toString();
                                WidgetsBinding
                                    .instance.focusManager.primaryFocus
                                    ?.unfocus();
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
                                    WidgetsBinding
                                        .instance.focusManager.primaryFocus
                                        ?.unfocus();
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
                                        'assets/fonst/Metropolis-Black.otf')),
                            onChanged: (value) {},
                          ),),),
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
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
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
                                  padding: EdgeInsets.only(right: 10),
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
                                        'assets/fonst/Metropolis-Black.otf')),
                            onSubmitted: (value) {
                              WidgetsBinding.instance.focusManager.primaryFocus
                                  ?.unfocus();
                              setState(() {});
                            },
                            onChanged: (value) {
                              WidgetsBinding.instance.focusManager.primaryFocus
                                  ?.unfocus();
                            },
                          ))),
                  GestureDetector(
                      onTap: () {},
                      child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width / 11.5,
                          // padding: EdgeInsets.only(right: 5),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 0, 91, 148)),
                          child: GestureDetector(
                              onTap: () {
                                ViewItem(context);
                              },
                              child: const Icon(
                                Icons.filter_alt,
                                color: Colors.white,
                              ))))
                ],
              ),
              horiztallist(),
              directory()
              // tab bar view here
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
    );
  }

  Widget directory() {
    return Expanded(
        child: Container(
            //height: 200,

            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0),
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
                //future: load_category(),
                builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                //List<dynamic> users = snapshot.data as List<dynamic>;
                return ListView.builder(

                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: exhibitor_data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    exhibitor.Result record = exhibitor_data[index];

                    //print(exhibitorList![index]['images']);
                    List<dynamic> firstExhibitorImages =
                        exhibitorList![index]['images'];

                    return GestureDetector(
                        onTap: (() {}),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(children: [
                            Container(
                                margin: const EdgeInsets.fromLTRB(
                                    15.0, 5.0, 15.0, 0.0),
                                //padding: EdgeInsets.all(10.0),
                                //transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                                child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: 70.0,
                                            height: 70.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xff7c94b6),
                                              image: DecorationImage(
                                                image: NetworkImage(record
                                                    .userImageUrl
                                                    .toString()),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(50.0)),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          Container(
                                              //height: 30,
                                              //margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              transform:
                                                  Matrix4.translationValues(
                                                      0.0, -10.0, 0.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                    const Color(0xffFFC107),
                                              ),
                                              child: const Text(
                                                'Premium',
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: Colors.black),
                                              )),
                                        ],
                                      ),
                                      Flexible(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10.0, 0.0, 0.0, 5.0),
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        record.username
                                                            .toString(),
                                                        softWrap: false,
                                                        style: const TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                            color:
                                                                Colors.black,
                                                            fontFamily:
                                                                'assets/fonst/Metropolis-SemiBold.otf'),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        resultList[index]
                                                            .toString(),
                                                        softWrap: false,
                                                        style: const TextStyle(
                                                                fontSize:
                                                                    14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'assets/fonst/Metropolis-Black.otf')
                                                            .copyWith(
                                                                fontSize: 11),
                                                        textAlign:
                                                            TextAlign.left,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                  SizedBox(
                                                    //width: MediaQuery.of(context).size.width/0.9,
                                                    // height: 25,
                                                    child: Row(
                                                      children: [
                                                        const ImageIcon(
                                                            AssetImage(
                                                                'assets/location.png'),
                                                            size: 10),
                                                        Expanded(
                                                            child: Text(
                                                                record.address
                                                                    .toString(),
                                                                softWrap:
                                                                    false,
                                                                style: const TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight: FontWeight
                                                                            .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'assets/fonst/Metropolis-Black.otf')
                                                                    .copyWith(
                                                                        fontSize:
                                                                            11),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis))
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ))),
                                      Image.asset(
                                        "assets/call2.png",
                                        width: 30,
                                        height: 30,
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Image.asset(
                                        "assets/msg1.png",
                                        width: 30,
                                        height: 30,
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Image.asset(
                                        "assets/web.png",
                                        width: 30,
                                        height: 30,
                                      ),
                                    ])),
                            const Divider(
                              color: Colors.black38,
                            ),
                            Container(
                              //height: 50,
                              margin: const EdgeInsets.fromLTRB(
                                  10.0, 2.0, 0.0, 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(record.businessName.toString(),
                                    softWrap: false,
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets/fonst/Metropolis-SemiBold.otf'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                                margin: const EdgeInsets.only(left: 15),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/verify1.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    const Text('Verified'),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Image.asset(
                                      'assets/trust.png',
                                      width: 20,
                                      height: 15,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    const Text('Trusted')
                                  ],
                                )),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                  //height: 50,
                                  margin: const EdgeInsets.fromLTRB(
                                      10.0, 10.0, 10.0, 0),
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Text(
                                    resultList1[index].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf',
                                        fontSize: 13,
                                        color: Colors.black),
                                    maxLines: 2,
                                  )),
                            ),
                            //SizedBox(height: 5.0,)
                            firstExhibitorImages.isNotEmpty
                                ? slider(firstExhibitorImages)
                                : Image.asset(
                                    'assets/plastic4trade logo final.png')
                          ]),
                        ));
                  },
                );
              }

            })));
  }

  Widget horiztallist() {
    return Container(
        height: 50,
        margin: const EdgeInsets.fromLTRB(10.0, 2.0, 0, 0),
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
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: constanst.catdata.length,
                itemBuilder: (context, index) {
                  cat.Result result = constanst.catdata[index];
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: ChoiceChip(
                        label: Text(
                            constanst.catdata[index].categoryName.toString()),
                        selected: _defaultChoiceIndex == index,
                        selectedColor: const Color.fromARGB(255, 0, 91, 148),
                        onSelected: (bool selected) {
                          setState(() {
                            _defaultChoiceIndex = selected ? index : 0;
                            category_id = result.categoryId.toString();
                            exhibitor_data.clear();
                            _onLoading();
                            get_Exhibitorlist();
                          });
                        },
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        backgroundColor: Colors.white,
                        labelStyle: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                      ));
                });
          }
        }));
  }

  Widget slider(List firstExhibitorImages) {
    return GFCarousel(
      height: 330,
      autoPlay: true,
      pagerSize: 2.0,
      viewportFraction: 1.0,
      aspectRatio: 2,
      // hasPagination: true,
      //
      // activeIndicator: Colors.lightBlue,

      items: firstExhibitorImages.map(
        (url) {
          return Container(
            // decoration:BoxDecoration(
            //   borderRadius: BorderRadius.circular(25.0)),
            margin: const EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              child: Image.network(url, fit: BoxFit.cover, width: 2500.0),
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
      Navigator.of(dialogContext)
          .pop(); // Use dialogContext to close the dialog
      // Dialog closed
    });
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
        category_id = constanst.select_categotyId.join(",");
        type_id = constanst.select_typeId.join(",");
        grade_id = constanst.select_gradeId.join(",");
        bussinesstype = constanst.selectbusstype_id.join(",");

        post_type = constanst.select_categotyType.join(",");

        exhibitor_data.clear();
        _onLoading();

        get_Exhibitorlist();
        constanst.select_categotyId.clear();
        constanst.select_typeId.clear();
        constanst.select_gradeId.clear();
        constanst.selectbusstype_id.clear();
        constanst.select_categotyType.clear();

        setState(() {});
      },
    );
  }

}
