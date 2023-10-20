// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison

import 'dart:developer';
import 'dart:io';

import 'package:Plastic4trade/constroller/GetCategoryController.dart';
import 'package:Plastic4trade/model/GetCategory.dart' as cat;
import 'package:Plastic4trade/screen/Type_update.dart';
import 'package:Plastic4trade/utill/constant.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';

class UpdateCategoryScreen extends StatefulWidget {
  const UpdateCategoryScreen({Key? key}) : super(key: key);

  @override
  State<UpdateCategoryScreen> createState() => _UpdateCategoryScreenState();
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(this.isSelected, this.buttonText);
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
  List<RadioModel> sampleData = <RadioModel>[];
  List<RadioModel> sampleData1 = <RadioModel>[];
  bool category1 = false;
  bool category2 = false;
  bool category3 = false;
  String? location_interest;
  String? post_type;
  String category_id = '';
  bool? _isloading;
  bool _isloading1 = false;
  BuildContext? dialogContext;

  void get_data() async {
    GetCategoryController bt = GetCategoryController();
    constanst.cat_data = bt.setlogin();
    _isloading = true;
    constanst.cat_data!.then((value) {
      for (var item in value) {
        constanst.catdata.add(item);
      }
      _isloading = false;
      setState(() {});
    });
    //
  }

  clear_data() {
    constanst.selectcolor_id.clear();
    constanst.catdata.clear();
    constanst.cat_data = null;
  }

  @override
  initState() {
    super.initState();

    sampleData.add(RadioModel(false, 'Domestic'));
    sampleData.add(RadioModel(false, 'International'));
    sampleData1.add(RadioModel(false, 'Buy Post'));
    sampleData1.add(RadioModel(false, 'Sell Post'));
    constanst.select_cat_idx = -1;
    checknetwork();
  }

  @override
  Widget build(BuildContext context) {
    return initwidget(context);
  }

  Widget initwidget(BuildContext context) {
    setState(() {
      if (constanst.catdata.isEmpty) {
        _isloading = true;
      }
      for (int i = 0; i < constanst.catdata.length; i++) {
        constanst.itemsCheck.add(Icons.circle_outlined);
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          // height: MediaQuery.of(context).size.height,

          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SafeArea(
                top: true,
                left: true,
                right: true,
                maintainBottomViewPadding: true,
                child: _isloading == true
                    ? Center(
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
                      )
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: Image.asset('assets/back.png',
                                    height: 50, width: 60),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Center(
                                child: Text(
                                  'Update Category',
                                  style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets/fonst/Metropolis-Black.otf')
                                      .copyWith(fontSize: 20.0),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 4.6,
                                height: 37,
                                margin: const EdgeInsets.only(right: 10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: const Color.fromARGB(255, 0, 91, 148),
                                ),
                                child: TextButton(
                                  onPressed: () async {
                                    log("LENGTH === ${constanst.select_inserestlocation.length}");
                                    final connectivityResult =
                                        await Connectivity()
                                            .checkConnectivity();

                                    if (connectivityResult ==
                                        ConnectivityResult.none) {
                                      Fluttertoast.showToast(
                                          msg: 'Net Connection not available');
                                    } else if (constanst
                                        .select_inserestlocation.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Select Atleast 1 Domestic / International or Select Both ');
                                    } else if (constanst
                                        .select_categotyType.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Select Atleast 1 Buy Post / Sell Post or Select Both');
                                    } else if (constanst
                                        .select_categotyId.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: 'Select Minimum 1 Category');
                                    } else {
                                      setState(() {});
                                      _onLoading();
                                      setcategory().then((value) {
                                        Navigator.of(dialogContext!).pop();
                                        if (value) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Type_update(),
                                            ),
                                          );
                                        }
                                      });
                                    }
                                  },
                                  child: const Text(
                                    'Continue',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 80,
                            child: Card(
                              color: Colors.white,
                              elevation: 2,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              margin: const EdgeInsets.fromLTRB(
                                  25.0, 5.0, 25.0, 10.0),

                              //padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                              /* decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black26),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10),),
                              ),*/
                              child: Column(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 5.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Where would you like to do your business?',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets/fonst/Metropolis-Black.otf'),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          width: 120,
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                child: Row(
                                                  children: [
                                                    sampleData.first
                                                                .isSelected ==
                                                            true
                                                        ? Icon(
                                                            Icons.check_circle,
                                                            color: Colors
                                                                .green.shade600)
                                                        : const Icon(
                                                            Icons
                                                                .circle_outlined,
                                                            color:
                                                                Colors.black38),
                                                    Text(
                                                      sampleData
                                                          .first.buttonText,
                                                      style: const TextStyle(
                                                              fontSize: 13.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'assets/fonst/Metropolis-Black.otf')
                                                          .copyWith(
                                                              fontSize: 17),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    if (sampleData
                                                            .first.isSelected ==
                                                        false) {
                                                      sampleData.first
                                                          .isSelected = true;

                                                      /* sampleData1.last.isSelected =
                                                      false;*/
                                                      category1 = true;
                                                      location_interest =
                                                          'Domestic';
                                                      constanst
                                                          .select_inserestlocation
                                                          .add(
                                                        location_interest
                                                            .toString(),
                                                      );
                                                    } else {
                                                      sampleData.first
                                                          .isSelected = false;
                                                      constanst
                                                          .select_inserestlocation
                                                          .remove('Domestic');
                                                    }
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 150,
                                          height: 30,
                                          child: GestureDetector(
                                            child: Row(
                                              children: [
                                                sampleData.last.isSelected ==
                                                        true
                                                    ? Icon(Icons.check_circle,
                                                        color: Colors
                                                            .green.shade600)
                                                    : const Icon(
                                                        Icons.circle_outlined,
                                                        color: Colors.black38),
                                                Text(
                                                  sampleData.last.buttonText,
                                                  style: const TextStyle(
                                                          fontSize: 13.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf')
                                                      .copyWith(fontSize: 17),
                                                )
                                              ],
                                            ),
                                            onTap: () {
                                              setState(() {
                                                if (sampleData
                                                        .last.isSelected ==
                                                    false) {
                                                  sampleData.last.isSelected =
                                                      true;
                                                  /* sampleData1.last.isSelected =
                                                      false;*/
                                                  category1 = true;
                                                  location_interest =
                                                      'International';
                                                  constanst
                                                      .select_inserestlocation
                                                      .add(
                                                    location_interest
                                                        .toString(),
                                                  );
                                                } else {
                                                  sampleData.last.isSelected =
                                                      false;
                                                  constanst
                                                      .select_inserestlocation
                                                      .remove('International');
                                                }
                                                //Fluttertoast.showToast(msg: 'hell $sampleData.last.isSelected');
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            child: Card(
                              color: Colors.white,
                              elevation: 2,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              margin: const EdgeInsets.fromLTRB(
                                  25.0, 5.0, 25.0, 10.0),

                              //padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                              /* decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black26),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10),),
                              ),*/
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 8.0, 0.0, 0.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'You’re like to do?',
                                        style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontFamily:
                                                    'assets/fonst/Metropolis-Black.otf')
                                            .copyWith(
                                                fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.5,
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                child: Row(
                                                  children: [
                                                    sampleData1.first
                                                                .isSelected ==
                                                            true
                                                        ? Icon(
                                                            Icons.check_circle,
                                                            color: Colors
                                                                .green.shade600)
                                                        : const Icon(
                                                            Icons
                                                                .circle_outlined,
                                                            color:
                                                                Colors.black38),
                                                    Text(
                                                      'Buy Post',
                                                      style: const TextStyle(
                                                              fontSize: 13.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'assets/fonst/Metropolis-Black.otf')
                                                          .copyWith(
                                                              fontSize: 17),
                                                    )
                                                  ],
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    if (sampleData1
                                                            .first.isSelected ==
                                                        false) {
                                                      sampleData1.first
                                                          .isSelected = true;
                                                      /* sampleData1.last.isSelected =
                                                      false;*/
                                                      category2 = true;
                                                      post_type = 'BuyPost';
                                                      constanst
                                                          .select_categotyType
                                                          .add(
                                                        post_type.toString(),
                                                      );
                                                    } else {
                                                      sampleData1.first
                                                          .isSelected = false;
                                                      constanst
                                                          .select_categotyType
                                                          .remove('BuyPost');
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                            height: 30,
                                            child: GestureDetector(
                                              child: Row(
                                                children: [
                                                  sampleData1.last.isSelected ==
                                                          true
                                                      ? Icon(Icons.check_circle,
                                                          color: Colors
                                                              .green.shade600)
                                                      : const Icon(
                                                          Icons.circle_outlined,
                                                          color:
                                                              Colors.black38),
                                                  Text(
                                                    'Sell Post',
                                                    style: const TextStyle(
                                                            fontSize: 13.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'assets/fonst/Metropolis-Black.otf')
                                                        .copyWith(fontSize: 17),
                                                  )
                                                ],
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  if (sampleData1
                                                          .last.isSelected ==
                                                      false) {
                                                    sampleData1
                                                        .last.isSelected = true;
                                                    setState(() {});
                                                    /* sampleData1.last.isSelected =
                                                      false;*/
                                                    category2 = true;
                                                    post_type = 'SellPost';
                                                    constanst
                                                        .select_categotyType
                                                        .add(
                                                      post_type.toString(),
                                                    );
                                                  } else {
                                                    sampleData1.last
                                                        .isSelected = false;
                                                    constanst
                                                        .select_categotyType
                                                        .remove('SellPost');
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(27.0, 5.0, 5.0, 5.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Select Your Interest',
                                style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf')
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          FutureBuilder(

                              //future: load_subcategory(),
                              builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                snapshot.hasData == null) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: constanst.catdata.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    cat.Result record =
                                        constanst.catdata[index];

                                    if (constanst.catdata.isEmpty) {
                                      return const Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (!constanst.select_categotyId
                                                .contains(
                                              record.categoryId.toString(),
                                            )) {
                                              constanst.itemsCheck[index] =
                                                  Icons.check_circle_outline;

                                              constanst.select_categotyId.add(
                                                record.categoryId.toString(),
                                              );

                                              constanst.select_cat_id =
                                                  constanst.select_categotyId
                                                      .join(",");

                                              setState(() {});
                                            } else {
                                              constanst.itemsCheck[index] =
                                                  Icons.check_circle_outline;

                                              constanst.select_categotyId
                                                  .remove(
                                                record.categoryId.toString(),
                                              );

                                              constanst.select_cat_id =
                                                  constanst.select_categotyId
                                                      .join(",");

                                              setState(() {});
                                            }
                                          });
                                        },
                                        child: Container(
                                          height: 70,
                                          alignment: Alignment.center,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Card(
                                              color: Colors.white,
                                              //elevation: 2,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              margin: const EdgeInsets.fromLTRB(
                                                  25.0, 5.0, 25.0, 5.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          constanst
                                                                  .select_cat_idx =
                                                              index;

                                                          constanst
                                                                  .select_cat_idx =
                                                              index;
                                                          if (!constanst
                                                              .select_cat_id
                                                              .contains(
                                                            record.categoryId
                                                                .toString(),
                                                          )) {
                                                            constanst.itemsCheck[
                                                                    index] =
                                                                Icons
                                                                    .check_circle_outline;

                                                            constanst
                                                                .select_categotyId
                                                                .add(
                                                              record.categoryId
                                                                  .toString(),
                                                            );

                                                            constanst
                                                                    .select_cat_id =
                                                                constanst
                                                                    .select_categotyId
                                                                    .join(",");

                                                            setState(() {});
                                                          } else {
                                                            constanst.itemsCheck[
                                                                    index] =
                                                                Icons
                                                                    .check_circle_outline;

                                                            constanst
                                                                .select_categotyId
                                                                .remove(
                                                              record.categoryId
                                                                  .toString(),
                                                            );

                                                            constanst
                                                                    .select_cat_id =
                                                                constanst
                                                                    .select_categotyId
                                                                    .join(",");

                                                            setState(() {});
                                                          }
                                                        });
                                                      },
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                            child: IconButton(
                                                              icon: constanst
                                                                      .select_categotyId
                                                                      .contains(
                                                                record
                                                                    .categoryId
                                                                    .toString(),
                                                              )
                                                                  ? Icon(
                                                                      Icons
                                                                          .check_circle,
                                                                      color: Colors
                                                                          .green
                                                                          .shade600)
                                                                  : const Icon(
                                                                      Icons
                                                                          .circle_outlined,
                                                                      color: Colors
                                                                          .black45),
                                                              onPressed: () {
                                                                setState(() {
                                                                  constanst
                                                                          .select_cat_idx =
                                                                      index;

                                                                  constanst
                                                                          .select_cat_idx =
                                                                      index;
                                                                  if (!constanst
                                                                      .select_cat_id
                                                                      .contains(
                                                                    record
                                                                        .categoryId
                                                                        .toString(),
                                                                  )) {
                                                                    constanst.itemsCheck[
                                                                            index] =
                                                                        Icons
                                                                            .check_circle_outline;

                                                                    constanst
                                                                        .select_categotyId
                                                                        .add(
                                                                      record
                                                                          .categoryId
                                                                          .toString(),
                                                                    );

                                                                    constanst.select_cat_id = constanst
                                                                        .select_categotyId
                                                                        .join(
                                                                            ",");
                                                                    setState(
                                                                        () {});
                                                                  } else {
                                                                    constanst.itemsCheck[
                                                                            index] =
                                                                        Icons
                                                                            .check_circle_outline;

                                                                    constanst
                                                                        .select_categotyId
                                                                        .remove(
                                                                      record
                                                                          .categoryId
                                                                          .toString(),
                                                                    );

                                                                    constanst.select_cat_id = constanst
                                                                        .select_categotyId
                                                                        .join(
                                                                            ",");
                                                                    setState(
                                                                        () {});
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          Text(
                                                            record.categoryName
                                                                .toString(),
                                                            style: const TextStyle(
                                                                    fontSize:
                                                                        13.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        'assets/fonst/Metropolis-Black.otf',
                                                                    color: Colors
                                                                        .black)
                                                                .copyWith(
                                                                    fontSize:
                                                                        17),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  });
                            }
                          }),
                          Container(
                            width: MediaQuery.of(context).size.width * 1.2,
                            height: 60,
                            margin: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(50.0),
                              color: const Color.fromARGB(255, 0, 91, 148),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                final connectivityResult =
                                    await Connectivity().checkConnectivity();

                                if (connectivityResult ==
                                    ConnectivityResult.none) {
                                  Fluttertoast.showToast(
                                      msg: 'Net Connection not available');
                                } else if (constanst
                                    .select_inserestlocation.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg:
                                          'Select Atleast 1 Domestic / International or Select Both ');
                                } else if (constanst
                                    .select_categotyType.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg:
                                          'Select Atleast 1 Buy Post / Sell Post or Select Both');
                                } else if (constanst
                                    .select_categotyId.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: 'Select Minimum 1 Category');
                                } else {
                                  setState(() {});
                                  _onLoading();
                                  setcategory().then((value) {
                                    Navigator.of(dialogContext!).pop();
                                    if (value) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Type_update(),
                                        ),
                                      );
                                    }
                                  });
                                }
                              },
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf'),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    constanst.itemsCheck.clear();
  }

  getProfiless() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    constanst.itemsCheck.clear();

    var res = await getbussinessprofile(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );

    if (res['status'] == 1) {
      category_id = res['user']['category_id'];
      location_interest = res['user']['location_interest'];
      post_type = res['user']['posttype'];

      if (post_type == "Both") {
        constanst.select_categotyType.add('BuyPost');
        constanst.select_categotyType.add('SellPost');
      } else if (post_type.toString() == "BuyPost") {
        sampleData1.first.isSelected = true;
        constanst.select_categotyType.add(
          post_type.toString(),
        );
      } else if (post_type.toString() == "SellPost") {
        sampleData1.last.isSelected = true;
        constanst.select_categotyType.add(
          post_type.toString(),
        );
      }

      if (location_interest == "Both") {
        sampleData.first.isSelected = true;
        sampleData.last.isSelected = true;
        constanst.select_inserestlocation.add("Domestic");
        constanst.select_inserestlocation.add("International");
      } else if (location_interest.toString() == "Domestic") {
        sampleData.first.isSelected = true;
        constanst.select_inserestlocation.add(
          location_interest.toString(),
        );
      } else if (location_interest.toString() == "International") {
        sampleData.last.isSelected = true;
        constanst.select_inserestlocation.add(
          location_interest.toString(),
        );
      }

      constanst.select_categotyId = category_id.split(",");
    } else {
      Fluttertoast.showToast(
        msg: res['message'],
      );
    }

    setState(() {});
  }

  Future<bool> setcategory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var stringCategory = constanst.select_categotyId.join(",");

    if (constanst.select_inserestlocation.length == 2) {
      location_interest = 'Both';
    } else {
      location_interest = constanst.select_inserestlocation.join(",");
    }
    if (constanst.select_categotyType.length == 2) {
      post_type = 'Both';
    } else {
      post_type = constanst.select_categotyType.join(",");
    }

    if (constanst.select_inserestlocation.isNotEmpty &&
        constanst.select_categotyType.isNotEmpty &&
        constanst.select_categotyId.isNotEmpty) {
      var res = await addcategory(
          pref.getString('user_id').toString(),
          pref.getString('api_token').toString(),
          location_interest.toString(),
          post_type.toString(),
          stringCategory.trim(),
          '7');

      if (res['status'] == 1) {
        Fluttertoast.showToast(
          msg: res['message'],
        );
        _isloading1 = true;
      } else {
        _isloading1 = true;
        Fluttertoast.showToast(
          msg: res['message'],
        );
      }
      setState(() {});
    }
    return _isloading1;
  }

  checknetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      constanst.catdata.clear();
      _isloading = true;
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      clear_data();
      get_data();
      getProfiless();
    }
  }

  void _onLoading() {
    dialogContext = context;

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
  }
}
