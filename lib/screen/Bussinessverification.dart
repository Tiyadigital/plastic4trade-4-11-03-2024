// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, unrelated_type_equality_checks, camel_case_types, prefer_typing_uninitialized_variables

import 'dart:developer';
import 'dart:io';

import 'package:Plastic4trade/model/Getbusiness_document_types.dart'
    as doc_type;
import 'package:Plastic4trade/model/Getmybusinessprofile.dart';
import 'package:Plastic4trade/model/Getmybusinessprofile.dart' as profile;
import 'package:Plastic4trade/model/getannualcapacity.dart' as cat;
import 'package:Plastic4trade/model/getannualturnovermaster.dart' as cat1;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';
import '../utill/constant.dart';
import 'Bussinessinfo.dart';

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
  final _formKey = GlobalKey<FormState>();
  List<RadioModel> sampleData1 = <RadioModel>[];
  final TextEditingController _usergst = TextEditingController();
  final TextEditingController _pannumber = TextEditingController();
  final TextEditingController _exno = TextEditingController();
  final TextEditingController _useresiger = TextEditingController();
  final TextEditingController _prd_cap = TextEditingController();
  final TextEditingController _doctype = TextEditingController();
  Color _color1 = Colors.black45;
  Color _color2 = Colors.black45;
  Color _color3 = Colors.black45;
  Color _color4 = Colors.black45;
  Color _color5 = Colors.black45;

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;

  List<Doc> get_doctype = [];
  DateTime dateTime = DateTime.now();
  String? _select_premises;
  String? firstyear_currency, secondyear_currency, thirdyear_currency;
  String? firstyear_amount, secondyear_amount, thirdyear_amount;
  String? firstyear_amountID, secondyear_amountID, thirdyear_amountID;
  String imageName = "";

  String userId = "";

  Getmybusinessprofile getprofile = Getmybusinessprofile();

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
    sampleData1.add(RadioModel(false, 'Rent'));
    sampleData1.add(RadioModel(false, 'Own'));
    checknetowork();
    super.initState();
  }

  String? get _errorText {
    final text = _usergst.value.text;
    final text1 = _useresiger.value.text;

    if (text.isEmpty && text1.isEmpty) {
      return null;
    }
    if (text.isNotEmpty && text1.isEmpty) {
      return '';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return initwidget(size);
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
                          : Container(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget initwidget(size) {
    return WillPopScope(
      onWillPop: () async {
        setState(
          () {
            // Reset document type selection
            constanst.Document_type_itemsCheck[0] = Icons.circle_outlined;
            constanst.select_document_type_id = "";
            constanst.Document_type_name = "";
            constanst.select_document_type_idx = -1;

            // Reset product capacity selection
            constanst.Prodcap_itemsCheck[0] = Icons.circle_outlined;
            constanst.select_product_cap_id = "";
            constanst.Product_Capcity_name = "";
            constanst.select_prodcap_idx = -1;
          },
        );
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFDADADA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Business Verification',
            softWrap: false,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Metropolis',
            ),
          ),
          leading: InkWell(
            onTap: () {
              setState(
                () {
                  // Reset document type selection
                  constanst.Document_type_itemsCheck[0] = Icons.circle_outlined;
                  constanst.select_document_type_id = "";
                  constanst.Document_type_name = "";
                  constanst.select_document_type_idx = -1;

                  // Reset product capacity selection
                  constanst.Prodcap_itemsCheck[0] = Icons.circle_outlined;
                  constanst.select_product_cap_id = "";
                  constanst.Product_Capcity_name = "";
                  // constanst.select_product_cap_idx = -1;
                  constanst.select_prodcap_idx = -1;
                },
              );

              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: isload == true
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
                            child: Column(
                              children: [
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
                                          controller: _usergst,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          style: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf'),
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
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'GST/VAT/TAX Number',
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
                                                  width: 1, color: _color1),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color1),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color1),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          onFieldSubmitted: (value) {
                                            var numValue = value.length;
                                            if (numValue == 15) {
                                              _color1 = Colors.green.shade600;
                                            } else {
                                              _color1 = Colors.red;
                                              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                                              Fluttertoast.showToast(msg: 'Please Enter a GST/VAT/TAX Number');
                                            }
                                          },
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              WidgetsBinding.instance
                                                  .focusManager.primaryFocus
                                                  ?.unfocus();
                                              Fluttertoast.showToast(msg: 'Please Your GST/VAT/TAX  Number');
                                              setState(() {_color1 = Colors.red;});
                                            } else {
                                              setState(
                                                () {_color1 = Colors.green.shade600;
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 0.0, 25.0, 5.0),
                                        child: TextFormField(
                                          controller: _useresiger,
                                          readOnly: true,
                                          style: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf'),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r"[a-zA-Z]+|\d"),
                                            ),
                                          ],
                                          decoration: InputDecoration(
                                            // labelText: 'Your Name*',
                                            // labelStyle: TextStyle(color: Colors.red),
                                            suffixIcon: const Icon(
                                              Icons.calendar_month,
                                              color: Color.fromARGB(
                                                  255, 0, 91, 148),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: 'Registration Date',
                                            errorText: _errorText,
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
                                                  width: 1, color: _color2),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color2),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color2),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          onTap: () async {
                                            final date = await showDatePicker(
                                              context: context,
                                              firstDate: DateTime(1960),
                                              initialDate: DateTime.now(),
                                              lastDate: DateTime(2100),
                                            );
                                            if (date != null) {
                                              setState(
                                                () {
                                                  _useresiger.text =
                                                      DateFormat()
                                                          .add_yMMMd()
                                                          .format(date);
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 5.0),
                                        child: TextFormField(
                                          controller: _pannumber,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          style: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf'),
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
                                                  width: 1, color: _color3),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color3),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color3),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          onFieldSubmitted: (value) {
                                            var numValue = value.length;
                                            if (numValue == 10) {
                                              _color3 = Colors.green.shade600;
                                            } else {
                                              _color3 = Colors.red;
                                              WidgetsBinding.instance
                                                  .focusManager.primaryFocus
                                                  ?.unfocus();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Enter Pan Number');
                                            }
                                          },
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              WidgetsBinding.instance
                                                  .focusManager.primaryFocus
                                                  ?.unfocus();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Your Pan Number');
                                              setState(
                                                () {
                                                  _color3 = Colors.red;
                                                },
                                              );
                                            } else {
                                              setState(
                                                () {
                                                  _color3 =
                                                      Colors.green.shade600;
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 10.0),
                                        child: TextFormField(
                                          controller: _exno,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          style: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf'),
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
                                                  width: 1, color: _color4),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color4),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color4),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
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
                                                  .focusManager.primaryFocus
                                                  ?.unfocus();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Your Export Import Number');
                                              setState(
                                                () {
                                                  _color4 = Colors.red;
                                                },
                                              );
                                            } else {
                                              setState(
                                                () {
                                                  _color4 =
                                                      Colors.green.shade600;
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 5.0),
                                        child: TextFormField(
                                          controller: _prd_cap,
                                          keyboardType: TextInputType.text,
                                          readOnly: true,
                                          textInputAction: TextInputAction.next,
                                          style: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf'),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Production Capacity ",
                                            suffixIcon: const Icon(
                                                Icons.arrow_drop_down_sharp),
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
                                                  width: 1, color: _color2),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color2),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color2),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          onTap: () async {
                                            setState(
                                              () {},
                                            );
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
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 2.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Annual Turnover',
                                              style: const TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'assets/fonst/Metropolis-Black.otf')
                                                  .copyWith(fontSize: 15),
                                            ),
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
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 10.0),
                                        child: Row(
                                          children: [
                                            Center(
                                              child: Text(
                                                '2020 - 2021',
                                                style: const TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf')
                                                    .copyWith(fontSize: 15),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16.0,
                                                  top: 5.0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.3,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  color: Colors.white),
                                              child: Column(
                                                children: [
                                                  DropdownButton(
                                                    value: firstyear_currency,
                                                    hint: Text(
                                                      'Currency',
                                                      style: const TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets/fonst/Metropolis-Black.otf')
                                                          .copyWith(
                                                              color: Colors
                                                                  .black45),
                                                    ),
                                                    dropdownColor: Colors.white,
                                                    icon: const Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 15,
                                                    isExpanded: true,
                                                    underline: const SizedBox(),
                                                    items: listrupes.map(
                                                      (valueItem) {
                                                        return DropdownMenuItem(
                                                          value: valueItem,
                                                          child: Text(
                                                            valueItem,
                                                            style: const TextStyle(
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'assets/fonst/Metropolis-Black.otf'),
                                                          ),
                                                        );
                                                      },
                                                    ).toList(),
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          firstyear_currency =
                                                              null;

                                                          firstyear_currency =
                                                              value.toString();
                                                        },
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16.0,
                                                  top: 5.0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.3,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  color: Colors.white),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  DropdownButtonFormField<int>(
                                                    hint:
                                                        firstyear_amount != null
                                                            ? Text(
                                                                firstyear_amount
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'assets/fonst/Metropolis-Black.otf')
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .black),
                                                              )
                                                            : Text(
                                                                'Amount',
                                                                style: const TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'assets/fonst/Metropolis-Black.otf')
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .black45),
                                                              ),
                                                    dropdownColor: Colors.white,
                                                    icon: const Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 15,
                                                    isExpanded: true,
                                                    items: production_turn.map(
                                                      (cat1.Annual annual) {
                                                        return DropdownMenuItem<
                                                            int>(
                                                          value: annual.id,
                                                          child: Text(
                                                            annual.name ?? '',
                                                            style: const TextStyle(
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'assets/fonst/Metropolis-Black.otf'),
                                                          ),
                                                        );
                                                      },
                                                    ).toList(),
                                                    onChanged:
                                                        (int? selectedId) {
                                                      // Handle the selected id
                                                      if (selectedId != null) {
                                                        // Find the corresponding Annual object
                                                        cat1.Annual?
                                                            selectedAnnual =
                                                            production_turn
                                                                .firstWhere(
                                                                    (annual) =>
                                                                        annual
                                                                            .id ==
                                                                        selectedId);
                                                        setState(
                                                          () {
                                                            firstyear_amountID =
                                                                selectedAnnual
                                                                    .id
                                                                    .toString();
                                                          },
                                                        );
                                                      }
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                            border: InputBorder
                                                                .none),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 10.0),
                                        child: Row(
                                          children: [
                                            Center(
                                              child: Text(
                                                '2021 - 2022',
                                                style: const TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf')
                                                    .copyWith(fontSize: 15),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16.0,
                                                  top: 5.0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.3,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  color: Colors.white),
                                              child: Column(
                                                children: [
                                                  DropdownButton(
                                                    value: secondyear_currency,
                                                    hint: Text(
                                                      'Currency',
                                                      style: const TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets/fonst/Metropolis-Black.otf')
                                                          .copyWith(
                                                              color: Colors
                                                                  .black45),
                                                    ),
                                                    dropdownColor: Colors.white,
                                                    icon: const Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 15,
                                                    isExpanded: true,
                                                    underline: const SizedBox(),
                                                    items: listrupes.map(
                                                      (valueItem) {
                                                        return DropdownMenuItem(
                                                          value: valueItem,
                                                          child: Text(
                                                            valueItem,
                                                            style: const TextStyle(
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'assets/fonst/Metropolis-Black.otf'),
                                                          ),
                                                        );
                                                      },
                                                    ).toList(),
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          secondyear_currency =
                                                              null;
                                                          secondyear_currency =
                                                              value.toString();
                                                        },
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16.0,
                                                  top: 5.0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.3,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  color: Colors.white),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  DropdownButtonFormField<int>(
                                                    hint: secondyear_amount !=
                                                            null
                                                        ? Text(
                                                            secondyear_amount
                                                                .toString(),
                                                            style: const TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'assets/fonst/Metropolis-Black.otf')
                                                                .copyWith(
                                                                    color: Colors
                                                                        .black),
                                                          )
                                                        : Text(
                                                            'Amount',
                                                            style: const TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'assets/fonst/Metropolis-Black.otf')
                                                                .copyWith(
                                                                    color: Colors
                                                                        .black45),
                                                          ),
                                                    dropdownColor: Colors.white,
                                                    icon: const Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 15,
                                                    isExpanded: true,
                                                    items: production_turn.map(
                                                      (cat1.Annual annual) {
                                                        return DropdownMenuItem<
                                                            int>(
                                                          value: annual.id,
                                                          child: Text(
                                                            annual.name ?? '',
                                                            style: const TextStyle(
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'assets/fonst/Metropolis-Black.otf'),
                                                          ),
                                                        );
                                                      },
                                                    ).toList(),
                                                    onChanged:
                                                        (int? selectedId) {
                                                      // Handle the selected id
                                                      if (selectedId != null) {
                                                        // Find the corresponding Annual object
                                                        cat1.Annual?
                                                            selectedAnnual =
                                                            production_turn
                                                                .firstWhere(
                                                                    (annual) =>
                                                                        annual
                                                                            .id ==
                                                                        selectedId);
                                                        setState(
                                                          () {
                                                            secondyear_amountID =
                                                                selectedAnnual
                                                                    .id
                                                                    .toString();
                                                          },
                                                        );
                                                      }
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                            border: InputBorder
                                                                .none),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 5.0, 25.0, 10.0),
                                        child: Row(
                                          children: [
                                            Center(
                                              child: Text(
                                                '2022 - 2023',
                                                style: const TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf')
                                                    .copyWith(fontSize: 15),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16.0,
                                                  top: 5.0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.3,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  color: Colors.white),
                                              child: Column(
                                                children: [
                                                  DropdownButton(
                                                    value: thirdyear_currency,
                                                    hint: Text(
                                                      'Currency',
                                                      style: const TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets/fonst/Metropolis-Black.otf')
                                                          .copyWith(
                                                              color: Colors
                                                                  .black45),
                                                    ),
                                                    dropdownColor: Colors.white,
                                                    icon: const Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 15,
                                                    isExpanded: true,
                                                    underline: const SizedBox(),
                                                    items: listrupes.map(
                                                      (valueItem) {
                                                        return DropdownMenuItem(
                                                          value: valueItem,
                                                          child: Text(
                                                            valueItem,
                                                            style: const TextStyle(
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'assets/fonst/Metropolis-Black.otf'),
                                                          ),
                                                        );
                                                      },
                                                    ).toList(),
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          thirdyear_currency =
                                                              null;
                                                          thirdyear_currency =
                                                              value.toString();
                                                        },
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 16.0,
                                                  top: 5.0),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3.3,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  color: Colors.white),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  DropdownButtonFormField<int>(
                                                    hint:
                                                        thirdyear_amount != null
                                                            ? Text(
                                                                thirdyear_amount
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'assets/fonst/Metropolis-Black.otf')
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .black),
                                                              )
                                                            : Text(
                                                                'Amount',
                                                                style: const TextStyle(
                                                                        fontSize:
                                                                            15.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'assets/fonst/Metropolis-Black.otf')
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .black45),
                                                              ),
                                                    dropdownColor: Colors.white,
                                                    icon: const Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 15,
                                                    isExpanded: true,
                                                    items: production_turn.map(
                                                      (cat1.Annual annual) {
                                                        return DropdownMenuItem<
                                                            int>(
                                                          value: annual.id,
                                                          child: Text(
                                                            annual.name ?? '',
                                                            style: const TextStyle(
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'assets/fonst/Metropolis-Black.otf'),
                                                          ),
                                                        );
                                                      },
                                                    ).toList(),
                                                    onChanged:
                                                        (int? selectedId) {
                                                      // Handle the selected id
                                                      if (selectedId != null) {
                                                        // Find the corresponding Annual object
                                                        cat1.Annual?
                                                            selectedAnnual =
                                                            production_turn
                                                                .firstWhere(
                                                                    (annual) =>
                                                                        annual
                                                                            .id ==
                                                                        selectedId);
                                                        setState(
                                                          () {
                                                            thirdyear_amountID =
                                                                selectedAnnual
                                                                    .id
                                                                    .toString();
                                                          },
                                                        );
                                                      }
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                            border: InputBorder
                                                                .none),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            25.0, 10.0, 25.0, 5.0),
                                        padding: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.black45),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Select Premise Type ',
                                                style: const TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf')
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
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
                                                                  : const Icon(
                                                                      Icons
                                                                          .circle_outlined,
                                                                      color: Colors
                                                                          .black38),
                                                              onTap: () {
                                                                setState(
                                                                  () {
                                                                    sampleData1
                                                                        .first
                                                                        .isSelected = true;
                                                                    _select_premises =
                                                                        sampleData1
                                                                            .first
                                                                            .buttonText;
                                                                    sampleData1
                                                                            .last
                                                                            .isSelected =
                                                                        false;
                                                                    //category1 = true;
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                            Text(
                                                              sampleData1.first
                                                                  .buttonText,
                                                              style: const TextStyle(
                                                                      fontSize:
                                                                          13.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'assets/fonst/Metropolis-Black.otf')
                                                                  .copyWith(
                                                                      fontSize:
                                                                          17),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    setState(
                                                      () {
                                                        sampleData1.first
                                                            .isSelected = true;
                                                        _select_premises =
                                                            sampleData1.first
                                                                .buttonText;
                                                        sampleData1.last
                                                            .isSelected = false;
                                                        //category1 = true;
                                                      },
                                                    );
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
                                                              : const Icon(
                                                                  Icons
                                                                      .circle_outlined,
                                                                  color: Colors
                                                                      .black38),
                                                          onTap: () {
                                                            setState(
                                                              () {
                                                                sampleData1.last
                                                                        .isSelected =
                                                                    true;
                                                                sampleData1
                                                                        .first
                                                                        .isSelected =
                                                                    false;
                                                                //category1 = true;
                                                                _select_premises =
                                                                    sampleData1
                                                                        .last
                                                                        .buttonText;
                                                                //Fluttertoast.showToast(msg: 'hell $sampleData.last.isSelected');
                                                              },
                                                            );
                                                          },
                                                        ),
                                                        Text(
                                                          sampleData1
                                                              .last.buttonText,
                                                          style: const TextStyle(
                                                                  fontSize:
                                                                      13.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'assets/fonst/Metropolis-Black.otf')
                                                              .copyWith(
                                                                  fontSize: 17),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    setState(
                                                      () {
                                                        sampleData1.last
                                                            .isSelected = true;
                                                        sampleData1.first
                                                            .isSelected = false;
                                                        _select_premises =
                                                            sampleData1.last
                                                                .buttonText;
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              30.0, 5.0, 0.0, 2.0),
                                          child: Text(
                                            'Upload Document',
                                            style: const TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf')
                                                .copyWith(
                                                    color: Colors.black45),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            25.0, 0.0, 25.0, 15.0),
                                        child: TextFormField(
                                          controller: _doctype,
                                          keyboardType: TextInputType.text,
                                          readOnly: true,
                                          textInputAction: TextInputAction.next,
                                          style: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf'),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Document Type",
                                            suffixIcon: const Icon(
                                                Icons.arrow_drop_down_sharp),
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
                                                  width: 1, color: _color5),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color5),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: _color5),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          onTap: () async {
                                            setState(
                                              () {},
                                            );
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
                                        padding: const EdgeInsets.fromLTRB(
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
                                          },
                                          child: Image.asset(
                                              'assets/add_document.png'),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15.0, 0.0, 15.0, 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: document_display(
                                                  size, imageName),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: (get_doctype.isEmpty)
                                            ? 0
                                            : (get_doctype.isNotEmpty &&
                                                    get_doctype.length <= 3)
                                                ? 60
                                                : (get_doctype.length >= 4 &&
                                                        get_doctype.length <= 6)
                                                    ? 120
                                                    : 180,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15.0, 0.0, 15.0, 0),
                                          child: uploadedImage(size),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1.2,
                                        height: 60,
                                        margin: const EdgeInsets.fromLTRB(
                                            20.0, 10.0, 20.0, 20),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          color: const Color.fromARGB(
                                              255, 0, 91, 148),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            if (_errorText != null) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please Enter Registration Date');
                                            } else {
                                              vaild_data();
                                            }
                                            setState(
                                              () {},
                                            );
                                          },
                                          child: const Text(
                                            'Update',
                                            style: TextStyle(
                                                fontSize: 19.0,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                                fontFamily:
                                                    'assets/fonst/Metropolis-Black.otf'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
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
                            color: Color.fromARGB(255, 0, 91, 148),
                            radius: 20,
                            animating: true,
                          )
                        : Container(),
              ),
      ),
    );
  }

  File? filename;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'pdf'],
    );

    try {
      if (result != null) {
        File file = File(result.files.single.path!);
        int fileSizeInBytes = await file.length();
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 2) {
          Fluttertoast.showToast(msg: "Selected File must be less than 2 mb");
          return;
        }

        if (await file.length() > 1024 * 1024) {
          // Compress the file if it exceeds 1 MB
          file = (await compressFile(file)) as File;
        }

        setState(() {
          filename = file;
          _selectedFile = file;
          imageName = _doctype.text;

          log("SELECTED FILE === $_selectedFile");
        });
      }
    } catch (e) {
      log("ERROR START === $e");
    }
  }

  Future<XFile?> compressFile(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(
      RegExp(r'.jp'),
    );
    final newPath = '${filePath.substring(0, lastIndex)}.compressed.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      newPath,
      quality: 70,
    );

    return result;
  }

  Widget document_display(size, label) {
    return Column(
      children: [
        if (filename != null)
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  getFilePreview();
                },
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(8.0),
                    height: 45,
                    width: size.width,
                    child: Text(
                      label,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: -6,
                  right: -5,
                  child: GestureDetector(
                    onTap: () {
                      filename = null;
                      _selectedFile = null;
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 25,
                    ),
                  ))
            ],
          ),
      ],
    );
  }

  Widget? getFilePreview() {
    // Check the file extension
    String extension = filename!.path.split('.').last.toLowerCase();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
              height: 500,
              width: 225,
              padding: const EdgeInsets.all(16.0),
              child: (extension == 'jpg' || extension == 'png')
                  ? Image.file(filename!, fit: BoxFit.cover)
                  : (extension == 'pdf')
                      ? const Icon(Icons.picture_as_pdf,
                          size: 50, color: Colors.red)
                      : const Icon(Icons.insert_drive_file,
                          size: 50, color: Colors.blue)),
        );
      },
    );
    return null;
  }

  Widget uploadedImage(Size size) {
    return ListView.builder(
      itemCount: (get_doctype.length / 2).ceil(),
      itemBuilder: (context, index) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 60,
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            // mainAxisSpacing: 1.0,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: get_doctype.length,
          itemBuilder: (context, gridIndex) {
            final doc = get_doctype[gridIndex];
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    if (doc.documentUrl != null) {
                      if (doc.documentUrl!.toLowerCase().endsWith('.pdf')) {
                        // Handle PDF
                        showPdfPreview(size, doc.documentUrl ?? "");
                      } else {
                        // Handle image
                        showImagePreview(size, doc.documentUrl ?? "");
                      }
                    }
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 55,
                      width: size.width / 2 - 12, // Adjust the width as needed

                      child: Text(
                        doc.docType!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -6,
                  right: -5,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isload = false; // Show the circular progress indicator
                      });

                      remove_document(doc.id.toString()).then((value) {
                        Future.delayed(const Duration(seconds: 2), () {
                          // After 2 seconds, refresh the page
                          setState(() {
                            isload = true; // Hide the circular progress indicator
                            getProfiless();
                          });
                        });
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 25,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showImagePreview(size, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 500,
            width: 225,
            padding: const EdgeInsets.all(16.0),
            child: Image.network(imageUrl), // Replace with your image widget
          ),
        );
      },
    );
  }

  void showPdfPreview(Size size, String pdfUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            height: size.height * 0.8,
            width: size.width * 0.8,
            child: PDFView(
              filePath: pdfUrl,
              autoSpacing: true,
              swipeHorizontal: true,
              onRender: (pages) {
                setState(() {
                  pages = pages;
                  isReady = true;
                });
              },
            ),
          ),
        );
      },
    );
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
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.60,
        // Initial height as a fraction of screen height
        builder: (BuildContext context, ScrollController scrollController) {
          return StatefulBuilder(
            builder: (context, setState) {
              return const type();
            },
          );
        },
      ),
    ).then(
      (value) {
        if (constanst.select_prodcap_idx != "") {
          _prd_cap.text = constanst.Product_Capcity_name;
          setState(
            () {
              _color2 = Colors.green.shade600;
            },
          );
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
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.60,
        // Initial height as a fraction of screen height
        builder: (BuildContext context, ScrollController scrollController) {
          return StatefulBuilder(
            builder: (context, setState) {
              return const document_type();
            },
          );
        },
      ),
    ).then(
      (value) {
        if (constanst.select_document_type_idx != "") {
          _doctype.text = constanst.Document_type_name;

          setState(
            () {
              _color5 = Colors.green.shade600;
            },
          );
        }
      },
    );
  }

  Widget prem_dropdown(List listitem, String hint) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white),
          child: DropdownButton(
            value: _select_premises,
            hint: Text(
              hint,
              style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf')
                  .copyWith(color: Colors.black45),
            ),
            dropdownColor: Colors.white,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 30,
            isExpanded: true,
            underline: const SizedBox(),
            items: listitem.map(
              (valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(
                    valueItem,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf',
                    ),
                  ),
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(
                () {
                  _select_premises = value.toString();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget doc_type_dropdown(String hint) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white),
          child: DropdownButtonFormField<int>(
            hint: Text(
              hint,
              style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf')
                  .copyWith(color: Colors.black45),
            ),
            dropdownColor: Colors.white,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 30,
            isExpanded: true,
            items: constanst.doc_typess.map(
              (doc_type.Types annual) {
                return DropdownMenuItem<int>(
                  value: annual.id,
                  child: Text(
                    annual.name ?? '',
                    style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                  ),
                );
              },
            ).toList(),
            onChanged: (int? selectedId) {
              // Handle the selected id
              if (selectedId != null) {
                // Find the corresponding Annual object
              }
            },
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  vaild_data() {
    if (_usergst.text.isEmpty &&
        _pannumber.text.isEmpty &&
        _exno.text.isEmpty &&
        _useresiger.text.isEmpty &&
        _prd_cap.text.isEmpty &&
        _doctype.text.isEmpty &&
        firstyear_amount == "" &&
        secondyear_amount == "" &&
        thirdyear_amount == "") {
      _onLoading();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Bussinessinfo(),
        ),
      );
    } else if (constanst.select_document_type_id.isNotEmpty) {
      if (_selectedFile == null) {
        Fluttertoast.showToast(msg: 'Please Add Document');
      } else {
        _onLoading();
        update_BusinessVerification().then(
          (value) {
            Navigator.of(dialogContext!).pop(); // loader
            if (value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Bussinessinfo(),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Bussinessinfo(),
                ),
              );
            }
          },
        );
      }
    } else {
      _onLoading();
      update_BusinessVerification().then(
        (value) {
          Navigator.of(dialogContext!).pop(); // loader
          if (value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Bussinessinfo(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Bussinessinfo(),
              ),
            );
          }
        },
      );
    }
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
    var res = await getannual_capacity();
    var jsonArray;
    if (res['status'] == 1) {
      jsonArray = res['annual'];

      for (var data in jsonArray) {
        cat.Annual record = cat.Annual(
          id: data['id'],
          name: data['name'],
        );
        constanst.production_cap.add(record);
      }

      setState(
        () {},
      );
      for (int i = 0; i < constanst.production_cap.length; i++) {
        constanst.Prodcap_itemsCheck.add(Icons.circle_outlined);
      }
      isload = true;
    } else {
      isload = true;
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(
        msg: res['message'],
      );
    }
    return jsonArray;
  }

  getannua_turnover() async {
    var res = await getannual_turnover();
    var jsonArray;
    if (res['status'] == 1) {
      jsonArray = res['annual'];
      for (var data in jsonArray) {
        cat1.Annual record = cat1.Annual(
          id: data['id'],
          name: data['name'],
        );
        production_turn.add(record);
      }
      setState(
        () {},
      );
      isload = true;
    } else {
      isload = true;
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(
        msg: res['message'],
      );
    }
    return jsonArray;
  }

  getdoc_type() async {
    var res = await getbusiness_document_types();
    var jsonArray;
    if (res['status'] == 1) {
      jsonArray = res['types'];
      for (var data in jsonArray) {
        doc_type.Types record = doc_type.Types(
          id: data['id'],
          name: data['name'],
        );
        constanst.doc_typess.add(record);
        isload = true;
      }
      for (int i = 0; i < constanst.doc_typess.length; i++) {
        constanst.Document_type_itemsCheck.add(Icons.circle_outlined);
      }
      setState(
        () {},
      );
    } else {
      isload = true;
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(
        msg: res['message'],
      );
    }
    return jsonArray;
  }

  Future<bool> update_BusinessVerification() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await updateBusinessVerification(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        _useresiger.text,
        _pannumber.text,
        _exno.text,
        _select_premises.toString(),
        _usergst.text,
        firstyear_currency.toString(),
        firstyear_amountID.toString(),
        secondyear_currency.toString(),
        secondyear_amountID.toString(),
        thirdyear_currency.toString(),
        thirdyear_amountID.toString(),
        constanst.select_document_type_id.toString(),
        constanst.select_product_cap_id.toString(),
        _selectedFile);

    if (res['status'] == 1) {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(
        msg: res['message'],
      );
      _isloading1 = true;
    } else {
      _isloading1 = true;
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(
        msg: res['message'],
      );
    }
    return _isloading1;
  }

  getProfiless() async {
    getprofile = Getmybusinessprofile();

    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getbussinessprofile(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );

    getprofile = Getmybusinessprofile.fromJson(res);
    resultList = getprofile.doc!;

    if (res['status'] == 1) {
      _usergst.text = res['profile']['gst_tax_vat'] ?? '';
      _exno.text = res['profile']['export_import_number'] ?? '';
      _useresiger.text = res['profile']['registration_date'] ?? '';
      _pannumber.text = res['profile']['pan_number'] ?? '';
      userId = res['profile']['user_id'] ?? '';

      if (res['annual_turnover'] != null) {
        if (res['annual_turnover']['amounts2021'] != null) {
          firstyear_amountID = res['annual_turnover']['amounts2021'] == null
              ? ""
              : res['annual_turnover']['amounts2021']['id'].toString();

          firstyear_amount = res['annual_turnover']['amounts2021'] == null
              ? ""
              : res['annual_turnover']['amounts2021']['name'];
        }
        if (res['annual_turnover']['amounts2122'] != null) {
          secondyear_amountID = res['annual_turnover']['amounts2122'] == null
              ? ""
              : res['annual_turnover']['amounts2122']['id'].toString();

          secondyear_amount = res['annual_turnover']['amounts2122'] == null
              ? ""
              : res['annual_turnover']['amounts2122']['name'];
        }
        if (res['annual_turnover']['amounts2223'] != null) {
          thirdyear_amountID = res['annual_turnover']['amounts2223'] == null
              ? ""
              : res['annual_turnover']['amounts2223']['id'].toString();

          thirdyear_amount = res['annual_turnover']['amounts2223'] == null
              ? ""
              : res['annual_turnover']['amounts2223']['name'];
        }

        firstyear_currency = res['annual_turnover']['currency_20_21'] ?? "";
        secondyear_currency = res['annual_turnover']['currency_21_22'] ?? "";
        thirdyear_currency = res['annual_turnover']['currency_22_23'] ?? "";
      }

      _prd_cap.text = res['profile']['annualcapacity'] != null
          ? res['profile']['annualcapacity']['name']
          : "";

      constanst.select_product_cap_id = res['profile']['annualcapacity'] != null
          ? res['profile']['annualcapacity']['id'].toString()
          : "";

      if (res['doc'] != null && res['doc'] != []) {
        var jsonArray = res['doc'];

        for (var data in jsonArray) {
          Doc record = Doc(
            id: data['id'],
            docType: data['doctype']['name'].toString(),
            documentUrl: data['document_url'],
          );
          get_doctype.add(record);
        }
      }

      isload = true;
    } else {
      log("ELSE RUN");

      isload = true;
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(
        msg: res['message'],
      );
    }

    setState(
      () {},
    );
  }

  Future<void> remove_document(String docId) async {
    var res = await remove_docu(docId);

    if (res['status'] == 1) {
      if (mounted) {
        setState(
          () {},
        );
      }
    } else {
      WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      Fluttertoast.showToast(
        msg: res['message'],
      );
    }
  }
}

class type extends StatefulWidget {
  const type({Key? key}) : super(key: key);

  @override
  State<type> createState() => _typeState();
}

class _typeState extends State<type> {
  @override
  void initState() {
    super.initState();

    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    setState(
      () {},
    );

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
          child: Text(
            'Select Production Capacity',
            style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: 'assets/fonst/Metropolis-Black.otf'),
          ),
        ),
        const SizedBox(height: 5),
        //-------CircularCheckBox()
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: constanst.production_cap.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              cat.Annual record = constanst.production_cap[index];
              return GestureDetector(
                onTap: () {
                  setState(
                    () {
                      if (constanst.select_prodcap_idx == index) {
                        // User tapped on the already selected item, unselect it
                        constanst.Prodcap_itemsCheck[index] =
                            Icons.circle_outlined;
                        constanst.select_product_cap_id = "";
                        constanst.Product_Capcity_name = "";
                        constanst.select_prodcap_idx = -1; // Unselect the item
                      } else {
                        // User tapped on a new item, select it
                        constanst.select_prodcap_idx = index;
                        constanst.Prodcap_itemsCheck[index] =
                            Icons.check_circle_outline;
                        constanst.select_product_cap_id = record.id.toString();
                        constanst.Product_Capcity_name = record.name.toString();
                      }
                    },
                  );
                },
                child: ListTile(
                  title: Text(
                    record.name.toString(),
                    style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                  ),
                  leading: IconButton(
                    icon: constanst.select_prodcap_idx == index
                        ? Icon(Icons.check_circle, color: Colors.green.shade600)
                        : const Icon(Icons.circle_outlined,
                            color: Colors.black45),
                    onPressed: () {
                      setState(
                        () {
                          if (constanst.select_prodcap_idx == index) {
                            // User tapped on the already selected item, unselect it
                            constanst.Prodcap_itemsCheck[index] =
                                Icons.circle_outlined;
                            constanst.select_product_cap_id = "";
                            constanst.Product_Capcity_name = "";
                            constanst.select_prodcap_idx =
                                -1; // Unselect the item
                          } else {
                            // User tapped on a new item, select it
                            constanst.select_prodcap_idx = index;
                            constanst.Prodcap_itemsCheck[index] =
                                Icons.check_circle_outline;
                            constanst.select_product_cap_id =
                                record.id.toString();
                            constanst.Product_Capcity_name =
                                record.name.toString();
                          }
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),

        Container(
          width: MediaQuery.of(context).size.width * 1.2,
          height: 60,
          margin: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(50.0),
            color: const Color.fromARGB(255, 0, 91, 148),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(
                () {},
              );
            },
            child: const Text(
              'Update',
              style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontFamily: 'assets/fonst/Metropolis-Black.otf'),
            ),
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
  @override
  void initState() {
    super.initState();

    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    setState(
      () {},
    );

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
          child: Text(
            'Select Document Type',
            style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: 'assets/fonst/Metropolis-Black.otf'),
          ),
        ),
        const SizedBox(height: 5),
        //-------CircularCheckBox()
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: constanst.doc_typess.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              doc_type.Types record = constanst.doc_typess[index];
              return GestureDetector(
                onTap: () {
                  setState(
                    () {
                      if (constanst.select_document_type_idx == index) {
                        // User tapped on the already selected item, unselect it
                        constanst.Document_type_itemsCheck[index] =
                            Icons.circle_outlined;
                        constanst.select_document_type_id = "";
                        constanst.Document_type_name = "";
                        constanst.select_document_type_idx =
                            -1; // Unselect the item
                      } else {
                        // User tapped on a new item, select it
                        constanst.select_document_type_idx = index;
                        constanst.Document_type_itemsCheck[index] =
                            Icons.check_circle_outline;
                        constanst.select_document_type_id =
                            record.id.toString();
                        constanst.Document_type_name = record.name.toString();
                      }
                    },
                  );
                },
                child: ListTile(
                  title: Text(
                    record.name.toString(),
                    style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                  ),
                  leading: IconButton(
                    icon: constanst.select_document_type_idx == index
                        ? Icon(Icons.check_circle, color: Colors.green.shade600)
                        : const Icon(Icons.circle_outlined,
                            color: Colors.black45),
                    onPressed: () {
                      setState(
                        () {
                          if (constanst.select_document_type_idx == index) {
                            // User tapped on the already selected item, unselect it
                            constanst.Document_type_itemsCheck[index] =
                                Icons.circle_outlined;
                            constanst.select_document_type_id = "";
                            constanst.Document_type_name = "";
                            constanst.select_document_type_idx =
                                -1; // Unselect the item
                          } else {
                            // User tapped on a new item, select it
                            constanst.select_document_type_idx = index;
                            constanst.Document_type_itemsCheck[index] =
                                Icons.check_circle_outline;
                            constanst.select_document_type_id =
                                record.id.toString();
                            constanst.Document_type_name =
                                record.name.toString();
                          }
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),

        Container(
          width: MediaQuery.of(context).size.width * 1.2,
          height: 60,
          margin: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(50.0),
            color: const Color.fromARGB(255, 0, 91, 148),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(
                () {},
              );
            },
            child: const Text(
              'Update',
              style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontFamily: 'assets/fonst/Metropolis-Black.otf'),
            ),
          ),
        ),
      ],
    );
  }
}
