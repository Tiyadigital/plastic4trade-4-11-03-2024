// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison

import 'dart:io' show Platform;

import 'package:Plastic4trade/api/api_interface.dart';
import 'package:Plastic4trade/model/GetCategoryGrade.dart' as grade;
import 'package:Plastic4trade/utill/constant.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constroller/GetCategoryGradeController.dart';
import '../widget/MainScreen.dart';

class Grade extends StatefulWidget {
  const Grade({Key? key}) : super(key: key);

  @override
  State<Grade> createState() => _TypeState();
}

class _TypeState extends State<Grade> {
  bool category3 = false;
  bool? _isloading;
  String grade_id = '';
  BuildContext? dialogContext;
  bool _isloading1 = false;

  @override
  void initState() {
    super.initState();

    checknetwork();
  }

  Future<bool> _onbackpress(BuildContext context) async {
    Navigator.pop(context);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return initwidget(context);
  }

  Widget initwidget(BuildContext context) {
    setState(() {
      for (int i = 0; i < constanst.cat_grade_data.length; i++) {
        constanst.Grade_itemsCheck1.add(Icons.circle_outlined);
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: WillPopScope(
        onWillPop: () => _onbackpress(context),
        child: _isloading == true
            ? Align(
                alignment: Alignment.center,
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
              )
            : SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      SafeArea(
                        top: true,
                        left: true,
                        right: true,
                        maintainBottomViewPadding: true,
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      'Grade',
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
                                    width:
                                        MediaQuery.of(context).size.width / 4.6,
                                    height: 37,
                                    margin: const EdgeInsets.only(right: 10.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: const Color.fromARGB(
                                            255, 0, 91, 148)),
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          if (constanst
                                              .select_gradeId.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg: 'Please Select Grade');
                                          } else {
                                            _onLoading();
                                            setGrade().then((value) {
                                              Navigator.of(dialogContext!)
                                                  .pop();
                                              if (value) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MainScreen(0)));
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MainScreen(0)));
                                              }
                                            });
                                          }
                                        });
                                      },
                                      child: const Text('Continue',
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf')),
                                    ),
                                  ),
                                ]),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  27.0, 5.0, 5.0, 5.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Select Your Grade',
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
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  if (constanst.cat_grade_data.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  } else {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            constanst.cat_grade_data.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          grade.Result record =
                                              constanst.cat_grade_data[index];
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                category3 = true;

                                                if (constanst.Grade_itemsCheck1[
                                                        index] ==
                                                    Icons.circle_outlined) {
                                                  constanst.Grade_itemsCheck1[
                                                          index] =
                                                      Icons
                                                          .check_circle_outline;
                                                  grade_id = record
                                                      .productgradeId
                                                      .toString();
                                                  constanst.select_gradeId
                                                      .add(grade_id);
                                                } else {
                                                  constanst.Grade_itemsCheck1[
                                                          index] =
                                                      Icons.circle_outlined;
                                                  grade_id = record
                                                      .productgradeId
                                                      .toString();
                                                  constanst.select_gradeId
                                                      .remove(grade_id);
                                                }
                                              });
                                            },
                                            child: SizedBox(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Card(
                                                  color: Colors.white,
                                                  elevation: 3,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0))),
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          25.0,
                                                          10.0,
                                                          25.0,
                                                          5.0),
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              category3 = true;

                                                              if (constanst
                                                                          .Grade_itemsCheck1[
                                                                      index] ==
                                                                  Icons
                                                                      .circle_outlined) {
                                                                constanst.Grade_itemsCheck1[
                                                                        index] =
                                                                    Icons
                                                                        .check_circle_outline;
                                                                grade_id = record
                                                                    .productgradeId
                                                                    .toString();
                                                                constanst
                                                                    .select_gradeId
                                                                    .add(
                                                                        grade_id);
                                                              } else {
                                                                constanst.Grade_itemsCheck1[
                                                                        index] =
                                                                    Icons
                                                                        .circle_outlined;
                                                                grade_id = record
                                                                    .productgradeId
                                                                    .toString();
                                                                constanst
                                                                    .select_gradeId
                                                                    .remove(
                                                                        grade_id);
                                                              }
                                                            });
                                                          },
                                                          child: Row(
                                                            children: [
                                                              GestureDetector(
                                                                child:
                                                                    IconButton(
                                                                  icon: constanst.Grade_itemsCheck1[
                                                                              index] ==
                                                                          Icons
                                                                              .circle_outlined
                                                                      ? const Icon(
                                                                          Icons
                                                                              .circle_outlined,
                                                                          color: Colors
                                                                              .black45)
                                                                      : Icon(
                                                                          Icons
                                                                              .check_circle,
                                                                          color: Colors
                                                                              .green
                                                                              .shade600),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                      () {
                                                                        category3 =
                                                                            true;

                                                                        if (constanst.Grade_itemsCheck1[index] ==
                                                                            Icons.circle_outlined) {
                                                                          constanst.Grade_itemsCheck1[index] =
                                                                              Icons.check_circle_outline;
                                                                          grade_id = record
                                                                              .productgradeId
                                                                              .toString();
                                                                          constanst
                                                                              .select_gradeId
                                                                              .add(grade_id);
                                                                        } else {
                                                                          constanst.Grade_itemsCheck1[index] =
                                                                              Icons.circle_outlined;
                                                                          grade_id = record
                                                                              .productgradeId
                                                                              .toString();
                                                                          constanst
                                                                              .select_gradeId
                                                                              .remove(grade_id);
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              Text(
                                                                  record
                                                                      .productGrade
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                          fontSize:
                                                                              13.0,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              'assets/fonst/Metropolis-Black.otf')
                                                                      .copyWith(
                                                                          fontSize:
                                                                              17))
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
                                        });
                                  }
                                }
                              },
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 1.2,
                              height: 60,
                              margin: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: const Color.fromARGB(255, 0, 91, 148)),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (constanst.select_gradeId.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: 'Please Select Grade');
                                    } else {
                                      _onLoading();
                                      setGrade().then((value) {
                                        Navigator.of(dialogContext!).pop();
                                        if (value) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MainScreen(0),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MainScreen(0),
                                            ),
                                          );
                                        }
                                      });
                                    }
                                  });
                                },
                                child: const Text('Continue',
                                    style: TextStyle(
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
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
                            : Container()),
              ),
            ),
          ),
        );
      },
    );
  }

  void get_data() async {
    // Clear the existing cat_grade_data list
    constanst.cat_grade_data.clear();

    GetCategoryGradeController bt = GetCategoryGradeController();
    constanst.cat_gradedata = bt.setGrade();
    _isloading = true;
    constanst.cat_gradedata!.then((value) {
      for (var item in value) {
        constanst.cat_grade_data.add(item);
      }
      _isloading = false;
      setState(() {});
    });
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

  Future<bool> setGrade() async {
    var stringgrade = constanst.select_gradeId.join(",");

    constanst.step = 9;
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await addgrade(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        stringgrade.trim(),
        constanst.step.toString());


    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: 'Interest Selected Successfully');
      constanst.isgrade = false;
      _isloading1 = true;
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return _isloading1;
  }
}
