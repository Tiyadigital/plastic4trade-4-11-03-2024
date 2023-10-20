// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:io';

import 'package:Plastic4trade/constroller/GetCategoryTypeController.dart';
import 'package:Plastic4trade/model/GetCategoryType.dart' as type;
import 'package:Plastic4trade/utill/constant.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';
import 'GradeUpdate.dart';

class Type_update extends StatefulWidget {
  const Type_update({Key? key}) : super(key: key);

  @override
  State<Type_update> createState() => _Type_updateState();
}

class _Type_updateState extends State<Type_update> {
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
    //
  }

  getProfiless() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getbussinessprofile(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );

    if (res['status'] == 1) {
      constanst.select_type_id = res['user']['type_id'];

      constanst.select_typeId = constanst.select_type_id.split(",");
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {});
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
        constanst.itemsCheck.add(Icons.circle_outlined);
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
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
                                : Container())
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
                                  'Update Type',
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
                                      color: const Color.fromARGB(
                                          255, 0, 91, 148)),
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
                                                          const Grade_update()));
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Grade_update(),
                                                ),
                                              );
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
                            padding:
                                const EdgeInsets.fromLTRB(27.0, 5.0, 5.0, 5.0),
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
                                      constanst.select_type_idx = index;
                                      constanst.select_type_idx = index;
                                      if (!constanst.select_typeId.contains(
                                          record.producttypeId.toString())) {
                                        constanst.itemsCheck[index] =
                                            Icons.check_circle_outline;
                                        constanst.select_typeId.add(
                                            record.producttypeId.toString());
                                        constanst.select_type_id =
                                            constanst.select_typeId.join(",");
                                        setState(() {});
                                      } else {
                                        constanst.itemsCheck[index] =
                                            Icons.check_circle_outline;
                                        constanst.select_typeId.remove(
                                            record.producttypeId.toString());
                                        constanst.select_type_id =
                                            constanst.select_typeId.join(",");
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
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0))),
                                              margin: const EdgeInsets.fromLTRB(
                                                  25.0, 10.0, 25.0, 5.0),
                                              child: Column(children: [
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Row(children: [
                                                    GestureDetector(
                                                        child: IconButton(
                                                      icon: constanst
                                                              .select_typeId
                                                              .contains(record
                                                                  .producttypeId
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
                                                                  .select_type_idx =
                                                              index;
                                                          constanst
                                                                  .select_type_idx =
                                                              index;
                                                          if (!constanst
                                                              .select_typeId
                                                              .contains(record
                                                                  .producttypeId
                                                                  .toString())) {
                                                            constanst.itemsCheck[
                                                                    index] =
                                                                Icons
                                                                    .check_circle_outline;

                                                            constanst
                                                                .select_typeId
                                                                .add(record
                                                                    .producttypeId
                                                                    .toString());
                                                            constanst
                                                                    .select_type_id =
                                                                constanst
                                                                    .select_typeId
                                                                    .join(",");

                                                            setState(() {});
                                                          } else {
                                                            constanst.itemsCheck[
                                                                    index] =
                                                                Icons
                                                                    .check_circle_outline;

                                                            constanst
                                                                .select_typeId
                                                                .remove(record
                                                                    .producttypeId
                                                                    .toString());

                                                            constanst
                                                                    .select_type_id =
                                                                constanst
                                                                    .select_typeId
                                                                    .join(",");

                                                            setState(() {});
                                                          }
                                                        });
                                                      },
                                                    )),
                                                    Text(
                                                        record.productType
                                                            .toString(),
                                                        style: const TextStyle(
                                                                fontSize: 13.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'assets/fonst/Metropolis-Black.otf',
                                                                color: Colors
                                                                    .black)
                                                            .copyWith(
                                                                fontSize: 17))
                                                  ]),
                                                ),
                                              ])))),
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
                                setState(
                                  () {
                                    if (constanst.select_typeId.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: 'Select Minimum 1 Type');
                                    } else {
                                      _onLoading();
                                      setType().then(
                                        (value) {
                                          Navigator.of(dialogContext!).pop();
                                          if (value) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Grade_update()));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Grade_update()));
                                          }
                                        },
                                      );
                                    }
                                  },
                                );
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
            ));
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    constanst.itemsCheck.clear();
  }

  Future<bool> setType() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await addProducttype(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        constanst.select_type_id.trim(),
        '7');

    String? msg = res['message'];
    Fluttertoast.showToast(msg: "$msg");
    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);
      clear_data();
      _isloading1 = true;
    } else {
      _isloading1 = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return _isloading1;
  }

  checknetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      constanst.catdata.clear();
      _isloading = false;
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      clear_data();
      getProfiless();
      get_data();
    }
  }

  clear_data() {
    constanst.select_typeId.clear();
    constanst.select_type_id = "";
    constanst.select_type_idx = 0;
    constanst.itemsCheck.clear();
    constanst.cat_type_data.clear();
  }
}
