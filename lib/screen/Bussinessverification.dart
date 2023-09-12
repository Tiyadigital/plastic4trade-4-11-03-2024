import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:Plastic4trade/model/Getmybusinessprofile.dart';
import 'package:Plastic4trade/model/Getmybusinessprofile.dart' as profile;
import 'package:Plastic4trade/model/getannualcapacity.dart';
import 'dart:ui';
import 'package:Plastic4trade/model/getannualcapacity.dart' as cat;
import 'package:Plastic4trade/model/getannualturnovermaster.dart' as cat1;
import 'package:Plastic4trade/model/Getbusiness_document_types.dart'
    as doc_type;
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_interface.dart';
import '../model/Getbusiness_document_types.dart';
import '../model/common.dart';
import '../model/getannualcapacity.dart';
import '../model/getannualturnovermaster.dart';
import 'Bussinessinfo.dart';
import '../utill/constant.dart';

class Bussinessverification extends StatefulWidget {
  const Bussinessverification({Key? key}) : super(key: key);

  @override
  State<Bussinessverification> createState() => _BussinessverificationState();
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(this.isSelected, this.buttonText);
}

class _BussinessverificationState extends State<Bussinessverification> {
  var _formKey = GlobalKey<FormState>();
  List<RadioModel> sampleData1 = <RadioModel>[];
  TextEditingController _usergst = TextEditingController();
  TextEditingController _pannumber = TextEditingController();
  TextEditingController _exno = TextEditingController();
  TextEditingController _useresiger = TextEditingController();
  TextEditingController _prd_cap = TextEditingController();
  TextEditingController _doctype = TextEditingController();
  Color _color1 = Colors.black45;
  Color _color2 = Colors.black45;
  Color _color3 = Colors.black45;
  Color _color4 = Colors.black45;
  Color _color5 = Colors.black45;

  List<Doc> get_doctype = [];
  DateTime dateTime = DateTime.now();
  String? _select_prod_cap, _select_premises, _doc_type, _selectitem3;
  String? firstyear_currency, secondyear_currency, thirdyear_currency;
  String? firstyear_amount, secondyear_amount, thirdyear_amount;

  Getmybusinessprofile getprofile = new Getmybusinessprofile();

  List<cat1.Annual> production_turn = [];

  List<profile.Doc> resultList = [];

  List listitem2 = ['Rent', 'Own'];

  bool? isload;

  List listrupes = ['₹', '\$', '€', '£', '¥'];

  File? _selectedFile;
  BuildContext? dialogContext;
  bool _isloading1 = false;

  @override
  void initState() {
    // TODO: implement initState
    sampleData1.add(new RadioModel(false, 'Rent'));
    sampleData1.add(new RadioModel(
      false,
      'Own',
    ));
    checknetowork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return initwidget();
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

  Widget initwidget() {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xFFDADADA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text('Business Verification',
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
        body: isload == true
            ? SingleChildScrollView(
                child: Column(
                children: [
                  Container(
                      //height: 400,

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
                                          controller: _usergst,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf'),
                                          keyboardType: TextInputType.text,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r"[a-zA-Z]+|\d"),
                                            ),
                                          ],
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            // labelText: 'Your phone *',
                                            // labelStyle: TextStyle(color: Colors.red),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'GST/VAT/TAX Number',
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
                                                    width: 1, color: _color1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, color: _color1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, color: _color1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                          ),
                                          /* validator: (value) {
                                            if (value!.isEmpty) {
                                              _color1 = Colors.red;
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Your GST/VAT/TAX  Number');
                                            } else {
                                              // setState(() {
                                              _color2 = Colors.green.shade600;
                                              //});
                                            }

                                            return null;
                                          },*/
                                          onFieldSubmitted: (value) {
                                            var numValue = value.length;
                                            if (numValue == 15) {
                                              _color1 = Colors.green.shade600;
                                            } else {
                                              _color1 = Colors.red;
                                              WidgetsBinding.instance
                                                  ?.focusManager.primaryFocus
                                                  ?.unfocus();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Enter  a GST/VAT/TAX Number');
                                            }
                                          },
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              WidgetsBinding.instance
                                                  ?.focusManager.primaryFocus
                                                  ?.unfocus();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Your GST/VAT/TAX  Number');
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
                                            25.0, 0.0, 25.0, 5.0),
                                        child: TextFormField(
                                          controller: _useresiger,
                                          readOnly: true,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf'),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r"[a-zA-Z]+|\d"),
                                            ),
                                          ],
                                          decoration: InputDecoration(
                                            // labelText: 'Your Name*',
                                            // labelStyle: TextStyle(color: Colors.red),
                                            suffixIcon: Icon(
                                                Icons.calendar_month,
                                                color: Color.fromARGB(
                                                    255, 0, 91, 148)),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Registration Date',
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
                                                    width: 1, color: _color2),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, color: _color2),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, color: _color2),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                          ),
                                          onTap: () async {
                                            final date = await showDatePicker(
                                                context: context,
                                                firstDate: DateTime(1960),
                                                initialDate: DateTime.now(),
                                                lastDate: DateTime(2100));
                                            if (date != null) {
                                              setState(() {
                                                _useresiger.text = DateFormat()
                                                    .add_yMMMd()
                                                    .format(date);
                                              });
                                            }
                                          },
                                          /* validator: (value) {
                                            if (value!.isEmpty) {
                                              _color2 = Colors.red;
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Enter a Registration Date');
                                            } else {
                                              // setState(() {
                                              _color2 = Colors.green.shade600;
                                              // });
                                            }
                                            return null;
                                          },*/
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 5.0),
                                        child: TextFormField(
                                          controller: _pannumber,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf'),
                                          keyboardType: TextInputType.text,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          textInputAction: TextInputAction.next,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r"[a-zA-Z]+|\d"),
                                            ),
                                          ],
                                          decoration: InputDecoration(
                                            // labelText: 'Your phone *',
                                            // labelStyle: TextStyle(color: Colors.red),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Pan Number',
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
                                                    width: 1, color: _color3),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, color: _color3),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, color: _color3),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                          ),
                                          /* validator: (value) {
                                            if (value!.isEmpty) {
                                              _color3 = Colors.red;
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Enter Pan Number');
                                            } else {
                                              // setState(() {
                                              _color3 = Colors.green.shade600;
                                              //});
                                            }

                                            return null;
                                          },*/
                                          onFieldSubmitted: (value) {
                                            var numValue = value.length;
                                            if (numValue == 10) {
                                              _color3 = Colors.green.shade600;
                                            } else {
                                              _color3 = Colors.red;
                                              WidgetsBinding.instance
                                                  ?.focusManager.primaryFocus
                                                  ?.unfocus();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Enter Pan Number');
                                            }
                                          },
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              WidgetsBinding.instance
                                                  ?.focusManager.primaryFocus
                                                  ?.unfocus();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Your Pan Number');
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
                                        padding: EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 10.0),
                                        child: TextFormField(
                                          controller: _exno,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf'),
                                          keyboardType: TextInputType.text,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          textInputAction: TextInputAction.next,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r"[a-zA-Z]+|\d"),
                                            ),
                                          ],
                                          decoration: InputDecoration(
                                            // labelText: 'Your phone *',
                                            // labelStyle: TextStyle(color: Colors.red),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Export Import Number',
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
                                                    width: 1, color: _color4),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, color: _color4),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, color: _color4),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                          ),
                                          /* validator: (value) {
                                            if (value!.isEmpty) {
                                              _color4 = Colors.red;
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Enter a Export Import Number');
                                            } else {
                                              // setState(() {
                                              _color4 = Colors.green.shade600;
                                              //});
                                            }

                                            return null;
                                          },*/
                                          onFieldSubmitted: (value) {
                                            var numValue = value.length;
                                            if (numValue == 10) {
                                              _color4 = Colors.green.shade600;
                                            } else {
                                              _color4 = Colors.red;
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Enter a Export Import Number');
                                            }
                                          },
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              WidgetsBinding.instance
                                                  ?.focusManager.primaryFocus
                                                  ?.unfocus();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Your Export Import Number');
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
                                            25.0, 5.0, 25.0, 5.0),
                                        child: TextFormField(
                                          controller: _prd_cap,
                                          keyboardType: TextInputType.text,
                                          readOnly: true,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf'),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Production Capacity ",
                                            suffixIcon: Icon(
                                                Icons.arrow_drop_down_sharp),
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
                                                    width: 1, color: _color2),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, color: _color2),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, color: _color2),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            //errorText: _validusernm ? 'Name is not empty' : null),
                                          ),
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
                                              ViewItem1(context);
                                            }
                                          },
                                        ),
                                      ),
                                      /* prd_cap_dropdown(production_cap,
                                          'Production Capacity'),*/
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 2.0),
                                        child: Row(
                                          children: [
                                            Text('Annual Turnover',
                                                style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'assets\fonst\Metropolis-Black.otf')
                                                    ?.copyWith(fontSize: 15)),
                                            Image.asset(
                                              'assets/Line.png',
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.8,
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 10.0),
                                        child: Row(
                                          children: [
                                            Center(
                                              child: Text('2020 - 2021',
                                                  style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'assets\fonst\Metropolis-Black.otf')
                                                      ?.copyWith(fontSize: 15)),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 16.0,
                                                        right: 16.0,
                                                        top: 5.0),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.3,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        color: Colors.white),
                                                    child: Column(
                                                      children: [
                                                        /*Visibility(
                                                          child: Align(
                                                            child: Text(
                                                                'Currency',
                                                                style: TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'assets\fonst\Metropolis-Black.otf')
                                                                    ?.copyWith(
                                                                        color: Colors
                                                                            .grey)),
                                                            alignment: Alignment
                                                                .topLeft,
                                                          ),
                                                          visible:
                                                              firstyear_currency !=
                                                                      null
                                                                  ? true
                                                                  : false,
                                                        ),
                                                        Visibility(
                                                          child: Align(
                                                            child: Text(
                                                                'Currency',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    12.0,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                    'assets\fonst\Metropolis-Black.otf')
                                                                    ?.copyWith(
                                                                    color: Colors
                                                                        .grey)),
                                                            alignment: Alignment
                                                                .topLeft,
                                                          ),
                                                          visible:
                                                          firstyear_currency !=
                                                              null
                                                              ? true
                                                              : false,
                                                        ),*/
                                                        DropdownButton(
                                                          value:
                                                              firstyear_currency,
                                                          hint: Text('Currency',
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
                                                                          .black45)),
                                                          dropdownColor:
                                                              Colors.white,
                                                          icon: Icon(Icons
                                                              .arrow_drop_down),
                                                          iconSize: 15,
                                                          isExpanded: true,
                                                          underline: SizedBox(),
                                                          items: listrupes
                                                              .map((valueItem) {
                                                            return DropdownMenuItem(
                                                                value:
                                                                    valueItem,
                                                                child: Text(
                                                                    valueItem,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'assets\fonst\Metropolis-Black.otf')));
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              firstyear_currency =
                                                                  null;

                                                              firstyear_currency =
                                                                  value
                                                                      .toString();
                                                              print(
                                                                  firstyear_currency);
                                                            });
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 16.0,
                                                        right: 16.0,
                                                        top: 5.0),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.3,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        color: Colors.white),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        /* Visibility(
                                                          child: Align(
                                                            child: Text(
                                                                'Amount',
                                                                style: TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'assets\fonst\Metropolis-Black.otf')
                                                                    ?.copyWith(
                                                                        color: Colors
                                                                            .grey)),
                                                            alignment: Alignment
                                                                .topLeft,
                                                          ),
                                                          visible:
                                                              firstyear_amount !=
                                                                      null
                                                                  ? true
                                                                  : false,
                                                        ),*/
                                                        DropdownButtonFormField<
                                                            int>(
                                                          hint: firstyear_amount != null
                                                              ? Text(
                                                                  firstyear_amount
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                          fontSize:
                                                                              15.0,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color: Colors
                                                                              .black,
                                                                          fontFamily:
                                                                              'assets\fonst\Metropolis-Black.otf')
                                                                      ?.copyWith(
                                                                          color: Colors
                                                                              .black))
                                                              : Text('Amount',
                                                                  style: TextStyle(
                                                                          fontSize: 15.0,
                                                                          fontWeight: FontWeight.w400,
                                                                          color: Colors.black,
                                                                          fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                                      ?.copyWith(color: Colors.black45)),
                                                          dropdownColor:
                                                              Colors.white,
                                                          icon: Icon(Icons
                                                              .arrow_drop_down),
                                                          iconSize: 15,
                                                          isExpanded: true,
                                                          items: production_turn
                                                              .map((cat1.Annual
                                                                  annual) {
                                                            return DropdownMenuItem<
                                                                int>(
                                                              value: annual.id,
                                                              child: Text(
                                                                  annual.name ??
                                                                      '',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'assets\fonst\Metropolis-Black.otf')),
                                                            );
                                                          }).toList(),
                                                          onChanged: (int?
                                                              selectedId) {
                                                            // Handle the selected id
                                                            if (selectedId !=
                                                                null) {
                                                              // Find the corresponding Annual object
                                                              cat1.Annual?
                                                                  selectedAnnual =
                                                                  production_turn.firstWhere(
                                                                      (annual) =>
                                                                          annual
                                                                              .id ==
                                                                          selectedId);
                                                              if (selectedAnnual !=
                                                                  null) {
                                                                // Handle the selected Annual object
                                                                setState(() {
                                                                  firstyear_amount =
                                                                      selectedAnnual
                                                                          .id
                                                                          .toString();
                                                                  print(
                                                                      'Selected Annual ID: ${selectedAnnual.id}');
                                                                  print(
                                                                      'Selected Annual Name: ${selectedAnnual.name}');
                                                                });
                                                              }
                                                            }
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 10.0),
                                        child: Row(
                                          children: [
                                            Center(
                                              child: Text('2021 - 2022',
                                                  style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'assets\fonst\Metropolis-Black.otf')
                                                      ?.copyWith(fontSize: 15)),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 16.0,
                                                        right: 16.0,
                                                        top: 5.0),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.3,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        color: Colors.white),
                                                    child: Column(
                                                      children: [
                                                        /*Visibility(
                                                          child: Align(
                                                            child: Text(
                                                                'Currency',
                                                                style: TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'assets\fonst\Metropolis-Black.otf')
                                                                    ?.copyWith(
                                                                        color: Colors
                                                                            .grey)),
                                                            alignment: Alignment
                                                                .topLeft,
                                                          ),
                                                          visible:
                                                              secondyear_currency !=
                                                                      null
                                                                  ? true
                                                                  : false,
                                                        ),*/
                                                        DropdownButton(
                                                          value:
                                                              secondyear_currency,
                                                          hint: Text('Currency',
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
                                                                          .black45)),
                                                          dropdownColor:
                                                              Colors.white,
                                                          icon: Icon(Icons
                                                              .arrow_drop_down),
                                                          iconSize: 15,
                                                          isExpanded: true,
                                                          underline: SizedBox(),
                                                          items: listrupes
                                                              .map((valueItem) {
                                                            return DropdownMenuItem(
                                                                value:
                                                                    valueItem,
                                                                child: Text(
                                                                    valueItem,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'assets\fonst\Metropolis-Black.otf')));
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              secondyear_currency =
                                                                  null;
                                                              secondyear_currency =
                                                                  value
                                                                      .toString();
                                                            });
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 16.0,
                                                        right: 16.0,
                                                        top: 5.0),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.3,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        color: Colors.white),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        /*Visibility(
                                                          child: Align(
                                                            child: Text(
                                                                'Amount',
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
                                                                            .black45)),
                                                            alignment: Alignment
                                                                .topLeft,
                                                          ),
                                                          visible:
                                                              secondyear_amount !=
                                                                      null
                                                                  ? true
                                                                  : false,
                                                        ),*/
                                                        DropdownButtonFormField<
                                                            int>(
                                                          hint: secondyear_amount != null
                                                              ? Text(
                                                                  secondyear_amount
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                          fontSize:
                                                                              15.0,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color: Colors
                                                                              .black,
                                                                          fontFamily:
                                                                              'assets\fonst\Metropolis-Black.otf')
                                                                      ?.copyWith(
                                                                          color: Colors
                                                                              .black))
                                                              : Text('Amount',
                                                                  style: TextStyle(
                                                                          fontSize: 15.0,
                                                                          fontWeight: FontWeight.w400,
                                                                          color: Colors.black,
                                                                          fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                                      ?.copyWith(color: Colors.black45)),
                                                          dropdownColor:
                                                              Colors.white,
                                                          icon: Icon(Icons
                                                              .arrow_drop_down),
                                                          iconSize: 15,
                                                          isExpanded: true,
                                                          items: production_turn
                                                              .map((cat1.Annual
                                                                  annual) {
                                                            return DropdownMenuItem<
                                                                int>(
                                                              value: annual.id,
                                                              child: Text(
                                                                  annual.name ??
                                                                      '',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'assets\fonst\Metropolis-Black.otf')),
                                                            );
                                                          }).toList(),
                                                          onChanged: (int?
                                                              selectedId) {
                                                            // Handle the selected id
                                                            if (selectedId !=
                                                                null) {
                                                              // Find the corresponding Annual object
                                                              cat1.Annual?
                                                                  selectedAnnual =
                                                                  production_turn.firstWhere(
                                                                      (annual) =>
                                                                          annual
                                                                              .id ==
                                                                          selectedId);
                                                              if (selectedAnnual !=
                                                                  null) {
                                                                // Handle the selected Annual object
                                                                setState(() {
                                                                  secondyear_amount =
                                                                      selectedAnnual
                                                                          .id
                                                                          .toString();
                                                                  print(
                                                                      'Selected Annual ID: ${selectedAnnual.id}');
                                                                  print(
                                                                      'Selected Annual Name: ${selectedAnnual.name}');
                                                                });
                                                              }
                                                            }
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 10.0),
                                        child: Row(
                                          children: [
                                            Center(
                                              child: Text('2022 - 2023',
                                                  style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'assets\fonst\Metropolis-Black.otf')
                                                      ?.copyWith(fontSize: 15)),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 16.0,
                                                        right: 16.0,
                                                        top: 5.0),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.3,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        color: Colors.white),
                                                    child: Column(
                                                      children: [
                                                        /*Visibility(
                                                          child: Align(
                                                            child: Text(
                                                                'Currency',
                                                                style: TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'assets\fonst\Metropolis-Black.otf')
                                                                    ?.copyWith(
                                                                        color: Colors
                                                                            .grey)),
                                                            alignment: Alignment
                                                                .topLeft,
                                                          ),
                                                          visible:
                                                              thirdyear_currency !=
                                                                      null
                                                                  ? true
                                                                  : false,
                                                        ),*/
                                                        DropdownButton(
                                                          value:
                                                              thirdyear_currency,
                                                          hint: Text('Currency',
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
                                                                          .black45)),
                                                          dropdownColor:
                                                              Colors.white,
                                                          icon: Icon(Icons
                                                              .arrow_drop_down),
                                                          iconSize: 15,
                                                          isExpanded: true,
                                                          underline: SizedBox(),
                                                          items: listrupes
                                                              .map((valueItem) {
                                                            return DropdownMenuItem(
                                                                value:
                                                                    valueItem,
                                                                child: Text(
                                                                    valueItem,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'assets\fonst\Metropolis-Black.otf')));
                                                          }).toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              thirdyear_currency =
                                                                  null;
                                                              thirdyear_currency =
                                                                  value
                                                                      .toString();
                                                            });
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 16.0,
                                                        right: 16.0,
                                                        top: 5.0),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3.3,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        color: Colors.white),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        /*Visibility(
                                                          visible:
                                                              thirdyear_amount !=
                                                                      null
                                                                  ? true
                                                                  : false,
                                                          child: Align(
                                                            child: Text(
                                                                'Amount',
                                                                style: TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'assets\fonst\Metropolis-Black.otf')
                                                                    ?.copyWith(
                                                                        color: Colors
                                                                            .grey)),
                                                            alignment: Alignment
                                                                .topLeft,
                                                          ),
                                                        ),*/
                                                        DropdownButtonFormField<
                                                            int>(
                                                          hint: thirdyear_amount != null
                                                              ? Text(
                                                                  thirdyear_amount
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                          fontSize:
                                                                              15.0,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          color: Colors
                                                                              .black,
                                                                          fontFamily:
                                                                              'assets\fonst\Metropolis-Black.otf')
                                                                      ?.copyWith(
                                                                          color: Colors
                                                                              .black))
                                                              : Text('Amount',
                                                                  style: TextStyle(
                                                                          fontSize: 15.0,
                                                                          fontWeight: FontWeight.w400,
                                                                          color: Colors.black,
                                                                          fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                                      ?.copyWith(color: Colors.black45)),
                                                          dropdownColor:
                                                              Colors.white,
                                                          icon: Icon(Icons
                                                              .arrow_drop_down),
                                                          iconSize: 15,
                                                          isExpanded: true,
                                                          items: production_turn
                                                              .map((cat1.Annual
                                                                  annual) {
                                                            return DropdownMenuItem<
                                                                int>(
                                                              value: annual.id,
                                                              child: Text(
                                                                  annual.name ??
                                                                      '',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'assets\fonst\Metropolis-Black.otf')),
                                                            );
                                                          }).toList(),
                                                          onChanged: (int?
                                                              selectedId) {
                                                            // Handle the selected id
                                                            if (selectedId !=
                                                                null) {
                                                              // Find the corresponding Annual object
                                                              cat1.Annual?
                                                                  selectedAnnual =
                                                                  production_turn.firstWhere(
                                                                      (annual) =>
                                                                          annual
                                                                              .id ==
                                                                          selectedId);
                                                              if (selectedAnnual !=
                                                                  null) {
                                                                // Handle the selected Annual object
                                                                setState(() {
                                                                  thirdyear_amount =
                                                                      selectedAnnual
                                                                          .id
                                                                          .toString();
                                                                  print(
                                                                      'Selected Annual ID: ${selectedAnnual.id}');
                                                                  print(
                                                                      'Selected Annual Name: ${selectedAnnual.name}');
                                                                });
                                                              }
                                                            }
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      //annul_turn_dropdown(production_turn, 'Annual Turnover'),
                                      /*prem_dropdown(
                                          listitem2, 'Premises: Rent or Own'),*/
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            25.0, 10.0, 25.0, 5.0),
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black45),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Column(children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Select Premise Type ',
                                              style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'assets\fonst\Metropolis-Black.otf')
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                                            child: sampleData1
                                                                        .first
                                                                        .isSelected ==
                                                                    true
                                                                ? Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    color: Colors
                                                                        .green
                                                                        .shade600)
                                                                : Icon(
                                                                    Icons
                                                                        .circle_outlined,
                                                                    color: Colors
                                                                        .black38),
                                                            onTap: () {
                                                              setState(() {
                                                                sampleData1
                                                                        .first
                                                                        .isSelected =
                                                                    true;
                                                                _select_premises =
                                                                    sampleData1
                                                                        .first
                                                                        .buttonText;
                                                                sampleData1.last
                                                                        .isSelected =
                                                                    false;
                                                                //category1 = true;
                                                              });
                                                            },
                                                          ),
                                                          Text(
                                                              sampleData1.first
                                                                  .buttonText,
                                                              style: TextStyle(
                                                                      fontSize:
                                                                          13.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'assets\fonst\Metropolis-Black.otf')
                                                                  ?.copyWith(
                                                                      fontSize:
                                                                          17))
                                                        ],
                                                      ),
                                                    ])),
                                                onTap: () {
                                                  setState(() {
                                                    sampleData1.first
                                                        .isSelected = true;
                                                    _select_premises =
                                                        sampleData1
                                                            .first.buttonText;
                                                    sampleData1.last
                                                        .isSelected = false;
                                                    //category1 = true;
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
                                                          child: sampleData1
                                                                      .last
                                                                      .isSelected ==
                                                                  true
                                                              ? Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  color: Colors
                                                                      .green
                                                                      .shade600)
                                                              : Icon(
                                                                  Icons
                                                                      .circle_outlined,
                                                                  color: Colors
                                                                      .black38),
                                                          onTap: () {
                                                            setState(() {
                                                              sampleData1.last
                                                                      .isSelected =
                                                                  true;
                                                              sampleData1.first
                                                                      .isSelected =
                                                                  false;
                                                              //category1 = true;
                                                              _select_premises =
                                                                  sampleData1
                                                                      .last
                                                                      .buttonText;
                                                              //Fluttertoast.showToast(msg: 'hell $sampleData.last.isSelected');
                                                            });
                                                          },
                                                        ),
                                                        Text(
                                                            sampleData1
                                                                .last.buttonText,
                                                            style: TextStyle(
                                                                    fontSize:
                                                                        13.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'assets\fonst\Metropolis-Black.otf')
                                                                ?.copyWith(
                                                                    fontSize:
                                                                        17))
                                                      ],
                                                    )),
                                                onTap: () {
                                                  setState(() {
                                                    sampleData1
                                                        .last.isSelected = true;
                                                    sampleData1.first
                                                        .isSelected = false;
                                                    //category1 = true;
                                                    _select_premises =
                                                        sampleData1
                                                            .last.buttonText;
                                                    //Fluttertoast.showToast(msg: 'hell $sampleData.last.isSelected');
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ]),
                                      ),
                                      Align(
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              30.0, 5.0, 0.0, 2.0),
                                          child: Text(
                                            'Upload Document',
                                            style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf')
                                                ?.copyWith(
                                                    color: Colors.black45),
                                          ),
                                        ),
                                        alignment: Alignment.topLeft,
                                      ),
                                      //doc_type_dropdown('Select Document Type'),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            25.0, 0.0, 25.0, 15.0),
                                        child: TextFormField(
                                          controller: _doctype,
                                          keyboardType: TextInputType.text,
                                          readOnly: true,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf'),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Document Type",
                                            suffixIcon: Icon(
                                                Icons.arrow_drop_down_sharp),
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
                                                    width: 1, color: _color5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, color: _color5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1, color: _color5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            //errorText: _validusernm ? 'Name is not empty' : null),
                                          ),
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
                                              ViewItem2(context);
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              25.0, 0.0, 25.0, 10.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (_doctype.text.isEmpty) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Please Select Document Type ');
                                              } else {
                                                _pickFile();
                                              }

                                              /*showDialog(
                                        barrierColor: Colors.black26,
                                        context: context,
                                        builder: (context) {

                                          //isimage=false;

                                          return bottomsheet();
                                        },
                                      );*/
                                            },
                                            child: Image.asset(
                                                'assets/add_document.png'),
                                          )),

                                      document_display(),

                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1.2,
                                        height: 60,
                                        margin: EdgeInsets.all(20.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            color: Color.fromARGB(
                                                255, 0, 91, 148)),
                                        child: TextButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              /*Fluttertoast.showToast(
                                                  msg: "Data Proccess");*/
                                              vaild_data();
                                            }
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
                              ])))
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
                        : Container()));
  }

  Widget document_display() {
    return Container(
        //height: 200,

        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0),
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
            //future: load_category(),
            builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            //List<dynamic> users = snapshot.data as List<dynamic>;
            return ListView.builder(
              //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // crossAxisCount: 2,
              // mainAxisSpacing: 5,
              // crossAxisSpacing: 5,
              // childAspectRatio: .90,

              /*  childAspectRatio:MediaQuery.of(context).size.height/330,
                mainAxisSpacing: 4.0,
                crossAxisCount: 1,
              ),*/
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: resultList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                //Doc? record =get .result![index];
                //Doc? color = record?.postColor?[index];

                // String colorString=resultList![index].postColor![colorIndex].haxCode.toString();
                String colorString =
                    resultList![index].doctype!.name.toString();

                //String fileExtension = p.extension(get_doctype[index].documentUrl.toString());

                return GestureDetector(
                    onTap: (() {}),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        child: Column(children: [
                          Container(
                            // margin: EdgeInsets.all(10.0),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.file_copy,
                                      color: Color.fromARGB(255, 0, 91, 148),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        //height: 50,
                                        margin: const EdgeInsets.fromLTRB(
                                            10.0, 2.0, 0.0, 0),
                                        child: Center(
                                          child: Text(
                                              get_doctype[index]
                                                  .docType
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf',
                                                fontSize: 13,
                                                color: Colors.black),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    String remove =
                                        get_doctype[index].id.toString();
                                    get_doctype.removeAt(index);
                                    print(remove);
                                    remove_document(remove);
                                  },
                                  child: Align(
                                    child: Image.asset(
                                      'assets/delete2.png',
                                      width: 30,
                                      height: 30,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          )
                        ]),
                      ),
                    ));
              },
            );
          }

          return CircularProgressIndicator();
        }));
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
                0.60, // Initial height as a fraction of screen height
            builder: (BuildContext context, ScrollController scrollController) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return type();
                },
              );
            })).then(
      (value) {
        if (constanst.select_prodcap_idx != "") {
          _prd_cap.text = constanst.Product_Capcity_name;
          setState(() {
            _color2 = Colors.green.shade600;
          });
        }
      },
    );
  }

  ViewItem2(BuildContext context) {
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
                0.60, // Initial height as a fraction of screen height
            builder: (BuildContext context, ScrollController scrollController) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return document_type();
                },
              );
            })).then(
      (value) {
        if (constanst.select_document_type_idx != "") {
          _doctype.text = constanst.Document_type_name;
          setState(() {
            _color5 = Colors.green.shade600;
          });
        }
      },
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      if (await file.length() > 1024 * 1024) {
        // Compress the file if it exceeds 1 MB
        file = (await compressFile(file)) as File;
      }
      setState(() {
        _selectedFile = file;
        print('select file $_selectedFile');
      });
    }
  }

  Future<XFile?> compressFile(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final newPath = filePath.substring(0, lastIndex) + '.compressed.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      newPath,
      quality: 70,
    );

    return result;
  }

  /*vaild_data() {
    _isValid = EmailValidator.validate(_useremail.text);

    if (_userpass.text != _usercpass.text) {
      Fluttertoast.showToast(msg: "Password and Conform password not same");
    } else if (!check_value) {
      Fluttertoast.showToast(msg: "Please Select Terms and Condition ");
    } else if (_usernm.text.isNotEmpty &&
        _useremail.text.isNotEmpty &&
        _usermbl.text.isNotEmpty &&
        _userpass.text.isNotEmpty &&
        _usercpass.text.isNotEmpty &&
        _isValid &&
        check_value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Register2()));
      //_registerApi();
    }
  }*/
  Widget prd_cap_dropdown(List listitem, String hint) {
    return Center(
        child: Padding(
            padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
            child: Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white),
              child: DropdownButtonFormField<int>(
                hint: _select_prod_cap != null
                    ? Text(_select_prod_cap.toString(),
                        style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily: 'assets\fonst\Metropolis-Black.otf')
                            ?.copyWith(color: Colors.black45))
                    : Text(hint,
                        style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily: 'assets\fonst\Metropolis-Black.otf')
                            ?.copyWith(color: Colors.black45)),
                dropdownColor: Colors.white,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 30,
                isExpanded: true,
                items: constanst.production_cap.map((cat.Annual annual) {
                  return DropdownMenuItem<int>(
                    value: annual.id,
                    child: Text(annual.name ?? '',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                  );
                }).toList(),
                onChanged: (int? selectedId) {
                  // Handle the selected id
                  if (selectedId != null) {
                    // Find the corresponding Annual object
                    cat.Annual? selectedAnnual = constanst.production_cap
                        .firstWhere((annual) => annual.id == selectedId);
                    if (selectedAnnual != null) {
                      // Handle the selected Annual object
                      _select_prod_cap = selectedAnnual.id.toString();
                      print('Selected Annual ID: ${selectedAnnual.id}');
                      print('Selected Annual Name: ${selectedAnnual.name}');
                    }
                  }
                },
                decoration: InputDecoration(border: InputBorder.none),
              ),
            )));
  }

  Future<bool> update_BusinessVerification() async {
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(_pref.getString('user_id').toString());
    print(_pref.getString('api_token').toString());

    /* String userId,String userToken, String registration_date, String  pan_number,
    String export_import_number,String annual_turnover,String premises,String gst_tax_vat,String currency_20_21,String amount_20_21,String currency_21_22,
    String amount_21_22,String currency_22_23,String amount_22_23,
    String doc_type,String production_capacity,
    File? file*/
    print(_doc_type);
    var res = await updateBusinessVerification(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        _useresiger.text,
        _pannumber.text,
        _exno.text,
        _select_premises.toString(),
        _usergst.text,
        firstyear_currency.toString(),
        firstyear_amount.toString(),
        secondyear_currency.toString(),
        secondyear_amount.toString(),
        thirdyear_currency.toString(),
        thirdyear_amount.toString(),
        constanst.select_document_type_id.toString(),
        _select_prod_cap.toString(),
        _selectedFile);
    /* 'userId':userId,'userToken':userToken,'business_name':business_name,'business_type':business_type,'location':location,'longitude':longitude,'longitude':latitude,'other_mobile1':other_mobile1,'country':country,
    'countryCode':countryCode,
    'business_phone':business_phone,'business_type':business_type,'city':city,'email':email,'website':website,'about_business':about_business,
    'profilePicture':file,'gst_tax_vat':gst_tax_vat,'state':state*/

    print('after register');
    print(res);
    if (res['status'] == 1) {
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
      _isloading1 = true;
      /*  Navigator.push(
          context, MaterialPageRoute(builder: (context) => Bussinessinfo()));*/
    } else {
      _isloading1 = true;
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
    }
    return _isloading1;
  }

  Widget prem_dropdown(List listitem, String hint) {
    return Center(
        child: Padding(
      padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
      child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white),
          child: DropdownButton(
            value: _select_premises,
            hint: Text(hint,
                style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'assets\fonst\Metropolis-Black.otf')
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
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: 'assets\fonst\Metropolis-Black.otf')));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _select_premises = value.toString();
              });
            },
          )),
    ));
  }

  Widget doc_type_dropdown(String hint) {
    return Center(
        child: Padding(
      padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
      child: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white),
        /*child: DropdownButton(
            value: _selectitem3,
            hint: Text(hint,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.black45)),
            dropdownColor: Colors.white,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 30,
            isExpanded: true,
            underline: SizedBox(),
            items: doc_typess
                .map<DropdownMenuItem<doc_type.Types>>((doc_type.Types server) {
              return DropdownMenuItem(
                value: server,
                child: Text(server.name.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
              );
              */ /* return DropdownMenuItem<cat.Annua>(
               value: server,
               child: Text(server.name, style: TextStyle(fontSize: 20)),
             );*/ /*
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectitem3 = value.toString();
              });
            },
          )*/
        child: DropdownButtonFormField<int>(
          hint: Text(hint,
              style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontFamily: 'assets\fonst\Metropolis-Black.otf')
                  ?.copyWith(color: Colors.black45)),
          dropdownColor: Colors.white,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 30,
          isExpanded: true,
          items: constanst.doc_typess.map((doc_type.Types annual) {
            return DropdownMenuItem<int>(
              value: annual.id,
              child: Text(annual.name ?? '',
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontFamily: 'assets\fonst\Metropolis-Black.otf')),
            );
          }).toList(),
          onChanged: (int? selectedId) {
            // Handle the selected id
            if (selectedId != null) {
              // Find the corresponding Annual object
              doc_type.Types? selectedAnnual = constanst.doc_typess
                  .firstWhere((annual) => annual.id == selectedId);
              if (selectedAnnual != null) {
                // Handle the selected Annual object
                _doc_type = selectedAnnual.id.toString();
                print('Selected Annual ID: ${selectedAnnual.id}');
                print('Selected Annual Name: ${selectedAnnual.name}');
              }
            }
          },
          decoration: InputDecoration(border: InputBorder.none),
        ),
      ),
    ));
  }

  vaild_data() {
    if (constanst.select_document_type_id.isNotEmpty) {
      if (_selectedFile == null) {
        Fluttertoast.showToast(msg: 'Please Add Document');
      } else {
        _onLoading();
        update_BusinessVerification().then((value) {
          print('12345$value');
          Navigator.of(dialogContext!).pop(); // loader
          if (value) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Bussinessinfo()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Bussinessinfo()));
          }
        });
      }
    } else {
      _onLoading();
      update_BusinessVerification().then((value) {
        print('12345$value');
        Navigator.of(dialogContext!).pop(); // loader
        if (value) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Bussinessinfo()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Bussinessinfo()));
        }
      });
    }
    /* if (_select_prod_cap.toString().isEmpty) {
      Fluttertoast.showToast(msg: 'Plz Select Production Capacity');
    } else if (firstyear_amount.toString().isEmpty) {
      Fluttertoast.showToast(msg: 'Plz Select First Year Annual Turnover ');
    } else if (secondyear_amount.toString().isEmpty) {
      Fluttertoast.showToast(msg: 'Plz Select Second Year Annual Turnover ');
    } else if (thirdyear_amount.toString().isEmpty) {
      Fluttertoast.showToast(msg: 'Plz Select Third Year Annual Turnover ');
    } else if (firstyear_currency.toString().isEmpty) {
      Fluttertoast.showToast(msg: 'Plz Select First Year Currency Turnover ');
    } else if (secondyear_currency.toString().isEmpty) {
      Fluttertoast.showToast(msg: 'Plz Select Second Year Currency Turnover ');
    } else if (thirdyear_currency.toString().isEmpty) {
      Fluttertoast.showToast(msg: 'Plz Select Third Year Currency Turnover ');
    } else if (_select_premises.toString().isEmpty) {
      Fluttertoast.showToast(msg: 'Plz Select Premises');
    } else if (_doc_type.toString().isEmpty) {
      Fluttertoast.showToast(msg: 'Plz Select  Document Type');
    } else {
      print('dffdfdf');
      update_BusinessVerification();
    }*/
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      getProfiless();
      getannua_lcapacity();
      getannua_turnover();
      getdoc_type();
      // get_data();
    }
  }

  getannua_lcapacity() async {
    getannualcapacity getcoloregory = getannualcapacity();

    var res = await getannual_capacity();
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getcoloregory = getannualcapacity.fromJson(res);

      jsonarray = res['annual'];

      print(jsonarray);
      for (var data in jsonarray) {
        cat.Annual record = cat.Annual(id: data['id'], name: data['name']);
        constanst.production_cap.add(record);
      }
      print(constanst.production_cap);

      setState(() {});
      for (int i = 0; i < constanst.production_cap.length; i++) {
        constanst.Prodcap_itemsCheck.add(Icons.circle_outlined);
      }
      isload = true;
    } else {
      isload = true;
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
  }

  getannua_turnover() async {
    getannualturnovermaster getcoloregory = getannualturnovermaster();

    var res = await getannual_turnover();
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getcoloregory = getannualturnovermaster.fromJson(res);
      jsonarray = res['annual'];
      print(jsonarray);
      for (var data in jsonarray) {
        cat1.Annual record = cat1.Annual(id: data['id'], name: data['name']);
        production_turn.add(record);
      }
      print(production_turn);
      setState(() {});
      isload = true;
    } else {
      isload = true;
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
  }

  getdoc_type() async {
    Getbusiness_document_types getcoloregory = Getbusiness_document_types();

    var res = await getbusiness_document_types();
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getcoloregory = Getbusiness_document_types.fromJson(res);
      jsonarray = res['types'];
      print(jsonarray);
      for (var data in jsonarray) {
        doc_type.Types record =
            doc_type.Types(id: data['id'], name: data['name']);
        constanst.doc_typess.add(record);
        isload = true;
      }
      print(constanst.doc_typess);
      for (int i = 0; i < constanst.doc_typess.length; i++) {
        constanst.Document_type_itemsCheck.add(Icons.circle_outlined);
      }
      setState(() {});
    } else {
      isload = true;
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
  }

  getProfiless() async {
    getprofile = Getmybusinessprofile();

    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getbussinessprofile(
      _pref.getString('user_id').toString(),
      _pref.getString('api_token').toString(),
    );

    getprofile = Getmybusinessprofile.fromJson(res);
    resultList = getprofile.doc!;

    print(res);
    if (res['status'] == 1) {
      _usergst.text = res['profile']['gst_tax_vat'] == null
          ? ''
          : res['profile']['gst_tax_vat'];
      _exno.text = res['profile']['export_import_number'] == null
          ? ''
          : res['profile']['export_import_number'];
      _useresiger.text = res['profile']['registration_date'] == null
          ? ''
          : res['profile']['registration_date'];
      _pannumber.text = res['profile']['pan_number'] == null
          ? ''
          : res['profile']['pan_number'];

      if (res['annual_turnover'] != null) {
        firstyear_currency = res['annual_turnover']['currency_20_21'];
        secondyear_currency = res['annual_turnover']['currency_21_22'];
        thirdyear_currency = res['annual_turnover']['currency_22_23'];

        if (res['annual_turnover']['amounts2021'] != null) {
          print('Annual TurnOver ');
          firstyear_amount = res['annual_turnover']['amounts2021'] == null
              ? null
              : res['annual_turnover']['amounts2021']['name'];
        }
        if (res['annual_turnover']['amounts2122'] != null) {
          secondyear_amount = res['annual_turnover']['amounts2122'] == null
              ? null
              : res['annual_turnover']['amounts2122']['name'];
        }
        if (res['annual_turnover']['amounts2223'] != null) {
          thirdyear_amount = res['annual_turnover']['amounts2223'] == null
              ? null
              : res['annual_turnover']['amounts2223']['name'];
        }
      }
      _select_prod_cap = res['profile']['annualcapacity'] != null
          ? res['profile']['annualcapacity']['name']
          : "Production Capacity";

      // _select_premises = res['profile']['premises'];

      if (res['doc'] != null && res['doc'] != []) {
        var jsonarray = res['doc'];

        for (var data in jsonarray) {
          Doc record = Doc(
            id: data['id'],
              docType: data['doctype']['name'].toString()
          );
          get_doctype.add(record);
        }
        print('Doc Type $get_doctype');
      }
      isload = true;

      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(0)));*/
    } else {
      isload = true;
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
      // Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {});
  }

  Future<void> remove_document(String doc_id) async {
    var res = await remove_docu(doc_id);

    print(res);
    if (res['status'] == 1) {
      //getsimmilar = Get_deteteDocument.fromJson(res);
      // Fluttertoast.showToast(msg: res['message']);
      // remove_item(notify_id)

      if (mounted) {
        setState(() {});
      }
    } else {
      WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(msg: res['message']);
    }
  }
}

class type extends StatefulWidget {
  const type({Key? key}) : super(key: key);

  @override
  State<type> createState() => _typeState();
}

class _typeState extends State<type> {
  String? assignedName;
  bool gender = false;

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
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
          child: Text('Select Production Capacity',
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
              itemCount: constanst.production_cap.length,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                cat.Annual record = constanst.production_cap[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      constanst.select_prodcap_idx = index;

                      if (constanst.select_prodcap_idx == index) {
                        constanst.Prodcap_itemsCheck[index] =
                            Icons.check_circle_outline;

                        //constanst.select_categotyId.add(record.categoryId.toString());
                        constanst.select_product_cap_id = record.id.toString();
                        constanst.Product_Capcity_name = record.name.toString();
                      } else {
                        constanst.Prodcap_itemsCheck[index] =
                            Icons.circle_outlined;
                      }
                    });
                  },
                  child: ListTile(
                      title: Text(record.name.toString(),
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                      leading: IconButton(
                          icon: constanst.select_prodcap_idx == index
                              ? Icon(Icons.check_circle,
                                  color: Colors.green.shade600)
                              : Icon(Icons.circle_outlined,
                                  color: Colors.black45),
                          onPressed: () {
                            setState(() {
                              constanst.select_prodcap_idx = index;

                              if (constanst.select_cat_idx == index) {
                                constanst.Prodcap_itemsCheck[index] =
                                    Icons.check_circle_outline;

                                //constanst.select_categotyId.add(record.categoryId.toString());
                                constanst.select_product_cap_id =
                                    record.id.toString();
                                constanst.Product_Capcity_name =
                                    record.name.toString();
                              } else {
                                constanst.Prodcap_itemsCheck[index] =
                                    Icons.circle_outlined;
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
              //if (constanst.select_cat_idx!= "") {
              Navigator.pop(context);
              setState(() {});
              /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryScreen()));*/
              /* } else {
                Fluttertoast.showToast(msg: 'Select Minimum 1 Category ');
              }*/
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

class document_type extends StatefulWidget {
  const document_type({Key? key}) : super(key: key);

  @override
  State<document_type> createState() => _document_typeState();
}

class _document_typeState extends State<document_type> {
  String? assignedName;
  bool gender = false;

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
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
          child: Text('Select Document Type',
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
              itemCount: constanst.doc_typess.length,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                doc_type.Types record = constanst.doc_typess[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      constanst.select_document_type_idx = index;

                      if (constanst.select_document_type_idx == index) {
                        constanst.Document_type_itemsCheck[index] =
                            Icons.check_circle_outline;

                        //constanst.select_categotyId.add(record.categoryId.toString());
                        constanst.select_document_type_id =
                            record.id.toString();
                        constanst.Document_type_name = record.name.toString();
                      } else {
                        constanst.Document_type_itemsCheck[index] =
                            Icons.circle_outlined;
                      }
                    });
                  },
                  child: ListTile(
                      title: Text(record.name.toString(),
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                      leading: IconButton(
                          icon: constanst.select_document_type_idx == index
                              ? Icon(Icons.check_circle,
                                  color: Colors.green.shade600)
                              : Icon(Icons.circle_outlined,
                                  color: Colors.black45),
                          onPressed: () {
                            setState(() {
                              constanst.select_document_type_idx = index;

                              if (constanst.select_document_type_idx == index) {
                                constanst.Document_type_itemsCheck[index] =
                                    Icons.check_circle_outline;

                                //constanst.select_categotyId.add(record.categoryId.toString());
                                constanst.select_document_type_id =
                                    record.id.toString();
                                constanst.Document_type_name =
                                    record.name.toString();
                              } else {
                                constanst.Document_type_itemsCheck[index] =
                                    Icons.circle_outlined;
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
              //if (constanst.select_cat_idx!= "") {
              Navigator.pop(context);
              setState(() {});
              /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryScreen()));*/
              /* } else {
                Fluttertoast.showToast(msg: 'Select Minimum 1 Category ');
              }*/
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