import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:io' as io;
import 'package:Plastic4trade/model/GetBusinessType.dart' as bt;
import 'package:Plastic4trade/utill/constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import '../api/api_interface.dart';
import '../constroller/GetBussinessTypeController.dart';
import '../model/common.dart';
import '../widget/MainScreen.dart';
import 'dart:io' show Platform;

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
  LatLng startLocation = LatLng(0, 0);
  bool _isloading=false;
  String location = "Search Location";
  TextEditingController _usernm = TextEditingController();
  TextEditingController _userbussnm = TextEditingController();
  TextEditingController _userbussnature = TextEditingController();
  TextEditingController _userloc = TextEditingController();
  TextEditingController _bussmbl = TextEditingController();
  TextEditingController _bussemail = TextEditingController();
  TextEditingController _bussweb = TextEditingController();
  TextEditingController _bussabout = TextEditingController();

  Color _color1 = Colors.black45;
  Color _color2 = Colors.black45;
  Color _color3 = Colors.black45;
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
  bool _isloading1 = false;
  var _formKey = GlobalKey<FormState>();

  io.File? file;
  //enum FavoriteMethod { flutter, kotlin, swift, reactNative }

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

  Widget initwidget() {
    final country1 = _selectedCountry;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFDADADA),
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
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: isprofile
          ? SingleChildScrollView(
              child: Column(
              children: [
                Container(
                    child: Column(
                  children: [
                    Form(
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
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          25.0, 18.0, 25.0, 10.0),
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _usernm,
                                        keyboardType: TextInputType.name,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets\fonst\Metropolis-Black.otf'),
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
                                          // errorBorder: OutlineInputBorder(
                                          //   borderSide:
                                          //       BorderSide(width: 1, color: Colors.red),
                                          // ),
                                          // focusedErrorBorder: OutlineInputBorder(
                                          //   borderSide: BorderSide(
                                          //       width: 1, color: Colors.green.shade600),
                                          //     borderRadius:
                                          //     BorderRadius.circular(10.0)
                                          // ),
                                        ),
                                       /* validator: (value) {
                                          if (value!.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg: 'Please Enter Your Name!');
                                          } else {
                                            // setState(() {
                                            _color1 = Colors.green.shade600;
                                            // });
                                          }
                                          return null;
                                        },*/
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
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
                                            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
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
                                      padding: EdgeInsets.fromLTRB(
                                          25.0, 0.0, 25.0, 10.0),
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _userbussnm,
                                        keyboardType: TextInputType.name,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets\fonst\Metropolis-Black.otf'),
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
                                          hintStyle: TextStyle(
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
                                          // errorBorder: OutlineInputBorder(
                                          //   borderSide:
                                          //       BorderSide(width: 1, color: Colors.red),
                                          // ),
                                          // focusedErrorBorder: OutlineInputBorder(
                                          //   borderSide: BorderSide(
                                          //       width: 1, color: Colors.green.shade600),
                                          //     borderRadius:
                                          //     BorderRadius.circular(10.0)
                                          // ),
                                        ),
                                        /*validator: (value) {
                                          if (value!.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Please Enter Your Business Name');
                                          } else {
                                            // setState(() {
                                            _color2 = Colors.green.shade600;
                                            // });
                                          }
                                          return null;
                                        },*/
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
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
                                            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
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
                                      padding: EdgeInsets.fromLTRB(
                                          25.0, 0.0, 25.0, 10.0),
                                      child: TextFormField(
                                        readOnly: true,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _userbussnature,
                                        keyboardType: TextInputType.name,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets\fonst\Metropolis-Black.otf'),
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        textInputAction: TextInputAction.next,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r"[a-zA-Z]+|\s"),
                                          ),
                                        ],
                                        onTap: () async {
                                          //Fluttertoast.showToast(msg: 'hello');
                                          /*InkWell(
                                      onTap: () {*/
                                          //Fluttertoast.showToast(msg: 'hello');
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
                                          //},
                                          //);
                                        },
                                        decoration: InputDecoration(
                                          // labelText: 'Your Name*',
                                          // labelStyle: TextStyle(color: Colors.red),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Nature Of Business *',

                                          hintStyle: TextStyle(
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
                                                  BorderRadius.circular(15.0)),
                                          // errorBorder: OutlineInputBorder(
                                          //   borderSide:
                                          //       BorderSide(width: 1, color: Colors.red),
                                          // ),
                                          // focusedErrorBorder: OutlineInputBorder(
                                          //   borderSide: BorderSide(
                                          //       width: 1, color: Colors.green.shade600),
                                          //     borderRadius:
                                          //     BorderRadius.circular(10.0)
                                          // ),
                                        ),
                                       /* validator: (value) {
                                          if (value!.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Please Enter Nature Of Business');
                                          } else {
                                            // setState(() {
                                            _color4 = Colors.green.shade600;
                                            // });
                                          }
                                          return null;
                                        },*/
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
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
                                            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
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
                                      padding: EdgeInsets.fromLTRB(
                                          25.0, 0.0, 25.0, 5.0),
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _userloc,
                                        keyboardType: TextInputType.name,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets\fonst\Metropolis-Black.otf'),
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        textInputAction: TextInputAction.next,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r"[a-zA-Z]+|\s"),
                                          ),
                                          //LengthLimitingTextInputFormatter(30)
                                        ],
                                        decoration: InputDecoration(
                                          // labelText: 'Your Name*',
                                          // labelStyle: TextStyle(color: Colors.red),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Location/ Address/ City*',
                                          hintStyle: TextStyle(
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
                                                  BorderRadius.circular(15.0)),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color5),
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color5),
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          // errorBorder: OutlineInputBorder(
                                          //   borderSide:
                                          //       BorderSide(width: 1, color: Colors.red),
                                          // ),
                                          // focusedErrorBorder: OutlineInputBorder(
                                          //   borderSide: BorderSide(
                                          //       width: 1, color: Colors.green.shade600),
                                          //     borderRadius:
                                          //     BorderRadius.circular(10.0)
                                          // ),
                                        ),
                                     /*   validator: (value) {
                                          if (value!.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Please Enter Your Location');
                                          } else {
                                            // setState(() {
                                            _color5 = Colors.green.shade600;
                                            // });
                                          }
                                          return null;
                                        },*/
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
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
                                          var place = await PlacesAutocomplete.show(
                                              context: context,
                                              apiKey: googleApikey,
                                              mode: Mode.overlay,
                                              types: ['(cities)'],
                                              strictbounds: false,
                                              // components: [Component(Component.country, 'np')],
                                              //google_map_webservice package
                                              onError: (err) {
                                                print(err);
                                              });

                                          if (place != null) {
                                            setState(() {
                                              location =
                                                  place.description.toString();

                                              List<String> list = place
                                                  .description
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
                                              print(state);
                                              print(city);
                                              print(country);
                                              _userloc.text = location;
                                              _color5 = Colors.green.shade600;
                                              // print(location);
                                              setState(() {});
                                            });

                                            //form google_maps_webservice package
                                            final plist = GoogleMapsPlaces(
                                              apiKey: googleApikey,
                                              apiHeaders:
                                                  await GoogleApiHeaders()
                                                      .getHeaders(),
                                              //from google_api_headers package
                                            );
                                            String placeid =
                                                place.placeId ?? "0";
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
                                        onFieldSubmitted: (value) {
                                          if (value.isEmpty) {
                                            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
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
                                            margin: EdgeInsets.fromLTRB(
                                                28.0, 5.0, 5.0, 10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              //mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                    height: 57,
                                                    padding: EdgeInsets.only(
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
                                                      onTap: () {},
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
                                                            textAlign: TextAlign
                                                                .center,
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
                                            margin: EdgeInsets.only(
                                                left: 0.0,
                                                right: 25,
                                                bottom: 5.0),
                                            child: TextFormField(
                                              // controller: _usernm,
                                              controller: _bussmbl,
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets\fonst\Metropolis-Black.otf'),
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(13),
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
                                                hintStyle: TextStyle(
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
                                                    numValue < 13) {
                                                  _color6 =
                                                      Colors.green.shade600;
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
                                      padding: EdgeInsets.fromLTRB(
                                          25.0, 0.0, 25.0, 5.0),
                                      child: TextFormField(
                                        controller: _bussemail,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets\fonst\Metropolis-Black.otf'),
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          // labelText: 'Your email *',
                                          // labelStyle: TextStyle(color: Colors.red),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: "Bussiness Email",
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
                                            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Please enter a valid email');
                                            setState(() {});
                                          } else if (value.isEmpty) {
                                            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
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
                                      padding: EdgeInsets.fromLTRB(
                                          25.0, 5.0, 25.0, 5.0),
                                      child: TextFormField(
                                        controller: _bussweb,
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
                                        decoration: InputDecoration(
                                          // labelText: 'Your email *',
                                          // labelStyle: TextStyle(color: Colors.red),
                                          filled: true,
                                          fillColor: Colors.white,
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
                                      /*  validator: (value) {
                                          // if (!EmailValidator.validate(value!)) {
                                          //   return 'Please enter a valid email';
                                          // }

                                          if (value!.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg: 'Please Your Website');
                                          } else {
                                            // setState(() {
                                            //_color3 = Colors.green.shade600;
                                            //});
                                          }
                                          return null;
                                        },*/
                                        onFieldSubmitted: (value) {
                                          String msg = hasValidUrl(value);
                                          if (msg != '') {
                                            setState(() {
                                              _color8 = Colors.red;
                                              Fluttertoast.showToast(msg: msg);
                                            });
                                          } else {
                                            setState(() {
                                              _color8 = Colors.green.shade600;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          25.0, 5.0, 25.0, 10.0),
                                      child: TextFormField(
                                        controller: _bussabout,
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
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintStyle: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf')
                                                ?.copyWith(
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
                                     /*   validator: (value) {
                                          // if (!EmailValidator.validate(value!)) {
                                          //   return 'Please enter a valid email';
                                          // }
                                          if (value!.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Please Your About Bussiness');
                                          } else {
                                            // setState(() {
                                            //_color3 = Colors.green.shade600;
                                            //});
                                          }
                                          return null;
                                        },*/
                                        onFieldSubmitted: (value) {
                                          if (value.isEmpty) {
                                            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
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
                                      margin: EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          color:
                                              Color.fromARGB(255, 0, 91, 148)),
                                      child: TextButton(
                                        onPressed: () {
                                        /*  if (_formKey.currentState!
                                              .validate()) {*/
                                            /* Fluttertoast.showToast(msg: "Data Proccess");*/
                                            vaild_data();
                                          //}
                                          setState(() {});
                                        },
                                        child: Text('Update',
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
                              )
                            ]))),
                  ],
                )),
              ],
            ))
          : Center(
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
    );
  }

  String hasValidUrl(String value) {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter url';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid url';
    }
    return '';
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
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: 'Please Enter Your Name');
    } else if (_userbussnm.text.isEmpty) {
      _color1 = Colors.red;
      setState(() {});
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: 'Please Add Your Business Name');
    } else if (_userbussnature.text.isEmpty) {
      _color4 = Colors.red;
      setState(() {});
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(
          msg: 'Please Select at least 1 Nature of Business');
    } else if (_userloc.text.isEmpty) {
      if (constanst.Bussiness_nature.isNotEmpty) {
        _color5 = Colors.green.shade600;
        setState(() {});
      }
      _color5 = Colors.red;
      setState(() {});
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(
          msg: 'Please Search and Save your Business Location');
    } else if (_usernm.text.isNotEmpty &&
        _userbussnm.text.isNotEmpty &&
        _userloc.text.isNotEmpty &&
        constanst.select_Bussiness_nature.isNotEmpty) {
      if (_bussmbl.text.isNotEmpty) {
        var numValue = _bussmbl.text.length;

        if (numValue >= 6 && numValue < 11) {
          _color2 = Colors.green.shade600;
          setState(() {});
          if (_bussemail.text.isNotEmpty) {
            if (!_isValid) {
              WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
              Fluttertoast.showToast(msg: 'Enter Valid Email Address');
              _color7 = Colors.red;
              setState(() {});
            } else if (_isValid) {
              //  Fluttertoast.showToast(msg: 'Enter Valid Email Address');
              _color7 = Colors.green.shade600;
              setState(() {});

                _onLoading();
                updateUserBusiness_Profile().then((value) {
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
          } else{
            _onLoading();
            updateUserBusiness_Profile().then((value) {
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
          _color6 = Colors.red;
          setState(() {});
          WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
          Fluttertoast.showToast(msg: 'Please Enter Correct Number');
        }
      }
      else if (_bussemail.text.isNotEmpty) {
        if (!_isValid) {
          WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
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
      else{
        _onLoading();
        updateUserBusiness_Profile().then((value) {
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

/*    if (_userbussnm.text.isNotEmpty &&
        _usernm.text.isNotEmpty &&
        _bussmbl.text.isNotEmpty &&
        _bussemail.text.isNotEmpty &&
        _userloc.text.isNotEmpty &&
        _userbussnature.text.isNotEmpty &&
        _bussweb.text.isNotEmpty &&
        _bussabout.text.isNotEmpty) {
      _onLoading();
      updateUserBusiness_Profile().then((value) {
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

      //_registerApi();
    }*/
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

  getProfiless() async {
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(_pref.getString('user_id').toString());

    var res = await getbussinessprofile(
      _pref.getString('user_id').toString(),
      _pref.getString('api_token').toString(),
    );

    print(res);
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

      print(_usernm.text.toString());

      String myString = res['profile']['business_type'];

      /*  List<String> stringList = myString.split(",");
      print(stringList);
      for(int i=0;i<stringList.length;i++){
        findcartItem(stringList[i].toString());
      }*/
      isprofile = true;
      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(0)));*/
    } else {
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
      // Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {});
  }

  Future<bool> updateUserBusiness_Profile() async {
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(_pref.getString('user_id').toString());
    print(_pref.getString('A').toString());
    var res = await updateUserBusinessProfile(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
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

    print(res);
    if (res['status'] == 1) {
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(0)));
      _isloading1=true;
    } else {
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
      _isloading1=true;
    }
    return _isloading;
  }

  /*Widget _buildDropdownItem(Country country) => Container(
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
                  return YourWidget();
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

  Future<void> checknetowork() async {
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
  String? assignedName;
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
        SizedBox(height: 5),
        Image.asset(
          'assets/hori_line.png',
          width: 150,
          height: 5,
        ),
        SizedBox(height: 5),
        Center(
          child: Text('Select Nature Of Business',
              style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'assets\fonst\Metropolis-Black.otf')),
        ),
        SizedBox(height: 5),
        //-------CircularCheckBox()
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: constanst.btype_data.length,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                bt.Result record = constanst.btype_data[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      gender = true;
                      /*if (constanst.itemsCheck[index] ==
                                Icons.circle_outlined) {*/
                      if (!constanst.selectbusstype_id
                          .contains(record.businessTypeId.toString())) {
                        // print('1236 ${constanst.selectbusstype_id}');
                        if (constanst.selectbusstype_id.length <= 2) {
                          constanst.itemsCheck[index] =
                              Icons.check_circle_outline;
                          //constanst.select_Bussiness_nature
                          constanst.lstBussiness_nature
                              .add(record.businessType.toString());
                          constanst.selectbusstype_id
                              .add(record.businessTypeId.toString());
                          constanst.Bussiness_nature =
                              constanst.lstBussiness_nature.join(",");
                          constanst.select_Bussiness_nature =
                              constanst.lstBussiness_nature.join(",");
                        } else {
                          WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                          Fluttertoast.showToast(
                              msg:
                              'You Can Select Maximum 3 Nature of Bussiness');
                        }
                      } else {
                        // print('1236 ${constanst.selectbusstype_id}');
                        print(record.businessType.toString());
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
                  },
                  child: ListTile(
                      title: Text(record.businessType.toString(),
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                      leading: IconButton(
                          icon: constanst.selectbusstype_id
                                  .contains(record.businessTypeId.toString())
                              ? Icon(Icons.check_circle,
                                  color: Colors.green.shade600)
                              : Icon(Icons.circle_outlined,
                                  color: Colors.black45),
                          onPressed: () {
                            setState(() {
                              gender = true;
                              /*if (constanst.itemsCheck[index] ==
                                  Icons.circle_outlined) {*/
                              if (!constanst.selectbusstype_id
                                  .contains(record.businessTypeId.toString())) {
                                // print('1236 ${constanst.selectbusstype_id}');
                                if (constanst.selectbusstype_id.length <= 2) {
                                  constanst.itemsCheck[index] =
                                      Icons.check_circle_outline;
                                  //constanst.select_Bussiness_nature
                                  constanst.lstBussiness_nature
                                      .add(record.businessType.toString());
                                  constanst.selectbusstype_id
                                      .add(record.businessTypeId.toString());
                                  constanst.Bussiness_nature =
                                      constanst.lstBussiness_nature.join(",");
                                  constanst.select_Bussiness_nature =
                                      constanst.lstBussiness_nature.join(",");
                                } else {
                                  WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                  Fluttertoast.showToast(
                                      msg:
                                          'You Can Select Maximum 3 Nature of Bussiness');
                                }
                              } else {
                                // print('1236 ${constanst.selectbusstype_id}');
                                print(record.businessType.toString());
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
          margin: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(50.0),
              color: Color.fromARGB(255, 0, 91, 148)),
          child: TextButton(
            onPressed: () {
              if (constanst.selectbusstype_id.isNotEmpty) {
                Navigator.pop(context);
                setState(() {});
                /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryScreen()));*/
              } else {
                WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                Fluttertoast.showToast(
                    msg: 'Select Minimum 1 Nature of Bussiness ');
              }
            },
            child: Text('Update',
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
