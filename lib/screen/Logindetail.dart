import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_interface.dart';
import '../model/common.dart';
import '../model/getUserProfile.dart';
import '../widget/MainScreen.dart';
import 'Bussinessinfo.dart';

class LoginDetail extends StatefulWidget {
  const LoginDetail({Key? key}) : super(key: key);

  @override
  State<LoginDetail> createState() => _LoginDetailState();
}

class _LoginDetailState extends State<LoginDetail> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController _bussmbl = TextEditingController();
  TextEditingController _bussemail = TextEditingController();
  TextEditingController _currentpass = TextEditingController();
  TextEditingController _newpass = TextEditingController();
  TextEditingController _confirpass = TextEditingController();
  TextEditingController _mblotp = TextEditingController();
  TextEditingController _emailotp = TextEditingController();
  bool _isValid = false;
  bool _passwordVisible = false;
  bool _cpasswordVisible = false;
  bool _cfrpasswordVisible = false;
  bool isloading1 = false;
  String? email, countrycode1, countrycode, phoneno;
  Color _color6 = Colors.black45;
  Color _color7 = Colors.black45;
  Color _color1 = Colors.black45;
  Color _color4 = Colors.black45;
  Color _color5 = Colors.black45;
  Color _color3 = Colors.black45;

  int mbl_otp = 0;
  int email_otp = 0;

  Country? _selected;
  bool? otp_sent;
  bool edit_mbl = false, edit_email = false, edit_pass = false;
  String defaultCountryCode = 'IN';

  //PhoneNumber number = PhoneNumber(isoCode: 'IN');
  Country? _selectedCountry, defaultCountry;
  bool isloading = false;
  BuildContext? dialogContext;
  bool _isResendButtonEnabled = false;
  bool _isResendButtonEnabled1 = false;

  Timer? _timer;
  int _countdown = 30;


  int _countdown1 = 30;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCountry();
    getBussinessProfile();
  }

  void _onPressedShowBottomSheet() async {
    final country = await showCountryPickerSheet(
      context,
      cornerRadius: BorderSide.strokeAlignInside,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
        countrycode1 = country.callingCode.toString();
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

  void initCountry() async {
    final country = await getCountryByCountryCode(context, defaultCountryCode);
    setState(() {
      _selectedCountry = country;
    });

    // Navigate to the PickerPage and pass the selected country

    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  Future<String> getCountryFromCallingCode(String callingCode) async {
    List<Country> list = await getCountries(context);
    for (var country in list) {
      if (country.callingCode == callingCode) {
        defaultCountry = country;
        _selectedCountry = country;
        return country.flag;
      }
    }
    return 'Country not found'; // Default return value if the calling code is not found
  }

  @override
  Widget build(BuildContext context) {
    return initwidget();
  }

  getBussinessProfile() async {
    getUserProfile getprofile = getUserProfile();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    print(_pref.getString('user_id').toString());
    print(_pref.getString('api_token').toString());
    var res = await getuser_Profile(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());
    print(res);

    if (res['status'] == 1) {
      getprofile = getUserProfile.fromJson(res);

      var jsonarray = res['user'];

      print(jsonarray['image_url']);
      email = jsonarray['email'];
      countrycode = jsonarray['countryCode'];
      phoneno = jsonarray['phoneno'];
      print(phoneno); // for (var data in jsonarray) {
      getCountryFromCallingCode(countrycode!);
      //print();
      setState(() {});
      isloading = true;
      // buss.add(record);
      // }
    } else {
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
    }

    // setState(() {});
    // print(constanst.btype_data);
  }

  Widget initwidget() {
    final country = _selectedCountry;
    final country1 = defaultCountry;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromARGB(255, 218, 218, 218),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: const Text('Login Details',
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
        body: SingleChildScrollView(
            child: Column(children: [
          Column(children: [
            Form(
                key: _formKey,
                child: Container(
                    // height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(bottom: 10.0, top: 20),
                    child: Column(children: [
                      SafeArea(
                        top: true,
                        left: true,
                        right: true,
                        maintainBottomViewPadding: true,
                        child: isloading
                            ? Column(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          20.0, 0.0, 20.0, 10.0),
                                      padding: const EdgeInsets.fromLTRB(
                                          5.0, 5.0, 5.0, 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border:
                                            Border.all(color: Colors.black26),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0.0, 5.0, 0.0, 0.0),
                                                      child: Text(
                                                        'Phone Number               ',
                                                        style: const TextStyle(
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'assets\fonst\Metropolis-Black.otf')
                                                            ?.copyWith(
                                                                color: Colors
                                                                    .black45),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3.0,
                                                  ),
                                                  Row(
                                                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Image.asset(
                                                              country1!.flag,
                                                              package:
                                                                  countryCodePackageName,
                                                              width: 30,
                                                            ),
                                                            const SizedBox(
                                                              height: 16,
                                                            ),
                                                            const SizedBox(
                                                              width: 2,
                                                            ),
                                                            Text(
                                                              '$countrycode',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: const TextStyle(
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'assets\fonst\Metropolis-Black.otf')
                                                                  ?.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                            ),
                                                            const SizedBox(
                                                              width: 2,
                                                            ),
                                                          ],
                                                        ),
                                                        Text(phoneno.toString(),
                                                            style: const TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'assets\fonst\Metropolis-Black.otf')
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                      ]),
                                                  const SizedBox(
                                                    height: 3.0,
                                                  ),
                                                ]),
                                                edit_mbl
                                                    ? Center(
                                                        child: Align(
                                                          child: TextButton(
                                                            child: Text(
                                                                'Cancel',
                                                                style: const TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'assets\fonst\Metropolis-Black.otf')
                                                                    ?.copyWith(
                                                                        color: Colors
                                                                            .red)),
                                                            onPressed: () {
                                                              setState(() {
                                                                edit_mbl =
                                                                    false;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    : Center(
                                                        child: Align(
                                                          child: TextButton(
                                                            child: const Text(
                                                                'Edit'),
                                                            onPressed: () {
                                                              setState(() {
                                                                edit_mbl = true;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      )
                                              ]),
                                          Visibility(
                                              visible: edit_mbl,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                          height: 55,
                                                          //width: 130,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black45),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          margin:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  5.0,
                                                                  5.0,
                                                                  5.0,
                                                                  5.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            //mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              GestureDetector(
                                                                child: Row(
                                                                  children: [
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Image.asset(
                                                                      country!
                                                                          .flag,
                                                                      package:
                                                                          countryCodePackageName,
                                                                      width: 30,
                                                                    ),
                                                                    const SizedBox(
                                                                      height:
                                                                          16,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 2,
                                                                    ),
                                                                    Text(
                                                                      country
                                                                          .callingCode,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                  ],
                                                                ),
                                                                onTap: () {
                                                                  _onPressedShowBottomSheet();
                                                                },
                                                              )
                                                            ],
                                                          )),


                                                      Container(
                                                        //padding: EdgeInsets.only(bottom: 3.0),
                                                        height: 57,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.68,
                                                        margin: const EdgeInsets.only(
                                                            bottom: 0.0),
                                                        child: TextFormField(
                                                          // controller: _usernm,
                                                          controller: _bussmbl,
                                                          style: const TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-Black.otf'),
                                                          inputFormatters: [
                                                            LengthLimitingTextInputFormatter(
                                                                13),
                                                          ],
                                                          keyboardType:
                                                              TextInputType
                                                                  .phone,
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          decoration:
                                                              InputDecoration(
                                                            // labelText: 'Your phone *',
                                                            // labelStyle: TextStyle(color: Colors.red),
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            hintText:
                                                                "New Mobile Number",
                                                            hintStyle: const TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'assets\fonst\Metropolis-Black.otf')
                                                                ?.copyWith(
                                                                    color: Colors
                                                                        .black45),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        width:
                                                                            1,
                                                                        color:
                                                                            _color6),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0)),
                                                            border: OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        width:
                                                                            1,
                                                                        color:
                                                                            _color6),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0)),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        width:
                                                                            1,
                                                                        color:
                                                                            _color6),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0)),
                                                          ),
                                                          onFieldSubmitted:
                                                              (value) {
                                                            var numValue =
                                                                value.length;
                                                            if (numValue >= 6 &&
                                                                numValue < 13) {
                                                              _color6 = Colors
                                                                  .green
                                                                  .shade600;
                                                            } else {
                                                              _color6 =
                                                                  Colors.red;
                                                              WidgetsBinding
                                                                  .instance
                                                                  ?.focusManager
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'Please Enter Correct Number');
                                                            }
                                                          },
                                                          onChanged: (value) {
                                                            if (value.isEmpty) {
                                                              WidgetsBinding
                                                                  .instance
                                                                  ?.focusManager
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'Please Your Mobile Number');
                                                              setState(() {
                                                                _color6 =
                                                                    Colors.red;
                                                              });
                                                            } else {
                                                              setState(() {
                                                                _color6 = Colors
                                                                    .green
                                                                    .shade600;
                                                              });
                                                            }
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  mbl_otp == 1
                                                      ? Column(
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  1.2,
                                                              height: 60,
                                                              margin:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      20.0),
                                                              decoration: BoxDecoration(
                                                                  border: Border
                                                                      .all(
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
                                                                          148)
                                                                      .withOpacity(
                                                                          0.8)),
                                                              // Set the height of the container
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: _isResendButtonEnabled &&
                                                                      _countdown !=
                                                                          0
                                                                  ? Text(
                                                                      '0:$_countdown',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                        color: Colors
                                                                            .white,
                                                                        fontFamily:
                                                                            'assets\fonst\Metropolis-Black.otf',
                                                                      )?.copyWith(
                                                                              fontWeight: FontWeight.w800,
                                                                              fontSize: 17),
                                                                    )
                                                                  : TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        /*Navigator.push(
                                                            context, MaterialPageRoute(builder: (context) => bussinessprofile()));*/

                                                                        var numValue = _bussmbl
                                                                            .text
                                                                            .length;
                                                                        WidgetsBinding
                                                                            .instance
                                                                            ?.focusManager
                                                                            .primaryFocus
                                                                            ?.unfocus();
                                                                        if (_bussmbl
                                                                            .text
                                                                            .isEmpty) {
                                                                          setState(
                                                                              () {
                                                                            _color6 =
                                                                                Colors.red;
                                                                            Fluttertoast.showToast(msg: 'Please Your Mobile Number');
                                                                          });
                                                                        } else if (numValue >=
                                                                                6 &&
                                                                            numValue <
                                                                                13) {
                                                                          _color6 = Colors
                                                                              .green
                                                                              .shade600;
                                                                          WidgetsBinding
                                                                              .instance
                                                                              ?.focusManager
                                                                              .primaryFocus
                                                                              ?.unfocus();

                                                                          _onLoading();
                                                                          await update_phone()
                                                                              .then((value) {
                                                                            print('dsefef $value');
                                                                            Navigator.of(dialogContext!).pop();
                                                                            if (value) {
                                                                              /* Navigator.push(
                                                          context, MaterialPageRoute(builder: (context) => Bussinessinfo()));*/

                                                                              _startTimer();
                                                                            } else {
                                                                              /*  Navigator.push(
                                                          context, MaterialPageRoute(builder: (context) => Bussinessinfo()));*/
                                                                            }
                                                                          });
                                                                          isloading1 =
                                                                              false;
                                                                        } else {
                                                                          _color6 =
                                                                              Colors.red;

                                                                          Fluttertoast.showToast(
                                                                              msg: 'Please Enter Correct Number');
                                                                        }
                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      child: const Text(
                                                                          'Resend OTP',
                                                                          style: TextStyle(
                                                                              fontSize: 19.0,
                                                                              fontWeight: FontWeight.w800,
                                                                              color: Colors.white,
                                                                              fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                                                                    ),
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets
                                                                  .fromLTRB(
                                                                      25.0,
                                                                      0.0,
                                                                      25.0,
                                                                      0.0),
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    _mblotp,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'assets\fonst\Metropolis-Black.otf'),
                                                                autovalidateMode:
                                                                    AutovalidateMode
                                                                        .onUserInteraction,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .next,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      "Enter OTP",
                                                                  hintStyle: const TextStyle(
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'assets\fonst\Metropolis-Black.otf'),
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              _color1),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0)),
                                                                  border: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              _color1),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0)),
                                                                  focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              _color1),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15.0)),
                                                                  //errorText: _validusernm ? 'Name is not empty' : null),
                                                                ),
                                                                validator:
                                                                    (value) {
                                                                  if (value!
                                                                      .isEmpty) {
                                                                    _color1 =
                                                                        Colors
                                                                            .red;
                                                                    //return 'Enter a otp!';
                                                                  } else {
                                                                    // setState(() {
                                                                    _color1 = Colors
                                                                        .green
                                                                        .shade600;
                                                                    // });
                                                                  }
                                                                  return null;
                                                                },
                                                                onChanged:
                                                                    (value) {
                                                                  if (value
                                                                      .isEmpty) {
                                                                    WidgetsBinding
                                                                        .instance
                                                                        ?.focusManager
                                                                        .primaryFocus
                                                                        ?.unfocus();
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                'Please Enter otp');
                                                                    setState(
                                                                        () {
                                                                      _color1 =
                                                                          Colors
                                                                              .red;
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      _color1 = Colors
                                                                          .green
                                                                          .shade600;
                                                                    });
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  1.2,
                                                              height: 60,
                                                              margin: const EdgeInsets
                                                                  .all(20.0),
                                                              decoration: BoxDecoration(
                                                                  border: Border
                                                                      .all(
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
                                                                onPressed: () {
                                                                  setState(
                                                                      () async {

                                                                    WidgetsBinding
                                                                        .instance
                                                                        ?.focusManager
                                                                        .primaryFocus
                                                                        ?.unfocus();
                                                                   if(_mblotp.text.isEmpty){
                                                                     Fluttertoast.showToast(msg: "Please Enter OTP");
                                                                     _color1 = Colors.red;

                                                                   }else{



                                                                     // _onLoading();
                                                                     await register_mo_verifyotp(
                                                                         _mblotp.text
                                                                             .toString(),
                                                                         _bussmbl.text
                                                                             .toString(),
                                                                         "3")
                                                                         .then(
                                                                             (value) {
                                                                           print(
                                                                               'dsefef $value');
                                                                           Navigator.of(
                                                                               dialogContext!)
                                                                               .pop();
                                                                           if (value) {}
                                                                         });

                                                                     isloading1 = false;
                                                                   }

                                                                  });
                                                                },
                                                                child: const Text(
                                                                    'Verify',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            19.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w800,
                                                                        color: Colors
                                                                            .white,
                                                                        fontFamily:
                                                                            'assets\fonst\Metropolis-Black.otf')),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Container(
                                                          width: MediaQuery.of(context).size.width * 1.2,
                                                          height: 60,
                                                          margin:
                                                              const EdgeInsets.all(
                                                                  20.0),
                                                          decoration: BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                      width: 1),
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
                                                              /*Navigator.push(
                                                            context, MaterialPageRoute(builder: (context) => bussinessprofile()));*/

                                                              var numValue =
                                                                  _bussmbl.text
                                                                      .length;
                                                              WidgetsBinding
                                                                  .instance
                                                                  ?.focusManager
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                              if (_bussmbl.text
                                                                  .isEmpty) {
                                                                setState(() {
                                                                  _color6 =
                                                                      Colors
                                                                          .red;
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              'Please Your Mobile Number');
                                                                });
                                                              } else if (numValue >=
                                                                      6 &&
                                                                  numValue <
                                                                      13) {
                                                                _color6 = Colors
                                                                    .green
                                                                    .shade600;
                                                                WidgetsBinding
                                                                    .instance
                                                                    ?.focusManager
                                                                    .primaryFocus
                                                                    ?.unfocus();

                                                                _onLoading();
                                                                await update_phone()
                                                                    .then(
                                                                        (value) {
                                                                  print(
                                                                      'dsefef $value');
                                                                  Navigator.of(
                                                                          dialogContext!)
                                                                      .pop();
                                                                  if (value) {
                                                                    /* Navigator.push(
                                                          context, MaterialPageRoute(builder: (context) => Bussinessinfo()));*/

                                                                    _startTimer();
                                                                  } else {
                                                                    /*  Navigator.push(
                                                          context, MaterialPageRoute(builder: (context) => Bussinessinfo()));*/
                                                                  }
                                                                });
                                                                isloading1 =
                                                                    false;
                                                              } else {
                                                                _color6 =
                                                                    Colors.red;

                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            'Please Enter Correct Number');
                                                              }
                                                              setState(() {});
                                                            },
                                                            child: const Text(
                                                                'Send OTP',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        19.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        'assets\fonst\Metropolis-Black.otf')),
                                                          ),
                                                        ),
                                                ],
                                              ))
                                        ],
                                      ),),


                                  Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        20.0, 0.0, 20.0, 10.0),
                                    padding: const EdgeInsets.fromLTRB(
                                        5.0, 5.0, 5.0, 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                    ),
                                    child: Column(children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IntrinsicWidth(
                                                child: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        10.0, 5.0, 0.0, 0.0),
                                                    child: Text(
                                                      'Email Address',
                                                      style: const TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-Black.otf')
                                                          ?.copyWith(
                                                              color: Colors
                                                                  .black45),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10.0, 2.0, 0.0, 2.0),
                                                  child: Text(email.toString(),
                                                      style: const TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-Black.otf')
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                )
                                              ],
                                            )),
                                            edit_email
                                                ? Center(
                                                    child: Align(
                                                      child: TextButton(
                                                        child: Text('Cancel',
                                                            style: const TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'assets\fonst\Metropolis-Black.otf')
                                                                ?.copyWith(
                                                                    color: Colors
                                                                        .red)),
                                                        onPressed: () {
                                                          setState(() {
                                                            edit_email = false;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                : Center(
                                                    child: Align(
                                                      child: TextButton(
                                                        child:
                                                            const Text('Edit'),
                                                        onPressed: () {
                                                          setState(() {
                                                            edit_email = true;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  )
                                          ]),
                                      Visibility(
                                          visible: edit_email,
                                          child: Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                20, 20, 20, 20),
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  // controller: _usernm,
                                                  controller: _bussemail,
                                                  style: const TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'assets\fonst\Metropolis-Black.otf'),

                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                    // labelText: 'Your phone *',
                                                    // labelStyle: TextStyle(color: Colors.red),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    hintText:
                                                        "New Email Address",
                                                    hintStyle: const TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'assets\fonst\Metropolis-Black.otf')
                                                        ?.copyWith(
                                                            color:
                                                                Colors.black45),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    width: 1,
                                                                    color:
                                                                        _color7),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0)),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: _color7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    12.0)),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    width: 1,
                                                                    color:
                                                                        _color7),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0)),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      //return 'Enter a Email!';
                                                      _color7 = Colors.red;
                                                    } else {
                                                      // setState(() {
                                                      _color7 =
                                                          Colors.green.shade600;
                                                      //});
                                                    }

                                                    return null;
                                                  },
                                                  onFieldSubmitted: (value) {},
                                                  onChanged: (value) {
                                                    if (value.isEmpty) {
                                                      WidgetsBinding
                                                          .instance
                                                          ?.focusManager
                                                          .primaryFocus
                                                          ?.unfocus();
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Please Your Email');
                                                      setState(() {
                                                        _color7 = Colors.red;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _color7 = Colors
                                                            .green.shade600;
                                                      });
                                                    }
                                                  },
                                                ),

                                                (email_otp == 1)
                                                    ? Column(
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                1.2,
                                                            height: 60,
                                                            margin:
                                                                const EdgeInsets.all(
                                                                    20.0),
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
                                                                        148)
                                                                    .withOpacity(
                                                                        0.8)),
                                                            // Set the height of the container
                                                            alignment: Alignment
                                                                .center,
                                                            child: (_isResendButtonEnabled1 &&
                                                                    _countdown1 !=
                                                                        0)
                                                                ? Text(
                                                                    '0:$_countdown1',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          15.0,
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'assets\fonst\Metropolis-Black.otf',
                                                                    )?.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                            fontSize: 17),
                                                                  )
                                                                : TextButton(
                                                                    onPressed: () {

                                                                      log("_isResendButtonEnabled1 = $_isResendButtonEnabled1");
                                                                      setState(
                                                                          () {
                                                                        _isValid =
                                                                            EmailValidator.validate(_bussemail.text);
                                                                        if (!_isValid) {
                                                                          WidgetsBinding
                                                                              .instance
                                                                              ?.focusManager
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                          Fluttertoast.showToast(
                                                                              msg: 'Enter Proper Email');
                                                                          _color7 =
                                                                              Colors.red;
                                                                        } else {
                                                                          WidgetsBinding
                                                                              .instance
                                                                              ?.focusManager
                                                                              .primaryFocus
                                                                              ?.unfocus();
                                                                          _onLoading();
                                                                          update_email()
                                                                              .then((value) {
                                                                            // isloading1=false;
                                                                            print('rgdrr$value');
                                                                            Navigator.of(dialogContext!).pop();
                                                                            _email_startTimer();
                                                                          });
                                                                        }
                                                                        isloading1 =
                                                                            false;
                                                                        Navigator.of(dialogContext!)
                                                                            .pop();
                                                                      });
                                                                    },
                                                                    child: const Text(
                                                                        'Resend OTP',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                19.0,
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                            color: Colors.white,
                                                                            fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                                                                  ),
                                                          ),
                                                          Container(
                                                            margin: const EdgeInsets
                                                                .fromLTRB(
                                                                    25.0,
                                                                    0.0,
                                                                    25.0,
                                                                    0.0),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  _emailotp,
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'assets\fonst\Metropolis-Black.otf'),
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    "Enter OTP",
                                                                hintStyle: const TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'assets\fonst\Metropolis-Black.otf'),
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color:
                                                                            _color1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.0)),
                                                                border: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color:
                                                                            _color1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.0)),
                                                                focusedBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color:
                                                                            _color1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.0)),
                                                                //errorText: _validusernm ? 'Name is not empty' : null),
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  _color7 =
                                                                      Colors
                                                                          .red;
                                                                  //return 'Enter a otp!';
                                                                } else {
                                                                  // setState(() {
                                                                  _color1 = Colors
                                                                      .green
                                                                      .shade600;
                                                                  // });
                                                                }
                                                                return null;
                                                              },
                                                              onChanged:
                                                                  (value) {
                                                                if (value
                                                                    .isEmpty) {
                                                                  WidgetsBinding
                                                                      .instance
                                                                      ?.focusManager
                                                                      .primaryFocus
                                                                      ?.unfocus();
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              'Please otp');
                                                                  setState(() {
                                                                    _color1 =
                                                                        Colors
                                                                            .red;
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    _color1 = Colors
                                                                        .green
                                                                        .shade600;
                                                                  });
                                                                }
                                                              },
                                                              onFieldSubmitted:
                                                                  (value) {
                                                                if (value
                                                                    .isEmpty) {
                                                                  WidgetsBinding
                                                                      .instance
                                                                      ?.focusManager
                                                                      .primaryFocus
                                                                      ?.unfocus();
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              'Please Enter otp');
                                                                  setState(() {
                                                                    _color1 =
                                                                        Colors
                                                                            .red;
                                                                  });
                                                                } else {
                                                                  setState(() {
                                                                    _color1 = Colors
                                                                        .green
                                                                        .shade600;
                                                                  });
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                1.2,
                                                            height: 60,
                                                            margin:
                                                                const EdgeInsets.all(
                                                                    20.0),
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
                                                              onPressed: () {

                                                                WidgetsBinding
                                                                    .instance
                                                                    ?.focusManager
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                                if(_emailotp.text.isEmpty){
                                                                  _color1 = Colors.red;
                                                                  Fluttertoast.showToast(msg: "Please Enter OTP");
                                                                }else{
                                                                  update_email_verifyotp(
                                                                      _emailotp
                                                                          .text
                                                                          .toString(),
                                                                      _bussemail
                                                                          .text
                                                                          .toString(),
                                                                      "2")
                                                                      .then(
                                                                          (value) {
                                                                        Navigator.of(
                                                                            dialogContext!)
                                                                            .pop();
                                                                      });
                                                                }
                                                                isloading1 =
                                                                    false;
                                                              },
                                                              child: const Text(
                                                                  'Verify',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          19.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'assets\fonst\Metropolis-Black.otf')),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            1.2,
                                                        height: 60,
                                                        margin: const EdgeInsets.all(
                                                            20.0),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0),
                                                            color:
                                                                const Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    91,
                                                                    148)),
                                                        child: TextButton(
                                                          onPressed: () {
                                                            /*Navigator.push(
                                                              context, MaterialPageRoute(builder: (context) => bussinessprofile()));*/

                                                            setState(() {
                                                              _isValid = EmailValidator
                                                                  .validate(
                                                                      _bussemail
                                                                          .text);
                                                              if (!_isValid) {
                                                                WidgetsBinding
                                                                    .instance
                                                                    ?.focusManager
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            'Enter Proper Email');
                                                                _color7 =
                                                                    Colors.red;
                                                              } else {
                                                                WidgetsBinding
                                                                    .instance
                                                                    ?.focusManager
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                                _onLoading();
                                                                update_email()
                                                                    .then(
                                                                        (value) {
                                                                  // isloading1=false;
                                                                  print(
                                                                      'rgdrr$value');
                                                                  Navigator.of(
                                                                          dialogContext!)
                                                                      .pop();
                                                                  _email_startTimer();
                                                                  /* if (value) {
                                                      */ /*Navigator.push(
                                                          context, MaterialPageRoute(builder: (context) => Bussinessinfo()));*/ /*
                                                    } else {
                                                     */ /* Navigator.push(
                                                          context, MaterialPageRoute(builder: (context) => Bussinessinfo()));*/ /*
                                                    }*/
                                                                });
                                                              }
                                                              isloading1 =
                                                                  false;
                                                              Navigator.of(
                                                                      dialogContext!)
                                                                  .pop();
                                                            });
                                                          },
                                                          child: Text(
                                                              'Send OTP',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      19.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'assets\fonst\Metropolis-Black.otf')),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          )),
                                    ]),
                                  ),


                                  Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          20.0, 0.0, 20.0, 20.0),
                                      padding: EdgeInsets.fromLTRB(
                                          5.0, 5.0, 5.0, 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border:
                                            Border.all(color: Colors.black26),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(children: [
                                                  Image.asset(
                                                    'assets/password.png',
                                                    width: 120,
                                                    height: 40,
                                                  )
                                                ]),
                                                edit_pass
                                                    ? Center(
                                                        child: Align(
                                                          child: TextButton(
                                                            child: Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'assets\fonst\Metropolis-Black.otf')
                                                                    ?.copyWith(
                                                                        color: Colors
                                                                            .red)),
                                                            onPressed: () {
                                                              setState(() {
                                                                edit_pass =
                                                                    false;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    : Center(
                                                        child: Align(
                                                          child: TextButton(
                                                            child: Text('Edit'),
                                                            onPressed: () {
                                                              setState(() {
                                                                edit_pass =
                                                                    true;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      )
                                              ]),


                                          Visibility(
                                              visible: edit_pass,
                                              child: Column(
                                                children: [


                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            25.0,
                                                            5.0,
                                                            25.0,
                                                            10.0),
                                                    child: TextFormField(
                                                      controller: _newpass,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      style: const TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'assets\fonst\Metropolis-Black.otf'),
                                                      obscureText:
                                                          !_cpasswordVisible,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        // labelText: 'Your Confirm Password',
                                                        // labelStyle: TextStyle(color: Colors.red),
                                                        hintText:
                                                            "New Password",
                                                        hintStyle: const TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'assets\fonst\Metropolis-Black.otf'),
                                                        suffixIcon: IconButton(
                                                          icon:
                                                              // Based on passwordVisible state choose the icon
                                                              _cpasswordVisible
                                                                  ? Image.asset(
                                                                      'assets/hidepassword.png')
                                                                  : Image.asset(
                                                                      'assets/Vector.png',
                                                                      width:
                                                                          20.0,
                                                                      height:
                                                                          20.0,
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
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        width:
                                                                            1,
                                                                        color:
                                                                            _color3),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0)),
                                                        border: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    width: 1,
                                                                    color:
                                                                        _color3),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        width:
                                                                            1,
                                                                        color:
                                                                            _color3),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0)),
                                                        //errorText: _validusernm ? 'Name is not empty' : null),
                                                      ),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          _color3 = Colors.red;
                                                        } else {
                                                          _color3 = Colors
                                                              .green.shade600;
                                                        }
                                                      },
                                                      onChanged: (value) {
                                                        if (value.isEmpty) {
                                                          WidgetsBinding
                                                              .instance
                                                              ?.focusManager
                                                              .primaryFocus
                                                              ?.unfocus();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Please Enter New Password');
                                                          setState(() {
                                                            _color3 =
                                                                Colors.red;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _color3 = Colors
                                                                .green.shade600;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),


                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            25.0,
                                                            5.0,
                                                            25.0,
                                                            10.0),
                                                    child: TextFormField(
                                                      controller: _confirpass,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      style: const TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'assets\fonst\Metropolis-Black.otf'),
                                                      obscureText:
                                                          !_cfrpasswordVisible,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        // labelText: 'Your Confirm Password',
                                                        // labelStyle: TextStyle(color: Colors.red),
                                                        hintText:
                                                            "Confirm New Password",
                                                        hintStyle: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'assets\fonst\Metropolis-Black.otf'),
                                                        suffixIcon: IconButton(
                                                          icon:
                                                              // Based on passwordVisible state choose the icon
                                                              _cfrpasswordVisible
                                                                  ? Image.asset(
                                                                      'assets/hidepassword.png')
                                                                  : Image.asset(
                                                                      'assets/Vector.png',
                                                                      width:
                                                                          20.0,
                                                                      height:
                                                                          20.0,
                                                                    ),
                                                          color: Colors.white,
                                                          onPressed: () {
                                                            // Update the state i.e. toogle the state of passwordVisible variable
                                                            setState(() {
                                                              _cfrpasswordVisible =
                                                                  !_cfrpasswordVisible;
                                                            });
                                                          },
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        width:
                                                                            1,
                                                                        color:
                                                                            _color5),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0)),
                                                        border: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    width: 1,
                                                                    color:
                                                                        _color5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        width:
                                                                            1,
                                                                        color:
                                                                            _color5),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0)),
                                                        //errorText: _validusernm ? 'Name is not empty' : null),
                                                      ),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Enter a Confirm New Password!';
                                                        }
                                                      },
                                                      onChanged: (value) {
                                                        if (value.isEmpty) {
                                                          WidgetsBinding
                                                              .instance
                                                              ?.focusManager
                                                              .primaryFocus
                                                              ?.unfocus();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Please Enter Confirm New Password');
                                                          setState(() {
                                                            _color5 =
                                                                Colors.red;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _color5 = Colors
                                                                .green.shade600;
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
                                                            1.2,
                                                    height: 60,
                                                    margin:
                                                        const EdgeInsets.all(20.0),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50.0),
                                                        color: const Color.fromARGB(
                                                            255, 0, 91, 148)),
                                                    child: TextButton(
                                                      onPressed: () {
                                                         WidgetsBinding
                                                            .instance
                                                            ?.focusManager
                                                            .primaryFocus
                                                            ?.unfocus();

                                                        setState(() {

                                                          if(_newpass.text.isEmpty){
                                                            _color3 = Colors.red;
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                "Please Enter Password...");
                                                          }else if(_newpass.text.length < 6){
                                                            _color3 = Colors.red;
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                "Password must have 6 digit...");
                                                          }else if(_confirpass.text.isEmpty){
                                                            _color5 = Colors.red;
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                "Please Enter Confirm Password");
                                                          }else if (_confirpass
                                                                  .text !=
                                                              _newpass.text) {
                                                            _color3 = Colors.red;
                                                            _color5 = Colors.red;
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Password Doesn't Match");
                                                          } else {
                                                            isloading1 = true;
                                                            WidgetsBinding
                                                                .instance
                                                                ?.focusManager
                                                                .primaryFocus
                                                                ?.unfocus();
                                                            change_password()
                                                                .then((value) {
                                                              Navigator.of(
                                                                      dialogContext!)
                                                                  .pop();
                                                            });
                                                            isloading1 = false;
                                                          }
                                                        });
                                                      },
                                                      child: const Text(
                                                          'Change Password',
                                                          style: TextStyle(
                                                              fontSize: 19.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-Black.otf')),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      )),
                                  

                                ],
                              )
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
                      )
                    ])))
          ])
        ])));
  }

  // kkrk0514@gmail.com

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

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          print('grrgt $_countdown');
        });
      }
    });
  }

  void _email_startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown1 > 0) {
        setState(() {
          _countdown1--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          print('grrgt $_countdown1');
        });
      }
    });
  }

  Future<bool> update_phone() async {

    log("Button Pressed");

    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    // _isResendButtonEnabled = ;
    _countdown = 30;
    countrycode1 ??= countrycode;
    print(_pref.getString('user_id').toString());

    var res = await updateUserPhoneno(
      _bussmbl.text.toString(),
      countrycode1!,
      _pref.getString('user_id').toString(),
      _pref.getString('api_token').toString(),
    );

    print(res);
    if (res['status'] == 1) {
      isloading1 = true;
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
      otp_sent = res['otp_sent'];
      mbl_otp = 1;
      edit_mbl = true;
      if (otp_sent == false) {
        print(_bussmbl.text.toString());
        await register_mo_verifyotp("1234", _bussmbl.text.toString(), "3");
        Navigator.of(dialogContext!).pop();
        edit_mbl = false;
        setState(() {
          _isResendButtonEnabled = false;
        });
      } else {
        setState(() {
          _isResendButtonEnabled = true;
        });
      }
      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(0)));*/
    } else {
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
      setState(() {
        _isResendButtonEnabled = false;
      });
      // Fluttertoast.showToast(msg: res['message']);
    }
    isloading1 = true;
    setState(() {});
    return isloading1;
  }

  Future<bool> update_email() async {


    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _countdown1 = 30;
    print(_pref.getString('user_id').toString());
    _onLoading();
    var res = await updateUseremail(
      _bussemail.text.toString(),
      _pref.getString('user_id').toString(),
      _pref.getString('api_token').toString(),
    );

    log("RESPONSE ==  $res");

    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);
      setState(() {
        _isResendButtonEnabled1 = true;
      });

      email_otp = 1;

      // isloading1=true;
      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(0)));*/
    } else {
      //isloading1=false;
      Fluttertoast.showToast(msg: res['message']);
      setState(() {
        _isResendButtonEnabled1 = true;
      });
      // Fluttertoast.showToast(msg: res['message']);
    }
    isloading1 = true;
    setState(() {});
    return isloading1;
  }

  Future<bool> register_mo_verifyotp(
    String otp,
    String phoneno,
    String step,
  ) async {

    log("VERIFY Button Pressed");

    common_par common = common_par();
    _onLoading();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var res = await reg_mo_updateverifyotp(
        otp,
        _pref.getString('user_id').toString(),
        phoneno,
        _pref.getString('api_token').toString(),
        step);

    String? msg = res['message'];

    if (res['status'] == 1) {
      common = common_par.fromJson(res);
      Fluttertoast.showToast(msg: res['message']);
      _bussmbl.clear();
      _mblotp.clear();
      edit_mbl = false;
      mbl_otp = 0;
      isloading1 = true;
    } else {
      Fluttertoast.showToast(msg: res['message']);
      log("VALIDATION FAILED");
      isloading1 = true;

    }
    getBussinessProfile();
    setState(() {});
    return isloading1;
  }

  Future<bool> update_email_verifyotp(
    String otp,
    String email,
    String step,
  ) async {

    _onLoading();

    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var res = await reg_email_verifyotp(
      otp,
      _pref.getString('user_id').toString(),
      _pref.getString('api_token').toString(),
      email,
      "2",
    );

    log("OTP RESPONSE == $res");

    if (res['status'] == 1) {
      common = common_par.fromJson(res);
      Fluttertoast.showToast(msg: res['message']);
      _bussemail.clear();
      _emailotp.clear();
      edit_email = false;
      email_otp = 0;
      isloading1 = true;
    } else {
      Fluttertoast.showToast(msg: res['message']);
      _emailotp.clear();
      isloading1 = true;
    }
    getBussinessProfile();
    setState(() {});
    return isloading1;
  }

  Future<bool> change_password() async {
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _onLoading();

    var res = await changePassword(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(), _newpass.text.toString());

    if (res['status'] == 1) {
      common = common_par.fromJson(res);
      Fluttertoast.showToast(msg: res['message']);
      _newpass.clear();
      _confirpass.clear();
      edit_pass = false;
      isloading1 = true;
    } else {
      Fluttertoast.showToast(msg: res['message']);
      isloading1 = true;
    }
    getBussinessProfile();
    setState(() {});
    return isloading1;
  }
}
