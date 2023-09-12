import 'package:Plastic4trade/screen/Register2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Plastic4trade/constroller/GetCategoryController.dart';
import 'package:Plastic4trade/model/common.dart';
import 'package:Plastic4trade/screen/Type.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/screen/Videos.dart';
import 'package:Plastic4trade/utill/constant.dart';
import 'dart:ui';
import 'package:Plastic4trade/model/GetCategory.dart' as cat;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

import '../api/api_interface.dart';
import '../widget/MainScreen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(this.isSelected, this.buttonText);
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<RadioModel> sampleData = <RadioModel>[];
  List<RadioModel> sampleData1 = <RadioModel>[];
  bool category1 = false;
  bool category2 = false;
  bool category3 = false;
  String location_interest = "";
  String post_type = "";
  String category_id = '';
  bool? _isloading;
  bool _isloading1 = false;
  BuildContext? dialogContext;

  void get_data() async {
    GetCategoryController bt = await GetCategoryController();
    constanst.cat_data = bt.setlogin();
    _isloading = true;
    constanst.cat_data!.then((value) {
      if (value != null) {
        for (var item in value) {
          constanst.catdata.add(item);
        }
      }
      _isloading = false;
      setState(() {});
    });
    //
  }

  @override
  initState() {
    super.initState();

    sampleData.add(new RadioModel(false, 'Domestic'));
    sampleData.add(new RadioModel(
      false,
      'International',
    ));
    sampleData1.add(new RadioModel(false, 'Buy Post'));
    sampleData1.add(new RadioModel(
      false,
      'Sell Post',
    ));

    checknetwork();
  }

  @override
  Widget build(BuildContext context) {
    return initwidget(context);
  }

  Future<bool> _onbackpress(BuildContext context) async {
    /* Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => MainScreen(0)),
        ModalRoute.withName('/')
    );*/
    Navigator.pop(context);
    return Future.value(true);
  }

  Widget initwidget(BuildContext context) {
    print(_isloading);
    setState(() {
      print('hello' + constanst.catdata.length.toString());
      if (constanst.catdata.isEmpty) {
        _isloading = true;
        print(_isloading);
      }
      for (int i = 0; i < constanst.catdata.length; i++) {
        constanst.itemsCheck.add(Icons.circle_outlined);
      }
    });
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: WillPopScope(
          onWillPop: () => _onbackpress(context),
          child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                  // height: MediaQuery.of(context).size.height,

                  width: MediaQuery.of(context).size.width,
                  child: Column(children: [
                    SafeArea(
                      top: true,
                      left: true,
                      right: true,
                      maintainBottomViewPadding: true,
                      child: _isloading == true
                          ? Align(
                              alignment: Alignment.center,
                              child: Center(
                                  child: Platform.isAndroid
                                      ? CircularProgressIndicator(
                                          value: null,
                                          strokeWidth: 2.0,
                                          color:
                                              Color.fromARGB(255, 0, 91, 148),
                                        )
                                      : Platform.isIOS
                                          ? CupertinoActivityIndicator(
                                              color: Color.fromARGB(
                                                  255, 0, 91, 148),
                                              radius: 20,
                                              animating: true,
                                            )
                                          : Container()))
                          : Column(children: [
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
                                  'Category',
                                  style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets\fonst\Metropolis-Black.otf')
                                      ?.copyWith(fontSize: 20.0),
                                )),

                                    Container(
                                      width: MediaQuery.of(context).size.width /4.6,
                                      height: 37,
                                      margin: EdgeInsets.only(right: 10.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Color.fromARGB(255, 0, 91, 148)),
                                      child: TextButton(
                                        onPressed: () async {
                                          // if (_formKey.currentState!.validate()) {
                                          //   Fluttertoast.showToast(
                                          //       msg: "Data Proccess");
                                          //   vaild_data();
                                          // }
                                          // setState(() {});

                                          final connectivityResult =
                                          await Connectivity()
                                              .checkConnectivity();

                                          if (connectivityResult ==
                                              ConnectivityResult.none) {
                                            Fluttertoast.showToast(
                                                msg: 'Net Connection not available');
                                          } else {
                                            print(constanst.select_inserestlocation);
                                            print(location_interest);
                                            if (location_interest.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  'Select Atleast 1 Domestic / International or Select Both ');
                                            } else if (post_type.isEmpty) {
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
                                                print('12346 $value');
                                                Navigator.of(dialogContext!).pop();
                                                if (value) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Type()));
                                                } else {
                                                  /*   Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Type()));*/
                                                }
                                              });
                                              // constanst.itemsCheck.clear();
                                            }
                                          }
                                        },
                                        child: Text('Continue',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                                fontFamily:
                                                'assets\fonst\Metropolis-Black.otf')),
                                      ),
                                    ),

                              ]),
                              Container(
                                height: 80,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  margin: EdgeInsets.fromLTRB(
                                      25.0, 5.0, 25.0, 10.0),

                                  //padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                  /* decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black26),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),*/
                                  child: Column(children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          8.0, 8.0, 0.0, 5.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            'Where would you like to do your business?',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf')),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                height: 30,
                                                width: 120,
                                                child: Row(children: [
                                                  GestureDetector(
                                                    child: Row(
                                                      children: [
                                                        sampleData.first
                                                                    .isSelected ==
                                                                true
                                                            ? Icon(
                                                                Icons
                                                                    .check_circle,
                                                                color: Colors
                                                                    .green
                                                                    .shade600)
                                                            : Icon(
                                                                Icons
                                                                    .circle_outlined,
                                                                color: Colors
                                                                    .black38),
                                                        Text(
                                                            sampleData
                                                                .first.buttonText,
                                                            style: TextStyle(
                                                                    fontSize:
                                                                        13.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        'assets\fonst\Metropolis-Black.otf')
                                                                ?.copyWith(
                                                                    fontSize:
                                                                        17)),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        if (sampleData.first
                                                                .isSelected ==
                                                            false) {
                                                          sampleData.first
                                                                  .isSelected =
                                                              true;
                                                          /* sampleData1.last.isSelected =
                                                      false;*/
                                                          category1 = true;
                                                          location_interest =
                                                              'Domestic';
                                                          constanst
                                                              .select_inserestlocation
                                                              .add(location_interest
                                                                  .toString());
                                                          print(constanst
                                                              .select_inserestlocation);
                                                        } else {
                                                          sampleData.first
                                                                  .isSelected =
                                                              false;
                                                          constanst
                                                              .select_inserestlocation
                                                              .remove(
                                                                  'Domestic');
                                                          print(constanst
                                                              .select_inserestlocation);
                                                        }
                                                      });
                                                    },
                                                  )
                                                ])),
                                            SizedBox(
                                              width: 150,
                                              height: 30,
                                              child: GestureDetector(
                                                child: Row(children: [
                                                  sampleData.last.isSelected ==
                                                          true
                                                      ? Icon(Icons.check_circle,
                                                          color: Colors
                                                              .green.shade600)
                                                      : Icon(
                                                          Icons.circle_outlined,
                                                          color:
                                                              Colors.black38),
                                                  Text(
                                                      sampleData
                                                          .last.buttonText,
                                                      style: TextStyle(
                                                              fontSize: 13.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-Black.otf')
                                                          ?.copyWith(
                                                              fontSize: 17))
                                                ]),
                                                onTap: () {
                                                  setState(() {
                                                    if (sampleData
                                                            .last.isSelected ==
                                                        false) {
                                                      sampleData.last
                                                          .isSelected = true;
                                                      /* sampleData1.last.isSelected =
                                                      false;*/
                                                      category1 = true;
                                                      location_interest =
                                                          'International';
                                                      constanst
                                                          .select_inserestlocation
                                                          .add(location_interest
                                                              .toString());
                                                      print(constanst
                                                          .select_inserestlocation);
                                                    } else {
                                                      sampleData.last
                                                          .isSelected = false;
                                                      constanst
                                                          .select_inserestlocation
                                                          .remove(
                                                              'International');
                                                      print(constanst
                                                          .select_inserestlocation);
                                                    }
                                                    //Fluttertoast.showToast(msg: 'hell $sampleData.last.isSelected');
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ))
                                  ]),
                                ),
                              ),
                              Container(
                                height: 80,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  margin: EdgeInsets.fromLTRB(
                                      25.0, 5.0, 25.0, 10.0),

                                  //padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                  /* decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black26),
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                              ),*/
                                  child: Column(children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          8.0, 8.0, 0.0, 0.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'You’re like to do?',
                                          style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets\fonst\Metropolis-Black.otf')
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              child: SizedBox(
                                                height: 30,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3.5,
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      child: Row(children: [
                                                        sampleData1.first
                                                                    .isSelected ==
                                                                true
                                                            ? Icon(
                                                                Icons
                                                                    .check_circle,
                                                                color: Colors
                                                                    .green
                                                                    .shade600)
                                                            : Icon(
                                                                Icons
                                                                    .circle_outlined,
                                                                color: Colors
                                                                    .black38),
                                                        Text('Buy Post',
                                                            style: TextStyle(
                                                                    fontSize:
                                                                        13.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        'assets\fonst\Metropolis-Black.otf')
                                                                ?.copyWith(
                                                                    fontSize:
                                                                        17))
                                                      ]),
                                                    ),
                                                  ],
                                                ),
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
                                                        .add(post_type
                                                            .toString());
                                                    print(constanst
                                                        .select_categotyType);
                                                  } else {
                                                    sampleData1.first
                                                        .isSelected = false;
                                                    constanst
                                                        .select_categotyType
                                                        .remove('BuyPost');
                                                    print(constanst
                                                        .select_categotyType);
                                                  }
                                                });
                                              },
                                            ),
                                            GestureDetector(
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.5,
                                                height: 30,
                                                child: GestureDetector(
                                                  child: Row(children: [
                                                    sampleData1.last
                                                                .isSelected ==
                                                            true
                                                        ? Icon(
                                                            Icons.check_circle,
                                                            color: Colors
                                                                .green.shade600)
                                                        : Icon(
                                                            Icons
                                                                .circle_outlined,
                                                            color:
                                                                Colors.black38),
                                                    Text('Sell Post',
                                                        style: TextStyle(
                                                                fontSize: 13.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'assets\fonst\Metropolis-Black.otf')
                                                            ?.copyWith(
                                                                fontSize: 17))
                                                  ]),
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  print(sampleData1
                                                      .last.isSelected);
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
                                                        .add(post_type
                                                            .toString());
                                                    print(constanst
                                                        .select_categotyType);
                                                  } else {
                                                    sampleData1.last
                                                        .isSelected = false;
                                                    constanst
                                                        .select_categotyType
                                                        .remove('SellPost');
                                                    print(constanst
                                                        .select_categotyType);
                                                  }
                                                });
                                              },
                                            )
                                          ],
                                        ))
                                  ]),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(27.0, 5.0, 5.0, 5.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Select Your Interest',
                                    style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets\fonst\Metropolis-Black.otf')
                                        ?.copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              FutureBuilder(

                                  //future: load_subcategory(),
                                  builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting &&
                                    snapshot.hasData == null) {
                                  return Center(
                                      child: Platform.isAndroid
                                          ? CircularProgressIndicator(
                                              value: null,
                                              strokeWidth: 2.0,
                                              color: Color.fromARGB(
                                                  255, 0, 91, 148),
                                            )
                                          : Platform.isIOS
                                              ? CupertinoActivityIndicator(
                                                  color: Color.fromARGB(
                                                      255, 0, 91, 148),
                                                  radius: 20,
                                                  animating: true,
                                                )
                                              : Container());
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: constanst.catdata.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        cat.Result record =
                                            constanst.catdata[index];

                                        if (constanst.catdata.isEmpty) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Center(
                                                child: Platform.isAndroid
                                                    ? CircularProgressIndicator(
                                                        value: null,
                                                        strokeWidth: 2.0,
                                                        color: Color.fromARGB(
                                                            255, 0, 91, 148),
                                                      )
                                                    : Platform.isIOS
                                                        ? CupertinoActivityIndicator(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    91,
                                                                    148),
                                                            radius: 20,
                                                            animating: true,
                                                          )
                                                        : Container()),
                                          );
                                        } else {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (constanst
                                                        .itemsCheck[index] ==
                                                    Icons.circle_outlined) {
                                                  category3 = true;
                                                  constanst.itemsCheck[index] =
                                                      Icons
                                                          .check_circle_outline;
                                                  category_id = record
                                                      .categoryId
                                                      .toString();
                                                  constanst.select_categotyId
                                                      .add(category_id);
                                                } else {
                                                  constanst.itemsCheck[index] =
                                                      Icons.circle_outlined;
                                                  category_id = record
                                                      .categoryId
                                                      .toString();
                                                  constanst.select_categotyId
                                                      .remove(category_id);
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
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10.0))),
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                25.0,
                                                                5.0,
                                                                25.0,
                                                                5.0),
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Row(
                                                                    children: [
                                                                      GestureDetector(
                                                                          child:
                                                                              IconButton(
                                                                        icon: constanst.itemsCheck[index] ==
                                                                                Icons.circle_outlined
                                                                            ? Icon(Icons.circle_outlined, color: Colors.black45)
                                                                            : Icon(Icons.check_circle, color: Colors.green.shade600),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            if (constanst.itemsCheck[index] ==
                                                                                Icons.circle_outlined) {
                                                                              category3 = true;
                                                                              constanst.itemsCheck[index] = Icons.check_circle_outline;
                                                                              category_id = record.categoryId.toString();
                                                                              constanst.select_categotyId.add(category_id);
                                                                            } else {
                                                                              constanst.itemsCheck[index] = Icons.circle_outlined;
                                                                              category_id = record.categoryId.toString();
                                                                              constanst.select_categotyId.remove(category_id);
                                                                            }
                                                                          });
                                                                        },
                                                                      )),
                                                                      Text(
                                                                          record
                                                                              .categoryName
                                                                              .toString(),
                                                                          style:
                                                                              TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500, fontFamily: 'assets\fonst\Metropolis-Black.otf')?.copyWith(fontSize: 17))
                                                                    ]),
                                                              ),
                                                            ])))),
                                          );
                                        }
                                      });
                                }
                              }),
                              Container(
                                width: MediaQuery.of(context).size.width * 1.2,
                                height: 60,
                                margin: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Color.fromARGB(255, 0, 91, 148)),
                                child: TextButton(
                                  onPressed: () async {
                                    // if (_formKey.currentState!.validate()) {
                                    //   Fluttertoast.showToast(
                                    //       msg: "Data Proccess");
                                    //   vaild_data();
                                    // }
                                    // setState(() {});

                                    final connectivityResult =
                                        await Connectivity()
                                            .checkConnectivity();

                                    if (connectivityResult ==
                                        ConnectivityResult.none) {
                                      Fluttertoast.showToast(
                                          msg: 'Net Connection not available');
                                    } else {
                                      print(constanst.select_inserestlocation);
                                      print(location_interest);
                                      if (location_interest.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Select Atleast 1 Domestic / International or Select Both ');
                                      } else if (post_type.isEmpty) {
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
                                          print('12346 $value');
                                          Navigator.of(dialogContext!).pop();
                                          if (value) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Type()));
                                          } else {
                                         /*   Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Type()));*/
                                          }
                                        });
                                        // constanst.itemsCheck.clear();
                                      }
                                    }
                                  },
                                  child: Text('Continue',
                                      style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          fontFamily:
                                              'assets\fonst\Metropolis-Black.otf')),
                                ),
                              ),
                            ]),
                    ),
                  ]))),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    constanst.itemsCheck.clear();
  }

  Future<bool> setcategory() async {
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    constanst.step = 7;
    var stringCategory = constanst.select_categotyId.join(",");
    print(stringCategory);
    var stringtype;
    if (constanst.select_categotyType.length == 2) {
      stringtype = 'Both';
    } else {
      stringtype = constanst.select_categotyType.join(",");
    }

    print(stringtype);
    var stringList;
    if (constanst.select_inserestlocation.length == 2) {
      stringList = 'Both';
    } else {
      stringList = constanst.select_inserestlocation.join(",");
    }
    print(stringList);
    var res = await addcategory(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        stringList,
        stringtype,
        stringCategory,
        constanst.step.toString());

    String? msg = res['message'];
    /*Fluttertoast.showToast(msg: "$msg");*/
    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);
      _isloading1 = true;
      /*Navigator.push(context, MaterialPageRoute(builder: (context) => Type()));*/
      constanst.iscategory = false;
      constanst.appopencount1 = 2;
    } else {
      _isloading1 = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    //setState(() {});
    return _isloading1;
  }

  checknetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      constanst.catdata.clear();
      _isloading = false;
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      get_data();
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
              ),
            ));
      },
    );

    /*Future.delayed(const Duration(seconds: 5), () {
      print('exit');
      Navigator.of(dialogContext!).pop(); // Use dialogContext to close the dialog
      print('exit1'); // Dialog closed
    });*/
  }
}
