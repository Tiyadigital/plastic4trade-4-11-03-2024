// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, depend_on_referenced_packages

import 'dart:io' as io;
import 'dart:io' show Platform;

import 'package:Plastic4trade/model/GetBusinessType.dart' as bt;
import 'package:Plastic4trade/utill/constant.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';
import '../constroller/GetBussinessTypeController.dart';
import 'Bussinessinfo.dart';

class EditBussinessProfile extends StatefulWidget {
  const EditBussinessProfile({Key? key}) : super(key: key);

  @override
  State<EditBussinessProfile> createState() => _EditBussinessProfileState();
}

class _EditBussinessProfileState extends State<EditBussinessProfile> {
  bool passenable = true;
  var check_value = false;
  bool isprofile = false;
  bool _isValid = false;
  String? country_code, product_name, category_name;
  String googleApikey = "AIzaSyCyqsD3OPUWGJ5AWbN3iKbUzQGs3Q-ZlPE";
  late double lat = 0.0;
  late double log = 0.0;
  String state = '', city = '', country = '';
  CameraPosition? cameraPosition;
  int? buss_id;
  LatLng startLocation = const LatLng(0, 0);
  final bool _isloading = false;
  String location = "Search Location";
  final TextEditingController _usernm = TextEditingController();
  final TextEditingController _userbussnm = TextEditingController();
  final TextEditingController _userbussnature = TextEditingController();
  final TextEditingController _userloc = TextEditingController();
  final TextEditingController _bussmbl = TextEditingController();
  final TextEditingController _bussemail = TextEditingController();
  final TextEditingController _bussweb = TextEditingController();
  final TextEditingController _bussabout = TextEditingController();

  Color _color1 = Colors.black45;
  Color _color2 = Colors.black45;
  Color _color4 = Colors.black45;
  Color _color5 = Colors.black45;
  Color _color6 = Colors.black45;
  Color _color7 = Colors.black45;
  Color _color8 = Colors.black45;
  Color _color9 = Colors.black45;
  List<String> select_cate = [];
  String? bus_type;
  String defaultCountryCode = 'IN';

  //PhoneNumber number = PhoneNumber(isoCode: 'IN');
  Country? _selectedCountry;
  BuildContext? dialogContext;
  final _formKey = GlobalKey<FormState>();

  io.File? file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCountry();
    checkNetwork();
  }

  void initCountry() async {
    final country = await getCountryByCountryCode(context, defaultCountryCode);
    setState(() {
      _selectedCountry = country;
    });
  }

  void get_data() async {
    GetBussinessTypeController bt = GetBussinessTypeController();
    constanst.bt_data = bt.getBussiness_Type();

    constanst.bt_data!.then((value) {
      for (var item in value) {
        constanst.btype_data.add(item);
      }
    });

    // setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    constanst.select_Bussiness_nature = "";
    constanst.lstBussiness_nature.clear();
    constanst.itemsCheck.clear();
    constanst.selectbusstype_id.clear();
    constanst.btype_data.clear();
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
    final country1 = _selectedCountry;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFDADADA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text('Business Info',
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
      body: isprofile
          ? SingleChildScrollView(
              child: Column(
              children: [
                Column(
                  children: [
                Form(
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
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 18.0, 25.0, 10.0),
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
                                      hintText: 'User Name *',
                                      hintStyle: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf')
                                          .copyWith(color: Colors.black45),

                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color1),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color1),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color1),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                    ),
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        WidgetsBinding.instance.focusManager
                                            .primaryFocus
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
                                        WidgetsBinding.instance.focusManager
                                            .primaryFocus
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
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 0.0, 25.0, 10.0),
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _userbussnm,
                                    keyboardType: TextInputType.name,
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf'),
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
                                      hintText: 'Business Name*',
                                      hintStyle: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf')
                                          .copyWith(color: Colors.black45),

                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color2),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color2),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color2),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),

                                    ),

                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        WidgetsBinding.instance
                                            .focusManager.primaryFocus
                                            ?.unfocus();
                                        Fluttertoast.showToast(
                                            msg:
                                                'Please Enter Your Business Name');
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
                                        WidgetsBinding.instance
                                            .focusManager.primaryFocus
                                            ?.unfocus();
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
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 0.0, 25.0, 10.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _userbussnature,
                                    keyboardType: TextInputType.name,
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf'),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r"[a-zA-Z]+|\s"),
                                      ),
                                    ],
                                    onTap: () async {
                                      setState(() {});
                                      final connectivityResult =
                                          await Connectivity()
                                              .checkConnectivity();

                                      if (connectivityResult ==
                                          ConnectivityResult.none) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'Internet Connection not available');
                                      } else {
                                        ViewItem(context);
                                      }
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Nature Of Business *',
                                      hintStyle: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf')
                                          .copyWith(color: Colors.black45),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color4),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color4),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color4),
                                          borderRadius:
                                              BorderRadius.circular(15.0),),
                                    ),
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        WidgetsBinding.instance.focusManager
                                            .primaryFocus
                                            ?.unfocus();
                                        Fluttertoast.showToast(
                                            msg:
                                                'Please Enter Nature Of Business');
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
                                        WidgetsBinding.instance.focusManager
                                            .primaryFocus
                                            ?.unfocus();
                                        Fluttertoast.showToast(
                                            msg:
                                                'Please Nature Of Business');
                                        setState(() {
                                          _color4 = Colors.red;
                                        });
                                      } else {
                                        setState(() {
                                          _color4 = Colors.green.shade600;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 0.0, 25.0, 5.0),
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _userloc,
                                    keyboardType: TextInputType.name,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontFamily:
                                          'assets/fonst/Metropolis-Black.otf',
                                    ),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r"[a-zA-Z]+|\s"),
                                      ),
                                    ],
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Location/ Address/ City*',
                                      hintStyle: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf',
                                      ).copyWith(color: Colors.black45),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: _color5),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: _color5),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: _color5),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        WidgetsBinding.instance.focusManager
                                            .primaryFocus
                                            ?.unfocus();
                                        Fluttertoast.showToast(
                                            msg:
                                                'Please Enter Your Location');
                                        setState(() {
                                          _color5 = Colors.red;
                                        });
                                      } else {
                                        setState(() {
                                          _color5 = Colors.green.shade600;
                                        });
                                      }
                                    },
                                    onTap: () async {
                                      var place =
                                          await PlacesAutocomplete.show(
                                        context: context,
                                        apiKey: googleApikey,
                                        mode: Mode.overlay,
                                        types: ['establishment', 'geocode'],
                                        // types: ['geocode', 'ADDRESS'],

                                        strictbounds: false,
                                        onError: (err) {
                                        },
                                      );

                                      if (place != null) {
                                        setState(() {
                                          location =
                                              place.description.toString();
                                          _userloc.text = location;
                                          _color5 = Colors.green.shade600;
                                          setState(() {});
                                        });

                                        final plist = GoogleMapsPlaces(
                                          apiKey: googleApikey,
                                          apiHeaders:
                                              await const GoogleApiHeaders()
                                                  .getHeaders(),
                                        );
                                        String placeid =
                                            place.placeId ?? "0";
                                        final detail = await plist
                                            .getDetailsByPlaceId(placeid);

                                        final geometry =
                                            detail.result.geometry!;
                                        lat = geometry.location.lat;
                                        log = geometry.location.lng;
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      if (value.isEmpty) {
                                        WidgetsBinding.instance.focusManager
                                            .primaryFocus
                                            ?.unfocus();
                                        Fluttertoast.showToast(
                                            msg:
                                                'Please Enter Your Location');
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
                                Row(
                                  children: [
                                    Container(
                                        height: 55,
                                        //width: 130,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Colors.white),
                                        margin: const EdgeInsets.fromLTRB(
                                            28.0, 5.0, 5.0, 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          //mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                                height: 57,
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 2),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
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
                                                        country1
                                                            .callingCode,
                                                        textAlign: TextAlign
                                                            .center,
                                                        style:
                                                            const TextStyle(
                                                                fontSize:
                                                                    15),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        )),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 0.0,
                                            right: 25,
                                            bottom: 5.0),
                                        child: TextFormField(
                                          // controller: _usernm,
                                          controller: _bussmbl,
                                          style: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf'),
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                11),
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
                                                        'assets/fonst/Metropolis-Black.otf')
                                                .copyWith(
                                                    color: Colors.black45),
                                            enabledBorder:
                                                OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: _color6),
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                                10.0)),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: _color6),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            focusedBorder:
                                                OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: _color6),
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                                10.0)),
                                          ),
                                          /*   validator: (value) {
                                            if (value!.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Your Bussiness Mobile Number');
                                            } else {
                                              // setState(() {
                                              _color2 =
                                                  Colors.green.shade600;
                                              //});
                                            }

                                            return null;
                                          },*/
                                          onFieldSubmitted: (value) {
                                            var numValue = value.length;
                                            if (numValue >= 6 &&
                                                numValue < 12) {
                                              _color6 =
                                                  Colors.green.shade600;
                                            } else {
                                              _color6 = Colors.red;
                                              WidgetsBinding
                                                  .instance
                                                  .focusManager
                                                  .primaryFocus
                                                  ?.unfocus();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Enter Correct Number');
                                            }
                                          },
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              WidgetsBinding
                                                  .instance
                                                  .focusManager
                                                  .primaryFocus
                                                  ?.unfocus();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Add Correct Mobile Numbe');
                                              setState(() {
                                                _color6 = Colors.red;
                                              });
                                            } else {
                                              setState(() {
                                                _color6 =
                                                    Colors.green.shade600;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 0.0, 25.0, 5.0),
                                  child: TextFormField(
                                    controller: _bussemail,
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
                                      // labelText: 'Your email *',
                                      // labelStyle: TextStyle(color: Colors.red),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: "Business Email",
                                      hintStyle: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf')
                                          .copyWith(color: Colors.black45),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color7),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color7),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color7),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                    ),
                                    /*  validator: (value) {
                                      // if (!EmailValidator.validate(value!)) {
                                      //   return 'Please enter a valid email';
                                      // }
                                      if (value!.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: 'Please Your Email');
                                      } else {
                                        // setState(() {
                                        //_color3 = Colors.green.shade600;
                                        //});
                                      }
                                      return null;
                                    },*/
                                    onFieldSubmitted: (value) {
                                      if (!EmailValidator.validate(value)) {
                                        _color7 = Colors.red;
                                        WidgetsBinding.instance
                                            .focusManager.primaryFocus
                                            ?.unfocus();
                                        Fluttertoast.showToast(
                                            msg:
                                                'Please enter a valid email');
                                        setState(() {});
                                      } else if (value.isEmpty) {
                                        WidgetsBinding.instance
                                            .focusManager.primaryFocus
                                            ?.unfocus();
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
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 5.0, 25.0, 5.0),
                                  child: TextFormField(
                                    controller: _bussweb,
                                    keyboardType: TextInputType.text,
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
                                      // labelText: 'Your email *',
                                      // labelStyle: TextStyle(color: Colors.red),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: "Website",
                                      hintStyle: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf')
                                          .copyWith(color: Colors.black45),

                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color8),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color8),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: _color8),
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                    ),
                                    onFieldSubmitted: (value) {
                                      if (value != '') {
                                        setState(() {
                                          _color8 = Colors.green.shade600;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 5.0, 25.0, 10.0),
                                  child: TextFormField(
                                    controller: _bussabout,
                                    keyboardType: TextInputType.multiline,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    maxLength: 2000,
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf'),
                                    maxLines: 4,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                        hintText: "About Bussiness",
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintStyle: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontFamily:
                                                    'assets/fonst/Metropolis-Black.otf')
                                            .copyWith(
                                                color: Colors.black45),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1, color: _color9),
                                            borderRadius: BorderRadius.circular(
                                                10.0)),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1, color: _color9),
                                            borderRadius:
                                                BorderRadius.circular(
                                                    10.0)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1, color: _color9),
                                            borderRadius: BorderRadius.circular(10.0))

                                        //errorText: _validusernm ? 'Name is not empty' : null),
                                        ),
                                    onFieldSubmitted: (value) {
                                      if (value.isEmpty) {
                                        WidgetsBinding.instance
                                            .focusManager.primaryFocus
                                            ?.unfocus();
                                        Fluttertoast.showToast(
                                            msg:
                                                'Please Your About Bussiness');
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
                                  width: MediaQuery.of(context).size.width *
                                      1.2,
                                  height: 60,
                                  margin: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius:
                                          BorderRadius.circular(50.0),
                                      color:
                                          const Color.fromARGB(255, 0, 91, 148)),
                                  child: TextButton(
                                    onPressed: () {
                                      vaild_data();

                                      setState(() {});
                                    },
                                    child: const Text('Update',
                                        style: TextStyle(
                                            fontSize: 19.0,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            fontFamily:
                                                'assets/fonst/Metropolis-Black.otf')),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]))),
                  ],
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
                          color: Color.fromARGB(255, 0, 91, 148),
                          radius: 20,
                          animating: true,
                        )
                      : Container()),
    );
  }

  vaild_data() {
    _isValid = EmailValidator.validate(_bussemail.text);

    if (_usernm.text.isEmpty) {
      _color1 = Colors.red;
      setState(() {});
    }
    if (_userbussnm.text.isEmpty) {
      _color2 = Colors.red;
      setState(() {});
    }
    if (_userbussnature.text.isEmpty) {
      _color4 = Colors.red;
      setState(() {});
    }
    if (_userloc.text.isEmpty) {
      _color5 = Colors.red;
      setState(() {});
    }
    if (_usernm.text.isEmpty) {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: 'Please Enter Your Name');
    } else if (_userbussnm.text.isEmpty) {
      _color1 = Colors.red;
      setState(() {});
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: 'Please Add Your Business Name');
    } else if (_userbussnature.text.isEmpty) {
      _color4 = Colors.red;
      setState(() {});
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(
          msg: 'Please Select at least 1 Nature of Business');
    } else if (_userloc.text.isEmpty) {
      if (constanst.Bussiness_nature.isNotEmpty) {
        _color5 = Colors.green.shade600;
        setState(() {});
      }
      _color5 = Colors.red;
      setState(() {});
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(
          msg: 'Please Search and Save your Business Location');
    } else if (_usernm.text.isNotEmpty &&
        _userbussnm.text.isNotEmpty &&
        _userloc.text.isNotEmpty &&
        constanst.select_Bussiness_nature.isNotEmpty) {
      if (_bussmbl.text.isNotEmpty) {
        var numValue = _bussmbl.text.length;

        if (numValue >= 6 && numValue < 12) {
          _color2 = Colors.green.shade600;
          setState(() {});
          if (_bussemail.text.isNotEmpty) {
            if (!_isValid) {
              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
              Fluttertoast.showToast(msg: 'Enter Valid Email Address');
              _color7 = Colors.red;
              setState(() {});
            } else if (_isValid) {
              _color7 = Colors.green.shade600;
              setState(() {});

              _onLoading();
              updateUserBusiness_Profile().then((value) {
                Navigator.of(dialogContext!).pop();
                if (value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const Bussinessinfo()),
                      ModalRoute.withName('/'));
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const Bussinessinfo()),
                      ModalRoute.withName('/'));
                }
              });
            }
          } else {
            _onLoading();
            updateUserBusiness_Profile().then((value) {
              Navigator.of(dialogContext!).pop();
              if (value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const Bussinessinfo()),
                    ModalRoute.withName('/'));
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const Bussinessinfo()),
                    ModalRoute.withName('/'));
              }
            });
          }
        } else {
          _color6 = Colors.red;
          setState(() {});
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          Fluttertoast.showToast(msg: 'Please Enter Correct Number');
        }
      } else if (_bussemail.text.isNotEmpty) {
        if (!_isValid) {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          Fluttertoast.showToast(msg: 'Enter Valid Email Address');
          _color7 = Colors.red;
          setState(() {});
        } else if (_isValid) {
          _color7 = Colors.green.shade600;
          setState(() {});

          _onLoading();
          updateUserBusiness_Profile().then((value) {
            Navigator.of(dialogContext!).pop();
            if (value) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Bussinessinfo()),
                  ModalRoute.withName('/'));
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Bussinessinfo()),
                  ModalRoute.withName('/'));
            }
          });
        }
      } else {
        _onLoading();
        updateUserBusiness_Profile().then((value) {
          Navigator.of(dialogContext!).pop();
          if (value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const Bussinessinfo()),
                ModalRoute.withName('/'));
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const Bussinessinfo()),
                ModalRoute.withName('/'));
          }
        });
      }
    }
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

  getProfiless() async {
    SharedPreferences pref = await SharedPreferences.getInstance();


    var res = await getbussinessprofile(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );

    // print("GET PROFILE RESPONSE  === $res");

    if (res['status'] == 1) {
      _usernm.text = res['user']['username'];
      _userbussnm.text = res['profile']['business_name'];
      buss_id = res['profile']['id'];
      _bussemail.text = res['profile']['other_email'];
      _bussweb.text = res['profile']['website'];
      _bussmbl.text = res['profile']['business_phone'];
      _bussabout.text = res['profile']['about_business'];
      _userloc.text = res['profile']['address'];
      country_code = res['profile']['countryCode'];
      _userbussnature.text = res['profile']['business_type_name'];
      city = res['profile']['city'];
      state = res['profile']['state'];
      country = res['profile']['country'];
      product_name = res['profile']['product_name'] ?? "";
      category_name = res['user']['category_name'] ?? "";

      constanst.select_Bussiness_nature = res['profile']['business_type'];
      constanst.lstBussiness_nature =
          res['profile']['business_type_name'].split(',');
      constanst.selectbusstype_id =
          constanst.select_Bussiness_nature.split(',');

      isprofile = true;
    } else {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
    }


    setState(() {});
  }

  Future<bool> updateUserBusiness_Profile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await updateUserBusinessProfile(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        _userbussnm.text.toString(),
        constanst.select_Bussiness_nature.toString(),
        _userloc.text.toString(),
        lat.toString(),
        log.toString(),
        '',
        country,
        country_code.toString(),
        _bussmbl.text.toString(),
        '11',
        city,
        _bussemail.text.toString(),
        _bussweb.text.toString(),
        _bussabout.text.toString(),
        buss_id.toString(),
        state,
        _usernm.text.toString());

    if (res['status'] == 1) {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Bussinessinfo()));
    } else {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
    }
    return _isloading;
  }

  ViewItem(BuildContext context) {
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
                  return const YourWidget();
                },
              );
            })).then(
      (value) {
        if (constanst.selectbusstype_id.isNotEmpty) {
          _userbussnature.text = constanst.lstBussiness_nature.join(', ');
          constanst.select_Bussiness_nature =
              constanst.selectbusstype_id.join(', ');
        }
      },
    );
  }

  Future<void> checkNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      isprofile = true;
    } else {
      get_data();
      getProfiless();
    }
  }
}

class YourWidget extends StatefulWidget {
  const YourWidget({Key? key}) : super(key: key);

  @override
  State<YourWidget> createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  bool gender = false;

  @override
  void initState() {
    super.initState();
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
                  fontFamily: 'assets/fonst/Metropolis-Black.otf')),
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
                      if (!constanst.selectbusstype_id
                          .contains(record.businessTypeId.toString())) {
                        if (constanst.selectbusstype_id.length <= 2) {
                          constanst.itemsCheck[index] =
                              Icons.check_circle_outline;
                          constanst.lstBussiness_nature_name
                              .add(record.businessType.toString());
                          constanst.selectbusstype_id
                              .add(record.businessTypeId.toString());
                          constanst.Bussiness_nature =
                              constanst.lstBussiness_nature_name.join(",");
                          constanst.select_Bussiness_nature =
                              constanst.lstBussiness_nature_name.join(",");
                        } else {
                          WidgetsBinding.instance.focusManager.primaryFocus
                              ?.unfocus();
                          Fluttertoast.showToast(
                              msg:
                                  'You Can Select Maximum 3 Nature of Bussiness');
                        }
                      } else {
                        constanst.itemsCheck[index] = Icons.circle_outlined;
                        constanst.selectbusstype_id
                            .remove(record.businessTypeId.toString());
                        constanst.lstBussiness_nature
                            .remove(record.businessType.toString());
                        constanst.select_Bussiness_nature =
                            constanst.selectbusstype_id.join(",");
                      }
                    });
                  },
                  child: ListTile(
                      title: Text(record.businessType.toString(),
                          style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'assets/fonst/Metropolis-Black.otf')),
                      leading: IconButton(
                          icon: constanst.select_Bussiness_nature
                                  .contains(record.businessTypeId.toString())
                              ? Icon(Icons.check_circle,
                                  color: Colors.green.shade600)
                              : const Icon(Icons.circle_outlined,
                                  color: Colors.black45),
                          onPressed: () {
                            setState(() {

                              gender = true;

                              if (!constanst.selectbusstype_id
                                  .contains(record.businessTypeId.toString())) {
                                if (constanst.selectbusstype_id.length <= 2) {
                                  constanst.itemsCheck[index] =
                                      Icons.check_circle_outline;

                                  constanst.lstBussiness_nature
                                      .add(record.businessType.toString());
                                  constanst.selectbusstype_id
                                      .add(record.businessTypeId.toString());
                                  constanst.Bussiness_nature =
                                      constanst.lstBussiness_nature.join(",");
                                  constanst.select_Bussiness_nature =
                                      constanst.lstBussiness_nature.join(",");
                                } else {
                                  WidgetsBinding
                                      .instance.focusManager.primaryFocus
                                      ?.unfocus();
                                  Fluttertoast.showToast(
                                      msg:
                                          'You Can Select Maximum 3 Nature of Bussiness');
                                }
                              } else {
                                constanst.itemsCheck[index] =
                                    Icons.circle_outlined;
                                constanst.selectbusstype_id
                                    .remove(record.businessTypeId.toString());
                                constanst.lstBussiness_nature
                                    .remove(record.businessType.toString());
                                constanst.select_Bussiness_nature =
                                    constanst.selectbusstype_id.join(",");
                              }
                            });
                          })),
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
              if (constanst.selectbusstype_id.isNotEmpty) {
                Navigator.pop(context);
                setState(() {});
              } else {
                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                Fluttertoast.showToast(
                    msg: 'Select Minimum 1 Nature of Bussiness ');
              }
            },
            child: const Text('Update',
                style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'assets/fonst/Metropolis-Black.otf')),
          ),
        ),
      ],
    );
  }
}
