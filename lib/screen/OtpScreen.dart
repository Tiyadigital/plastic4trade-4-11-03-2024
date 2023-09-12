import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/screen/ResetPassword.dart';
import 'dart:io' show Platform;
import '../api/api_interface.dart';
import '../model/common.dart';
import 'homepage.dart';

class otp extends StatefulWidget {
  late String phone, countrycode, email;
  String? myotp;
  otp(
      {Key? key,
      required this.phone,
      required this.countrycode,
      required this.email})
      : super(key: key);
  @override
  State<otp> createState() =>
      _otpState(phone1: phone, countrycode1: countrycode, email1: email);
}

class _otpState extends State<otp> {
  String? phone1, countrycode1, email1;

  final TextEditingController _onefield = TextEditingController();
  final TextEditingController _twofield = TextEditingController();
  final TextEditingController _threefield = TextEditingController();
  final TextEditingController _fourfield = TextEditingController();
  BuildContext? dialogContext;
  bool isloading = false;

  _otpState(
      {Key? key, required phone1, required countrycode1, required email1});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
                top: true,
                left: true,
                right: true,
                bottom: true,
                child: SingleChildScrollView(
                    child: Container(
                        child: Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            child: Image.asset('assets/back.png',
                                height: 50, width: 60),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Container(
                        //height: MediaQuery.of(context).size.height,
                        margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Image.asset('assets/Otpverification.png',
                                  alignment: Alignment.topCenter,
                                  height: 150,
                                  width: 100),
                            ),
                            Column(children: [
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 20.0, 0, 20.0),
                                  child: Text('OTP Verification',
                                      style: TextStyle(
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets\fonst\Metropolis-Black.otf'))),
                              widget.email.isEmpty
                                  ? SizedBox(
                                      height: 20.0,
                                      width: MediaQuery.of(context).size.width /
                                          1.15,
                                      child: Text(
                                          'Enter OTP Sent To ${widget.countrycode}${widget.phone}',
                                          maxLines: 2,
                                          style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets\fonst\Metropolis-Black.otf')
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 17)),
                                    )
                                  : Container(
                                      //height: 20.0,
                                      //width: MediaQuery.of(context).size.width / 1.15,
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                          'Enter OTP Sent To ' + widget.email,
                                          maxLines: 2,
                                          style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets\fonst\Metropolis-Black.otf')
                                              ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          textAlign: TextAlign.center),
                                    ),

                              SizedBox(
                                height: 30,
                              )
                              //alignment: Alignment.center,

                              /*  SizedBox(
                                height: 30.0,
                                width: MediaQuery.of(context).size.width / 1.95,
                                child: Text('and jack@gmail.com',
                                    //maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(fontWeight: FontWeight.w400,fontSize: 17)),
                              ),*/
                            ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OtpInput(_onefield, true),
                                OtpInput(_twofield, false),
                                OtpInput(_threefield, true),
                                OtpInput(_fourfield, false),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Did’t Received the OTP?',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf')),
                                Container(
                                  //margin: EdgeInsets.fromLTRB(250.0, 0.0, 0.0, 0.0),
                                  child: TextButton(
                                    child: Text(
                                      'Resend Otp ',
                                    ),
                                    onPressed: () {
                                      //resendotp();
                                      _onLoading();
                                      get_otp(widget.phone, widget.countrycode,
                                          widget.email).then((value) {
                                            if(value){

                                            }else{

                                            }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Color.fromARGB(255, 0, 91, 148)),
                              child: TextButton(
                                onPressed: () {
                                  WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                  widget.myotp = _onefield.text.toString() +
                                      _twofield.text.toString() +
                                      _threefield.text.toString() +
                                      _fourfield.text.toString();
                                  _onLoading();
                                  verify_otp(
                                          widget.myotp.toString(),
                                          widget.phone,
                                          widget.countrycode,
                                          widget.email)
                                      .then((value) {
                                    Navigator.of(dialogContext!).pop();
                                    if (value) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ResetPassword(
                                                    country_code:
                                                        widget.countrycode,
                                                    phone: widget.phone,
                                                    email: widget.email,
                                                  )));
                                    } else {}
                                  });
                                },
                                child: Text('Submit',
                                    style: TextStyle(
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]))))));
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

  Future<bool> get_otp(phone, conutry_code, email) async {
    common_par login = common_par();

    var res = await forgotpassword_ME(phone, conutry_code, email);
    //String? msg = res['message'];
    //Fluttertoast.showToast(msg: "$msg");
    if (res['status'] == 1) {
      login = common_par.fromJson(res);
      isloading=true;
      Fluttertoast.showToast(msg: res['message']);

      /* if (login.data!.image_url != null) {
        _pref.setString('image', login.data!.image_url.toString());
      } else {
        _pref.setString('image', '');
      }*/

      // verify = res['data']['mbl_verified'];
      // print(login.data!.mblVerified.toString());
      /* if (login.data!.mblVerified == "1") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Homepage()));
      } else {
        otpvalue = login.otp.toString();
        Fluttertoast.showToast(msg: "$otpvalue");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => otp(name: otpvalue)));
      }*/
    } else {
      isloading=false;
      Fluttertoast.showToast(msg: res['message']);
    }
    return isloading;
  }

  Future<bool> verify_otp(myotp, phone, conutry_code, email) async {
    common_par login = common_par();

    var res = await verifyforgototp(myotp, phone, conutry_code, email);
    String? msg = res['message'];
   // Fluttertoast.showToast(msg: "$msg");
    if (res['status'] == 1) {
      login = common_par.fromJson(res);

      Fluttertoast.showToast(msg: res['message']);
      isloading = true;
    } else {
      isloading = false;
      Fluttertoast.showToast(msg: res['message']);
    }
    return isloading;
  }
  // void verifyotp() async {
  //   print(constanst.api_token);
  //
  //   VerifyOtp verifyOtp = VerifyOtp();
  //   var res = await verify_otp(constanst.api_token);
  //   print("mannnnnn  $res");
  //   var msg = res['message'];
  //   Fluttertoast.showToast(msg: "$msg");
  //
  //   if (res['result'] == "1") {
  //     verifyOtp = VerifyOtp.fromJson(res);
  //   } else {
  //     //String alert = isReturningCustomer ? 'Welcome back to our site!' : 'Welcome, please sign up.';
  //     if (msg.isNotEmpty) {
  //       Fluttertoast.showToast(msg: "$msg");
  //     } else {
  //       Fluttertoast.showToast(msg: "Something Wrong");
  //     }
  //   }
  // }
}

// resendotp() async {
//   ResendOtp resendOtp = ResendOtp();
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   String mbl = pref.getString('mbl').toString();
//   resendOtp = await resend_otp(mbl);
//   var msg = resendOtp.message;
//   String otp1 = resendOtp.otp.toString();
//   constanst.otp = otp1;
//   print(constanst.otp);
//   print(" hello 123 $constanst.api_token");
//   Fluttertoast.showToast(msg: " $msg");
//   Fluttertoast.showToast(msg: " $otp1");
//   print(resendOtp);
// }

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Colors.white,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
