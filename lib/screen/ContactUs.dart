// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, import_of_legacy_library_into_null_safe, depend_on_referenced_packages

import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/api_interface.dart';
import '../widget/HomeAppbar.dart';
import 'package:country_calling_code_picker/picker.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  String? _selectitem;
  bool? passenable = true, load;
  var check_value = false;
  String? location, email = 'email', countryCode = "+91", phone = 'phone';
  List listitem2 = ['Feedback/Suggestions', 'Advetiesment'];
  final TextEditingController _usernm = TextEditingController();
  final TextEditingController _usermbl = TextEditingController();
  final TextEditingController _bussemail = TextEditingController();
  final TextEditingController _bussabout = TextEditingController();
  final TextEditingController _bussnm = TextEditingController();

  Color _color1 = Colors.black26;
  Color _color2 = Colors.black26;
  Color _color7 = Colors.black26;
  Color _color6 = Colors.black26;
  Color _color9 = Colors.black26;
  Color _color = Colors.black26;

  String? whatsappUrl,
      facebookUrl,
      instagramUrl,
      linkedinUrl,
      youtubeUrl,
      telegramUrl,
      twitterUrl;

  final _formKey = GlobalKey<FormState>();
  final bool _validusernm = false;
  bool _isValid = false;
  String device_name = '';
  String defaultCountryCode = 'IN';

  //PhoneNumber number = PhoneNumber(isoCode: 'IN');
  Country? _selectedCountry;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCountry();
    checknetowork();
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

  Widget initwidget() {
    final country = _selectedCountry;
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 218, 218, 218),
      resizeToAvoidBottomInset: true,
      appBar: CustomeApp('ContactUs'),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SizedBox(
            // height: MediaQuery.of(context).size.height,
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
                      select_sub_dropdown(listitem2, 'Select Subject'),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _usernm,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-Z]+|\s"),
                            ),
                            LengthLimitingTextInputFormatter(30)
                          ],
                          decoration: InputDecoration(
                            // labelText: 'Your Name*',
                            // labelStyle: TextStyle(color: Colors.red),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Your Name *',
                            hintStyle: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf')
                                .copyWith(color: Colors.black45),

                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: _color1),
                                borderRadius: BorderRadius.circular(12.0)),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: _color1),
                                borderRadius: BorderRadius.circular(12.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: _color1),
                                borderRadius: BorderRadius.circular(12.0)),

                            errorText:
                                _validusernm ? 'Name is not empty' : null,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Please Enter Your Name');
                              _color1 = Colors.red;
                            } else if (value.length > 30) {
                              _color1 = Colors.red;
                              return 'Name Should be 30 Character';
                            } else {
                              // setState(() {
                              _color1 = Colors.green.shade600;
                              // });
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value.isEmpty) {
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
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _bussnm,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-Z]+|\s"),
                            ),
                            LengthLimitingTextInputFormatter(50)
                          ],
                          decoration: InputDecoration(
                            // labelText: 'Your Name*',
                            // labelStyle: TextStyle(color: Colors.red),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Business Name*',
                            hintStyle: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf')
                                .copyWith(color: Colors.black45),

                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: _color2),
                                borderRadius: BorderRadius.circular(12.0)),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: _color2),
                                borderRadius: BorderRadius.circular(12.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: _color2),
                                borderRadius: BorderRadius.circular(12.0)),

                            errorText:
                                _validusernm ? 'Name is not empty' : null,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Please Enter Your Bussiness Name');
                              _color2 = Colors.red;
                            } else if (value.length > 30) {
                              _color2 = Colors.red;
                              return 'Name Should be 30 Character';
                            } else {
                              // setState(() {
                              _color2 = Colors.green.shade600;
                              // });
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Please Enter Your Bussiness Name');
                              setState(() {
                                _color2 = Colors.red;
                              });
                            } else {
                              setState(() {
                                _color2 = Colors.green.shade600;
                              });
                            }
                          },
                          onFieldSubmitted: (value) {
                            if (value.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Please Enter Your Name');
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
                        padding: const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 0),
                        child: TextFormField(
                          controller: _bussemail,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            // labelText: 'Your email *',
                            // labelStyle: TextStyle(color: Colors.red),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Email*",
                            hintStyle: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf')
                                .copyWith(color: Colors.black45),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: _color7),
                                borderRadius: BorderRadius.circular(12.0)),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: _color7),
                                borderRadius: BorderRadius.circular(12.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: _color7),
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: (value) {
                            // if (!EmailValidator.validate(value!)) {
                            //   return 'Please enter a valid email';
                            // }
                            if (value!.isEmpty) {
                              _color7 = Colors.red;
                              Fluttertoast.showToast(msg: 'Please Your Email');
                            } else {
                              // setState(() {
                              _color7 = Colors.green.shade600;
                              // });
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            if (!EmailValidator.validate(value)) {
                              _color7 = Colors.red;
                              Fluttertoast.showToast(
                                  msg: 'Please enter a valid email');
                              setState(() {});
                            } else if (value.isEmpty) {
                              Fluttertoast.showToast(msg: 'Please Your Email');
                              setState(() {
                                _color7 = Colors.red;
                              });
                            } else if (value.isNotEmpty) {
                              setState(() {
                                _color7 = Colors.green.shade600;
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 68,
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(25.0, 0.0, 5.0, 0),
                              child: Container(
                                height: 58,
                                //width: 130,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.black26),
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white),

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  //mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 58,
                                      padding: const EdgeInsets.only(left: 2),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.black26),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {},
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
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 0.0, right: 25),
                                //padding: EdgeInsets.only(bottom: 3.0),
                                //height: 58,
                                /* width: MediaQuery.of(context).size.width /
                                        1.58,*/
                                child: TextFormField(
                                  // controller: _usernm,
                                  controller: _usermbl,
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromARGB(255, 0, 91, 148),
                                      fontFamily:
                                          'assets/fonst/Metropolis-Black.otf'),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                  keyboardType: TextInputType.phone,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    // labelText: 'Your phone *',
                                    // labelStyle: TextStyle(color: Colors.red),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: "Bussiness Mobile",
                                    hintStyle: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets/fonst/Metropolis-Black.otf')
                                        .copyWith(color: Colors.black45),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: _color6),
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: _color6),
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: _color6),
                                        borderRadius:
                                            BorderRadius.circular(12.0)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      _color6 = Colors.red;
                                      Fluttertoast.showToast(
                                          msg: 'Please Your Bussiness Mobile');
                                    } else {
                                      // setState(() {
                                      _color6 = Colors.green.shade600;
                                      //});
                                    }

                                    return null;
                                  },
                                  onFieldSubmitted: (value) {
                                    var numValue = value.length;
                                    if (numValue >= 6 && numValue < 11) {
                                      _color6 = Colors.green.shade600;
                                    } else {
                                      _color6 = Colors.red;
                                      Fluttertoast.showToast(
                                          msg: 'Please Enter Correct Number');
                                    }
                                  },
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg: 'Please Your Bussiness Mobile');
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
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
                        child: TextFormField(
                          controller: _bussabout,
                          keyboardType: TextInputType.multiline,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                          maxLines: 4,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              hintText: "Message*",
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontFamily:
                                          'assets/fonst/Metropolis-Black.otf')
                                  .copyWith(color: Colors.black45),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: _color9),
                                  borderRadius: BorderRadius.circular(10.0)),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: _color9),
                                  borderRadius: BorderRadius.circular(10.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: _color9),
                                  borderRadius: BorderRadius.circular(10.0))

                              //errorText: _validusernm ? 'Name is not empty' : null),
                              ),
                          validator: (value) {
                            // if (!EmailValidator.validate(value!)) {
                            //   return 'Please enter a valid email';
                            // }
                            if (value!.isEmpty) {
                              _color9 = Colors.red;
                              Fluttertoast.showToast(
                                  msg: 'Please Your Message');
                            } else {
                              // setState(() {
                              _color9 = Colors.green.shade600;
                              //});
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            if (value.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Please Your Message');
                              setState(() {
                                _color9 = Colors.red;
                              });
                            } else if (value.isNotEmpty) {
                              setState(() {
                                _color9 = Colors.green.shade600;
                              });
                            }
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: 60,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(50.0),
                            color: const Color.fromARGB(255, 0, 91, 148)),
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              /*Fluttertoast.showToast(
                                        msg: "Data Proccess");*/
                            }

                            setState(() {
                              vaild_data();
                            });
                          },
                          child: const Text('Submit',
                              style: TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontFamily:
                                      'assets/fonst/Metropolis-Black.otf')),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      load == true
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                              height: 210,
                              width: MediaQuery.of(context).size.width * 0.85,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/contactus_back.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 10,
                                    left: 20,
                                    child: Container(
                                      color: const Color.fromARGB(
                                          0, 255, 255, 255),
                                      child: Text('Our Location',
                                          style: const TextStyle(
                                                  fontSize: 26.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-Black.otf')
                                              .copyWith(fontSize: 16)),
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    left: 20,
                                    child: Container(
                                        color: const Color.fromARGB(
                                            0, 255, 255, 255),
                                        child: SizedBox(
                                            height: 85,
                                            width: 150,
                                            child: Html(data: location,

                                            ))),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      color: const Color.fromARGB(
                                          0, 255, 255, 255),
                                      child: Center(
                                          child: Image.asset(
                                        'assets/plastic4trade logo final.png',
                                        width: 100,
                                        height: 30,
                                      )),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Container(
                                      color: const Color.fromARGB(
                                          0, 255, 255, 255),
                                      child: Center(
                                          child: GestureDetector(
                                        onTap: () {
                                          openMap();
                                        },
                                        child: Image.asset(
                                          'assets/contactus_loc.png',
                                          width: 200,
                                          height: 30,
                                        ),
                                      )),
                                    ),
                                  ),
                                ],
                              ))
                          : Center(
                              child: Platform.isAndroid
                                  ? const CircularProgressIndicator(
                                      value: null,
                                      strokeWidth: 2.0,
                                      color: Color.fromARGB(255, 0, 91, 148),
                                    )
                                  : Platform.isIOS
                                      ? const CupertinoActivityIndicator(
                                          color:
                                              Color.fromARGB(255, 0, 91, 148),
                                          radius: 20,
                                          animating: true,
                                        )
                                      : Container()),
                      Container(
                        margin: const EdgeInsets.only(left: 25,right: 25,top: 10),
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
                      )]),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 60,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            launchUrl(
                                              Uri.parse(
                                                  'tel:$countryCode + ${phone.toString()}'),
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          },
                                          child: Text(
                                              countryCode.toString() +
                                                  phone.toString(),
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-SemiBold.otf')),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                launchUrl(
                                  Uri.parse(
                                      'tel:$countryCode + ${phone.toString()}'),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              icon: Image.asset('assets/call1.png',height: 32,width: 32,),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 25,right: 25,top: 10),
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
                              )]),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 60,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            launchUrl(
                                              Uri.parse(
                                                  'mailto:${email.toString()}'),
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          },
                                          child: Text(
                                            email.toString(),
                                            style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight:
                                                    FontWeight.w600,
                                                color: Colors.black,
                                                fontFamily:
                                                    'assets/fonst/Metropolis-SemiBold.otf'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                launchUrl(
                                  Uri.parse('mailto:${email.toString()}'),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              icon: Image.asset('assets/msg1.png',height: 32,width: 32,),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: 80,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          margin: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 15.0),
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
                      )]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Follow Plastic4trade',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic,
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf',
                                    color: Colors.black),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    iconSize: 26,
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () => launchUrl(
                                      Uri.parse(whatsappUrl!),
                                      mode: LaunchMode.externalApplication,
                                    ),
                                    icon:
                                        Image.asset('assets/whatsapp.png',height: 26,width: 26,),
                                  ),
                                  IconButton(
                                    iconSize: 26,
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () => launchUrl(
                                      Uri.parse(facebookUrl!),
                                      mode: LaunchMode.externalApplication,
                                    ),
                                    icon:
                                        Image.asset('assets/facebook.png',height: 26,width: 26),
                                  ),
                                  IconButton(
                                    iconSize: 26,
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () => launchUrl(
                                      Uri.parse(instagramUrl!),
                                      mode: LaunchMode.externalApplication,
                                    ),
                                    icon:
                                        Image.asset('assets/instagram.png',height: 26,width: 26),
                                  ),
                                  IconButton(
                                    iconSize: 26,
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () => launchUrl(
                                      Uri.parse(linkedinUrl!),
                                      mode: LaunchMode.externalApplication,
                                    ),
                                    icon: Image.asset('assets/linkdin.png',height: 26,width: 26),
                                  ),
                                  IconButton(
                                    iconSize: 26,
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () => launchUrl(
                                      Uri.parse(youtubeUrl!),
                                      mode: LaunchMode.externalApplication,
                                    ),
                                    icon: Image.asset('assets/youtube.png',height: 26,width: 26),
                                  ),
                                  IconButton(
                                    iconSize: 26,
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () => launchUrl(
                                      Uri.parse(telegramUrl!),
                                      mode: LaunchMode.externalApplication,
                                    ),
                                    icon:
                                        Image.asset('assets/Telegram.png',height: 26,width: 26),
                                  ),
                                  IconButton(
                                    iconSize: 26,
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () => launchUrl(
                                      Uri.parse(twitterUrl!),
                                      mode: LaunchMode.externalApplication,
                                    ),
                                    icon: Image.asset('assets/Twitter.png',height: 26,width: 26),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget select_sub_dropdown(List listitem, String hint) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 0.0),
      child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: _color),
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white),
          child: DropdownButton(
            value: _selectitem,
            hint: Text(hint,
                style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf')
                    .copyWith(color: Colors.black45)),
            dropdownColor: Colors.white,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 30,
            isExpanded: true,
            underline: const SizedBox(),
            items: listitem.map((valueItem) {
              return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem,
                      style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: 'assets/fonst/Metropolis-Black.otf')));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectitem = value.toString();
              });
            },
          )),
    ));
  }

  vaild_data() {
    _isValid = EmailValidator.validate(_bussemail.text);

    var numValue = _usermbl.text.length;
    if (_selectitem == null) {
      setState(() {
        _color = Colors.red;
        Fluttertoast.showToast(msg: 'Please Select a Subject');
      });
    } else if (numValue <= 6) {
      setState(() {
        _color6 = Colors.red;
        Fluttertoast.showToast(msg: 'Please Enter Correct Number ');
      });
    } else if (numValue >= 14) {
      setState(() {
        _color6 = Colors.red;
        Fluttertoast.showToast(msg: 'Please Enter Correct Number ');
      });
    } else if (_usernm.text.isNotEmpty &&
        _bussemail.text.isNotEmpty &&
        _usermbl.text.isNotEmpty &&
        _bussnm.text.isNotEmpty &&
        _isValid) {
      if (Platform.isAndroid) {
        device_name = 'android';
      } else if (Platform.isIOS) {
        device_name = 'ios';
      }
      setContact().then((value) => Navigator.pop(context));
    }
  }

  Future<void> setContact() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var res = await add_contact(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        _selectitem.toString(),
        _usernm.text.toString(),
        _bussemail.text.toString(),
        countryCode.toString(),
        _usermbl.text.toString(),
        _bussabout.text.toString(),
        _bussnm.text.toString(),
        device_name.toString());


    if (res['status'] == 1) {
      // Fluttertoast.showToast(msg: res['message']);
      Fluttertoast.showToast(
          msg: "Your Query is Submitted will Get Back to you Shortly");
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res['message']);

      setState(() {});
    }
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      get_ContactDetails();
      getSocialMedia();
    }
  }

  Future<void> get_ContactDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getContactDetails(pref.getString('user_id').toString(),
        pref.getString('api_token').toString());

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];

        location = jsonArray['location'];
        countryCode = jsonArray['countryCode'];
        phone = jsonArray['phone'];
        countryCode = jsonArray['countryCode'];
        email = jsonArray['email'];
        load = true;

        if (mounted) {
          setState(() {});
        }
      } else {
        load = true;
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonArray;
  }

  getSocialMedia() async {
    var res = await getSocialLinks();

    if (res['status'] == 1) {
      whatsappUrl = res['result']['site_whatsapp_url'];
      facebookUrl = res['result']['site_facebook_url'];
      instagramUrl = res['result']['site_instagram_url'];
      linkedinUrl = res['result']['site_linkedin_url'];
      youtubeUrl = res['result']['site_youtube_url'];
      telegramUrl = res['result']['site_telegram_url'];
      twitterUrl = res['result']['site_twitter_url'];
      setState(() {});
    } else {}
  }

  void openMap() async {
    double latitude = 23.016189;
    double longitude = 72.468770;

    // 23.016189, 72.468770  == HAR IMPEX OFFICE

    String label = "HAR IMPEX OFFICE";

    // final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&query_place=$label";
    const String googleMapsUrl =
        "https://www.google.com/maps/place/Plastic4trade/@23.0161915,72.4661721,17z/data=!3m1!4b1!4m6!3m5!1s0x395e9b21c3b75b55:0xd74cdf40aaa80916!8m2!3d23.0161866!4d72.468747!16s%2Fg%2F11rv7yjdsv?entry=ttu";

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {}
  }
}
