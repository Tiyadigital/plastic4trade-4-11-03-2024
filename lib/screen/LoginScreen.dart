import 'package:android_id/android_id.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/screen/CategoryScreen.dart';
import 'package:Plastic4trade/screen/ForgetPassword.dart';
import 'package:Plastic4trade/screen/HomePage.dart';
import 'package:Plastic4trade/screen/Register2.dart';
import 'package:Plastic4trade/widget/MainScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/firebase_api.dart';
import '../utill/constant.dart';
import '../api/api_interface.dart';
import '../model/Login.dart';
import '../widget/shared_value_helper.dart';
import 'RegisterScreen.dart';
import 'dart:io' show Platform;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernm = TextEditingController();
  TextEditingController _userpass = TextEditingController();
  Color _color2 = Colors.black26;
  Color _color3 = Colors.black26;
  bool _passwordVisible = false;
  String device_name = '';
  var _formKey = GlobalKey<FormState>();
  String notificationMessge = 'Notification Waiting ';
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Login login = Login();
  bool _isloading=false;
  BuildContext? dialogContext;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    if(kIsWeb) {
      await Firebase.initializeApp(
          name: 'Plastic4Trade',
          options: const FirebaseOptions(
              apiKey: "AIzaSyCTqG3cUX04ACxu1U4tRhfTrI_odai_ZPY",
              appId: "1:929685037367:web:9b8d8a76c75d902292fab2",
              messagingSenderId: "929685037367",
              projectId: "plastic4trade-55372")
      );
    }else{
      if(Platform.isAndroid) {
        await Firebase.initializeApp(

          /* name: 'plastic4Trade',
          options: FirebaseOptions(
          apiKey: "AIzaSyCTqG3cUX04ACxu1U4tRhfTrI_odai_ZPY",
          appId: "1:929685037367:android:4ee71ab0f0e0608492fab2",
          messagingSenderId: "929685037367",
          projectId: "plastic4trade-55372",
          databaseURL: "https://plastic4trade-55372-default-rtdb.firebaseio.com")*/);
      } else if(Platform.isIOS){
        await Firebase.initializeApp(

          /*options: FirebaseOptions(
          apiKey: "AIzaSyCTqG3cUX04ACxu1U4tRhfTrI_odai_ZPY",
          appId: "1:929685037367:ios:2ff9d0954f9bc0e292fab2",
          messagingSenderId: "929685037367",
          projectId: "plastic4trade-55372",
          databaseURL: "https://plastic4trade-55372-default-rtdb.firebaseio.com")*/);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      // Android-specific code
      device_name = 'android';
    } else if (Platform.isIOS) {
      device_name = 'ios';
    }init(context);
    return initwidget();
  }
  Future<bool> _onbackpress(BuildContext context) async {

    SystemNavigator.pop(); // Close the app
    return Future.value(true);
  }
  Widget initwidget() {

    return  WillPopScope(
        onWillPop: () => _onbackpress(context),
    child: Scaffold(
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
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
                                    width:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.7,
                                    height: 170,
                                  )),
                              const SizedBox(
                                height: 40.0,
                                child: Text(
                                  'Hello Again!',
                                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700, color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf')
                                  // style: TextStyle(
                                  //   fontSize: 26.0,
                                  //   color: Colors.black,
                                  //   fontWeight: FontWeight.bold,
                                  //   fontFamily: 'Metropolis',
                                  // ),
                                ),
                              ),
                              const SizedBox(
                                  height: 25.0,
                                  child: Text(
                                    'Log in into your account',
                                    style:TextStyle(fontSize: 21.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf',)
                                  )),
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 10.0),
                                child: TextFormField(
                                  controller: _usernm,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(fontSize: 15.0,  fontFamily: 'assets/fonst/Metropolis-Black.otf',color:  Color.fromARGB(255, 0, 91, 148)),
                                  decoration: InputDecoration(
                                    hintText: "Enter Your Email/Mobile ",
                                    hintStyle:
                                    const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: _color2),
                                        borderRadius:
                                        BorderRadius.circular(10.0)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: _color2),
                                        borderRadius:
                                        BorderRadius.circular(10.0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: _color2),
                                        borderRadius:
                                        BorderRadius.circular(10.0)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                     /* Fluttertoast.showToast(
                                          msg:
                                          'Enter a Mobile Number or Email Id !');*/
                                      //return '';
                                    } else {
                                      // setState(() {
                                      _color2 = Colors.green.shade600;
                                      //});
                                    }

                                    return null;
                                  },
                                  onFieldSubmitted: (value) {
                                    if (value.isEmpty) {
                                      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                      Fluttertoast.showToast(
                                          msg:
                                          'Please Enter Your Number or Email');
                                      _color2 = Colors.red;
                                    } else {
                                      // setState(() {
                                      _color2 = Colors.green.shade600;
                                      //});
                                    }
                                  },
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                      Fluttertoast.showToast(
                                          msg:
                                          'Please Enter Your Number or Email');
                                      setState(() {
                                        _color2 = Colors.red;
                                      });
                                    } else {
                                      setState(() {
                                        _color2 = Colors.green.shade600;
                                      });
                                    }
                                  },
                                  //errorText: _validusernm ? 'Name is not empty' : null),
                                ),
                              ),
                              Padding(
                                padding:
                                EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                                child: TextFormField(
                                  controller: _userpass,
                                  obscureText: !_passwordVisible,
                                  style:const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    hintText: "Enter Your Password ",
                                    hintStyle:
                                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                                    //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    suffixIcon: IconButton(
                                      icon:
                                      // Based on passwordVisible state choose the icon
                                      _passwordVisible
                                          ? Image.asset(
                                          'assets/hidepassword.png')
                                          : Image.asset(
                                        'assets/Vector.png',
                                        width: 20.0,
                                        height: 20.0,
                                      ),
                                      color: Theme
                                          .of(context)
                                          .primaryColorDark,
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: _color3),
                                        borderRadius:
                                        BorderRadius.circular(10.0)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: _color3),
                                        borderRadius:
                                        BorderRadius.circular(10.0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: _color3),
                                        borderRadius:
                                        BorderRadius.circular(10.0)),
                                    //errorText: _validusernm ? 'Name is not empty' : null),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      /*Fluttertoast.showToast(
                                          msg: 'Enter a Password!');*/
                                      //return '';
                                    }
                                  },
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      _color3 = Colors.red;
                                      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
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
                                      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
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
                                    // var numValue = value.length;
                                    // if (numValue < 6) {
                                    //   WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                    //   Fluttertoast.showToast(
                                    //       msg: 'Password must be 6 charecter');
                                    //   _color3 = Colors.red;
                                    // } else {
                                    //   _color3 = Colors.green.shade600;
                                    // }
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
                                                  ForgetPasswprd()));
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(fontSize: 15.0,  fontFamily: 'assets/fonst/Metropolis-Black.otf',color:  Color.fromARGB(255, 0, 91, 148)),
                                    )),
                              ),
                              Container(
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.9,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Color.fromARGB(255, 0, 91, 148)),
                                  child: TextButton(
                                      onPressed: () async {
                                        final connectivityResult = await Connectivity().checkConnectivity();
                                        if (connectivityResult ==
                                            ConnectivityResult.none) {
                                          //this.getData();
                                          Fluttertoast.showToast(
                                              msg:
                                              'Net Connection not available');
                                        } else {
                                          if (_formKey.currentState!
                                              .validate()) {

                                          }
                                          setState(() {
                                            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                            vaild_data();
                                          });
                                        }
                                      },
                                      child: Text(
                                        'Login',
                                        style: TextStyle(fontSize: 15.0, color: Colors.white ,fontFamily: 'assets/fonst/Metropolis-Black.otf',),
                                      ))),
                              Container(
                                // margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 25.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    Text(
                                      'Don' r"'" 't have an account?',
                                      style:
                                      TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Register()));
                                      },
                                      child: Text('Create an account',
                                          style:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color:  Color.fromARGB(255, 0, 91, 148),fontFamily: 'assets/fonst/Metropolis-Black.otf')),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Image.asset(
                                'assets/image 2.png',
                              ),
                            ))
                      ],
                    ))))));
  }
  Future<void> init(BuildContext context) async {

    await FirebaseApi().initNOtification(context);

    // APIs.getSelfInfo();
  }



  setlogin() async {

    print(_usernm.text.toString());
    print(_userpass.text.toString());
    /*_onLoading();*/
    var res = await login_user(
        device_name, _usernm.text.toString(), _userpass.text.toString());
    //var jsonResponse = json.decode(res);
    //print(jsonResponse);
    if (res['status'] == 1) {
      login = Login.fromJson(res);
      Fluttertoast.showToast(msg: res['message']);


      /* if (login.data!.image_url != null) {
        _pref.setString('image', login.data!.image_url.toString());
      } else {
        _pref.setString('image', '');
      }*/
      //userid.$ = _pref.getString('user_id')!;
      constanst.api_token = login.result!.userToken.toString();
      constanst.userid = login.result!.userid.toString();
      constanst.step = login.result!.stepCounter!;
      constanst.image_url= login.result!.userImage.toString();
      init(context);

      if (Platform.isAndroid) {
        // Android-specific code
        //print('device id $deviceId');
        //if(constanst.fcm_token!=null || constanst.fcm_token.isEmpty) {
        const androidId = AndroidId();
        constanst.android_device_id = (await androidId.getId())!;

        print('android device');
        print(constanst.android_device_id);
        add_android_device();


        // }
      } else if (Platform.isIOS) {
      //  if (constanst.APNSToken != null || constanst.fcm_token.isEmpty) {
        print('ios device');
          final iosinfo = await deviceInfo.iosInfo;
          constanst.devicename =iosinfo.name!;
          constanst.ios_device_id = iosinfo.identifierForVendor!;
          print('ios device_id ${constanst.ios_device_id}');
          add_ios_device();
      }

    } else {
      _isloading=true;
      Fluttertoast.showToast(msg: res['message']);
    }
  }

  Future<bool>  add_android_device() async {
    Login login1 = Login();

    /*_onLoading();*/
    var res = await androidDevice_Register(
        _usernm.text.toString());
    print('Inside Api ');
    if (res['status'] == 1) {
      constanst.usernm=_usernm.text.toString();
      login1 = Login.fromJson(res);
      SharedPreferences _pref = await SharedPreferences.getInstance();
      _pref.setString('user_id', login.result!.userid.toString());
      _pref.setString('name', login.result!.userName.toString());
      _pref.setString('email', login.result!.email.toString());
      _pref.setString('phone', login.result!.phoneno.toString());
      _pref.setString('api_token', login.result!.userToken.toString());
      _pref.setString('step', login.result!.stepCounter.toString());
      _pref.setString('userImage', login.result!.userImage.toString());
      _pref.setBool('islogin', true);
      _isloading=true;
      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(0)));*/
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MainScreen(0)),
          ModalRoute.withName('/'));
      //Fluttertoast.showToast(msg: res['message']);
    } else {
      _isloading=false;
    //  Fluttertoast.showToast(msg: res['message']);
    }
    return _isloading;
  }

  Future<bool>  add_ios_device() async {
    Login login1 = Login();

    /*_onLoading();*/
    var res = await iosDevice_Register();

    if (res['status'] == 1) {
      login1 = Login.fromJson(res);
      constanst.usernm=_usernm.text.toString();
      //Fluttertoast.showToast(msg: res['message']);
      SharedPreferences _pref = await SharedPreferences.getInstance();
      _pref.setString('user_id', login.result!.userid.toString());
      _pref.setString('name', login.result!.userName.toString());
      _pref.setString('email', login.result!.email.toString());
      _pref.setString('phone', login.result!.phoneno.toString());
      _pref.setString('api_token', login.result!.userToken.toString());
      _pref.setString('step', login.result!.stepCounter.toString());
      constanst.step=login.result!.stepCounter!;
      _pref.setString('userImage', login.result!.userImage.toString());
      _pref.setBool('islogin', true);
      _isloading=true;
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen(0)));
    } else {
      _isloading=false;
     // Fluttertoast.showToast(msg: res['message']);
    }
    return _isloading;
  }

  vaild_data() {
    var numValue = _userpass.text.length;

    if (_usernm.text.isNotEmpty && _userpass.text.isNotEmpty) {
      _onLoading();
      setlogin().then((value) {
        Navigator.of(dialogContext!).pop();
        if (value!) {
          _isloading = false;
        } else {
          _isloading = false;
        }
      });
    } else if (_usernm.text.isEmpty && _userpass.text.isEmpty) {
      _color2 = Colors.red;
      _color3 = Colors.red;
      _isloading=true;
      setState(() {

      });
    }
    if (_usernm.text.isEmpty) {
      _color2 = Colors.red;
      setState(() {
        Fluttertoast.showToast(msg: 'Please Enter Your Email or Mobile');
        //_isloading=true;
      });
    } else if (_userpass.text.isEmpty) {
      _color3 = Colors.red;
      //_isloading=true;
      setState(() {
        Fluttertoast.showToast(msg: 'Please Enter Your Password');
      });
    } else if (_userpass.text.isNotEmpty) {
      // if (numValue < 6) {
      //   Fluttertoast.showToast(msg: 'Your Password Require Minimum 6 Character ');
      //   _color3 = Colors.red;
      //   //_isloading=true;
      // }
      //_isloading=true;
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

}
