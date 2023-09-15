import 'package:country_calling_code_picker/picker.dart';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/model/common.dart';
import 'package:Plastic4trade/screen/HomePage.dart';
import 'package:Plastic4trade/screen/LoginScreen.dart';
import 'package:Plastic4trade/screen/OtpScreen.dart';
import 'package:Plastic4trade/widget/MainScreen.dart';
import 'package:slide_switcher/slide_switcher.dart';
import '../api/api_interface.dart';
import 'RegisterScreen.dart';
import 'package:email_validator/email_validator.dart';

class ForgetPasswprd extends StatefulWidget {
  const ForgetPasswprd({super.key});

  @override
  State<ForgetPasswprd> createState() => _ForgetPasswprdState();
}

class _ForgetPasswprdState extends State<ForgetPasswprd> with SingleTickerProviderStateMixin  {
  TextEditingController _useremail = TextEditingController();
  TextEditingController _usermbl = TextEditingController();
  Color _color2 = Colors.black26;
  Color _color3 = Colors.black26;
  late AnimationController _animationController;
  /* late TabController _tabController;
  late PageController _pageController;*/
  int switcherIndex2 = 0;
  String country_code = '+91';
  bool _isValid = false;
  String defaultCountryCode = 'IN';
  //PhoneNumber number = PhoneNumber(isoCode: 'IN');
  Country? _selectedCountry;
  BuildContext? dialogContext;
  bool isloading=false;
  @override
  void initState() {
    /*  _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(initialPage: 0);*/
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    initCountry();
    super.initState();
  }
  @override
  void dispose() {
    _animationController.dispose();
    // TODO: implement dispose
    super.dispose();
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
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 218, 218, 218),


      body: Container(
        // height: MediaQuery.of(context).size.height,
        child: SafeArea(
            top: true,
            left: true,
            right: true,
            bottom: true,
            maintainBottomViewPadding: true,
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                header(),

                const SizedBox(
                  height: 10,
                ),
                SlideSwitcher(

                  containerColor: Color.fromARGB(255, 0, 91, 148),
                  onSelect: (int index) =>
                      setState(() => switcherIndex2 = index),
                  containerHeight: 40,
                  containerWight: 350,

                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontWeight: switcherIndex2 == 0
                            ? FontWeight.w500
                            : FontWeight.w400,
                        color: switcherIndex2 == 0
                            ? Color.fromARGB(255, 0, 91, 148)
                            : Colors.white,
                      ),
                    ),
                    Text(
                      'Moblie',
                      style: TextStyle(
                        fontWeight: switcherIndex2 == 1
                            ? FontWeight.w500
                            : FontWeight.w400,
                        color: switcherIndex2 == 1
                            ? Color.fromARGB(255, 0, 91, 148)
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
                switcherIndex2 == 0 ? email_otp() : phone_otp()
                //_subtabSection(context),

                //  ExpandablePageView(

                // second tab bar view widget
              ]),
            ))),
      ),
      bottomNavigationBar: Container(
        // margin: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 25.0),
        child: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          child: const Text('Log in',
              style:  TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 0, 91, 148),
                  fontFamily: 'assets\fonst\Metropolis-Black.otf')),
        ),
      ),
    );
  }

  Widget email_otp() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 10.0),
          child: TextFormField(
            controller: _useremail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontFamily: 'assets\fonst\Metropolis-Black.otf'),
            decoration: InputDecoration(
              hintText: "Enter Your Email",
              hintStyle: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Metropolis',
                  color: Colors.black),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: _color2),
                  borderRadius: BorderRadius.circular(10.0)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: _color2),
                  borderRadius: BorderRadius.circular(10.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: _color2),
                  borderRadius: BorderRadius.circular(10.0)),
              //errorText: _validusernm ? 'Name is not empty' : null),
            ),
            /*validator: (value) {
              if (value!.isEmpty) {
                WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                //Fluttertoast.showToast(msg: 'Please Enter Your Email');
                Fluttertoast.showToast(msg: 'Please Enter Your Email');
                //return '';
              } else {
                // setState(() {
                _color2 = Colors.green.shade600;
                //});
              }

              return null;
            },*/
            onFieldSubmitted: (value) {
              if (value.isEmpty) {
                WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                Fluttertoast.showToast(msg: 'Please Enter Your Email');
                _color2 = Colors.red;
              } else {
                if(!EmailValidator.validate(_useremail.text)){
                  _color2 = Colors.red;
                  setState(() {

                  });
                  Fluttertoast.showToast(msg: 'Please Enter Correct Email');
                }else{
                  _color2 = Colors.green.shade600;
                }
                // setState(() {

                //});
              }
            },
            onChanged: (value) {
              if (value.isEmpty) {
                WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                Fluttertoast.showToast(msg: 'Please Enter Your Email');
                //Fluttertoast.showToast(msg: 'Please Enter Your Email');
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
        const SizedBox(
          height: 10.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(50.0),
              color: const Color.fromARGB(255, 0, 91, 148)),
          child: TextButton(
            onPressed: () {
              _isValid = EmailValidator.validate(_useremail.text);
              if (_useremail.text.isNotEmpty) {
                if (_isValid) {
                  _onLoading();
                  get_otp('', '', _useremail.text.toString()).then((value) {
                    Navigator.of(dialogContext!).pop();
                    if (value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => otp(
                                phone: '',
                                countrycode:'',
                                email: _useremail.text.toString(),
                              )));
                    } else { }
                  });
                } else {
                  setState(() {
                    _color2 = Colors.red;
                  });
                  WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                  Fluttertoast.showToast(msg: 'Please Enter Correct Email');
                }
                print(_useremail.text);
              } else {
                Fluttertoast.showToast(msg: 'Please Enter Your Email');
                setState(() {
                  _color2 = Colors.red;
                });
              }
            },
            child: const Text('Submit',
                style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'assets\fonst\Metropolis-Black.otf')),
          ),
        ),
      ],
    );
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
    /*  final country =
    await Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return PickerPage();
    }));
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }*/
  }

  Widget phone_otp() {
    final country = _selectedCountry;
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,

      children: [
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Container(
                height: 55,
                //width: MediaQuery.of(context).size.width / 3.7,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black26),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.fromLTRB(25.0, 5.0, 5.0, 5.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _onPressedShowBottomSheet();
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
                              width: 5,
                            ),
                          ],
                        ),
                      )
                      /* new Expanded(

                          child:
                          CountryCodePickerX(
                              onChanged: (value) {
                                country_code=value.toString();
                                print(country_code);
                              },
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection: 'IN',
                              favorite: ['+39','FR'],

                              // optional. Shows only country name and flag
                              showCountryOnly: false,
                              //showDropDownButton: true,

                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: false,
                              flagWidth: 20.0,
                              textStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.black),



                              // padding: EdgeInsets.all(10.0),
                              alignLeft: false,
                              searchDecoration: InputDecoration(
                                  hintText: 'Select Country',
                                  border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(width: 1, color: Colors.black),
                                      borderRadius:
                                      BorderRadius.circular(10.0))
                              )
                          ),
                          flex: 8),*/
                    ],
                  ),
                )

                // ],
                // ),
                //),
                ),
            Expanded(
              flex: 2,
              child: Container(
                //padding: EdgeInsets.only(bottom: 3.0),
                height: 57,
                /*width: MediaQuery.of(context).size.width /
                                          1.58,*/
                margin: EdgeInsets.only(right: 25),
                child: TextFormField(
                  // controller: _usernm,
                  controller: _usermbl,
                  style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 0, 91, 148),
                      fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(11),
                  ],
                  keyboardType: TextInputType.phone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    // labelText: 'Your phone *',
                    // labelStyle: TextStyle(color: Colors.red),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Mobile Number",
                    hintStyle: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontFamily: 'assets\fonst\Metropolis-Black.otf')
                        ?.copyWith(color: Colors.black45),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: _color3),
                        borderRadius: BorderRadius.circular(10.0)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: _color3),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: _color3),
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  /*validator: (value) {
                    if (value!.isEmpty) {
                      // Fluttertoast.showToast(msg:'Enter a Mobile Number!');
                      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                      Fluttertoast.showToast(msg: 'Please Enter Your Number');
                      _color3 = Colors.red;
                      // return '';
                    } else {
                      // setState(() {
                      _color3 = Colors.green.shade600;
                      //});
                    }

                    return null;
                  },*/
                  onFieldSubmitted: (value) {
                    var numValue = value.length;
                    if (numValue >= 6 && numValue < 12) {
                      _color3 = Colors.green.shade600;
                    } else {
                      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                      _color3 = Colors.red;
                      Fluttertoast.showToast(
                          msg: 'Please Enter Correct Number');
                      setState(() {

                      });
                    }
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      /* Fluttertoast.showToast(
                          msg:
                          'Please Your Mobile Number');*/
                      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                      Fluttertoast.showToast(msg: 'Please Enter Your Number');
                      setState(() {
                        _color2 = Colors.red;
                      });
                    } else {
                      setState(() {
                        _color3 = Colors.green.shade600;
                      });
                    }
                  },
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.0,
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
              if (_usermbl.text.isNotEmpty) {
                print(country_code);
                print(_usermbl.text.toString());
                var numValue = _usermbl.text.length;
                if (numValue >= 6 && numValue < 12) {
                  _color3 = Colors.green.shade600;
                  _onLoading();
                  print('======');
                  get_otp(country_code, _usermbl.text.toString(), '').then((value) {
                    Navigator.of(dialogContext!).pop();
                    if (value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => otp(
                                phone: _usermbl.text.toString(),
                                countrycode:country_code,
                                email: '',
                              )));
                    } else {

                    }
                  });
                } else {
                  setState(() {
                    _color3 = Colors.red;
                  });

                  Fluttertoast.showToast(msg: 'Please Enter Correct Number');
                }
              } else {

                //Fluttertoast.showToast(msg: 'Moblie Number  is Required');
                Fluttertoast.showToast(msg: 'Please Enter Your Number');
                setState(() {
                  _color3 = Colors.red;
                });
              }
            },
            child: Text('Submit',
                style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'assets\fonst\Metropolis-Black.otf')),
          ),
        ),
      ],
    );
  }

  Future<bool> get_otp(conutry_code, phone, email) async {
    common_par login = common_par();

    var res = await forgotpassword_ME(phone, country_code, email);
   // String? msg = res['message'];
    //Fluttertoast.showToast(msg: "$msg");
    if (res['status'] == 1) {
      login = common_par.fromJson(res);
      isloading=true;
      Fluttertoast.showToast(msg: res['message']);


    } else {
      isloading=false;
      Fluttertoast.showToast(msg: res['message']);
    }
    return isloading;
  }

  Widget header() {
    return Column(children: [
      Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          child: Image.asset('assets/back.png', height: 50, width: 60),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),

      Image.asset(
        'assets/forgetPassword.png',
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 3.2,
        height: 170,
      ),
      const SizedBox(
        height: 35.0,
        child: Text('Forgot password?',
            style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontFamily: 'assets\fonst\Metropolis-Black.otf')),
      ),

      Container(
        height: 20.0,
        width: MediaQuery.of(context).size.width / 1.09,
        //padding: EdgeInsets.symmetric(horizontal: 10),

        child: Text('Enter your email/Moblie  for verification process',
            //maxLines: 2,
            style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'assets\fonst\Metropolis-Black.otf')
                ?.copyWith(fontWeight: FontWeight.w400)),
      ),

      //alignment: Alignment.center,

      Container(
        height: 40.0,
        width: MediaQuery.of(context).size.width / 1.09,
        //padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text('we will send 4 digits code to your email/Moblie',
            //maxLines: 2,
            style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'assets\fonst\Metropolis-Black.otf')
                ?.copyWith(fontWeight: FontWeight.w400)),
      ),
    ]);
  }
}
