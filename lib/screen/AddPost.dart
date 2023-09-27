// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, camel_case_types, unnecessary_null_comparison, non_constant_identifier_names

import 'dart:async';
import 'package:Plastic4trade/widget/MainScreen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Plastic4trade/constroller/GetColorsController.dart';
import 'package:Plastic4trade/constroller/GetUnitController.dart';

import 'package:Plastic4trade/utill/constant.dart';
import 'dart:io' as io;
import 'package:Plastic4trade/model/GetCategory.dart' as cat;
import 'package:Plastic4trade/model/GetCategoryType.dart' as type;
import 'package:Plastic4trade/model/GetCategoryGrade.dart' as grade;
import 'package:Plastic4trade/model/GetColors.dart' as color;
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_interface.dart';
import '../constroller/GetCategoryController.dart';
import '../constroller/GetCategoryGradeController.dart';
import '../constroller/GetCategoryTypeController.dart';
import '../model/GetProductName.dart';
import 'package:Plastic4trade/model/GetProductName.dart' as pnm;
import 'dart:io' show Platform;

import '../model/common.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(this.isSelected, this.buttonText);
}

class _AddPostState extends State<AddPost> {
  List<RadioModel> sampleData1 = <RadioModel>[];
  final TextEditingController _prodnm = TextEditingController();
  final TextEditingController _prod_cate = TextEditingController();
  final TextEditingController _prod_type = TextEditingController();
  final TextEditingController _prod_grade = TextEditingController();
  final TextEditingController _prodprice = TextEditingController();
  final TextEditingController _prodcolor = TextEditingController();
  final TextEditingController _prodqty = TextEditingController();
  final TextEditingController _loc = TextEditingController();
  final TextEditingController _proddetail = TextEditingController();

  Color _color1 = Colors.black26;
  Color _color2 = Colors.black26;
  Color _color3 = Colors.black26;
  Color _color4 = Colors.black26;
  Color _color5 = Colors.black26;
  Color _color6 = Colors.black26;
  Color _color7 = Colors.black26;
  Color _color8 = Colors.grey;

  Color _color10 = Colors.grey;

  List<String> _suggestions = [];

  String? address;
  var place;

  final _formKey = GlobalKey<FormState>();
  PickedFile? _imagefiles, _imagefiles1, _imagefiles2;
  io.File? file, file1, file2, mainfile;
  bool? _isloading = false;
  bool _isloading1 = false;
  late double lat = 0.0;
  late double log = 0.0;
  String state = '', country_code = '+91', city = '', country = '';
  final ImagePicker _picker = ImagePicker();
  bool category1 = false;
  String type_post = "";

  String? _selectitem4 = null, _selectitem5 = null, _selectitem6 = null;
  String googleApikey = "AIzaSyCyqsD3OPUWGJ5AWbN3iKbUzQGs3Q-ZlPE";

  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(0, 0);
  String location = "Search Location";
  BuildContext? dialogContext;
  List listrupes = ['₹', '\$', '€', '£', '¥'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleData1.add(RadioModel(false, 'Buy Post'));
    sampleData1.add(RadioModel(false, 'Sell Post'));

    checknetwork();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    clear_data();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return initwidget(context);
  }

  Widget initwidget(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
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
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: _isloading == false
                        ? Center(
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
                                    : Container())
                        : Column(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    child: Image.asset('assets/back.png',
                                        height: 50, width: 60),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 100.0,
                                  ),
                                  Center(
                                      child: Text(
                                    'Add Post',
                                    style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets\fonst\Metropolis-Black.otf')
                                        .copyWith(fontSize: 20.0),
                                  ))
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(
                                    25.0, 10.0, 25.0, 5.0),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'You’re like to do?',
                                        style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf')
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black38),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          child: SizedBox(
                                            height: 30,
                                            width: 120,
                                            child: Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      child: sampleData1.first
                                                                  .isSelected ==
                                                              true
                                                          ? Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color: Colors
                                                                  .green
                                                                  .shade600)
                                                          : const Icon(
                                                              Icons
                                                                  .circle_outlined,
                                                              color: Colors
                                                                  .black38),
                                                      onTap: () {
                                                        setState(() {
                                                          sampleData1.first
                                                                  .isSelected =
                                                              true;
                                                          type_post =
                                                              sampleData1.first
                                                                  .buttonText;
                                                          sampleData1.last
                                                                  .isSelected =
                                                              false;
                                                          category1 = true;
                                                        });
                                                      },
                                                    ),
                                                    Text(
                                                        sampleData1
                                                            .first.buttonText,
                                                        style: const TextStyle(
                                                                fontSize: 13.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'assets\fonst\Metropolis-Black.otf')
                                                            .copyWith(
                                                                fontSize: 17))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              sampleData1.first.isSelected =
                                                  true;
                                              type_post =
                                                  sampleData1.first.buttonText;
                                              sampleData1.last.isSelected =
                                                  false;
                                              category1 = true;
                                            });
                                          },
                                        ),
                                        GestureDetector(
                                          child: SizedBox(
                                              width: 150,
                                              height: 30,
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    child: sampleData1.last
                                                                .isSelected ==
                                                            true
                                                        ? Icon(
                                                            Icons.check_circle,
                                                            color: Colors
                                                                .green.shade600)
                                                        : const Icon(
                                                            Icons
                                                                .circle_outlined,
                                                            color:
                                                                Colors.black38),
                                                    onTap: () {
                                                      setState(() {
                                                        sampleData1.last
                                                            .isSelected = true;
                                                        sampleData1.first
                                                            .isSelected = false;
                                                        category1 = true;
                                                        type_post = sampleData1
                                                            .last.buttonText;
                                                        //Fluttertoast.showToast(msg: 'hell $sampleData.last.isSelected');
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                      sampleData1
                                                          .last.buttonText,
                                                      style: const TextStyle(
                                                              fontSize: 13.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-Black.otf')
                                                          .copyWith(
                                                              fontSize: 17))
                                                ],
                                              )),
                                          onTap: () {
                                            setState(() {
                                              sampleData1.last.isSelected =
                                                  true;
                                              sampleData1.first.isSelected =
                                                  false;
                                              category1 = true;
                                              type_post =
                                                  sampleData1.last.buttonText;
                                              //Fluttertoast.showToast(msg: 'hell $sampleData.last.isSelected');
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    25.0, 5.0, 25.0, 5.0),
                                child: SizedBox(
                                  height: 55,
                                  child: TypeAheadField<String>(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      controller: _prodnm,
                                      style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets\fonst\Metropolis-Black.otf'),
                                      onChanged: (value) {
                                        // vaild_data();
                                        if (value.isEmpty) {
                                          WidgetsBinding.instance?.focusManager
                                              .primaryFocus
                                              ?.unfocus();
                                          Fluttertoast.showToast(
                                              msg:
                                                  'Please Add Your Product Name');
                                          _color1 = Colors.red;
                                        } else {}
                                      },
                                      onSubmitted: (value) {
                                        if (value.isEmpty) {
                                          _color1 = Colors.red;
                                          setState(() {});
                                        } else if (value.isNotEmpty) {
                                          _color1 = Colors.green.shade600;
                                          setState(() {});
                                        }
                                      },
                                      textCapitalization:
                                          TextCapitalization.words,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        hintText: "Product Name *",
                                        hintStyle: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf')
                                            .copyWith(color: Colors.grey),
                                        filled: true,
                                        fillColor: Colors.white,
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
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) {
                                      return _getSuggestions(pattern);
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(
                                          suggestion,
                                          style: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf'),
                                        ),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      _prodnm.text = suggestion;
                                      _color1 = Colors.green.shade600;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    25.0, 5.0, 25.0, 5.0),
                                child: TextFormField(
                                    controller: _prod_cate,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf'),
                                    readOnly: true,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      suffixIcon:
                                          Icon(Icons.arrow_drop_down_sharp),
                                      hintText: "Product Category*",
                                      hintStyle: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf')
                                          .copyWith(color: Colors.grey),
                                      filled: true,
                                      fillColor: Colors.white,
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
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        _color2 = Colors.red;
                                      } else {}
                                      return null;
                                    },
                                    onTap: () {
                                      Viewproduct(context);
                                    },
                                    onFieldSubmitted: (value) {
                                      if (value.isEmpty) {
                                        setState(() {});
                                      } else if (value.isNotEmpty) {
                                        setState(() {});
                                      }
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    25.0, 5.0, 25.0, 5.0),
                                child: TextFormField(
                                    controller: _prod_type,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf'),
                                    readOnly: true,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      suffixIcon: const Icon(
                                          Icons.arrow_drop_down_sharp),
                                      hintText: "Product Type *",
                                      hintStyle: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf')
                                          .copyWith(color: Colors.grey),
                                      filled: true,
                                      fillColor: Colors.white,
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
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        _color3 = Colors.red;
                                      } else {}
                                      return null;
                                    },
                                    onTap: () {
                                      Viewtype(context);
                                    },
                                    onFieldSubmitted: (value) {
                                      if (value.isEmpty) {
                                        setState(() {});
                                      } else if (value.isNotEmpty) {
                                        setState(() {});
                                      }
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    25.0, 5.0, 25.0, 5.0),
                                child: TextFormField(
                                    controller: _prod_grade,
                                    keyboardType: TextInputType.text,
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf'),
                                    readOnly: true,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      hintText: "Product Grade*",
                                      hintStyle: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf')
                                          .copyWith(color: Colors.grey),
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: const Icon(
                                          Icons.arrow_drop_down_sharp),
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
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        _color4 = Colors.red;
                                      } else {}
                                      return null;
                                    },
                                    onTap: () {
                                      Viewgrade(context);
                                    },
                                    onFieldSubmitted: (value) {
                                      if (value.isEmpty) {
                                        setState(() {});
                                      } else if (value.isNotEmpty) {
                                        setState(() {});
                                      }
                                    }),
                              ),
                              Container(
                                height: 62,
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: _color8),
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.9,
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _prodprice,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets\fonst\Metropolis-Black.otf'),
                                        textInputAction: TextInputAction.next,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r"\d"),
                                          ),
                                          LengthLimitingTextInputFormatter(5)
                                        ],
                                        decoration: InputDecoration(
                                            // labelText: 'Your Name*',
                                            // labelStyle: TextStyle(color: Colors.red),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Price *',
                                            hintStyle: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey,
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf'),
                                            border: InputBorder.none),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            /*  Fluttertoast.showToast(
                                                  msg:
                                                      'Please Add Your Product Price');*/
                                          } else {
                                            // setState(() {
                                            // });
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            /*  Fluttertoast.showToast(
                                                  msg:
                                                      'Please Add Your Product Price');*/
                                            setState(() {});
                                          }
                                        },
                                        onFieldSubmitted: (value) {
                                          if (value.isEmpty) {
                                            /* Fluttertoast.showToast(
                                                  msg:
                                                      'Please Add Your Product Price');*/
                                            setState(() {});
                                          } else {
                                            setState(() {});
                                          }
                                        },
                                      )),
                                  VerticalDivider(
                                    width: 1,
                                    color: Colors.black38,
                                  ),
                                  Unit_dropdown(constanst.unitdata, "Unit"),
                                  VerticalDivider(
                                    width: 1,
                                    color: Colors.black38,
                                  ),
                                  rupess_dropdown(listrupes, 'Currency'),
                                ]),
                              ),
                              Container(
                                height: 62,
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 5.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: _color10),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(children: [
                                  Container(
                                      //color: Colors.white,

                                      width: MediaQuery.of(context).size.width /
                                          1.7,
                                      padding: EdgeInsets.only(
                                          top: 3, bottom: 3.0, left: 2.0),
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _prodqty,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets\fonst\Metropolis-Black.otf'),
                                        textInputAction: TextInputAction.next,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r"\d"),
                                          ),
                                          LengthLimitingTextInputFormatter(5)
                                        ],
                                        decoration: InputDecoration(
                                            // labelText: 'Your Name*',
                                            // labelStyle: TextStyle(color: Colors.red),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Qty *',
                                            hintStyle: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf')
                                                .copyWith(height: 2),
                                            border: InputBorder.none),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            /*Fluttertoast.showToast(
                                                  msg:
                                                      'Please Add Your Product Quantity');*/
                                          } else {
                                            // setState(() {
                                            // });
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            /*  Fluttertoast.showToast(
                                                  msg:
                                                      'Please Add Your Product Quantity');*/
                                            setState(() {});
                                          }
                                        },
                                        onFieldSubmitted: (value) {
                                          if (value.isEmpty) {
                                            /*Fluttertoast.showToast(
                                                  msg: 'Please Add Your Product Quantity');*/
                                            setState(() {});
                                          } else {
                                            setState(() {});
                                          }
                                        },
                                      )),
                                  VerticalDivider(
                                    width: 1,
                                    color: Colors.black38,
                                  ),
                                  Unit_dropdown1(constanst.unitdata, 'Unit')
                                ]),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                                child: TextFormField(
                                    controller: _prodcolor,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf'),
                                    readOnly: true,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      hintText: "Color*",
                                      hintStyle: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf')
                                          .copyWith(color: Colors.grey),
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon:
                                          Icon(Icons.arrow_drop_down_sharp),
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
                                        /* Fluttertoast.showToast(
                                              msg: 'Please Select Product Colour');*/
                                        _color5 = Colors.red;
                                      } else {
                                        // setState(() {
                                        //_color3 = Colors.green.shade600;
                                        //});
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      //Fluttertoast.showToast(msg: 'hello');
                                      /*InkWell(
                                      onTap: () {*/
                                      //Fluttertoast.showToast(msg: 'hello');
                                      ViewItem(context);
                                      //},
                                      //);
                                    },
                                    onFieldSubmitted: (value) {
                                      if (value.isEmpty) {
                                        /*Fluttertoast.showToast(
                                              msg: 'Please Select Product Colour');*/
                                        _color5 = Colors.red;
                                        setState(() {});
                                      } else if (value.isNotEmpty) {
                                        setState(() {});
                                      }
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    25.0, 5.0, 25.0, 5.0),
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
                                    place = await PlacesAutocomplete.show(
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
                                        location = place.description.toString();
                                        _loc.text = location;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Location/ Address / City",
                                    hintStyle: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf'),

                                    filled: true,
                                    fillColor: Colors.white,

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
                                  validator: (value) {
                                    // if (!EmailValidator.validate(value!)) {
                                    //   return 'Please enter a valid email';
                                    // }
                                    if (value!.isEmpty) {
                                      // return 'Enter a Location!';
                                      _color6 = Colors.red;
                                    } else {
                                      // setState(() {
                                      //_color3 = Colors.green.shade600;
                                      //});
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (value) {
                                    if (value.isEmpty) {
                                      /* Fluttertoast.showToast(
                                            msg: 'Please Add Stock Location ');*/
                                      setState(() {
                                        _color6 = Colors.red;
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
                                padding:
                                    EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 10.0),
                                child: TextFormField(
                                  controller: _proddetail,
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
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: "Product Description ",
                                    hintStyle: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf'),
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
                                            BorderRadius.circular(10.0)),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      _color7 = Colors.red;
                                    } else {
                                      // setState(() {
                                      //_color3 = Colors.green.shade600;
                                      //});
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (value) {
                                    if (value.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Please Add Your Product Description');
                                      _color7 = Colors.red;
                                      setState(() {});
                                    } else if (value.isNotEmpty) {
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin:
                                      EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            child: _imagefiles != null
                                                ? Image.file(file!,
                                                    height: 100, width: 100)
                                                : Image.asset(
                                                    'assets/addphoto1.png',
                                                    height: 100,
                                                    width: 100),
                                            onTap: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) =>
                                                      bottomsheet());
                                            },
                                          ),
                                          Visibility(
                                            visible: _imagefiles == null
                                                ? false
                                                : true,
                                            child: Positioned(
                                                bottom: -5,
                                                left: 25,
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  margin: EdgeInsets.all(2.0),
                                                  child: Card(
                                                      //margin: EdgeInsets.all(5),
                                                      shape: CircleBorder(),
                                                      child: GestureDetector(
                                                        child: Icon(
                                                            Icons.delete,
                                                            color: Colors.red),
                                                        onTap: () {
                                                          setState(() {
                                                            _imagefiles = null;
                                                            constanst.imagesList
                                                                .remove(
                                                                    _imagefiles);
                                                          });
                                                        },
                                                      )),
                                                )),
                                          )
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            child: _imagefiles1 != null
                                                ? Image.file(file1!,
                                                    height: 100, width: 100)
                                                : Image.asset(
                                                    'assets/addphoto1.png',
                                                    height: 100,
                                                    width: 100),
                                            onTap: () {
                                              //takephoto1(ImageSource.gallery);
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) =>
                                                      bottomsheet1());
                                            },
                                          ),
                                          Visibility(
                                            visible: _imagefiles1 == null
                                                ? false
                                                : true,
                                            child: Positioned(
                                                bottom: -5,
                                                left: 25,
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  margin: EdgeInsets.all(2.0),
                                                  child: Card(
                                                      //margin: EdgeInsets.all(5),
                                                      shape: CircleBorder(),
                                                      child: GestureDetector(
                                                        child: Icon(
                                                            Icons.delete,
                                                            color: Colors.red),
                                                        onTap: () {
                                                          setState(() {
                                                            _imagefiles1 = null;
                                                            constanst.imagesList
                                                                .remove(
                                                                    _imagefiles1);
                                                          });
                                                        },
                                                      )),
                                                )),
                                          )
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          GestureDetector(
                                            child: _imagefiles2 != null
                                                ? Image.file(file2!,
                                                    height: 100, width: 100)
                                                : Image.asset(
                                                    'assets/addphoto1.png',
                                                    height: 100,
                                                    width: 100,
                                                  ),
                                            onTap: () {
                                              // takephoto2(ImageSource.gallery);
                                              // print('heeeeeee');
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) =>
                                                      bottomsheet2());
                                            },
                                          ),
                                          Visibility(
                                              visible: _imagefiles2 == null
                                                  ? false
                                                  : true,
                                              child: Positioned(
                                                bottom: -10,
                                                left: 30,
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  //margin: EdgeInsets.all(2.0),
                                                  child: Card(
                                                      //margin: EdgeInsets.all(5),
                                                      shape:
                                                          const CircleBorder(),
                                                      child: GestureDetector(
                                                        child: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red),
                                                        onTap: () {
                                                          setState(() {
                                                            _imagefiles2 = null;
                                                            constanst.imagesList
                                                                .remove(
                                                                    _imagefiles2);
                                                          });
                                                        },
                                                      )),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  vaild_data();
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Color.fromARGB(255, 0, 91, 148)),
                                  child: TextButton(
                                    onPressed: () {
                                      place ??= Prediction(
                                          description: _loc.text, placeId: "0");

                                      List<String> list = place.description
                                          .toString()
                                          .split(",");

                                      list.length == 1
                                          ? country = list[0].toString()
                                          : country = '';
                                      list.length == 2
                                          ? state = list[0].toString()
                                          : state = '';
                                      list.length == 2
                                          ? country = list[1].toString()
                                          : country = '';

                                      if (list.length == 3) {
                                        country = list.last.toString();
                                        city = list[0].toString();
                                        state = list[1].toString();
                                      }
                                      if (list.length == 4) {
                                        country = list.last.toString();
                                        city = list.first.toString();
                                        state = list[2].toString();
                                      }
                                      if (list.length == 5) {
                                        country = list.last.toString();
                                        city = list.first.toString();
                                        state = list[3].toString();
                                      }

// final plist = GoogleMapsPlaces(
//   apiKey: googleApikey,
//   apiHeaders: await GoogleApiHeaders()
//       .getHeaders(),
//
// );
// String placeid = place.placeId ?? "0";
// final detail = await plist
//     .getDetailsByPlaceId(placeid);
//
// final geometry = detail.result.geometry!;
// lat = geometry.location.lat;
//
// log = geometry.location.lng;

                                      if (_formKey.currentState!.validate()) {
                                        /*  Fluttertoast.showToast(
                                              msg: "Data Proccess");*/
                                      }
                                      setState(() {
                                        vaild_data();
                                      });
                                    },
                                    child: const Text('Publish',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 19,
                                            color: Colors.white)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getProfiless() async {
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getbussinessprofile(
      _pref.getString('user_id').toString(),
      _pref.getString('api_token').toString(),
    );

    if (res['status'] == 1) {
      address = res['profile']['address'];
      _loc.text = address!;
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {});
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

    /*Future.delayed(const Duration(seconds: 5), () {
      print('exit');
      Navigator.of(dialogContext!).pop(); // Use dialogContext to close the dialog
      print('exit1'); // Dialog closed
    });*/
  }

  Future<bool> add_BuyPost() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    constanst.step = 11;
    int imageCounter = constanst.imagesList.length;
    var res = await addBuyPost(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        constanst.select_type_id,
        constanst.select_gradeId.join(","),
        _selectitem4.toString(),
        _prodprice.text.toString(),
        _prodqty.text.toString(),
        constanst.select_color_id,
        _proddetail.text.toString(),
        _selectitem5.toString(),
        _selectitem6.toString(),
        _loc.text.toString(),
        lat.toString(),
        log.toString(),
        imageCounter.toString(),
        city,
        state,
        country,
        constanst.step.toString(),
        _prodnm.text.toString(),
        constanst.select_cat_id);

    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);
      clear_data();
      _isloading1 = true;
      print('123456 $_isloading1');
    } else {
      _isloading1 = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    return _isloading1;
  }

  clear_data() {
    _selectitem4 = null;
    _selectitem5 = null;
    _selectitem6 = null;
    constanst.unitdata.clear();
    constanst.colorsitemsCheck.clear();
    constanst.category_itemsCheck.clear();
    constanst.itemsCheck.clear();
    constanst.category_itemsCheck1.clear();
    constanst.Type_itemsCheck.clear();
    constanst.Type_itemsCheck1.clear();
    constanst.Grade_itemsCheck.clear();
    constanst.Grade_itemsCheck1.clear();
    constanst.imagesList.clear();
    constanst.select_color_id = "";
    constanst.select_color_name = "";
    constanst.select_cat_id = "";
    constanst.select_cat_name = "";
    constanst.select_cat_idx;
    constanst.select_type_id = "";
    constanst.select_type_idx;
    constanst.select_type_name = "";
    constanst.select_grade_id = "";
    constanst.select_grade_name.clear();
    constanst.select_grade_idx;
    constanst.Product_color = "";
    constanst.select_prodcolor_idx = 0;
    constanst.unit_data = null;
    constanst.color_data = null;
    constanst.cat_typedata = null;
    constanst.cat_gradedata = null;
    constanst.cat_data = null;
  }

  Future<bool> add_SalePost() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    constanst.step = 11;
    print(_selectitem5);
    int imageCounter = constanst.imagesList.length;

    var res = await addSalePost(
      _pref.getString('user_id').toString(),
      _pref.getString('api_token').toString(),
      constanst.select_type_id,
      constanst.select_gradeId.join(","),
      _selectitem4.toString(),
      _prodprice.text.toString(),
      _prodqty.text.toString(),
      constanst.select_color_id,
      _proddetail.text.toString(),
      _selectitem5.toString(),
      _selectitem6.toString(),
      _loc.text.toString(),
      lat.toString(),
      log.toString(),
      imageCounter.toString(),
      city,
      state,
      country,
      constanst.step.toString(),
      _prodnm.text.toString(),
      constanst.select_cat_id,
    );

    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);
      clear_data();
      _isloading1 = true;
      // Navigator.of(context).pop();
      print('123456 $_isloading1');
    } else {
      _isloading1 = true;

      Fluttertoast.showToast(msg: res['message']);
    }
    return _isloading1;
  }

  Widget bottomsheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile Photo",
            style: TextStyle(fontSize: 18.0),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    takephoto(ImageSource.camera, FilterQuality.none);
                  },
                  icon: const Icon(Icons.camera,
                      color: Color.fromARGB(255, 0, 91, 148)),
                  label: const Text(
                    'Camera',
                    style: TextStyle(color: Color.fromARGB(255, 0, 91, 148)),
                  )),
              TextButton.icon(
                  onPressed: () {
                    takephoto(ImageSource.gallery, FilterQuality.none);
                  },
                  icon: const Icon(Icons.image,
                      color: Color.fromARGB(255, 0, 91, 148)),
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

  void takephoto(ImageSource imageSource, FilterQuality quality) async {
    final pickedfile =
        await _picker.getImage(source: imageSource, imageQuality: 50);
    setState(() async {
      _imagefiles = pickedfile!;
      file = await _cropImage(imagefile: io.File(_imagefiles!.path));
      constanst.imagesList.add(file!);
      Navigator.of(context).pop();
    });
  }

  Future<io.File?> _cropImage({required io.File imagefile}) async {
    if (imagefile != null) {
      final croppedFile = await ImageCropper().cropImage(
          sourcePath: imagefile.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: const Color.fromARGB(255, 0, 91, 148),
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
          ]);
      if (croppedFile != null) {
        setState(() {});
        return io.File(croppedFile.path);
      }
    } else {
      return null;
    }
  }

  List<String> _getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(_suggestions);

    matches.retainWhere(
        (suggestion) => suggestion.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  Widget bottomsheet1() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
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
                    takephoto1(ImageSource.camera, FilterQuality.none);
                  },
                  icon: const Icon(Icons.camera,
                      color: Color.fromARGB(255, 0, 91, 148)),
                  label: const Text(
                    'Camera',
                    style: TextStyle(color: Color.fromARGB(255, 0, 91, 148)),
                  )),
              TextButton.icon(
                  onPressed: () {
                    takephoto1(ImageSource.gallery, FilterQuality.none);
                  },
                  icon: const Icon(Icons.image,
                      color: Color.fromARGB(255, 0, 91, 148)),
                  label: const Text(
                    'Gallary',
                    style: TextStyle(color: Color.fromARGB(255, 0, 91, 148)),
                  )),
            ],
          )
        ],
      ),
    );
  }

  void takephoto1(ImageSource imageSource, FilterQuality quality) async {
    final pickedfile =
        await _picker.getImage(source: imageSource, imageQuality: 50);
    setState(() async {
      _imagefiles1 = pickedfile!;
      //file = io.File(_imagefiles!.path);
      file1 = await _cropImage1(imagefile: io.File(_imagefiles1!.path));
      constanst.imagesList.add(file1!);
      Navigator.of(context).pop();
    });
  }

  Future<io.File?> _cropImage1({required io.File imagefile}) async {
    if (imagefile != null) {
      final croppedFile = await ImageCropper().cropImage(
          sourcePath: imagefile.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: const Color.fromARGB(255, 0, 91, 148),
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
          ]);
      if (croppedFile != null) {
        setState(() {});
        return io.File(croppedFile.path);
      }
    } else {
      return null;
    }
  }

  Widget bottomsheet2() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile Photo",
            style: TextStyle(fontSize: 18.0),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    takephoto2(ImageSource.camera, FilterQuality.none);
                  },
                  icon: const Icon(Icons.camera,
                      color: Color.fromARGB(255, 0, 91, 148)),
                  label: const Text(
                    'Camera',
                    style: TextStyle(color: Color.fromARGB(255, 0, 91, 148)),
                  )),
              TextButton.icon(
                  onPressed: () {
                    takephoto2(ImageSource.gallery, FilterQuality.none);
                  },
                  icon: const Icon(Icons.image,
                      color: Color.fromARGB(255, 0, 91, 148)),
                  label: const Text(
                    'Gallary',
                    style: TextStyle(color: Color.fromARGB(255, 0, 91, 148)),
                  )),
            ],
          )
        ],
      ),
    );
  }

  void takephoto2(ImageSource imageSource, FilterQuality quality) async {
    final pickedfile =
        await _picker.getImage(source: imageSource, imageQuality: 50);
    setState(() async {
      _imagefiles2 = pickedfile!;
      //file = io.File(_imagefiles!.path);
      file2 = await _cropImage2(imagefile: io.File(_imagefiles2!.path));
      constanst.imagesList.add(file2!);
      Navigator.of(context).pop();

      // print('image path : ');
      // print(_imagefiles!.path);
    });
  }

  Future<io.File?> _cropImage2({required io.File imagefile}) async {
    if (imagefile != null) {
      final croppedFile = await ImageCropper().cropImage(
          sourcePath: imagefile.path,
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
        setState(() {});
        return io.File(croppedFile.path);
      }
    } else {
      return null;
    }
  }

  Widget Unit_dropdown(List listitem, String hint) {
    return Container(
      width: MediaQuery.of(context).size.width / 4.1,
      height: 55,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 18.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: DropdownButton(
            value: _selectitem5,
            hint: Text(hint,
                style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontFamily: 'assets\fonst\Metropolis-Black.otf')),
            dropdownColor: Colors.white,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 40,
            isExpanded: true,
            underline: SizedBox(),
            items: listitem.map((valueItem) {
              return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem,
                      style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: 'assets\fonst\Metropolis-Black.otf')));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectitem5 = value.toString();
              });
            },
          )),
    );
  }

  Widget Unit_dropdown1(List listitem, String hint) {
    return Container(
      width: MediaQuery.of(context).size.width / 4.2,
      height: 55,
      color: Colors.white,
      padding: EdgeInsets.only(left: 15.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: DropdownButton(
            value: _selectitem6,
            hint: Text(hint,
                style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontFamily: 'assets\fonst\Metropolis-Black.otf')),
            dropdownColor: Colors.white,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 40,
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
                          fontFamily: 'assets\fonst\Metropolis-Black.otf')));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectitem6 = value.toString();
              });
            },
          )),
    );
  }

  Widget rupess_dropdown(List listitem, String hint) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.88,
      //height: 60,
      //margin: EdgeInsets.only(right: 5,),
      padding: EdgeInsets.only(left: 5.0, top: 5, bottom: 5),
      color: Colors.white,
      child: Align(
          alignment: Alignment.centerLeft,
          child: DropdownButton(
            value: _selectitem4,
            hint: Text(hint,
                style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontFamily: 'assets\fonst\Metropolis-Black.otf')),
            dropdownColor: Colors.white,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 40,
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
                          fontFamily: 'assets\fonst\Metropolis-Black.otf')));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectitem4 = value.toString();
              });
            },
          )),
    );
  }

  vaild_data() async {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

    if (_prodprice.text.isEmpty ||
        _selectitem5 == null ||
        _selectitem4 == null) {
      _color8 = Colors.red;
      setState(() {});
    }
    if (_selectitem6 == null || _prodqty.text.isEmpty) {
      _color10 = Colors.red;
      setState(() {});
    }

    if (_prodnm.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please Add Your Product Name');
      _color1 = Colors.red;
      setState(() {});
    } else if (category1 == false) {
      //_color1 = Colors.red;
      Fluttertoast.showToast(msg: 'Please Select Sale Post or Buy Post');
    } else if (_prodnm.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please Add Your Product Name');
      _color1 = Colors.red;
      setState(() {});
    } else if (constanst.select_cat_name.isEmpty) {
      Fluttertoast.showToast(msg: 'Please Select Category');
      _color2 = Colors.red;
      setState(() {});
    } else if (constanst.select_type_name.isEmpty) {
      Fluttertoast.showToast(msg: 'Please Select Type');
      _color3 = Colors.red;
      setState(() {});
    } else if (constanst.select_grade_name.isEmpty) {
      Fluttertoast.showToast(msg: 'Please Select Grade');
      _color4 = Colors.red;
      setState(() {});
    } else if (_prodprice.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please Add Your Product Price ');
      _color8 = Colors.red;
      setState(() {});
    } else if (_selectitem5 == null) {
      Fluttertoast.showToast(msg: 'Select Product Unit');
      _color8 = Colors.red;
      setState(() {});
    } else if (_selectitem4 == null) {
      Fluttertoast.showToast(msg: 'Please Select Currency Sign ');
      _color8 = Colors.red;
      setState(() {});
    } else if (_prodqty.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please Add Your Product Quantity");
      _color10 = Colors.red;
      setState(() {});
    } else if (_selectitem6 == null) {
      Fluttertoast.showToast(msg: 'Select Product Unit');
      _color10 = Colors.red;
    } else if (constanst.select_color_name.isEmpty) {
      Fluttertoast.showToast(msg: 'Please Select Product Colour');
      _color5 = Colors.red;
    } else if (_loc.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please Add Stock Location");
      _color6 = Colors.red;
      setState(() {});
    } else if (_proddetail.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please Add Your Product Description");
      _color7 = Colors.red;
      setState(() {});
    } else if (constanst.imagesList.isEmpty) {
      Fluttertoast.showToast(msg: 'Please Add Your Product Image');
    }

    if (_prodprice.text.isNotEmpty &&
        _selectitem5 != null &&
        _selectitem4 != null) {
      _color8 = Colors.green.shade600;
      setState(() {});
    }
    if (_selectitem6 != null && _prodqty.text.isNotEmpty) {
      _color10 = Colors.green.shade600;
      setState(() {});
    }
    if (_prodnm.text.isNotEmpty) {
      _color1 = Colors.green.shade600;
      setState(() {});
    }
    if (constanst.select_cat_name.isNotEmpty) {
      _color2 = Colors.green.shade600;
      setState(() {});
    }
    if (constanst.select_type_name.isNotEmpty) {
      _color3 = Colors.green.shade600;
      setState(() {});
    }
    if (constanst.select_grade_name.isNotEmpty) {
      _color4 = Colors.green.shade600;
      setState(() {});
    }
    if (constanst.select_color_name.isNotEmpty) {
      _color5 = Colors.green.shade600;
      setState(() {});
    }
    if (_loc.text.isNotEmpty) {
      _color6 = Colors.green.shade600;
      setState(() {});
    }
    if (_proddetail.text.isNotEmpty) {
      _color7 = Colors.green.shade600;
      setState(() {});
    }

    if (type_post == 'Sell Post') {
      if (_selectitem6 != null &&
          _prodqty.text.isNotEmpty &&
          category1 &&
          _prodnm.text.isNotEmpty &&
          constanst.select_cat_name.isNotEmpty &&
          constanst.select_type_name.isNotEmpty &&
          constanst.select_grade_name.isNotEmpty &&
          _prodprice.text.isNotEmpty &&
          _selectitem5 != null &&
          _selectitem4 != null &&
          _prodqty.text.isNotEmpty &&
          _selectitem6 != null &&
          _loc.text.isNotEmpty &&
          _proddetail.text.isNotEmpty &&
          constanst.imagesList.isNotEmpty) {
        _onLoading();
        setState(() {
          _isloading1 =
              false; // Hide the loader when the async operation completes
        });
        add_SalePost().then((value) {
          if (value) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainScreen(0)));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainScreen(0)));
          }
          // Navigator.of(dialogContext!).pop(); // loader
        });
      }
    } else if (type_post == 'Buy Post') {
      if (_selectitem6 != null &&
          _prodqty.text.isNotEmpty &&
          category1 &&
          _prodnm.text.isNotEmpty &&
          constanst.select_cat_name.isNotEmpty &&
          constanst.select_type_name.isNotEmpty &&
          constanst.select_grade_name.isNotEmpty &&
          _prodprice.text.isNotEmpty &&
          _selectitem5 != null &&
          _selectitem4 != null &&
          _prodqty.text.isNotEmpty &&
          _selectitem6 != null &&
          _loc.text.isNotEmpty &&
          _proddetail.text.isNotEmpty &&
          constanst.imagesList.isNotEmpty) {
        _onLoading();
        add_BuyPost().then((value) {
          if (value) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainScreen(0)));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainScreen(0)));
          }
          // Navigator.of(dialogContext!).pop(); // loader
        });
      }
    }
  }

  ViewItem(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          // <-- SEE HERE
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        )),
        builder: (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize:
                0.80, // Initial height as a fraction of screen height
            builder: (BuildContext context, ScrollController scrollController) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return selectcolor();
                },
              );
            })).then(
      (value) {
        String color = constanst.select_color_name.toString();
        var arr = color.split(',');
        print(arr);
        var stringList = arr.join(",");
        _prodcolor.text = stringList.toString();
      },
    );
  }

  Viewproduct(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
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
                  return selectcategory();
                },
              );
            })).then(
      (value) {
        _prod_cate.text = constanst.select_cat_name;
      },
    );
  }

  Viewtype(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
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
                  return selectType();
                },
              );
            })).then(
      (value) {
        _prod_type.text = constanst.select_type_name;
      },
    );
  }

  Viewgrade(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
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
                  return const selectGrade();
                },
              );
            })).then(
      (value) {
        print(constanst.select_grade_name);

        _prod_grade.text = constanst.select_grade_name.join(',');
      },
    );
  }

  void get_data1() async {
    GetCategoryTypeController bType = await GetCategoryTypeController();
    constanst.cat_typedata = bType.setType();
    _isloading = true;
    constanst.cat_typedata!.then((value) {
      for (var item in value) {
        constanst.cat_type_data.add(item);
      }
      for (int i = 0; i < constanst.cat_type_data.length; i++) {
        constanst.Type_itemsCheck.add(Icons.circle_outlined);
      }
      _isloading = true;
      setState(() {});
    });
    //
  }

  void get_data2() async {
    GetCategoryGradeController bt = await GetCategoryGradeController();
    constanst.cat_gradedata = bt.setGrade();
    _isloading = true;
    constanst.cat_gradedata!.then((value) {
      for (var item in value) {
        constanst.cat_grade_data.add(item);
      }
      for (int i = 0; i < constanst.cat_grade_data.length; i++) {
        constanst.Grade_itemsCheck.add(Icons.circle_outlined);
      }
      _isloading = true;
      setState(() {});
    });
  }

  void get_data4() async {
    GetUnitController bType = await GetUnitController();
    constanst.unit_data = bType.setunit();
    _isloading = true;
    constanst.unit_data!.then((value) {
      for (var item in value) {
        constanst.unitdata.add(item);
      }
      _isloading = true;
      setState(() {});
    });
  }

  checknetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      constanst.category_itemsCheck.clear();
      constanst.Type_itemsCheck.clear();
      constanst.Grade_itemsCheck.clear();
      constanst.catdata.clear();
      constanst.colordata.clear();
      constanst.cat_grade_data.clear();
      constanst.cat_type_data.clear();
      _isloading = false;
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      constanst.select_cat_idx = -1;
      constanst.select_type_idx = -1;
      constanst.select_grade_idx = -1;
      constanst.category_itemsCheck.clear();
      constanst.Type_itemsCheck.clear();
      constanst.Grade_itemsCheck.clear();
      constanst.catdata.clear();
      constanst.colordata.clear();
      constanst.cat_grade_data.clear();
      constanst.cat_type_data.clear();
      constanst.select_gradeId.clear();
      constanst.unitdata.clear();
      constanst.colordata.clear();
      get_product_name();
      get_data();
      get_data1();
      get_data2();
      get_data3();
      get_data4();
      getProfiless();
    }
  }

  Future get_product_name() async {
    GetProductName getdir = GetProductName();

    var res = await get_productname();

    print(res);
    getdir = GetProductName.fromJson(res);
    List<pnm.Result>? results = getdir.result;
    if (results != null) {
      _suggestions = results.map((result) => result.productName ?? "").toList();
      print('rsrsrser $_suggestions');
      return _suggestions;
    } else {
      return [];
    }
  }

  void get_data() async {
    GetCategoryController bt = await GetCategoryController();
    constanst.cat_data = bt.setlogin();
    _isloading = true;
    constanst.cat_data!.then((value) {
      for (var item in value) {
        constanst.catdata.add(item);
      }
      for (int i = 0; i < constanst.catdata.length; i++) {
        constanst.category_itemsCheck.add(Icons.circle_outlined);
      }
      _isloading = true;
      setState(() {});
    });
    //
  }

  void get_data3() async {
    GetColorsController bt = await GetColorsController();
    constanst.color_data = bt.setlogin();
    _isloading = true;
    constanst.color_data!.then((value) {
      for (var item in value) {
        constanst.colordata.add(item);
      }
      _isloading = true;
      setState(() {});
    });
    //
  }
}

class selectcolor extends StatefulWidget {
  const selectcolor({Key? key}) : super(key: key);

  @override
  State<selectcolor> createState() => _selectcolorState();
}

class _selectcolorState extends State<selectcolor> {
  String? assignedName;
  bool gender = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 5),
            Image.asset(
              'assets/hori_line.png',
              width: 150,
              height: 5,
            ),
            SizedBox(height: 5),
            Center(
              child: Text('Select Color of Product',
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'assets\fonst\Metropolis-Black.otf')),
            ),
            SizedBox(height: 5),
            //-------CircularCheckBox()

            FutureBuilder(

                //future: load_subcategory(),

                builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  snapshot.hasData == null) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                for (int i = 0; i <= constanst.colordata.length; i++) {
                  constanst.colorsitemsCheck.add(Icons.circle_outlined);
                }

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: constanst.colordata.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      color.Result record = constanst.colordata[index];

                      if (constanst.colordata.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              constanst.select_prodcolor_idx = index;
                              gender = true;
                              constanst.select_prodcolor_idx = index;
                              if (constanst.colorsitemsCheck[index] ==
                                  Icons.circle_outlined) {
                                constanst.colorsitemsCheck[index] =
                                    Icons.check_circle_outline;

                                constanst.color_name_list
                                    .add(record.colorName.toString());
                                constanst.select_color_name =
                                    constanst.color_name_list.join(",");
                                print(constanst.select_color_name);

                                constanst.color_id_list
                                    .add(record.colorId.toString());
                                constanst.select_color_id =
                                    constanst.color_id_list.join(",");
                                print(constanst.select_color_id);
                              } else {
                                constanst.colorsitemsCheck[index] =
                                    Icons.circle_outlined;
                                constanst.color_name_list
                                    .remove(record.colorName.toString());
                                constanst.select_color_name =
                                    constanst.color_name_list.join(",");

                                constanst.color_id_list
                                    .remove(record.colorId.toString());
                                constanst.select_color_id =
                                    constanst.color_id_list.join(",");
                              }
                            });
                          },
                          child: ListTile(
                              title: Text(record.colorName.toString(),
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontFamily:
                                          'assets\fonst\Metropolis-Black.otf')),
                              leading: IconButton(
                                  icon: constanst.colorsitemsCheck[index] ==
                                          Icons.circle_outlined
                                      ? Icon(Icons.circle_outlined,
                                          color: Colors.black45)
                                      : Icon(Icons.check_circle,
                                          color: Colors.green.shade600),
                                  onPressed: () {
                                    setState(() {
                                      constanst.select_prodcolor_idx = index;
                                      gender = true;
                                      constanst.select_prodcolor_idx = index;
                                      if (constanst.colorsitemsCheck[index] ==
                                          Icons.circle_outlined) {
                                        constanst.colorsitemsCheck[index] =
                                            Icons.check_circle_outline;

                                        constanst.color_name_list
                                            .add(record.colorName.toString());
                                        constanst.select_color_name =
                                            constanst.color_name_list.join(",");
                                        print(constanst.select_color_name);

                                        constanst.color_id_list
                                            .add(record.colorId.toString());
                                        constanst.select_color_id =
                                            constanst.color_id_list.join(",");
                                        print(constanst.select_color_id);
                                      } else {
                                        constanst.colorsitemsCheck[index] =
                                            Icons.circle_outlined;
                                        constanst.color_name_list.remove(
                                            record.colorName.toString());
                                        constanst.select_color_name =
                                            constanst.color_name_list.join(",");

                                        constanst.color_id_list
                                            .remove(record.colorId.toString());
                                        constanst.select_color_id =
                                            constanst.color_id_list.join(",");
                                      }
                                    });
                                  })),
                        );
                      }
                    });
              }
            }),

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
                  if (constanst.select_color_name.isNotEmpty) {
                    Navigator.pop(context, constanst.Product_color);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => CategoryScreen()));
                  } else {
                    Fluttertoast.showToast(msg: 'Select Minimum 1 Color ');
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
        ),
      ),
    );
  }
}

class selectcategory extends StatefulWidget {
  const selectcategory({Key? key}) : super(key: key);

  @override
  State<selectcategory> createState() => _selectcategoryState();
}

class _selectcategoryState extends State<selectcategory> {
  String? assignedName;
  bool gender = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 5),
            Image.asset(
              'assets/hori_line.png',
              width: 150,
              height: 5,
            ),
            SizedBox(height: 5),
            Center(
              child: Text('Select Product Category',
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'assets\fonst\Metropolis-Black.otf')),
            ),
            SizedBox(height: 5),
            //-------CircularCheckBox()

            FutureBuilder(

                //future: load_subcategory(),
                builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  snapshot.hasData == null) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: constanst.catdata.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      cat.Result record = constanst.catdata[index];

                      if (constanst.catdata.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              gender = true;
                              //constanst.category_itemsCheck.clear();
                              constanst.select_cat_idx = index;

                              if (constanst.select_cat_idx == index) {
                                constanst.category_itemsCheck[index] =
                                    Icons.check_circle_outline;

                                //constanst.select_categotyId.add(record.categoryId.toString());
                                constanst.select_cat_id =
                                    record.categoryId.toString();
                                constanst.select_cat_name =
                                    record.categoryName.toString();
                              } else {
                                constanst.category_itemsCheck[index] =
                                    Icons.circle_outlined;
                              }
                            });
                          },
                          child: ListTile(
                              title: Text(record.categoryName.toString(),
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontFamily:
                                          'assets\fonst\Metropolis-Black.otf')),
                              leading: IconButton(
                                  icon: constanst.select_cat_idx == index
                                      ? Icon(Icons.check_circle,
                                          color: Colors.green.shade600)
                                      : Icon(Icons.circle_outlined,
                                          color: Colors.black45),
                                  onPressed: () {
                                    setState(() {
                                      gender = true;
                                      //constanst.category_itemsCheck.clear();
                                      constanst.select_cat_idx = index;

                                      if (constanst.select_cat_idx == index) {
                                        constanst.category_itemsCheck[index] =
                                            Icons.check_circle_outline;

                                        //constanst.select_categotyId.add(record.categoryId.toString());
                                        constanst.select_cat_id =
                                            record.categoryId.toString();
                                        constanst.select_cat_name =
                                            record.categoryName.toString();
                                      } else {
                                        constanst.category_itemsCheck[index] =
                                            Icons.circle_outlined;
                                      }
                                    });
                                  })),
                        );
                      }
                    });
              }
            }),

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
                  if (constanst.select_cat_name != "") {
                    Navigator.pop(context, constanst.Product_color);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => CategoryScreen()));
                  } else {
                    Fluttertoast.showToast(msg: 'Select Minimum 1 Category ');
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
        ),
      ),
    );
  }
}

class selectType extends StatefulWidget {
  const selectType({Key? key}) : super(key: key);

  @override
  State<selectType> createState() => _selectTypeState();
}

class _selectTypeState extends State<selectType> {
  String? assignedName;

  bool gender = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 5),
            Image.asset(
              'assets/hori_line.png',
              width: 150,
              height: 5,
            ),
            SizedBox(height: 5),
            Center(
              child: Text('Select Product Type',
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'assets\fonst\Metropolis-Black.otf')),
            ),
            SizedBox(height: 5),
            //-------CircularCheckBox()

            FutureBuilder(

                //future: load_subcategory(),
                builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  snapshot.hasData == null) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: constanst.cat_type_data.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      type.Result record = constanst.cat_type_data[index];

                      if (constanst.cat_type_data.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              constanst.select_type_idx = index;
                              gender = true;
                              print(constanst.select_type_idx);
                              print(constanst.Type_itemsCheck.length);
                              if (constanst.select_type_idx == index) {
                                constanst.Type_itemsCheck[index] =
                                    Icons.check_circle_outline;

                                constanst.select_type_id =
                                    record.producttypeId.toString();
                                constanst.select_type_name =
                                    record.productType.toString();

                                setState(() {});
                              } else {
                                constanst.category_itemsCheck[index] =
                                    Icons.circle_outlined;
                              }
                            });
                          },
                          child: ListTile(
                              title: Text(record.productType.toString(),
                                  style: const TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontFamily:
                                          'assets\fonst\Metropolis-Black.otf')),
                              leading: IconButton(
                                  icon: constanst.select_type_idx == index
                                      ? Icon(Icons.check_circle,
                                          color: Colors.green.shade600)
                                      : const Icon(Icons.circle_outlined,
                                          color: Colors.black45),
                                  onPressed: () {
                                    setState(() {
                                      constanst.select_type_idx = index;
                                      gender = true;
                                      print(constanst.select_type_idx);
                                      print(constanst.Type_itemsCheck.length);
                                      if (constanst.select_type_idx == index) {
                                        constanst.Type_itemsCheck[index] =
                                            Icons.check_circle_outline;

                                        constanst.select_type_id =
                                            record.producttypeId.toString();
                                        constanst.select_type_name =
                                            record.productType.toString();

                                        setState(() {});
                                      } else {
                                        constanst.category_itemsCheck[index] =
                                            Icons.circle_outlined;
                                      }
                                    });
                                  })),
                        );
                      }
                    });
              }
            }),

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
                    Navigator.pop(context, constanst.Product_color);
                  } else {
                    Fluttertoast.showToast(msg: 'Select Minimum 1 Type ');
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
        ),
      ),
    );
  }
}

class selectGrade extends StatefulWidget {
  const selectGrade({Key? key}) : super(key: key);

  @override
  State<selectGrade> createState() => _selectGradeState();
}

class _selectGradeState extends State<selectGrade> {
  String? assignedName;
  bool gender = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 5),
          Image.asset(
            'assets/hori_line.png',
            width: 150,
            height: 5,
          ),
          const SizedBox(height: 5),
          const Center(
            child: Text('Select Product Grade',
                style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'assets\fonst\Metropolis-Black.otf')),
          ),
          const SizedBox(height: 5),
          //-------CircularCheckBox()

          FutureBuilder(
              //future: load_subcategory(),
              builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                snapshot.hasData == null) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: constanst.cat_grade_data.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  grade.Result record = constanst.cat_grade_data[index];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (constanst.select_gradeId.length < 3) {
                          constanst.select_grade_idx = index;
                          gender = true;

                          if (constanst.Grade_itemsCheck[index] ==
                              Icons.circle_outlined) {
                            constanst.Grade_itemsCheck[index] =
                                Icons.check_circle_outline;

                            constanst.select_grade_id =
                                record.productgradeId.toString();
                            constanst.select_gradeId
                                .add(constanst.select_grade_id);
                            constanst.select_grade_name
                                .add(record.productGrade.toString());
                          } else {
                            constanst.Grade_itemsCheck[index] =
                                Icons.circle_outlined;
                            constanst.select_grade_id =
                                record.productgradeId.toString();
                            constanst.select_gradeId
                                .remove(constanst.select_grade_id);
                            constanst.select_grade_name
                                .remove(record.productGrade.toString());
                          }
                        } else {
                          if (constanst.Grade_itemsCheck[index] ==
                              Icons.check_circle_outline) {
                            constanst.Grade_itemsCheck[index] =
                                Icons.circle_outlined;
                            constanst.select_grade_id =
                                record.productgradeId.toString();
                            constanst.select_gradeId
                                .remove(constanst.select_grade_id);
                            constanst.select_grade_name
                                .remove(record.productGrade.toString());
                          } else {
                            Fluttertoast.showToast(
                                msg: 'You Can Select Maximum 3 Grade');
                          }
                        }
                      });
                    },
                    child: ListTile(
                      title: Text(record.productGrade.toString(),
                          style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                      leading: IconButton(
                        icon: constanst.Grade_itemsCheck[index] !=
                                Icons.circle_outlined
                            ? Icon(Icons.check_circle,
                                color: Colors.green.shade600)
                            : const Icon(Icons.circle_outlined,
                                color: Colors.black45),
                        onPressed: () {
                          setState(() {
                            if (constanst.select_gradeId.length < 3) {
                              constanst.select_grade_idx = index;
                              gender = true;

                              if (constanst.Grade_itemsCheck[index] ==
                                  Icons.circle_outlined) {
                                constanst.Grade_itemsCheck[index] =
                                    Icons.check_circle_outline;

                                constanst.select_grade_id =
                                    record.productgradeId.toString();
                                constanst.select_gradeId
                                    .add(constanst.select_grade_id);
                                constanst.select_grade_name
                                    .add(record.productGrade.toString());
                              } else {
                                constanst.Grade_itemsCheck[index] =
                                    Icons.circle_outlined;
                                constanst.select_grade_id =
                                    record.productgradeId.toString();
                                constanst.select_gradeId
                                    .remove(constanst.select_grade_id);
                                constanst.select_grade_name
                                    .remove(record.productGrade.toString());
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'You Can Select Maximum 3 Grade');
                            }
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            }
          }),

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
                if (constanst.select_gradeId.isEmpty) {
                  Fluttertoast.showToast(msg: 'Select Minimum 1 Grade ');
                } else {
                  Navigator.pop(context, constanst.Product_color);
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
      ),
    );
  }
}
