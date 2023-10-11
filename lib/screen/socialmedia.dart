// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:io' show Platform;

import 'package:Plastic4trade/screen/Bussinessinfo.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';

class socialmedia extends StatefulWidget {
  const socialmedia({Key? key}) : super(key: key);

  @override
  State<socialmedia> createState() => _socialmediaState();
}

class _socialmediaState extends State<socialmedia> {
  bool isprofile = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController instat = TextEditingController();
  TextEditingController facebook = TextEditingController();
  TextEditingController youtube = TextEditingController();
  TextEditingController twitter = TextEditingController();
  TextEditingController telegram = TextEditingController();
  TextEditingController linkdn = TextEditingController();
  BuildContext? dialogContext;
  bool _isloading1 = false;

  @override
  void initState() {
    // TODO: implement initState
    checknetowork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return initwidget();
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

  Widget initwidget() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFDADADA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text('Social Media URLs',
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
      body: isprofile
          ? SingleChildScrollView(
              child: Column(
              children: [
                Column(
                  children: [
                    Form(
                        key: _formKey,
                        child: SizedBox(
                            // height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Column(children: [
                              SafeArea(
                                top: true,
                                left: true,
                                right: true,
                                maintainBottomViewPadding: true,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          25.0, 20.0, 25.0, 5.0),
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.black26),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            //ImageIcon(Image.asset('assets/instagram.png') as ImageProvider<Object>?)

                                            SizedBox(
                                              height: 30,
                                              width: 50,
                                              child: Image.asset(
                                                'assets/instagram.png',
                                                height: 20,
                                                width: 25,
                                              ),
                                            ),

                                            Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 3.0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  115,
                                              child: TextFormField(
                                                controller: instat,
                                                style: const TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf'),
                                                keyboardType:
                                                    TextInputType.text,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  hintText:
                                                      "Copy & Paste Instagram URL",
                                                  hintStyle: const TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf')
                                                      .copyWith(
                                                          color:
                                                              Colors.black45),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 5.0),
                                        child: Container(
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(15)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                //ImageIcon(Image.asset('assets/instagram.png') as ImageProvider<Object>?)

                                                SizedBox(
                                                  height: 30,
                                                  width: 50,
                                                  child: Image.asset(
                                                    'assets/YouTube (1).png',
                                                    height: 20,
                                                    width: 15,
                                                  ),
                                                ),

                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 3.0),
                                                  //height: 58,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      115,
                                                  child: TextFormField(
                                                    // controller: _usernm,
                                                    controller: youtube,
                                                    style: const TextStyle(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf'),

                                                    keyboardType:
                                                        TextInputType.text,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: InputDecoration(
                                                      // labelText: 'Your phone *',
                                                      // labelStyle: TextStyle(color: Colors.red),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      hintText:
                                                          "Copy & Paste YouTube URL",
                                                      hintStyle: const TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets/fonst/Metropolis-Black.otf')
                                                          .copyWith(
                                                              color: Colors
                                                                  .black45),
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),),),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 5.0),
                                        child: Container(
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(15)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                //ImageIcon(Image.asset('assets/instagram.png') as ImageProvider<Object>?)

                                                SizedBox(
                                                  height: 30,
                                                  width: 50,
                                                  child: Image.asset(
                                                    'assets/Facebook (1).png',
                                                    height: 20,
                                                    width: 15,
                                                  ),
                                                ),

                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 3.0),
                                                  //height: 58,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      115,
                                                  child: TextFormField(
                                                    // controller: _usernm,
                                                    controller: facebook,
                                                    style: const TextStyle(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf'),

                                                    keyboardType:
                                                        TextInputType.text,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: InputDecoration(
                                                      // labelText: 'Your phone *',
                                                      // labelStyle: TextStyle(color: Colors.red),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      hintText:
                                                          "Copy & Paste Facebook URL",
                                                      hintStyle: const TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets/fonst/Metropolis-Black.otf')
                                                          .copyWith(
                                                              color: Colors
                                                                  .black45),
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),),),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 5.0),
                                        child: Container(
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(15)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                //ImageIcon(Image.asset('assets/instagram.png') as ImageProvider<Object>?)

                                                SizedBox(
                                                  height: 30,
                                                  width: 50,
                                                  child: Image.asset(
                                                    'assets/LinkedIn.png',
                                                    height: 20,
                                                    width: 25,
                                                  ),
                                                ),

                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 3.0),
                                                  //height: 58,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      115,
                                                  child: TextFormField(
                                                    // controller: _usernm,
                                                    controller: linkdn,
                                                    style: const TextStyle(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf'),

                                                    keyboardType:
                                                        TextInputType.text,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: InputDecoration(
                                                      // labelText: 'Your phone *',
                                                      // labelStyle: TextStyle(color: Colors.red),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      hintText:
                                                          "Copy & Paste LinkedIn URL",
                                                      hintStyle: const TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets/fonst/Metropolis-Black.otf')
                                                          .copyWith(
                                                              color: Colors
                                                                  .black45),
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),),),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 5.0),
                                        child: Container(
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(15)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                //ImageIcon(Image.asset('assets/instagram.png') as ImageProvider<Object>?)

                                                SizedBox(
                                                  height: 30,
                                                  width: 50,
                                                  child: Image.asset(
                                                    'assets/Twitter.png',
                                                    height: 20,
                                                    width: 25,
                                                  ),
                                                ),

                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 3.0),
                                                  //height: 58,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      115,
                                                  child: TextFormField(
                                                    // controller: _usernm,
                                                    controller: twitter,
                                                    style: const TextStyle(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf'),

                                                    keyboardType:
                                                        TextInputType.text,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: InputDecoration(
                                                      // labelText: 'Your phone *',
                                                      // labelStyle: TextStyle(color: Colors.red),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      hintText:
                                                          "Copy & Paste Twitter URL",
                                                      hintStyle: const TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets/fonst/Metropolis-Black.otf')
                                                          .copyWith(
                                                              color: Colors
                                                                  .black45),
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),),),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 5.0),
                                        child: Container(
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(15)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                //ImageIcon(Image.asset('assets/instagram.png') as ImageProvider<Object>?)

                                                SizedBox(
                                                  height: 30,
                                                  width: 50,
                                                  child: Image.asset(
                                                    'assets/Telegram.png',
                                                    height: 20,
                                                    width: 25,
                                                  ),
                                                ),

                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 3.0),
                                                  //height: 58,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      115,
                                                  child: TextFormField(
                                                    // controller: _usernm,
                                                    controller: telegram,
                                                    style: const TextStyle(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf'),

                                                    keyboardType:
                                                        TextInputType.text,
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: InputDecoration(
                                                      // labelText: 'Your phone *',
                                                      // labelStyle: TextStyle(color: Colors.red),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      hintText:
                                                          "Copy & Paste Telegram URL",
                                                      hintStyle: const TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets/fonst/Metropolis-Black.otf')
                                                          .copyWith(
                                                              color: Colors
                                                                  .black45),
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),),),
                                  ],
                                ),
                              )
                            ]),),)
                  ],
                ),
              ],
            ))
          : const Center(
              child: CircularProgressIndicator(
              color: Color.fromARGB(255, 0, 91, 148),
            )),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width * 1.2,
        height: 60,
        margin: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(50.0),
            color: const Color.fromARGB(255, 0, 91, 148)),
        child: TextButton(
          onPressed: () {
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
            _onLoading();
            add_SocialProfile().then((value) {
              Navigator.of(dialogContext!).pop();
              if (value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Bussinessinfo(),),);
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Bussinessinfo(),),);
              }
            });
            setState(() {});
          },
          child: const Text('Save & Update',
              style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontFamily: 'assets/fonst/Metropolis-Black.otf')),
        ),
      ),
    );
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      isprofile = true;
    } else {
      getProfiless();
    }
  }

  getProfiless() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getbussinessprofile(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );

    if (res['status'] == 1) {
      instat.text = res['profile']['instagram_link'];
      youtube.text = res['profile']['youtube_link'];
      facebook.text = res['profile']['facebook_link'];
      linkdn.text = res['profile']['linkedin_link'];
      twitter.text = res['profile']['twitter_link'];
      telegram.text = res['profile']['telegram_link'];
      isprofile = true;

      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(0),),);*/
    } else {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
      // Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {});
  }

  Future<bool> add_SocialProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await updatesocialmedia(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        instat.text.toString(),
        youtube.text.toString(),
        facebook.text.toString(),
        linkdn.text.toString(),
        twitter.text.toString(),
        telegram.text.toString());

    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);
      _isloading1 = true;
      /* Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(0),),);*/
    } else {
      _isloading1 = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    return _isloading1;
  }
}
