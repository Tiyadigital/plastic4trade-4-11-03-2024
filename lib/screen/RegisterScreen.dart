// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, prefer_final_fields, depend_on_referenced_packages

import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:Plastic4trade/model/FinalRegister.dart';
import 'package:Plastic4trade/screen/LoginScreen.dart';
import 'package:Plastic4trade/screen/terms_condtion.dart';
import 'package:Plastic4trade/widget/MainScreen.dart';
import 'package:android_id/android_id.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';
import '../api/firebase_api.dart';
import '../model/RegisterUserPhoneno.dart';
import '../utill/constant.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool passenable = true;
  var check_value = false;
  final TextEditingController _usernm = TextEditingController();
  final TextEditingController _usermbl = TextEditingController();
  final TextEditingController _useremail = TextEditingController();
  final TextEditingController _userpass = TextEditingController();
  final TextEditingController _mbloto = TextEditingController();
  final TextEditingController _emailotp = TextEditingController();
  final TextEditingController _usercpass = TextEditingController();
  Color _color1 = Colors.black26;
  Color _color2 = Colors.black26;
  Color _color3 = Colors.black26;
  Color _color4 = Colors.black26;
  Color _color6 = Colors.black26;
  Color _color5 = Colors.black26;
  Color _color7 = Colors.black26;
  String device_name = '';
  FinalRegister register = FinalRegister();
  late SharedPreferences _pref;
  bool _isloading = false;
  bool isloading = false;
  BuildContext? dialogContext;
  final _formKey = GlobalKey<FormState>();
  bool _validusernm = false, _validemail = false;
  bool _passwordVisible = false;
  bool _cpasswordVisible = false;
  bool _isValid = false;
  String initialCountry = 'IN';
  String country_code = '+91';
  int verify_phone = 0;
  int mbl_otp = 0;
  int email_otp = 0;
  int verify_email = 0;
  int sms_mbl = 0;
  bool? otp_sent;
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool _isResendButtonEnabled = false;
  Timer? _timer;
  int _countdown = 30;
  String defaultCountryCode = 'IN';

  Country? _selectedCountry;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCountry();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isResendButtonEnabled = true;
        });
      }
    });
  }

  void initCountry() async {
    final country = await getCountryByCountryCode(context, defaultCountryCode);
    setState(() {
      _selectedCountry = country;
    });
  }

  @override
  Widget build(BuildContext context) {
    return initwidget();
  }

  void _onPressedShowBottomSheet() async {
    final country = await showCountryPickerSheet(
      context,
      cornerRadius: BorderSide.strokeAlignInside,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
        country_code = country.callingCode.toString();
      });
    }
  }

  Widget initwidget() {
    final country = _selectedCountry;
    if (Platform.isAndroid) {
      // Android-specific code
      device_name = 'android';
    } else if (Platform.isIOS) {
      device_name = 'ios';
    }
    init(context);
    return Material(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Form(
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
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-Black.otf'),
                            ),
                          ),
                          const SizedBox(
                              height: 25.0,
                              child: Text(
                                'It' r"'" 's free and always',
                                style: TextStyle(
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf'),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                25.0, 25.0, 25.0, 5.0),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _usernm,
                              keyboardType: TextInputType.name,
                              style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-Black.otf'),
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r"[a-zA-Z]+|\s"),
                                ),
                                LengthLimitingTextInputFormatter(30),
                                CapitalizeWordsTextInputFormatter(),
                              ],
                              decoration: InputDecoration(
                                // labelText: 'Your Name*',
                                // labelStyle: TextStyle(color: Colors.red),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Your Name',

                                enabled: verify_phone == 1 ? false : true,
                                hintStyle: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black45,
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf'),

                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 1, color: _color1),
                                    borderRadius: BorderRadius.circular(10.0)),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 1, color: _color1),
                                    borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 1, color: _color1),
                                    borderRadius: BorderRadius.circular(10.0)),

                                errorText:
                                    _validusernm ? 'Name is not empty' : null,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  _color1 = Colors.red;
                                  /* Fluttertoast.showToast(msg: 'Enter a  Name!');*/
                                } else if (value.length > 30) {
                                  _color1 = Colors.red;
                                  WidgetsBinding
                                      .instance.focusManager.primaryFocus
                                      ?.unfocus();
                                  Fluttertoast.showToast(
                                      msg: 'Name Should be 30 Character');
                                  // return '';
                                } else {
                                  // setState(() {
                                  _color1 = Colors.green.shade600;
                                  // });
                                }
                                return null;
                              },
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  WidgetsBinding
                                      .instance.focusManager.primaryFocus
                                      ?.unfocus();
                                  Fluttertoast.showToast(
                                      msg: 'Please Enter Your Name');
                                  setState(() {
                                    _color1 = Colors.red;
                                  });
                                } else {
                                  setState(() {
                                    _color1 = Colors.green.shade600;
                                  });
                                }
                              },
                              onFieldSubmitted: (value) {
                                if (value.isEmpty) {
                                  WidgetsBinding
                                      .instance.focusManager.primaryFocus
                                      ?.unfocus();
                                  Fluttertoast.showToast(
                                      msg: 'Please Enter Your Name');
                                  setState(() {
                                    _color1 = Colors.red;
                                  });
                                } else {
                                  setState(() {
                                    _color1 = Colors.green.shade600;
                                  });
                                }
                              },
                            ),
                          ),
                          AbsorbPointer(
                              absorbing: verify_phone == 1 ? true : false,
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(
                                    25.0, 5.0, 5.0, 5.0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                          height: 57,
                                          padding: const EdgeInsets.only(left: 2),
                                          decoration: BoxDecoration(
                                            border: verify_phone == 1
                                                ? Border.all(
                                                    width: 1,
                                                    color: Colors.grey)
                                                : Border.all(
                                                    width: 1,
                                                    color: Colors.black26),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Image.asset(
                                                country!.flag,
                                                package: countryCodePackageName,
                                                width: 30,
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                country.callingCode,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 15),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          )),
                                      onTap: () {
                                        _onPressedShowBottomSheet();
                                      },
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        //padding: EdgeInsets.only(bottom: 3.0),
                                        height: 57,
                                        /*width: MediaQuery.of(context).size.width /
                                            1.58,*/
                                        margin: const EdgeInsets.only(
                                            left: 5.0, right: 25),
                                        child: TextFormField(
                                          controller: _usermbl,
                                          style: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf'),
                                          keyboardType: TextInputType.phone,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          textInputAction: TextInputAction.next,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                11),
                                          ],
                                          decoration: InputDecoration(
                                            // labelText: 'Your phone *',
                                            // labelStyle: TextStyle(color: Colors.red),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Mobile Number",
                                            enabled: verify_phone == 1
                                                ? false
                                                : true,
                                            suffixIcon: verify_phone == 1
                                                ? Icon(
                                                    Icons.check_circle_rounded,
                                                    color:
                                                        Colors.green.shade600,
                                                  )
                                                : null,
                                            hintStyle: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black45,
                                                fontFamily:
                                                    'assets/fonst/Metropolis-Black.otf'),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, color: _color2),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, color: _color2),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, color: _color2),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                          ),
                                          onFieldSubmitted: (value) {
                                            var numValue = value.length;
                                            if (numValue >= 6 &&
                                                numValue < 12) {
                                              _color2 = Colors.green.shade600;
                                              setState(() {});
                                            } else {
                                              _color2 = Colors.red;
                                              WidgetsBinding.instance
                                                  .focusManager.primaryFocus
                                                  ?.unfocus();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Enter Correct Number');
                                              setState(() {});
                                            }
                                          },
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              WidgetsBinding.instance
                                                  .focusManager.primaryFocus
                                                  ?.unfocus();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Enter Your Number');
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
                                    )
                                  ],
                                ),
                              )),
                          mbl_otp == 1
                              ? Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height: 60,
                                      margin: const EdgeInsets.only(top: 15),
                                      child: _isResendButtonEnabled &&
                                              _countdown != 0
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                  border: Border.all(width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  color: const Color.fromARGB(
                                                          255, 0, 91, 148)
                                                      .withOpacity(0.8)),
                                              margin: const EdgeInsets.only(
                                                  top: 5.0),
                                              // Set the height of the container
                                              alignment: Alignment.center,
                                              child: Text(
                                                '0:$_countdown',
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-Black.otf',
                                                ).copyWith(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 17),
                                              ))
                                          : Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                  border: Border.all(width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  color: const Color.fromARGB(
                                                      255, 0, 91, 148)),
                                              margin: const EdgeInsets.only(top: 5.0),
                                              // Set the height of the container
                                              alignment: Alignment.center,
                                              child: TextButton(
                                                onPressed: () async {
                                                  if (_usernm.text.isEmpty) {
                                                    _color1 = Colors.red;
                                                    setState(() {});
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Please Enter Your Name');
                                                  } else if (_usermbl
                                                      .text.isEmpty) {
                                                    _color2 = Colors.red;
                                                    setState(() {});
                                                    WidgetsBinding
                                                        .instance
                                                        .focusManager
                                                        .primaryFocus
                                                        ?.unfocus();
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Please Enter Your Number ');
                                                  } else if (_usermbl
                                                      .text.isNotEmpty) {
                                                    if (_usermbl.text.length >=
                                                            6 &&
                                                        _usermbl.text.length <
                                                            12) {
                                                      _color2 =
                                                          Colors.green.shade600;
                                                      if (_usernm.text
                                                              .isNotEmpty &&
                                                          _usermbl.text
                                                              .isNotEmpty) {
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                        _isloading = false;
                                                        _onLoading();
                                                        await register_mo_resendotp(
                                                                _pref
                                                                    .getString(
                                                                        'user_id')
                                                                    .toString(),
                                                                _usermbl.text
                                                                    .toString(),
                                                                _pref
                                                                    .getString(
                                                                        'api_token')
                                                                    .toString(),
                                                                country_code)
                                                            .then((value) {
                                                          Navigator.of(
                                                                  dialogContext!)
                                                              .pop();
                                                          if (value) {
                                                            _isloading = false;
                                                          } else {
                                                            _isloading = false;
                                                          }
                                                        });
                                                        setState(() {});
                                                      }
                                                    } else {
                                                      _color2 = Colors.red;
                                                      WidgetsBinding
                                                          .instance
                                                          .focusManager
                                                          .primaryFocus
                                                          ?.unfocus();
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Please Enter Your Correct Number');
                                                      setState(() {});
                                                    }
                                                  } else if (_usernm
                                                          .text.isNotEmpty &&
                                                      _usermbl
                                                          .text.isNotEmpty) {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    _onLoading();
                                                    await register_mo_resendotp(
                                                            _pref
                                                                .getString(
                                                                    'user_id')
                                                                .toString(),
                                                            _usermbl.text
                                                                .toString(),
                                                            _pref
                                                                .getString(
                                                                    'api_token')
                                                                .toString(),
                                                            country_code)
                                                        .then((value) {
                                                      Navigator.of(
                                                              dialogContext!)
                                                          .pop();
                                                      if (value) {
                                                        _isloading = false;
                                                      } else {
                                                        _isloading = false;
                                                      }
                                                    });
                                                    setState(() {});
                                                  }
                                                },
                                                child: Text('Resend OTP ',
                                                    style: const TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.white,
                                                      fontFamily:
                                                          'assets/fonst/Metropolis-Black.otf',
                                                    ).copyWith(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 19)),
                                              ),
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15.0, 15.0, 15.0, 5.0),
                                      child: TextFormField(
                                        controller: _mbloto,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(4),
                                          _CloseKeyboardFormatter(),
                                        ],
                                        style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets/fonst/Metropolis-Black.otf'),
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          // labelText: 'Your Password',
                                          // labelStyle: TextStyle(color: Colors.red),

                                          hintText: "Enter OTP ",
                                          hintStyle: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf'),

                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color6),
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color6),
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color6),
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          //errorText: _validusernm ? 'Name is not empty' : null),
                                        ),
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            WidgetsBinding.instance
                                                .focusManager.primaryFocus
                                                ?.unfocus();
                                            _color6 = Colors.red;
                                            Fluttertoast.showToast(
                                                msg: 'Please Enter OTP');
                                            setState(() {});
                                            /*setState(() {

                                            _color6 = Colors.red;
                                          });*/
                                          } else {
                                            _color6 = Colors.green.shade600;
                                            setState(() {});
                                          }
                                        },
                                        onFieldSubmitted: (value) {
                                          if (value.isEmpty) {
                                            WidgetsBinding.instance
                                                .focusManager.primaryFocus
                                                ?.unfocus();
                                            Fluttertoast.showToast(
                                                msg: 'Please Enter OTP');
                                            setState(() {
                                              _color6 = Colors.red;
                                            });
                                          } else {
                                            setState(() {
                                              _color6 = Colors.green.shade600;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height: 60,
                                      margin: const EdgeInsets.only(top: 10),
                                      padding: const EdgeInsets.fromLTRB(
                                          35.0, 5.0, 35.0, 5.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          color:
                                              const Color.fromARGB(255, 0, 91, 148)),
                                      child: TextButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            /* Fluttertoast.showToast(
                                                msg: "Data Proccess");*/
                                          }
                                          setState(() {
                                            if (_mbloto.text.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg: 'Please Enter OTP');
                                              //setState(() {
                                              _color6 = Colors.red;
                                              // });
                                            } else if (_mbloto
                                                    .text.isNotEmpty &&
                                                _usermbl.text.isNotEmpty) {
                                              _isloading = false;
                                              _onLoading();
                                              register_mo_verifyotp(
                                                      _mbloto.text.toString(),
                                                      _pref
                                                          .getString('user_id')
                                                          .toString(),
                                                      _usermbl.text.toString(),
                                                      _pref
                                                          .getString(
                                                              'api_token')
                                                          .toString(),
                                                      "3")
                                                  .then((value) {
                                                Navigator.of(dialogContext!)
                                                    .pop();
                                                if (value) {
                                                  _isloading = false;
                                                } else {
                                                  _isloading = false;
                                                }
                                              });
                                            }
                                          });
                                        },
                                        child: Text('Verify OTP',
                                            style: const TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf',
                                            ).copyWith(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 19)),
                                      ),
                                    ),
                                  ],
                                )
                              : verify_phone == 0
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          35.0, 15.0, 35.0, 5.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                color: const Color.fromARGB(
                                                    255, 0, 91, 148)),
                                            child: TextButton(
                                              onPressed: () async {
                                                final connectivityResult =
                                                    await Connectivity()
                                                        .checkConnectivity();

                                                if (connectivityResult ==
                                                    ConnectivityResult.none) {
                                                  //this.getData();
                                                  WidgetsBinding
                                                      .instance
                                                      .focusManager
                                                      .primaryFocus
                                                      ?.unfocus();
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Net Connection not available');
                                                } else {
                                                  if (_usernm.text.isEmpty) {
                                                    _color1 = Colors.red;
                                                    setState(() {});
                                                    WidgetsBinding
                                                        .instance
                                                        .focusManager
                                                        .primaryFocus
                                                        ?.unfocus();
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Please Enter Your Name');
                                                  } else if (_usermbl
                                                      .text.isEmpty) {
                                                    _color2 = Colors.red;
                                                    setState(() {});
                                                    WidgetsBinding
                                                        .instance
                                                        .focusManager
                                                        .primaryFocus
                                                        ?.unfocus();
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Please Enter Your Number ');
                                                  } else if (_usermbl
                                                      .text.isNotEmpty) {
                                                    if (_usermbl.text.length >=
                                                            6 &&
                                                        _usermbl.text.length <
                                                            12) {
                                                      _color2 =
                                                          Colors.green.shade600;
                                                      if (_usernm.text
                                                              .isNotEmpty &&
                                                          _usermbl.text
                                                              .isNotEmpty) {
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                        _onLoading();
                                                        setRegisterUserPhoneno()
                                                            .then((value) {
                                                          Navigator.of(
                                                                  dialogContext!)
                                                              .pop();
                                                          if (value!) {
                                                            _isloading = false;
                                                          } else {
                                                            _isloading = false;
                                                          }
                                                        });
                                                        setState(() {});
                                                      }
                                                    } else {
                                                      _color2 = Colors.red;
                                                      WidgetsBinding
                                                          .instance
                                                          .focusManager
                                                          .primaryFocus
                                                          ?.unfocus();
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Please Enter Your Correct Number');
                                                      setState(() {});
                                                    }
                                                  } else if (_usernm
                                                          .text.isNotEmpty &&
                                                      _usermbl
                                                          .text.isNotEmpty) {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    _onLoading();
                                                    _onLoading();
                                                    setRegisterUserPhoneno()
                                                        .then((value) {
                                                      Navigator.of(
                                                              dialogContext!)
                                                          .pop();
                                                      if (value!) {
                                                        _isloading = false;
                                                      } else {
                                                        _isloading = false;
                                                      }
                                                    });
                                                    setState(() {});
                                                  }
                                                }
                                              },
                                              child: Text('Send OTP',
                                                  style: const TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.white,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf',
                                                  ).copyWith(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 17)),
                                            ),
                                          ),
                                        ],
                                      ))
                                  : Container(),
                          verify_phone == 1
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        autocorrect: false,
                                        controller: _useremail,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets/fonst/Metropolis-Black.otf'),
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(

                                          enabled:
                                              verify_email == 1 ? false : true,
                                          suffixIcon: verify_email == 1
                                              ? Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Colors.green.shade600,
                                                )
                                              : null,
                                          hintText: "Your Email",
                                          hintStyle: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf'),
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

                                          errorText: _validemail
                                              ? 'Email no is not empty'
                                              : null,
                                        ),
                                        validator: (value) {
                                          // if (!EmailValidator.validate(value!)) {
                                          //   return 'Please enter a valid email';
                                          // }
                                          if (value!.isEmpty) {
                                            //WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Please Enter Your Email ');
                                            // Fluttertoast.showToast(msg: 'Email is Required');

                                            //setState(() {
                                            _color3 = Colors.red;
                                            //  });
                                            //return 'Enter a Email!';
                                          } else {
                                            // setState(() {
                                            //_color3 = Colors.green.shade600;
                                            //});
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            setState(() {
                                              _color3 = Colors.green.shade600;
                                            });
                                          } else if (value.isEmpty) {
                                            setState(() {
                                              WidgetsBinding.instance
                                                  .focusManager.primaryFocus
                                                  ?.unfocus();
                                              _color3 = Colors.red;
                                            });
                                          }
                                        },
                                        onFieldSubmitted: (value) {
                                          if (!EmailValidator.validate(value)) {
                                            _color3 = Colors.red;
                                            WidgetsBinding.instance
                                                .focusManager.primaryFocus
                                                ?.unfocus();
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Please Enter Correct Email');
                                            // setState(() {});
                                          }

                                          else if (value.isNotEmpty) {
                                            // setState(() {
                                            _color3 = Colors.green.shade600;
                                            // });
                                          }
                                        },
                                      ),
                                      verify_email == 0
                                          ? email_otp == 0
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  height: 60,
                                                  margin:
                                                      const EdgeInsets.only(top: 15),
                                                  decoration: BoxDecoration(
                                                      border:
                                                          Border.all(width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                      color: const Color.fromARGB(
                                                          255, 0, 91, 148)),
                                                  child: TextButton(
                                                    onPressed: () async {

                                                      log("EMAIL OTP BUTTON PRESSED");

                                                      final connectivityResult =
                                                          await Connectivity()
                                                              .checkConnectivity();

                                                      if (connectivityResult ==
                                                          ConnectivityResult
                                                              .none) {
                                                        //this.getData();
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Net Connection not available');
                                                      } else {
                                                        //this.getData();
                                                        if (_useremail
                                                            .text.isNotEmpty) {
                                                          _isValid =
                                                              EmailValidator
                                                                  .validate(
                                                                      _useremail
                                                                          .text);
                                                          if (_isValid) {
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                            _isloading = false;
                                                            _onLoading();
                                                            setRegisterUserEmail()
                                                                .then((value) {
                                                              Navigator.of(
                                                                      dialogContext!)
                                                                  .pop();
                                                              if (value) {
                                                                _isloading =
                                                                    false;
                                                              } else {
                                                                _isloading =
                                                                    false;
                                                              }
                                                            });
                                                          } else {
                                                            _color3 =
                                                                Colors.red;
                                                            WidgetsBinding
                                                                .instance
                                                                .focusManager
                                                                .primaryFocus
                                                                ?.unfocus();
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Please Enter Correct Email');
                                                            setState(() {});
                                                          }
                                                        } else {
                                                          _color3 = Colors.red;
                                                          WidgetsBinding
                                                              .instance
                                                              .focusManager
                                                              .primaryFocus
                                                              ?.unfocus();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Please Enter Your Email');
                                                          setState(() {});
                                                        }
                                                      }
                                                    },
                                                    child: Text('Send OTP',
                                                        style: const TextStyle(
                                                          fontSize: 15.0,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf',
                                                        ).copyWith(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 17)),
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    _isResendButtonEnabled &&
                                                            _countdown != 0
                                                        ? Container(
                                                            width:
                                                                MediaQuery.of(context)
                                                                        .size
                                                                        .width *
                                                                    0.9,
                                                            height: 60,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        50.0),
                                                                color: const Color.fromARGB(
                                                                        255,
                                                                        0,
                                                                        91,
                                                                        148)
                                                                    .withOpacity(
                                                                        0.8)),
                                                            margin:
                                                                const EdgeInsets.only(
                                                                    top: 5.0),
                                                            // Set the height of the container
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              '0:$_countdown',
                                                              style: const TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'assets/fonst/Metropolis-Black.otf',
                                                              ).copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize: 17),
                                                            ))
                                                        : Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.9,
                                                            height: 60,
                                                            margin:
                                                                const EdgeInsets.only(
                                                                    top: 15),
                                                            decoration: BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                        width:
                                                                            1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50.0),
                                                                color: const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    0,
                                                                    91,
                                                                    148)),
                                                            child: TextButton(
                                                              onPressed:
                                                                  () async {
                                                                final connectivityResult =
                                                                    await Connectivity()
                                                                        .checkConnectivity();

                                                                if (connectivityResult ==
                                                                    ConnectivityResult
                                                                        .none) {
                                                                  //this.getData();
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              'Net Connection not available');
                                                                } else {
                                                                  //this.getData();
                                                                  if (_useremail
                                                                      .text
                                                                      .isNotEmpty) {
                                                                    _isValid = EmailValidator.validate(
                                                                        _useremail
                                                                            .text);
                                                                    if (_isValid) {
                                                                      _isloading =
                                                                          false;
                                                                      _onLoading();
                                                                      register_email_resendotp(
                                                                              _pref.getString('user_id').toString(),
                                                                              _pref.getString('api_token').toString(),
                                                                              _useremail.text.toString())
                                                                          .then((value) {
                                                                        Navigator.of(dialogContext!)
                                                                            .pop();
                                                                        if (value) {
                                                                          _isloading =
                                                                              false;
                                                                        } else {
                                                                          _isloading =
                                                                              false;
                                                                        }
                                                                      });
                                                                    } else {
                                                                      _color3 =
                                                                          Colors
                                                                              .red;
                                                                      WidgetsBinding
                                                                          .instance
                                                                          .focusManager
                                                                          .primaryFocus
                                                                          ?.unfocus();
                                                                      Fluttertoast
                                                                          .showToast(
                                                                              msg: 'Please Enter Correct Email');
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  }
                                                                }
                                                              },
                                                              child: Text(
                                                                  'Resend OTP',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        'assets/fonst/Metropolis-Black.otf',
                                                                  ).copyWith(
                                                                          fontWeight: FontWeight
                                                                              .w800,
                                                                          fontSize:
                                                                              17)),
                                                            ),
                                                          ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(10.0,
                                                          15.0, 10.0, 5.0),
                                                      child: TextFormField(
                                                        controller: _emailotp,
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                          LengthLimitingTextInputFormatter(
                                                              4),
                                                          _CloseKeyboardFormatter(),
                                                        ],
                                                        style: const TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'assets/fonst/Metropolis-Black.otf'),
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration:
                                                            InputDecoration(
                                                          // labelText: 'Your Password',
                                                          // labelStyle: TextStyle(color: Colors.red),

                                                          hintText:
                                                              "Enter OTP ",
                                                          hintStyle:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'assets/fonst/Metropolis-Black.otf'),

                                                          enabledBorder: OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      width: 1,
                                                                      color:
                                                                          _color7),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0)),
                                                          border: OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      width: 1,
                                                                      color:
                                                                          _color7),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0)),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      width: 1,
                                                                      color:
                                                                          _color7),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0)),
                                                          //errorText: _validusernm ? 'Name is not empty' : null),
                                                        ),
                                                        onChanged: (value) {
                                                          if (value.isEmpty) {
                                                            WidgetsBinding
                                                                .instance
                                                                .focusManager
                                                                .primaryFocus
                                                                ?.unfocus();
                                                            _color7 =
                                                                Colors.red;
                                                            setState(() {});
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Please Enter OTP');
                                                          } else {
                                                            _color7 = Colors
                                                                .green.shade600;
                                                            setState(() {});
                                                          }
                                                        },
                                                        onFieldSubmitted:
                                                            (value) {
                                                          if (value.isEmpty) {
                                                            WidgetsBinding
                                                                .instance
                                                                .focusManager
                                                                .primaryFocus
                                                                ?.unfocus();
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Please Enter OTP');
                                                            setState(() {
                                                              _color7 =
                                                                  Colors.red;
                                                            });
                                                          } else if (value
                                                              .isNotEmpty) {
                                                            setState(() {
                                                              _color7 = Colors
                                                                  .green
                                                                  .shade600;
                                                            });
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      height: 60,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          35.0, 5.0, 35.0, 5.0),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                          color: const Color
                                                                  .fromARGB(
                                                              255, 0, 91, 148)),
                                                      child: TextButton(
                                                        onPressed: () async {
                                                          final connectivityResult =
                                                              await Connectivity()
                                                                  .checkConnectivity();

                                                          if (connectivityResult ==
                                                              ConnectivityResult
                                                                  .none) {
                                                            //this.getData();
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Net Connection not available');
                                                          } else {
                                                            //this.getData();
                                                            if (_emailotp
                                                                .text.isEmpty) {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Please Enter OTP");
                                                            }

                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              /* Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Data Proccess");*/
                                                            }
                                                            setState(() {
                                                              if (_emailotp.text
                                                                      .isNotEmpty &&
                                                                  _useremail
                                                                      .text
                                                                      .isNotEmpty) {
                                                                // register_mo_verifyotp(_mbloto.text.toString(),_pref.getString('user_id').toString(),_pref.getString('phone').toString(),_pref.getString('api_token').toString(),"3");
                                                                _isloading =
                                                                    false;
                                                                _onLoading();
                                                                register_email_verifyotp(
                                                                        _emailotp
                                                                            .text
                                                                            .toString(),
                                                                        _pref
                                                                            .getString(
                                                                                'user_id')
                                                                            .toString(),
                                                                        _pref
                                                                            .getString(
                                                                                'api_token')
                                                                            .toString(),
                                                                        _useremail
                                                                            .text
                                                                            .toString(),
                                                                        "2")
                                                                    .then(
                                                                        (value) {
                                                                  Navigator.of(
                                                                          dialogContext!)
                                                                      .pop();
                                                                  if (value) {
                                                                    _isloading =
                                                                        false;
                                                                  } else {
                                                                    _isloading =
                                                                        false;
                                                                  }
                                                                });
                                                              }
                                                            });
                                                          }
                                                        },
                                                        child: Text(
                                                            'Verify OTP',
                                                            style: const TextStyle(
                                                              fontSize: 15.0,
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'assets/fonst/Metropolis-Black.otf',
                                                            ).copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontSize: 19)),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                          : Container()
                                    ],
                                  ))
                              : Container(),
                          verify_email == 1
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          25.0, 5.0, 25.0, 5.0),
                                      child: TextFormField(
                                        controller: _userpass,
                                        obscureText: !_passwordVisible,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        keyboardType: TextInputType.text,
                                        style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets/fonst/Metropolis-Black.otf'),
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          // labelText: 'Your Password',
                                          // labelStyle: TextStyle(color: Colors.red),

                                          hintText: "Enter Your Password ",
                                          hintStyle: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf'),
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
                                            color: Colors.white,
                                            onPressed: () {
                                              // Update the state i.e. toogle the state of passwordVisible variable
                                              setState(() {
                                                _passwordVisible =
                                                    !_passwordVisible;
                                              });
                                            },
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color4),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color4),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color4),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          //errorText: _validusernm ? 'Name is not empty' : null),
                                        ),
                                        validator: (value) {
                                          return null;
                                        },
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            if (value.length < 6) {
                                              /* Fluttertoast.showToast(
                                                msg:
                                                'Password must be 6 charecter');*/
                                              setState(() {
                                                _color4 = Colors.red;
                                              });
                                            } else {
                                              setState(() {
                                                _color4 = Colors.green.shade600;
                                              });
                                            }
                                          } else if (value.isEmpty) {
                                            WidgetsBinding.instance
                                                .focusManager.primaryFocus
                                                ?.unfocus();
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Please Enter Your Password');
                                            setState(() {
                                              _color4 = Colors.red;
                                            });
                                          }
                                        },
                                        /*onFieldSubmitted: (value) {
                                        if (value.isEmpty) {
                                          WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                          Fluttertoast.showToast(
                                              msg:
                                              'Please Enter Your Password');
                                          setState(() {
                                            _color4 = Colors.red;
                                          });
                                        } else {
                                          setState(() {
                                            _color4 = Colors.green.shade600;
                                          });
                                        }
                                        var numValue = value.length;

                                        */ /* if (numValue<=6) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Password must be 6 charecter');
                                            _color4 = Colors.red;
                                          } else {
                                            _color4 = Colors.green.shade600;
                                          }*/ /*
                                      },*/
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          25.0, 5.0, 25.0, 5.0),
                                      child: TextFormField(
                                        controller: _usercpass,
                                        keyboardType: TextInputType.text,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets/fonst/Metropolis-Black.otf'),
                                        obscureText: !_cpasswordVisible,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          // labelText: 'Your Confirm Password',
                                          // labelStyle: TextStyle(color: Colors.red),
                                          hintText:
                                              "Please Enter Confirm Password",
                                          hintStyle: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf'),
                                          suffixIcon: IconButton(
                                            icon:
                                                // Based on passwordVisible state choose the icon
                                                _cpasswordVisible
                                                    ? Image.asset(
                                                        'assets/hidepassword.png')
                                                    : Image.asset(
                                                        'assets/Vector.png',
                                                        width: 20.0,
                                                        height: 20.0,
                                                      ),
                                            color: Colors.white,
                                            onPressed: () {
                                              // Update the state i.e. toogle the state of passwordVisible variable
                                              setState(() {
                                                _cpasswordVisible =
                                                    !_cpasswordVisible;
                                              });
                                            },
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color5),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color5),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color5),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          //errorText: _validusernm ? 'Name is not empty' : null),
                                        ),
                                        /*validator: (value) {
                                        if (value!.isEmpty) {
                                         // WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                          Fluttertoast.showToast(
                                              msg:
                                              'Please Enter Confirm Password');
                                          //setState(() {
                                          _color5 = Colors.red;
                                          // });
                                        } */ /* else if(value!.isNotEmpty) {
                                            if (_userpass.text.length <
                                                6) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                  'Your Password Require Minimum 6 Character');
                                              //setState(() {
                                              _color5 = Colors.red;
                                              // });
                                            }
                                          }*/ /*
                                      },*/
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            WidgetsBinding.instance
                                                .focusManager.primaryFocus
                                                ?.unfocus();
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Please Enter Confirm Password');
                                            setState(() {
                                              _color5 = Colors.red;
                                            });
                                          } else {
                                            if (_userpass.text.toString() ==
                                                value) {
                                              setState(() {
                                                _color5 = Colors.green.shade600;
                                              });
                                            } else {
                                              setState(() {
                                                _color5 = Colors.red;
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              25.0, 0.0, 0, 10.0),
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                value: check_value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    check_value = value!;
                                                  });
                                                },
                                              ),
                                              const Text('I agree with',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'assets/fonst/Metropolis-Black.otf')),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => const AppTermsCondition(),
                                                    ),
                                                  );
                                                },
                                                child: const Text('Terms & Condition',
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Color.fromARGB(
                                                            255, 0, 91, 148),
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf')),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          color:
                                              const Color.fromARGB(255, 0, 91, 148)),
                                      child: TextButton(
                                        onPressed: () async {
                                          final connectivityResult =
                                              await Connectivity()
                                                  .checkConnectivity();

                                          if (connectivityResult ==
                                              ConnectivityResult.none) {
                                            //this.getData();
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Net Connection not available');
                                          } else {
                                            if (_formKey.currentState!
                                                .validate()) {}
                                            setState(() {
                                              vaild_data();
                                            });
                                          }
                                        },
                                        child: const Text('Continue',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf',
                                            )),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    )
                  ]))),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have Account?',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontFamily: 'assets/fonst/Metropolis-Black.otf')),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                child: const Text('Log in',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 91, 148),
                        fontFamily: 'assets/fonst/Metropolis-Black.otf'))),
          ],
        ),
      ),
    );
  }

  vaild_data() {
    _isValid = EmailValidator.validate(_useremail.text);
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    if (_userpass.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please Enter Your Password');
      setState(() {
        _color4 = Colors.red;
      });
    } else if (_usercpass.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please Enter Confirm Password');
      setState(() {
        _color5 = Colors.red;
      });
    } else if (_userpass.text.isNotEmpty) {
      if (_userpass.text.length < 6) {
        Fluttertoast.showToast(msg: 'Password must be 6 charecter');
      } else if (_userpass.text != _usercpass.text) {
        Fluttertoast.showToast(
            msg: "Password and Confirm Password Doesn't Match");
      } else if (!check_value) {
        Fluttertoast.showToast(msg: "Please Select Terms and Condition ");
      } else if (_usernm.text.isNotEmpty &&
          _useremail.text.isNotEmpty &&
          _usermbl.text.isNotEmpty &&
          _userpass.text.isNotEmpty &&
          _usercpass.text.isNotEmpty &&
          _isValid &&
          check_value) {
        _isloading = false;
        _onLoading();

        finalRegister(_useremail.text, _userpass.text, country_code,
                _usermbl.text, device_name, _usernm.text, "5")
            .then((value) {
          Navigator.of(dialogContext!).pop();
          if (value!) {
            _isloading = false;
          } else {
            _isloading = false;
          }
        });
      }
    } else if (_usernm.text.isNotEmpty &&
        _useremail.text.isNotEmpty &&
        _usermbl.text.isNotEmpty &&
        _userpass.text.isNotEmpty &&
        _usercpass.text.isNotEmpty &&
        _isValid &&
        check_value) {
      _isloading = false;
      _onLoading();

      finalRegister(_useremail.text, _userpass.text, country_code,
              _usermbl.text, device_name, _usernm.text, "5")
          .then((value) {
        Navigator.of(dialogContext!).pop();
        if (value!) {
          _isloading = false;
        } else {
          _isloading = false;
        }
      });
    } else {}
  }

  Future<bool?> setRegisterUserPhoneno() async {
    RegisterUserPhoneno register = RegisterUserPhoneno();


    var res = await registerUserPhoneno(
      _usermbl.text,
      country_code.toString(),
      _usernm.text.toString(),
      device_name,
      '3',
    );

    if (res['status'] == 1) {
      register = RegisterUserPhoneno.fromJson(res);
      Fluttertoast.showToast(msg: res['message']);
      _pref = await SharedPreferences.getInstance();
      _pref.setString('user_id', register.result!.userid.toString());
      _pref.setString('name', register.result!.userName.toString());
      _pref.setString('phone', register.result!.phoneno.toString());
      _pref.setString('api_token', register.result!.userToken.toString());
      _pref.setString('step', register.result!.stepCounter.toString());
      constanst.step = register.result!.stepCounter!;
      /* _pref.setBool('islogin', true);*/
      mbl_otp = 1;

      otp_sent = register.otpSent;
      if (otp_sent == false) {
        mbl_otp = 0;
        verify_phone = 1;
      }
      sms_mbl = register.result!.smsCode!;
      _isloading = true;
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res['message']);
      mbl_otp = 0;
      _isloading = true;
      setState(() {});
      return _isloading;
    }
    if (mbl_otp == 1) {
      _isResendButtonEnabled = true;
      _startTimer();
      setState(() {});
    }
    return null;
  }

  Future<bool> setRegisterUserEmail() async {

    log("setRegisterUserEmail Method Called");

    var res = await registerUserEmail(
        _usernm.text.toString(),
        _useremail.text.toString(),
        '1',
        _pref.getString('api_token').toString(),
        _pref.getString('user_id').toString(),
        device_name);

    if (res['status'] == 1) {

      email_otp = 1;
      _isloading = true;
      Fluttertoast.showToast(msg: res['message']);

      setState(() {});
    } else {
      _isloading = true;
      Fluttertoast.showToast(msg: res['message']);
      email_otp = 0;
      setState(() {});
    }
    if (email_otp == 1) {
      _countdown = 30;
      _isResendButtonEnabled = true;
      _startTimer();
      setState(() {});
    }
    return _isloading;
  }

  Future<void> init(BuildContext context) async {
    await FirebaseApi().initNOtification(context);

    // APIs.getSelfInfo();
  }

  Future<bool> register_mo_verifyotp(
    String otp,
    String userId,
    String phoneno,
    String apiToken,
    String step,
  ) async {
    log("VERIFY OTP PRESSED");

    var res = await reg_mo_verifyotp(otp, userId, phoneno, apiToken, step);

    //String? msg = res['message'];

    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);
      verify_phone = 1;
      mbl_otp = 0;
      _isloading = true;
    } else {
      _isloading = true;
      Fluttertoast.showToast(msg: res['message']);
      _isResendButtonEnabled = false;
      _countdown = 30;
    }

    setState(() {});
    return _isloading;
  }

  Future<bool> register_mo_resendotp(
    String userId,
    String apiToken,
    String phoneno,
    countryCode,
  ) async {

    var res = await reg_mo_resendotp(userId, phoneno, apiToken, countryCode);


    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);
      otp_sent = res['otp_sent'];
      //verify_phone=1;
      mbl_otp = 1;
      if (otp_sent == false) {
        mbl_otp = 0;
        verify_phone = 1;
      }
      _isloading = true;
    } else {
      _isloading = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    if (mbl_otp == 1) {
      _countdown = 30;
      _isResendButtonEnabled = true;
      _startTimer();
      setState(() {});
    }
    setState(() {});
    return _isloading;
  }

  Future<bool> register_email_resendotp(
      String userId, String apiToken, String email) async {

    var res = await reg_email_resendotp(userId, apiToken, email);


    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);
      _isloading = true;
      //verify_phone=1;
      email_otp = 1;
    } else {
      _isloading = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    if (email_otp == 1) {
      _countdown = 30;
      _isResendButtonEnabled = true;
      _startTimer();
      setState(() {});
    }
    return _isloading;
  }

  Future<bool> register_email_verifyotp(
    String otp,
    String userId,
    String apiToken,
    String email,
    String step,
  ) async {
    log("VERIFY EMAIL OTP PRESSED..!");

    var res = await reg_email_verifyotp(otp, userId, apiToken, email, step);


    if (res['status'] == 1) {
      // Fluttertoast.showToast(msg: res['message']);
      Fluttertoast.showToast(msg: "Your Email is Verified");
      verify_email = 1;
      _isloading = true;
      email_otp = 1;
    } else {
      _isloading = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return _isloading;
  }

  finalRegister(
      String email,
      String password,
      String countryCode,
      String phoneNumber,
      String device,
      String username,
      String stepCounter) async {
    //FinalRegister register = FinalRegister();

    var res = await final_register(
        email,
        password,
        countryCode,
        phoneNumber,
        device,
        username,
        stepCounter,
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());


    if (res['status'] == 1) {
      register = FinalRegister.fromJson(res);
      Fluttertoast.showToast(msg: res['message']);
      _pref = await SharedPreferences.getInstance();
      _pref.setString('user_id', register.result!.userid.toString());
      _pref.setString('name', register.result!.userName.toString());
      _pref.setString('email', register.result!.email.toString());
      _pref.setString('api_token', register.result!.userToken.toString());
      _pref.setString('step', register.result!.stepCounter.toString());
      constanst.step = int.parse(register.result!.stepCounter.toString());
      _pref.setBool('islogin', true);
      constanst.api_token = register.result!.userToken.toString();
      constanst.userid = register.result!.userid.toString();
      constanst.step = register.result!.stepCounter!;

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
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
  }

  Future<bool> add_android_device() async {

    /*_onLoading();*/
    var res = await androidDevice_Register(_usermbl.text.toString());
    if (res['status'] == 1) {
      constanst.usernm = _usernm.text.toString();
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('user_id', register.result!.userid.toString());
      pref.setString('name', register.result!.userName.toString());
      pref.setString('email', register.result!.email.toString());
      pref.setString('phone', register.result!.phoneno.toString());
      pref.setString('api_token', register.result!.userToken.toString());
      pref.setString('step', register.result!.stepCounter.toString());

      pref.setBool('islogin', true);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MainScreen(0)),
          ModalRoute.withName('/'));
    } else {
      _isloading = true;
    }
    return _isloading;
  }

  Future<bool> add_ios_device() async {

    var res = await iosDevice_Register();

    if (res['status'] == 1) {
      constanst.usernm = _usernm.text.toString();
      //Fluttertoast.showToast(msg: res['message']);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('user_id', register.result!.userid.toString());
      pref.setString('name', register.result!.userName.toString());
      pref.setString('email', register.result!.email.toString());
      pref.setString('phone', register.result!.phoneno.toString());
      pref.setString('api_token', register.result!.userToken.toString());
      pref.setString('step', register.result!.stepCounter.toString());
      constanst.step = register.result!.stepCounter!;
      // _pref.setString('userImage', register.result!.userImage.toString());
      pref.setBool('islogin', true);
      _isloading = true;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MainScreen(0)),
          ModalRoute.withName('/'));
    } else {
      _isloading = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    return _isloading;
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

class _CloseKeyboardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 4) {
      // Close the keyboard
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
    }
    return newValue;
  }
}

class CapitalizeWordsTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Capitalize the first letter of each word
    return TextEditingValue(
      text: toTitleCase(newValue.text),
      selection: newValue.selection,
    );
  }

  String toTitleCase(String text) {
    if (text.isEmpty) {
      return '';
    }
    return text.split(' ').map((word) {
      if (word.isNotEmpty) {
        return '${word[0].toUpperCase()}${word.substring(1)}';
      } else {
        return '';
      }
    }).join(' ');
  }
}
