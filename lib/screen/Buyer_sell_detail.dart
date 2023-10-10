// ignore_for_file: unnecessary_null_comparison, depend_on_referenced_packages, camel_case_types, must_be_immutable, prefer_interpolation_to_compose_strings, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:core';
import 'dart:io';

import 'package:Plastic4trade/model/CommonPostdetail.dart' as postdetail;
import 'package:Plastic4trade/model/common.dart';
import 'package:Plastic4trade/model/getsimilar_product.dart' as similar_prod;
import 'package:Plastic4trade/screen/Chat.dart';
import 'package:Plastic4trade/screen/other_user_profile.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';
import '../model/CommonPostdetail.dart';
import '../model/getsimilar_product.dart';

class Buyer_sell_detail extends StatefulWidget {
  String? post_type;
  String? prod_id;

  Buyer_sell_detail({Key? key, this.post_type, this.prod_id}) : super(key: key);

  @override
  State<Buyer_sell_detail> createState() => _Buyer_sell_detailState();
}

class _Buyer_sell_detailState extends State<Buyer_sell_detail> {
  final scrollercontroller = ScrollController();

  String? packageName;
  PackageInfo? packageInfo;
  int offset = 0;
  int count = 0;
  String notiId = "";
  String cate_name = "";
  String Grade = "";
  String type = "";
  String qty = "";
  String price = "";
  String usernm = "";
  String city = "";
  String state = "";
  String country = "";
  int? likecount, viewcount;
  String? isFavorite = "", unit = "", price_unit = "";

  String is_Follow = "";

  // int? islike;
  int? isView, user_id;
  String? product_status;
  String? prod_desc;
  String? prod_nm;
  String? loc;
  bool prod_like = false;
  String create_date = "";
  String update_date = "";
  bool load = false;
  String? location;
  List<postdetail.PostHaxCodeColor>? postHaxCodeColors = [];

  String? bussiness_type;
  String? user_image, main_product;
  var create_formattedDate, update_formattedDate;
  List<String> imagelist = [];

  List<similar_prod.Result> simmilar_post_buyer = [];
  List<similar_prod.Result> simmilar_post_saler = [];

  List<postdetail.PostHaxCodeColor> colors = [];
  String? follow;
  String like = "0";
  String? fav;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollercontroller.addListener(_scrollercontroller);
    getPackage();
    checknetowork();
  }

  void getPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
    String version = packageInfo!.version;
    String buildNumber = packageInfo!.buildNumber;
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Widget init() {
    return Scaffold(
        backgroundColor: const Color(0xFFDADADA),
        body: load == true
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Stack(fit: StackFit.passthrough, children: <Widget>[
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: SizedBox(
                          height: 900,
                          child: imagelist.length == 1
                              ? GestureDetector(
                                  onTap: () {
                                    _showImageDialog(context);
                                  },
                                  child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Image.network(
                                        imagelist[0].toString(),
                                        fit: BoxFit.cover,
                                        height: 400,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      )),
                                )
                              : slider(),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade600),
                          // color: Color.fromARGB(0, 255, 255, 255),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          right: 80,
                          top: 30,
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade600),
                            // color: Color.fromARGB(0, 255, 255, 255),
                            child: prod_like
                                ? GestureDetector(
                                    onTap: () {
                                      getremove_product();
                                    },
                                    child: Center(
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.red.shade400,
                                      ),
                                    ))
                                : GestureDetector(
                                    onTap: () {
                                      getadd_product();
                                    },
                                    child: const Center(
                                        child: Icon(
                                      Icons.favorite_border_outlined,
                                      color: Colors.white,
                                    ))),
                          )),
                      Positioned(
                        right: 30,
                        top: 30,
                        child: GestureDetector(
                          onTap: () {
                            shareImage(url: main_product.toString());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade600),
                            // color: Color.fromARGB(0, 255, 255, 255),
                            child: const Center(
                              child: Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 250,
                        left: 12,
                        right: 12,
                        child: Column(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                                //transform: Matrix4.translationValues(0.0, -50.0, 0.0),

                                //height: 320,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(prod_nm.toString(),
                                            style: const TextStyle(
                                                    fontSize: 26.0,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf')
                                                .copyWith(fontSize: 17))),
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                margin:
                                                    const EdgeInsets.all(5.0),
                                                padding: const EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  color: const Color.fromARGB(255, 0, 148, 95),),
                                                child: Row(
                                                  children: [
                                                    Text('₹$price',
                                                        style: const TextStyle(
                                                                fontSize: 26.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'assets/fonst/Metropolis-Black.otf')
                                                            .copyWith(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                    .white)),
                                                    Text('/Per $price_unit',
                                                        style: const TextStyle(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'assets/fonst/Metropolis-Black.otf')
                                                            .copyWith(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .white))
                                                  ],
                                                ))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(5.0),
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: const Color.fromRGBO(
                                                    90, 231, 131, 0.29),
                                              ),
                                              child: Text(
                                                  product_status.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'assets/fonst/Metropolis-SemiBold.otf')),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                margin:
                                                    const EdgeInsets.all(5.0),
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  shape: BoxShape.rectangle,
                                                ),
                                                child: Text(
                                                  widget.post_type.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'assets/fonst/Metropolis-SemiBold.otf'),
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 90,
                                            child: Text(
                                              'Category:',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-SemiBold.otf'),
                                            ),
                                          ),
                                          Text(cate_name,
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-SemiBold.otf'))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 90,
                                            child: Text(
                                              'Type:',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-SemiBold.otf'),
                                            ),
                                          ),
                                          Text(type,
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-SemiBold.otf'))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      // width: MediaQuery.of(context).size.width/1.5,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 90,
                                            child: Text(
                                              'Grade:',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-SemiBold.otf'),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                            child: Text(Grade,
                                                overflow: TextOverflow.visible,
                                                softWrap: false,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-SemiBold.otf')),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 90,
                                            child: Text(
                                              'Quantity:',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-SemiBold.otf'),
                                            ),
                                          ),
                                          Text("$qty$unit",
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-SemiBold.otf'))
                                        ],
                                      ),
                                    ),
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // Text('$colors'),]
                                          //colors==null?Container(): getcolorlist()

                                          const SizedBox(
                                            width: 90,
                                            height: 70,
                                            child: Text(
                                              'Color: ',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-SemiBold.otf'),
                                            ),
                                          ),

                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              // scrollDirection: Axis.horizontal,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,

                                              itemCount:
                                                  postHaxCodeColors?.length ??
                                                      0,
                                              itemBuilder:
                                                  (context, colorIndex) {
                                                postdetail.PostHaxCodeColor
                                                    result = postHaxCodeColors![
                                                        colorIndex];
                                                String colorString =
                                                    result.haxCode.toString();
                                                String newStr =
                                                    colorString.substring(1);

                                                Color colors = Color(int.parse(
                                                        newStr,
                                                        radix: 16))
                                                    .withOpacity(1.0);
                                                return Container(
                                                    margin: EdgeInsets.zero,
                                                    padding: EdgeInsets.zero,
                                                    child: Row(
                                                      children: [
                                                        newStr == 'ffffff'
                                                            ? const Icon(
                                                                Icons
                                                                    .circle_outlined,
                                                                size: 15)
                                                            : Icon(
                                                                Icons
                                                                    .circle_rounded,
                                                                size: 15,
                                                                color: colors),
                                                        Flexible(
                                                          child: Text(
                                                            colorIndex + 1 ==
                                                                    postHaxCodeColors
                                                                        ?.length
                                                                ? postHaxCodeColors![
                                                                        colorIndex]
                                                                    .colorName
                                                                    .toString()
                                                                : '${postHaxCodeColors![colorIndex].colorName.toString()},',
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            maxLines: 1,
                                                          ),

                                                          //width: 43,
                                                          // height: 30,
                                                        )
                                                      ],
                                                    ));
                                              },
                                            ),
                                          )
                                        ]),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          prod_desc.toString(),
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets/fonst/Metropolis-SemiBold.otf',
                                          ),
                                          textAlign: TextAlign.left,
                                        )),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Posted on $create_formattedDate',
                                            style: const TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf')
                                                .copyWith(
                                                    fontSize: 10,
                                                    color: Colors.grey)),
                                        Text('Updated on $update_formattedDate',
                                            style: const TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf')
                                                .copyWith(
                                                    fontSize: 10,
                                                    color: Colors.grey))
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 140,
                                            child: Row(
                                              children: [
                                                //Image.asset('assets/like1.png',height: 25,width: 40,),
                                                Container(
                                                    child: like == "0"
                                                        ? GestureDetector(
                                                            child: Image.asset(
                                                              'assets/like.png',
                                                              height: 20,
                                                              width: 40,
                                                            ),
                                                            onTap: () {
                                                              Prodlike();
                                                              like = '1';
                                                              int add =
                                                                  likecount!;
                                                              add++;
                                                              likecount = add;

                                                              setState(() {});
                                                            },
                                                          )
                                                        : GestureDetector(
                                                            child: Image.asset(
                                                              'assets/like1.png',
                                                              height: 20,
                                                              width: 40,
                                                            ),
                                                            onTap: () {
                                                              Prodlike();
                                                              like = '0';
                                                              int add =
                                                                  likecount!;
                                                              add--;
                                                              likecount = add;
                                                              setState(() {});
                                                            },
                                                          )),
                                                Text('Interested ($likecount)',
                                                    style: const TextStyle(
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Color.fromARGB(
                                                            255, 0, 91, 148),
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf'))
                                              ],
                                            )),
                                        SizedBox(
                                            width: 130,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/view1.png',
                                                  height: 25,
                                                  width: 40,
                                                ),
                                                Text('Views ($viewcount)',
                                                    style: const TextStyle(
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Color.fromARGB(
                                                            255, 0, 91, 148),
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf'))
                                              ],
                                            )),
                                        GestureDetector(
                                          onTap: () {
                                            shareImage(
                                                url: main_product.toString());
                                          },
                                          child: SizedBox(
                                              width: 90,
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/send2.png',
                                                    height: 25,
                                                    width: 40,
                                                  ),
                                                  const Text('Send',
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color.fromARGB(
                                                              255, 0, 91, 148),
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf'))
                                                ],
                                              )),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              // margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                              padding: const EdgeInsets.only(
                                  top: 5.0, left: 2.0, right: 2.0, bottom: 2),
                              height: 100,
                              //transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              other_user_profile(user_id!),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                width: 70.0,
                                                height: 70.0,
                                                margin: const EdgeInsets.only(top: 3),
                                                decoration: BoxDecoration(
                                                  //color:  Colors.blue,
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        user_image.toString()),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  shape: BoxShape.circle,
                                                  // borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xffFFC107),
                                                    width: 2.0,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(3.0),
                                                transform:
                                                    Matrix4.translationValues(
                                                        0.0, -10.0, 0.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color:
                                                      const Color(0xffFFC107),
                                                ),
                                                child: const Text(
                                                  'Premium',
                                                  style: TextStyle(fontSize: 9),
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      other_user_profile(
                                                          user_id!),
                                                ),
                                              );
                                            },
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.2,
                                              height: 80,
                                              /*  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(5.0)),
                                                    border: Border.all(
                                                      color:
                                                          const Color(0xffFFC107),
                                                      width: 2.0,
                                                    ),
                                                  ),*/
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10.0, 0.0, 0.0, 5.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        usernm.toString(),
                                                        softWrap: false,
                                                        style: const TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-SemiBold.otf',
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        bussiness_type
                                                            .toString(),
                                                        softWrap: false,
                                                        style: const TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf',
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      child: Row(
                                                        children: [
                                                          const ImageIcon(
                                                              AssetImage(
                                                                  'assets/location.png')),
                                                          Expanded(
                                                            child: Text(
                                                              location
                                                                  .toString(),
                                                              softWrap: false,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'assets/fonst/Metropolis-Black.otf',
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    children: [
                                      Expanded(child: Container()),
                                      Container(
                                        height: 35,
                                        width: 72,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: const Color.fromARGB(
                                              255, 0, 91, 148),
                                        ),
                                        child: is_Follow == "0"
                                            ? GestureDetector(
                                                onTap: () {
                                                  followUnfollowUser("1");
                                                  is_Follow = "1";
                                                  setState(() {});
                                                },
                                                child: const Center(
                                                  child: Text('Follow',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                              )
                                            : GestureDetector(
                                                // onTap: () {
                                                //   followUnfollowUser("0");
                                                //   is_Follow = "0";
                                                //   setState(() {});
                                                // },
                                                child: const Center(
                                                  child: Text('Followed',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                              ),
                                      ),
                                      Expanded(child: Container()),
                                      Container(
                                        height: 35,
                                        width: 72,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: const Color.fromARGB(
                                              255, 0, 91, 148),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (_) => const Chat()));
                                          },
                                          child: const Center(
                                            child: Text('Chat',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                                textAlign: TextAlign.center),
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Container()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.fromLTRB(
                                    15.0, 5.0, 15.0, 0.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text('Similar Posts',
                                      style: const TextStyle(
                                              fontSize: 26.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf')
                                          .copyWith(fontSize: 17),
                                      textAlign: TextAlign.left),
                                )),
                          ],
                        ),
                      ),
                    ]),
                    category()
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
                        : Container()));
  }

  Widget slider() {
    return GFCarousel(
      height: 300,
      autoPlay: false,
      pagerSize: 2.0,
      viewportFraction: 1.0,
      aspectRatio: 2,
      reverse: false,
      items: imagelist.map(
        (url) {
          return GestureDetector(
            onTap: () {
              _showImageSliderDialog(context);
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              child: Image.network(url, fit: BoxFit.cover, width: 1500.0),
            ),
          );
        },
      ).toList(),
      onPageChanged: (index) {
        setState(() {
          index;
          //cat_data.clear();
        });
      },
    );
  }

  Widget category() {
    return FutureBuilder(
        //future: load_category(),
        builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      if (snapshot.connectionState == ConnectionState.none &&
          snapshot.hasData == null) {
        return const Center(child: CircularProgressIndicator());
      } else {
        //List<dynamic> users = snapshot.data as List<dynamic>;
        return simmilar_post_buyer.isNotEmpty
            ? GridView.builder(
                //padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                padding: const EdgeInsets.only(top: 5.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  // crossAxisCount: 2,
                  // mainAxisSpacing: 5,
                  // crossAxisSpacing: 5,
                  // childAspectRatio: .90,
                  childAspectRatio: MediaQuery.of(context).size.width / 620,
                  /*childAspectRatio: MediaQuery.of(context).size.height /
                      1400,*/ //MediaQuery.of(context).size.aspectRatio * 1.3,
                  // mainAxisSpacing: 1.0,
                  crossAxisCount: 2,
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollercontroller,
                itemCount: simmilar_post_buyer.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  similar_prod.Result result = simmilar_post_buyer[index];
                  return GestureDetector(
                    onTap: (() {

                    }),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(children: [
                        Stack(fit: StackFit.passthrough, children: <Widget>[
                          Container(
                            height: 165,
                            width: 175,
                            margin: const EdgeInsets.all(5.0),
                            decoration: const BoxDecoration(
                                //color: Colors.black26,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              /*shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(10.0)),*/
                              child: Image(
                                image: NetworkImage(
                                    result.mainproductImage.toString()),
                                fit: BoxFit.cover,
                                height: 150,
                                width: 170,
                              ),
                            ),
                            /* child:Image(
                                  errorBuilder: (context, object, trace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromARGB(
                                            255, 223, 220, 220),
                                      ),
                                    );
                                  },
                                  image: NetworkImage(result.mainproductImage.toString()),fit: BoxFit.cover,width: 170,height: 150,
                              ),*/
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 0, 148, 95),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              // color: Color.fromARGB(0,255, 255, 255),
                              child: Text('₹${result.productPrice}',
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w800,
                                      fontFamily:
                                          'assets/fonst/Metropolis-Black.otf',
                                      color: Colors.white)),
                            ),
                          ),
                        ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 10.0),
                                  child: Text(result.postName.toString(),
                                      style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets/fonst/Metropolis-SemiBold.otf'),
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis)),
                            ),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 10.0),
                                  child: Text(
                                      '${result.productType} | ${result.productGrade}',
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.grey,
                                        fontFamily: 'Metropolis',
                                      ),
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                )),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 10.0),
                                  child:
                                      Text('${result.state},${result.country}',
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.grey,
                                            fontFamily: 'Metropolis',
                                          ),
                                          softWrap: false,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                )),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 10.0),
                                  child: Text(
                                    result.postType.toString(),
                                    style: const TextStyle(
                                        fontSize: 13.0,
                                        fontFamily: 'Metropolis',
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(0, 148, 95, 1)),
                                  ),
                                )),
                          ],
                        )
                      ]),
                    ),
                  );
                },
              )
            : const Text('Post Not Found');
      }
    });
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      Fluttertoast.showToast(msg: widget.post_type.toString());
      if (widget.post_type == 'BuyPost') {
        get_BuyerPostDatil();
        get_ral_buyerpost();
      } else if (widget.post_type == 'SalePost') {
        get_SalePostDatil();
        get_ral_salerpost();
      }

      // get_data();
    }
  }

  get_BuyerPostDatil() async {
    CommonPostdetail commonPostdetail = CommonPostdetail();
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getPost_datail(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        widget.prod_id.toString(),
        notiId.toString());
    var jsonArray, subjsonarray, color_array;
    if (res['status'] == 1) {
      commonPostdetail = CommonPostdetail.fromJson(res);
      List<postdetail.Result>? results = commonPostdetail.result;

      if (results != null && results.isNotEmpty) {
        postdetail.Result firstResult = results[0];
        postHaxCodeColors = firstResult.postHaxCodeColor;
      }
      if (res['result'] != null) {
        jsonArray = res['result'];

        for (var data in jsonArray) {
          cate_name = data['CategoryName'];
          Grade = data['ProductGrade'];
          type = data['ProductType'];
          qty = data['PostQuntity'];
          prod_desc = data['Description'];
          Grade = data['ProductGrade'];
          product_status = data['product_status'];
          price = data['ProductPrice'];
          prod_nm = data['PostName'];
          create_date = data['new_created_date'];
          update_date = data['new_updated_date'];
          location = data['Location'];
          like = data['isLike'];
          subjsonarray = data['subproductImage'];
          color_array = data['PostHaxCodeColor'];
          likecount = data['likeCount'];
          isFavorite = data['isFavorite'];
          is_Follow = data['isFollow'];
          viewcount = data['isView'];
          unit = data['Unit'];
          usernm = data['Username'];
          user_id = data['UserId'];
          price_unit = data['unit_of_price'] ?? "";
          user_image = data['UserImage'];
          bussiness_type = data['BusinessType'];
          main_product = data['mainproductImage'];
        }

        imagelist.add(main_product!);

        //var date = Jiffy.parse("12.04.2020", pattern: "dd.MM.yyyy").format("dd, Oct yy");
        //11-05-2023
        DateFormat format = DateFormat("dd-MM-yyyy");
        var curret_date = format.parse(create_date);
        var updat_date = format.parse(update_date);
        DateTime? dt1 = DateTime.parse(curret_date.toString());
        DateTime? dt2 = DateTime.parse(updat_date.toString());
        // print(dt1);
        create_formattedDate =
            dt1 != null ? DateFormat('dd MMMM, yyyy').format(dt1) : "";
        update_formattedDate =
            dt2 != null ? DateFormat('dd MMMM, yyyy').format(dt2) : "";

      }
      if (color_array != null) {
        for (var data in color_array) {
          postdetail.PostHaxCodeColor record = postdetail.PostHaxCodeColor(
              colorName: data['colorName'], haxCode: data['HaxCode']);
          colors.add(record);
        }
      }
      if (subjsonarray != null) {
        for (var data in subjsonarray) {
          main_product = data['sub_image_url'];
          imagelist.add(main_product!);
        }
      }

      load = true;
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonArray;
    setState(() {});
  }

  get_SalePostDatil() async {
    CommonPostdetail commonPostdetail = CommonPostdetail();
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getPost_datail1(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        widget.prod_id.toString(),
        notiId.toString());
    var jsonArray, subjsonarray, color_array;

    if (res['status'] == 1) {
      commonPostdetail = CommonPostdetail.fromJson(res);
      List<postdetail.Result>? results = commonPostdetail.result;

      if (results != null && results.isNotEmpty) {
        postdetail.Result firstResult = results[0];
        postHaxCodeColors = firstResult.postHaxCodeColor;
      }
      if (res['result'] != null) {
        jsonArray = res['result'];

        for (var data in jsonArray) {
          cate_name = data['CategoryName'];
          Grade = data['ProductGrade'];
          type = data['ProductType'];
          qty = data['PostQuntity'];
          prod_desc = data['Description'];
          Grade = data['ProductGrade'];
          product_status = data['product_status'];
          price = data['ProductPrice'];
          prod_nm = data['PostName'];
          create_date = data['new_created_date'];
          update_date = data['new_updated_date'];
          location = data['Location'];
          like = data['isLike'];
          subjsonarray = data['subproductImage'];
          color_array = data['PostHaxCodeColor'];
          likecount = data['likeCount'];
          isFavorite = data['isFavorite'];
          is_Follow = data['isFollow'];
          viewcount = data['isView'];
          unit = data['Unit'];
          price_unit = data['unit_of_price'];
          usernm = data['Username'];
          user_id = data['UserId'];
          price_unit = data['unit_of_price'] ?? "";
          user_image = data['UserImage'];
          bussiness_type = data['BusinessType'];
          main_product = data['mainproductImage'];
        }

        imagelist.add(main_product!);
        DateFormat format = DateFormat("dd-MM-yyyy");
        var curret_date = format.parse(create_date);
        var updat_date = format.parse(update_date);
        DateTime? dt1 = DateTime.parse(curret_date.toString());
        DateTime? dt2 = DateTime.parse(updat_date.toString());

        create_formattedDate =
            dt1 != null ? DateFormat('dd MMMM, yyyy').format(dt1) : "";
        update_formattedDate =
            dt2 != null ? DateFormat('dd MMMM, yyyy').format(dt2) : "";
      }
      if (color_array != null) {
        for (var data in color_array) {
          postdetail.PostHaxCodeColor record = postdetail.PostHaxCodeColor(
              colorName: data['colorName'], haxCode: data['HaxCode']);
          colors.add(record);
        }
      }

      if (subjsonarray != null) {
        for (var data in subjsonarray) {
          main_product = data['sub_image_url'];

          imagelist.add(main_product!);
        }
      }
      load = true;
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonArray;
  }

  getadd_product() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await addfav(pref.getString('user_id').toString(),
        pref.getString('api_token').toString(), widget.prod_id.toString());
    var jsonArray;

    if (res['status'] == 1) {
      jsonArray = res['result'];
      Fluttertoast.showToast(msg: res['message']);
      prod_like = true;


      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonArray;
  }

  getremove_product() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await removefav(pref.getString('user_id').toString(),
        pref.getString('api_token').toString(), widget.prod_id.toString());
    var jsonArray;

    if (res['status'] == 1) {
      jsonArray = res['result'];
      Fluttertoast.showToast(msg: res['message']);
      prod_like = false;

      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonArray;
  }

  Future<void> followUnfollowUser(isFollow) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await followUnfollow(
      isFollow.toString(),
      user_id.toString(),
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );

    var jsonArray;

    if (response['status'] == 1) {
      Fluttertoast.showToast(msg: response['message']);
    } else {
      Fluttertoast.showToast(msg: response['message']);
    }
    setState(() {});
    return jsonArray;
  }

  getcolorlist() {
    Expanded(
      child: FutureBuilder(
          builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.hasData == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {

          return ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: colors.length,
              itemBuilder: (context, index) {
                postdetail.PostHaxCodeColor record = colors[index];

                return Row(children: [
                  Icon(
                    Icons.circle,
                    size: 15,
                    color: Color(int.parse(record.haxCode.toString())),
                  ),
                  Text(record.colorName.toString())
                ]);
              });
        }
      }),
    );
  }

  get_ral_buyerpost() async {
    var res = await similar_product_buyer(
        widget.prod_id.toString(), '20', offset.toString());
    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];

        for (var data in jsonArray) {
          similar_prod.Result record = similar_prod.Result(
              postName: data['PostName'],
              categoryName: data['CategoryName'],
              productGrade: data['ProductGrade'],
              currency: data['Currency'],
              productPrice: data['ProductPrice'],
              state: data['State'],
              country: data['Country'],
              postType: data['PostType'],
              // isPaidPost: data['is_paid_post'],
              productId: data['productId'],
              productType: data['ProductType'],
              mainproductImage: data['mainproductImage']);

          simmilar_post_buyer.add(record);
        }
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonArray;
  }

  void _showImageSliderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.all(5.0),
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 7.0),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                PhotoViewGallery.builder(
                  customSize: Size.fromHeight(
                      MediaQuery.of(context).size.height / 1.12),
                  itemCount: imagelist.length,
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(imagelist[index]),
                      minScale: PhotoViewComputedScale.contained / 5.0,
                      maxScale: PhotoViewComputedScale.covered * 2.0,
                    );
                  },
                  scrollPhysics: const BouncingScrollPhysics(),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  pageController: PageController(initialPage: 0),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.all(5.0),
          insetPadding: EdgeInsets.zero,
          // Remove any additional padding around the dialog
          contentPadding: EdgeInsets.zero,
          // Remove padding around the content

          content: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close_rounded)),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.15,
                  padding: const EdgeInsets.symmetric(horizontal: 7.0),
                  child: InteractiveViewer(
                    child: Image.network(
                      imagelist[0],
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      //height: 345,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  get_ral_salerpost() async {
    var res = await similar_product_saler(
        widget.prod_id.toString(), '20', offset.toString());

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];

        for (var data in jsonArray) {
          similar_prod.Result record = similar_prod.Result(
              postName: data['PostName'],
              categoryName: data['CategoryName'],
              productGrade: data['ProductGrade'],
              currency: data['Currency'],
              productPrice: data['ProductPrice'],
              state: data['State'],
              country: data['Country'],
              postType: data['PostType'],
              // isPaidPost: data['is_paid_post'],
              productId: data['productId'],
              productType: data['ProductType'],
              mainproductImage: data['mainproductImage']);

          simmilar_post_saler.add(record);
        }
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonArray;
    setState(() {});
  }

  void _scrollercontroller() {
    if (scrollercontroller.position.pixels ==
        scrollercontroller.position.maxScrollExtent) {
      if (simmilar_post_buyer.isNotEmpty) {
        count++;
        if (count == 1) {
          offset = offset + 31;
        } else {
          offset = offset + 20;
        }
        _onLoading();
        get_ral_buyerpost();
      } else if (simmilar_post_saler.isNotEmpty) {
        count++;
        if (count == 1) {
          offset = offset + 31;
        } else {
          offset = offset + 20;
        }
        _onLoading();
        get_ral_salerpost();
      }
    }
  }

  void _onLoading() {
    BuildContext dialogContext = context;

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
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(dialogContext).pop();
    });
  }

  void shareImage({required String url}) async {
    final imageurl = url;
    final uri = Uri.parse(imageurl);
    final response = await http.get(uri);
    final bytes = response.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);
    await Share.shareFiles([path],
        text: prod_nm! +
            '\n' +
            qty +
            unit! +
            '\n' +
            Grade +
            type +
            "\t" +
            "\n" +
            "\n" +
            'Hey check out my app at: https://play.google.com/store/apps/details?id=' +
            packageName!);
  }

  Future<void> Prodlike() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await product_like(
        widget.prod_id.toString(),
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString());

    var jsonArray;
    if (res['status'] == 1) {
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonArray;
  }
}
