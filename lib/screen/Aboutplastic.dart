// ignore_for_file: unused_local_variable, import_of_legacy_library_into_null_safe, prefer_typing_uninitialized_variables, non_constant_identifier_names, camel_case_types

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' show Platform;

import '../api/api_interface.dart';

class aboutplastic extends StatefulWidget {
  const aboutplastic({Key? key}) : super(key: key);

  @override
  State<aboutplastic> createState() => _aboutplasticState();
}

class _aboutplasticState extends State<aboutplastic> {
  bool? load;

  String? link;
  String? linkForIos;

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
          timeInSecForIosWeb: 2, msg: 'Internet Connection not available');
    } else {
      get_aboutus();
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
    return Scaffold(
        backgroundColor: const Color(0xFFDADADA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: const Text('About Us',
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
            child: const Icon(
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
                        height: 110,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        padding: const EdgeInsets.all(10),
                        margin:
                            const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
                        child: Image.asset(
                          'assets/plastic4trade logo final.png',
                        )),
                    Container(
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.05),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x3FA6A6A6),
                              blurRadius: 16.32,
                              offset: Offset(0, 3.26),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        margin:
                            const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        child: Html(
                          data: Platform.isIOS ? linkForIos : link,
                          style: {
                            "p": Style(
                              //fontSize: FontSize(12),
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.24,
                              fontFamily: 'Metropolis',
                            ),
                            "body": Style(
                              //fontSize: FontSize(12),
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.24,
                              fontFamily: 'Metropolis',
                            ),
                          },
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
                            : Container())));
  }

  Future<void> get_aboutus() async {
    var res = await getStaticPage();
    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];
        link = jsonArray['staticDescription'];
        if (Platform.isIOS) {
          linkForIos = jsonArray['description_for_ios'];
        }
        load = true;
        if (mounted) {
          setState(() {});
        }
      } else {
        load = true;
      }
    } else {
      Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: res['message']);
    }
    return jsonArray;
  }
}



// for testing