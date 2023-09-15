import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' show Platform;

import '../api/api_interface.dart';
import '../model/getAbout_us.dart';

class aboutplastic extends StatefulWidget {
  const aboutplastic({Key? key}) : super(key: key);

  @override
  State<aboutplastic> createState() => _aboutplasticState();
}

class _aboutplasticState extends State<aboutplastic> {
  bool? load;

  String? link;

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      get_aboutus();
      // get_data();
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
        backgroundColor: Color(0xFFDADADA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text('About Us',
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
            physics: AlwaysScrollableScrollPhysics(),
            child: load == true
                ? Container(
                    //padding: EdgeInsets.only(bottom: 3.0),
                    child: Column(children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
                          height: 150,
                          child: Image.asset(
                            'assets/plastic4trade logo final.png',
                          )),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
                          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Align(child: Html(data: link)),
                              )
                            ],
                          )),
                    ]),
                  )
                : Center(
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
                            : Container())
        ));
  }

  Future<void> get_aboutus() async {
    getAbout_us getsimmilar = getAbout_us();

    var res = await getStaticPage();

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = getAbout_us.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];

        //
        // for (var data in jsonarray) {

        link = jsonarray['staticDescription'];

        /*videolist.add(link);
          videocontent.add(content);*/
        //loadmore = true;
        //}
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
    return jsonarray;
    setState(() {});
  }
}
