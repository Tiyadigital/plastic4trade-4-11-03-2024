// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, unnecessary_null_comparison, use_build_context_synchronously, prefer_typing_uninitialized_variables

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

class review extends StatefulWidget {
  String profileid;

  review(this.profileid, {Key? key}) : super(key: key);

  @override
  State<review> createState() => _reviewState();
}

class _reviewState extends State<review> {
  //final items = List<String>.generate(20, (i) => "Item ${i + 1}");

  int comment_count = 0;
  String? avg;
  String? av;
  int offset = 0;
  bool? isload;
  var jsonArray;
  Get_comment getcomment = Get_comment();
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
      backgroundColor: const Color(0xFFDADADA),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        centerTitle: true,
        elevation: 0,
        title: const Text('Reviews',
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
      body: isload == true
          ? Column(
              children: [
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 5.0),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 230,
                            child: RatingBar.builder(
                              ignoreGestures: true,
                              initialRating: double.parse(avg ?? ""),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              tapOnlyMode: false,
                              itemCount: 5,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => const Icon(
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
                            style: const TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily:
                                    'assets/fonst/Metropolis-SemiBold.otf'),
                          )
                        ],
                      ),

                      // 141400059150
                      SizedBox(
                          width: 350,
                          child: Text(
                            '$comment_count Reviews',
                            style: const TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily:
                                    'assets/fonst/Metropolis-SemiBold.otf'),
                          )),
                    ],
                  ),
                ),
                notificationsetting(),
              ],
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
                      : Container()),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(50.0),
            color: const Color.fromARGB(255, 0, 91, 148)),
        child: TextButton(
          onPressed: () {
            ViewItem(context);
          },
          child: const Text('Write Review',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
                fontFamily: 'assets/fonst/Metropolis-Black.otf',
              ),
          ),
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
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        //List<dynamic> users = snapshot.data as List<dynamic>;
        return ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: commentlist_data.length,
            padding: const EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
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

              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(clipBehavior: Clip.antiAlias, children: [
                    Positioned.fill(
                      child: Builder(
                          builder: (context) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Container(
                                    height: 40,
                                    color:
                                        const Color.fromARGB(255, 0, 91, 148)),
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
                                      child: Container(
                                        color: const Color.fromARGB(
                                            255, 0, 91, 148),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          Edit_Review(
                                                              context,
                                                              widget.profileid,
                                                              record.id
                                                                  .toString(),
                                                              record.rating
                                                                  .toString(),
                                                              record.comment
                                                                  .toString(),
                                                              record
                                                                  .commentImageUrl
                                                                  .toString());
                                                        },
                                                        icon: Image.asset(
                                                            'assets/edit.png',
                                                            color: Colors.white,
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
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          revove_Reply(record.id
                                                              .toString());
                                                          commentlist_data
                                                              .clear();
                                                          isload = false;
                                                          get_reviewlist();
                                                          setState(() {});
                                                        },
                                                        icon: Image.asset(
                                                            'assets/Delete.png',
                                                            color: Colors.white,
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
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    5,
                                                margin:
                                                    const EdgeInsets.fromLTRB(
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
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                50.0)),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.8,
                                                      margin: const EdgeInsets
                                                              .fromLTRB(
                                                          5.0, 10.0, 0, 0),
                                                      child: Text(
                                                        record.username
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'assets/fonst/Metropolis-SemiBold.otf'),
                                                      )),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.8,
                                                    child: RatingBar.builder(
                                                      itemSize: 20,
                                                      ignoreGestures: true,
                                                      initialRating:
                                                          double.parse(record
                                                              .rating
                                                              .toString()),
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      tapOnlyMode: false,
                                                      itemCount: 5,
                                                      itemPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 2.0),
                                                      itemBuilder:
                                                          (context, _) =>
                                                              const Icon(
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  11.5,
                                              margin: const EdgeInsets.fromLTRB(
                                                  15.0, 0.0, 0, 0),
                                              child: Text(day,
                                                  style: const TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf')
                                                      .copyWith(
                                                          color: Colors.black38,
                                                          fontSize: 10))),
                                        ]),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                            10.0,
                                            5.0,
                                            0,
                                            0.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              record.commentImageUrl != null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      /*shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(10.0)),*/
                                                      child: Image(
                                                        image: NetworkImage(
                                                            record
                                                                .commentImageUrl
                                                                .toString()),
                                                        fit: BoxFit.cover,
                                                        height: 90,
                                                        width: 100,
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 80,
                                                    ),
                                              Container(
                                                  height: 31,
                                                  alignment: Alignment.topLeft,
                                                  margin:
                                                      record.commentImageUrl !=
                                                              null
                                                          ? const EdgeInsets
                                                                  .fromLTRB(
                                                              30.0, 0.0, 5.0, 5)
                                                          : EdgeInsets.zero,
                                                  child: Text(
                                                    record.comment.toString() !=
                                                            'null'
                                                        ? record.comment
                                                            .toString()
                                                        : '',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf',
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
                                                  0.0, 0, 10.0, 10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  EditItem(
                                                      context,
                                                      widget.profileid,
                                                      record.id.toString());
                                                },
                                                child: Text(
                                                  'Reply',
                                                  style: const TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf')
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color
                                                                  .fromARGB(
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
                                                const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            itemCount:
                                                record.subcomment?.length ?? 0,
                                            itemBuilder: (context, colorIndex) {
                                              Subcomment? color = record
                                                  .subcomment?[colorIndex];
                                              return Container(
                                                  // height: 200,
                                                  margin: const EdgeInsets.only(
                                                      left: 30.0),
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
                                                              const EdgeInsets
                                                                  .fromLTRB(
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
                                                                      width:
                                                                          35.0,
                                                                      height:
                                                                          35.0,
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
                                                                            const BorderRadius.all(Radius.circular(35.0)),
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
                                                                      5.0,
                                                                      10.0,
                                                                      0,
                                                                      0),
                                                                  child: Text(
                                                                    record
                                                                        .username
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'assets/fonst/Metropolis-SemiBold.otf'),
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            margin: color
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
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      'assets/fonst/Metropolis-Black.otf',
                                                                  fontSize: 12,
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
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
                                      width:
                                          MediaQuery.of(context).size.width / 5,
                                      margin: const EdgeInsets.fromLTRB(
                                          0.0, 10.0, 0, 0),
                                      alignment: Alignment.topCenter,
                                      // margin: EdgeInsets.fromLTRB(0,0, 5.0,0),
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff7c94b6),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                record.userImageUrl.toString()),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50.0)),
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.8,
                                            margin: const EdgeInsets.fromLTRB(
                                                5.0, 10.0, 0, 0),
                                            child: Text(
                                              record.username.toString(),
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-SemiBold.otf'),
                                            )),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.8,
                                          child: RatingBar.builder(
                                            itemSize: 20,
                                            ignoreGestures: true,
                                            initialRating: double.parse(
                                                record.rating.toString()),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            tapOnlyMode: false,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 2.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
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
                                    width: MediaQuery.of(context).size.width /
                                        11.8,
                                    margin: const EdgeInsets.fromLTRB(
                                        15.0, 0.0, 0, 0),
                                    child: Text(day,
                                        style: const TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontFamily:
                                                    'assets/fonst/Metropolis-Black.otf')
                                            .copyWith(
                                                color: Colors.black38,
                                                fontSize: 10))),
                              ]),
                              Container(
                                margin: const EdgeInsets.fromLTRB(
                                  10.0,
                                  5.0,
                                  0,
                                  5.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    record.commentImageUrl != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
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
                                        margin: record.commentImageUrl != null
                                            ? const EdgeInsets.fromLTRB(
                                                30.0, 0.0, 5.0, 5)
                                            : EdgeInsets.zero,
                                        child: Text(
                                          record.comment.toString() != 'null'
                                              ? record.comment.toString()
                                              : '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                                  'assets/fonst/Metropolis-Black.otf',
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
                                        0.0, 0, 10.0, 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        EditItem(context, widget.profileid,
                                            record.id.toString());
                                      },
                                      child: Text(
                                        'Reply',
                                        style: const TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    'assets/fonst/Metropolis-Black.otf')
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromARGB(
                                                    255, 0, 91, 148)),
                                      ),
                                    )),
                              ),
                              Visibility(
                                visible:
                                    record.subcomment!.isEmpty ? false : true,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: record.subcomment?.length ?? 0,
                                  itemBuilder: (context, colorIndex) {
                                    Subcomment? color =
                                        record.subcomment?[colorIndex];
                                    return Container(
                                        // height: 200,
                                        margin:
                                            const EdgeInsets.only(left: 30.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                  10.0,
                                                  5.0,
                                                  0,
                                                  5.0,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    color!.userImageUrl != null
                                                        ? Container(
                                                            width: 35.0,
                                                            height: 35.0,
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
                                                                  const BorderRadius
                                                                          .all(
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
                                                          style: const TextStyle(
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'assets/fonst/Metropolis-SemiBold.otf'),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  alignment: Alignment.topLeft,
                                                  margin: color.userImageUrl !=
                                                          null
                                                      ? const EdgeInsets
                                                              .fromLTRB(
                                                          50.0, 0.0, 5.0, 10)
                                                      : EdgeInsets.zero,
                                                  child: Text(
                                                    color.comment.toString() !=
                                                            'null'
                                                        ? color.comment
                                                            .toString()
                                                        : '',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            'assets/fonst/Metropolis-Black.otf',
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                    maxLines: 3,
                                                  )),
                                            ],
                                          ),
                                        ));
                                  },
                                ),
                              )
                            ]))
                  ]));
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
      isload = false;
      commentlist_data.clear();
      subcomment.clear();
      subcomment.clear();
      setState(() {});
      get_reviewlist();
    });
  }

  Edit_Review(BuildContext context, String profileid, String comentId,
      String rating, String comment, String commentUrl) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      )),
      builder: (context) =>
          EditReview(widget.profileid, comentId, rating, comment, commentUrl),
    ).then((value) {
      commentlist_data.clear();
      subcomment.clear();
      subcomment.clear();
      isload = false;
      get_reviewlist();
    });
  }

  EditItem(BuildContext context, String profileid, String comentId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      )),
      builder: (context) => EditReply(profileid, comentId),
    ).then((value) {
      commentlist_data.clear();
      subcomment.clear();
      subcomment.clear();
      isload = false;
      get_reviewlist();
    });
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
          timeInSecForIosWeb: 2, msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      get_reviewlist();

      // get_data();
    }
  }

  revove_Reply(String commentId) async {
    var res = await deletemyreview(commentId);
    print(res);
    if (res['status'] == 1) {
      Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: res['message']);
    } else {
      Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: res['message']);
    }
  }

  get_reviewlist() async {
    getcomment = Get_comment();
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await Getcomment(widget.profileid, offset.toString(), '10');
    print("RESPONSE == $res");

    if (res['status'] == 1) {
      getcomment = Get_comment.fromJson(res);
      resultList = getcomment.data;
      comment_count = res['comment_count'];
      avg = res['comment_avg'] ?? "";

      print("COMMENT COUNT == $comment_count");

      setState(() {});

      print(avg);
      print(av);

      if (res['data'] != null) {
        jsonArray = res['data'];

        for (var data in jsonArray) {
          comment.Data record = comment.Data(
              username: data['username'],
              userImageUrl: data['user_image_url'],
              comment: data['comment'],
              rating: data['rating'],
              commentImageUrl: data['comment_image_url']);
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
      Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: res['message']);
    }
    setState(() {});
    return jsonArray;
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
  final TextEditingController _comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        child: SingleChildScrollView(
          child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Column(
              children: [
                const SizedBox(height: 5),
                Image.asset(
                  'assets/hori_line.png',
                  width: 150,
                  height: 5,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 230,
                      child: RatingBar.builder(
                        initialRating: 0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        tapOnlyMode: false,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => const Icon(
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
                      }),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _comment,
                    keyboardType: TextInputType.multiline,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                    maxLines: 4,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "Write Your Feedback Here",
                      hintStyle: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black38),
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
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
                      if (rate != null) {
                        Navigator.pop(context);
                        add_Review();
                      } else {
                        Fluttertoast.showToast(msg: 'plz select rating ');
                      }
                    },
                    child: const Text('Publish',
                        style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'assets/fonst/Metropolis-Black.otf')),
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
                    takephoto1(ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera, color: Colors.white),
                  label: const Text(
                    'Camera',
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton.icon(
                  onPressed: () {
                    takephoto1(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.image, color: Colors.white),
                  label: const Text(
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
    file1 = await _cropImage1(imagefile: io.File(_imagefiles1!.path));
    constanst.imagesList.add(file1!);
    Navigator.of(context).pop();
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
                toolbarColor: Colors.white,
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
    return null;
  }

  add_Review() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await addReview(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        widget.profileid.toString(),
        rate.toString(),
        _comment.text.toString(),
        file1);

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
  String? profileid, comment, comment_url;
  String? comment_id, rating;

  EditReview(this.profileid, this.comment_id, this.rating, this.comment,
      this.comment_url,
      {Key? key})
      : super(key: key);

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
  final TextEditingController _comment = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _comment.text = widget.comment.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        child: SingleChildScrollView(
          child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 5),
                Image.asset(
                  'assets/hori_line.png',
                  width: 150,
                  height: 5,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 230,
                      child: RatingBar.builder(
                        initialRating: double.parse(widget.rating.toString()),
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        tapOnlyMode: false,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => const Icon(
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
                      child: widget.comment_url != null
                          ? Image.network(widget.comment_url.toString(),
                              height: 100, width: 100)
                          : _imagefiles1 != null
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
                    style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                    maxLines: 4,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "Write Your Feedback Here",
                      hintStyle: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: 'assets/fonst/Metropolis-Black.otf'),

                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black38),
                          borderRadius: BorderRadius.circular(10.0)),

                      //errorText: _validusernm ? 'Name is not empty' : null),
                    ),
                  ),
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
                      edit_Review();
                    },
                    child: const Text('Publish',
                        style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'assets/fonst/Metropolis-Black.otf')),
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
                    takephoto1(ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera, color: Colors.white),
                  label: const Text(
                    'Camera',
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton.icon(
                  onPressed: () {
                    takephoto1(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.image, color: Colors.white),
                  label: const Text(
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
    file1 = await _cropImage1(imagefile: io.File(_imagefiles1!.path));
    constanst.imagesList.add(file1!);
    Navigator.of(context).pop();
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
                toolbarColor: Colors.white,
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
    return null;
  }

  edit_Review() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await editReview(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        widget.comment_id.toString(),
        widget.rating.toString(),
        _comment.text.toString(),
        file1);

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

  EditReply(this.profileid, this.commentid, {Key? key}) : super(key: key);

  @override
  State<EditReply> createState() => _EditWidgetState();
}

class _EditWidgetState extends State<EditReply> {
  String? assignedName;
  int? rate;
  bool gender = false;
  io.File? file1;
  final TextEditingController _comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        child: SingleChildScrollView(
          child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 5),
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
                    style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                    maxLines: 4,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "Write Your Feedback Here",
                      hintStyle: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black38),
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
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
                      add_Reply();
                    },
                    child: const Text('Publish',
                        style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'assets/fonst/Metropolis-Black.otf')),
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
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await addReply(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
      widget.commentid.toString(),
      widget.profileid.toString(),
      _comment.text.toString(),
    );
    print(res);
    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);

      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
  }
}
