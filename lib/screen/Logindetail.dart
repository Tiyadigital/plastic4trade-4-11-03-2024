import 'dart:async';
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
  bool isloading1=false;
  String? email,countrycode1,countrycode,phoneno;
  Color _color6 = Colors.black45;
  Color _color7 = Colors.black45;
  Color _color1 = Colors.black45;
  Color _color4 = Colors.black45;
  Color _color5 = Colors.black45;
  Color _color3 = Colors.black45;
  Country? _selected;
  bool? otp_sent;
  bool edit_mbl = false, edit_email = false,edit_pass=false;
  String defaultCountryCode = 'IN';
  //PhoneNumber number = PhoneNumber(isoCode: 'IN');
  Country? _selectedCountry,defaultCountry;
  bool isloading=false;
  BuildContext? dialogContext;
  bool _isResendButtonEnabled=false ;
  Timer? _timer;
  int _countdown = 30;
  bool _isResendButtonEnabled1=false ;
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
        defaultCountry=country;
        _selectedCountry=country;
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
      email=jsonarray['email'];
      countrycode=jsonarray['countryCode'];
      phoneno=jsonarray['phoneno'];
      print(phoneno);      // for (var data in jsonarray) {
      getCountryFromCallingCode(countrycode!);
      //print();
      setState(() {

      });
      isloading =true;
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
        backgroundColor: Color.fromARGB(255, 218, 218, 218),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text('Login Details',
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
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              //height: 400,

              child: Column(children: [
            Form(
                key: _formKey,
                child: Container(
                    // height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(bottom: 10.0,top: 20),
                    child: Column(children: [
                      SafeArea(
                          top: true,
                          left: true,
                          right: true,
                          maintainBottomViewPadding: true,
                          child: isloading?Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.fromLTRB(
                                      20.0, 0.0, 20.0, 10.0),
                                  padding:
                                      EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black26),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(children: [

                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0.0, 5.0, 0.0, 0.0),
                                                  child: Text(
                                                    'Phone Number               ',
                                                    style:const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                        ?.copyWith(
                                                            color:
                                                                Colors.black45),
                                                  ),
                                                ),
                                              ), SizedBox(height: 3.0,),
                                              Container(
                                                  child: Row(
                                                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [

                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Image.asset(
                                                              country1!.flag,
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
                                                              '$countrycode',
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                                  ?.copyWith(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                            ),
                                                            SizedBox(
                                                              width: 2,
                                                            ),
                                                          ],
                                                        ),
                                                        /*CountryCodePickerX(
                                                          onChanged: (value) {
                                                            countrycode=value.toString();
                                                          },
                                                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')

                                                          initialSelection: countrycode,
                                                          favorite: ['+39', 'FR'],
                                                          // optional. Shows only country name and flag

                                                          showFlagMain: true,

                                                          showCountryOnly: false,
                                                          //showDropDownButton: true,
                                                          alignLeft: false,
                                                          enabled:false,
                                                          boxDecoration: BoxDecoration(
                                                            shape: BoxShape.rectangle
                                                          ),
                                                          // optional. Shows only country name and flag when popup is closed.
                                                          showOnlyCountryWhenClosed: false,
                                                          showFlag: true,

                                                          //flagWidth: 20.0,
                                                           //padding: EdgeInsets.all(10.0),
                                                          //alignLeft: false,
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
                                                    Text(phoneno.toString(),
                                                        style:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                  ])),
                                              SizedBox(height: 3.0,),
                                            ]),
                                            edit_mbl
                                                ? Center(
                                                    child: Align(
                                                      child: TextButton(
                                                        child: Text('Cancel',
                                                            style:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                                ?.copyWith(
                                                                    color: Colors
                                                                        .red)),
                                                        onPressed: () {
                                                          setState(() {
                                                            edit_mbl = false;
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
                                                            edit_mbl = true;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  )
                                          ]),
                                      Visibility(
                                          visible: edit_mbl,
                                          child: Container(

                                            child: Column(
                                              children: [
                                                Container(
                                                  //height: 55,
                                                  child:  Row(
                                                    children: [
                                                      Container(
                                                          height: 55,
                                                          //width: 130,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(width: 1, color: Colors.black45),
                                                            borderRadius: BorderRadius.circular(10.0),


                                                          ),
                                                          margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),


                                                          child:   Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            //mainAxisSize: MainAxisSize.min,
                                                            children: [

                                                              GestureDetector(

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
                                                                onTap: () {
                                                                  _onPressedShowBottomSheet();
                                                                },
                                                              )


                                                            ],
                                                          )




                                                        // ],
                                                        // ),
                                                        //),
                                                      ),
                                                      Container(
                                                        //padding: EdgeInsets.only(bottom: 3.0),
                                                        height: 57,
                                                        width: MediaQuery.of(context).size.width /
                                                            1.68,
                                                        margin: EdgeInsets.only(bottom: 0.0),
                                                        child: TextFormField(
                                                          // controller: _usernm,
                                                          controller: _bussmbl,
                                                          style:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                                                          inputFormatters: [
                                                            LengthLimitingTextInputFormatter(13),
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
                                                            hintText: "New Mobile Number",
                                                            hintStyle:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                                ?.copyWith(color: Colors.black45),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1, color: _color6),
                                                                borderRadius:
                                                                BorderRadius.circular(10.0)),
                                                            border: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1, color: _color6),
                                                                borderRadius:
                                                                BorderRadius.circular(10.0)),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1, color: _color6),
                                                                borderRadius:
                                                                BorderRadius.circular(10.0)),
                                                          ),
                                                          /*validator: (value) {
                                                            if (value!.isEmpty) {
                                                              WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                  'Please Enter  Number');
                                                            } else {
                                                              // setState(() {
                                                              _color6 = Colors.green.shade600;
                                                              //});
                                                            }

                                                            return null;
                                                          },*/
                                                          onFieldSubmitted: (value) {
                                                            var numValue = value.length;
                                                            if (numValue >= 6 && numValue < 13) {
                                                              _color6 = Colors.green.shade600;
                                                            } else {
                                                              _color6 = Colors.red;
                                                              WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                  'Please Enter Correct Number');
                                                            }
                                                          },
                                                          onChanged: (value) {
                                                            if (value.isEmpty) {
                                                              WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                  'Please Your Mobile Number');
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
                                                    ],
                                                  ),
                                                ),
                                                _isResendButtonEnabled  &&
                                                    _countdown != 0
                                                    ? Container(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        1.2,
                                                    height: 60,
                                                    margin: EdgeInsets.all(20.0),
                                                    decoration: BoxDecoration(
                                                        border:
                                                        Border.all(width: 1),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                        color:
                                                        Color.fromARGB(
                                                            255, 0, 91, 148)
                                                            .withOpacity(0.8)),
                                                     // Set the height of the container
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '0:$_countdown',
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.white,
                                                        fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf',
                                                      )?.copyWith(
                                                          fontWeight:
                                                          FontWeight.w800,
                                                          fontSize: 17),
                                                    ))

                                                    : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      1.2,
                                                  height: 60,
                                                  margin: EdgeInsets.all(20.0),
                                                  decoration: BoxDecoration(
                                                      border:
                                                          Border.all(width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                      color: Color.fromARGB(
                                                          255, 0, 91, 148)),
                                                  child: TextButton(
                                                    onPressed: () async {
                                                      /*Navigator.push(
                                                                  context, MaterialPageRoute(builder: (context) => bussinessprofile()));*/

                                                      var numValue = _bussmbl.text.length;
                                                      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                                      if(_bussmbl.text.isEmpty){
                                                        setState(() {
                                                          _color6 = Colors.red;
                                                          Fluttertoast.showToast(
                                                              msg:
                                                              'Please Your Mobile Number');
                                                        });
                                                      }
                                                      else if (numValue >= 6 && numValue < 13) {
                                                        _color6 = Colors.green.shade600;
                                                        WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();

                                                        _onLoading();
                                                        await  update_phone().then((value) {
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
                                                        isloading1=false;
                                                      } else {
                                                        _color6 = Colors.red;

                                                        Fluttertoast.showToast(
                                                            msg:
                                                            'Please Enter Correct Number');

                                                      }



                                                      setState(() {});
                                                    },
                                                    child: Text('Send OTP',
                                                        style: TextStyle(
                                                            fontSize: 19.0,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'assets\fonst\Metropolis-Black.otf')),
                                                  ),
                                                ),

                                                 Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        25.0, 0.0, 25.0, 0.0),
                                                    child: TextFormField(
                                                      controller: _mblotp,
                                                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration: InputDecoration(
                                                        hintText: "Enter OTP",
                                                        hintStyle:
                                                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        width: 1,
                                                                        color:
                                                                            _color1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0)),
                                                        border: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    width: 1,
                                                                    color:
                                                                        _color1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0)),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        width: 1,
                                                                        color:
                                                                            _color1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0)),
                                                        //errorText: _validusernm ? 'Name is not empty' : null),
                                                      ),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          _color1 = Colors
                                                              .red;
                                                          //return 'Enter a otp!';
                                                        } else {
                                                          // setState(() {
                                                          _color1 = Colors
                                                              .green.shade600;
                                                          // });
                                                        }
                                                        return null;
                                                      },
                                                      onChanged: (value) {
                                                        if (value.isEmpty) {
                                                          WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                                          Fluttertoast.showToast(
                                                              msg: 'Please Enter otp');
                                                          setState(() {
                                                            _color1 = Colors.red;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _color1 = Colors
                                                                .green.shade600;
                                                          });
                                                        }
                                                      },
                                                      /*onFieldSubmitted: (value) {
                                                        if (value.isEmpty) {
                                                          WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Please Enter otp');
                                                          setState(() {
                                                            _color1 = Colors.red;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _color1 = Colors
                                                                .green.shade600;
                                                          });
                                                        }
                                                      },*/
                                                    ),
                                                  ),

                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      1.2,
                                                  height: 60,
                                                  margin: EdgeInsets.all(20.0),
                                                  decoration: BoxDecoration(
                                                      border:
                                                          Border.all(width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                      color: Color.fromARGB(
                                                          255, 0, 91, 148)),
                                                  child: TextButton(
                                                    onPressed: () {

                                                      /*Navigator.push(
                                                                  context, MaterialPageRoute(builder: (context) => bussinessprofile()));*/
                                                      setState(() async {
                                                        edit_mbl = false;
                                                        WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                                        _onLoading();
                                                        await register_mo_verifyotp(_mblotp.text.toString(),_bussmbl.text.toString(),"3").then((value) {
                                                          print('dsefef $value');
                                                          Navigator.of(dialogContext!).pop();
                                                          if (value) {
                                                          /*  Navigator.push(
                                                                context, MaterialPageRoute(builder: (context) => Bussinessinfo()));*/
                                                          } /*else {
                                                            Navigator.push(
                                                                context, MaterialPageRoute(builder: (context) => Bussinessinfo()));
                                                          }*/
                                                        });
                                                          isloading1=false;
                                                            });

                                                    },
                                                    child: Text('Verify',
                                                        style: TextStyle(
                                                            fontSize: 19.0,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'assets\fonst\Metropolis-Black.otf')),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                    ],
                                  )),
                              Container(

                                margin:
                                    EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                                padding:
                                    EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
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
                                              padding: EdgeInsets.fromLTRB(
                                                  10.0, 5.0, 0.0, 0.0),
                                              child: Text(
                                                'Email Address',
                                                style:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                    ?.copyWith(
                                                        color: Colors.black45),
                                              ),
                                            ),
                                          ),
                                          Container(

                                              padding: EdgeInsets.fromLTRB(
                                                  10.0, 2.0, 0.0, 2.0),
                                            child: Text(email.toString(),
                                                style:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w500)),
                                          )
                                        ],
                                          )),
                                        edit_email
                                            ? Center(
                                                child: Align(
                                                  child: TextButton(
                                                    child: Text('Cancel',
                                                        style:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
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
                                                    child: Text('Edit'),
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
                                        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                        child: Column(
                                          children: [
                                            Container(
                                              //padding: EdgeInsets.only(bottom: 3.0),

                                              child: TextFormField(
                                                // controller: _usernm,
                                                controller: _bussemail,
                                                style:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),

                                                keyboardType:
                                                    TextInputType.emailAddress,
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
                                                  hintText: "New Email Address",
                                                  hintStyle:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
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
                                                          BorderRadius.circular(
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
                                                    _color7 =
                                                        Colors.red;
                                                  } else {
                                                    // setState(() {
                                                    _color7 =
                                                        Colors.green.shade600;
                                                    //});
                                                  }

                                                  return null;
                                                },
                                                onFieldSubmitted: (value) {

                                                },
                                                onChanged: (value) {
                                                  if (value.isEmpty) {
                                                    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Please Your Email');
                                                    setState(() {
                                                      _color7 = Colors.red;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _color7 =
                                                          Colors.green.shade600;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            _isResendButtonEnabled1  &&
                                                _countdown1 != 0
                                                ? Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    1.2,
                                                height: 60,
                                                margin: EdgeInsets.all(20.0),
                                                decoration: BoxDecoration(
                                                    border:
                                                    Border.all(width: 1),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        50.0),
                                                    color:
                                                    Color.fromARGB(
                                                        255, 0, 91, 148)
                                                        .withOpacity(0.8)),
                                                // Set the height of the container
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '0:$_countdown1',
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.white,
                                                    fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf',
                                                  )?.copyWith(
                                                      fontWeight:
                                                      FontWeight.w800,
                                                      fontSize: 17),
                                                ))

                                                :
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  1.2,
                                              height: 60,
                                              margin: EdgeInsets.all(20.0),
                                              decoration: BoxDecoration(
                                                  border:
                                                  Border.all(width: 1),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      50.0),
                                                  color: Color.fromARGB(
                                                      255, 0, 91, 148)),
                                              child: TextButton(
                                                onPressed: () {
                                                  /*Navigator.push(
                                                                  context, MaterialPageRoute(builder: (context) => bussinessprofile()));*/

                                                  setState(() {
                                                    _isValid = EmailValidator.validate(_bussemail.text);
                                                    if(!_isValid){
                                                      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                                      Fluttertoast.showToast(msg: 'Enter Proper Email');
                                                      _color7 = Colors.red;
                                                    }else{
                                                      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                                      _onLoading();
                                                      update_email().then((value) {
                                                       // isloading1=false;
                                                        print('rgdrr$value');
                                                        Navigator.of(dialogContext!).pop();
                                                        _email_startTimer();
                                                       /* if (value) {
                                                          *//*Navigator.push(
                                                              context, MaterialPageRoute(builder: (context) => Bussinessinfo()));*//*
                                                        } else {
                                                         *//* Navigator.push(
                                                              context, MaterialPageRoute(builder: (context) => Bussinessinfo()));*//*
                                                        }*/
                                                      });


                                                    }
                                                    isloading1=false;
                                                    Navigator.of(dialogContext!).pop();
                                                  });
                                                },
                                                child: Text('Send OTP',
                                                    style: TextStyle(
                                                        fontSize: 19.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'assets\fonst\Metropolis-Black.otf')),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  25.0, 0.0, 25.0, 0.0),
                                              child: TextFormField(
                                                controller: _emailotp,
                                                style:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                keyboardType:
                                                    TextInputType.number,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                  hintText: "Enter OTP",
                                                  hintStyle:TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color:
                                                                      _color1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0)),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: _color1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0)),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1,
                                                                  color:
                                                                      _color1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0)),
                                                  //errorText: _validusernm ? 'Name is not empty' : null),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    _color7 =
                                                        Colors.red;
                                                    //return 'Enter a otp!';
                                                  } else {
                                                    // setState(() {
                                                    _color1 =
                                                        Colors.green.shade600;
                                                    // });
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  if (value.isEmpty) {
                                                    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                                    Fluttertoast.showToast(
                                                        msg: 'Please otp');
                                                    setState(() {
                                                      _color1 = Colors.red;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _color1 =
                                                          Colors.green.shade600;
                                                    });
                                                  }
                                                },
                                                onFieldSubmitted: (value) {
                                                  if (value.isEmpty) {
                                                    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Please Enter otp');
                                                    setState(() {
                                                      _color1 = Colors.red;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _color1 =
                                                          Colors.green.shade600;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1.2,
                                              height: 60,
                                              margin: EdgeInsets.all(20.0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  color: Color.fromARGB(
                                                      255, 0, 91, 148)),
                                              child: TextButton(
                                                onPressed: () {
                                                  /*Navigator.push(
                                                                  context, MaterialPageRoute(builder: (context) => bussinessprofile()));*/
                                                  setState(() {
                                                    edit_email = false;
                                                  });
                                                  WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                                  _onLoading();

                                                  update_email_verifyotp(_emailotp.text.toString(),
                                                      _bussemail.text.toString(),
                                                      "2").then((value) {
                                                    Navigator.of(dialogContext!).pop();
                                                    if (value) {
                                                      /*Navigator.push(
                                                          context, MaterialPageRoute(builder: (context) => Bussinessinfo()));*/
                                                    } else {
                                                      /*Navigator.push(
                                                          context, MaterialPageRoute(builder: (context) => Bussinessinfo()));*/
                                                    }
                                                  });
                                                  isloading1=false;
                                                },
                                                child: Text('Verify',
                                                    style: TextStyle(
                                                        fontSize: 19.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Colors.white,
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
                                  margin: EdgeInsets.fromLTRB(
                                      20.0, 0.0, 20.0, 20.0),

                                  padding:
                                      EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black26),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                  child: Text('Cancel',
                                                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                          ?.copyWith(
                                                          color: Colors
                                                              .red)),
                                                  onPressed: () {
                                                    setState(() {
                                                      edit_pass = false;
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
                                                      edit_pass = true;
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
                                              /*Padding(
                                                padding:
                                                EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                                                child: TextFormField(
                                                  controller: _currentpass,
                                                  obscureText: !_passwordVisible,
                                                  autovalidateMode:
                                                  AutovalidateMode.onUserInteraction,
                                                  keyboardType: TextInputType.text,
                                                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                                                  textInputAction: TextInputAction.next,
                                                  decoration: InputDecoration(
                                                    // labelText: 'Your Password',
                                                    // labelStyle: TextStyle(color: Colors.red),

                                                    hintText: "Enter Your Current Password ",
                                                    hintStyle:
                                                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                                                    suffixIcon: IconButton(
                                                      icon:
                                                      // Based on passwordVisible state choose the icon
                                                      _passwordVisible
                                                          ?  Image.asset(
                                                          'assets/hidepassword.png')
                                                          :Image.asset('assets/Vector.png'),
                                                      color: Colors.white,
                                                      onPressed: () {
                                                        // Update the state i.e. toogle the state of passwordVisible variable
                                                        setState(() {
                                                          _passwordVisible = !_passwordVisible;
                                                        });
                                                      },
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(width: 1, color: _color4),
                                                        borderRadius:
                                                        BorderRadius.circular(10.0)),
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(width: 1, color: _color4),
                                                        borderRadius:
                                                        BorderRadius.circular(10.0)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(width: 1, color: _color4),
                                                        borderRadius:
                                                        BorderRadius.circular(10.0)),
                                                    //errorText: _validusernm ? 'Name is not empty' : null),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Enter a Password!';
                                                    }
                                                  },
                                                  onChanged: (value) {

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
                                                          msg: 'Password must be 6 charecter');
                                                      _color4 = Colors.red;
                                                    } else {
                                                      _color4 = Colors.green.shade600;
                                                    }
                                                  },
                                                ),
                                              ),*/
                                              Padding(
                                                padding:
                                                EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                                                child: TextFormField(
                                                  controller: _newpass,
                                                  keyboardType: TextInputType.text,
                                                  autovalidateMode:
                                                  AutovalidateMode.onUserInteraction,
                                                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                                                  obscureText: !_cpasswordVisible,
                                                  textInputAction: TextInputAction.next,
                                                  decoration: InputDecoration(
                                                    // labelText: 'Your Confirm Password',
                                                    // labelStyle: TextStyle(color: Colors.red),
                                                    hintText: "New Password",
                                                    hintStyle:
                                                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                                                    suffixIcon: IconButton(
                                                      icon:
                                                      // Based on passwordVisible state choose the icon
                                                      _cpasswordVisible
                                                          ? Image.asset(
                                                          'assets/hidepassword.png')
                                                          : Image.asset('assets/Vector.png' ,width: 20.0,
                                                        height: 20.0,),
                                                      color: Colors.white,
                                                      onPressed: () {
                                                        // Update the state i.e. toogle the state of passwordVisible variable
                                                        setState(() {
                                                          _cpasswordVisible = !_cpasswordVisible;
                                                        });
                                                      },
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(width: 1, color: _color3),
                                                        borderRadius:
                                                        BorderRadius.circular(10.0)),
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(width: 1, color: _color3),
                                                        borderRadius:
                                                        BorderRadius.circular(10.0)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(width: 1, color: _color3),
                                                        borderRadius:
                                                        BorderRadius.circular(10.0)),
                                                    //errorText: _validusernm ? 'Name is not empty' : null),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      _color3 = Colors.red;
                                                    } else{
                                                      _color3 = Colors.green.shade600;
                                                    }
                                                  },
                                                  onChanged: (value) {
                                                    if (value.isEmpty) {
                                                      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                                      Fluttertoast.showToast(
                                                          msg: 'Please Enter New Password');
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
                                              Padding(
                                                padding:
                                                EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                                                child: TextFormField(
                                                  controller: _confirpass,
                                                  keyboardType: TextInputType.text,
                                                  autovalidateMode:
                                                  AutovalidateMode.onUserInteraction,
                                                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                                                  obscureText: !_cfrpasswordVisible,
                                                  textInputAction: TextInputAction.next,
                                                  decoration: InputDecoration(
                                                    // labelText: 'Your Confirm Password',
                                                    // labelStyle: TextStyle(color: Colors.red),
                                                    hintText: "Confirm New Password",
                                                    hintStyle:
                                                    TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                                                    suffixIcon: IconButton(
                                                      icon:
                                                      // Based on passwordVisible state choose the icon
                                                      _cfrpasswordVisible
                                                          ? Image.asset(
                                                          'assets/hidepassword.png')
                                                          : Image.asset('assets/Vector.png', width: 20.0,
                                                        height: 20.0,),
                                                      color: Colors.white,
                                                      onPressed: () {
                                                        // Update the state i.e. toogle the state of passwordVisible variable
                                                        setState(() {
                                                          _cfrpasswordVisible = !_cfrpasswordVisible;
                                                        });
                                                      },
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(width: 1, color: _color5),
                                                        borderRadius:
                                                        BorderRadius.circular(10.0)),
                                                    border: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(width: 1, color: _color5),
                                                        borderRadius:
                                                        BorderRadius.circular(10.0)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide:
                                                        BorderSide(width: 1, color: _color5),
                                                        borderRadius:
                                                        BorderRadius.circular(10.0)),
                                                    //errorText: _validusernm ? 'Name is not empty' : null),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Enter a Confirm New Password!';
                                                    }
                                                  },
                                                  onChanged: (value) {
                                                    if (value.isEmpty) {
                                                      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                                      Fluttertoast.showToast(
                                                          msg: 'Please Enter Confirm New Password');
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
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    1.2,
                                                height: 60,
                                                margin: EdgeInsets.all(20.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all(width: 1),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        50.0),
                                                    color: Color.fromARGB(
                                                        255, 0, 91, 148)),
                                                child: TextButton(
                                                  onPressed: () {
                                                    /*Navigator.push(
                                                                  context, MaterialPageRoute(builder: (context) => bussinessprofile()));*/
                                                    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();

                                                    setState(() {

                                                      if(_confirpass.text!=_newpass.text){

                                                        Fluttertoast.showToast(msg:"Password Doesn't Match");

                                                      }else{
                                                        edit_pass = false;
                                                        isloading1=true;
                                                        WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                                        _onLoading();
                                                        change_password().then((value) {
                                                          Navigator.of(dialogContext!).pop();
                                                          if (value) {
                                                            /*Navigator.push(
                                                                context, MaterialPageRoute(builder: (context) => Bussinessinfo()));*/
                                                          } else {
                                                          /*  Navigator.push(
                                                                context, MaterialPageRoute(builder: (context) => Bussinessinfo()));*/
                                                          }
                                                        });
                                                        isloading1=false;
                                                      }
                                                    });
                                                  },
                                                  child: Text('Change Password',
                                                      style: TextStyle(
                                                          fontSize: 19.0,
                                                          fontWeight:
                                                          FontWeight.w800,
                                                          color: Colors.white,
                                                          fontFamily:
                                                          'assets\fonst\Metropolis-Black.otf')),
                                                ),
                                              ),
                                            ],
                                          ))

                                    ],
                                  )

                ),
                            ],
                          ):Center(
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
                                  : Container()),)
                    ])))
          ]))
        ])));
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
  Future<bool> update_phone() async{
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
        _pref.getString('api_token').toString(),);


    /* 'userId':userId,'userToken':userToken,'business_name':business_name,'business_type':business_type,'location':location,'longitude':longitude,'longitude':latitude,'other_mobile1':other_mobile1,'country':country,
    'countryCode':countryCode,
    'business_phone':business_phone,'business_type':business_type,'city':city,'email':email,'website':website,'about_business':about_business,
    'profilePicture':file,'gst_tax_vat':gst_tax_vat,'state':state*/

    print(res);
    if (res['status'] == 1) {
      isloading1=true;
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
      otp_sent= res['otp_sent'];
      print('OTP_SENT $otp_sent');
      edit_mbl = true;
      if(otp_sent==false){
        print(_bussmbl.text.toString());
        await register_mo_verifyotp("1234",_bussmbl.text.toString(),"3");
        Navigator.of(dialogContext!).pop();
        edit_mbl = false;
        setState(() {
          _isResendButtonEnabled = false;
        });
      }else {
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
        _isResendButtonEnabled=false;
      });
      // Fluttertoast.showToast(msg: res['message']);
    }
    isloading1=true;
    setState(() {

    });
    return isloading1;
  }

  Future<bool >update_email() async{
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(_pref.getString('user_id').toString());
    _onLoading();
    var res = await updateUseremail(
      _bussemail.text.toString(),
      _pref.getString('user_id').toString(),
      _pref.getString('api_token').toString(),

      );

    print(res);
    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);
      setState(() {
        _isResendButtonEnabled1 = true;
      });
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
    isloading1=true;
    setState(() {

    });
    return isloading1;
  }

  Future<bool> register_mo_verifyotp(
      String otp,

      String phoneno,

      String step,
      ) async {
    common_par common = common_par();
    _onLoading();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var res = await reg_mo_updateverifyotp(otp, _pref.getString('user_id').toString(), phoneno,  _pref.getString('api_token').toString(), step);

    String? msg = res['message'];
    Fluttertoast.showToast(msg: "$msg");
    if (res['status'] == 1) {
      common = common_par.fromJson(res);
      Fluttertoast.showToast(msg: res['message']);
     isloading1=true;
    } else {
      isloading1=true;
      Fluttertoast.showToast(msg: res['message']);
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
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var res = await reg_email_verifyotp(otp,  _pref
        .getString(
        'user_id')
        .toString(),
        _pref
            .getString(
            'api_token')
            .toString(),
      email,
        "2", );



    if (res['status'] == 1) {
      common = common_par.fromJson(res);
      Fluttertoast.showToast(msg: res['message']);
      isloading1=true;
    } else {
      Fluttertoast.showToast(msg: res['message']);
      isloading1=true;
    }
    getBussinessProfile();
    setState(() {});
    return isloading1;
  }

 Future<bool> change_password() async {
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _onLoading();

    var res = await changePassword(_pref
        .getString(
        'user_id')
        .toString(),
      _pref
          .getString(
          'api_token')
          .toString(),
      _newpass.text.toString());



    if (res['status'] == 1) {
      common = common_par.fromJson(res);
      Fluttertoast.showToast(msg: res['message']);
      isloading1=true;

    } else {
      Fluttertoast.showToast(msg: res['message']);
      isloading1=true;
    }
    getBussinessProfile();
    setState(() {});
    return isloading1;
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
}
