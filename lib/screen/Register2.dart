// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:developer';

import 'package:Plastic4trade/widget/MainScreen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' as io;
import 'package:email_validator/email_validator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:Plastic4trade/constroller/GetBussinessTypeController.dart';
import 'package:Plastic4trade/model/common.dart';
import 'package:Plastic4trade/utill/constant.dart';
import 'package:Plastic4trade/model/GetBusinessType.dart' as bt;
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_interface.dart';
import 'dart:io' show Platform;

class Register2 extends StatefulWidget {
  Register2({Key? key}) : super(key: key);

  @override
  State<Register2> createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  TextEditingController _bussname = TextEditingController();
  //TextEditingController _busstype = TextEditingController();
  TextEditingController _bussmbl = TextEditingController();
  TextEditingController _bussemail = TextEditingController();
  TextEditingController _loc = TextEditingController();
  TextEditingController _gstno = TextEditingController();
  TextEditingController _website = TextEditingController();
  TextEditingController _aboutbuess = TextEditingController();
  TextEditingController _userbussnature = TextEditingController();

  Color _color1 = Colors.black26; //name
  Color _color2 = Colors.black26;
  Color _color3 = Colors.black26;
  Color _color4 = Colors.black26;
  Color _color5 = Colors.black26;
  Color _color6 = Colors.black26;
  Color _color7 = Colors.black26;
  Color _color8 = Colors.black26;

  var _formKey = GlobalKey<FormState>();
  PickedFile? _imagefiles;
  io.File? file, file1, file2;
  CroppedFile? _croppedFile;
  final ImagePicker _picker = ImagePicker();
  String googleApikey = "AIzaSyCyqsD3OPUWGJ5AWbN3iKbUzQGs3Q-ZlPE";
  //String googleApikey = "AIzaSyBAhhavIsSMVdaBF2WkJvwJdF8EPuJeGcg";
  late double lat = 0.0;
  late double log = 0.0;
  String state = '', country_code = '+91', city = '', country = '';
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(0, 0);
  String location = "Search Location";
  //final ImagePicker _picker = ImagePicker();
  bool _isValid = false;
  // CountryController countryController = getCountryController();
  String defaultCountryCode = 'IN';
  String buss_type = "";
  //PhoneNumber number = PhoneNumber(isoCode: 'IN');
  Country? _selectedCountry;
  BuildContext? dialogContext;
  bool _isloading1 = false;

  @override
  void initState() {
    super.initState();
    initCountry();
    constanst.Bussiness_nature_name = "";
    print('init');
    get_data();
  }

  void initCountry() async {
    final country = await getCountryByCountryCode(context, defaultCountryCode);
    setState(() {
      _selectedCountry = country;
    });
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

  @override
  Widget build(BuildContext context) {
    return initwidget(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    constanst.itemsCheck.clear();
    constanst.lstBussiness_nature.clear();
  }

  void get_data() async {
    GetBussinessTypeController bt = await GetBussinessTypeController();
    constanst.bt_data = bt.getBussiness_Type();

    constanst.bt_data!.then((value) {
      if (value != null) {
        for (var item in value) {
          constanst.btype_data.add(item);
        }
      }
    });
    // setState(() {});
    print(constanst.btype_data);
  }

  Future<bool> _onbackpress(BuildContext context) async {
    /* Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => MainScreen(0)),
        ModalRoute.withName('/')
    );*/
    Navigator.pop(context);
    return Future.value(true);
  }

  Widget initwidget(BuildContext context) {
    final country1 = _selectedCountry;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        //resizeToAvoidBottomInset: false,
        body: WillPopScope(
            onWillPop: () => _onbackpress(context),
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Form(
                    // key: _formKey,
                    child: Container(
                        // height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(children: [
                          SafeArea(
                              top: true,
                              left: true,
                              right: true,
                              maintainBottomViewPadding: true,
                              child: Column(children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      child: Image.asset('assets/back.png',
                                          height: 50, width: 70),
                                      onTap: () {
                                        /* Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (BuildContext context) => MainScreen(0)),
                                        ModalRoute.withName('/')
                                    );*/
                                        Navigator.pop(context);
                                      },
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.3,
                                      alignment: Alignment.topLeft,
                                      child: const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Setup Business Profile",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          )),
                                    ),
                                  ],
                                ),
                                imageprofile(context),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 25.0, 25.0, 3.0),
                                  child: TextFormField(
                                    controller: _bussname,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf'),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r"[a-zA-Z]+|\s"),
                                      ),
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                      hintText: "Bussiness Name *",
                                      hintStyle: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf')
                                          ?.copyWith(color: Colors.black45),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color1),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color1),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color1),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      //errorText: _validusernm ? 'Name is not empty' : null),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        _color1 = Colors.red;
                                      } else {
                                        // setState(() {
                                        _color1 = Colors.green.shade600;
                                        // });
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                            msg:
                                                'Please Add Your Business Name');
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
                                        Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                            msg: 'Please Enter Bussiness Name');
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
                                      const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                                  child: TextFormField(
                                      controller: _userbussnature,
                                      keyboardType: TextInputType.text,
                                      readOnly: true,
                                      textInputAction: TextInputAction.next,
                                      style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets\fonst\Metropolis-Black.otf'),
                                      decoration: InputDecoration(
                                        hintText: "Nature Of Business *",
                                        suffixIcon:
                                            Icon(Icons.arrow_drop_down_sharp),
                                        hintStyle: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf')
                                            ?.copyWith(color: Colors.black45),
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
                                      onTap: () async {
                                        setState(() {});
                                        final connectivityResult =
                                            await Connectivity()
                                                .checkConnectivity();

                                        if (connectivityResult ==
                                            ConnectivityResult.none) {
                                          Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                              msg:
                                                  'Internet Connection not available');
                                        } else {

                                          ViewItem1(context);
                                        }
                                      },
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                              msg:
                                                  'Please Select Nature Of Business');
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
                                          Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                              msg:
                                                  'Please Select Nature Of Business');
                                          setState(() {
                                            _color2 = Colors.red;
                                          });
                                        } else {
                                          setState(() {
                                            _color2 = Colors.green.shade600;
                                          });
                                        }
                                      }),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                                  child: TextFormField(
                                    controller: _loc,
                                    readOnly: true,
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf'),
                                    onTap: () async {
                                      var place =
                                      await PlacesAutocomplete.show(
                                        context: context,
                                        apiKey: googleApikey,
                                        mode: Mode.overlay,
                                        types: ['geocode', 'establishment'],
                                        strictbounds: false,
                                        onError: (err) {
                                          print(err);
                                        },
                                      );


                                      if (place != null) {
                                        setState(() {
                                          location =
                                              place.description.toString();

                                          List<String> list = place.description
                                              .toString()
                                              .split(",");
                                          list.length > 2
                                              ? state = list[1].toString()
                                              : state = '';
                                          list.length >= 3
                                              ? country = list[2].toString()
                                              : country = '';
                                          city = list[0];
                                          print(list);
                                          print(city);
                                          print(state);
                                          print(country);
                                          _loc.text = location;
                                          _color5 = Colors.green.shade600;
                                          // print(location);
                                          setState(() {});
                                        });

                                        //form google_maps_webservice package
                                        final plist = GoogleMapsPlaces(
                                          apiKey: googleApikey,
                                          apiHeaders: await const GoogleApiHeaders()
                                              .getHeaders(),
                                          //from google_api_headers package
                                        );
                                        String placeid = place.placeId ?? "0";
                                        final detail = await plist
                                            .getDetailsByPlaceId(placeid);

                                        final geometry =
                                            detail.result.geometry!;
                                        lat = geometry.location.lat;

                                        log = geometry.location.lng;
                                        print(log);
                                        var newlatlang = LatLng(lat, log);

                                        //move map camera to selected place with animation
                                        //mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Location/ Address / City *",
                                      hintStyle: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf')
                                          ?.copyWith(color: Colors.black45),
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
                                    validator: (value) {
                                      // if (!EmailValidator.validate(value!)) {
                                      //   return 'Please enter a valid email';
                                      // }
                                      if (value!.isEmpty) {
                                        // return 'Enter a Location!';
                                        _color5 = Colors.red;
                                      } else {
                                        // setState(() {
                                        //_color3 = Colors.green.shade600;
                                        //});
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (value) {
                                      if (value.isEmpty) {
                                        Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                            msg:
                                                'Please Search and Save your Business Location');
                                        setState(() {
                                          _color5 = Colors.red;
                                        });
                                      } else if (value.isNotEmpty) {
                                        setState(() {
                                          _color5 = Colors.green.shade600;
                                        });
                                      }
                                    },
                                  ),
                                ),



                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 55,
                                          //width: 130,
                                          /* decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.black26),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),*/
                                          margin: EdgeInsets.fromLTRB(
                                              0.0, 0.0, 5.0, 0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            //mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                  height: 57,
                                                  padding:
                                                      EdgeInsets.only(left: 2),
                                                  decoration: BoxDecoration(
                                                    border: /* verify_phone == 1
                                                      ? Border.all(
                                                      width: 1, color: Colors.grey)
                                                      : */
                                                        Border.all(
                                                            width: 1,
                                                            color:
                                                                Colors.black26),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _onPressedShowBottomSheet();
                                                    },
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Image.asset(
                                                          country1!.flag,
                                                          package:
                                                              countryCodePackageName,
                                                          width: 30,
                                                        ),
                                                        SizedBox(
                                                          height: 16,
                                                        ),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        Text(
                                                          '${country1.callingCode}',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ],
                                          )

                                          // ],
                                          // ),
                                          //),
                                          ),
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                            //padding: EdgeInsets.only(bottom: 3.0),
                                            height: 55,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.59,
                                            margin:
                                                const EdgeInsets.only(bottom: 0.0),
                                            child: TextFormField(
                                              // controller: _usernm,
                                              controller: _bussmbl,
                                              style: const TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets\fonst\Metropolis-Black.otf'),
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(11),
                                              ],
                                              keyboardType: TextInputType.phone,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                // labelText: 'Your phone *',
                                                // labelStyle: TextStyle(color: Colors.red),
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: "Bussiness Moblie",
                                                hintStyle: const TextStyle(
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'assets\fonst\Metropolis-Black.otf')
                                                    ?.copyWith(
                                                        color: Colors.black45),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: _color8),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.0)),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: _color8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color: _color8),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    10.0)),
                                              ),

                                              onFieldSubmitted: (value) {
                                                var numValue = value.length;
                                                if (numValue >= 6 &&
                                                    numValue < 12) {
                                                  _color8 =
                                                      Colors.green.shade600;
                                                } else {
                                                  _color8 = Colors.red;
                                                  Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                                      msg:
                                                          'Please Enter Correct Number');
                                                }
                                              },
                                              onChanged: (value) {
                                                if (value.isEmpty) {
                                                  /* Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                              msg:
                                                  'Please Your Bussiness Mobile Number');*/
                                                  setState(() {
                                                    _color8 = Colors.black26;
                                                  });
                                                } else {
                                                  setState(() {
                                                    _color8 =
                                                        Colors.green.shade600;
                                                  });
                                                }
                                              },
                                            ),
                                          ))
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                                  child: TextFormField(
                                    controller: _bussemail,
                                    keyboardType: TextInputType.emailAddress,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf'),
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      // labelText: 'Your email *',
                                      // labelStyle: TextStyle(color: Colors.red),
                                      hintText: "Bussiness Email",
                                      hintStyle: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf')
                                          ?.copyWith(color: Colors.black45),
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
                                    ),
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        /* Fluttertoast.showToast(
                                              msg:
                                                  'Please Your Bussiness Mobile Number');*/
                                        setState(() {
                                          _color4 = Colors.black26;
                                        });
                                      } else {
                                        setState(() {
                                          _color4 = Colors.green.shade600;
                                        });
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      if (!EmailValidator.validate(value)) {
                                        _color4 = Colors.red;
                                        Fluttertoast.showToast(
                                            msg: 'Please enter a valid email');
                                        setState(() {});
                                      } else if (value.isEmpty) {
                                        /*  Fluttertoast.showToast(
                                        msg: 'Please Your Email');*/
                                        setState(() {
                                          _color4 = Colors.black26;
                                        });
                                      } else if (value.isNotEmpty) {
                                        setState(() {
                                          _color4 = Colors.green.shade600;
                                        });
                                      }
                                    },
                                  ),
                                ),

                                // child:Padding(
                                //   padding: EdgeInsets.all(15),
                                //   child: Card(
                                //     child: Container(
                                //         padding: EdgeInsets.all(0),
                                //         width: MediaQuery.of(context).size.width - 40,
                                //         child: ListTile(
                                //           title:Text(location, style: TextStyle(fontSize: 18),),
                                //           trailing: Icon(Icons.search),
                                //           dense: true,
                                //         )
                                //     ),
                                //   ),
                                // )

                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                                  child: TextFormField(
                                    controller: _gstno,
                                    keyboardType: TextInputType.text,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf'),
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r"[a-zA-Z]+|\d"),
                                      ),
                                      LengthLimitingTextInputFormatter(15)
                                    ],
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: InputDecoration(
                                      hintText: "GST/Tax/VAT Number",
                                      hintStyle: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf')
                                          ?.copyWith(color: Colors.black45),
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
                                    /* validator: (value) {
                                  // if (!EmailValidator.validate(value!)) {
                                  //   return 'Please enter a valid email';
                                  // }
                                  if (value!.isEmpty) {
                                    //return 'Enter a GST Number!';
                                    _color3 = Colors.red;
                                  } else {
                                    // setState(() {
                                    //_color3 = Colors.green.shade600;
                                    //});
                                  }
                                  return null;
                                },*/
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        /*Fluttertoast.showToast(
                                        msg: 'Please Enter Valid GST/ VAT/Tax Number');*/
                                        setState(() {
                                          _color3 = Colors.black26;
                                        });
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      var numValue = value.length;
                                      if (value.isEmpty) {
                                        /*Fluttertoast.showToast(
                                        msg: 'Please Enter Valid GST/ VAT/Tax Number');*/
                                        setState(() {
                                          _color3 = Colors.black26;
                                        });
                                      } else if (numValue < 15) {
                                        _color3 = Colors.green.shade600;
                                      } else if (value.isNotEmpty) {
                                        setState(() {
                                          _color3 = Colors.green.shade600;
                                        });
                                      } else {
                                        _color3 = Colors.red;

                                        Fluttertoast.showToast(
                                            msg:
                                                'Please Enter Valid GST/ VAT/Tax Number');
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                                  child: TextFormField(
                                    controller: _website,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf'),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      hintText: "Website",
                                      hintStyle: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf')
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
                                      //errorText: _validusernm ? 'Name is not empty' : null),
                                    ),
                                    /* validator: (value) {
                                  // if (!EmailValidator.validate(value!)) {
                                  //   return 'Please enter a valid email';
                                  // }
                                  if (value!.isEmpty) {
                                    // return 'Enter a Website Number!';


                                    Fluttertoast.showToast(
                                        msg: 'Please Your Website ');
                                    setState(() {
                                      _color6 = Colors.red;
                                    });
                                  } else {
                                    // setState(() {
                                    //_color3 = Colors.green.shade600;
                                    //});
                                  }
                                  return null;
                                },*/
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        /* Fluttertoast.showToast(
                                              msg:
                                                  'Please Your Bussiness Mobile Number');*/
                                        setState(() {
                                          _color6 = Colors.black26;
                                        });
                                      } else {
                                        setState(() {
                                          _color6 = Colors.green.shade600;
                                        });
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      if (value.isEmpty) {
                                        /* Fluttertoast.showToast(
                                        msg: 'Please Your Website ');*/
                                        setState(() {
                                          _color6 = Colors.black26;
                                        });
                                      } else if (value.isNotEmpty) {
                                        setState(() {
                                          _color6 = Colors.green.shade600;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      25.0, 5.0, 25.0, 10.0),
                                  child: TextFormField(
                                    controller: _aboutbuess,
                                    keyboardType: TextInputType.multiline,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf'),
                                    maxLines: 4,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                        hintText: "About Bussiness",
                                        hintStyle: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf')
                                            ?.copyWith(color: Colors.black45),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1, color: _color7),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1, color: _color7),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1, color: _color7),
                                            borderRadius:
                                                BorderRadius.circular(10.0))

                                        //errorText: _validusernm ? 'Name is not empty' : null),
                                        ),
                                    /* validator: (value) {
                                  // if (!EmailValidator.validate(value!)) {
                                  //   return 'Please enter a valid email';
                                  // }
                                  if (value!.isEmpty) {
                                    //return 'Enter a About Bussiness!';
                                    _color7 = Colors.black26;
                                  } else {
                                    // setState(() {
                                    //_color3 = Colors.green.shade600;
                                    //});
                                  }
                                  return null;
                                },*/
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        /* Fluttertoast.showToast(
                                              msg:
                                                  'Please Your Bussiness Mobile Number');*/
                                        setState(() {
                                          _color7 = Colors.black26;
                                        });
                                      } else {
                                        setState(() {
                                          _color7 = Colors.green.shade600;
                                        });
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      if (value.isEmpty) {
                                        /*  Fluttertoast.showToast(
                                        msg: 'Please Your Website Number');*/
                                        setState(() {
                                          _color7 = Colors.black26;
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Color.fromARGB(255, 0, 91, 148)),
                                  child: TextButton(
                                    onPressed: () async {
                                      //setState(()  {
                                      final connectivityResult =
                                          await Connectivity()
                                              .checkConnectivity();

                                      if (connectivityResult ==
                                          ConnectivityResult.none) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Net Connection not available');
                                      } else {
                                        // if (_formKey.currentState!.validate()) {
                                        /*Fluttertoast.showToast(
                                            msg: "Data Proccess");*/
                                        vaild_data();
                                        print("SENDED DATA === ${constanst.Bussiness_nature}");
                                        // }
                                      }
                                      // });
                                    },
                                    child: Text('Continue',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                          fontFamily:
                                              'assets\fonst\Metropolis-Black.otf',
                                        )),
                                  ),
                                ),
                              ]))
                        ]))))));
  }

  Widget imageprofile(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 60.0,

            backgroundImage: _imagefiles == null
                ?AssetImage('assets/addphoto1.png') as ImageProvider
                : FileImage(file!),
            //File imageFile = File(pickedFile.path);

            backgroundColor: Color.fromARGB(255, 240, 238, 238),
          ),
          Positioned(
            bottom: 3.0,
            right: 5.0,
            child: Container(
                width: 40,
                height: 33,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    showModalBottomSheet(
                        context: context, builder: (context) => bottomsheet());
                  },
                  child: ImageIcon(
                    AssetImage('assets/Vector (1).png'),
                    color: Color.fromARGB(255, 0, 91, 148),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget bottomsheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile Photo",
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    takephoto(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera,
                      color: Color.fromARGB(255, 0, 91, 148)),
                  label: Text(
                    'Camera',
                    style: TextStyle(color: Color.fromARGB(255, 0, 91, 148)),
                  )),
              TextButton.icon(
                  onPressed: () {
                    takephoto(ImageSource.gallery);
                  },
                  icon:
                      Icon(Icons.image, color: Color.fromARGB(255, 0, 91, 148)),
                  label: Text(
                    'Gallary',
                    style: TextStyle(color: Color.fromARGB(255, 0, 91, 148)),
                  )),
            ],
          )
        ],
      ),
    );
  }

  void takephoto(ImageSource imageSource) async {
    final pickedfile = await _picker.getImage(source: imageSource);

    _imagefiles = pickedfile!;
    //file = io.File(_imagefiles!.path);
    file = await _cropImage(imagefile: io.File(_imagefiles!.path));

    Navigator.of(context).pop();


  }


  Future<io.File?> _cropImage({required io.File imagefile}) async {
    if (_imagefiles != null) {
      final croppedFile = await ImageCropper().cropImage(
          sourcePath: _imagefiles!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,

          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Color.fromARGB(255, 0, 91, 148),
                toolbarWidgetColor: Colors.white,

                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
          ]);
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
        return io.File(croppedFile.path);
      } else{
        return io.File(_imagefiles!.path);
      }
    } else {
      return null;
    }
  }

  vaild_data() {
    _isValid = EmailValidator.validate(_bussemail.text);

    if (_bussname.text.isEmpty) {
      _color1 = Colors.red;
      setState(() {});
    }
    if (_userbussnature.text.isEmpty) {
      _color2 = Colors.red;
      setState(() {});
    }
    if (_loc.text.isEmpty) {
      _color5 = Colors.red;
      setState(() {});
    }
    if (file == null) {
      Fluttertoast.showToast(msg: 'Please Add and Save Your Image');
    } else if (_bussname.text.isEmpty) {
      _color1 = Colors.red;
      setState(() {});
      Fluttertoast.showToast(msg: 'Please Add Your Business Name');
    } else if (_userbussnature.text.isEmpty) {
      _color2 = Colors.red;
      setState(() {});
      Fluttertoast.showToast(
          msg: 'Please Select at least 1 Nature of Business');
    } else if (_loc.text.isEmpty) {
      if (constanst.Bussiness_nature.isNotEmpty) {
        _color2 = Colors.green.shade600;
        setState(() {});
      }
      _color5 = Colors.red;
      setState(() {});
      Fluttertoast.showToast(
          msg: 'Please Search and Save your Business Location');
    } /*else if (_bussmbl.text.isEmpty) {
      _color3 = Colors.red;
      setState(() {

      });
      Fluttertoast.showToast(
          msg: 'Please Add Your Business Mobile ');
    } */
    else if (_bussname.text.isNotEmpty &&
        _loc.text.isNotEmpty &&
        constanst.Bussiness_nature.isNotEmpty) {
      if (_bussmbl.text.isNotEmpty) {
        var numValue = _bussmbl.text.length;
        if (numValue >= 6 && numValue < 11) {
          _color8 = Colors.green.shade600;
          setState(() {});
          if (_bussemail.text.isNotEmpty) {
            if (!_isValid) {
              Fluttertoast.showToast(msg: 'Enter Valid Email Address');
              _color4 = Colors.red;
              setState(() {});
            } else if (_isValid) {
              //  Fluttertoast.showToast(msg: 'Enter Valid Email Address');
              _color4 = Colors.green.shade600;
              setState(() {});
              if (_gstno.text.isNotEmpty) {
                var numValue = _gstno.text.length;

                if (numValue < 15) {
                  Fluttertoast.showToast(
                      msg: 'Enter Valid GST/ VAT/Tax Number');
                  setState(() {
                    _color3 = Colors.red;
                  });
                } else {
                  setState(() {
                    _color3 = Colors.green.shade600;
                  });

                  /* Fluttertoast.showToast(msg: 'Please Enter correct GST Number');*/
                }
              } else {
                _onLoading();
                add_bussinessProfile().then((value) {
                  Navigator.of(dialogContext!).pop();
                  if (value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MainScreen(0)),
                        ModalRoute.withName('/'));
                  } else {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MainScreen(0)),
                        ModalRoute.withName('/'));
                  }
                });
              }
            } else if (_gstno.text.isNotEmpty) {
              var numValue = _gstno.text.length;

              if (numValue < 15) {
                Fluttertoast.showToast(msg: 'Enter Valid GST/ VAT/Tax Number');
                setState(() {
                  _color3 = Colors.red;
                });
              } else {
                setState(() {
                  _color3 = Colors.green.shade600;
                });

                /* Fluttertoast.showToast(msg: 'Please Enter correct GST Number');*/
              }
            } else {
              _onLoading();
              add_bussinessProfile().then((value) {
                Navigator.of(dialogContext!).pop();
                if (value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MainScreen(0)),
                      ModalRoute.withName('/'));
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MainScreen(0)),
                      ModalRoute.withName('/'));
                }
              });
              ;
            }
          } else if (_gstno.text.isNotEmpty) {
            var numValue = _gstno.text.length;

            if (numValue < 15) {
              Fluttertoast.showToast(msg: 'Enter Valid GST/ VAT/Tax Number');
              setState(() {
                _color3 = Colors.red;
              });
            } else {
              setState(() {
                _onLoading();
                add_bussinessProfile().then((value) {
                  Navigator.of(dialogContext!).pop();
                  if (value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MainScreen(0)),
                        ModalRoute.withName('/'));
                  } else {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MainScreen(0)),
                        ModalRoute.withName('/'));
                  }
                });
                _color3 = Colors.green.shade600;
              });

              /* Fluttertoast.showToast(msg: 'Please Enter correct GST Number');*/
            }
          } else {
            _onLoading();
            add_bussinessProfile().then((value) {
              Navigator.of(dialogContext!).pop();
              if (value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen(0)),
                    ModalRoute.withName('/'));
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen(0)),
                    ModalRoute.withName('/'));
              }
            });
          }
        } else {
          _color8 = Colors.red;
          setState(() {});
          Fluttertoast.showToast(msg: 'Please Enter Correct Number');
        }
      } else if (_bussemail.text.isNotEmpty) {
        if (!_isValid) {
          Fluttertoast.showToast(msg: 'Enter Valid Email Address');
          _color4 = Colors.red;
          setState(() {});
        } else if (_isValid) {
          //  Fluttertoast.showToast(msg: 'Enter Valid Email Address');
          _color4 = Colors.green.shade600;
          setState(() {});
          if (_gstno.text.isNotEmpty) {
            var numValue = _gstno.text.length;

            if (numValue < 15) {
              Fluttertoast.showToast(msg: 'Enter Valid GST/ VAT/Tax Number');
              setState(() {
                _color3 = Colors.red;
              });
            } else {
              setState(() {
                _color3 = Colors.green.shade600;
              });

              /* Fluttertoast.showToast(msg: 'Please Enter correct GST Number');*/
            }
          } else {
            _onLoading();
            add_bussinessProfile().then((value) {
              Navigator.of(dialogContext!).pop();
              if (value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen(0)),
                    ModalRoute.withName('/'));
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen(0)),
                    ModalRoute.withName('/'));
              }
            });
          }
        } else if (_gstno.text.isNotEmpty) {
          var numValue = _gstno.text.length;

          if (numValue < 15) {
            Fluttertoast.showToast(msg: 'Enter Valid GST/ VAT/Tax Number');
            setState(() {
              _color3 = Colors.red;
            });
          } else {
            setState(() {
              _color3 = Colors.green.shade600;
            });
          }
        } else {
          _onLoading();
          add_bussinessProfile().then((value) {
            Navigator.of(dialogContext!).pop();
            if (value) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MainScreen(0)),
                  ModalRoute.withName('/'));
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MainScreen(0)),
                  ModalRoute.withName('/'));
            }
          });
        }
      } else if (_gstno.text.isNotEmpty) {
        var numValue = _gstno.text.length;

        if (numValue < 15) {
          Fluttertoast.showToast(msg: 'Enter Valid GST/ VAT/Tax Number');
          setState(() {
            _color3 = Colors.red;
          });
        } else {
          setState(() {
            _onLoading();

            _color3 = Colors.green.shade600;
            add_bussinessProfile().then((value) {
              Navigator.of(dialogContext!).pop();
              if (value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen(0)),
                    ModalRoute.withName('/'));
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainScreen(0)),
                    ModalRoute.withName('/'));
              }
            });
          });

          /* Fluttertoast.showToast(msg: 'Please Enter correct GST Number');*/
        }
      } else {
        _onLoading();
        add_bussinessProfile().then((value) {
          Navigator.of(dialogContext!).pop();
          if (value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen(0)),
                ModalRoute.withName('/'));
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MainScreen(0)),
                ModalRoute.withName('/'));
          }
        });

      }

    }
  }

  Future<bool> add_bussinessProfile() async {
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    constanst.step = 6;
    print(_pref.getString('user_id').toString());
    print(_pref.getString('api_token').toString());
    var res = await addbussiness(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        _bussname.text,
        constanst.Bussiness_nature,
        _loc.text,
        lat.toString(),
        log.toString(),
        '',
        country,
        country_code,
        _bussmbl.text,
        constanst.step.toString(),
        city,
        _bussemail.text,
        _website.text,
        _aboutbuess.text,
        file,
        _gstno.text,
        state);

    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);
      constanst.isprofile = false;
      _pref.setString('userImage', res['profile_image']).toString();
      constanst.image_url = _pref.getString('userImage').toString();
      _isloading1 = true;
    } else {
      _isloading1 = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    return _isloading1;
  }

  ViewItem1(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          // <-- SEE HERE
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        )),
        builder: (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize:
                0.90, // Initial height as a fraction of screen height
            builder: (BuildContext context, ScrollController scrollController) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return type();
                },
              );
            })).then(
      (value) {
        _userbussnature.text = constanst.Bussiness_nature_name;

        setState(() {
          _color2 = Colors.green.shade600;
        });
      },
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

class type extends StatefulWidget {
  const type({Key? key}) : super(key: key);

  @override
  State<type> createState() => _typeState();
}

class _typeState extends State<type> {
  bool gender = false;

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < constanst.btype_data.length; i++) {
      constanst.itemsCheck.add(Icons.circle_outlined);
    }
    setState(() {});

    return Column(
      children: [
        const SizedBox(height: 5),
        Image.asset(
          'assets/hori_line.png',
          width: 150,
          height: 5,
        ),
        const SizedBox(height: 5),
        const Center(
          child: Text('Select Nature Of Business',
              style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'assets\fonst\Metropolis-Black.otf')),
        ),
        const SizedBox(height: 5),
        //-------CircularCheckBox()
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: constanst.btype_data.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                bt.Result record = constanst.btype_data[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      gender = true;
                      if (constanst.itemsCheck[index] ==
                          Icons.circle_outlined) {
                        if (constanst.lstBussiness_nature_name.length <= 2) {
                          constanst.itemsCheck[index] =
                              Icons.check_circle_outline;

                          constanst.lstBussiness_nature_name
                              .add(record.businessType.toString());
                          constanst.Bussiness_nature_name =
                              constanst.lstBussiness_nature_name.join(", ");
                          constanst.lstBussiness_nature
                              .add(record.businessTypeId.toString());

                          constanst.Bussiness_nature =
                              constanst.lstBussiness_nature.join(",");
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  'You Can Select Maximum 3 Nature Of Business ');
                        }
                      } else {
                        constanst.itemsCheck[index] = Icons.circle_outlined;
                        constanst.lstBussiness_nature
                            .remove(record.businessTypeId.toString());
                        constanst.Bussiness_nature =
                            constanst.lstBussiness_nature.join(",");
                        constanst.lstBussiness_nature_name
                            .remove(record.businessType.toString());
                        constanst.Bussiness_nature_name =
                            constanst.lstBussiness_nature_name.join(", ");
                      }
                    });
                  },
                  child: ListTile(
                      title: Text(record.businessType.toString(),
                          style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                      leading: IconButton(
                          icon: constanst.itemsCheck[index] ==
                                  Icons.circle_outlined
                              ? const Icon(Icons.circle_outlined,
                                  color: Colors.black45)
                              : Icon(Icons.check_circle,
                                  color: Colors.green.shade600),
                          onPressed: () {
                            setState(() {
                              gender = true;
                              if (constanst.itemsCheck[index] ==
                                  Icons.circle_outlined) {
                                if (constanst.lstBussiness_nature_name.length <=
                                    2) {
                                  constanst.itemsCheck[index] =
                                      Icons.check_circle_outline;

                                  constanst.lstBussiness_nature_name
                                      .add(record.businessType.toString());
                                  constanst.Bussiness_nature_name = constanst
                                      .lstBussiness_nature_name
                                      .join(",");
                                  constanst.lstBussiness_nature
                                      .add(record.businessTypeId.toString());

                                  constanst.Bussiness_nature =
                                      constanst.lstBussiness_nature.join(", ");
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          'You Can Select Maximum 3 Nature Of Business ');
                                }
                              } else {
                                constanst.itemsCheck[index] =
                                    Icons.circle_outlined;
                                constanst.lstBussiness_nature
                                    .remove(record.businessTypeId.toString());
                                constanst.Bussiness_nature =
                                    constanst.lstBussiness_nature.join(", ");
                                constanst.lstBussiness_nature_name
                                    .remove(record.businessType.toString());
                                constanst.Bussiness_nature_name = constanst
                                    .lstBussiness_nature_name
                                    .join(",");
                              }
                            });
                          }


                          )),
                );
              }),
        ),

        Container(
          width: MediaQuery.of(context).size.width * 1.2,
          height: 60,
          margin: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(50.0),
              color: const Color.fromARGB(255, 0, 91, 148)),
          child: TextButton(
            onPressed: () {
              if (gender) {
                Navigator.pop(context);
                setState(() {});
              log("SELECTED NATURE === ${constanst.lstBussiness_nature}");
              } else {
                Fluttertoast.showToast(msg: 'Select Minimum 1 Category ');
              }
            },
            child: const Text('Update',
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
}
