import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
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

  TextEditingController otpController = TextEditingController();

  var otp = "";
  var enteredOTP = "";
  bool otpError = false;

  BuildContext? dialogContext;
  bool isloading = false;
  var _formKey = GlobalKey<FormState>();

  _otpState(
      {Key? key, required phone1, required countrycode1, required email1});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
                top: true,
                left: true,
                right: true,
                bottom: true,
                child: SingleChildScrollView(
                    child: Form(
                  key: _formKey,
                  child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            child: Image.asset('assets/back.png',
                                height: 50, width: 60),
                            onTap: () {
                              Navigator.pop(context);
                            },
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
                                const Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
                                    child: Text('OTP Verification',
                                        style: TextStyle(
                                            fontSize: 26.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets\fonst\Metropolis-Black.otf'))),
                                widget.email.isEmpty
                                    ? Container(
                                        height: 20.0,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.15,
                                  alignment: Alignment.center,
                                        child: Text(
                                            'Enter OTP Sent To ${widget.countrycode}${widget.phone}',
                                            maxLines: 2,
                                            style: const TextStyle(
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
                                  alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Text(
                                            'Enter OTP Sent To ${widget.email}',
                                            maxLines: 2,
                                            style: const TextStyle(
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

                                const SizedBox(
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
                              OtpTextField(

                                enabledBorderColor:
                                    otpError ? Colors.red : Colors.black26,
                                onSubmit: (String verificationCode) {
                                  setState(() {
                                    enteredOTP = verificationCode;
                                  });
                                  log("VERIFICATION CODE == $verificationCode");
                                },
                                onCodeChanged: (code) {
                                  otp = code;
                                  setState(() {
                                    otpError = false; // Reset the error when the OTP field changes
                                  });
                                },
                                numberOfFields: 4,
                                fieldWidth: 50,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                cursorColor: Colors.black26,
                                borderRadius: BorderRadius.circular(20),
                                borderColor:
                                    otpError ? Colors.red : Colors.black26,
                                focusedBorderColor: Colors.blue,
                                showFieldAsBox: true,
                                textStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Did’t Received the OTP?',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets\fonst\Metropolis-Black.otf')),
                                  TextButton(
                                    child: const Text(
                                      'Resend Otp',
                                    ),
                                    onPressed: () {
                                      _onLoading();
                                      get_otp(widget.phone, widget.countrycode,
                                              widget.email)
                                          .then((value) {
                                        if (value) {
                                        } else {}
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(50.0),
                                    color:
                                        const Color.fromARGB(255, 0, 91, 148)),
                                child: TextButton(
                                  onPressed: () {
                                    log("ENTERED OTP LENGTH = ${otp.length}");
                                    log("ENTERED OTP = $otp");


                                    if (enteredOTP.isEmpty || enteredOTP.length < 4) {
                                      Fluttertoast.showToast(
                                          msg: 'Please Enter Your OTP');
                                      setState(() {
                                        otpError = true; // Set error to true if OTP is empty
                                      });
                                    } else {
                                      WidgetsBinding
                                          .instance?.focusManager.primaryFocus
                                          ?.unfocus();
                                      _onLoading();
                                      verify_otp(
                                              enteredOTP.toString(),
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

                                      // if (/* Your OTP validation logic */) {
                                      //   // OTP is valid, proceed with your logic
                                      // } else {
                                      //   setState(() {
                                      //     otpError = true; // Set error to true if OTP is invalid
                                      //   });
                                      // }
                                    }
                                  },
                                  child: const Text('Submit',
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
                      ]),
                )))));
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

    Future.delayed(const Duration(seconds: 3), () {
      print('exit');
      Navigator.of(dialogContext!)
          .pop(); // Use dialogContext to close the dialog
      print('exit1'); // Dialog closed
    });
  }

  Future<bool> get_otp(phone, conutry_code, email) async {
    common_par login = common_par();

    var res = await forgotpassword_ME(phone, conutry_code, email);
    //String? msg = res['message'];
    //Fluttertoast.showToast(msg: "$msg");
    if (res['status'] == 1) {
      login = common_par.fromJson(res);
      isloading = true;
      Fluttertoast.showToast(msg: res['message']);
    } else {
      isloading = false;
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
}
