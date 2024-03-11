// ignore_for_file: depend_on_referenced_packages, import_of_legacy_library_into_null_safe, must_be_immutable, non_constant_identifier_names, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, unnecessary_null_comparison

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

class NewsDetail extends StatefulWidget {
  String news_id;

  NewsDetail({Key? key, required this.news_id}) : super(key: key);

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  PackageInfo? packageInfo;
  String? packageName;
  String? title;
  bool isload = false;
  String? news_date;
  int? newsId, view_counter;
  String? long_text, ShortContent;
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
    packageName = packageInfo!.packageName;
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Widget init() {
    return Scaffold(
      backgroundColor: const Color(0xFFDADADA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'News Detail',
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
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: isload
          ? SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(children: [
                Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
                    height: 150,
                    child: Image.network(
                      news_image.toString(),
                    )),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  child: Row(
                    children: [
                      isLike == "0"
                          ? GestureDetector(
                              onTap: () {
                                newslike(
                                  newsId.toString(),
                                );
                                isLike = '1';
                                int like = int.parse(
                                  likeCount.toString(),
                                );
                                like = like + 1;
                                likeCount = like.toString();
                                /*getnewsdata.clear();
                                            get_News();*/
                                setState(() {});
                              },
                              child: Image.asset(
                                'assets/like.png',
                                width: 50,
                                height: 28,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                newslike(
                                  newsId.toString(),
                                );
                                isLike = '0';
                                int like = int.parse(
                                  likeCount.toString(),
                                );
                                like = like - 1;
                                likeCount = like.toString();
                                //getnewsdata.clear();
                                // get_News();
                                setState(() {});
                              },
                              child: Image.asset(
                                'assets/like1.png',
                                width: 50,
                                height: 28,
                              ),
                            ),
                      Text(
                        'Like ($likeCount)',
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                          width: 126,
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/view1.png',
                                height: 25,
                                width: 40,
                              ),
                              Text(
                                'Views ($view_counter)',
                                style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf')
                                    .copyWith(
                                        fontSize: 13,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                              )
                            ],
                          )),
                      GestureDetector(
                        child: SizedBox(
                            width: 90,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/send2.png',
                                  height: 25,
                                  width: 40,
                                ),
                                Text(
                                  'Send',
                                  style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets/fonst/Metropolis-Black.otf')
                                      .copyWith(
                                          fontSize: 13,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                )
                              ],
                            )),
                        onTap: () {
                          shareImage(
                            url: news_image.toString(),
                            title: news_title.toString(),
                          );
                        },
                      )
                    ],
                  ),
                ),
                Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
                    padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              news_title.toString(),
                              style: const TextStyle(
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      fontFamily:
                                          'assets/fonst/Metropolis-Black.otf')
                                  .copyWith(fontSize: 16),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              create_formattedDate,
                              style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-Black.otf'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Html(data: long_text,
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
                            ),
                          ),
                        ),
                      ],
                    )),
              ]),
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

  Future<void> get_NewsDetail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var res = await getnewssdetail(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
      widget.news_id.toString(),
    );

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];
        ShortContent = jsonArray['ShortContent'];
        long_text = jsonArray['LongContent'];
        news_date = jsonArray['newsDate'];
        news_title = jsonArray['newsTitle'];
        news_image = jsonArray['newsImage'];
        likeCount = jsonArray['likeCount'];
        isLike = jsonArray['isLike'];
        newsId = jsonArray['newsId'];
        view_counter = jsonArray['viewCounter'];

        DateFormat format = DateFormat("yyyy-MM-dd");
        var curretDate = format.parse(
          news_date.toString(),
        );

        DateTime? dt1 = DateTime.parse(
          curretDate.toString(),
        );

        // print(dt1);
        create_formattedDate =
            dt1 != null ? DateFormat('dd MMMM, yyyy').format(dt1) : "";

        isload = true;
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: res['message']);
      }
      return jsonArray;
    }
  }

  Future<void> newslike(String newsid) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await news_like(
      newsid.toString(),
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];

        isload = true;

        if (mounted) {
          setState(() {});
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonArray;
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
