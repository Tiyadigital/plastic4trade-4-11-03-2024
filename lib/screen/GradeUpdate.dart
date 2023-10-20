// ignore_for_file: camel_case_types, unnecessary_null_comparison, non_constant_identifier_names

import 'dart:io' show Platform;

import 'package:Plastic4trade/api/api_interface.dart';
import 'package:Plastic4trade/model/GetCategoryGrade.dart' as grade;
import 'package:Plastic4trade/utill/constant.dart';
import 'package:Plastic4trade/widget/MainScreen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constroller/GetCategoryGradeController.dart';

class Grade_update extends StatefulWidget {
  const Grade_update({Key? key}) : super(key: key);

  @override
  State<Grade_update> createState() => _Grade_updateState();
}

class _Grade_updateState extends State<Grade_update> {
  bool category3 = false;
  bool? _isloading;
  String grade_id = '';
  bool _isloading1 = false;
  BuildContext? dialogContext;

  @override
  void initState() {
    super.initState();
    checknetwork();
  }

  @override
  Widget build(BuildContext context) {
    return initwidget(context);
  }

  Widget initwidget(BuildContext context) {
    setState(() {
      for (int i = 0; i < constanst.cat_grade_data.length; i++) {
        constanst.itemsCheck.add(Icons.circle_outlined);
      }
    });
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: SizedBox(


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
                                  ? const CircularProgressIndicator(
                                      value: null,
                                      strokeWidth: 2.0,
                                      color: Color.fromARGB(255, 0, 91, 148),
                                    )
                                  : Platform.isIOS
                                      ? const CupertinoActivityIndicator(
                                          color:
                                              Color.fromARGB(255, 0, 91, 148),
                                          radius: 20,
                                          animating: true,
                                        )
                                      : Container()),
                        )
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
                                  'Update Grade',
                                  style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets/fonst/Metropolis-Black.otf')
                                      .copyWith(fontSize: 20.0),
                                )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 4.6,
                                  height: 37,
                                  margin: const EdgeInsets.only(right: 10.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: const Color.fromARGB(255, 0, 91, 148)),
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if (constanst.select_gradeId.isEmpty) {
                                          Fluttertoast.showToast(
                                              msg: 'Please Select Grade');
                                        } else {
                                          /*Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Type()));*/
                                          _onLoading();
                                          setGrade().then((value) {
                                            Navigator.of(dialogContext!).pop();
                                            if (value) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MainScreen(4)));
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MainScreen(4)));
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
                            padding: const EdgeInsets.fromLTRB(27.0, 5.0, 5.0, 5.0),
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


                              builder: (context, snapshot) {
                            if (snapshot.hasData == null &&
                                snapshot.connectionState ==
                                    ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
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
                                    itemCount: constanst.cat_grade_data.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      grade.Result record =
                                          constanst.cat_grade_data[index];
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            constanst.select_grade_idx = index;

                                            constanst.select_grade_idx = index;
                                            if (!constanst.select_gradeId
                                                .contains(record.productgradeId
                                                    .toString())) {
                                              constanst.itemsCheck[index] =
                                                  Icons.check_circle_outline;

                                              constanst.select_gradeId.add(
                                                  record.productgradeId
                                                      .toString());

                                              constanst.select_grade_id =
                                                  constanst.select_gradeId
                                                      .join(",");


                                              setState(() {});
                                              // print(constanst.colorsitemsCheck[index]==Icons.check_circle);
                                            } else {
                                              constanst.itemsCheck[index] =
                                                  Icons.check_circle_outline;

                                              constanst.select_gradeId.remove(
                                                  record.productgradeId
                                                      .toString());

                                              constanst.select_grade_id =
                                                  constanst.select_gradeId
                                                      .join(",");


                                              setState(() {});
                                            }
                                          });
                                        },
                                        child: SizedBox(
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Card(
                                                    color: Colors.white,
                                                    elevation: 3,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0))),
                                                    margin: const EdgeInsets.fromLTRB(
                                                        25.0, 10.0, 25.0, 5.0),
                                                    child: Column(children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Row(children: [
                                                          GestureDetector(
                                                              child: IconButton(
                                                            icon: constanst
                                                                    .select_gradeId
                                                                    .contains(record
                                                                        .productgradeId
                                                                        .toString())
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
                                                                        .select_grade_idx =
                                                                    index;

                                                                constanst
                                                                        .select_grade_idx =
                                                                    index;
                                                                if (!constanst
                                                                    .select_gradeId
                                                                    .contains(record
                                                                        .productgradeId
                                                                        .toString())) {
                                                                  constanst.itemsCheck[
                                                                          index] =
                                                                      Icons
                                                                          .check_circle_outline;

                                                                  constanst
                                                                      .select_gradeId
                                                                      .add(record
                                                                          .productgradeId
                                                                          .toString());

                                                                  constanst
                                                                          .select_grade_id =
                                                                      constanst
                                                                          .select_gradeId
                                                                          .join(
                                                                              ",");


                                                                  setState(
                                                                      () {});
                                                                  // print(constanst.colorsitemsCheck[index]==Icons.check_circle);
                                                                } else {
                                                                  constanst.itemsCheck[
                                                                          index] =
                                                                      Icons
                                                                          .check_circle_outline;

                                                                  constanst
                                                                      .select_gradeId
                                                                      .remove(record
                                                                          .productgradeId
                                                                          .toString());

                                                                  constanst
                                                                          .select_grade_id =
                                                                      constanst
                                                                          .select_gradeId
                                                                          .join(
                                                                              ",");


                                                                  setState(
                                                                      () {});
                                                                }
                                                              });
                                                            },
                                                          )),
                                                          Text(record.productGrade.toString(),
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
                                                                          17))
                                                        ]),
                                                      ),
                                                    ])))),
                                      );
                                    });
                              }
                            }
                          }),
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
                                                    MainScreen(4)));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainScreen(4)));
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
                        ])),
            ]),
          ),
        ));
  }

  void get_data() async {
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
    //
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
            ));
      },
    );

    /*Future.delayed(const Duration(seconds: 5), () {
      print('exit');
      Navigator.of(dialogContext!).pop(); // Use dialogContext to close the dialog
      print('exit1'); // Dialog closed
    });*/
  }

  checknetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      constanst.catdata.clear();
      _isloading = false;
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      clean_data();
      getProfiless();
      get_data();
    }
  }

  getProfiless() async {
    SharedPreferences pref = await SharedPreferences.getInstance();


    var res = await getbussinessprofile(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );

    if (res['status'] == 1) {
      grade_id = res['user']['grade_id'];

      constanst.select_gradeId = grade_id.split(",");
    } else {
      Fluttertoast.showToast(msg: res['message']);

    }

    setState(() {});
  }

  clean_data() {
    constanst.select_gradeId.clear();
    constanst.itemsCheck.clear();
    constanst.Type_itemsCheck.clear();
    constanst.Grade_itemsCheck.clear();
    constanst.select_grade_name.clear();
    constanst.select_grade_id = "";
    constanst.select_grade_idx = 0;
  }

  Future<bool> setGrade() async {
    var stringgrade = constanst.select_gradeId.join(",");

    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await addProductgrade(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),

      stringgrade.trim(),
      '9',
    );


    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);
      clean_data();
      _isloading1 = true;
    } else {
      clean_data();
      Fluttertoast.showToast(msg: res['message']);
      _isloading1 = true;
    }
    setState(() {});
    return _isloading1;
  }
}
