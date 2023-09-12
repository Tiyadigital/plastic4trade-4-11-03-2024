import 'dart:core';
import 'dart:io' as io;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:Plastic4trade/model/common.dart';
import 'package:Plastic4trade/screen/other_user_profile.dart';
import 'package:share/share.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Plastic4trade/model/CommonPostdetail.dart' as postdetail;
import 'package:Plastic4trade/model/getsimilar_product.dart' as similar_prod;
import '../api/api_interface.dart';
import '../model/CommonPostdetail.dart';
import '../model/getsimilar_product.dart';
import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';

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
  String? isFavorite = "", unit = "",price_unit = "", isFollow;
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
    print(
        "App Name : ${appName}, App Package Name: ${packageName},App Version: ${version}, App build Number: ${buildNumber}");
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Widget init() {
    return Scaffold(
        backgroundColor: Color(0xFFDADADA),
        body: load == true
            ? SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                    child: Column(
                  children: [
                    Stack(fit: StackFit.passthrough, children: <Widget>[
                      SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Container(
                          child: Container(
                            height: 900,
                            /*child: slider(),*/
                            child: imagelist.length == 1
                                ? Container(
                                    //height: 180,
                                    //margin: EdgeInsets.fromLTRB(5, 0, 5,0),
                                    child: GestureDetector(
                                      onTap: () {
                                        //show_Dialog(url);
                                        _showImageDialog(context);
                                      },
                                      child: Align(
                                          child: Image.network(
                                            imagelist[0].toString(),
                                            fit: BoxFit.cover,
                                            height: 400,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                          alignment: Alignment.topCenter),
                                    ),
                                  )
                                : slider(),
                          ),
                        ),
                      ),
                      /* Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: imagelist.length == 1
                              ? Container(
                            //height: 180,
                            //margin: EdgeInsets.fromLTRB(5, 0, 5,0),
                            child: GestureDetector(
                              onTap: () {
                                //show_Dialog(url);
                              },
                              child: Align(child: Image.network(imagelist[0].toString(),fit: BoxFit.contain,height: 200),alignment: Alignment.topCenter),
                            ),
                          ):slider()),*/
                      Positioned(
                        top: 30,
                        left: 10,
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade600),
                          // color: Color.fromARGB(0, 255, 255, 255),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Center(
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
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade600),
                            // color: Color.fromARGB(0, 255, 255, 255),
                            child: prod_like
                                ? GestureDetector(
                                    onTap: () {
                                      print('hello');
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
                                      print('hello');
                                      getadd_product();
                                    },
                                    child: Center(
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
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade600),
                            // color: Color.fromARGB(0, 255, 255, 255),
                            child: Center(
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

                                //color: Colors.grey,
                                //  margin: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                                padding: EdgeInsets.all(10.0),
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
                                        child: Text(prod_nm.toString(),
                                            style: TextStyle(
                                                    fontSize: 26.0,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf')
                                                ?.copyWith(fontSize: 17)),
                                        alignment: Alignment.topLeft),
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                margin: EdgeInsets.all(5.0),
                                                padding: EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Color(0xFFc00945F)),
                                                child: Row(
                                                  children: [
                                                    Text('₹$price',
                                                        style: TextStyle(
                                                                fontSize: 26.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'assets\fonst\Metropolis-Black.otf')
                                                            ?.copyWith(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                    .white)),
                                                    Text('/Per $price_unit',
                                                        style: TextStyle(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'assets\fonst\Metropolis-Black.otf')
                                                            ?.copyWith(
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
                                              margin: EdgeInsets.all(5.0),
                                              padding: EdgeInsets.all(6.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Color.fromRGBO(
                                                    90, 231, 131, 0.29),
                                              ),
                                              child: Text(
                                                  product_status.toString(),
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'assets\fonst\Metropolis-SemiBold.otf')),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                margin: EdgeInsets.all(5.0),
                                                padding: EdgeInsets.all(6.0),
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
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'assets\fonst\Metropolis-SemiBold.otf'),
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            child: Text(
                                              'Category:',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets\fonst\Metropolis-SemiBold.otf'),
                                            ),
                                            width: 90,
                                          ),
                                          Text(cate_name,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets\fonst\Metropolis-SemiBold.otf'))
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 30,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            child: Text(
                                              'Type:',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets\fonst\Metropolis-SemiBold.otf'),
                                            ),
                                            width: 90,
                                          ),
                                          Text(type,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets\fonst\Metropolis-SemiBold.otf'))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      // width: MediaQuery.of(context).size.width/1.5,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            child: Text(
                                              'Grade:',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                  'assets\fonst\Metropolis-SemiBold.otf'),
                                            ),
                                            width: 90,
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
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                    fontFamily:
                                                    'assets\fonst\Metropolis-SemiBold.otf')),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            child: Text(
                                              'Quantity:',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets\fonst\Metropolis-SemiBold.otf'),
                                            ),
                                            width: 90,
                                          ),
                                          Text(qty+""+unit.toString(),
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets\fonst\Metropolis-SemiBold.otf'))
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
                                                      'assets\fonst\Metropolis-SemiBold.otf'),
                                            ),
                                          ),

                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                             // scrollDirection: Axis.horizontal,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              /*gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                // crossAxisCount: 2,
                                                // mainAxisSpacing: 5,
                                                // crossAxisSpacing: 5,
                                                // childAspectRatio: .90,

                                                childAspectRatio:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        300,
                                                //MediaQuery.of(context).size.aspectRatio * 1.3,
                                                //crossAxisSpacing: 0.0,
                                               // mainAxisSpacing: 0.0,
                                                crossAxisCount: 2,
                                              ),*/
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
                                                            ? Icon(
                                                                Icons
                                                                    .circle_outlined,
                                                                size: 15)
                                                            : Icon(
                                                                Icons
                                                                    .circle_rounded,
                                                                size: 15,
                                                                color: colors),
                                                        Flexible(

                                                          child: Text( colorIndex+1 == postHaxCodeColors?.length? '${postHaxCodeColors![colorIndex].colorName.toString()}': '${postHaxCodeColors![colorIndex].colorName.toString()},' ,

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
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontFamily:
                                                'assets\fonst\Metropolis-SemiBold.otf',
                                          ),
                                          textAlign: TextAlign.left,
                                        )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Posted on $create_formattedDate',
                                            style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf')
                                                ?.copyWith(
                                                    fontSize: 10,
                                                    color: Colors.grey)),
                                        Text('Updated on $update_formattedDate',
                                            style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf')
                                                ?.copyWith(
                                                    fontSize: 10,
                                                    color: Colors.grey))
                                      ],
                                    ),
                                    Divider(
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
                                                    style: TextStyle(
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Color.fromARGB(
                                                            255, 0, 91, 148),
                                                        fontFamily:
                                                            'assets\fonst\Metropolis-Black.otf'))
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
                                                    style: TextStyle(
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Color.fromARGB(
                                                            255, 0, 91, 148),
                                                        fontFamily:
                                                            'assets\fonst\Metropolis-Black.otf'))
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
                                                  Text('Send',
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color.fromARGB(
                                                              255, 0, 91, 148),
                                                          fontFamily:
                                                              'assets\fonst\Metropolis-Black.otf'))
                                                ],
                                              )),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                                // margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                                padding: EdgeInsets.only(
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
                                          print('Tap');

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  other_user_profile(user_id!),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(left: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                                                    margin:
                                                        EdgeInsets.only(top: 3),
                                                    decoration: BoxDecoration(
                                                      //color:  Colors.blue,
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            user_image
                                                                .toString()),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      shape: BoxShape.circle,
                                                      // borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xffFFC107),
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.all(3.0),
                                                    transform: Matrix4
                                                        .translationValues(
                                                            0.0, -10.0, 0.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: const Color(
                                                          0xffFFC107),
                                                    ),
                                                    child: Text(
                                                      'Premium',
                                                      style: TextStyle(
                                                          fontSize: 9),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  print('Tap123');
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          other_user_profile(
                                                              user_id!),
                                                    ),
                                                  );
                                                },
                                                child: Container(
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
                                                        EdgeInsets.fromLTRB(
                                                            10.0,
                                                            0.0,
                                                            0.0,
                                                            5.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Align(
                                                          child: Text(
                                                            usernm.toString(),
                                                            softWrap: false,
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-SemiBold.otf',
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          alignment:
                                                              Alignment.topLeft,
                                                        ),
                                                        Align(
                                                          child: Text(
                                                            bussiness_type
                                                                .toString(),
                                                            softWrap: false,
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets\fonst\Metropolis-Black.otf',
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          alignment:
                                                              Alignment.topLeft,
                                                        ),
                                                        SizedBox(
                                                          child: Row(
                                                            children: [
                                                              ImageIcon(AssetImage(
                                                                  'assets/location.png')),
                                                              Expanded(
                                                                child: Text(
                                                                  location
                                                                      .toString(),
                                                                  softWrap:
                                                                      false,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'assets\fonst\Metropolis-Black.otf',
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
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/follow1.png",
                                            width: 50,
                                            height: 50,
                                          ),
                                          isFollow == "0"
                                              ? GestureDetector(
                                                  onTap: () {
                                                    setfollowUnfollow('1',
                                                        user_id.toString());
                                                    isFollow = '1';
                                                    setState(() {});
                                                  },
                                                  child: Text(
                                                    'Follow',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () {},
                                                  child: Text(
                                                    'Followed',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/user_chat.png",
                                            width: 50,
                                            height: 50,
                                          ),
                                          Text(
                                            'Chat',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      )
                                    ])),
                            Container(
                                margin:
                                    EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                                child: Align(
                                  child: Text('Similar Posts',
                                      style: TextStyle(
                                              fontSize: 26.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf')
                                          ?.copyWith(fontSize: 17),
                                      textAlign: TextAlign.left),
                                  alignment: Alignment.topLeft,
                                )),
                          ],
                        ),
                      ),
                      /* Positioned(
                              top: 710,
                              left: 12,
                              right: 12,
                              child: Container(
                              margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                              padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                              // transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                              child: Column(
                                children: [

                                  //SizedBox(height: 5,),

                                ],
                              ))),*/
                    ]),
                    category()
                  ],
                )))
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
                        : Container())
    );

    /*Container(
                    height: 320,
                    child: Stack(
                      children: [
                        Positioned(child:
                        Container(

                          //color: Colors.grey,
                          //  margin: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                            padding: EdgeInsets.all(10.0),
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
                                    child: Text(prod_nm.toString(),
                                        style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                            ?.copyWith(fontSize: 17)),
                                    alignment: Alignment.topLeft),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.all(5.0),
                                            padding: EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Color(0xFFc00945F)),
                                            child: Row(
                                              children: [
                                                Text('₹$price',
                                                    style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                        ?.copyWith(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w800,
                                                        color: Colors.white)),
                                                Text('/per $unit',
                                                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                        ?.copyWith(
                                                        fontSize: 10,
                                                        color: Colors.white))
                                              ],
                                            ))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(5.0),
                                          padding: EdgeInsets.all(6.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Color.fromRGBO(90, 231, 131, 0.29),
                                          ),
                                          child: Text(product_status.toString(),
                                              style:TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf')),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.all(5.0),
                                            padding: EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1, color: Colors.grey),
                                              borderRadius: BorderRadius.circular(20),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Text(widget.post_type.toString(),
                                              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'),
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          'Category:',
                                          style:TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'),
                                        ),
                                        width: 130,
                                      ),
                                      Text(cate_name,
                                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          'Grade:',
                                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'),
                                        ),
                                        width: 130,
                                      ),
                                      Text(Grade,
                                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          'Type:',
                                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'),
                                        ),
                                        width: 130,
                                      ),
                                      Text(type,
                                          style:TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          'Quantity:',
                                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'),
                                        ),
                                        width: 130,
                                      ),
                                      Text(qty,
                                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'))
                                    ],
                                  ),
                                ),
                                */ /* Row(
                            children: [
                              SizedBox(
                                height: 30,
                                child:  Row(
                                  children: [
                                    SizedBox(

                                      child: Text('Color: ',style:Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500),),
                                      width: 130,
                                    ),

                                   //
                                    Row(
                                      children: [
                                        SizedBox(
                                            height: 20,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                    width: 15,
                                                    child: Icon(
                                                      Icons.circle_outlined,
                                                      size: 14.0,
                                                    )),
                                                Text('White',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.copyWith(
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                    maxLines: 2,
                                                    softWrap: false),
                                              ],
                                            )),
                                        SizedBox(
                                            height: 20,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                    width: 15,
                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 14.0,
                                                    )),
                                                Text('Black',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.copyWith(
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                    maxLines: 2,
                                                    softWrap: false),
                                              ],
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ),


                            ],
                          ),*/ /*
                                Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      // Text('$colors'),]
                                      //colors==null?Container(): getcolorlist()

                                      SizedBox(
                                        child: Text(
                                          'Color: ',
                                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'),
                                        ),
                                        width: 130,
                                        height: 70,
                                      ),

                                      Expanded(
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            // crossAxisCount: 2,
                                            // mainAxisSpacing: 5,
                                            // crossAxisSpacing: 5,
                                            // childAspectRatio: .90,

                                            childAspectRatio:
                                            MediaQuery.of(context).size.height /
                                                200,
                                            //MediaQuery.of(context).size.aspectRatio * 1.3,
                                            crossAxisSpacing: 0.0,
                                            mainAxisSpacing: 0.0,
                                            crossAxisCount: 3,
                                          ),
                                          itemCount: postHaxCodeColors?.length ?? 0,
                                          itemBuilder: (context, colorIndex) {
                                            */ /*  PostColor? color =
                                      record?.postColor?[colorIndex];
                                      String colorString=resultList![index].postColor![colorIndex].haxCode.toString();
*/ /*
                                            postdetail.PostHaxCodeColor result =
                                            postHaxCodeColors![colorIndex];
                                            String colorString =
                                            result.haxCode.toString();
                                            String newStr = colorString.substring(1);

                                            Color colors =
                                            Color(int.parse(newStr, radix: 16))
                                                .withOpacity(1.0);
                                            return Container(
                                                margin: EdgeInsets.zero,
                                                padding: EdgeInsets.zero,
                                                child: Row(
                                                  children: [
                                                    newStr == 'ffffff'
                                                        ? Icon(Icons.circle_outlined,
                                                        size: 15)
                                                        : Icon(Icons.circle_rounded,
                                                        size: 15, color: colors),
                                                    SizedBox(

                                                      child: Text(result.colorName.toString(),overflow: TextOverflow.ellipsis,),
                                                      width: 50,)
                                                  ],
                                                ));
                                          },
                                        ),
                                      )
                                    ]),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(prod_desc.toString(),
                                      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf',),textAlign: TextAlign.left,)),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Posted on $create_formattedDate',
                                        style:  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                            ?.copyWith(
                                            fontSize: 10, color: Colors.grey)),
                                    Text('Updated on $update_formattedDate',
                                        style:  TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                            ?.copyWith(
                                            fontSize: 10, color: Colors.grey))
                                  ],
                                ),
                                Divider(
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
                                                    int add = likecount!;
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
                                                    int add = likecount!;
                                                    add--;
                                                    likecount = add;
                                                    setState(() {});
                                                  },
                                                )),
                                            Text('Interested ($likecount)',
                                                style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400,color:  Color.fromARGB(255, 0, 91, 148),fontFamily: 'assets\fonst\Metropolis-Black.otf'))
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
                                                style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400,color:  Color.fromARGB(255, 0, 91, 148),fontFamily: 'assets\fonst\Metropolis-Black.otf'))
                                          ],
                                        )),
                                    GestureDetector(
                                      onTap: () {
                                        shareImage(url: main_product.toString());
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
                                              Text('Send',
                                                  style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400,color:  Color.fromARGB(255, 0, 91, 148),fontFamily: 'assets\fonst\Metropolis-Black.otf'))

                                            ],
                                          )),
                                    )
                                  ],
                                )
                              ],
                            )),
                        top: -50,
                        left: 20,
                        right: 20,)

                      ],

                    ),
                  ),
                  Container(
                    height: 120,
                    child: Stack(

                      children: [
                        Positioned(
                          top: -40,
                          left: 20,
                          right: 20,
                          child: Container(
                           // margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                            //padding: EdgeInsets.all(10.0),
                            height: 100,
                            //transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color:Colors.white,
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [

                                  GestureDetector(
                                    onTap: () {
                                      print('Tap');

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => other_user_profile(user_id!),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.pink,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: const Color(0xffFFC107),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              Container(

                                                width: 70.0,
                                                height: 70.0,
                                                decoration: BoxDecoration(
                                                  //color:  Colors.blue,
                                                  image: DecorationImage(
                                                    image: NetworkImage(user_image.toString()),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  shape: BoxShape.circle,
                                                  // borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                                  border: Border.all(
                                                    color: const Color(0xffFFC107),
                                                    width: 2.0,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(3.0),
                                                transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: const Color(0xffFFC107),
                                                ),
                                                child: Text(
                                                  'Premium',
                                                  style: TextStyle(fontSize: 9),
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              print('Tap123');
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => other_user_profile(user_id!),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context).size.width / 2.5,
                                              height: 85,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                border: Border.all(
                                                  color: const Color(0xffFFC107),
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      child: Text(
                                                        usernm.toString(),
                                                        softWrap: false,
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black,
                                                          fontFamily: 'assets\fonst\Metropolis-SemiBold.otf',
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      alignment: Alignment.topLeft,
                                                    ),
                                                    Align(
                                                      child: Text(
                                                        bussiness_type.toString(),
                                                        softWrap: false,
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.black,
                                                          fontFamily: 'assets\fonst\Metropolis-Black.otf',
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      alignment: Alignment.topLeft,
                                                    ),
                                                    SizedBox(
                                                      child: Row(
                                                        children: [
                                                          ImageIcon(AssetImage('assets/location.png')),
                                                          Expanded(
                                                            child: Text(
                                                              location.toString(),
                                                              softWrap: false,
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                                fontWeight: FontWeight.w400,
                                                                color: Colors.black,
                                                                fontFamily: 'assets\fonst\Metropolis-Black.otf',
                                                              ),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
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




                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/follow1.png",
                                        width: 50,
                                        height: 50,
                                      ),
                                      isFollow == "0"
                                          ? GestureDetector(
                                        onTap: () {
                                          setfollowUnfollow('1', user_id.toString());
                                          isFollow = '1';
                                          setState(() {});
                                        },
                                        child: Text(
                                          'Follow',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                          : GestureDetector(
                                        onTap: () {
                                          */ /* setfollowUnfollow('1', user_id.toString());
                                            isFollow = '0';
                                            setState(() {});*/ /*
                                        },
                                        child: Text(
                                          'Followed',
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Column(
                                    children: [
                                      Image.asset(
                                        "assets/user_chat.png",
                                        width: 50,
                                        height: 50,
                                      ),
                                      Text(
                                        'Chat',
                                        style: TextStyle(
                                            fontSize: 11, fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  )
                                ])),),

                      ],

                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                      transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                      child: Column(
                        children: [
                          Align(
                            child: Text('Similar Posts',
                                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                    ?.copyWith(fontSize: 17),
                                textAlign: TextAlign.left),
                            alignment: Alignment.topLeft,
                          ),
                          //SizedBox(height: 5,),
                          category()
                        ],
                      ))
                      */
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
          return Container(
            //margin: EdgeInsets.fromLTRB(5, 0, 5,0),
            child: GestureDetector(
              onTap: () {
                _showImageSliderDialog(context);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                child: Image.network(url, fit: BoxFit.cover, width: 1500.0),
              ),
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
        return Center(child: CircularProgressIndicator());
      } else {
        //List<dynamic> users = snapshot.data as List<dynamic>;
        return simmilar_post_buyer.isNotEmpty
            ? GridView.builder(
                //padding: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                padding: EdgeInsets.only(top: 5.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  // crossAxisCount: 2,
                  // mainAxisSpacing: 5,
                  // crossAxisSpacing: 5,
                  // childAspectRatio: .90,
                  childAspectRatio: MediaQuery.of(context).size.width/ 620,
                  /*childAspectRatio: MediaQuery.of(context).size.height /
                      1400,*/ //MediaQuery.of(context).size.aspectRatio * 1.3,
                 // mainAxisSpacing: 1.0,
                  crossAxisCount: 2,
                ),
                physics: AlwaysScrollableScrollPhysics(),
                controller: scrollercontroller,
                itemCount: simmilar_post_buyer.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  similar_prod.Result result = simmilar_post_buyer[index];
                  return GestureDetector(
                    onTap: (() {
                      /*   if (!constanst.isgrade &&
                            !constanst.istype &&
                            !constanst.iscategory &&
                            !constanst.isprofile) {
                          print(constanst.step);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Buyer_sell_detail(
                                  post_type: result.postType.toString(),
                                  prod_id: result.productId.toString(),
                                ),
                              ));
                        } else {
                          showInformationDialog(context);
                        }*/
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
                            margin: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 0, 148, 95),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              // color: Color.fromARGB(0,255, 255, 255),
                              child: Text('₹' + result.productPrice.toString(),
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w800,
                                      fontFamily:
                                          'assets\fonst\Metropolis-Black.otf',
                                      color: Colors.white)),
                            ),
                          ),
                          /* result.isPaidPost == 'Paid'
                                ? Positioned(
                              top: -10,
                              left: -30,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                */ /*decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0))),*/ /*
                                // color: Color.fromARGB(0,255, 255, 255),
                                //child: Text('Paid', style: TextStyle(color: Colors.white)),
                                child: Image.asset(
                                  'assets/PaidPost.png',
                                  height: 50,
                                  width: 100,
                                ),
                              ),
                            )
                                : Container()*/
                        ]),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, left: 10.0),
                                  child: Text(result.postName.toString(),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets\fonst\Metropolis-SemiBold.otf'),
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis)),
                            ),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, left: 10.0),
                                  child: Text(
                                      result.productType.toString() +
                                          ' | ' +
                                          result.productGrade.toString(),
                                      style: TextStyle(
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
                                  padding:
                                      EdgeInsets.only(top: 10.0, left: 10.0),
                                  child: Text(
                                      result.state.toString() +
                                          ',' +
                                          result.country.toString(),
                                      style: TextStyle(
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
                                  padding:
                                      EdgeInsets.only(top: 10.0, left: 10.0),
                                  child: Text(
                                    result.postType.toString(),
                                    style: TextStyle(
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
            : Text('Post Not Found');
      }

      return CircularProgressIndicator();
    });
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
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
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getPost_datail(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        widget.prod_id.toString(),
        notiId.toString());
    var jsonarray, subjsonarray, simmilar_list, color_array;
    print(res);
    if (res['status'] == 1) {
      commonPostdetail = CommonPostdetail.fromJson(res);
      List<postdetail.Result>? results = commonPostdetail.result;

      if (results != null && results.isNotEmpty) {
        postdetail.Result firstResult = results[0];
        postHaxCodeColors = firstResult.postHaxCodeColor;
        print('colors123 $postHaxCodeColors');
      }
      if (res['result'] != null) {
        jsonarray = res['result'];

        for (var data in jsonarray) {
          print(data);
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
          simmilar_list = data['SimilarProducts'];
          color_array = data['PostHaxCodeColor'];
          likecount = data['likeCount'];
          isFavorite = data['isFavorite'];
          isFollow = data['isFollow'];
          viewcount = data['isView'];
          unit = data['Unit'];
          usernm = data['Username'];
          user_id = data['UserId'];
          price_unit =data['unit_of_price']==null?"":data['unit_of_price'];
          user_image = data['UserImage'];
          bussiness_type = data['BusinessType'];
          main_product = data['mainproductImage'];
        }
        /*     for (var data in jsonarray) {
          postdetail.Result record = postdetail.Result(
              postName: data['PostName'],
              categoryName: data['CategoryName'],
              productGrade: data['ProductGrade'],
              currency: data['Currency'],
              productPrice: data['ProductPrice'],
              state: data['State'],
              country: data['Country'],
              postType: data['PostType'],
              isPaidPost: data['is_paid_post'],
              productType: data['ProductType'],);
          detail_data.add(record);
         // loadmore = true;
        }*/

        imagelist.add(main_product!);

        //var date = Jiffy.parse("12.04.2020", pattern: "dd.MM.yyyy").format("dd, Oct yy");
        //11-05-2023
        DateFormat format = new DateFormat("dd-MM-yyyy");
        var curret_date = format.parse(create_date);
        var updat_date = format.parse(update_date);
        DateTime? dt1 = DateTime.parse(curret_date.toString());
        DateTime? dt2 = DateTime.parse(updat_date.toString());
        // print(dt1);
        create_formattedDate =
            dt1 != null ? DateFormat('dd MMMM, yyyy').format(dt1) : "";
        update_formattedDate =
            dt2 != null ? DateFormat('dd MMMM, yyyy').format(dt2) : "";
        // print(formattedDate);
        // print(detail_data);
      }
      if (color_array != null) {
        for (var data in color_array) {
          postdetail.PostHaxCodeColor record = postdetail.PostHaxCodeColor(
              colorName: data['colorName'], haxCode: data['HaxCode']);
          print(record.haxCode);
          colors.add(record);
        }

        print(colors.length);
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
    return jsonarray;
    setState(() {});
  }

  get_SalePostDatil() async {
    CommonPostdetail commonPostdetail = CommonPostdetail();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getPost_datail1(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        widget.prod_id.toString(),
        notiId.toString());
    var jsonarray, subjsonarray, simmilar_list, color_array;
    print(res);

    if (res['status'] == 1) {
      commonPostdetail = CommonPostdetail.fromJson(res);
      List<postdetail.Result>? results = commonPostdetail.result;

      if (results != null && results.isNotEmpty) {
        postdetail.Result firstResult = results[0];
        postHaxCodeColors = firstResult.postHaxCodeColor;
        print('colors123 $postHaxCodeColors');
      }
      if (res['result'] != null) {
        jsonarray = res['result'];
        print(jsonarray);
        // postdetail.Result firstResult = res['result']['PostHaxCodeColor'];

        for (var data in jsonarray) {
          print(data);
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
          simmilar_list = data['SimilarProducts'];
          color_array = data['PostHaxCodeColor'];
          likecount = data['likeCount'];
          isFavorite = data['isFavorite'];
          isFollow = data['isFollow'];
          viewcount = data['isView'];
          unit = data['Unit'];
          price_unit =data['unit_of_price'];
          usernm = data['Username'];
          user_id = data['UserId'];
          price_unit =data['unit_of_price']==null?"":data['unit_of_price'];
          user_image = data['UserImage'];
          bussiness_type = data['BusinessType'];
          main_product = data['mainproductImage'];
        }
        /*     for (var data in jsonarray) {
          postdetail.Result record = postdetail.Result(
              postName: data['PostName'],
              categoryName: data['CategoryName'],
              productGrade: data['ProductGrade'],
              currency: data['Currency'],
              productPrice: data['ProductPrice'],
              state: data['State'],
              country: data['Country'],
              postType: data['PostType'],
              isPaidPost: data['is_paid_post'],
              productType: data['ProductType'],);
          detail_data.add(record);
         // loadmore = true;
        }*/

        imagelist.add(main_product!);
        print('view count $viewcount');
        //var date = Jiffy.parse("12.04.2020", pattern: "dd.MM.yyyy").format("dd, Oct yy");
        //11-05-2023
        DateFormat format = new DateFormat("dd-MM-yyyy");
        var curret_date = format.parse(create_date);
        var updat_date = format.parse(update_date);
        DateTime? dt1 = DateTime.parse(curret_date.toString());
        DateTime? dt2 = DateTime.parse(updat_date.toString());
        // print(dt1);
        create_formattedDate =
            dt1 != null ? DateFormat('dd MMMM, yyyy').format(dt1) : "";
        update_formattedDate =
            dt2 != null ? DateFormat('dd MMMM, yyyy').format(dt2) : "";
        // print(formattedDate);
        // print(detail_data);
      }
      if (color_array != null) {
        for (var data in color_array) {
          postdetail.PostHaxCodeColor record = postdetail.PostHaxCodeColor(
              colorName: data['colorName'], haxCode: data['HaxCode']);
          print(record.haxCode);
          colors.add(record);
        }

        print(colors.length);
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
    return jsonarray;
    setState(() {});
  }

  getadd_product() async {
    CommonPostdetail commonPostdetail = CommonPostdetail();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await addfav(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(), widget.prod_id.toString());
    var jsonarray;

    print(res);
    if (res['status'] == 1) {
      print('inside if');
      commonPostdetail = CommonPostdetail.fromJson(res);
      // if (res['result'] != null) {
      jsonarray = res['result'];
      Fluttertoast.showToast(msg: res['message']);
      prod_like = true;

      // }

      setState(() {});
    } else {
      print('inside else');
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }

  getremove_product() async {
    CommonPostdetail commonPostdetail = CommonPostdetail();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await removefav(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(), widget.prod_id.toString());
    var jsonarray;

    print(res);
    if (res['status'] == 1) {
      commonPostdetail = CommonPostdetail.fromJson(res);
      //if (res['result'] != null) {
      jsonarray = res['result'];
      Fluttertoast.showToast(msg: res['message']);
      prod_like = false;

      //   }

      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }

  Future<void> setfollowUnfollow(String follow, String otherUserId) async {
    common_par getsimmilar = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await followUnfollow(
        follow,
        otherUserId,
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = common_par.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];
        // setState(() {});
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }

  getcolorlist() {
    Expanded(
      child: FutureBuilder(

          //future: load_subcategory(),
          builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.hasData == null) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          //List<dynamic> users = snapshot.data as List<dynamic>;

          return ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: colors.length,
              itemBuilder: (context, index) {
                postdetail.PostHaxCodeColor record = colors[index];

                print('========');
                return Container(
                  child: Row(children: [
                    Icon(
                      Icons.circle,
                      size: 15,
                      color: Color(int.parse(record.haxCode.toString())),
                    ),
                    Text(record.colorName.toString())
                  ]),
                );
              });
        }

        return CircularProgressIndicator();
      }),
    );
  }

  get_ral_buyerpost() async {
    getsimilar_product getsimmilar = getsimilar_product();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await similar_product_buyer(
        widget.prod_id.toString(), '20', offset.toString());
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = getsimilar_product.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];
        print(jsonarray);

        for (var data in jsonarray) {
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
          //loadmore = true;
        }
        print(simmilar_post_buyer);
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
    setState(() {});
  }

  void show_Dialog(image_url) {
    BuildContext dialogContext = context;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        dialogContext = context; // Store the context in a variable
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            alignment: Alignment.center,
            height: 175, // Adjust the height of the Carousel
            width: MediaQuery.of(context).size.width,
            child: GFCarousel(
              autoPlay: false,
              pagerSize: 2.0,
              viewportFraction: 1.0,
              aspectRatio: 2,
              items: imagelist.map((url) {
                return Container(
                  child: ClipRect(
                    child: InteractiveViewer(
                      child: Image.network(
                        url,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                        height: 345,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onPageChanged: (index) {
                setState(() {
                  index;
                  //cat_data.clear();
                });
              },
            ),
          ),
        );
      },
    );

    /*Future.delayed(const Duration(seconds: 5), () {
    print('exit');
    Navigator.of(dialogContext).pop(); // Use dialogContext to close the dialog
    print('exit1'); // Dialog closed
  });*/
  }

  void _showImageSliderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.all(5.0),
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,

            padding: EdgeInsets.symmetric(horizontal: 7.0),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                PhotoViewGallery.builder(
                  customSize: Size.fromHeight(MediaQuery.of(context).size.height/1.12),
                  itemCount: imagelist.length,
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(imagelist[index]),
                      minScale: PhotoViewComputedScale.contained / 5.0,
                      maxScale: PhotoViewComputedScale.covered * 2.0,
                    );
                  },
                  scrollPhysics: const BouncingScrollPhysics(),
                  backgroundDecoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  pageController: PageController(initialPage: 0),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: IconButton(
                    icon: Icon(Icons.close),
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
          actionsPadding: EdgeInsets.all(5.0),
          insetPadding: EdgeInsets
              .zero, // Remove any additional padding around the dialog
          contentPadding: EdgeInsets.zero, // Remove padding around the content

          content: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(onPressed: () {
                  Navigator.of(context).pop();
                }, icon: Icon(Icons.close_rounded)),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/1.15 ,
                  padding: EdgeInsets.symmetric(horizontal: 7.0),
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
    getsimilar_product getsimmilar = getsimilar_product();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await similar_product_saler(
        widget.prod_id.toString(), '20', offset.toString());

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = getsimilar_product.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];
        print(jsonarray);

        for (var data in jsonarray) {
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
          //loadmore = true;
        }
        print(simmilar_post_saler);
        setState(() {});
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
    setState(() {});
  }

  void _scrollercontroller() {
    if (scrollercontroller.position.pixels ==
        scrollercontroller.position.maxScrollExtent) {
      // loadmore = false;

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

          ), /*Container(
            child: Stack(
              children: <Widget>[
                Container(
                  width: 300.0,
                  height: 150.0,
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    width: 300.0,
                    height: 150.0,
                    alignment: AlignmentDirectional.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const
                      */ /*  Container(
                          margin: const EdgeInsets.only(top: 25.0),
                          child: Center(
                            child: Text(
                              "loading.. wait...",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),*/ /*
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )*/
        );
      },
    );

    Future.delayed(const Duration(seconds: 5), () {
      print('exit');
      Navigator.of(dialogContext)
          .pop(); // Use dialogContext to close the dialog
      print('exit1'); // Dialog closed
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
    common_par getsimmilar = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await product_like(
        widget.prod_id.toString(),
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = common_par.fromJson(res);
      //  Fluttertoast.showToast(msg: res['message']);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }
/*Future<Null> urlFileShare() async {
    setState(() {
      //button2 = true;
    });
    final RenderBox box = context.findRenderObject();
    if (Platform.isAndroid) {
      var url = 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg';
      var response = await get(url);
      final documentDirectory = (await getExternalStorageDirectory()).path;
      File imgFile = new File('$documentDirectory/flutter.png');
      imgFile.writeAsBytesSync(response.bodyBytes);

      Share.shareFile(File('$documentDirectory/flutter.png'),
          subject: 'URL File Share',
          text: 'Hello, check your share files!',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      Share.share('Hello, check your share files!',
          subject: 'URL File Share',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
    setState(() {
      button2 = false;
    });
  }*/
}
