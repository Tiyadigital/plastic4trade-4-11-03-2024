import 'dart:ffi';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:Plastic4trade/model/Get_comment.dart';
import 'dart:io' as io;
import 'package:Plastic4trade/utill/constant.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_interface.dart';
import 'package:Plastic4trade/model/Get_comment.dart' as comment;
import '../model/common.dart';

class review extends StatefulWidget {
  String profileid;
  review(this.profileid, {Key? key}) : super(key: key);

  @override
  State<review> createState() => _reviewState();
}

class Choice {
  Choice({required this.title, required this.icon});
  String title;
  bool icon;
}

List<Choice> choices = <Choice>[];

class _reviewState extends State<review> {
  //final items = List<String>.generate(20, (i) => "Item ${i + 1}");

  int? comment_count;
  String? avg;
  String? av;
  int offset = 0;
  bool? isload;
  var jsonarray;
  Get_comment getcomment = new Get_comment();
  List<comment.Data>? resultList;
  List<comment.Subcomment> subcomment = [];
  List<comment.Data> commentlist_data = [];
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checknetowork();
  }

  @override
  Widget build(BuildContext context) {
    return initwidget();
  }

  Widget initwidget() {
    return Scaffold(
      backgroundColor: Color(0xFFDADADA),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        centerTitle: true,
        elevation: 0,
        title: Text('Reviews',
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
          ? Column(children: [
              Container(
                height: 100,
                margin: EdgeInsets.only(bottom: 5.0),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 230,
                          child: RatingBar.builder(
                            ignoreGestures: true,
                            initialRating: double.parse(avg!),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            tapOnlyMode: false,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ),
                        Text(
                          '$avg/5',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily:
                                  'assets\fonst\Metropolis-SemiBold.otf'),
                        )
                      ],
                    ),
                    SizedBox(
                        width: 350,
                        child: Text(
                          '$comment_count Reviews',
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily:
                                  'assets\fonst\Metropolis-SemiBold.otf'),
                        )),
                  ],
                ),
              ),

              notificationsetting(),
              // SingleChildScrollView(
              //   child: notificationsetting(),
              //   //physics: AlwaysScrollableScrollPhysics(),
              // )
            ])
          :Center(
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
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(50.0),
            color: Color.fromARGB(255, 0, 91, 148)),
        child: TextButton(
          onPressed: () {
            ViewItem(context);
          },
          child: Text('Write Review',
              style: TextStyle(fontSize: 15.0, color: Colors.white ,fontFamily: 'assets\fonst\Metropolis-Black.otf',)),
        ),
      ),
    );
  }

  Widget notificationsetting() {
    return Expanded(child: FutureBuilder(

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
            itemCount: commentlist_data.length,
            padding: EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
            itemBuilder: (context, index) {
              Data? record = getcomment.data![index];
              DateTime date1 = DateFormat("yyyy-MM-dd").parse(formattedDate);
              DateTime date2 = DateFormat("yyyy-MM-dd")
                  .parse(record.commentDatetime.toString());

              // Calculate the difference between the dates
              Duration difference = date1.difference(date2);

              // Print the result
              print("${difference.inDays} days");

              String day;
              int days = difference.inDays;
              int months = difference.inDays ~/ 30;
              int years = difference.inDays ~/ 365;

              if (days <= 30 && days != 0) {
                day = '$days Days ago';
              } else if (months >= 1) {
                day = '$months Days ago';
              } else if (years >= 1) {
                day = '$years Days ago';
              } else {
                day = 'Today';
              }

              return Container(
                  //height: 200,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(clipBehavior: Clip.antiAlias, children: [
                        Positioned.fill(
                          child: Builder(
                              builder: (context) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Container(
                                        height: 40,
                                        color: Color.fromARGB(255, 0, 91, 148)),
                                  )),
                        ),
                        constanst.userid == record.userId
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SlidableAutoCloseBehavior(
                                    child: Slidable(
                                        direction: Axis.horizontal,
                                        endActionPane: ActionPane(
                                          motion: const BehindMotion(),
                                          extentRatio: 0.25,
                                          children: [
                                            Expanded(
                                              //flex: 1,
                                              child: Container(
                                                // height: 120,

                                                // margin: const EdgeInsets.symmetric(
                                                //     horizontal: 8, vertical: 16),
                                                color: Color.fromARGB(
                                                    255, 0, 91, 148),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Expanded(
                                                      child: InkWell(
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              IconButton(
                                                                onPressed:
                                                                    () {
                                                                      Edit_Review(context,widget.profileid,record.id.toString(),record.rating.toString(),record.comment.toString(),record.commentImageUrl.toString());
                                                                    },
                                                                icon: Image.asset(
                                                                    'assets/edit.png',
                                                                    color: Colors
                                                                        .white,
                                                                    width: 30,
                                                                    height: 40),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          ViewItem(context);
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: InkWell(
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              IconButton(
                                                                onPressed:
                                                                    () {
                                                                      revove_Reply(record.id.toString());
                                                                      commentlist_data.clear();
                                                                      isload=false;
                                                                      get_reviewlist();
                                                                      setState(() {

                                                                      });

                                                                    },
                                                                icon: Image.asset(
                                                                    'assets/Delete.png',
                                                                    color: Colors
                                                                        .white,
                                                                    width: 30,
                                                                    height: 40),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        onTap: () {},
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {});
                                            },
                                            child: Container(
                                                //height: 200,
                                                //margin: EdgeInsets.only(bottom: 10.0),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Column(children: [
                                                      Row(children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Container(
                                                              //height: 40,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  5,
                                                              margin: const EdgeInsets
                                                                      .fromLTRB(
                                                                  0.0,
                                                                  10.0,
                                                                  0,
                                                                  0),
                                                              alignment:
                                                                  Alignment
                                                                      .topCenter,
                                                              // margin: EdgeInsets.fromLTRB(0,0, 5.0,0),
                                                              child: Container(
                                                                width: 50.0,
                                                                height: 50.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xff7c94b6),
                                                                  image:
                                                                      DecorationImage(
                                                                    image: NetworkImage(record
                                                                        .userImageUrl
                                                                        .toString()),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              50.0)),
                                                                  /* border: Border.all(
                                                                  color: const Color(0xffFFC107),
                                                                  width: 2.0,
                                                                ),*/
                                                                ),
                                                              ),
                                                            ),
                                                            Column(
                                                              children: [
                                                                Container(
                                                                    width: MediaQuery.of(context).size.width/1.8,
                                                                    margin: const EdgeInsets
                                                                            .fromLTRB(
                                                                        5.0,
                                                                        10.0,
                                                                        0,
                                                                        0),
                                                                    child: Text(
                                                                      record
                                                                          .username
                                                                          .toString(),
                                                                      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'),
                                                                    )),
                                                                Container(
                                                                  width: MediaQuery.of(context).size.width/1.8,
                                                                  child: RatingBar
                                                                      .builder(
                                                                    itemSize:
                                                                        20,
                                                                    ignoreGestures:
                                                                        true,
                                                                    initialRating:
                                                                        double.parse(record
                                                                            .rating
                                                                            .toString()),
                                                                    minRating:
                                                                        1,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    allowHalfRating:
                                                                        true,
                                                                    tapOnlyMode:
                                                                        false,
                                                                    itemCount:
                                                                        5,
                                                                    itemPadding:
                                                                        EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                2.0),
                                                                    itemBuilder:
                                                                        (context,
                                                                                _) =>
                                                                            Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: Colors
                                                                          .amber,
                                                                    ),
                                                                    onRatingUpdate:
                                                                        (rating) {
                                                                      print(
                                                                          rating);
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        Container(
                                                            width: MediaQuery.of(context).size.width/11.5,
                                                            margin:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    15.0,
                                                                    0.0,
                                                                    0,
                                                                    0),
                                                            child: Text('$day',
                                                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                                    ?.copyWith(
                                                                        color: Colors
                                                                            .black38,
                                                                        fontSize:
                                                                            10))),
                                                      ]),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                          10.0,
                                                          5.0,
                                                          0,
                                                          0.0,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            record.commentImageUrl !=
                                                                    null
                                                                ? ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.0),
                                                                    /*shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10.0)),*/
                                                                    child:
                                                                        Image(
                                                                      image: NetworkImage(record
                                                                          .commentImageUrl
                                                                          .toString()),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height:
                                                                          90,
                                                                      width:
                                                                          100,
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    width: 80,
                                                                  ),
                                                            Container(
                                                                height: 31,
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                margin: record
                                                                            .commentImageUrl !=
                                                                        null
                                                                    ? const EdgeInsets
                                                                            .fromLTRB(
                                                                        30.0,
                                                                        0.0,
                                                                        5.0,
                                                                        5)
                                                                    : EdgeInsets
                                                                        .zero,
                                                                child: Text(
                                                                  record.comment
                                                                              .toString() !=
                                                                          'null'
                                                                      ? record
                                                                          .comment
                                                                          .toString()
                                                                      : '',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontFamily:
                                                                          'assets\fonst\Metropolis-Black.otf',
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black),
                                                                  maxLines: 3,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment.topRight,
                                                        child: Container(
                                                          //height: 30,
                                                            margin: const EdgeInsets.fromLTRB(
                                                                0.0,0, 10.0, 10),
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                EditItem(context,widget.profileid,record.id.toString());
                                                              },
                                                              child: Text(
                                                                'Reply',
                                                                style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                                    ?.copyWith(
                                                                    fontWeight:
                                                                    FontWeight.w600,
                                                                    color: Color.fromARGB(
                                                                        255, 0, 91, 148)),
                                                              ),
                                                            )),
                                                      ),
                                                      Visibility(
                                                        visible: record.subcomment!.isEmpty
                                                            ? false
                                                            : true,
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                          NeverScrollableScrollPhysics(),
                                                          padding: EdgeInsets.zero,
                                                          itemCount:
                                                          record.subcomment?.length ?? 0,
                                                          itemBuilder: (context, colorIndex) {
                                                            Subcomment? color =
                                                            record?.subcomment?[colorIndex];
                                                            return Container(
                                                              // height: 200,
                                                                margin:
                                                                EdgeInsets.only(left: 30.0),
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        10),
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        margin:
                                                                        EdgeInsets.fromLTRB(
                                                                          10.0,
                                                                          5.0,
                                                                          0,
                                                                          5.0,
                                                                        ),
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                          children: [
                                                                            color!.userImageUrl !=
                                                                                null
                                                                                ? Container(
                                                                              width: 35.0,
                                                                              height: 35.0,
                                                                              decoration: BoxDecoration(
                                                                                color:
                                                                                const Color(0xff7c94b6),
                                                                                image: DecorationImage(
                                                                                  image: NetworkImage(record
                                                                                      .userImageUrl
                                                                                      .toString()),
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                                borderRadius:
                                                                                BorderRadius.all(
                                                                                    Radius.circular(
                                                                                        35.0)),
                                                                                /* border: Border.all(
                                                                  color: const Color(0xffFFC107),
                                                                  width: 2.0,
                                                                ),*/
                                                                              ),
                                                                            )
                                                                                : Container(
                                                                              width: 80,
                                                                            ),
                                                                            Container(
                                                                                width: 200,
                                                                                margin: const EdgeInsets
                                                                                    .fromLTRB(
                                                                                    5.0, 10.0, 0, 0),
                                                                                child: Text(
                                                                                  record.username
                                                                                      .toString(),
                                                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'),
                                                                                )),

                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                          alignment:
                                                                          Alignment
                                                                              .topLeft,
                                                                          margin: color!
                                                                              .userImageUrl !=
                                                                              null
                                                                              ? const EdgeInsets
                                                                              .fromLTRB(
                                                                              50.0,
                                                                              0.0,
                                                                              5.0,
                                                                              10)
                                                                              : EdgeInsets
                                                                              .zero,
                                                                          child: Text(
                                                                            color.comment
                                                                                .toString() !=
                                                                                'null'
                                                                                ? color
                                                                                .comment
                                                                                .toString()
                                                                                : '',
                                                                            style: TextStyle(
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w400,
                                                                                fontFamily:
                                                                                'assets\fonst\Metropolis-Black.otf',
                                                                                fontSize:
                                                                                12,
                                                                                color: Colors
                                                                                    .black),
                                                                            maxLines: 3,
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ));
                                                          },
                                                        ),
                                                      )

                                                      /*Visibility(
                                                      visible: choices[index].icon,
                                                      child: Container(
                                                          // height: 200,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10.0),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Row(children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Container(
                                                                          //height: 40,
                                                                          width: MediaQuery.of(context).size.width /
                                                                              6,
                                                                          margin: const EdgeInsets.fromLTRB(
                                                                              0.0,
                                                                              10.0,
                                                                              0,
                                                                              0),
                                                                          alignment: Alignment
                                                                              .topCenter,
                                                                          // margin: EdgeInsets.fromLTRB(0,0, 5.0,0),
                                                                          child:
                                                                              Image(
                                                                            image:
                                                                                AssetImage('assets/Ellipse 13.png'),
                                                                            height:
                                                                                40,
                                                                          )),
                                                                      Column(
                                                                        children: [
                                                                          Container(
                                                                              width: 200,
                                                                              margin: const EdgeInsets.fromLTRB(5.0, 10.0, 0, 0),
                                                                              child: Text('Milan Patel', style:  Theme.of(context)
                  .textTheme
                  .headlineMedium,)),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ]),
                                                                Container(
                                                                    height: 60,
                                                                    margin: const EdgeInsets
                                                                            .fromLTRB(
                                                                        10.0,
                                                                        5.0,
                                                                        5.0,
                                                                        0),
                                                                    child: Text(
                                                                      'Don’t tell that to Apple. They will let others create new opportunities, products and even industry; and then swoop in with a better & improved version.',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontFamily:
                                                                              'assets\fonst\Metropolis-Black.otf',
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              Colors.black),
                                                                      maxLines:
                                                                          3,
                                                                    )),
                                                              ],
                                                            ),
                                                          )))*/
                                                    ])))))))
                            : Container(
                                //height: 200,
                                //margin: EdgeInsets.only(bottom: 10.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(children: [
                                      Row(children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              //height: 40,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5,
                                              margin: const EdgeInsets.fromLTRB(
                                                  0.0, 10.0, 0, 0),
                                              alignment: Alignment.topCenter,
                                              // margin: EdgeInsets.fromLTRB(0,0, 5.0,0),
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff7c94b6),
                                                  image: DecorationImage(
                                                    image: NetworkImage(record
                                                        .userImageUrl
                                                        .toString()),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              50.0)),
                                                  /* border: Border.all(
                                                                  color: const Color(0xffFFC107),
                                                                  width: 2.0,
                                                                ),*/
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                    width: MediaQuery.of(context).size.width/1.8,
                                                    margin: const EdgeInsets
                                                            .fromLTRB(
                                                        5.0, 10.0, 0, 0),
                                                    child: Text(
                                                      record.username
                                                          .toString(),
                                                      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'),
                                                    )),
                                                Container(
                                                  width: MediaQuery.of(context).size.width/1.8,
                                                  child: RatingBar.builder(
                                                    itemSize: 20,
                                                    ignoreGestures: true,
                                                    initialRating: double.parse(
                                                        record.rating
                                                            .toString()),
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    tapOnlyMode: false,
                                                    itemCount: 5,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 2.0),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      print(rating);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Container(
                                            width: MediaQuery.of(context).size.width/11.8,
                                            margin: const EdgeInsets.fromLTRB(
                                                15.0, 0.0, 0, 0),
                                            child: Text('$day',
                                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                    ?.copyWith(
                                                        color: Colors.black38,
                                                        fontSize: 10))),
                                      ]),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                          10.0,
                                          5.0,
                                          0,
                                          5.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            record.commentImageUrl != null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    /*shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10.0)),*/
                                                    child: Image(
                                                      image: NetworkImage(record
                                                          .commentImageUrl
                                                          .toString()),
                                                      fit: BoxFit.cover,
                                                      height: 100,
                                                      width: 140,
                                                    ),
                                                  )
                                                : Container(
                                                    width: 80,
                                                  ),
                                            Container(
                                                alignment: Alignment.topLeft,
                                                margin: record
                                                            .commentImageUrl !=
                                                        null
                                                    ? const EdgeInsets.fromLTRB(
                                                        30.0, 0.0, 5.0, 5)
                                                    : EdgeInsets.zero,
                                                child: Text(
                                                  record.comment.toString() !=
                                                          'null'
                                                      ? record.comment
                                                          .toString()
                                                      : '',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          'assets\fonst\Metropolis-Black.otf',
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                  maxLines: 3,
                                                )),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          //height: 30,
                                            margin: const EdgeInsets.fromLTRB(
                                                0.0,0, 10.0, 10),
                                            child: GestureDetector(
                                              onTap: () {
                                                EditItem(context,widget.profileid,record.id.toString());
                                              },
                                              child: Text(
                                                'Reply',
                                                style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                    ?.copyWith(
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: Color.fromARGB(
                                                        255, 0, 91, 148)),
                                              ),
                                            )),
                                      ),
                                      Visibility(
                                        visible: record.subcomment!.isEmpty
                                            ? false
                                            : true,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemCount:
                                              record.subcomment?.length ?? 0,
                                          itemBuilder: (context, colorIndex) {
                                            Subcomment? color =
                                                record?.subcomment?[colorIndex];
                                            return Container(
                                                // height: 200,
                                                margin:
                                                    EdgeInsets.only(left: 30.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                          10.0,
                                                          5.0,
                                                          0,
                                                          5.0,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            color!.userImageUrl !=
                                                                    null
                                                                ? Container(
                                                          width: 35.0,
                                                          height: 35.0,
                                                          decoration: BoxDecoration(
                                                            color:
                                                            const Color(0xff7c94b6),
                                                            image: DecorationImage(
                                                              image: NetworkImage(record
                                                                  .userImageUrl
                                                                  .toString()),
                                                              fit: BoxFit.cover,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    35.0)),
                                                            /* border: Border.all(
                                                                  color: const Color(0xffFFC107),
                                                                  width: 2.0,
                                                                ),*/
                                                          ),
                                                        )
                                                                : Container(
                                                                    width: 80,
                                                                  ),
                                                            Container(
                                                                width: 200,
                                                                margin: const EdgeInsets
                                                                    .fromLTRB(
                                                                    5.0, 10.0, 0, 0),
                                                                child: Text(
                                                                  record.username
                                                                      .toString(),
                                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'),
                                                                )),

                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                          alignment:
                                                          Alignment
                                                              .topLeft,
                                                          margin: color!
                                                              .userImageUrl !=
                                                              null
                                                              ? const EdgeInsets
                                                              .fromLTRB(
                                                              50.0,
                                                              0.0,
                                                              5.0,
                                                              10)
                                                              : EdgeInsets
                                                              .zero,
                                                          child: Text(
                                                            color.comment
                                                                .toString() !=
                                                                'null'
                                                                ? color
                                                                .comment
                                                                .toString()
                                                                : '',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                                fontFamily:
                                                                'assets\fonst\Metropolis-Black.otf',
                                                                fontSize:
                                                                12,
                                                                color: Colors
                                                                    .black),
                                                            maxLines: 3,
                                                          )),
                                                    ],
                                                  ),
                                                ));
                                          },
                                        ),
                                      )
                                    ])))
                      ])));
            });
      }
    }));
  }

  ViewItem(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      )),
      builder: (context) => YourWidget(widget.profileid),
    ).then((value) {
      isload=false;
      commentlist_data.clear();
      subcomment.clear();
      subcomment.clear();
      setState(() {

      });
      get_reviewlist();
    });
  }

  Edit_Review(BuildContext context,String profileid,String coment_id,String rating,String comment,String comment_url) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          )),
      builder: (context) => EditReview(widget.profileid,coment_id,rating,comment,comment_url),
    ).then((value) {
      commentlist_data.clear();
      subcomment.clear();
      subcomment.clear();
      isload=false;
      get_reviewlist();
    });
  }

  EditItem(BuildContext context,String profileid,String coment_id) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          )),
      builder: (context) => EditReply(profileid,coment_id),
    ).then((value) {
      commentlist_data.clear();
      subcomment.clear();
      subcomment.clear();
      isload=false;
      get_reviewlist();
    });

       /* .then((value) => (value) {

      setState(() {

      });
    });*/
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      get_reviewlist();

      // get_data();
    }
  }

  revove_Reply(String comment_id) async {

    var res = await deletemyreview(
        comment_id
    );

    /* 'userId':userId,'userToken':userToken,'business_name':business_name,'business_type':business_type,'location':location,'longitude':longitude,'longitude':latitude,'other_mobile1':other_mobile1,'country':country,
    'countryCode':countryCode,
    'business_phone':business_phone,'business_type':business_type,'city':city,'email':email,'website':website,'about_business':about_business,
    'profilePicture':file,'gst_tax_vat':gst_tax_vat,'state':state*/

    print(res);
    if (res['status'] == 1) {
      Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: res['message']);


    } else {
      Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: res['message']);
    }
  }
  get_reviewlist() async {
    getcomment = Get_comment();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await Getcomment(
        _pref.getString('user_id').toString(), offset.toString(), '20');

    print(res);
    if (res['status'] == 1) {
      getcomment = Get_comment.fromJson(res);
      print('hellooooo');
      resultList = getcomment.data;
      comment_count = res['comment_count'];
      avg = res['comment_avg'];

      print(avg);

      print(av);

      if (res['data'] != null) {
        jsonarray = res['data'];
        print(res['data']);
        //   List<Result>? results = res['result'];
        //   print(results);

        for (var data in jsonarray) {
          comment.Data record = comment.Data(
              username: data['username'],
              userImageUrl: data['user_image_url'],
              comment: data['comment'],
              rating: data['rating'],
              commentImageUrl: data['comment_image_url']);

          /*  subcomment=
          print(subcomment);

          if (subcomment != null && subcomment != []) {
            print(subcomment);
            for (var data in subcomment) {
              comment.Subcomment subcomments = comment.Subcomment(
                  userImageUrl: data.userImageUrl,
                  user: data.user

              );


              subcomment.add(subcomments);
            }
          }*/
          commentlist_data.add(record);
        }


        isload = true;
        print(commentlist_data);
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      isload = true;
      Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }
}

class YourWidget extends StatefulWidget {
  String? profileid;
  YourWidget(this.profileid, {Key? key}) : super(key: key);

  @override
  State<YourWidget> createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  String? assignedName;
  int? rate;
  bool gender = false;
  PickedFile? _imagefiles1;
  io.File? file1;
  final ImagePicker _picker = ImagePicker();
  CroppedFile? _croppedFile;
  TextEditingController _comment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      /*child: Container(
        child: Column(
          children: [

            SizedBox(height: 15),
            Container(
                margin: EdgeInsets.only(left: 15.0),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 230,
                          child: RatingBar.builder(

                            initialRating: 0,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            tapOnlyMode: false,

                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                             // int a=int.parse(rating.toString());
                              rate=rating.toInt();
                              print(rating.toInt());
                            },
                          ),
                        )),
                Align(
                  alignment: Alignment.topLeft,
                    child:  GestureDetector(
                        child: _imagefiles1 != null
                            ? Image.file(file1!,
                            height: 100, width: 100)
                            : Image.asset(
                            'assets/addphoto1.png',
                            height: 100,
                            width: 100),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  bottomsheet1());
                          // takephoto(ImageSource.gallery,);
                        }),
                ),
                    Container(
                      margin:
                      EdgeInsets.fromLTRB(15.0, 15.0, 25.0, 10.0),
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: TextFormField(
                        controller: _comment,
                        keyboardType: TextInputType.multiline,
                        autovalidateMode:
                        AutovalidateMode.onUserInteraction,
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                        maxLines: 4,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            hintText: "Write Your Feedback Here",
                            hintStyle:
                            TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),

                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.black38),
                                borderRadius:
                                BorderRadius.circular(10.0)),



                          //errorText: _validusernm ? 'Name is not empty' : null),
                        ),


                      ),
                    ),
                  ],
                )),

            //-------CircularCheckBox()

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
                  if (rate!=null) {
                    Navigator.pop(context);
                    add_Review();
                  } else {
                    Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'plz select rating ');
                  }
                },
                child: Text('Publish',
                    style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontFamily: 'assets\fonst\Metropolis-Black.otf')),
              ),
            ),
          ],
        ),
      ),*/
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: SingleChildScrollView(
          child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Column(
              children: <Widget>[
                SizedBox(height: 5),
                Image.asset(
                  'assets/hori_line.png',
                  width: 150,
                  height: 5,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 230,
                      child: RatingBar.builder(
                        initialRating: 0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        tapOnlyMode: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          // int a=int.parse(rating.toString());
                          rate = rating.toInt();
                          print(rating.toInt());
                        },
                      ),
                    )),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                      child: _imagefiles1 != null
                          ? Image.file(file1!, height: 100, width: 100)
                          : Image.asset('assets/addphoto1.png',
                              height: 100, width: 100),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => bottomsheet1());
                        // takephoto(ImageSource.gallery,);
                      }),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _comment,
                    keyboardType: TextInputType.multiline,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                    maxLines: 4,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "Write Your Feedback Here",
                      hintStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),

                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black38),
                          borderRadius: BorderRadius.circular(10.0)),

                      //errorText: _validusernm ? 'Name is not empty' : null),
                    ),
                  ),
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
                      if (rate != null) {
                        Navigator.pop(context);
                        add_Review();
                      } else {
                        Fluttertoast.showToast(msg: 'plz select rating ');
                      }
                    },
                    child: Text('Publish',
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
        ),
      ),
    );
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
                    takephoto1(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera,
                      color: Colors.white),
                  label: Text(
                    'Camera',
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton.icon(
                  onPressed: () {
                    takephoto1(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image,
                      color: Colors.white),
                  label: Text(
                    'Gallary',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          )
        ],
      ),
    );
  }

  void takephoto1(ImageSource imageSource) async {
    final pickedfile = await _picker.getImage(source: imageSource);

    _imagefiles1 = pickedfile!;
    //file = io.File(_imagefiles!.path);
    file1 = await _cropImage1(imagefile: io.File(_imagefiles1!.path));
    constanst.imagesList.add(file1!);
    Navigator.of(context).pop();
   /* setState(() async {


      // print('image path : ');
      // print(_imagefiles!.path);
    });*/
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
                toolbarColor: Colors.white,
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

  add_Review() async {
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await addReview(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        widget.profileid.toString(),
        rate.toString(),
        _comment.text.toString(),
        file1);

    /* 'userId':userId,'userToken':userToken,'business_name':business_name,'business_type':business_type,'location':location,'longitude':longitude,'longitude':latitude,'other_mobile1':other_mobile1,'country':country,
    'countryCode':countryCode,
    'business_phone':business_phone,'business_type':business_type,'city':city,'email':email,'website':website,'about_business':about_business,
    'profilePicture':file,'gst_tax_vat':gst_tax_vat,'state':state*/

    print(res);
    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);

      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
  }
}

class EditReview extends StatefulWidget {
  String? profileid,comment,comment_url;
  String? comment_id,rating;
  EditReview(this.profileid, this.comment_id, this.rating,this.comment, this.comment_url, {Key? key}) : super(key: key);

  @override
  State<EditReview> createState() => _EditReviewState();
}

class _EditReviewState extends State<EditReview> {
  String? assignedName;
  int? rate;
  bool gender = false;
  PickedFile? _imagefiles1;
  io.File? file1;
  final ImagePicker _picker = ImagePicker();
  CroppedFile? _croppedFile;
  TextEditingController _comment = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _comment.text=widget.comment.toString();

  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      /*child: Container(
        child: Column(
          children: [

            SizedBox(height: 15),
            Container(
                margin: EdgeInsets.only(left: 15.0),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 230,
                          child: RatingBar.builder(

                            initialRating: 0,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            tapOnlyMode: false,

                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                             // int a=int.parse(rating.toString());
                              rate=rating.toInt();
                              print(rating.toInt());
                            },
                          ),
                        )),
                Align(
                  alignment: Alignment.topLeft,
                    child:  GestureDetector(
                        child: _imagefiles1 != null
                            ? Image.file(file1!,
                            height: 100, width: 100)
                            : Image.asset(
                            'assets/addphoto1.png',
                            height: 100,
                            width: 100),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  bottomsheet1());
                          // takephoto(ImageSource.gallery,);
                        }),
                ),
                    Container(
                      margin:
                      EdgeInsets.fromLTRB(15.0, 15.0, 25.0, 10.0),
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: TextFormField(
                        controller: _comment,
                        keyboardType: TextInputType.multiline,
                        autovalidateMode:
                        AutovalidateMode.onUserInteraction,
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                        maxLines: 4,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            hintText: "Write Your Feedback Here",
                            hintStyle:
                            TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),

                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Colors.black38),
                                borderRadius:
                                BorderRadius.circular(10.0)),



                          //errorText: _validusernm ? 'Name is not empty' : null),
                        ),


                      ),
                    ),
                  ],
                )),

            //-------CircularCheckBox()

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
                  if (rate!=null) {
                    Navigator.pop(context);
                    add_Review();
                  } else {
                    Fluttertoast.showToast(msg: 'plz select rating ');
                  }
                },
                child: Text('Publish',
                    style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontFamily: 'assets\fonst\Metropolis-Black.otf')),
              ),
            ),
          ],
        ),
      ),*/
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: SingleChildScrollView(
          child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Column(
              children: <Widget>[
                SizedBox(height: 5),
                Image.asset(
                  'assets/hori_line.png',
                  width: 150,
                  height: 5,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 230,
                      child: RatingBar.builder(
                        initialRating: double.parse(widget.rating.toString()),
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        tapOnlyMode: false,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          // int a=int.parse(rating.toString());
                          rate = rating.toInt();
                          print(rating.toInt());
                        },
                      ),
                    )),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                      child: widget.comment_url!=null?
                      Image.network(widget.comment_url.toString(),
                          height: 100, width: 100)
                      :_imagefiles1 != null
                          ? Image.file(file1!, height: 100, width: 100)
                          : Image.asset('assets/addphoto1.png',
                      height: 100,
                      width: 100),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => bottomsheet1());
                        // takephoto(ImageSource.gallery,);
                      }),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _comment,
                    keyboardType: TextInputType.multiline,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                    maxLines: 4,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "Write Your Feedback Here",
                      hintStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),

                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 1, color: Colors.black38),
                          borderRadius: BorderRadius.circular(10.0)),

                      //errorText: _validusernm ? 'Name is not empty' : null),
                    ),
                  ),
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

                        edit_Review();

                    },
                    child: Text('Publish',
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
        ),
      ),
    );
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
                    takephoto1(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera,
                      color: Colors.white),
                  label: Text(
                    'Camera',
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton.icon(
                  onPressed: () {
                    takephoto1(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image,
                      color: Colors.white),
                  label: Text(
                    'Gallary',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          )
        ],
      ),
    );
  }

  void takephoto1(ImageSource imageSource) async {
    final pickedfile = await _picker.getImage(source: imageSource);

    _imagefiles1 = pickedfile!;
    //file = io.File(_imagefiles!.path);
    file1 = await _cropImage1(imagefile: io.File(_imagefiles1!.path));
    constanst.imagesList.add(file1!);
    Navigator.of(context).pop();

   /* setState(() async {


      // print('image path : ');
      // print(_imagefiles!.path);
    });*/
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
                toolbarColor: Colors.white,
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

  edit_Review() async {
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await editReview(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        widget.comment_id.toString(),
        widget.rating.toString(),
        _comment.text.toString(),
        file1);

    /* 'userId':userId,'userToken':userToken,'business_name':business_name,'business_type':business_type,'location':location,'longitude':longitude,'longitude':latitude,'other_mobile1':other_mobile1,'country':country,
    'countryCode':countryCode,
    'business_phone':business_phone,'business_type':business_type,'city':city,'email':email,'website':website,'about_business':about_business,
    'profilePicture':file,'gst_tax_vat':gst_tax_vat,'state':state*/

    print(res);
    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);

      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
  }
}




class EditReply extends StatefulWidget {
  String? profileid;
  String? commentid;
  EditReply(this.profileid,this.commentid, {Key? key}) : super(key: key);

  @override
  State<EditReply> createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditReply> {
  String? assignedName;
  int? rate;
  bool gender = false;
  PickedFile? _imagefiles1;
  io.File? file1;
  final ImagePicker _picker = ImagePicker();
  CroppedFile? _croppedFile;
  TextEditingController _comment = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),

      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: SingleChildScrollView(
          child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Column(
              children: <Widget>[
                SizedBox(height: 5),
                Image.asset(
                  'assets/hori_line.png',
                  width: 150,
                  height: 5,
                ),

                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _comment,
                    keyboardType: TextInputType.multiline,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                    maxLines: 4,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "Write Your Feedback Here",
                      hintStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),

                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(width: 1, color: Colors.black38),
                          borderRadius: BorderRadius.circular(10.0)),

                      //errorText: _validusernm ? 'Name is not empty' : null),
                    ),
                  ),
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

                        add_Reply();

                    },
                    child: Text('Publish',
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
        ),
      ),
    );
  }


  add_Reply() async {
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await addReply(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        widget.commentid.toString(),
        widget.profileid.toString(),
        _comment.text.toString(),
       );

    /* 'userId':userId,'userToken':userToken,'business_name':business_name,'business_type':business_type,'location':location,'longitude':longitude,'longitude':latitude,'other_mobile1':other_mobile1,'country':country,
    'countryCode':countryCode,
    'business_phone':business_phone,'business_type':business_type,'city':city,'email':email,'website':website,'about_business':about_business,
    'profilePicture':file,'gst_tax_vat':gst_tax_vat,'state':state*/

    print(res);
    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);

      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
  }

}
