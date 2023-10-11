// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:io' show Platform;

import 'package:Plastic4trade/screen/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../api/api_interface.dart';

class ResetPassword extends StatefulWidget {
  String? phone;
  String? country_code;
  String? email;
  ResetPassword(
      {Key? key,
      required this.country_code,
      required this.phone,
      required this.email})
      : super(key: key);

  @override
  State<ResetPassword> createState() => _RecentPasswordState();
}

class _RecentPasswordState extends State<ResetPassword> {
  final TextEditingController _userpass = TextEditingController();
  final TextEditingController _usercpass = TextEditingController();
  bool _passwordVisible = false;
  bool _cpasswordVisible = false;
  Color _color4 = Colors.black26;
  Color _color5 = Colors.black26;
  BuildContext? dialogContext;
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return initwidget();
  }

  Widget initwidget() {
    return Scaffold(

      resizeToAvoidBottomInset: true,

      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
            top: true,
            left: true,
            right: true,
            bottom: true,
            child: Column(

              children: [
            Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    child: Image.asset('assets/back.png',
                        height: 50, width: 60),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LoginScreen()),
                          ModalRoute.withName('/'));
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  alignment: Alignment.topLeft,
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),

            Column(


              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                  child: TextFormField(
                    controller: _userpass,
                    obscureText: !_passwordVisible,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "New Password",
                      hintStyle: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily:
                              'assets/fonst/Metropolis-Black.otf'),
                      suffixIcon: IconButton(
                        icon:

                            _passwordVisible
                                ? Image.asset('assets/hidepassword.png')
                                : Image.asset(
                                    'assets/Vector.png',
                                    width: 20.0,
                                    height: 20.0,
                                  ),
                        color: Colors.white,
                        onPressed: () {

                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: _color4),
                          borderRadius: BorderRadius.circular(10.0)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: _color4),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: _color4),
                          borderRadius: BorderRadius.circular(10.0)),

                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        _color4 = Colors.red;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'Please Enter Your Password');
                        setState(() {
                          _color4 = Colors.red;
                        });
                      } else {
                        setState(() {
                          _color4 = Colors.green.shade600;
                        });
                      }
                    },
                    onFieldSubmitted: (value) {
                      if (value.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'Please Enter Your Password');
                        setState(() {
                          _color4 = Colors.red;
                        });
                      } else {
                        setState(() {
                          _color4 = Colors.green.shade600;
                        });
                      }
                      var numValue = value.length;
                      if (numValue < 6) {
                        Fluttertoast.showToast(
                            msg:
                                'Your Password Require Minimum 6 Character');
                        _color4 = Colors.red;
                      } else {
                        _color4 = Colors.green.shade600;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                  child: TextFormField(
                    controller: _usercpass,
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                    obscureText: !_cpasswordVisible,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(

                      hintText: "Confirm Password",
                      hintStyle: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily:
                              'assets/fonst/Metropolis-Black.otf'),
                      suffixIcon: IconButton(
                        icon:

                            _cpasswordVisible
                                ? Image.asset('assets/hidepassword.png')
                                : Image.asset(
                                    'assets/Vector.png',
                                    width: 20.0,
                                    height: 20.0,
                                  ),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            _cpasswordVisible = !_cpasswordVisible;
                          });
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: _color5),
                          borderRadius: BorderRadius.circular(10.0)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: _color5),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: _color5),
                          borderRadius: BorderRadius.circular(10.0)),

                    ),
                    validator: (value) {
                      if (value!.isEmpty) {

                        _color5 = Colors.red;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'Please Enter Your Password');
                        setState(() {
                          _color5 = Colors.red;
                        });
                      } else {
                        setState(() {
                          _color5 = Colors.green.shade600;
                        });
                      }
                    },

                  ),
                ),
              ],
            ),
              ],
            )),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 15),
        decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(50.0),
            color: const Color.fromARGB(255, 0, 91, 148)),
        child: TextButton(
          onPressed: () {

            vaild_data();
          },
          child: const Text('Save & Continue',
              style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontFamily: 'assets/fonst/Metropolis-Black.otf')),
        ),
      ),
    );
  }

  vaild_data() {
    var numValue = _userpass.text.length;

    if (_userpass.text.isEmpty && _usercpass.text.isEmpty) {
      _color4 = Colors.red;
      _color5 = Colors.red;
      setState(() {});
    }
    if (_userpass.text.isEmpty) {
      _color4 = Colors.red;
      setState(() {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        Fluttertoast.showToast(msg: 'Please Enter Your Password');
      });
    } else if (_userpass.text.isNotEmpty) {
      if (numValue < 6) {
        Fluttertoast.showToast(
            msg: 'Your Password Require Minimum 6 Character ');
        _color4 = Colors.red;
        setState(() {

        });
      } else if (_usercpass.text.isEmpty) {
        _color5 = Colors.red;
        setState(() {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          Fluttertoast.showToast(msg: 'Please Enter Your Confirm Password');
        });
      } else if (_userpass.text != _usercpass.text) {
        Fluttertoast.showToast(
            msg: "Password and Confirm Password Doesn't Match");
      }  else if (_userpass.text.isNotEmpty && _usercpass.text.isNotEmpty) {
        _onLoading();
        reset_password(_userpass.text.toString(), widget.country_code,
            widget.phone, widget.email).then((value) {
          Navigator.of(dialogContext!).pop();
          if (value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const LoginScreen()),
                ModalRoute.withName('/'));
          } else {

          }
        });
      }
    } else if (_usercpass.text.isEmpty) {
      _color5 = Colors.red;
      setState(() {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        Fluttertoast.showToast(msg: 'Please Enter Your Confirm Password');
      });
    } else if (_userpass.text != _usercpass.text) {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(
          msg: "Password and Confirm Password Doesn't Match");
    } else if (_userpass.text.isNotEmpty && _usercpass.text.isNotEmpty) {
      reset_password(_userpass.text.toString(), widget.country_code,
          widget.phone, widget.email).then((value) {
        Navigator.of(dialogContext!).pop();
        if (value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const LoginScreen()),
              ModalRoute.withName('/'));
        } else {

        }
      });
    }
  }
  void _onLoading() {
    dialogContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
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
  Future<bool> reset_password(password, countryCode, phoneno, email) async {

    var res = await resetPassword(password, countryCode, phoneno, email);
    String? msg = res['message'];
    Fluttertoast.showToast(msg: "$msg");
    if (res['status'] == 1) {
      isloading=true;
      Fluttertoast.showToast(msg: res['message']);
    } else {
      Fluttertoast.showToast(msg: res['message']);
      isloading=false;
    }
    return isloading;
  }
}
