import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../api/api_interface.dart';
import 'dart:io';
import '../model/GetNewsDetail.dart';
import '../model/getNews.dart';

class NewsDetail extends StatefulWidget {
  String news_id;

   NewsDetail({Key? key,required this.news_id}) : super(key: key);

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  PackageInfo? packageInfo;
  String? packageName;
  String? title;
  bool isload=false;
  String? news_date;
  int? newsId,view_counter;
  String? long_text,ShortContent;
  String? news_image;
  String? news_title;
  String? isLike;
  String? likeCount;
  var create_formattedDate;

  @override
  void initState() {
    checknetowork();
    //_tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      getPackage();
      get_NewsDetail();

      // get_data();
    }
  }

  void getPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
    String version = packageInfo!.version;
    String buildNumber = packageInfo!.buildNumber;
    print(
        "App Name : ${appName}, App Package Name: ${packageName },App Version: ${version}, App build Number: ${buildNumber}");
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Widget init() {
    return Scaffold(
        backgroundColor: Color(0xFFDADADA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text('news Detail',
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
        body: isload?SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              //padding: EdgeInsets.only(bottom: 3.0),
              child: Column(children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
                    height: 150,
                    child: Image.network(news_image.toString(),)
                ),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    child: Row(
                      children: [
                        isLike=="0"?
                        GestureDetector(
                            onTap: () {
                              newslike(newsId.toString());
                              isLike='1';
                              int like=int.parse(likeCount.toString());
                              like=like+1;
                              likeCount=like.toString();
                              /*getnewsdata.clear();
                                              get_News();*/
                              setState(() {});
                            },
                            child: Image.asset('assets/like.png',width: 50,height: 28,))
                            :GestureDetector(
                            onTap: () {
                              newslike(newsId.toString());
                              isLike='0';
                              int like=int.parse(likeCount.toString());
                              like=like-1;
                              likeCount=like.toString();
                              //getnewsdata.clear();
                              // get_News();
                              setState(() {});
                            },
                            child : Image.asset('assets/like1.png',width: 50,height: 28,)),
                        Text('Like ('+ likeCount.toString()+')',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Metropolis',
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            )),
                        SizedBox(
                            width: 126,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/view1.png', height: 25, width: 40,),
                                Text('Views ('+view_counter.toString()+')', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                    .copyWith(fontSize: 13, color: Theme
                                    .of(context)
                                    .accentColor))
                              ],
                            )
                        ),
                        GestureDetector(
                          child: SizedBox(
                              width: 90,
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/send2.png', height: 25, width: 40,),
                                  Text('Send', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                      .copyWith(fontSize: 13, color: Theme
                                      .of(context)
                                      .accentColor))
                                ],
                              )
                          ),
                          onTap: () {
                            shareImage(url: news_image.toString(), title: news_title.toString());
                          },
                        )
                      ],
                    )),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Align(

                              child: Text(news_title.toString(),
                                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                      .copyWith(fontSize: 16)),
                              alignment: Alignment.topLeft,
                            )),
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child:
                            Align(

                              child: Text(create_formattedDate,
                                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                              alignment: Alignment.topLeft,
                            )),
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child:
                            Align(

                              child: Html(data: long_text),
                              /*child: Text(
                                  'In addition to the exhibition and conference, Oman Plast 2023 also features a registration process for attendees and exhibitors. The registration process is simple and can be done online via the OMAN PLAST login portal. Exhibitors can register for the event in advance and secure their',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .displaySmall),*/
                              alignment: Alignment.topLeft,
                            )),

                      ],
                    )
                ),

              ]),
            )):Center(
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
    : Container()),);
  }

  Future<void> get_NewsDetail() async {
    GetNewsDetail commonPostdetail = GetNewsDetail();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    //Fluttertoast.showToast(msg: widget.news_id.toString());
    var res = await getnewssdetail(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(), widget.news_id.toString());
    var jsonarray;
    print(res);
    if (res['status'] == 1) {

      commonPostdetail = GetNewsDetail.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];
        print(jsonarray['ShortContent']);
        ShortContent=jsonarray['ShortContent'];
          long_text = jsonarray['LongContent'];
          news_date = jsonarray['newsDate'];
          news_title = jsonarray['newsTitle'];
          news_image = jsonarray['newsImage'];
        likeCount=jsonarray['likeCount'];
        isLike=jsonarray['isLike'];
        newsId=jsonarray['newsId'];
        view_counter=jsonarray['viewCounter'];

        DateFormat format = new DateFormat("yyyy-MM-dd");
        var curret_date = format.parse(news_date.toString());

        DateTime? dt1 = DateTime.parse(curret_date.toString());

        // print(dt1);
        create_formattedDate =
        dt1 != null ? DateFormat('dd MMMM, yyyy').format(dt1) : "";

        isload=true;
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: res['message']);
      }
      return jsonarray;
      setState(() {});
    }
  }
  Future<void> newslike(String newsid) async {
    GetNews getsimmilar = GetNews();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(newsid);
    var res = await news_like(newsid.toString(),_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = GetNews.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];
        print(jsonarray['message']);


        isload=true;

        // setState(() {});
        if (mounted) {
          setState(() {

          });
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
    setState(() {});
  }

  void shareImage({required String url,required String title}) async {
    final imageurl = url;
    final uri = Uri.parse(imageurl);
    final response = await http.get(uri);
    final bytes = response.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);
    await Share.shareFiles([path], text: title+"\t"+"\n"+ "\n"+'Hey check out my app at: https://play.google.com/store/apps/details?id='+packageName!);
  }
}