// ignore_for_file: unused_local_variable, import_of_legacy_library_into_null_safe, prefer_typing_uninitialized_variables

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' show Platform;

import '../api/api_interface.dart';

class AppTermsCondition extends StatefulWidget {
  const AppTermsCondition({Key? key}) : super(key: key);

  @override
  State<AppTermsCondition> createState() => _AppTermsConditionState();
}

class _AppTermsConditionState extends State<AppTermsCondition> {
  bool? load;

  String? link;

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'Internet Connection not available');

    } else {
      getTermsCondition();

    }
  }

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
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: const Text('Terms & Condition',
              softWrap: false,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontFamily: 'Metropolis',
              )),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: load == true
                ? Column(children: [
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
                  height: 150,
                  child: Image.asset(
                    'assets/plastic4trade logo final.png',
                  )),
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Align(child: Html(data: link)),
                      )
                    ],
                  )),
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
                    : Container())
        ));
  }

  Future<void> getTermsCondition() async {

    var res = await getAppTermsCondition();

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];


        link = jsonArray['staticDescription'];

        load = true;

        if (mounted) {
          setState(() {});
        }
      } else {
        load = true;
      }
    } else {
      Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: res['message']);
    }
    return jsonArray;
  }
}
