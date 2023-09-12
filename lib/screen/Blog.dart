import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:Plastic4trade/model/getBlog.dart' as getblog;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:Plastic4trade/screen/BlogDetail.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

import '../api/api_interface.dart';
import '../model/getNews.dart';

class Blog extends StatefulWidget {
  const Blog({Key? key}) : super(key: key);

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  String? packageName;
  PackageInfo? packageInfo;
  List<getblog.Result> getblogsdata = [];
  bool isload = false;
  @override
  void initState() {
    checknetowork();
    //_tabController = TabController(length: 2, vsync: this);

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

  Widget init() {
    return Scaffold(
      backgroundColor: Color(0xFFDADADA),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: Text('Blog',
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
      body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: isload
              ? Blog()
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
          // tab bar view here

          ),
    );
  }

  Widget Blog() {
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
          itemCount: getblogsdata.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            getblog.Result result = getblogsdata[index];

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
                          BlogDetail(blog_id: result.blogId.toString()),
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
                    child: Image(
                      errorBuilder: (context, object, trace) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 223, 220, 220),
                          ),
                        );
                      },
                      image: NetworkImage(result.blogImage ?? ''
                          //data[index]['member_image'] ?? '',
                          ),
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          // child: Flexible(
                          child: Text(result.blogTitle.toString(),
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
                                          bloglike(result.blogId.toString());
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
                                          bloglike(result.blogId.toString());
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
                                Text(
                                    'View (' +
                                        result.viewCounter.toString() +
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
                                  onPressed: () {
                                    shareImage(
                                        url: result.blogImage.toString(),
                                        title: result.blogTitle.toString());
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

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      getPackage();
      get_Blog();
      // get_data();
    }
  }

  Future<void> get_Blog() async {
    GetNews getsimmilar = GetNews();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getblogs(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = GetNews.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];

        for (var data in jsonarray) {
          getblog.Result record = getblog.Result(
              blogId: data['blogId'],
              blogTitle: data['BlogTitle'],
              blogImage: data['BlogImage'],
              isLike: data['isLike'],
              likeCount: data['likeCount'],
              viewCounter: data['view_counter']);

          getblogsdata.add(record);
          //loadmore = true;
        }
        isload = true;
        print(getblogsdata);
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

  Future<void> bloglike(String blogid) async {
    GetNews getsimmilar = GetNews();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(blogid);
    var res = await blog_like(
        blogid.toString(),
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
