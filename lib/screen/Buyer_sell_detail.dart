// ignore_for_file: unnecessary_null_comparison, depend_on_referenced_packages, camel_case_types, must_be_immutable, prefer_interpolation_to_compose_strings, non_constant_identifier_names, prefer_typing_uninitialized_variables, library_prefixes

import 'dart:core';
import 'dart:io';

import 'package:Plastic4trade/model/CommonPostdetail.dart' as postdetail;
import 'package:Plastic4trade/model/getsimilar_product.dart' as similar_prod;
import 'package:Plastic4trade/screen/other_user_profile.dart';
import 'package:Plastic4trade/utill/constant.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';
import '../model/CommonPostdetail.dart';
import '../model/get_product_interest.dart' as interest;
import '../model/get_product_interest.dart';
import '../model/get_product_share.dart' as productShare;
import '../model/get_product_share.dart';
import '../model/get_product_view.dart' as viewInterest;
import '../model/get_product_view.dart';
import '../widget/HomeAppbar.dart';
import 'ChartDetail.dart';

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
  int? likecount, viewcount, is_prime;
  String? isFavorite = "0", unit = "", price_unit = "";
  String profileid = "";
  String is_Follow = "";
  String selfUserId = "";

  int? isView, user_id;
  String? product_status;
  String? prod_desc;
  String? prod_nm;
  String? loc;
  String create_date = "";
  String update_date = "";
  bool load = false;
  String? location;
  List<postdetail.PostHaxCodeColor>? postHaxCodeColors = [];

  String? bussiness_type;
  String? user_image, main_product;
  var create_formattedDate, update_formattedDate;
  List<String> imagelist = [];
  int getSliderIndex = 0;
  List<similar_prod.Result> simmilar_post_buyer = [];
  List<similar_prod.Result> simmilar_post_saler = [];

  List<postdetail.PostHaxCodeColor> colors = [];
  String? follow;
  String like = "0";
  String? fav;
  Future? getRalSalerpostFuture;
  Future? getRalBuyerpostFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("$selfUserId == ${user_id.toString()}");
    scrollercontroller.addListener(_scrollercontroller);
    getPackage();
    checknetowork();
  }

  void getPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
    packageName = packageInfo!.packageName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDADADA),
      body: load == true
          ? SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: <Widget>[
                      SizedBox(
                        height: 720,
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
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              )
                            : slider(),
                      ),
                      Positioned(
                        top: 30,
                        left: 15,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 38,
                            height: 38,
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              color: Colors.white.withOpacity(0.15000000596046448),
                              shape: const OvalBorder(),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        top: 30,
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              alignment: Alignment.center,
                              decoration: ShapeDecoration(
                                color: Colors.white.withOpacity(0.15000000596046448),
                                shape: const OvalBorder(),
                              ),
                              child: isFavorite == "1"
                                  ? GestureDetector(
                                onTap: () {
                                  print("data:-$isFavorite");
                                  getremove_product();
                                },
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red.shade400,
                                ),
                              )
                                  : GestureDetector(
                                onTap: () {
                                  print("data:-$isFavorite");
                                  setState(() {
                                    if(isFavorite == "1"){
                                      getremove_product();
                                    }else{
                                      getadd_product();
                                    }
                                  });
                                },
                                child: Icon(
                                  isFavorite == "1" ? Icons.favorite : Icons.favorite_border_outlined,
                                  color: isFavorite == "1" ?Colors.red.shade400 : Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                shareImage(
                                    url: main_product.toString(),
                                    share: "post",
                                  context: context
                                );

                              },
                              child: Container(
                                width: 38,
                                height: 38,
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  color: Colors.white.withOpacity(0.15000000596046448),
                                  shape: const OvalBorder(),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 250,
                        left: 10,
                        right: 10,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.05),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x3FA6A6A6),
                                    blurRadius: 16.32,
                                    offset: Offset(0, 3.26),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              //transform: Matrix4.translationValues(0.0, -50.0, 0.0),

                              //height: 320,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      prod_nm.toString(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontFamily: 'assets/fonst/Metropolis-Black.otf',
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.24,
                                    ),),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 26,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFF00945E),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              ' ₹$price',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontFamily: 'assets/fonst/Metropolis-Black.otf',
                                                  fontWeight: FontWeight.w800,
                                                  height: 0.09,
                                                  letterSpacing: -0.24,),
                                            ),
                                            price_unit != null && price_unit != "null" && price_unit != "" && price_unit!.isNotEmpty?Text(
                                              '/$price_unit ',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontFamily: 'assets/fonst/Metropolis-Black.otf',
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: -0.24,),
                                            ) : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Container(
                                        height: 26,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                                        decoration: ShapeDecoration(
                                          color: const Color(0x3000945E),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                        ),
                                        child: Text(
                                          product_status.toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontFamily: 'assets/fonst/Metropolis-SemiBold.otf',
                                              fontWeight: FontWeight.w500,
                                              height: 0.12,
                                              letterSpacing: -0.24,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Container(
                                        height: 26,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 1,
                                              color: Colors.black.withOpacity(0.1899999976158142),
                                            ),
                                            borderRadius: BorderRadius.circular(40),
                                          ),
                                        ),
                                        child: Text(
                                          (widget.post_type == 'BuyPost')
                                              ? "Buy Post"
                                              : (widget.post_type == 'SalePost')
                                                  ? "Sale Post"
                                                  : "",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontFamily: 'assets/fonst/Metropolis-SemiBold.otf',
                                              fontWeight: FontWeight.w500,
                                              height: 0.12,
                                              letterSpacing: -0.24,
                                             ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  _buildCommanData(title: "Category",data: cate_name),
                                  _buildCommanData(title: "Type",data: type),
                                  _buildCommanData(title: "Grade",data: Grade),
                                  _buildCommanData(title: "Quantity",data: "$qty $unit"),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const SizedBox(
                                        width: 80,
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
                                        child: SizedBox(
                                          width: 100,
                                          height: 45,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemCount:
                                                postHaxCodeColors?.length ?? 0,
                                            itemBuilder: (context, colorIndex) {
                                              postdetail.PostHaxCodeColor
                                                  result = postHaxCodeColors![
                                                      colorIndex];
                                              String colorString =
                                                  result.haxCode.toString();
                                              String newStr =
                                                  colorString.substring(1);

                                              Color colors = Color(
                                                int.parse(newStr, radix: 16),
                                              ).withOpacity(1.0);
                                              return Container(
                                                alignment: Alignment.center,
                                                width: 50,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    newStr == 'ffffff'
                                                        ? const Icon(
                                                            Icons
                                                                .circle_outlined,
                                                            size: 18)
                                                        : Icon(
                                                            Icons
                                                                .circle_rounded,
                                                            size: 18,
                                                            color: colors),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
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
                                                        overflow: TextOverflow
                                                            .visible,
                                                        maxLines: 1,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      prod_desc.toString(),
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets/fonst/Metropolis-SemiBold.otf',
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Posted on $create_formattedDate',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'assets/fonst/Metropolis-Black.otf')
                                      ),
                                      Text(
                                        'Updated on $update_formattedDate',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'assets/fonst/Metropolis-Black.otf')
                                      )
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            child: like == "0"
                                                ? GestureDetector(
                                                    child: Image.asset(
                                                      'assets/like.png',
                                                      height: 24,
                                                      width: 40,
                                                    ),
                                                    onTap: () {
                                                      Prodlike();
                                                      like = '1';
                                                      int add = likecount!;
                                                      add++;
                                                      likecount = add;

                                                      setState(() {});
                                                    },
                                                  )
                                                : GestureDetector(
                                                    child: Image.asset(
                                                      'assets/like1.png',
                                                      height: 24,
                                                      width: 40,
                                                    ),
                                                    onTap: () {
                                                      Prodlike();
                                                      like = '0';
                                                      int add = likecount!;
                                                      add--;
                                                      likecount = add;
                                                      setState(() {});
                                                    },
                                                  ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              ViewItem(context: context,tabIndex: 0);
                                            },
                                            child: Text(
                                              'Interested ($likecount)',
                                              style: const TextStyle(
                                                  color: Color(0xFF005C94),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: -0.24,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-Black.otf'),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {},
                                            child: Image.asset(
                                              'assets/view1.png',
                                              height: 24,
                                              width: 40,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              ViewItem(context: context,tabIndex: 1);
                                            },
                                            child: Text(
                                              'Views ($viewcount)',
                                              style: const TextStyle(
                                                  color: Color(0xFF005C94),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: -0.24,
                                                  fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf'),
                                            ),
                                          )
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          sharecount();
                                          shareImage(
                                            url: main_product.toString(),
                                            share: "post",
                                            context: context
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(
                                              'assets/send2.png',
                                              height: 24,
                                              width: 40,
                                            ),
                                            const Text(
                                              'Share',
                                              style: TextStyle(
                                                  color: Color(0xFF005C94),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: -0.24,
                                                  fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf'),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 9,
                            ),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.05),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x3FA6A6A6),
                                    blurRadius: 16.32,
                                    offset: Offset(0, 3.26),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: 51,
                                              height: 51,
                                              decoration: ShapeDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    user_image.toString(),
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                                shape: OvalBorder(
                                                  side: BorderSide(
                                                    width: 2,
                                                    strokeAlign: BorderSide.strokeAlignOutside,
                                                    color: (is_prime == 0) ? const Color(0xFF005C94) : const Color(0xFFFFC107),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 49,
                                              height: 13,
                                              alignment: Alignment.center,
                                              transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                              decoration: ShapeDecoration(
                                                color: (is_prime == 0) ? const Color(0xFF005C94) :  const Color(0xffFFC107),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(40),
                                                ),
                                              ),
                                              child: Text(
                                                (is_prime == 0) ? "Free" : 'Premium',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: (is_prime == 0) ? Colors.white : Colors.black,
                                                  fontSize: 9,
                                                  fontFamily: 'assets/fonst/Metropolis-SemiBold.otf',
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: -0.24,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 13),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width / 2.2,
                                              child: Text(
                                                usernm.toString(),
                                                style: const TextStyle(
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: -0.24,
                                                  fontFamily: 'assets/fonst/Metropolis-SemiBold.otf',
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width / 2.2,
                                              child: Text(
                                                bussiness_type.toString(),
                                                style: TextStyle(
                                                  overflow: TextOverflow.ellipsis,
                                                  color: Colors.black.withOpacity(0.50),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'assets/fonst/Metropolis-Black.otf',
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const ImageIcon(
                                                  AssetImage('assets/location.png'),
                                                  size: 15,
                                                ),
                                                const SizedBox(width: 3),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width / 2.2,
                                                  child: Text(
                                                    location.toString(),
                                                    style: const TextStyle(
                                                      overflow: TextOverflow.ellipsis,
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400,
                                                      letterSpacing: -0.24,
                                                      fontFamily: 'assets/fonst/Metropolis-Black.otf',
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  (selfUserId == user_id.toString())
                                      ? Container()
                                      : Row(
                                          children: [
                                            GestureDetector(
                                              onTap: is_Follow == "0" ? () {
                                                followUnfollowUser("1");
                                                is_Follow = "1";
                                                setState(() {});
                                              } : (){},
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 32,
                                                    height: 32,
                                                    alignment: Alignment.center,
                                                    decoration: const ShapeDecoration(
                                                      color: Color(0xFF005C94),
                                                      shape: OvalBorder(),
                                                    ),
                                                    child: Image.asset("assets/follow1.png",fit: BoxFit.cover),
                                                  ),
                                                  Text(
                                                    is_Follow == "0" ? 'Follow' : 'Followed',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: Color(0xFF005C94),
                                                      fontSize: 11,
                                                      fontFamily: 'assets/fonst/Metropolis-Black.otf',
                                                      fontWeight: FontWeight.w700,
                                                      letterSpacing: -0.24,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
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
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: 32,
                                                    height: 32,
                                                    alignment: Alignment.center,
                                                    decoration: const ShapeDecoration(
                                                      color: Color(0xFF005C94),
                                                      shape: OvalBorder(),
                                                    ),
                                                    child: Image.asset("assets/account.png",height: 25,width: 25,fit: BoxFit.cover,color: Colors.white),
                                                  ),
                                                  const Text(
                                                    'Profile',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xFF005C94),
                                                      fontSize: 11,
                                                      fontFamily: 'assets/fonst/Metropolis-Black.otf',
                                                      fontWeight: FontWeight.w700,
                                                      letterSpacing: -0.24,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            // Container(
                                            //   height: 35,
                                            //   width: 72,
                                            //   decoration: BoxDecoration(
                                            //     borderRadius:
                                            //         BorderRadius.circular(15),
                                            //     color: const Color.fromARGB(
                                            //         255, 0, 91, 148),
                                            //   ),
                                            //   child: is_Follow == "0"
                                            //       ? GestureDetector(
                                            //           onTap: () {
                                            //             followUnfollowUser("1");
                                            //             is_Follow = "1";
                                            //             setState(() {});
                                            //           },
                                            //           child: const Center(
                                            //             child: Text('Follow',
                                            //                 style: TextStyle(
                                            //                     fontSize: 11,
                                            //                     fontWeight:
                                            //                         FontWeight
                                            //                             .w600,
                                            //                     color: Colors
                                            //                         .white),
                                            //                 textAlign: TextAlign
                                            //                     .center),
                                            //           ),
                                            //         )
                                            //       : GestureDetector(
                                            //           child: const Center(
                                            //             child: Text('Followed',
                                            //                 style: TextStyle(
                                            //                     fontSize: 11,
                                            //                     fontWeight: FontWeight.w600,
                                            //                     color: Colors.white),
                                            //                 textAlign: TextAlign.center),
                                            //           ),
                                            //         ),
                                            // ),
                                            // GestureDetector(
                                            //   onTap: () {
                                            //     Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //         // builder: (_) => const Chat(),
                                            //          builder: (_) => ChartDetail(
                                            //           user_id!.toString(),
                                            //           usernm.toString(),
                                            //           user_image.toString(),
                                            //         ),
                                            //       ),
                                            //     );
                                            //   },
                                            //   child: Container(
                                            //     height: 35,
                                            //     width: 72,
                                            //     decoration: BoxDecoration(
                                            //       borderRadius:
                                            //           BorderRadius.circular(15),
                                            //       color: const Color.fromARGB(
                                            //           255, 0, 91, 148),
                                            //     ),
                                            //     child: const Center(
                                            //       child: Text('Chat',
                                            //           style: TextStyle(
                                            //               fontSize: 11,
                                            //               fontWeight:
                                            //                   FontWeight.w600,
                                            //               color: Colors.white),
                                            //           textAlign:
                                            //               TextAlign.center),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Card(
                        elevation: 0,
                        color: const Color(0xFFDADADA),
                       // alignment: Alignment.centerLeft,
                        child: Text('Similar Posts',
                            style: const TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontFamily: 'assets/fonst/Metropolis-Black.otf')
                                .copyWith(fontSize: 17),
                            textAlign: TextAlign.left),
                      ),
                    ),
                  ),
                  (widget.post_type == 'BuyPost')
                      ? categoryBuy()
                      : categorySale()
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
    );
  }

  Widget _buildCommanData({required String title,required String data}){
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 90,
              child: Text(
                '$title:',
                style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily:
                    'assets/fonst/Metropolis-SemiBold.otf'),
              ),
            ),
            Text(
              data,
              style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily:
                  'assets/fonst/Metropolis-SemiBold.otf'),
            )
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget slider() {
    return GFCarousel(
      height: 300,
      autoPlay: true,
      pagerSize: 2.0,
      viewportFraction: 1.0,
      aspectRatio: 2,
      items: imagelist.map(
        (url) {
          return GestureDetector(
            onTap: () {
              _showImageSliderDialog(context);
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              child: Image.network(url, fit: BoxFit.cover, width: 1500.0),
            ),
          );
        },
      ).toList(),
      onPageChanged: (index) {
        setState(() {
          getSliderIndex = index;
          //cat_data.clear();
        });
      },
    );
  }

  Widget categoryBuy() {
    return FutureBuilder(
        future: getRalBuyerpostFuture,
        builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      if (snapshot.connectionState == ConnectionState.none &&
          snapshot.hasData == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return simmilar_post_buyer.isNotEmpty
            ? GridView.builder(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: MediaQuery.of(context).size.width / 620,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10
                ),
                physics: const NeverScrollableScrollPhysics(),
                controller: scrollercontroller,
                itemCount: simmilar_post_buyer.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  similar_prod.Result result = simmilar_post_buyer[index];
                  return GestureDetector(
                    onTap: (() async{
                      // constanst.productId = result.productId.toString();
                      // constanst.post_type = result.postType.toString();
                      // constanst.redirectpage = "sale_buy";

                      SharedPreferences pref = await SharedPreferences.getInstance();

                      if(pref.getBool('isWithoutLogin') == true){
                        showLoginDialog(context);
                      } else {
                        print("ID = ${result.productId.toString()}");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Buyer_sell_detail(
                                  prod_id: result.productId.toString(),
                                  post_type: result.postType.toString()),
                            ));
                        // if (constanst.appopencount == constanst.appopencount1) {
                        //
                        //   if (!constanst.isgrade &&
                        //       !constanst.istype &&
                        //       !constanst.iscategory &&
                        //       !constanst.isprofile &&
                        //       constanst.step == 11) {
                        //     print("ID = ${result.productId.toString()}");
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => Buyer_sell_detail(
                        //               prod_id: result.productId.toString(),
                        //               post_type: result.postType.toString()),
                        //         ));
                        //   }  else if (constanst.isprofile) {
                        //     showInformationDialog(context);
                        //   } else if (constanst.iscategory) {
                        //     categoryDialog(context);
                        //   } else if (constanst.isgrade) {
                        //     categoryDialog(context);
                        //   } else if (constanst.istype) {
                        //     categoryDialog(context);
                        //   } else if (constanst.step != 11) {
                        //     addPostDialog(context);
                        //   }
                        // }
                        // else if (constanst.isprofile) {
                        //   showInformationDialog(context);
                        // }
                        // else if (constanst.appopencount ==
                        //     constanst.appopencount1) {
                        //   categoryDialog(context);
                        // } else {
                        //   print("ID = ${result.productId.toString()}");
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => Buyer_sell_detail(
                        //             prod_id: result.productId.toString(),
                        //             post_type: result.postType.toString()),
                        //       ));
                        // }
                      }
                    }),
                    child: Card(
                      color: const Color(0xFFFFFFFF),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.05),
                      ),
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.05),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3FA6A6A6),
                              blurRadius: 16.32,
                              offset: Offset(0, 3.26),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: <Widget>[
                                Container(
                                  height: 165,
                                  width: 175,
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: const BoxDecoration(
                                    //color: Colors.black26,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(13.05),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(13.05),
                                    child: Image(
                                      image: NetworkImage(
                                        result.mainproductImage.toString(),
                                      ),
                                      fit: BoxFit.cover,
                                      height: 150,
                                      width: 170,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5.0),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 0, 148, 95),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    // color: Color.fromARGB(0,255, 255, 255),
                                    child: Text(
                                      '₹${result.productPrice}',
                                      style: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w800,
                                          fontFamily:
                                              'assets/fonst/Metropolis-Black.otf',
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 10.0),
                                    child: Text(result.postName.toString(),
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets/fonst/Metropolis-SemiBold.otf'),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 10.0),
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
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 10.0),
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
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 10.0),
                                    child: Text(
                                      (result.postType.toString() == "BuyPost")
                                          ? "Buy Post"
                                          : "Sell Post",
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        fontFamily: 'Metropolis',
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(0, 148, 95, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Text('Post Not Found');
      }
    });
  }

  Widget categorySale() {
    return FutureBuilder(
      future: getRalSalerpostFuture,
      builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      if (snapshot.connectionState == ConnectionState.none &&
          snapshot.hasData == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return simmilar_post_saler.isNotEmpty
            ? GridView.builder(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: MediaQuery.of(context).size.width / 630,
                  crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10
                ),
                physics: const NeverScrollableScrollPhysics(),
                controller: scrollercontroller,
                itemCount: simmilar_post_saler.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  similar_prod.Result result = simmilar_post_saler[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => Buyer_sell_detail(
                        post_type: result.postType,
                        prod_id: result.productId.toString(),
                      )),);
                    },
                    child: Card(
                      color: const Color(0xFFFFFFFF),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.05),
                      ),
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.05),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x3FA6A6A6),
                              blurRadius: 16.32,
                              offset: Offset(0, 3.26),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: 165,
                                    width: 175,
                                    margin: const EdgeInsets.all(5.0),
                                    decoration: const BoxDecoration(
                                      //color: Colors.black26,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(13.05),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(13.05),
                                      child: Image(
                                        image: NetworkImage(
                                          result.mainproductImage.toString(),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5.0),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 0, 148, 95),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    // color: Color.fromARGB(0,255, 255, 255),
                                    child: Text(
                                      '₹${result.productPrice}',
                                      style: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w800,
                                          fontFamily:
                                              'assets/fonst/Metropolis-Black.otf',
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 10.0),
                                    child: Text(result.postName.toString(),
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets/fonst/Metropolis-SemiBold.otf'),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 10.0),
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
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 10.0),
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
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 10.0),
                                    child: Text(
                                      (result.postType.toString() == "BuyPost")
                                          ? "Buy Post"
                                          : "Sell Post",
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        fontFamily: 'Metropolis',
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(0, 148, 95, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Text('Post Not Found');
      }
    },);
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      Fluttertoast.showToast(
        msg: widget.post_type.toString(),
      );
      print("post_type:-${widget.post_type}");
      if (widget.post_type == 'BuyPost') {
        get_BuyerPostDatil();
        getRalBuyerpostFuture = get_ral_buyerpost();
      } else if (widget.post_type == 'SalePost') {
        get_SalePostDatil();
        getRalSalerpostFuture = get_ral_salerpost();
      }

      // get_data();
    }
  }

  getadd_product() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await addfav(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
      widget.prod_id.toString(),
    );
    var jsonArray;

    if (res['status'] == 1) {
      jsonArray = res['result'];
      Fluttertoast.showToast(msg: res['message']);
      isFavorite = "1";
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonArray;
  }

  getremove_product() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await removefav(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
      widget.prod_id.toString(),
    );

    var jsonArray;

    if (res['status'] == 1) {
      jsonArray = res['result'];
      Fluttertoast.showToast(
        msg: res['message'],
      );
      isFavorite = "0";

      setState(() {});
    } else {
      Fluttertoast.showToast(
        msg: res['message'],
      );
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
      Fluttertoast.showToast(
        msg: response['message'],
      );
    } else {
      Fluttertoast.showToast(
        msg: response['message'],
      );
    }
    setState(() {});
    return jsonArray;
  }

  getcolorlist() {
    Expanded(
      child: FutureBuilder(
        future: get_BuyerPostDatil(),
          builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.hasData == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
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

                return Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 15,
                      color: Color(
                        int.parse(
                          record.haxCode.toString(),
                        ),
                      ),
                    ),
                    Text(
                      record.colorName.toString(),
                    )
                  ],
                );
              });
        }
      }),
    );
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
                      imageProvider: NetworkImage(
                        imagelist[index],
                      ),
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
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.2,
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

  get_ral_buyerpost() async {
    var res = await similar_product_buyer(
      widget.prod_id.toString(),
      '20',
      offset.toString(),
    );
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
            mainproductImage: data['mainproductImage'],
          );

          simmilar_post_buyer.add(record);
        }
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(
        msg: res['message'],
      );
    }
    return jsonArray;
  }

  get_ral_salerpost() async {
    var res = await similar_product_saler(
      widget.prod_id.toString(),
      '20',
      offset.toString(),
    );

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
            mainproductImage: data['mainproductImage'],
          );

          simmilar_post_saler.add(record);
        }
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(
        msg: res['message'],
      );
    }
    return jsonArray;
  }

  get_BuyerPostDatil() async {
    CommonPostdetail commonPostdetail = CommonPostdetail();
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getPost_datail(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
      widget.prod_id.toString(),
      notiId.toString(),
    );

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
          is_prime = data['is_prime'];
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

        DateFormat format = DateFormat("dd-MM-yyyy");
        var curret_date = format.parse(create_date);
        var updat_date = format.parse(update_date);
        DateTime? dt1 = DateTime.parse(
          curret_date.toString(),
        );
        DateTime? dt2 = DateTime.parse(
          updat_date.toString(),
        );
        // print(dt1);
        create_formattedDate =
        dt1 != null ? DateFormat('dd MMMM, yyyy').format(dt1) : "";
        update_formattedDate =
        dt2 != null ? DateFormat('dd MMMM, yyyy').format(dt2) : "";
      }
      if (color_array != null) {
        for (var data in color_array) {
          postdetail.PostHaxCodeColor record = postdetail.PostHaxCodeColor(
            colorName: data['colorName'],
            haxCode: data['HaxCode'],
          );
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
      Fluttertoast.showToast(
        msg: res['message'],
      );
    }
    return jsonArray;
  }

  get_SalePostDatil() async {
    CommonPostdetail commonPostdetail = CommonPostdetail();
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getPost_datail1(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
      widget.prod_id.toString(),
      notiId.toString(),
    );

    selfUserId = pref.getString('user_id').toString();

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
          is_prime = data['is_prime'];
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
        DateTime? dt1 = DateTime.parse(
          curret_date.toString(),
        );
        DateTime? dt2 = DateTime.parse(
          updat_date.toString(),
        );

        create_formattedDate =
        dt1 != null ? DateFormat('dd MMMM, yyyy').format(dt1) : "";
        update_formattedDate =
        dt2 != null ? DateFormat('dd MMMM, yyyy').format(dt2) : "";
      }
      if (color_array != null) {
        for (var data in color_array) {
          postdetail.PostHaxCodeColor record = postdetail.PostHaxCodeColor(
            colorName: data['colorName'],
            haxCode: data['HaxCode'],
          );
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
      Fluttertoast.showToast(
        msg: res['message'],
      );
    }
    return jsonArray;
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
        getRalBuyerpostFuture =  get_ral_buyerpost();
      } else if (simmilar_post_saler.isNotEmpty) {
        count++;
        if (count == 1) {
          offset = offset + 31;
        } else {
          offset = offset + 20;
        }
        _onLoading();
        getRalSalerpostFuture = get_ral_salerpost();
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
                          : Container(),
                ),
              ),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(dialogContext).pop();
    });
  }

  void shareImage({required String url,required String share,required BuildContext context}) async {
    final imageurl = url;
    final uri = Uri.parse(imageurl);
    final response = await http.get(uri);
    final bytes = response.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);
    await Share.shareFiles([path],
        text: share == "post" ? prod_nm! + '\n' + cate_name + '\n' + type + '\n' + Grade + '\n' + qty + unit! + "\t" + "\n" + "\n" +
            'Hey check out my app at: https://play.google.com/store/apps/details?id=' + packageName! :
        prod_nm! + '\n' + price + '\n' + cate_name + '\n' + type + '\n' + Grade + '\n' + constanst.post_type + '\n' + qty + unit! + '\n' +
            postHaxCodeColors!.first.colorName.toString()
            + '\n' + prod_desc.toString() + '\n' +  product_status.toString() + '\n' +  create_formattedDate + '\n' +  update_formattedDate,
    );
  }
  //
  // void _onShareWithResult({required String url,required String share,required BuildContext context}) async {
  //   final box = context.findRenderObject() as RenderBox?;
  //     final files = <XFile>[];
  //       files.add(XFile(url, name: "image.jpg"));
  //      await Share.shareXFiles(files,
  //         text: "$share",
  //         subject: "send",
  //         sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  // }

  Future<void> Prodlike() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await product_like(
      widget.prod_id.toString(),
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );

    var jsonArray;
    if (res['status'] == 1) {
      Fluttertoast.showToast(
        msg: res['message'],
      );
    } else {
      Fluttertoast.showToast(
        msg: res['message'],
      );
    }
    setState(() {});
    return jsonArray;
  }

  ViewItem({required BuildContext context, int tabIndex = 0}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          // <-- SEE HERE
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize:
              0.60, // Initial height as a fraction of screen height
          builder: (BuildContext context, ScrollController scrollController) {
            return StatefulBuilder(
              builder: (context, setState) {
                return ViewWidget(
                  profileid: profileid.toString(),
                  prod_id: widget.prod_id.toString(),
                  tabIndex: tabIndex,
                );
              },
            );
          }),
    ).then(
      (value) {},
    );
  }

  Future<void> sharecount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getProductShareCount(
      pref.getString('user_id').toString(),
      widget.prod_id,
    );

    if (res['status'] == 1) {
      if (mounted) {
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
  }
}

class ViewWidget extends StatefulWidget
{
  String profileid;
  String prod_id;
  int tabIndex = 0;

  ViewWidget({Key? key,required this.profileid, required this.prod_id, required this.tabIndex,}) : super(key: key);

  @override
  State<ViewWidget> createState() => _ViewWidgetState();
}

class _ViewWidgetState extends State<ViewWidget>
    with SingleTickerProviderStateMixin {
  bool? isload;
  late TabController _tabController;
  List<interest.Result> dataList = [];
  List<viewInterest.Data> dataList1 = [];
  List<productShare.Data> dataList2 = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this,initialIndex: widget.tabIndex);
    getInterest(widget.prod_id);
    getViews(widget.prod_id);
    getShare(widget.profileid, widget.prod_id);
  }

  getInterest(prod_id) async {
    ApiResponse common = ApiResponse();
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getProductInterest(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
      widget.prod_id.toString(),
    );
    if (res['status'] == 1) {
      common = ApiResponse.fromJson(res);
      dataList = common.result ?? [];
      isload = true;
    } else {}
    setState(() {});
  }

  getViews(prod_id) async {
    GetProductView common = GetProductView();

    var res = await getProductView(prod_id);

    if (res['status'] == 1) {
      common = GetProductView.fromJson(res);
      dataList1 = common.data ?? [];
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {});
  }

  getShare(userId, productId) async {
    ProductShare common = ProductShare();

    var res = await getProductShare(userId, productId);

    if (res['status'] == 1) {
      common = ProductShare.fromJson(res);
      dataList2 = common.data ?? [];
      isload = true;
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isload == true
        ? Column(
            children: [
              const SizedBox(height: 5),
              Image.asset(
                'assets/hori_line.png',
                width: 150,
                height: 5,
              ),
              TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Like'),
                  Tab(text: 'View'),
                  Tab(text: 'Share'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                        padding: const EdgeInsets.all(15),
                        shrinkWrap: true,
                        itemCount: dataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => other_user_profile(
                                          int.parse(dataList[index]
                                              .userId
                                              .toString()))));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image: dataList[index].imageUrl != null
                                            ? NetworkImage(
                                          dataList[index].imageUrl.toString(),
                                        )
                                            : const AssetImage('assets/more.png')
                                        as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      shape: const OvalBorder(),
                                    ),
                                  ),
                                  const SizedBox(width: 9,),
                                  Text(
                                    dataList[index].username ?? "Unknown",
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily:
                                        'assets/fonst/Metropolis-Black.otf'),),
                                ],
                              ),
                            ),
                          );
                        }),
                    ListView.builder(
                        padding: const EdgeInsets.all(15),
                        shrinkWrap: true,
                        itemCount: dataList1.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      other_user_profile(int.parse(dataList1[index].userId.toString())),
                                ),);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image: dataList1[index].imageUrl != null
                                            ? NetworkImage(
                                          dataList1[index].imageUrl.toString(),
                                        )
                                            : const AssetImage('assets/more.png')
                                        as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      shape: const OvalBorder(),
                                    ),

                                  ),
                                  const SizedBox(width: 9,),
                                  Text(
                                    dataList1[index].username ?? "Unknown",
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily:
                                        'assets/fonst/Metropolis-Black.otf'),),
                                ],
                              ),
                            ),
                          );
                        }),
                    ListView.builder(
                        padding: const EdgeInsets.all(15),
                        shrinkWrap: true,
                        itemCount: dataList2.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      other_user_profile(int.parse(dataList2[index].userId.toString())),
                                ),);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image: dataList2[index].imageUrl != null
                                            ? NetworkImage(
                                          dataList2[index].imageUrl.toString(),
                                        )
                                            : const AssetImage('assets/more.png')
                                        as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      shape: const OvalBorder(),
                                    ),

                                  ),
                                  const SizedBox(width: 9,),
                                  Text(
                                    dataList2[index].username ?? "Unknown",
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontFamily:
                                        'assets/fonst/Metropolis-Black.otf'),),
                                ],
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ],
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
