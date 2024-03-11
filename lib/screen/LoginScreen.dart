// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:io' show Platform;

import 'package:Plastic4trade/screen/ForgetPassword.dart';
import 'package:Plastic4trade/widget/MainScreen.dart';
import 'package:android_id/android_id.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';
import '../api/firebase_api.dart';
import '../model/Login.dart';
import '../utill/constant.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernm = TextEditingController();
  final TextEditingController _userpass = TextEditingController();
  Color _color2 = Colors.black26;
  Color _color3 = Colors.black26;
  bool _passwordVisible = false;
  String device_name = '';
  final _formKey = GlobalKey<FormState>();
  String notificationMessge = 'Notification Waiting ';
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Login login = Login();
  bool _isloading = false;
  BuildContext? dialogContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (kIsWeb) {
      await Firebase.initializeApp(
          name: 'Plastic4Trade',
          options: const FirebaseOptions(
              apiKey: "AIzaSyCTqG3cUX04ACxu1U4tRhfTrI_odai_ZPY",
              appId: "1:929685037367:web:9b8d8a76c75d902292fab2",
              messagingSenderId: "929685037367",
              projectId: "plastic4trade-55372"));
    }
    else {
      if (Platform.isAndroid) {
        await Firebase.initializeApp();
      }
      else if (Platform.isIOS) {
        await Firebase.initializeApp();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      device_name = 'android';
    } else if (Platform.isIOS) {
      device_name = 'ios';
    }
    init(context);
    return initwidget();
  }

  Future<bool> _onbackpress(BuildContext context) async {
    SystemNavigator.pop();
    return Future.value(true);
  }

  Widget initwidget() {
    return WillPopScope(
      onWillPop: () => _onbackpress(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
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
                        Align(
                            alignment: Alignment.topCenter,
                            child: Image.asset(
                              'assets/plastic4trade logo final.png',
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 170,
                            )),
                        const SizedBox(
                          height: 40.0,
                          child: Text('Hello Again!',
                              style: TextStyle(
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-Black.otf')),
                        ),
                        const SizedBox(
                            height: 25.0,
                            child: Text('Log in into your account',
                                style: TextStyle(
                                  fontSize: 21.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-Black.otf',
                                ))),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 10.0),
                          child: TextFormField(
                            controller: _usernm,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'assets/fonst/Metropolis-Black.otf',
                                color: Color.fromARGB(255, 0, 91, 148)),
                            decoration: InputDecoration(
                              hintText: "Enter Your Email/Mobile ",
                              hintStyle: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-Black.otf'),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: _color2),
                                  borderRadius: BorderRadius.circular(10.0)),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: _color2),
                                  borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: _color2),
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                              } else {
                                _color2 = Colors.green.shade600;
                              }

                              return null;
                            },
                            onFieldSubmitted: (value) {
                              if (value.isEmpty) {
                                WidgetsBinding
                                    .instance.focusManager.primaryFocus
                                    ?.unfocus();
                                Fluttertoast.showToast(
                                    msg: 'Please Enter Your Number or Email');
                                _color2 = Colors.red;
                              } else {
                                _color2 = Colors.green.shade600;
                              }
                            },
                            onChanged: (value) {
                              if (value.isEmpty) {
                                WidgetsBinding
                                    .instance.focusManager.primaryFocus
                                    ?.unfocus();
                                Fluttertoast.showToast(
                                    msg: 'Please Enter Your Number or Email');
                                setState(() {
                                  _color2 = Colors.red;
                                });
                              } else {
                                setState(() {
                                  _color2 = Colors.green.shade600;
                                });
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                          child: TextFormField(
                            controller: _userpass,
                            obscureText: !_passwordVisible,
                            style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily:
                                    'assets/fonst/Metropolis-Black.otf'),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: "Enter Your Password ",
                              hintStyle: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-Black.otf'),
                              suffixIcon: IconButton(
                                icon: _passwordVisible
                                    ? Image.asset('assets/hidepassword.png')
                                    : Image.asset(
                                        'assets/Vector.png',
                                        width: 20.0,
                                        height: 20.0,
                                      ),
                                color: Theme.of(context).primaryColorDark,
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: _color3),
                                  borderRadius: BorderRadius.circular(10.0)),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: _color3),
                                  borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: _color3),
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {}
                              return null;
                            },
                            onChanged: (value) {
                              if (value.isEmpty) {
                                _color3 = Colors.red;
                                WidgetsBinding
                                    .instance.focusManager.primaryFocus
                                    ?.unfocus();
                                Fluttertoast.showToast(
                                    msg: 'Please Enter Your Password');
                                setState(() {});
                              } else {
                                _color3 = Colors.green.shade600;
                                setState(() {});
                              }
                            },
                            onFieldSubmitted: (value) {
                              if (value.isEmpty) {
                                WidgetsBinding
                                    .instance.focusManager.primaryFocus
                                    ?.unfocus();
                                Fluttertoast.showToast(
                                    msg: 'Please Enter Your Password');
                                setState(() {
                                  _color3 = Colors.red;
                                });
                              } else {
                                setState(() {
                                  _color3 = Colors.green.shade600;
                                });
                              }
                            },
                          ),
                        ),
                        Center(
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgetPasswprd()));
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf',
                                    color: Color.fromARGB(255, 0, 91, 148)),
                              )),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(50.0),
                                color: const Color.fromARGB(255, 0, 91, 148)),
                            child: TextButton(
                                onPressed: () async {
                                  final connectivityResult =
                                      await Connectivity().checkConnectivity();
                                  if (connectivityResult ==
                                      ConnectivityResult.none) {
                                    Fluttertoast.showToast(
                                        msg: 'Net Connection not available');
                                  } else {
                                    if (_formKey.currentState!.validate()) {}
                                    setState(() {
                                      WidgetsBinding
                                          .instance.focusManager.primaryFocus
                                          ?.unfocus();
                                      vaild_data();
                                    });
                                  }
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf',
                                  ),
                                ))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don' r"'" 't have an account?',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-Black.otf'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Register()));
                              },
                              child: const Text('Create an account',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromARGB(255, 0, 91, 148),
                                      fontFamily:
                                          'assets/fonst/Metropolis-Black.otf')),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                 Align (
                     alignment: Alignment.bottomCenter,
                     child :(Platform.isAndroid) ? Container() : Center(
                    child: TextButton(
                        onPressed: () async{
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          constanst.isWithoutLogin = true;
                          pref.setBool('isWithoutLogin', true);
                          setState(() {});
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => MainScreen(0)));
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                              fontSize: 13.0,
                              fontFamily:
                              'assets/fonst/Metropolis-Black.otf',
                              color: Color.fromARGB(255, 0, 91, 148)),
                        )),
                  )),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        'assets/image 2.png',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> init(BuildContext context) async {
    await FirebaseApi().initNOtification(context);
  }

  setlogin() async {
    var res = await login_user(
        device_name, _usernm.text.toString(), _userpass.text.toString());

    if (res['status'] == 1) {
      login = Login.fromJson(res);
      Fluttertoast.showToast(msg: res['message']);
      SharedPreferences pref = await SharedPreferences.getInstance();
      constanst.isWithoutLogin = false;
      pref.setBool('isWithoutLogin', false);
      setState(() {});
      constanst.api_token = login.result!.userToken.toString();
      constanst.userid = login.result!.userid.toString();
      constanst.step = login.result!.stepCounter!;
      constanst.image_url = login.result!.userImage.toString();
      init(context);

      if (Platform.isAndroid) {
        const androidId = AndroidId();
        constanst.android_device_id = (await androidId.getId())!;

        add_android_device();
      } else if (Platform.isIOS) {
        final iosinfo = await deviceInfo.iosInfo;
        constanst.devicename = iosinfo.name;
        constanst.ios_device_id = iosinfo.identifierForVendor!;
        add_ios_device();
      }
    } else {
      _isloading = true;
      Fluttertoast.showToast(msg: res['message']);
    }
  }

  Future<bool> add_android_device() async {
    var res = await androidDevice_Register(_usernm.text.toString());
    if (res['status'] == 1) {
      constanst.usernm = _usernm.text.toString();
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('user_id', login.result!.userid.toString());
      pref.setString('name', login.result!.userName.toString());
      pref.setString('email', login.result!.email.toString());
      pref.setString('phone', login.result!.phoneno.toString());
      pref.setString('api_token', login.result!.userToken.toString());
      pref.setString('step', login.result!.stepCounter.toString());
      pref.setString('userImage', login.result!.userImage.toString());
      pref.setBool('islogin', true);
      _isloading = true;

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MainScreen(0)),
          ModalRoute.withName('/'));
    } else {
      _isloading = false;
    }
    return _isloading;
  }

  Future<bool> add_ios_device() async {
    var res = await iosDevice_Register();

    if (res['status'] == 1) {
      constanst.usernm = _usernm.text.toString();

      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('user_id', login.result!.userid.toString());
      pref.setString('name', login.result!.userName.toString());
      pref.setString('email', login.result!.email.toString());
      pref.setString('phone', login.result!.phoneno.toString());
      pref.setString('api_token', login.result!.userToken.toString());
      pref.setString('step', login.result!.stepCounter.toString());
      constanst.step = login.result!.stepCounter!;
      pref.setString('userImage', login.result!.userImage.toString());
      pref.setBool('islogin', true);
      _isloading = true;
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => MainScreen(0)),
          ModalRoute.withName('/')
      );
    } else {
      _isloading = false;
    }
    return _isloading;
  }

  vaild_data() {
    if (_usernm.text.isNotEmpty && _userpass.text.isNotEmpty) {
      _onLoading();
      setlogin().then((value) {
        Navigator.of(dialogContext!).pop();
        if(value != null ){
        if (value) {
          _isloading = false;
        } else {
          _isloading = false;
        }}
      });
    } else if (_usernm.text.isEmpty && _userpass.text.isEmpty) {
      _color2 = Colors.red;
      _color3 = Colors.red;
      _isloading = true;
      setState(() {});
    }

    if (_usernm.text.isEmpty) {
      _color2 = Colors.red;
      setState(() {
        Fluttertoast.showToast(msg: 'Please Enter Your Email or Mobile');
      });
    } else if (_userpass.text.isEmpty) {
      _color3 = Colors.red;
      setState(() {
        Fluttertoast.showToast(msg: 'Please Enter Your Password');
      });
    } else if (_userpass.text.isNotEmpty) {}
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
}
