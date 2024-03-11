// ignore_for_file: prefer_typing_uninitialized_variables, import_of_legacy_library_into_null_safe, depend_on_referenced_packages, non_constant_identifier_names, unnecessary_null_comparison, prefer_interpolation_to_compose_strings

import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:Plastic4trade/model/getNews.dart' as getnews;
import 'package:Plastic4trade/model/QuickNews.dart' as getquicknews;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/screen/NewsDetail.dart';
import 'package:Plastic4trade/widget/MainScreen.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<getnews.Result> getnewsdata = [];
  List<getquicknews.Result> getQuicknewsdata = [];
  bool isload = false;
  String? packageName;
  int offset = 0;
  int count = 0;
  final scrollercontroller = ScrollController();
  var create_formattedDate;
  PackageInfo? packageInfo;
  int sameDateCount = 0;
  List showdate =[];

  @override
  void initState() {
    checknetowork();
    _tabController = TabController(length: 2, vsync: this);
    scrollercontroller.addListener(_scrollercontroller);
    super.initState();
  }

  void getPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
    packageName = packageInfo!.packageName;
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Future<bool> _onbackpress(BuildContext context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainScreen(0)));
    return Future.value(true);
  }

  Widget init() {
    return WillPopScope(
        onWillPop: () => _onbackpress(context),
        child: Scaffold(
          backgroundColor: const Color(0xFFDADADA),
          body: isload == true
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: Column(
                    children: [
                      // give the tab bar a height [can change height to preferred height]
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
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
                            borderRadius: BorderRadius.circular(42.26),
                            color: const Color.fromARGB(255, 0, 91, 148),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          tabs: const [
                            // first tab [you can add an icon using the icon property]
                            Tab(
                              //text: 'Quick News',
                              child: Text(
                                'Quick News',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Metropolis',
                                ),
                              ),
                            ),

                            // second tab [you can add an icon using the icon property]
                            Tab(
                              child: Text(
                                'News',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Metropolis',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 11,
                      ),
                      // tab bar view here
                      isload
                          ? Expanded(
                            child: TabBarView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: _tabController,
                                // first tab bar view widget
                                children: [
                                Quicknews(),
                                news()
                                /*news()*/
                              ]),
                          )
                          : Container()
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
                          : Container()),
        ));
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
        get_QuickNews();
      }
    } /*else{
      print('hello');
    }*/
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

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(dialogContext)
          .pop(); // Use dialogContext to close the dialog
      // Dialog closed
    });
  }

  Widget news() {
    return ListView.builder(
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // crossAxisCount: 2,
              // mainAxisSpacing: 5,
              // crossAxisSpacing: 5,
              // childAspectRatio: .90,
              //  childAspectRatio:MediaQuery.of(context).size.height/700,
              // MediaQuery.of(context).size.aspectRatio * 2.55,
              // mainAxisSpacing: 12.0,
              // crossAxisCount: 1,

              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: getnewsdata.length,
              shrinkWrap: true,
              controller: scrollercontroller,
              itemBuilder: (context, index) {
    getnews.Result result = getnewsdata[index];
    //Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: result.isLike.toString());
    return Column(
      children: [
        GestureDetector (
          onTap: (() {
            // cate_name = record.name.toString();
            // cate_id = record.id.toString();
            // Fluttertoast.showToast(timeInSecForIosWeb: 2,
            //     msg: cate_id.toString());
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             Subcategory(cate_id, cate_name)));
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NewsDetail(news_id: result.newsId.toString()),
                ));
          }),
          child: Container(
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
            ],),
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
                    image: NetworkImage(result.newsImage ?? ''
                        //data[index]['member_image'] ?? '',
                        ),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                       result.newsTitle.toString(),
                       maxLines: 2,
                       style: const TextStyle(
                         color: Colors.black,
                         fontSize: 14,
                         fontFamily: 'Metropolis',
                         fontWeight: FontWeight.w600,
                         letterSpacing: -0.24,
                         overflow: TextOverflow.ellipsis,
                       ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          result.isLike == "0"
                            ? IconButton    (
                            iconSize: 17,
                              padding: const EdgeInsets.all(0),
                                onPressed: () {
                                  Newslike(result.newsId.toString());
                                  result.isLike = '1';
                                  int like = int.parse(
                                      result.likeCount.toString());
                                  like = like + 1;
                                  result.likeCount = like.toString();
                                  /*getnewsdata.clear();
                                      get_News();*/
                                  setState(() {});
                                },
                                icon: const ImageIcon(
                                  size: 17,
                                  AssetImage('assets/like.png'),
                                ))
                            : IconButton(
                              padding: const EdgeInsets.all(0),
                            onPressed: (){
                              Newslike(result.newsId.toString());
                              result.isLike = '0';
                              int like = int.parse(
                                  result.likeCount.toString());
                              like = like - 1;
                              result.likeCount = like.toString();
                              //getnewsdata.clear();
                              // get_News();
                              setState(() {});
                            },
                            icon: const ImageIcon(
                            size: 17,
                            color: Color(0xFF005C94),
                            AssetImage('assets/like1.png'),
                            )),
                            Text('Like (${result.likeCount})',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Metropolis',
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.24,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            iconSize: 17,
                            padding: const EdgeInsets.all(0),
                              onPressed: () {},
                              icon: const Icon(
                                  Icons.remove_red_eye_outlined,size: 17,)),
                           Text('View (${result.viewCounter})',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Metropolis',
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.24,
                              ))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Row(
                        children: [
                        IconButton(
                          iconSize: 14,
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              shareImage(
                                  url: result.newsImage.toString(),
                                  title: result.newsTitle.toString());
                            },
                            icon: const ImageIcon(
                              AssetImage('assets/Send.png'),
                              size: 14,
                            )),
                        const Text('Share',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Metropolis',
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.24,
                            ))
                            ],
                          ),
                      ),
                      //const SizedBox(),
                    ],
                  )
                ],
              )
            ]),
          ),
        ),
        const SizedBox(height: 13),
      ],
    );
    },
  );
  }

  Widget Quicknews() {
    return  ListView.builder(
      //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      // crossAxisCount: 2,
      // mainAxisSpacing: 5,
      // crossAxisSpacing: 5,
      // childAspectRatio: .90,
      /*childAspectRatio:
                      MediaQuery.of(context).size.aspectRatio * 6.5,
                  mainAxisSpacing: 2.0,
                  crossAxisCount: 1,*/
      // ),
      controller: scrollercontroller,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: getQuicknewsdata.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        getquicknews.Result record = getQuicknewsdata[index];
        String displayDate = "";
        if(record.newsDate != null){
        create_formattedDate = DateFormat("dd-MMM-yyyy").format(DateFormat("yyyy-MM-dd").parse(record.newsDate.toString()));
        displayDate = dateConverter(create_formattedDate);
        }
        return GestureDetector(
            onTap: (() {
              // cate_name = record.name.toString();
              // cate_id = record.id.toString();
              // Fluttertoast.showToast(timeInSecForIosWeb: 2,
              //     msg: cate_id.toString());
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             Subcategory(cate_id, cate_name)));
            }),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(index == 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(displayDate.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          height: 0.06,
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.24,
                        )),
                  ),
                if(index > 0 && getQuicknewsdata[index - 1].newsDate != null)
                dateConverter(DateFormat("dd-MMM-yyyy").format(DateTime.parse(getQuicknewsdata[index - 1].newsDate.toString()))) != displayDate ?
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(displayDate.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w600,
                        height: 0.06,
                        letterSpacing: -0.24,
                      )),
                )
                    : const SizedBox(),
                Container(
                  padding: const EdgeInsets.all(10),
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
                    ],),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        record.newsImage != null
                            ? Stack(
                            fit: StackFit.passthrough,
                            children: <Widget>[
                              Container(
                                height: 165,
                                width: 175,
                                margin:
                                const EdgeInsets.all(5.0),
                                decoration:
                                const BoxDecoration(
                                  //color: Colors.black26,
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(
                                            30.0))),
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(
                                        20.0),
                                    /*shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10.0)),*/
                                    /* child: record.newsImage!=null? Image.network(
                                              record.newsImage.toString(),

                                          fit: BoxFit.cover,
                                          height: 100,
                                          width: 100,
                                        ):Image.asset("assets/plastic4trade logo final 1 (4).png") as ImageProvider,*/
                                    child: Image.network(
                                      record.imageUrl.toString(),
                                      fit: BoxFit.cover,
                                      height: 50,
                                      width: 50,
                                    )),
                              ),
                            ])
                            : SizedBox(
                              height: 50,
                              width: 50,
                              /* decoration: BoxDecoration(
                                  //color: Colors.black26,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),*/
                              child: Image.asset(
                                "assets/plastic4trade logo final 1 (2).png",
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                              ),
                            ),
                        const SizedBox(width: 9,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                                child: Text('${record.newsTitle}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontFamily: 'Metropolis',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(create_formattedDate,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontFamily: 'Metropolis',
                                    fontWeight: FontWeight.w400,
                                    height: 0.20,
                                    letterSpacing: -0.24,
                                  ),),
                              ),
                              Html(data: record.longDescription,
                                style: {
                                  "p": Style(
                                    fontSize: FontSize(12),
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.24,
                                    fontFamily: 'Metropolis',
                                  ),
                                  "body": Style(
                                    fontSize: FontSize(12),
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.24,
                                    fontFamily: 'Metropolis',
                                  ),
                                },
                              )
                            ],
                          ),
                        ),
                      ]),
                ),
                const SizedBox(height: 7),
              ],
            ));
      },
    );
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(
          timeInSecForIosWeb: 2, msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      getPackage();
      await get_News();
      get_QuickNews();
      // get_data();
    }
  }

  Future<void> get_News() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getnewss(pref.getString('user_id').toString(),
        pref.getString('api_token').toString());

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];

        //
        for (var data in jsonArray) {
          getnews.Result record = getnews.Result(
            newsId: data['newsId'],
            newsTitle: data['newsTitle'],
            newsImage: data['newsImage'],
            isLike: data['isLike'],
            likeCount: data['likeCount'],
            viewCounter: data['viewCounter'],
          );
          print("record:-${record.viewCounter}");
          getnewsdata.add(record);
          //loadmore = true;
        }

        if (mounted) {
          setState(() {});
        }
      }
    } else {
      Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: res['message']);
    }
    return jsonArray;
  }

  Future<void> get_QuickNews() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getQuicknews(pref.getString('user_id').toString(),
        pref.getString('api_token').toString(), offset.toString());

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];

        //
        for (var data in jsonArray) {
          getquicknews.Result record = getquicknews.Result(
            id: data['id'],
            longDescription: data['long_description'],
            newsTitle: data['news_title'],
            imageUrl: data['image_url'],
            newsDate: data['news_date'],
          );

          getQuicknewsdata.add(record);
        }
        isload = true;
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: res['message']);
    }

    return jsonArray;
  }

  Future<void> Newslike(String newsId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await news_like(
        newsId.toString(),
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString());

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];

        isload = true;

        // setState(() {});
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      Fluttertoast.showToast(timeInSecForIosWeb: 2, msg: res['message']);
    }
    setState(() {});
    return jsonArray;
  }

  String dateConverter(String myDate) {
    String date;
    DateTime convertedDate = DateFormat("dd-MMM-yyyy").parse(myDate.toString());
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final dateToCheck = convertedDate;
    final checkDate =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);

    if (checkDate == today) {
      date = "Today";
    } else if (checkDate == yesterday) {
      date = "Yesterday";
    } else if (checkDate == tomorrow) {
      date = "Tomorrow";
    } else {
      date = myDate;
    }
    return date;
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
}
