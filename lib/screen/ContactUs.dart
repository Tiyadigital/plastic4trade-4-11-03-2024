import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:Plastic4trade/model/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_interface.dart';
import '../model/getContact_Detail.dart';
import '../widget/HomeAppbar.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';


class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  String? _selectitem;
  bool? passenable = true,load;
  var check_value = false;
  String? location,email='email',countryCode="+91",phone='phone';
  List listitem2 = ['Feedback/Suggestions', 'Advetiesment'];
  TextEditingController _usernm = TextEditingController();
  TextEditingController _usermbl = TextEditingController();
  TextEditingController _bussemail = TextEditingController();
  TextEditingController _bussabout = TextEditingController();
  TextEditingController _bussnm = TextEditingController();

  Color _color1 = Colors.black26;
  Color _color2 = Colors.black26;
  Color _color7 = Colors.black26;
  Color _color6 = Colors.black26;
  Color _color9 = Colors.black26;

  var _formKey = GlobalKey<FormState>();
  bool _validusernm = false, _validusembl = false, _validemail = false;
  bool _passwordVisible = false;
  bool _cpasswordVisible = false;
  bool _vailduseremail = false;
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
        backgroundColor: Color.fromARGB(240, 218, 218, 218),
        resizeToAvoidBottomInset: true,

        appBar: CustomeApp('ContactUs'),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Container(
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
                            select_sub_dropdown(listitem2,'Select Subject'),
                            Padding(
                              padding:
                              EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                              child: TextFormField(
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                controller: _usernm,
                                keyboardType: TextInputType.name,
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                                textCapitalization:
                                TextCapitalization.sentences,
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
                                  hintStyle:
                                  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')?.copyWith(color: Colors.black45),

                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(width: 1, color: _color1),
                                      borderRadius:
                                      BorderRadius.circular(12.0)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(width: 1, color: _color1),
                                      borderRadius:
                                      BorderRadius.circular(12.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(width: 1, color: _color1),
                                      borderRadius:
                                      BorderRadius.circular(12.0)),

                                  errorText:
                                  _validusernm ? 'Name is not empty' : null,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: 'Please Enter Your Name');
                                    _color1 = Colors.red;
                                  } else if(value.length>30){
                                    _color1 = Colors.red;
                                    return 'Name Should be 30 Character';
                                  }

                                  else {
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
                              EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                              child: TextFormField(
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                controller: _bussnm,
                                keyboardType: TextInputType.name,
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                                textCapitalization:
                                TextCapitalization.words,
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
                                  hintStyle:
                                  TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')?.copyWith(color: Colors.black45),

                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(width: 1, color: _color2),
                                      borderRadius:
                                      BorderRadius.circular(12.0)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(width: 1, color: _color2),
                                      borderRadius:
                                      BorderRadius.circular(12.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(width: 1, color: _color2),
                                      borderRadius:
                                      BorderRadius.circular(12.0)),

                                  errorText:
                                  _validusernm ? 'Name is not empty' : null,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: 'Please Enter Your Bussiness Name');
                                    _color2 = Colors.red;
                                  } else if(value.length>30){
                                    _color2 = Colors.red;
                                    return 'Name Should be 30 Character';

                                  }
                                  else {
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
                              padding:
                              EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 0),
                              child: TextFormField(
                                controller: _bussemail,
                                keyboardType: TextInputType.emailAddress,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  // labelText: 'Your email *',
                                  // labelStyle: TextStyle(color: Colors.red),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Email*",
                                  hintStyle:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')?.copyWith(color: Colors.black45),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: _color7),
                                      borderRadius:
                                      BorderRadius.circular(12.0)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: _color7),
                                      borderRadius:
                                      BorderRadius.circular(12.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: _color7),
                                      borderRadius:
                                      BorderRadius.circular(12.0)),
                                ),
                                validator: (value) {
                                  // if (!EmailValidator.validate(value!)) {
                                  //   return 'Please enter a valid email';
                                  // }
                                  if (value!.isEmpty) {
                                    _color7 = Colors.red;
                                    Fluttertoast.showToast(
                                        msg: 'Please Your Email');
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
                                    Fluttertoast.showToast(
                                        msg: 'Please Your Email');
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

                            Container(
                              height: 68,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        25.0, 0.0, 5.0, 0),
                                    child: Container(
                                        height: 58,
                                        //width: 130,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.black26),
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                          color: Colors.white
                                        ),

                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          //mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              height: 58,
                                              padding: EdgeInsets.only(left: 2),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1, color: Colors.black26),
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {

                                                },
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Image.asset(
                                                      country!.flag,
                                                      package: countryCodePackageName,
                                                      width: 30,
                                                    ),
                                                    SizedBox(
                                                      height: 16,
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                      '${country.callingCode}',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontSize: 15),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                ),
                                              )),
                                             /* CountryPicker(
                                                dense: false,

                                                dialingCodeTextStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                showFlag:
                                                true, //displays flag, true by default
                                                showDialingCode:
                                                true, //displays dialing code, false by default
                                                showName:
                                                false, //displays country name, true by default
                                                showCurrency: false, //eg. 'British pound'
                                                showCurrencyISO: false, //eg. 'GBP'
                                                onChanged: (Country country) {
                                                  setState(() {
                                                    _selected = country;
                                                    countryCode =
                                                        _selected!.dialingCode.toString();
                                                    print(
                                                        _selected!.dialingCode.toString());
                                                  });
                                                },
                                                selectedCountry: _selected,
                                              ),*/
                                           // ),
                                           /* CountryCodePickerX(
                                              onChanged: (value) {
                                                countryCode=value.toString();
                                              },
                                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                              initialSelection: 'IN',
                                              favorite: ['+39', 'FR'],
                                              // optional. Shows only country name and flag
                                              showCountryOnly: false,
                                              //showDropDownButton: true,

                                              // optional. Shows only country name and flag when popup is closed.
                                              showOnlyCountryWhenClosed: false,
                                              flagWidth: 20.0,
                                              // padding: EdgeInsets.all(10.0),
                                              alignLeft: false,
                                              searchDecoration: InputDecoration(
                                                  hintText: 'Select Country',
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                      const BorderSide(
                                                          width: 1,
                                                          color:
                                                          Colors.black),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10.0))),
                                            ),*/
                                          ],
                                        )

                                      // ],
                                      // ),
                                      //),
                                    ),
                                  ),
                        Expanded(
                          flex: 2,
                                  child: Container(
                                    margin:
                                    EdgeInsets.only(left: 0.0, right: 25),
                                    //padding: EdgeInsets.only(bottom: 3.0),
                                    //height: 58,
                                   /* width: MediaQuery.of(context).size.width /
                                        1.58,*/
                                    child: TextFormField(
                                      // controller: _usernm,
                                      controller: _usermbl,
                                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color:  Color.fromARGB(255, 0, 91, 148),fontFamily: 'assets\fonst\Metropolis-Black.otf'),
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
                                        hintStyle:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')?.copyWith(color: Colors.black45),
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
                                              msg:
                                              'Please Enter Correct Number');
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
                                  )
                        )
                                ],
                              ),
                            ),

                            Padding(
                              padding:
                              EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 15.0),
                              child: TextFormField(
                                controller: _bussabout,
                                keyboardType: TextInputType.multiline,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                                maxLines: 4,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    hintText: "Message*",
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintStyle:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                        ?.copyWith(color: Colors.black45),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: _color9),
                                        borderRadius:
                                        BorderRadius.circular(10.0)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: _color9),
                                        borderRadius:
                                        BorderRadius.circular(10.0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: _color9),
                                        borderRadius:
                                        BorderRadius.circular(10.0))

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
                                  color: Color.fromARGB(255, 0, 91, 148)
                              ),
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
                                child:  Text('Submit', style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w800,color: Colors.white,fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                              ),
                            ),

                            load==true?Container(
                         margin:  EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                          height: 210,
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            image: DecorationImage(
                              image: AssetImage("assets/contactus_back.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 10,
                                left: 20,
                                child: Container(

                                  color: Color.fromARGB(0,255, 255, 255),
                                  child: Text('Our Location', style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf').copyWith(fontSize: 16)),




                                  ),
                                ),

                              Positioned(
                                top: 40,
                                left: 20,
                                child: Container(

                                  color: Color.fromARGB(0,255, 255, 255),
                                  child:  SizedBox(
                                    height: 85,
                                    width: 150,
                                    child: Html(data: location)



                                  )
                                  ),
                                ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(

                                  color: Color.fromARGB(0,255, 255, 255),
                                  child: Center(
                                      child: Image.asset('assets/plastic4trade logo final.png',width: 100,height: 30,)
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Container(

                                  color: Color.fromARGB(0,255, 255, 255),
                                  child: Center(
                                      child: Image.asset('assets/contactus_loc.png',width: 200,height: 30,)
                                  ),
                                ),
                              ),
                            ],
                          )
                         ):  Center(
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
                            Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),

                                padding: EdgeInsets.fromLTRB(5.0, 5.0, 8.0, 0.0),
                                child: Column(mainAxisSize: MainAxisSize.min, children: [
                                  Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                      child:  Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            Container(
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
                                                              padding:
                                                              EdgeInsets.only(left: 20.0),
                                                              child: Text(countryCode.toString()+phone.toString(),
                                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf')),
                                                            ),
                                                          ),




                                                        ]))),
                                            IconButton(onPressed: () {

                                            }, icon: Image.asset('assets/call1.png'))
                                          ]))])
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                                padding: EdgeInsets.fromLTRB(5.0, 5.0, 8.0, 0.0),
                                child: Column(mainAxisSize: MainAxisSize.min, children: [
                                  Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                      child:  Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            Container(
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
                                                              padding:
                                                              EdgeInsets.only(left: 20.0),
                                                              child: Text(email.toString(),
                                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf')),
                                                            ),
                                                          ),




                                                        ]))),
                                            IconButton(onPressed: () {

                                            }, icon: Image.asset('assets/msg1.png'))
                                          ]))])
                            ),
                            Container(
                                margin:
                                EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 15.0),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                    color: Colors.white),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text('Follow Plastic4trade',
                                        style: TextStyle(fontWeight:FontWeight.w400,fontStyle: FontStyle.italic, fontFamily: 'assets\fonst\Metropolis-Black.otf' ,color: Colors.black),),
                                    ),
                                    Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 70,
                                        padding: EdgeInsets.fromLTRB(5.0, 5.0, 8.0, 0.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(onTap: () {

                                            }, child: Image.asset('assets/whatsapp.png',width: 30,height: 30,)),
                                            InkWell(onTap: () {

                                            }, child: Image.asset('assets/facebook.png',width: 30,height: 30)),
                                            InkWell(onTap: () {

                                            }, child: Image.asset('assets/instagram.png',width: 30,height: 30)),
                                            InkWell(onTap: () {

                                            }, child: Image.asset('assets/linkdin.png',width: 30,height: 30)),
                                            InkWell(onTap: () {

                                            }, child: Image.asset('assets/youtube.png',width: 30,height: 30)),
                                            InkWell(onTap: () {

                                            }, child:Image.asset('assets/Telegram.png',width: 30,height: 30)),
                                            InkWell(onTap: () {

                                            }, child: Image.asset('assets/Twitter.png',width: 30,height: 30)),
                                          ],
                                        )
                                    ),
                                  ],
                                )
                            ),

                          ],
                        ),
                      )
                    ])))));
  }
  Widget select_sub_dropdown(List listitem, String hint) {
    return Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 0.0),
          child: Container(

              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white),
              child: DropdownButton(
                value: _selectitem,
                hint: Text(hint,
                    style:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                        ?.copyWith(color: Colors.black45)),
                dropdownColor: Colors.white,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 30,
                isExpanded: true,
                underline: SizedBox(),
                items: listitem.map((valueItem) {
                  return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem,
                          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectitem = value.toString();
                  });
                },
              )),
        ));
  }

/*  Widget _buildDropdownItem(Country country) => Container(
    width: MediaQuery.of(context).size.width / 3.5,
    height: 120,
    child: Row(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: CountryPickerUtils.getDefaultFlagImage(country),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Text(
            "+${country.phoneCode}",
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'assets\fonst\Metropolis-Black.otf'),
          ),
        ),
      ],
    ),
  );*/

  vaild_data() {
    _isValid = EmailValidator.validate(_bussemail.text);
    var numValue = _usermbl.text.length;
    if (numValue <= 6) {
      //_color6 = Colors.green.shade600;
      setState(() {
        _color6 = Colors.red;
        Fluttertoast.showToast(
            msg:
            'Please Enter Correct Number ');
      });
    } else if (numValue   >= 14 ){
      setState(() {
        _color6 = Colors.red;
        Fluttertoast.showToast(
            msg:
            'Please Enter Correct Number ');
      });
    }
      else if (_selectitem==null) {
      Fluttertoast.showToast(msg: "Please Select Select Subject  ");
    } else if (_usernm.text.isNotEmpty &&
        _bussemail.text.isNotEmpty &&
        _usermbl.text.isNotEmpty &&
        _bussnm.text.isNotEmpty &&
        _isValid ) {
      if (Platform.isAndroid) {
        // Android-specific code
        device_name = 'android';
      } else if (Platform.isIOS) {
        device_name = 'ios';
      }
      setContact();
    }
      //_registerApi();
    // }else {
    //   setState(() {
    //     _color6 = Colors.red;
    //     Fluttertoast.showToast(
    //         msg:
    //         'Please Enter Correct Number');
    //   });
    //
    // }
  }

  setContact() async {
    common_par register = common_par();


    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await add_contact(
    _pref.getString('user_id').toString(),
    _pref.getString('api_token').toString(),
        _selectitem.toString(),
        _usernm.text.toString(),
        _bussemail.text.toString(),
        countryCode.toString(),
        _usermbl.text.toString(),
        _bussabout.text.toString(),
    _bussnm.text.toString(),
        device_name.toString()
       );
    String? msg = res['message'];
    Fluttertoast.showToast(msg: "$msg");
    if (res['status'] == 1) {
      register = common_par.fromJson(res);
      print(res);

      Fluttertoast.showToast(msg: res['message']);

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
      //isprofile=true;
    } else {

      get_ContactDetails();
      // get_data();
    }
  }
  Future<void> get_ContactDetails() async {
    getContact_Detail getsimmilar = getContact_Detail();
    SharedPreferences _pref = await SharedPreferences.getInstance();



    var res = await getContactDetails(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = getContact_Detail.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];



        //
        // for (var data in jsonarray) {

        location=jsonarray['location'];
        countryCode=jsonarray['countryCode'];
        phone=jsonarray['phone'];
        countryCode=jsonarray['countryCode'];
        email=jsonarray['email'];

        /*videolist.add(link);
          videocontent.add(content);*/
        //loadmore = true;
        //}
        load=true;

        if (mounted) {
          setState(() {

          });
        }
      }else{
        load=true;
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
    setState(() {});
  }
}
