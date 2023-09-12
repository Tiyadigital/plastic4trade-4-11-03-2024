import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:ui';
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
import '../model/QuickNews.dart';
import '../model/getNews.dart';

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
  String create_date = "", create_date1 = "";
  var create_formattedDate, update_formattedDate, descr;
  PackageInfo? packageInfo;
  @override
  void initState() {
    checknetowork();
    _tabController = TabController(length: 2, vsync: this);
    scrollercontroller.addListener(_scrollercontroller);
    super.initState();
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
  Future<bool> _onbackpress(BuildContext context) async {
   /* DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Show a toast or snackbar message to inform the user to tap again to exit
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tap again to exit')),
      );
      return Future.value(false);
    }
    SystemNavigator.pop();*/ // Close the app
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(0)));
    return Future.value(true);
  }
  Widget init() {
    return WillPopScope(
        onWillPop: () => _onbackpress(context),
    child: Scaffold(
      backgroundColor: Color(0xFFDADADA),
      body:  isload==true?Padding(
        padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
        child: Column(
          children: [
            // give the tab bar a height [can change hheight to preferred height]
            SizedBox(
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
                controller: _tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: Color.fromARGB(255, 0, 91, 148),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: [
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
            // tab bar view here
            isload
                ? Expanded(
                    child: TabBarView(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _tabController,
                        // first tab bar view widget
                        children: [
                        Quicknews(),
                        news()
                        /*news()*/
                      ])

                    // second tab bar view widget
                    )
                : Container()
          ],
        ),
      ): Center(
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

  Widget news() {
    return Container(
        padding: EdgeInsets.fromLTRB(2.0, 12.0, 3.0, 0),
        width: MediaQuery.of(context).size.width,
        child:
            /*  FutureBuilder(
                //future: load_category(),
                builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } if(snapshot.hasData) {
                //List<dynamic> users = snapshot.data as List<dynamic>;*/
            ListView.builder(
          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // crossAxisCount: 2,
          // mainAxisSpacing: 5,
          // crossAxisSpacing: 5,
          // childAspectRatio: .90,
          //  childAspectRatio:MediaQuery.of(context).size.height/700,
          // MediaQuery.of(context).size.aspectRatio * 2.55,
          // mainAxisSpacing: 12.0,
          // crossAxisCount: 1,

          physics: AlwaysScrollableScrollPhysics(),
          itemCount: getnewsdata.length,
          shrinkWrap: true,
          controller: scrollercontroller,
          itemBuilder: (context, index) {
            getnews.Result result = getnewsdata[index];

            //Fluttertoast.showToast(msg: result.isLike.toString());
            return GestureDetector(
              onTap: (() {
                // cate_name = record.name.toString();
                // cate_id = record.id.toString();
                // Fluttertoast.showToast(
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
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      /*shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10.0)),*/
                      child: Image(
                        errorBuilder: (context, object, trace) {
                          return Container(
                            decoration: BoxDecoration(
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
                          padding: EdgeInsets.all(8.0),
                          // child: Flexible(
                          child: Text(result.newsTitle.toString(),
                              maxLines: 2,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Metropolis',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ))
                          // )

                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                result.isLike == "0"
                                    ? IconButton(
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
                                        icon: ImageIcon(
                                          AssetImage('assets/like.png'),
                                        ))
                                    : GestureDetector(
                                        onTap: () {
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
                                        child: Image.asset(
                                          'assets/like1.png',
                                          width: 50,
                                          height: 28,
                                        )),
                                Text(
                                    'Like (' +
                                        result.likeCount.toString() +
                                        ')',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontFamily: 'Metropolis',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.remove_red_eye_outlined)),
                                Text('View (0)',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontFamily: 'Metropolis',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                          ),
                          Expanded(
                              child: Row(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    shareImage(
                                        url: result.newsImage.toString(),
                                        title: result.newsTitle.toString());
                                  },
                                  icon: ImageIcon(
                                    AssetImage('assets/Send.png'),
                                    size: 20,
                                  )),
                              Text('Share',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: 'Metropolis',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ))
                            ],
                          ))
                        ],
                      )
                    ],
                  )
                ]),
              ),
            );
          },
        ));
  }

  Widget Quicknews() {
    return Container(
      padding: EdgeInsets.fromLTRB(2.0, 8.0, 3.0, 0),
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
            /*childAspectRatio:
                        MediaQuery.of(context).size.aspectRatio * 6.5,
                    mainAxisSpacing: 2.0,
                    crossAxisCount: 1,*/
            // ),
            controller: scrollercontroller,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: getQuicknewsdata.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              getquicknews.Result record = getQuicknewsdata[index];

              DateFormat format = new DateFormat("yyyy-MM-dd");
              create_date = record.newsDate.toString();
              var updat_date = format.parse(create_date);

              create_date1 = record.newsDate.toString();
              var curret_date = format.parse(create_date);

              DateTime? dt1 = DateTime.parse(curret_date.toString());
              DateTime? dt2 = DateTime.parse(updat_date.toString());
              //print('dt1 $dt2');
              update_formattedDate =
                  dt2 != null ? DateFormat('dd-MMMM-yyyy').format(dt2) : "";
              descr = "<b>${record.longDescription}</b>";

              // print(dt1);

              create_formattedDate =
                  dt1 != null ? DateFormat("dd-MM-yyyy").format(dt1) : "";
              // print('Todat $create_formattedDate');
              String display_date = dateConverter(create_formattedDate);

              return GestureDetector(
                  onTap: (() {
                    // cate_name = record.name.toString();
                    // cate_id = record.id.toString();
                    // Fluttertoast.showToast(
                    //     msg: cate_id.toString());
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             Subcategory(cate_id, cate_name)));
                  }),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(display_date.toString(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Metropolis',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ))),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      record.newsImage != null
                                          ? Stack(
                                              fit: StackFit.passthrough,
                                              children: <Widget>[
                                                  Container(
                                                    height: 165,
                                                    width: 175,
                                                    margin:
                                                        EdgeInsets.all(5.0),
                                                    decoration: BoxDecoration(
                                                        //color: Colors.black26,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    30.0))),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
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
                                                          record.imageUrl
                                                              .toString(),
                                                          fit: BoxFit.cover,
                                                          height: 50,
                                                          width: 50,
                                                        )),
                                                  ),
                                                ])
                                          : Align(
                                              child: Container(
                                                height: 80,
                                                width: 80,
                                                margin: EdgeInsets.all(5.0),
                                                /* decoration: BoxDecoration(
                                          //color: Colors.black26,
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(30.0))),*/
                                                child: Image.asset(
                                                  "assets/plastic4trade logo final 1 (2).png",

                                                  //fit: BoxFit.fitHeight,
                                                  // height: 100,
                                                  width: 50,
                                                ),
                                              ),
                                              alignment: Alignment.topCenter,
                                            ),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 15.0, 0, 8.0),
                                              child: Text(
                                                  '${record.newsTitle}',
                                                  style: TextStyle(
                                                    fontSize: 10.0,
                                                    fontFamily: 'Metropolis',
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: Colors.black,
                                                  )),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 5.0, 0, 5.0),
                                              child: Text(
                                                  update_formattedDate,
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontFamily: 'Metropolis',
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    color: Colors.black,
                                                  )),
                                            ),
                                            Html(data: descr)
                                            /*Text(
                                                      'HPL, IOCL. HDPE PRICES NO CHANGES',
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontFamily: 'Metropolis',
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black,
                                                      )),*/
                                          ],
                                        ),
                                      ),
                                      //cartwidget(),
                                    ]),
                              ],
                            ),
                          )),
                    ],
                  ));
            },
          );
        }

        return CircularProgressIndicator();
      }),
    );
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      getPackage();
     await get_News();
      get_QuickNews();
      // get_data();
    }
  }

  Future<void> get_News() async {
    GetNews getsimmilar = GetNews();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getnewss(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = GetNews.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];

        //
        for (var data in jsonarray) {
          getnews.Result record = getnews.Result(
            newsId: data['newsId'],
            newsTitle: data['newsTitle'],
            newsImage: data['newsImage'],
            isLike: data['isLike'],
            likeCount: data['likeCount'],
          );

          getnewsdata.add(record);
          //loadmore = true;
        }

        print(getnewsdata);
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
    setState(() {});
  }

  Future<void> get_QuickNews() async {
    QuickNews getsimmilar = QuickNews();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getQuicknews(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(), offset.toString());

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = QuickNews.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];

        //
        for (var data in jsonarray) {
          getquicknews.Result record = getquicknews.Result(
            id: data['id'],
            longDescription: data['long_description'],
            newsTitle: data['news_title'],
            imageUrl: data['image_url'],
            newsDate: data['news_date'],
          );

          getQuicknewsdata.add(record);
          //loadmore = true;
        }
        isload = true;
        print(getnewsdata);
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    return jsonarray;
  }

  Future<void> Newslike(String news_id) async {
    GetNews getsimmilar = GetNews();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(news_id);
    var res = await news_like(
        news_id.toString(),
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = GetNews.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];

        isload = true;

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

  String dateConverter(String myDate) {
    String date;
    DateTime convertedDate = DateFormat("dd-MM-yyyy").parse(myDate.toString());
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
