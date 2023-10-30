// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:Plastic4trade/constroller/GetCategoryTypeController.dart';
import 'package:Plastic4trade/model/GetCategoryType.dart' as type;
import 'package:Plastic4trade/screen/GradeScreen.dart';
import 'package:Plastic4trade/utill/constant.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';

class Type extends StatefulWidget {
  const Type({Key? key}) : super(key: key);

  @override
  State<Type> createState() => _TypeState();
}

class _TypeState extends State<Type> {
  bool category3 = false;
  String type_id = '';
  bool? _isloading;
  bool _isloading1 = false;
  BuildContext? dialogContext;

  @override
  void initState() {
    super.initState();

    checknetwork();
  }

  void get_data() async {
    // Clear the existing cat_type_data list
    constanst.cat_type_data.clear();

    GetCategoryTypeController bType = GetCategoryTypeController();
    constanst.cat_typedata = bType.setType();
    _isloading = true;
    constanst.cat_typedata!.then((value) {
      for (var item in value) {
        constanst.cat_type_data.add(item);
      }
      _isloading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return initwidget(context);
  }


  Widget initwidget(BuildContext context) {
    setState(() {
      if (constanst.cat_type_data.isEmpty) {
        _isloading = true;
      }
      for (int i = 0; i < constanst.cat_type_data.length; i++) {
        constanst.Type_itemsCheck1.add(Icons.circle_outlined);
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            top: true,
            left: true,
            right: true,
            maintainBottomViewPadding: true,
            child: SizedBox(
                // height: MediaQuery.of(context).size.height,

                width: MediaQuery.of(context).size.width,
                child: Column(children: [
                  _isloading == true
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
                                  : Container())
                      : Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: Image.asset('assets/back.png',
                                      height: 50, width: 60),
                                  onTap: () {
                                    /* Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => MainScreen(0)),
                              ModalRoute.withName('/'));*/
                                    Navigator.pop(context);
                                  },
                                ),
                                Center(
                                    child: Text(
                                  'Type',
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
                                        if (constanst.select_typeId.isEmpty) {
                                          Fluttertoast.showToast(
                                              msg: 'Select Minimum 1 Type');
                                        } else {
                                          _onLoading();
                                          setType().then((value) {
                                            Navigator.of(dialogContext!).pop();
                                            if (value) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Grade()));
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Grade()));
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
                                'Select Your Type',
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
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: constanst.cat_type_data.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                type.Result record =
                                    constanst.cat_type_data[index];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      category3 = true;
                                      if (constanst.Type_itemsCheck1[index] ==
                                          Icons.circle_outlined) {
                                        constanst.Type_itemsCheck1[index] =
                                            Icons.check_circle_outline;
                                        type_id =
                                            record.producttypeId.toString();
                                        constanst.select_typeId.add(type_id);
                                        setState(() {});
                                      } else {
                                        constanst.Type_itemsCheck1[index] =
                                            Icons.circle_outlined;
                                        type_id ==
                                            record.producttypeId.toString();
                                        constanst.select_typeId.remove(type_id);
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        margin: const EdgeInsets.fromLTRB(
                                            25.0, 10.0, 25.0, 5.0),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    category3 = true;
                                                    if (constanst
                                                                .Type_itemsCheck1[
                                                            index] ==
                                                        Icons.circle_outlined) {
                                                      constanst.Type_itemsCheck1[
                                                              index] =
                                                          Icons
                                                              .check_circle_outline;
                                                       type_id = record
                                                           .producttypeId
                                                          .toString();
                                                      constanst.select_typeId
                                                          .add(type_id);
                                                    } else {
                                                      constanst.Type_itemsCheck1[
                                                              index] =
                                                          Icons.circle_outlined;
                                                      type_id = record
                                                          .producttypeId
                                                          .toString();
                                                      constanst.select_typeId
                                                          .remove(type_id);
                                                    }
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      child: IconButton(
                                                        icon: constanst.Type_itemsCheck1[
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
                                                        onPressed: () {
                                                          setState(() {
                                                            category3 = true;
                                                            if (constanst
                                                                        .Type_itemsCheck1[
                                                                    index] ==
                                                                Icons
                                                                    .circle_outlined) {
                                                              constanst.Type_itemsCheck1[
                                                                      index] =
                                                                  Icons
                                                                      .check_circle_outline;
                                                              type_id = record
                                                                  .producttypeId
                                                                  .toString();
                                                              constanst
                                                                  .select_typeId
                                                                  .add(type_id);
                                                            } else {
                                                              constanst.Type_itemsCheck1[
                                                                      index] =
                                                                  Icons
                                                                      .circle_outlined;
                                                              type_id = record
                                                                  .producttypeId
                                                                  .toString();
                                                              constanst
                                                                  .select_typeId
                                                                  .remove(
                                                                      type_id);
                                                            }
                                                          });
                                                        },
                                                      ),

                                                    ),
                                                    Text(
                                                        record.productType
                                                            .toString(),
                                                        style: const TextStyle(
                                                                fontSize: 13.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'assets/fonst/Metropolis-Black.otf')
                                                            .copyWith(
                                                                fontSize: 17))
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
                                  if (constanst.select_typeId.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: 'Select Minimum 1 Type');
                                  } else {
                                    _onLoading();
                                    setType().then((value) {
                                      Navigator.of(dialogContext!).pop();
                                      if (value) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => const Grade()));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => const Grade()));
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
                        ]),
                ])),
          )),
    );
  }

  /* @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    constanst.Type_itemsCheck1.clear();
  }*/
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
  }

  Future<bool> setType() async {
    var Stringtype = constanst.select_typeId.join(",");
    SharedPreferences pref = await SharedPreferences.getInstance();
    constanst.step = 8;
    var res = await addtype(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        Stringtype.trim(),
        constanst.step.toString());


    if (res['status'] == 1) {
      _isloading1 = true;
      Fluttertoast.showToast(msg: res['message']);
      constanst.istype = false;
    } else {
      _isloading1 = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    return _isloading1;
  }

  checknetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      _isloading = false;
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      get_data();
    }
  }
}
