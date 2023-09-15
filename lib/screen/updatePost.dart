import 'dart:async';
import 'dart:io';
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
import 'package:Plastic4trade/model/CommonPostdetail.dart' as postdetail;
import 'package:Plastic4trade/model/GetCategory.dart' as cat;
import 'package:Plastic4trade/model/GetCategoryType.dart' as type;
import 'package:Plastic4trade/model/GetCategoryGrade.dart' as grade;
import 'package:Plastic4trade/model/GetColors.dart' as color;
import 'package:Plastic4trade/widget/MainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Plastic4trade/model/GetProductName.dart' as pnm;
import '../api/api_interface.dart';
import '../constroller/GetCategoryController.dart';
import '../constroller/GetCategoryGradeController.dart';
import '../constroller/GetCategoryTypeController.dart';
import '../model/CommonPostdetail.dart';
import '../model/GetProductName.dart';
import '../model/common.dart';

class UpdatePOst extends StatefulWidget {
  String? post_type;
  String? prod_id;
  UpdatePOst(this.post_type, this.prod_id, {Key? key}) : super(key: key);

  @override
  State<UpdatePOst> createState() => _UpdatePOstState();
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(this.isSelected, this.buttonText);
}

class _UpdatePOstState extends State<UpdatePOst> {
  List<RadioModel> sampleData1 = <RadioModel>[];
  TextEditingController _prodnm = TextEditingController();
  TextEditingController _prod_cate = TextEditingController();
  TextEditingController _prod_type = TextEditingController();
  TextEditingController _prod_grade = TextEditingController();
  TextEditingController _prodprice = TextEditingController();
  TextEditingController _prodcolor = TextEditingController();
  TextEditingController _prodqty = TextEditingController();
  TextEditingController _loc = TextEditingController();
  TextEditingController _proddetail = TextEditingController();
  List<String> _suggestions = [];
  Color _color1 = Colors.black26;
  Color _color2 = Colors.black26;
  Color _color3 = Colors.black26;
  Color _color4 = Colors.black26;
  Color _color5 = Colors.black26;
  Color _color6 = Colors.black26;
  Color _color7 = Colors.black26;
  Color _color8 = Colors.grey;
  Color _color9 = Colors.grey;
  Color _color10 = Colors.grey;
  Color _color11 = Colors.grey;
  Color _color12 = Colors.grey;

  var _formKey = GlobalKey<FormState>();
  PickedFile? _imagefiles, _imagefiles1, _imagefiles2;
  io.File? file, file1, file2, mainfile = null;
  CroppedFile? _croppedFile, _croppedFile1, _croppedFile2;
  bool? _isloading = false;
  String notiId = "",
      main_product = "",
      main_product1 = "",
      main_product2 = "",
      image1_id = "",
      image2_id = "";
  CommonPostdetail? commonPostdetail;
  late double? lat;
  late double? log;
  String? state, country_code, city, country;
  final ImagePicker _picker = ImagePicker();
  bool category1 = false;
  String type_post = "";
  bool _isloading1 = false;
  BuildContext? dialogContext;
  String? _selectcolor = "",
      _select_postType = "",
      _selectitem3 = null,
      _selectitem4 = null,
      _selectitem5 = null,
      _selectitem6 = null;
  String googleApikey = "AIzaSyCyqsD3OPUWGJ5AWbN3iKbUzQGs3Q-ZlPE";

  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(0, 0);
  String location = "Search Location";

  List listrupes = ['₹', '\$', '€', '£', '¥'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleData1.add(new RadioModel(false, 'Buy Post'));
    sampleData1.add(new RadioModel(
      false,
      'Sell Post',
    ));
    checknetwork();
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
    constanst.colorsitemsCheck.clear();
    constanst.selectcolor_name.clear();
    constanst.selectcolor_id.clear();
    constanst.select_prodcolor_idx = 0;
    constanst.unit_data = null;
    constanst.color_data = null;
    constanst.cat_typedata = null;
    constanst.cat_gradedata = null;
    constanst.cat_data = null;
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
    /* for (int i = 0; i < constanst.catdata.length; i++) {
      constanst.category_itemsCheck.add(Icons.circle_outlined);
    }*/
    /*for (int i = 0; i < constanst.cat_type_data.length; i++) {
      constanst.Type_itemsCheck.add(Icons.circle_outlined);
    }
    for (int i = 0; i < constanst.cat_grade_data.length; i++) {
      constanst.Grade_itemsCheck.add(Icons.circle_outlined);
    }*/
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Container(
                // height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(children: [
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
                                    ? CircularProgressIndicator(
                                        value: null,
                                        strokeWidth: 2.0,
                                        color: Color.fromARGB(255, 0, 91, 148),
                                      )
                                    : Platform.isIOS
                                        ? CupertinoActivityIndicator(
                                            color:
                                                Color.fromARGB(255, 0, 91, 148),
                                            radius: 20,
                                            animating: true,
                                          )
                                        : Container())
                            : Column(children: [
                                Row(children: [
                                  GestureDetector(
                                    child: Image.asset('assets/back.png',
                                        height: 50, width: 60),
                                    onTap: () {
                                      Navigator.pop(context);
                                      clear_data();
                                    },
                                  ),
                                  SizedBox(
                                    width: 80.0,
                                  ),
                                  Center(
                                      child: Text(
                                    'Update Post',
                                    style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets\fonst\Metropolis-Black.otf')
                                        ?.copyWith(fontSize: 20.0),
                                  ))
                                ]),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      25.0, 10.0, 25.0, 5.0),
                                  child: Column(children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'You’re like to do?',
                                        style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf')
                                            ?.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black38),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(

                                          child: SizedBox(
                                              height: 30,
                                              width: 120,
                                              child: Row(children: [
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      child: sampleData1.first
                                                                  .isSelected ==
                                                              true
                                                          ? Icon(
                                                              Icons.check_circle,
                                                              color: Colors
                                                                  .green.shade600)
                                                          : Icon(
                                                              Icons
                                                                  .circle_outlined,
                                                              color:
                                                                  Colors.black38),
                                                      onTap: () {
                                                        setState(() {
                                                          /* sampleData1.first
                                                              .isSelected = true;
                                                          type_post = 'BuyPost';
                                                          sampleData1.last
                                                              .isSelected = false;
                                                          category1 = true;*/
                                                        });
                                                      },
                                                    ),
                                                    Text(
                                                        sampleData1
                                                            .first.buttonText,
                                                        style: TextStyle(
                                                                fontSize: 13.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Colors.black,
                                                                fontFamily:
                                                                    'assets\fonst\Metropolis-Black.otf')
                                                            ?.copyWith(
                                                                fontSize: 17))
                                                  ],
                                                ),
                                              ])),
                                          onTap: () {
                                            setState(() {
                                              sampleData1.first
                                                  .isSelected = true;
                                              sampleData1.last
                                                  .isSelected = false;
                                              category1 = true;
                                              type_post = sampleData1
                                                  .first.buttonText;
                                              //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'hell $sampleData.last.isSelected');
                                            });
                                          },
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              sampleData1.last
                                                  .isSelected = true;
                                              sampleData1.first
                                                  .isSelected = false;
                                              category1 = true;
                                              type_post = sampleData1
                                                  .last.buttonText;
                                              //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'hell $sampleData.last.isSelected');
                                            });
                                          },
                                          child: SizedBox(
                                              width: 150,
                                              height: 30,
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    child: sampleData1.last
                                                                .isSelected ==
                                                            true
                                                        ? Icon(Icons.check_circle,
                                                            color: Colors
                                                                .green.shade600)
                                                        : Icon(
                                                            Icons.circle_outlined,
                                                            color:
                                                                Colors.black38),
                                                    onTap: () {
                                                      setState(() {
                                                        /*  sampleData1.last
                                                            .isSelected = true;
                                                        sampleData1.first
                                                            .isSelected = false;
                                                        category1 = true;
                                                        type_post = 'SalePost';*/
                                                        //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'hell $sampleData.last.isSelected');
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                      sampleData1.last.buttonText,
                                                      style: TextStyle(
                                                              fontSize: 13.0,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: Colors.black,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-Black.otf')
                                                          ?.copyWith(
                                                              fontSize: 17))
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                          Padding(
                            padding:
                            EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                            child: Container(
                              height: 55,
                              child: TypeAheadField<String>(
                                textFieldConfiguration:
                                TextFieldConfiguration(
                                  controller: _prodnm,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      fontFamily:
                                      'assets\fonst\Metropolis-Black.otf'),
                                  onChanged: (value) {
                                    if (value!.isEmpty) {
                                      Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                          msg:
                                          'Please Add Your Product Name');
                                      _color1 = Colors.red;
                                    } else {
                                      // setState(() {
                                      //_color3 = Colors.green.shade600;
                                      //});
                                    }
                                  },
                                  onSubmitted: (value) {
                                    if (value.isEmpty) {
                                      /* Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                                msg: 'Please Add Your Product Name');*/
                                      _color1 = Colors.red;
                                      setState(() {});
                                    } else if (value.isNotEmpty) {

                                      _color1 = Colors.green.shade600;
                                      setState(() {});
                                    }
                                  },

                                  /*  validator: (value) {
                                          // if (!EmailValidator.validate(value!)) {
                                          //   return 'Please enter a valid email';
                                          // }
                                          if (value!.isEmpty) {
                                            Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                                msg: 'Please Add Your Product Name');
                                            _color1 = Colors.red;
                                          } else {
                                            // setState(() {
                                            //_color3 = Colors.green.shade600;
                                            //});
                                          }
                                          return null;
                                        },*/

                                  textCapitalization:
                                  TextCapitalization.words,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    hintText: "Product Name *",
                                    hintStyle: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                        'assets\fonst\Metropolis-Black.otf')
                                        ?.copyWith(color: Colors.grey),
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

                                  /* validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please select an option';
                                          }
                                          return null;
                                        },*/
                                ),
                                suggestionsCallback: (pattern) {
                                  return _getSuggestions(pattern);
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(
                                      suggestion,
                                      style: TextStyle(
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

                                // prod_cate_dropdown(listitem, "Product Category"),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                                  child: TextFormField(
                                      controller: _prod_cate,
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
                                        suffixIcon:
                                            Icon(Icons.arrow_drop_down_sharp),
                                        hintText: "Product Category*",
                                        hintStyle: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf')
                                            ?.copyWith(color: Colors.grey),
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

                                        //errorText: _validusernm ? 'Name is not empty' : null),
                                      ),
                                   /*   validator: (value) {
                                        // if (!EmailValidator.validate(value!)) {
                                        //   return 'Please enter a valid email';
                                        // }
                                        if (value!.isEmpty) {
                                          Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                              msg:
                                                  'Please Your Product Category');
                                          _color2 = Colors.red;
                                          //return 'Enter a Color!';
                                        } else {
                                          // setState(() {
                                          //_color3 = Colors.green.shade600;
                                          //});
                                        }
                                        return null;
                                      },*/
                                      onTap: () {
                                        //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'hello');
                                        /*InkWell(
                                      onTap: () {*/
                                        //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'hello');
                                        Viewproduct(context);
                                        //},
                                        //);
                                      },
                                      onFieldSubmitted: (value) {
                                        if (value.isEmpty) {
                                          Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                              msg:
                                                  'Please Your Product Category');
                                          setState(() {});
                                        } else if (value.isNotEmpty) {
                                          setState(() {});
                                        }
                                      }),
                                ),

                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                                  child: TextFormField(
                                      controller: _prod_type,
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
                                        suffixIcon:
                                            Icon(Icons.arrow_drop_down_sharp),
                                        hintText: "Product Type *",
                                        hintStyle: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf')
                                            ?.copyWith(color: Colors.grey),
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

                                        //errorText: _validusernm ? 'Name is not empty' : null),
                                      ),
                                    /*  validator: (value) {
                                        // if (!EmailValidator.validate(value!)) {
                                        //   return 'Please enter a valid email';
                                        // }
                                        if (value!.isEmpty) {
                                          _color3 = Colors.red;
                                          Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                              msg:
                                                  'Please Your Product Category');
                                          //return 'Enter a Color!';
                                        } else {
                                          // setState(() {
                                          //_color3 = Colors.green.shade600;
                                          //});
                                        }
                                        return null;
                                      },*/
                                      onTap: () {
                                        //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'hello');
                                        /*InkWell(
                                      onTap: () {*/
                                        //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'hello');
                                        Viewtype(context);
                                        //},
                                        //);
                                      },
                                      onFieldSubmitted: (value) {
                                        if (value.isEmpty) {
                                          Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                              msg:
                                                  'Please Your Product Category');
                                          setState(() {});
                                        } else if (value.isNotEmpty) {
                                          setState(() {});
                                        }
                                      }),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                                  child: TextFormField(
                                      controller: _prod_grade,
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
                                        hintText: "Product Grade*",
                                        hintStyle: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf')
                                            ?.copyWith(color: Colors.grey),
                                        filled: true,
                                        fillColor: Colors.white,
                                        suffixIcon:
                                            Icon(Icons.arrow_drop_down_sharp),
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

                                        //errorText: _validusernm ? 'Name is not empty' : null),
                                      ),
                                     /* validator: (value) {
                                        // if (!EmailValidator.validate(value!)) {
                                        //   return 'Please enter a valid email';
                                        // }
                                        if (value!.isEmpty) {
                                          Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                              msg: 'Please Your Product Grade');
                                          _color4 = Colors.red;
                                          //return 'Enter a Color!';
                                        } else {
                                          // setState(() {
                                          //_color3 = Colors.green.shade600;
                                          //});
                                        }
                                        return null;
                                      },*/
                                      onTap: () {
                                        //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'hello');
                                        /*InkWell(
                                      onTap: () {*/
                                        //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'hello');
                                        Viewgrade(context);
                                        //},
                                        //);
                                      },
                                      onFieldSubmitted: (value) {
                                        if (value.isEmpty) {
                                          _color4 = Colors.red;
                                          Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                              msg:
                                                  'Please Your Product Category');
                                          setState(() {});
                                        } else if (value.isNotEmpty) {
                                          setState(() {});
                                        }
                                      }),
                                ),
                                //prod_grade_dropdown(listitem1, "Product Type"),

                          Container(
                            height: 62,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.fromLTRB(
                                25.0, 5.0, 25.0, 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: _color8),
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10))),
                            child: Row(children: [
                              Container(
                                  width:
                                  MediaQuery.of(context).size.width /
                                      2.9,
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode
                                        .onUserInteraction,
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
                                        /*  Fluttertoast.showToast(timeInSecForIosWeb: 2,
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
                                        /*  Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                                  msg:
                                                      'Please Add Your Product Price');*/
                                        setState(() {});
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      if (value.isEmpty) {
                                        /* Fluttertoast.showToast(timeInSecForIosWeb: 2,
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
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10))),
                            child: Row(children: [
                              Container(
                                //color: Colors.white,

                                  width:
                                  MediaQuery.of(context).size.width /
                                      1.7,
                                  padding: EdgeInsets.only(
                                      top: 3, bottom: 3.0, left: 2.0),
                                  child: TextFormField(
                                    autovalidateMode: AutovalidateMode
                                        .onUserInteraction,
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
                                            fontWeight:
                                            FontWeight.w400,
                                            color: Colors.grey,
                                            fontFamily:
                                            'assets\fonst\Metropolis-Black.otf')
                                            ?.copyWith(height: 2),
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        /*Fluttertoast.showToast(timeInSecForIosWeb: 2,
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
                                        /*  Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                                  msg:
                                                      'Please Add Your Product Quantity');*/
                                        setState(() {});
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      if (value.isEmpty) {
                                        /*Fluttertoast.showToast(timeInSecForIosWeb: 2,
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
                                            ?.copyWith(color: Colors.grey),
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
                                     /* validator: (value) {
                                        // if (!EmailValidator.validate(value!)) {
                                        //   return 'Please enter a valid email';
                                        // }
                                        if (value!.isEmpty) {
                                          Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                              msg: 'Please Your Color');
                                          _color5 = Colors.red;
                                        } else {
                                          // setState(() {
                                          //_color3 = Colors.green.shade600;
                                          //});
                                        }
                                        return null;
                                      },*/
                                      onTap: () {
                                        //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'hello');
                                        /*InkWell(
                                      onTap: () {*/
                                        //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'hello');
                                        ViewItem(context);
                                        //},
                                        //);
                                      },
                                      onFieldSubmitted: (value) {
                                        if (value.isEmpty) {
                                          Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                              msg: 'Please Your Color');
                                          _color5 = Colors.red;
                                          setState(() {});
                                        } else if (value.isNotEmpty) {
                                          setState(() {});
                                        }
                                      }),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                                  child: TextFormField(
                                    controller: _loc,
                                    readOnly: true,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets\fonst\Metropolis-Black.otf'),
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

                                          List<String> list = place.description
                                              .toString()
                                              .split(",");
                                          print(list);
                                          print('dvsdhsdf');
                                          print(list.length);
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
                                          print(state);
                                          print(city);
                                          print(country);

                                          _loc.text = location;
                                          _color5 = Colors.green.shade600;
                                          // print(location);
                                          setState(() {});
                                        });

                                        //form google_maps_webservice package
                                        final plist = GoogleMapsPlaces(
                                          apiKey: googleApikey,
                                          apiHeaders: await GoogleApiHeaders()
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
                                        var newlatlang = LatLng(lat!, log!);

                                        //move map camera to selected place with animation
                                        //mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Location/ Address / City",
                                      hintStyle: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf')
                                          ?.copyWith(color: Colors.grey),
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
                                   /* validator: (value) {
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
                                    },*/
                                    onFieldSubmitted: (value) {
                                      if (value.isEmpty) {
                                        Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                            msg: 'Please Your Location');
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
                                  padding: EdgeInsets.fromLTRB(
                                      25.0, 5.0, 25.0, 10.0),
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
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf')
                                          ?.copyWith(color: Colors.grey),

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

                                      //errorText: _validusernm ? 'Name is not empty' : null),
                                    ),
                                   /* validator: (value) {
                                      // if (!EmailValidator.validate(value!)) {
                                      //   return 'Please enter a valid email';
                                      // }
                                      if (value!.isEmpty) {
                                        Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                            msg:
                                                'Please Your Product Description');
                                        _color7 = Colors.red;
                                      } else {
                                        // setState(() {
                                        //_color3 = Colors.green.shade600;
                                        //});
                                      }
                                      return null;
                                    },*/
                                    onFieldSubmitted: (value) {
                                      if (value.isEmpty) {
                                        Fluttertoast.showToast(timeInSecForIosWeb: 2,
                                            msg:
                                                'Please Your Product Description');
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
                                    margin: EdgeInsets.fromLTRB(
                                        25.0, 0.0, 25.0, 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                            child: file != null
                                                ? Image.network(main_product,
                                                    height: 100, width: 100)
                                                : Image.file(mainfile!,
                                                    height: 100, width: 100),
                                            onTap: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) =>
                                                      bottomsheet());
                                              // takephoto(ImageSource.gallery,);
                                            }),
                                        image1_id.isNotEmpty
                                            ? Stack(
                                                children: [
                                                  GestureDetector(
                                                    child: file1 != null
                                                        ? Image.network(
                                                            main_product1,
                                                            height: 100,
                                                            width: 100)
                                                        : Image.asset(
                                                            'assets/addphoto1.png',
                                                            height: 100,
                                                            width: 100),
                                                    onTap: () {
                                                      //takephoto1(ImageSource.gallery);
                                                      /* showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) =>
                                                        bottomsheet1());*/
                                                    },
                                                  ),
                                                  Visibility(
                                                    visible: file1 == null
                                                        ? false
                                                        : true,
                                                    child: Positioned(
                                                        bottom: -5,
                                                        left: 25,
                                                        child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          margin:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                          child: Card(
                                                              //margin: EdgeInsets.all(5),
                                                              shape:
                                                                  CircleBorder(),
                                                              child:
                                                                  GestureDetector(
                                                                child: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .red),
                                                                onTap: () {
                                                                  setState(() {
                                                                    file1 =
                                                                        null;

                                                                    delete_subimage(
                                                                        image1_id);
                                                                    image1_id =
                                                                        "";
                                                                  });
                                                                },
                                                              )),
                                                        )),
                                                  )
                                                ],
                                              )
                                            : Stack(
                                                children: [
                                                  GestureDetector(
                                                    child: _imagefiles1 != null
                                                        ? Image.file(file1!,
                                                            height: 100,
                                                            width: 100)
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
                                                    visible:
                                                        _imagefiles1 == null
                                                            ? false
                                                            : true,
                                                    child: Positioned(
                                                        bottom: -5,
                                                        left: 25,
                                                        child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          margin:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                          child: Card(
                                                              //margin: EdgeInsets.all(5),
                                                              shape:
                                                                  CircleBorder(),
                                                              child:
                                                                  GestureDetector(
                                                                child: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .red),
                                                                onTap: () {
                                                                  setState(() {
                                                                    _imagefiles1 =
                                                                        null;
                                                                    constanst
                                                                        .imagesList
                                                                        .remove(
                                                                            _imagefiles1);
                                                                  });
                                                                },
                                                              )),
                                                        )),
                                                  )
                                                ],
                                              ),
                                        image2_id.isNotEmpty
                                            ? Stack(
                                                children: [
                                                  GestureDetector(
                                                    child: file2 != null
                                                        ? Image.network(
                                                            main_product2,
                                                            height: 100,
                                                            width: 100)
                                                        : Image.asset(
                                                            'assets/addphoto1.png',
                                                            height: 100,
                                                            width: 100),
                                                    onTap: () {
                                                      //takephoto1(ImageSource.gallery);
                                                      /*showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) =>
                                                        bottomsheet1());*/
                                                    },
                                                  ),
                                                  Visibility(
                                                    visible: file2 == null
                                                        ? false
                                                        : true,
                                                    child: Positioned(
                                                        bottom: -5,
                                                        left: 25,
                                                        child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          margin:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                          child: Card(
                                                              //margin: EdgeInsets.all(5),
                                                              shape:
                                                                  CircleBorder(),
                                                              child:
                                                                  GestureDetector(
                                                                child: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .red),
                                                                onTap: () {
                                                                  setState(() {
                                                                    file2 =
                                                                        null;

                                                                    delete_subimage(
                                                                        image2_id);
                                                                    image2_id =
                                                                        "";
                                                                  });
                                                                },
                                                              )),
                                                        )),
                                                  )
                                                ],
                                              )
                                            : Stack(
                                                children: [
                                                  GestureDetector(
                                                    child: _imagefiles2 != null
                                                        ? Image.file(file2!,
                                                            height: 100,
                                                            width: 100)
                                                        : Image.asset(
                                                            'assets/addphoto1.png',
                                                            height: 100,
                                                            width: 100),
                                                    onTap: () {
                                                      //takephoto1(ImageSource.gallery);
                                                      showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) =>
                                                              bottomsheet2());
                                                    },
                                                  ),
                                                  Visibility(
                                                    visible:
                                                        _imagefiles2 == null
                                                            ? false
                                                            : true,
                                                    child: Positioned(
                                                        bottom: -5,
                                                        left: 25,
                                                        child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          margin:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                          child: Card(
                                                              //margin: EdgeInsets.all(5),
                                                              shape:
                                                                  CircleBorder(),
                                                              child:
                                                                  GestureDetector(
                                                                child: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .red),
                                                                onTap: () {
                                                                  setState(() {
                                                                    _imagefiles2 =
                                                                        null;
                                                                    constanst
                                                                        .imagesList
                                                                        .remove(
                                                                            _imagefiles2);
                                                                  });
                                                                },
                                                              )),
                                                        )),
                                                  )
                                                ],
                                              ),
                                      ],
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Color.fromARGB(255, 0, 91, 148)),
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
                                    child: Text('Update',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 19,
                                            color: Colors.white)),
                                  ),
                                ),
                              ]),
                      ),
                    ),
                  )
                ]))));
  }


  void _onLoading() {
    dialogContext=context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context; // Store the context in a variable
        return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child:  SizedBox(
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
                          : Container()
                  ),
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

  /*clear_data() {
    _selectitem4 = null;
    _selectitem5 = null;
    _selectitem6 = null;
    constanst.unitdata.clear();
    constanst.colorsitemsCheck.clear();
    constanst.category_itemsCheck.clear();
    constanst.Type_itemsCheck.clear();
    constanst.Grade_itemsCheck.clear();
    constanst.select_grade_name.clear();
    constanst.select_gradeId.clear();
    constanst.selectcolor_name.clear();
    constanst.selectcolor_id.clear();
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
    constanst.select_prodcolor_idx;
    constanst.catdata.clear();
    constanst.cat_type_data.clear();
    constanst.cat_grade_data.clear();
  }*/
  List<String> _getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(_suggestions);

    matches.retainWhere(
            (suggestion) => suggestion.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
  Future<bool> update_SalePost() async {
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    constanst.step = 11;
    print(constanst.select_grade_id);
    int image_counter = constanst.imagesList.length;
    var res = await updateSalePost(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        constanst.select_type_id,
        constanst.select_grade_id,
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
        '0',
        city!,
        state!,
        country!,
        constanst.step.toString(),
        _prodnm.text.toString(),
        constanst.select_cat_id,
        mainfile,
        widget.prod_id.toString());
    /* 'userId':userId,'userToken':userToken,'business_name':business_name,'business_type':business_type,'location':location,'longitude':longitude,'longitude':latitude,'other_mobile1':other_mobile1,'country':country,
    'countryCode':countryCode,
    'business_phone':business_phone,'business_type':business_type,'city':city,'email':email,'website':website,'about_business':about_business,
    'profilePicture':file,'gst_tax_vat':gst_tax_vat,'state':state*/

    print(res);
    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);
      clear_data();
      _isloading1 = true;
      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(0)));*/
      clear_data();
    } else {
      clear_data();
      _isloading1 = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    return _isloading1;
  }

  Future<bool> update_BuyPost() async {
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(_pref.getString('user_id').toString());
    int image_counter = constanst.imagesList.length;
    var res = await updateBuyerPost(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        constanst.select_type_id,
        constanst.select_grade_id,
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
        '0',
        city!,
        state!,
        country!,
        "11",
        _prodnm.text.toString(),
        constanst.select_cat_id,
        mainfile,
        widget.prod_id.toString());
    /* 'userId':userId,'userToken':userToken,'business_name':business_name,'business_type':business_type,'location':location,'longitude':longitude,'longitude':latitude,'other_mobile1':other_mobile1,'country':country,
    'countryCode':countryCode,
    'business_phone':business_phone,'business_type':business_type,'city':city,'email':email,'website':website,'about_business':about_business,
    'profilePicture':file,'gst_tax_vat':gst_tax_vat,'state':state*/

    print(res);
    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);
      clear_data();
    /*  Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(0)));
      clear_data();*/
      _isloading1 = true;
    } else {
      clear_data();
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
                    takephoto(ImageSource.camera,FilterQuality.none);
                  },
                  icon: Icon(Icons.camera,
                      color: Color.fromARGB(255, 0, 91, 148)),
                  label: Text(
                    'Camera',
                    style: TextStyle(color: Color.fromARGB(255, 0, 91, 148)),
                  )),
              TextButton.icon(
                  onPressed: () {
                    takephoto(ImageSource.gallery,FilterQuality.none);
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

  void takephoto(ImageSource imageSource, FilterQuality quality) async {
    final pickedfile = await _picker.getImage(source: imageSource,imageQuality: 50);
    setState(() async {
      _imagefiles = pickedfile!;
      //file = io.File(_imagefiles!.path);
      file = null;
      mainfile = await _cropImage(imagefile: io.File(_imagefiles!.path));

      Navigator.of(context).pop();

      // print('image path : ');
      // print(_imagefiles!.path);
    });
  }

  Future<io.File?> _cropImage({required io.File imagefile}) async {
    if (imagefile != null) {
      final croppedFile = await ImageCropper().cropImage(
          sourcePath: imagefile!.path,
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
      }
    } else {
      return null;
    }
  }

  Widget bottomsheet1() {
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
                    takephoto1(ImageSource.camera,FilterQuality.none);
                  },
                  icon: Icon(Icons.camera,
                      color: Color.fromARGB(255, 0, 91, 148)),
                  label: Text(
                    'Camera',
                    style: TextStyle(color: Color.fromARGB(255, 0, 91, 148)),
                  )),
              TextButton.icon(
                  onPressed: () {
                    takephoto1(ImageSource.gallery,FilterQuality.none);
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

  void takephoto1(ImageSource imageSource,FilterQuality quality) async {
    final pickedfile = await _picker.getImage(source: imageSource,imageQuality: 50);
    setState(() async {
      _imagefiles1 = pickedfile!;
      //file = io.File(_imagefiles!.path);
      file1 = await _cropImage1(imagefile: io.File(_imagefiles1!.path));
      constanst.imagesList.add(file1!);
      Navigator.of(context).pop();

      // print('image path : ');
      // print(_imagefiles!.path);
    });
  }

  Future<io.File?> _cropImage1({required io.File imagefile}) async {
    if (imagefile != null) {
      final croppedFile = await ImageCropper().cropImage(
          sourcePath: imagefile!.path,
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
          _croppedFile1 = croppedFile;
        });
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
                    takephoto2(ImageSource.camera,FilterQuality.none);
                  },
                  icon: Icon(Icons.camera,
                      color: Color.fromARGB(255, 0, 91, 148)),
                  label: Text(
                    'Camera',
                    style: TextStyle(color: Color.fromARGB(255, 0, 91, 148)),
                  )),
              TextButton.icon(
                  onPressed: () {
                    takephoto2(ImageSource.gallery,FilterQuality.none);
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

  void takephoto2(ImageSource imageSource,FilterQuality quality) async {
    final pickedfile = await _picker.getImage(source: imageSource,imageQuality: 50);
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
          sourcePath: imagefile!.path,
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
          _croppedFile2 = croppedFile;
        });
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
      padding: EdgeInsets.only(left: 18.0),
      child: Align(
          alignment: Alignment.centerLeft,
          child: DropdownButton(
            value: _selectitem5,
            hint: Text(hint,
                style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'assets\fonst\Metropolis-Black.otf')
                    ?.copyWith(color: _color9)),
            dropdownColor: Colors.white,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 40,
            isExpanded: true,
            underline: SizedBox(),
            items: listitem.map((valueItem) {
              return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem,
                      style: TextStyle(
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
                style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'assets\fonst\Metropolis-Black.otf')
                    ?.copyWith(color: _color12)),
            dropdownColor: Colors.white,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 40,
            isExpanded: true,
            underline: SizedBox(),
            items: listitem.map((valueItem) {
              return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem,
                      style: TextStyle(
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
                style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'assets\fonst\Metropolis-Black.otf')
                    ?.copyWith(color: _color10, fontSize: 14)),
            dropdownColor: Colors.white,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 40,
            isExpanded: true,
            underline: SizedBox(),
            items: listitem.map((valueItem) {
              return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem,
                      style: TextStyle(
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
    if (category1 == false) {
      //_color1 = Colors.red;
      Fluttertoast.showToast(msg: 'Please Select Sale Post or Buy Post');
    } else if (_prodnm.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please Add Your Product Name');
      _color1 = Colors.red;
      setState(() {});
    } else if (_prod_cate.text.toString().isEmpty) {
      Fluttertoast.showToast(msg: 'Please Select Category');
      _color2 = Colors.red;
      setState(() {});
    } else if (_prod_type.text.toString().isEmpty) {
      Fluttertoast.showToast(msg: 'Please Select Type');
      _color3 = Colors.red;
      setState(() {});
    } else if (_prod_grade.text.toString().isEmpty) {
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
    } /*else if (_imagefiles == null) {
      Fluttertoast.showToast(msg: 'Please Add Your Product Image');
    }*/

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
    /*if (category1 == false) {
      _color1 = Colors.red;
      Fluttertoast.showToast(msg: 'Please Select Sale Post or Buy Post');
    }*/
    if (_prodnm.text.isNotEmpty) {
      //Fluttertoast.showToast(msg: 'Please Add Your Product Name');
      _color1 = Colors.green.shade600;
      setState(() {});
    }
    if (constanst.select_cat_name.isNotEmpty) {
      //  Fluttertoast.showToast(msg: 'Please Select Category');
      _color2 = Colors.green.shade600;
      setState(() {});
    }
    if (constanst.select_type_name.isNotEmpty) {
      //Fluttertoast.showToast(msg: 'Please Select Type');
      _color3 = Colors.green.shade600;
      setState(() {});
    }
    if (constanst.select_grade_name.isNotEmpty) {
      // Fluttertoast.showToast(msg: 'Please Select Grade');
      _color4 = Colors.green.shade600;
      setState(() {});
    } /*if (_prodprice.text.isNotEmpty) {
      //Fluttertoast.showToast(msg: 'Please Add Your Product Price ');
      _color8 = Colors.green.shade600;
      setState(() {});
    }  if (_selectitem5 != null) {
    //  Fluttertoast.showToast(msg: 'Select Product Unit');
      _color8 = Colors.green.shade600;
      setState(() {});
    }  if (_selectitem4 != null) {
     // Fluttertoast.showToast(msg: 'Please Select Currency Sign ');
      _color8 = Colors.green.shade600;
      setState(() {});
    }  */ /*if (_prodqty.text.isNotEmpty) {
     // Fluttertoast.showToast(msg: "Please Add Your Product Price");
      _color10 = Colors.green.shade600;
      setState(() {});
    }  if (_selectitem6 != null) {
    //  Fluttertoast.showToast(msg: 'Select Product Unit');
      _color10 = Colors.green.shade600;
    }  */
    if (constanst.select_color_name.isNotEmpty) {
      //Fluttertoast.showToast(msg: 'Please Select Product Colour');
      _color5 = Colors.green.shade600;
      setState(() {});
    }
    if (_loc.text.isNotEmpty) {
      //  Fluttertoast.showToast(msg: "Please Add Stock Location");
      _color6 = Colors.green.shade600;
      setState(() {});
    }
    if (_proddetail.text.isNotEmpty) {
      //   Fluttertoast.showToast(msg: "Please Add Stock Location");
      _color7 = Colors.green.shade600;
      setState(() {});
    }
    if (type_post == 'SalePost') {
      // if (_imagefiles == null) {
      //   Fluttertoast.showToast(msg: 'Select Product Image');
      // } else {


      print(constanst.imagesList.length);
        if (constanst.imagesList.isEmpty){


            if(_prodqty.text.toString().isNotEmpty && category1 && _prodnm.text.toString().isNotEmpty
                && _prod_cate.text.toString().isNotEmpty &&  _prod_type.text.toString().isNotEmpty &&
                _prodprice.text.isNotEmpty&&
                _selectitem5 != null&&
                _selectitem4 != null&&
                _prodqty.text.isNotEmpty&&
                _selectitem6 != null&&
                _loc.text.isNotEmpty&&
                _proddetail.text.isNotEmpty) {
              _onLoading();
              // add_salesubimage(widget.prod_id.toString());
              await update_SalePost().then((value) {
                print('123456$value');
                Navigator.of(dialogContext!).pop();
                if (value) {
                  print('1234568$value');
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen(0)));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen(0)));
                }
                //Navigator.of(dialogContext!).pop(); // loader
                /*Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => MainScreen(0)),
            ModalRoute.withName('/'));*/
              });
            }
        } else {
          //_onLoading();

          print('fdd${_prod_cate.text.toString()}');
          if( _prodqty.text.toString().isNotEmpty && category1 && _prodnm.text.toString().isNotEmpty
              && _prod_cate.text.toString().isNotEmpty &&  _prod_type.text.toString().isNotEmpty &&
              _prodprice.text.isNotEmpty&&
              _selectitem5 != null&&
              _selectitem4 != null&&
              _prodqty.text.isNotEmpty&&
              _selectitem6 != null&&
              _loc.text.isNotEmpty&&
              _proddetail.text.isNotEmpty) {
            _onLoading();
            await add_salesubimage(widget.prod_id.toString());
            update_SalePost().then((value) {
              print('12345$value');
              Navigator.of(dialogContext!).pop();
              if (value) {
                print('12345456$value');
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MainScreen(0),
                    )).then((value) =>  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MainScreen(0),
                    )));
              } else {
                print('123454567888$value');
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen(0)));
              }
              Navigator.of(dialogContext!).pop(); // loader
              /*Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => MainScreen(0)),
            ModalRoute.withName('/'));*/
            });
          }
        }
        // }

    } else if (type_post == 'BuyPost') {
      if (constanst.imagesList.isNotEmpty)
      {
        if(
        _prodqty.text.toString().isNotEmpty && category1 && _prodnm.text.toString().isNotEmpty
            && _prod_cate.text.toString().isNotEmpty &&  _prod_type.text.toString().isNotEmpty &&
            _prodprice.text.isNotEmpty&&
            _selectitem5 != null&&
            _selectitem4 != null&&
            _prodqty.text.isNotEmpty&&
            _selectitem6 != null&&
            _loc.text.isNotEmpty&&
            _proddetail.text.isNotEmpty) {
          _onLoading();
          await add_buysubimage(widget.prod_id.toString());

        }
      } else {
        if (
        _prodqty.text.toString().isNotEmpty && category1 && _prodnm.text.toString().isNotEmpty
            && _prod_cate.text.toString().isNotEmpty &&  _prod_type.text.toString().isNotEmpty &&
            _prodprice.text.isNotEmpty&&
            _selectitem5 != null&&
            _selectitem4 != null&&
            _prodqty.text.isNotEmpty&&
            _selectitem6 != null&&
            _loc.text.isNotEmpty&&
            _proddetail.text.isNotEmpty) {
          _onLoading();
          update_BuyPost().then((value) {
            print('12345$value');
            Navigator.of(dialogContext!).pop();
            if (value) {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen(0)));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen(0)));
            }
            Navigator.of(dialogContext!).pop(); // loader
            /*Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => MainScreen(0)),
            ModalRoute.withName('/'));*/
          });
        }
      }
    }
    if (_prodprice.text.isEmpty) {
      _color8 = Colors.red;
    }
    if (_prodqty.text.isEmpty) {
      _color11 = Colors.red;
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
                  return selectcolor(_prodcolor.text);
                },
              );
            })).then(
      (value) {
        _prodcolor.text = constanst.select_color_name;
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
                  constanst.select_cat_idx = findcategory(_prod_cate.text);
                  return selectcategory();
                },
              );
            })).then(
      (value) {
        if (constanst.select_cat_name.isNotEmpty) {
          _prod_cate.text = constanst.select_cat_name;
        }
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
                  constanst.select_type_idx = findtype(_prod_type.text);
                  return selectType();
                },
              );
            })).then(
      (value) {
        if (constanst.select_type_name.isNotEmpty) {
          _prod_type.text = constanst.select_type_name;
        }
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
                  //constanst.select_grade_idx = findgrade(_prod_grade.text);
                  return selectGrade();
                },
              );
            })).then(
      (value) {
        print(constanst.select_grade_name);
        if (constanst.select_grade_name.isNotEmpty) {
          _prod_grade.text = constanst.select_grade_name.join(',');
          constanst.select_grade_id = constanst.select_gradeId.join(',');
        }
      },
    );
  }

  void get_data1() async {
    GetCategoryTypeController b_type = await GetCategoryTypeController();
    constanst.cat_typedata = b_type.setType();

    constanst.cat_typedata!.then((value) {
      if (value != null) {
        for (var item in value) {
          constanst.cat_type_data.add(item);
        }
        for (int i = 0; i < constanst.cat_type_data.length; i++) {
          constanst.Type_itemsCheck.add(Icons.circle_outlined);
        }
      }

      setState(() {});
    });
    //
  }

  void get_data2() async {
    GetCategoryGradeController bt = await GetCategoryGradeController();
    constanst.cat_gradedata = bt.setGrade();

    constanst.cat_gradedata!.then((value) {
      if (value != null) {
        for (var item in value) {
          constanst.cat_grade_data.add(item);
        }
        for (int i = 0; i < constanst.cat_grade_data.length; i++) {
          constanst.Grade_itemsCheck.add(Icons.circle_outlined);
        }
      }
    });
    _isloading = true;
    setState(() {});
    //
  }

  void get_data4() async {
    GetUnitController b_type = await GetUnitController();
    constanst.unit_data = b_type.setunit();

    constanst.unit_data!.then((value) {
      if (value != null) {
        for (var item in value) {
          constanst.unitdata.add(item);
        }
      }
      print('here me....');
      _isloading = true;
      setState(() {});
    });
    // _isloading=false;
    //
  }
  Future get_product_name() async {
    GetProductName getdir = GetProductName();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await get_productname();

    var jsonarray;
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
    setState(() {});
    return jsonarray;
  }
  checknetwork() async {
    clear_data();
    final connectivityResult = await Connectivity().checkConnectivity();
    constanst.catdata.clear();
    constanst.colordata.clear();
    constanst.cat_grade_data.clear();
    constanst.cat_type_data.clear();
    constanst.selectcolor_name.clear();
    constanst.selectcolor_id.clear();
    _isloading = false;
    if (connectivityResult == ConnectivityResult.none) {
      constanst.catdata.clear();
      constanst.colordata.clear();
      constanst.cat_grade_data.clear();
      constanst.cat_type_data.clear();
      _isloading = false;
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      clear_data();
      if (widget.post_type == 'SalePost') {
        get_SalePostDatil();
        get_product_name();
        get_data();
        get_data1();
        get_data2();
        get_data3();
        get_data4();
      } else if (widget.post_type == 'BuyPost') {
        get_product_name();
        get_BuyPostDatil();
        get_data();
        get_data1();
        get_data2();
        get_data3();
        get_data4();
      }
    }
  }

  get_SalePostDatil() async {
    commonPostdetail = CommonPostdetail();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var color_id = [], color_nm = [];
    // Fluttertoast.showToast(msg: widget.prod_id.toString());
    var res = await getPost_datail1(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        widget.prod_id.toString(),
        notiId.toString());
    var jsonarray, color_array, sub_image;
    List<postdetail.SubproductImage> image = [];

    print(res);
    if (res['status'] == 1) {
      commonPostdetail = CommonPostdetail.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];
        print('dfs');
        print(jsonarray);
        for (var data in jsonarray) {
          print(data);
          _prod_cate.text = data['CategoryName'];
          _prod_grade.text = data['ProductGrade'];
          _prod_type.text = data['ProductType'];
          _prodqty.text = data['PostQuntity'];
          _proddetail.text = data['Description'];

          _prodprice.text = data['ProductPrice'];
          _prodnm.text = data['PostName'];

          _selectitem4 = data['Currency'];
          _selectitem6 = data['Unit'];
          _selectitem5 = data['unit_of_price'];
          _loc.text = data['Location'];
          _select_postType = data['PostType'];
          category1 = true;
          type_post = data['PostType'];
          color_array = data['PostHaxCodeColor'];
          constanst.select_cat_id = data['CategoryId'];
          constanst.select_type_id = data['productTypeId'];
          constanst.select_grade_id = data['ProductGradeId'];
          lat = double.parse(data['Latitude']);
          log = double.parse(data['Longitude']);
          main_product = data['mainproductImage'];
          state = data['State'];
          city = data['City'];
          country = data['Country'];

          sub_image = data['subproductImage'];

          print(data['Latitude']);
          print('-------');
          print(lat);

          print(constanst.select_cat_id);

          print(constanst.select_type_id);
          //constanst.select_type_id=findtype(_prod_type.text.toString()).toString();

          print(constanst.select_grade_id);

          print(sub_image);
          if (sub_image != null) {
            for (var data in sub_image) {
              postdetail.SubproductImage record = postdetail.SubproductImage(
                  productImageId: data['productImageId'],
                  subImageUrl: data['sub_image_url']);

              image.add(record);

              /* postdetail.SubproductImage images = data[0];
              main_product1 = data..subImageUrl.toString();
              file1 = io.File(main_product1);
              if (data[1] != null) {
                postdetail.SubproductImage image1 = data[1];
                main_product2 = image1.subImageUrl.toString();
                file2 = io.File(main_product2);
              }*/
            }
            if (image.length == 1) {
              main_product1 = image[0].subImageUrl.toString();
              image1_id = image[0].productImageId.toString();
              print('main_product $main_product1');
              file1 = io.File(main_product1);
            }

            if (image.length == 2) {
              main_product1 = image[0].subImageUrl.toString();
              image1_id = image[0].productImageId.toString();

              print('main_product $main_product1');
              file1 = io.File(main_product1);

              main_product2 = image[1].subImageUrl.toString();
              image2_id = image[1].productImageId.toString();

              print('main_product1 $main_product2');
              file2 = io.File(main_product2);
            }
          }
        }

        // imagelist.add(main_product!);

        file = io.File(main_product);
        if (color_array != null) {
          for (var data in color_array) {
            constanst.selectcolor_id.add(data['colorId']);
            constanst.selectcolor_name.add(data['colorName']);
          }
        }
        constanst.select_color_name = constanst.selectcolor_name.join(",");
        print(constanst.select_color_name);

        constanst.select_color_id = constanst.selectcolor_id.join(",");
        print(constanst.select_color_id);

        _prodcolor.text = constanst.select_color_name.toString();

        // for (int i = 0; i < subjsonarray.length; i++) {
        //for (var data in subjsonarray) {

        // }
        // _prodcolor.text = _selectcolor.toString();

        // }
      }
      if (_select_postType == "SalePost") {
        sampleData1.last.isSelected = true;
      } else if (_select_postType == "BuyPost") {
        sampleData1.first.isSelected = true;
      }
      //constanst.select_grade_id = _prod_grade.text.toString();

      constanst.select_grade_name = _prod_grade.text.toString().split(',');
      constanst.select_gradeId = constanst.select_grade_id.split(',');
      print('Select Grade ${constanst.select_gradeId}');
      _isloading = true;
      print(_isloading);
      _isloading = true;
      print(_isloading);

      /*  if(subjsonarray!=null){
        for (var data in subjsonarray) {
          main_product=data['sub_image_url'];

          imagelist.add(main_product!);
        }

      }*/
      _isloading = true;
      setState(() {});
    } else {
      _isloading = true;
      Fluttertoast.showToast(msg: res['message']);
    }

    return jsonarray;
  }

  get_BuyPostDatil() async {
    commonPostdetail = CommonPostdetail();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var color_id = [], color_nm = [];
    Fluttertoast.showToast(msg: widget.prod_id.toString());
    var res = await getPost_datail(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        widget.prod_id.toString(),
        notiId.toString());
    var jsonarray, color_array, sub_image;
    List<postdetail.SubproductImage> image = [];

    print(res);
    if (res['status'] == 1) {
      commonPostdetail = CommonPostdetail.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];
        print('dfs');
        print(jsonarray);
        for (var data in jsonarray) {
          print(data);
          _prod_cate.text = data['CategoryName'];
          _prod_grade.text = data['ProductGrade'];

          _prod_type.text = data['ProductType'];
          _prodqty.text = data['PostQuntity'];
          _proddetail.text = data['Description'];

          _prodprice.text = data['ProductPrice'];
          _prodnm.text = data['PostName'];

          _selectitem4 = data['Currency'];
          _selectitem5 = data['Unit'];
          _selectitem6 = data['unit_of_price'];
          _loc.text = data['Location'];
          _select_postType = data['PostType'];
          category1 = true;
          type_post = data['PostType'];
          color_array = data['PostHaxCodeColor'];
          constanst.select_cat_id = data['CategoryId'];
          constanst.select_type_id = data['productTypeId'];
          constanst.select_grade_id = data['ProductGradeId'];
          lat = double.parse(data['Latitude']);
          log = double.parse(data['Longitude']);
          main_product = data['mainproductImage'];

          state = data['State'];
          city = data['City'];
          country = data['Country'];

          sub_image = data['subproductImage'];

          print(data['Latitude']);
          print('-------');
          print(lat);

          print(constanst.select_cat_id);

          print(constanst.select_type_id);
          //constanst.select_type_id=findtype(_prod_type.text.toString()).toString();

          print(constanst.select_grade_id);

          print(sub_image);
          if (sub_image != null) {
            for (var data in sub_image) {
              postdetail.SubproductImage record = postdetail.SubproductImage(
                  productImageId: data['productImageId'],
                  subImageUrl: data['sub_image_url']);

              image.add(record);

              /* postdetail.SubproductImage images = data[0];
              main_product1 = data..subImageUrl.toString();
              file1 = io.File(main_product1);
              if (data[1] != null) {
                postdetail.SubproductImage image1 = data[1];
                main_product2 = image1.subImageUrl.toString();
                file2 = io.File(main_product2);
              }*/
            }
            if (image.length == 1) {
              main_product1 = image[0].subImageUrl.toString();
              image1_id = image[0].productImageId.toString();
              print('main_product $main_product1');
              file1 = io.File(main_product1);
            }

            if (image.length == 2) {
              main_product1 = image[0].subImageUrl.toString();
              image1_id = image[0].productImageId.toString();

              print('main_product $main_product1');
              file1 = io.File(main_product1);

              main_product2 = image[1].subImageUrl.toString();
              image2_id = image[1].productImageId.toString();

              print('main_product1 $main_product2');
              file2 = io.File(main_product2);
            }
          }
        }

        // imagelist.add(main_product!);

        file = io.File(main_product);
        if (color_array != null) {
          for (var data in color_array) {
            constanst.selectcolor_id.add(data['colorId']);
            constanst.selectcolor_name.add(data['colorName']);
          }
        }
        constanst.select_color_name = constanst.selectcolor_name.join(",");
        print(constanst.select_color_name);

        constanst.select_color_id = constanst.selectcolor_id.join(",");
        print(constanst.select_color_id);

        _prodcolor.text = constanst.select_color_name.toString();

        // for (int i = 0; i < subjsonarray.length; i++) {
        //for (var data in subjsonarray) {

        // }
        // _prodcolor.text = _selectcolor.toString();

        // }
      }
      if (_select_postType == "SalePost") {
        sampleData1.last.isSelected = true;
      } else if (_select_postType == "BuyPost") {
        sampleData1.first.isSelected = true;
      }
      //constanst.select_grade_id = _prod_grade.text.toString();
      constanst.select_grade_name = _prod_grade.text.toString().split(',');
      constanst.select_gradeId = constanst.select_grade_id.split(',');
      _isloading = true;
      print(_isloading);

      /*  if(subjsonarray!=null){
        for (var data in subjsonarray) {
          main_product=data['sub_image_url'];

          imagelist.add(main_product!);
        }

      }*/
      _isloading = true;
      setState(() {});
    } else {
      _isloading = true;
      Fluttertoast.showToast(msg: res['message']);
    }

    return jsonarray;
  }

  void get_data() async {
    GetCategoryController bt = await GetCategoryController();
    constanst.cat_data = bt.setlogin();
    _isloading = true;
    constanst.cat_data!.then((value) {
      if (value != null) {
        for (var item in value) {
          constanst.catdata.add(item);
        }
        for (int i = 0; i < constanst.catdata.length; i++) {
          constanst.category_itemsCheck.add(Icons.circle_outlined);
        }
      }
      _isloading = true;
    });
    //
  }

  void get_data3() async {
    GetColorsController bt = await GetColorsController();
    constanst.color_data = bt.setlogin();
    _isloading = true;
    constanst.color_data!.then((value) {
      if (value != null) {
        for (var item in value) {
          constanst.colordata.add(item);
        }
      }
      _isloading = true;
      setState(() {});
    });
    //
  }

  findcategory(cat_name) {
    final index = constanst.catdata
        .indexWhere((element) => element.categoryName == cat_name);
    //qtn = _cartItems[index].qtn;

    print('new qtn $index');

    return index;
  }

  findtype(cat_name) {
    final index = constanst.cat_type_data
        .indexWhere((element) => element.productType == cat_name);
    //qtn = _cartItems[index].qtn;

    print('new qtn $index');

    return index;
  }

  findgrade(cat_name) {
    final index = constanst.cat_grade_data
        .indexWhere((element) => element.productGrade == cat_name);
    //qtn = _cartItems[index].qtn;

    print('new qtn $index');

    return index;
  }

  delete_subimage(String prod_id) async {
    common_par gethomepost = common_par();

    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await deletePostSubImage(
        prod_id,
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      gethomepost = common_par.fromJson(res);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }

  add_salesubimage(String prod_id) async {
    common_par gethomepost = common_par();
    int image_counter = constanst.imagesList.length;

    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(_pref.getString('api_token').toString());
    var res = await addPostSubImage(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        prod_id,
        image_counter.toString());
    //String user_id,String userToken,String productId,String image_counter
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      gethomepost = common_par.fromJson(res);
      Fluttertoast.showToast(msg: res['message']);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }

  add_buysubimage(String prod_id) async {
    common_par gethomepost = common_par();
    int image_counter = constanst.imagesList.length;

    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(_pref.getString('api_token').toString());
    var res = await addBuyeSubImage(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        prod_id,
        image_counter.toString());
    //String user_id,String userToken,String productId,String image_counter
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      gethomepost = common_par.fromJson(res);
      Fluttertoast.showToast(msg: res['message']);
      await update_BuyPost().then((value) {
        print('12345$value');
        Navigator.of(dialogContext!).pop();
        if (value) {
          Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MainScreen(0),
              )).then((value) =>  Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MainScreen(0),
              )));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainScreen(0)));
        }
      /*  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainScreen(0)));*/
        Navigator.of(dialogContext!).pop(); // loader

        /*Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => MainScreen(0)),
            ModalRoute.withName('/'));*/
      });
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }
}

class selectcolor extends StatefulWidget {
  String colors_name;
  selectcolor(this.colors_name, {Key? key}) : super(key: key);

  @override
  State<selectcolor> createState() => _selectcolorState();
}

class _selectcolorState extends State<selectcolor> {
  int? _radioValue = 0;
  int? _selectindex;
  String? assignedName;
  bool gender = false;

  findcolor(cat_name) {
    final index = constanst.colordata
        .indexWhere((element) => element.colorId == cat_name);
    //qtn = _cartItems[index].qtn;
    print('new qtn $index');
    return index;
  }

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
                      int i = 0;
                      color.Result record = constanst.colordata[index];

                     // String color_id = constanst.selectcolor_id[i].toString();

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
                              if (!constanst.selectcolor_id
                                  .contains(record.colorId.toString())) {
                                constanst.colorsitemsCheck[index] =
                                    Icons.check_circle_outline;

                                constanst.selectcolor_name
                                    .add(record.colorName.toString());
                                constanst.selectcolor_id
                                    .add(record.colorId.toString());

                                constanst.select_color_name =
                                    constanst.selectcolor_name.join(",");
                                constanst.select_color_id =
                                    constanst.selectcolor_id.join(",");

                                print(constanst.select_color_name);
                                /*constanst.select_color_id =
                                            record.colorId.toString();
                                        constanst.select_color_name =
                                            constanst.select_color_name +
                                                record.colorName.toString();*/
                                //  print(constanst.select_type_id);
                                setState(() {});
                                // print(constanst.colorsitemsCheck[index]==Icons.check_circle);
                              } else {
                                constanst.colorsitemsCheck[index] =
                                    Icons.circle_outlined;
                                constanst.selectcolor_id
                                    .remove(record.colorId.toString());
                                constanst.selectcolor_name
                                    .remove(record.colorName.toString());
                                constanst.select_color_name =
                                    constanst.selectcolor_name.join(",");
                                constanst.select_color_id =
                                    constanst.selectcolor_id.join(",");
                                print(constanst.select_color_name);
                                print(constanst.select_color_name);
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
                                  icon: constanst.selectcolor_id
                                          .contains(record.colorId.toString())
                                      ? Icon(Icons.check_circle,
                                          color: Colors.green.shade600)
                                      : Icon(Icons.circle_outlined,
                                          color: Colors.black45),
                                  /*icon: constanst.selectcolor_id == index
                                      ? Icon(Icons.check_circle,
                                          color: Colors.green.shade600)
                                      : Icon(Icons.circle_outlined,
                                          color: Colors.black45),*/
                                  onPressed: () {
                                    setState(() {
                                      constanst.select_prodcolor_idx = index;
                                      gender = true;
                                      constanst.select_prodcolor_idx = index;
                                      if (!constanst.selectcolor_id
                                          .contains(record.colorId.toString())) {
                                        constanst.colorsitemsCheck[index] =
                                            Icons.check_circle_outline;

                                        constanst.selectcolor_name
                                            .add(record.colorName.toString());
                                        constanst.selectcolor_id
                                            .add(record.colorId.toString());

                                        constanst.select_color_name =
                                            constanst.selectcolor_name.join(",");
                                        constanst.select_color_id =
                                            constanst.selectcolor_id.join(",");

                                        print(constanst.select_color_name);
                                        /*constanst.select_color_id =
                                            record.colorId.toString();
                                        constanst.select_color_name =
                                            constanst.select_color_name +
                                                record.colorName.toString();*/
                                        //  print(constanst.select_type_id);
                                        setState(() {});
                                        // print(constanst.colorsitemsCheck[index]==Icons.check_circle);
                                      } else {
                                        constanst.colorsitemsCheck[index] =
                                            Icons.circle_outlined;
                                        constanst.selectcolor_id
                                            .remove(record.colorId.toString());
                                        constanst.selectcolor_name
                                            .remove(record.colorName.toString());
                                        constanst.select_color_name =
                                            constanst.selectcolor_name.join(",");
                                        constanst.select_color_id =
                                            constanst.selectcolor_id.join(",");
                                        print(constanst.select_color_name);
                                        print(constanst.select_color_name);
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
                  if (constanst.selectcolor_id.isEmpty) {
                    Navigator.pop(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => CategoryScreen()));
                  } else {
                    Fluttertoast.showToast(msg: 'Select Minimum 1  Colour');
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
  selectcategory({Key? key}) : super(key: key);

  @override
  State<selectcategory> createState() => _selectcategoryState();
}

class _selectcategoryState extends State<selectcategory> {
  int? _radioValue = 0;
  int? _selectindex;
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
                  if (constanst.select_cat_idx.toString().isNotEmpty) {
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
  int? _radioValue = 0;
  int? _selectindex;
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
                              //  print(_selectindex);
                              if (constanst.select_type_idx == index) {
                                constanst.Type_itemsCheck[index] =
                                    Icons.check_circle_outline;

                                constanst.select_type_id =
                                    record.producttypeId.toString();
                                constanst.select_type_name =
                                    record.productType.toString();

                                setState(() {});
                              } else {
                                constanst.Type_itemsCheck[index] =
                                    Icons.circle_outlined;
                                setState(() {

                                });
                              }
                            });
                          },
                          child: ListTile(
                              title: Text(record.productType.toString(),
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontFamily:
                                          'assets\fonst\Metropolis-Black.otf')),
                              leading: IconButton(
                                  icon: constanst.select_type_idx == index
                                      ? Icon(Icons.check_circle,
                                          color: Colors.green.shade600)
                                      : Icon(Icons.circle_outlined,
                                          color: Colors.black45),
                                  onPressed: () {
                                    setState(() {
                                      constanst.select_type_idx = index;
                                      gender = true;
                                      //  print(_selectindex);
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
                                        setState(() {
                                        });
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
                  if (constanst.select_type_idx.toString().isNotEmpty) {
                    Navigator.pop(context, constanst.Product_color);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => CategoryScreen()));
                  } else {
                    Fluttertoast.showToast(msg: 'Select Minimum 1 Type ');
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

class selectGrade extends StatefulWidget {
  const selectGrade({Key? key}) : super(key: key);

  @override
  State<selectGrade> createState() => _selectGradeState();
}

class _selectGradeState extends State<selectGrade> {
  int? _radioValue = 0;
  int? _managerValue = 0;
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
              child: Text('Select Product Grade',
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
                    itemCount: constanst.cat_grade_data.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      grade.Result record = constanst.cat_grade_data[index];

                      if (constanst.cat_grade_data.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              constanst.select_grade_idx = index;
                              gender = true;
                              //  print(_selectindex);
                              //if (constanst.select_grade_idx == index) {
                              // print(constanst.Grade_itemsCheck[index]);
                              /* if (constanst.Grade_itemsCheck[index] ==
                                        Icons.circle_outlined) {*/
                              if (!constanst.select_gradeId.contains(
                                  record.productgradeId.toString())) {
                                if (constanst.select_gradeId.length <=
                                    2) {
                                  constanst.Grade_itemsCheck[index] =
                                      Icons.check_circle_outline;

                                  constanst.select_gradeId.add(
                                      record.productgradeId.toString());

                                  constanst.select_grade_name.add(
                                      record.productGrade.toString());
                                  print(constanst.select_gradeId);
                                  print(constanst.select_grade_name);

                                  print(!constanst.select_gradeId
                                      .contains(record.productgradeId
                                      .toString()));
                                  setState(() {});
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                      'You Can Select Maximum 3 Grade');
                                }
                              } else {
                                constanst.category_itemsCheck[index] =
                                    Icons.circle_outlined;
                                constanst.select_gradeId.remove(
                                    record.productgradeId.toString());

                                constanst.select_grade_name.remove(
                                    record.productGrade.toString());
                                print(constanst.select_gradeId);
                                print(constanst.select_grade_name);
                              }
                            });
                          },
                          child: ListTile(
                              title: Text(record.productGrade.toString(),
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontFamily:
                                          'assets\fonst\Metropolis-Black.otf')),
                              leading: IconButton(
                                  icon: constanst.select_gradeId.contains(
                                          record.productgradeId.toString())
                                      ? Icon(Icons.check_circle,
                                          color: Colors.green.shade600)
                                      : Icon(Icons.circle_outlined,
                                          color: Colors.black45),
                                  onPressed: () {
                                    setState(() {
                                      constanst.select_grade_idx = index;
                                      gender = true;
                                      //  print(_selectindex);
                                      //if (constanst.select_grade_idx == index) {
                                      // print(constanst.Grade_itemsCheck[index]);
                                      /* if (constanst.Grade_itemsCheck[index] ==
                                          Icons.circle_outlined) {*/
                                      if (!constanst.select_gradeId.contains(
                                          record.productgradeId.toString())) {
                                        if (constanst.select_gradeId.length <=
                                            2) {
                                          constanst.Grade_itemsCheck[index] =
                                              Icons.check_circle_outline;

                                          constanst.select_gradeId.add(
                                              record.productgradeId.toString());

                                          constanst.select_grade_name.add(
                                              record.productGrade.toString());
                                          print(constanst.select_gradeId);
                                          print(constanst.select_grade_name);

                                          print(!constanst.select_gradeId
                                              .contains(record.productgradeId
                                                  .toString()));
                                          setState(() {});
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  'You Can Select Maximum 3 Grade');
                                        }
                                      } else {
                                        constanst.Grade_itemsCheck[index] =
                                            Icons.circle_outlined;
                                        constanst.select_gradeId.remove(
                                            record.productgradeId.toString());

                                        constanst.select_grade_name.remove(
                                            record.productGrade.toString());
                                        print(constanst.select_gradeId);
                                        print(constanst.select_grade_name);
                                        setState(() {});
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
                  if (constanst.select_gradeId.isEmpty) {

                    Fluttertoast.showToast(msg: 'Select Minimum 1 Grade ');
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => CategoryScreen()));
                  } else {
                    Navigator.pop(context, constanst.Product_color);

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
