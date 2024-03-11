// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, depend_on_referenced_packages

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:Plastic4trade/screen/ExhitionDetail.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Plastic4trade/model/GetUpcomingExhibition.dart' as getnews;
import 'package:http/http.dart' as http;
import '../api/api_interface.dart';
import '../constroller/GetCategoryController.dart';
import '../widget/HomeAppbar.dart';
import 'dart:io';
import '../utill/constant.dart';
import 'package:Plastic4trade/model/GetCategory.dart' as cat;

import 'package:path_provider/path_provider.dart';

class Exhibition extends StatefulWidget {
  const Exhibition({Key? key}) : super(key: key);

  @override
  State<Exhibition> createState() => _ExhibitionState();
}

class _ExhibitionState extends State<Exhibition>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool unread = false, isload = false, alldata = true;
  List<getnews.Data> getupexbitiondata = [];
  List<getnews.Data> getpastexbitiondata = [];
  String? packageName, create_formattedDate, end_formattedDate;
  PackageInfo? packageInfo;
  String limit = "20";
  int selectedIndex = 0, _defaultChoiceIndex = -1;
  String category_filter_id = "";
  final scrollercontroller = ScrollController();
  int count = 0;
  int offset = 0;

  @override
  void initState() {
    checknetowork();
    _tabController = TabController(length: 2, vsync: this);
    scrollercontroller.addListener(_scrollercontroller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      getPackage();
      get_UpcomingExhibition(offset.toString());
      get_pastExhibition(offset.toString());
      get_categorylist();
    }
  }

  Widget init() {
    return Scaffold(
      backgroundColor: const Color(0xFFDADADA),
      appBar: CustomeApp('Exhibition'),
      body: isload == true
          ? Column(children: [
              horiztallist(),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 8),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      color: const Color.fromARGB(255, 0, 91, 148),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: const [
                      Tab(
                        child: Text(
                          'Upcoming Exhibition',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Metropolis',
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Past Exhibition',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Metropolis',
                          ),
                        ),
                      ),
                    ],
                    onTap: (value) {
                      if (value == 0) {
                        unread = true;
                        alldata = false;
                      } else if (value == 1) {
                        alldata = true;
                        unread = false;
                      }
                    },
                  ),
                ),
              ),
              // tab bar view here
              Expanded(
                child: TabBarView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _tabController,
                    // first tab bar view widget
                    children: [
                      upcoming_exhibition(),
                      past_exhibition()
                      /*news()*/
                    ]),

                // second tab bar view widget
              ),
            ])
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
    );
  }

  Widget upcoming_exhibition() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: getupexbitiondata.length,
    shrinkWrap: true,
    controller: scrollercontroller,
    itemBuilder: (context, index) {
      getnews.Data result = getupexbitiondata[index];
      DateFormat format = DateFormat("yyyy-MM-dd");

      var currentDate = format.parse(result.startDate.toString());

      DateTime? dt1 = DateTime.parse(currentDate.toString());

      create_formattedDate =
          dt1 != null ? DateFormat('dd MMMM yyyy').format(dt1) : "";

      end_formattedDate =
          dt1 != null ? DateFormat('dd MMMM yyyy ').format(dt1) : "";
      return GestureDetector(
          onTap: (() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ExhitionDetail(blog_id: result.id.toString()),
              ),
            );
          }),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.05)),
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
                    )]),
              child: Column(children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13.05),
                    child: Image(
                      errorBuilder: (context, object, trace) {
                        return Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 223, 220, 220),
                          ),
                        );
                      },
                      image: NetworkImage(result.imageUrl ?? ''),
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.title.toString(),
                          maxLines: 2,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(
                                Icons.calendar_month_outlined,
                                size: 20),
                            Text(
                              "${create_formattedDate!} - ${end_formattedDate!}",
                              style: const TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily:
                                  'assets/fonst/Metropolis-Black.otf')
                                  .copyWith(fontSize: 11),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const ImageIcon(
                                AssetImage('assets/location.png'),
                                size: 15),
                            Text(
                              result.location.toString(),
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily:
                                  'assets/fonst/Metropolis-Black.otf')
                                  .copyWith(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(result.metaDescription.toString(),
                            maxLines: 2,
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Metropolis',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            )),
                        const SizedBox(height: 7),
                        const Divider(height: 2.0, thickness: 2),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                               // width: MediaQuery.of(context).size.width /2.6,
                                height: 18,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  //mainAxisSize: MainAxisSize.min,
                                  children: [
                                    result.isLike == "0"
                                        ? GestureDetector(
                                            onTap: () {
                                              Exhibitionlike(
                                                  result.id.toString());
                                              result.isLike = '1';
                                              int like = int.parse(result
                                                  .likeCounter
                                                  .toString());
                                              like = like + 1;
                                              result.likeCounter =
                                                  like.toString();
                                              setState(() {});
                                            },
                                            child: Image.asset(
                                              'assets/like.png',
                                              width: 30,
                                              height: 28,
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              Exhibitionlike(
                                                  result.id.toString());
                                              result.isLike = '0';
                                              int like = int.parse(result
                                                  .likeCounter
                                                  .toString());
                                              like = like - 1;
                                              result.likeCounter =
                                                  like.toString();
                                              //getnewsdata.clear();
                                              // get_News();
                                              setState(() {});
                                            },
                                            child: Image.asset(
                                              'assets/like1.png',
                                              width: 30,
                                              height: 28,
                                            )),
                                    Text(
                                        'Interested (${result.likeCounter})',
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: 'Metropolis',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ))
                                  ],
                                )),
                            SizedBox(
                              //width: MediaQuery.of(context).size.width / 3.5,
                              height: 18,
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                      onTap: () {},
                                      child: const ImageIcon(
                                        AssetImage('assets/show.png'),
                                        color: Colors.black,
                                        size: 20,
                                      )),
                                  const SizedBox(width: 2),
                                  Text(result.viewCounter.toString(),
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'Metropolis',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(
                                //width: MediaQuery.of(context).size.width / 5.0,
                                height: 18,
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          shareImage(
                                              url: result.imageUrl
                                                  .toString(),
                                              title: result.title
                                                  .toString());
                                        },
                                        child: const ImageIcon(AssetImage(
                                            'assets/Send.png'))),
                                    const SizedBox(width: 2),
                                    const Text('Share',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: 'Metropolis',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ))
                                  ],
                                )),
                          ],
                        ),
                        Container(
                          height: 15,
                        ),
                      ]),
                ),
              ]),
            ),
          ));
    },
                );
  }

  Widget past_exhibition() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: getpastexbitiondata.length,
    shrinkWrap: true,
    controller: scrollercontroller,
    itemBuilder: (context, index) {
      getnews.Data result = getpastexbitiondata[index];
      DateFormat format = DateFormat("yyyy-MM-dd");
      var curretDate = format.parse(result.startDate.toString());
      DateTime? dt1 = DateTime.parse(curretDate.toString());
      create_formattedDate =
          dt1 != null ? DateFormat('dd MMMM yyyy').format(dt1) : "";
      end_formattedDate =
          dt1 != null ? DateFormat('dd MMMM yyyy ').format(dt1) : "";
      return GestureDetector(
        onTap: (() {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ExhitionDetail(blog_id: result.id.toString()),
              ));
        }),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.05)),
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
          )]),
            child: Column(
                children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13.05),
                  /*shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10.0)),*/
                  child: Image(
                    errorBuilder: (context, object, trace) {
                      return Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 223, 220, 220),
                        ),
                      );
                    },
                    image: NetworkImage(result.imageUrl ?? ''
                        //data[index]['member_image'] ?? '',
                        ),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(result.title.toString(),
                          maxLines: 2,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          )),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                              Icons.calendar_month_outlined,
                              size: 15),
                          Text(
                            "${create_formattedDate!} - ${end_formattedDate!}",
                            style: const TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w500,
                                fontFamily:
                                'assets/fonst/Metropolis-Black.otf')
                                .copyWith(fontSize: 11),
                          )
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const ImageIcon(
                              AssetImage('assets/location.png'),
                              size: 15),
                          Text(
                            result.location.toString(),
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 11.0,
                                fontWeight: FontWeight.w500,
                                fontFamily:
                                'assets/fonst/Metropolis-Black.otf')
                                .copyWith(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(result.metaDescription.toString(),
                          maxLines: 2,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          )),
                      const SizedBox(height: 7),
                      const Divider(height: 2.0, thickness: 2),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                             // width: MediaQuery.of(context).size.width / 2.7,
                              height: 18,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                //mainAxisSize: MainAxisSize.min,
                                children: [
                                  result.isLike == "0"
                                      ? GestureDetector(
                                          onTap: () {
                                            Exhibitionlike(
                                                result.id.toString());
                                            result.isLike = '1';
                                            int like = int.parse(result
                                                .likeCounter
                                                .toString());
                                            like = like + 1;
                                            result.likeCounter =
                                                like.toString();
                                            /*getnewsdata.clear();
                                      get_News();*/
                                            setState(() {});
                                          },
                                          child: Image.asset(
                                            'assets/like.png',
                                            width: 30,
                                            height: 28,
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            Exhibitionlike(
                                                result.id.toString());
                                            result.isLike = '0';
                                            int like = int.parse(result
                                                .likeCounter
                                                .toString());
                                            like = like - 1;
                                            result.likeCounter =
                                                like.toString();
                                            //getnewsdata.clear();
                                            // get_News();
                                            setState(() {});
                                          },
                                          child: Image.asset(
                                            'assets/like1.png',
                                            width: 30,
                                            height: 28,
                                          )),
                                  Text(
                                      'Interested (${result.likeCounter})',
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'Metropolis',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ))
                                ],
                              )),
                          SizedBox(
                            //width: MediaQuery.of(context).size.width / 3.5,
                            height: 18,
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                    onTap: () {},
                                    child: const ImageIcon(
                                      AssetImage('assets/show.png'),
                                      color: Colors.black,
                                      size: 20,
                                    )),
                                const SizedBox(width: 2),
                                Text(result.viewCounter.toString(),
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      fontFamily: 'Metropolis',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(
                              //width: MediaQuery.of(context).size.width / 5.0,
                              height: 18,
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        shareImage(
                                            url: result.imageUrl
                                                .toString(),
                                            title:
                                                result.title.toString());
                                      },
                                      child: const ImageIcon(
                                          AssetImage('assets/Send.png'))),
                                  const SizedBox(width: 2),
                                  const Text('Share',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'Metropolis',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ))
                                ],
                              )),
                        ],
                      ),
                      Container(
                        height: 15,
                      ),
                    ]),
              ),
            ]),
          ),
        ),
      );
    },
                );
  }

  Widget horiztallist() {
    return Container(
        height: 50,
        color: Colors.white,
        //margin: EdgeInsets.only(top: 5.0),
        //margin: EdgeInsets.fromLTRB(10, 2.0, 0.0, 0),
        child:
        // FutureBuilder(
        //
        //     //future: load_subcategory(),
        //     builder: (context, snapshot) {
        //   if (snapshot.connectionState == ConnectionState.none &&
        //       snapshot.hasData == null) {
        //     return const Center(child: CircularProgressIndicator());
        //   }
        //   if (snapshot.hasError) {
        //     return Text('Error: ${snapshot.error}');
        //   } else {
        //     //List<dynamic> users = snapshot.data as List<dynamic>;
        //     return
              ListView.builder(
                shrinkWrap: false,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: constanst.catdata.length,
                itemBuilder: (context, index) {
                  cat.Result result = constanst.catdata[index];
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Wrap(spacing: 6.0, runSpacing: 6.0, children: <
                          Widget>[
                        ChoiceChip(
                          label: Text(
                              constanst.catdata[index].categoryName.toString()),
                          selected: _defaultChoiceIndex == index,
                          selectedColor: const Color.fromARGB(255, 0, 91, 148),
                          onSelected: (bool selected) {
                            setState(() {
                              _defaultChoiceIndex = selected ? index : -1;

                              if (_tabController.index == 0) {
                                if (_defaultChoiceIndex == -1) {
                                  category_filter_id = "";
                                  getupexbitiondata.clear();
                                  _onLoading();
                                  get_UpcomingExhibition(offset.toString());
                                } else {
                                  category_filter_id =
                                      result.categoryId.toString();
                                  getupexbitiondata.clear();
                                  _onLoading();
                                  get_UpcomingExhibition(offset.toString());
                                }
                              } else if (_tabController.index == 1) {
                                if (_defaultChoiceIndex == -1) {
                                  category_filter_id = "";
                                  getupexbitiondata.clear();
                                  _onLoading();
                                  get_UpcomingExhibition(offset.toString());
                                } else {
                                  category_filter_id =
                                      result.categoryId.toString();
                                  getupexbitiondata.clear();
                                  _onLoading();
                                  get_UpcomingExhibition(offset.toString());
                                }
                              }
                            });
                          },
                          // padding: EdgeInsets.all(5),
                          backgroundColor:
                              const Color.fromARGB(255, 236, 232, 232),
                          labelStyle: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-Black.otf')
                              .copyWith(
                                  color: _defaultChoiceIndex == index
                                      ? Colors.white
                                      : Colors.black),
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 14.0),
                          /*shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),*/
                        )
                      ]));
                }),
        //   }
        // })
    );
  }

  Future<void> get_UpcomingExhibition(String offset) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getupcoming_exbition(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        offset.toString(),
        limit,
        category_filter_id);

    var jsonArray;
    if (res['status'] == 1) {
      if (res['data'] != null) {
        jsonArray = res['data'];

        //
        for (var data in jsonArray) {
          getnews.Data record = getnews.Data(
              id: data['id'],
              isLike: data['isLike'],
              viewCounter: data['view_counter'],
              metaDescription: data['meta_description'],
              startDate: data['start_date'],
              endDate: data['end_date'],
              location: data['location'],
              imageUrl: data['image_url'],
              likeCounter: data['like_counter'],
              title: data['title']);

          getupexbitiondata.add(record);
          //loadmore = true;
        }
        //isload = true;

        if (mounted) {
          setState(() {});
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonArray;
  }

  Future<void> get_pastExhibition(String offset) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getpast_exbition(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        offset.toString(),
        limit,
        category_filter_id);

    var jsonArray;
    if (res['status'] == 1) {
      if (res['data'] != null) {
        jsonArray = res['data'];

        //
        for (var data in jsonArray) {
          getnews.Data record = getnews.Data(
              id: data['id'],
              isLike: data['isLike'],
              viewCounter: data['view_counter'],
              metaDescription: data['meta_description'],
              startDate: data['start_date'],
              endDate: data['end_date'],
              location: data['location'],
              imageUrl: data['image_url'],
              likeCounter: data['like_counter'],
              title: data['title']);

          getpastexbitiondata.add(record);
          //loadmore = true;
        }

        if (mounted) {
          setState(() {});
        }
      } else {
        isload = true;
      }
    } else {
      isload = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonArray;
  }

  Future<void> Exhibitionlike(String newsId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await exbitionlike_like(
        newsId.toString(),
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString());

    if (res['status'] == 1) {
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {});
  }

  void getPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
    packageName = packageInfo!.packageName;
  }

  void shareImage({required String url, required String title}) async {
    final imageurl = url;
    final uri = Uri.parse(imageurl);
    final response = await http.get(uri);
    final bytes = response.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);
    await Share.shareFiles([path],
        text: title +
            "\t" +
            "\n" +
            "\n" +
            'Hey check out my app at: https://play.google.com/store/apps/details?id=' +
            packageName!);
  }

  void _scrollercontroller() {
    if (scrollercontroller.position.pixels ==
        scrollercontroller.position.maxScrollExtent) {
      if (_tabController.index == 0) {
        count++;
        if (count == 1) {
          offset = offset + 21;
        } else {
          offset = offset + 20;
        }
        _onLoading();
        get_UpcomingExhibition(offset.toString());
      } else if (_tabController.index == 1) {
        count++;

        if (count == 1) {
          offset = offset + 21;
        } else {
          offset = offset + 20;
        }
        _onLoading();
        get_pastExhibition(offset.toString());
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

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(dialogContext)
          .pop(); // Use dialogContext to close the dialog
      // Dialog closed
    });
  }

  void get_categorylist() async {
    GetCategoryController bt = GetCategoryController();
    constanst.cat_data = bt.setlogin();

    constanst.cat_data!.then((value) {
      for (var item in value) {
        constanst.catdata.add(item);
      }
      isload = true;
      setState(() {});
    });
  }
}
