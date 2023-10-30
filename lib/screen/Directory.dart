// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, unnecessary_null_comparison

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_interface.dart';
import '../utill/constant.dart';
import '../constroller/GetCategoryController.dart';
import '../widget/FilterScreen.dart';
import '../widget/HomeAppbar.dart';
import 'package:Plastic4trade/model/getDirectory.dart' as dir;
import 'package:Plastic4trade/model/GetCategory.dart' as cat;

class Directory1 extends StatefulWidget {
  const Directory1({Key? key}) : super(key: key);

  @override
  State<Directory1> createState() => _DirectoryState();
}

class _DirectoryState extends State<Directory1> {
  int selectedIndex = 0, _defaultChoiceIndex = -1;
  int offset = 0;
  int count = 0;
  bool? isLoad;
  List<dir.Result> dir_data = [];
  List<dynamic> resultList = [];
  List<dynamic> resultList1 = [];
  var business_type;
  List<String>? ints;
  String googleApikey = "AIzaSyCyqsD3OPUWGJ5AWbN3iKbUzQGs3Q-ZlPE";
  String? location, search;

  String category_filter_id = '',
      category_id = '""',
      grade_id = '',
      type_id = '',
      bussinesstype = '',
      post_type = '';
  final TextEditingController _loc = TextEditingController();
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checknetowork();
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Widget init() {
    return Scaffold(
      backgroundColor: const Color(0xFFDADADA),
      appBar: CustomeApp('Directory'),
      body: isLoad == true
          ? Column(children: [
              const SizedBox(
                height: 3,
              ),
              Row(
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
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: TextField(
                        controller: _loc,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        readOnly: true,
                        onTap: () async {
                          var place = await PlacesAutocomplete.show(
                              context: context,
                              apiKey: googleApikey,
                              mode: Mode.overlay,
                              types: ['(cities)'],
                              strictbounds: false,
                              onError: (err) {});

                          if (place != null) {
                            setState(() {
                              location = place.description.toString();
                              constanst.location = place.description.toString();
                              _loc.text = location!;
                            });

                            final plist = GoogleMapsPlaces(
                              apiKey: googleApikey,
                              apiHeaders:
                                  await const GoogleApiHeaders().getHeaders(),
                            );
                            String placeid = place.placeId ?? "0";
                            final detail =
                                await plist.getDetailsByPlaceId(placeid);

                            final geometry = detail.result.geometry!;
                            constanst.lat = geometry.location.lat.toString();
                            WidgetsBinding.instance.focusManager.primaryFocus
                                ?.unfocus();
                            constanst.log = geometry.location.lng.toString();
                            dir_data.clear();
                            count = 0;
                            offset = 0;

                            _onLoading();
                            get_direcorylist();
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
                              WidgetsBinding.instance.focusManager.primaryFocus
                                  ?.unfocus();
                              _loc.clear();
                              count = 0;
                              offset = 0;
                              constanst.lat = "";
                              constanst.log = "";
                              dir_data.clear();
                              _onLoading();
                              get_direcorylist();
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
                              fontFamily: 'assets/fonst/Metropolis-Black.otf'),
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
                    margin: const EdgeInsets.only(left: 8.0),
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: TextField(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 14),
                        controller: _search,
                        textInputAction: TextInputAction.search,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIconConstraints: BoxConstraints(minWidth: 24),
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
                              fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                        ),
                        onSubmitted: (value) {
                          dir_data.clear();
                          count = 0;
                          offset = 0;
                          _onLoading();
                          get_direcorylist();
                          setState(() {});
                        },
                        onChanged: (value) {
                          if (value.isEmpty) {
                            WidgetsBinding.instance.focusManager.primaryFocus
                                ?.unfocus();
                            _search.clear();
                            count = 0;
                            offset = 0;
                            dir_data.clear();
                            _onLoading();
                            get_direcorylist();
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
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: const Icon(
                        Icons.filter_alt,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              horiztallist(),
              directory()
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
                      : Container(),
            ),
    );
  }

  ViewItem(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
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

        dir_data.clear();
        _onLoading();

        get_direcorylist();
        constanst.select_categotyId.clear();
        constanst.select_typeId.clear();
        constanst.select_gradeId.clear();
        constanst.selectbusstype_id.clear();
        constanst.select_categotyType.clear();

        setState(() {});
      },
    );
  }

  void _onLoading() {
    BuildContext dialogContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
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
      Navigator.of(dialogContext).pop();
    });
  }

  Widget directory() {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0),
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: dir_data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  dir.Result record = dir_data[index];

                  return GestureDetector(
                    onTap: (() {}),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          SizedBox(
                            height: 75,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            10.0, 10.0, 0, 0),
                                        child: Text(
                                          record.userImage.toString(),
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf'),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            10.0, 2.0, 0, 0),
                                        child: Text(
                                          resultList[index].toString(),
                                          style: const TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-Black.otf')
                                              .copyWith(color: Colors.black45),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            10.0, 2.0, 0, 0),
                                        child: Text(
                                          record.address.toString(),
                                          style: const TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf'),
                                        ),
                                      ),
                                    ]),
                                Container(
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff7c94b6),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        record.userImageUrl.toString(),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin:
                                  const EdgeInsets.fromLTRB(10.0, 2.0, 0.0, 0),
                              child: Text(
                                resultList1[index].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf',
                                    fontSize: 13,
                                    color: Colors.black),
                                maxLines: 2,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          )
                        ]),
                      ),
                    ),
                  );
                },
              );
            }
          })),
    );
  }

  Widget horiztallist() {
    return Container(
      height: 50,
      color: Colors.white,
      child: FutureBuilder(builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.hasData == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView.builder(
              shrinkWrap: false,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: constanst.catdata.length,
              itemBuilder: (context, index) {
                cat.Result result = constanst.catdata[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Wrap(spacing: 6.0, runSpacing: 6.0, children: <Widget>[
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
                            dir_data.clear();
                            _onLoading();
                            get_direcorylist()();
                          } else {
                            category_filter_id = result.categoryId.toString();
                            dir_data.clear();
                            _onLoading();
                            get_direcorylist();
                          }
                        });
                      },
                      backgroundColor: const Color.fromARGB(255, 236, 232, 232),
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
                    )
                  ]),
                );
              });
        }
      }),
    );
  }

  void get_categorylist() async {
    GetCategoryController bt = GetCategoryController();
    constanst.cat_data = bt.setlogin();

    constanst.cat_data!.then((value) {
      for (var item in value) {
        constanst.catdata.add(item);
      }
      isLoad = true;
      setState(() {});
    });
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      get_categorylist();
      get_direcorylist();
    }
  }

  get_direcorylist() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await get_directory(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
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

    print("RESPONSE === $res");

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];

        for (var data in jsonArray) {
          dir.Result record = dir.Result(
              userImage: data['username'],
              address: data['address'],
              userImageUrl: data['user_image_url']);

          List<dynamic>? strs = (data["business_type"] as List)
              .map(
                (e) => e.toString(),
              )
              .toList();

          String str = strs.join(",");
          resultList.add(str);

          List<dynamic>? strs1 = (data["product_name"] as List)
              .map(
                (e) => e.toString(),
              )
              .toList();
          String str1 = strs1.join(",");
          resultList1.add(str1);

          dir_data.add(record);
        }

        isLoad = true;
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      isLoad = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonArray;
  }
}
