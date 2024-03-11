
// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:Plastic4trade/model/getBlog.dart' as getblog;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:Plastic4trade/screen/BlogDetail.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';

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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: const Text('Blog',
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
      body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: isload
              ? Blog()
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
                          : Container())
          // tab bar view here

          ),
    );
  }

  Widget Blog() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: getblogsdata.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        getblog.Result result = getblogsdata[index];
        return GestureDetector(
          onTap: (() {
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
                borderRadius: BorderRadius.circular(13.05)),
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
            )]),
              child: Column(
                  children: [
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
                      image: NetworkImage(result.blogImage ?? ''
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
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        // child: Flexible(
                        child: Text(result.blogTitle.toString(),
                            maxLines: 2,
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Metropolis',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                            overflow: TextOverflow.ellipsis
                        )
                        // )
                        ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            result.isLike == "0"
                                ? IconButton(
                                    padding: const EdgeInsets.all(0),
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
                                    icon: const ImageIcon(
                                      AssetImage('assets/like.png',
                                      ),
                                      size: 17,
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
                                      width: 17,
                                      height: 17,
                                    )),
                            Text('Like (${result.likeCount ?? 0})',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Metropolis',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ))
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              padding: const EdgeInsets.all(0),
                                onPressed: () {},
                                iconSize: 17,
                                icon: const Icon(Icons.remove_red_eye_outlined,size: 17,)),
                            Text(
                                'View (${result.viewCounter})',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Metropolis',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ))
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              shareImage(
                                  url: result.blogImage.toString(),
                                  title: result.blogTitle.toString());
                            },
                            iconSize: 17,
                            icon: const ImageIcon(
                              AssetImage('assets/Send.png'),
                              size: 17,
                            )),
                        const Text('Share',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Metropolis',
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ))
                         ],
                        ),
                        const SizedBox(),
                      ],
                    )
                  ],
                )
              ]),
            ),
          ),
        );
      },
    );
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      getPackage();
      get_Blog();
    }
  }

  Future<void> get_Blog() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getblogs(pref.getString('user_id').toString(),
        pref.getString('api_token').toString());

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];

        for (var data in jsonArray) {
          getblog.Result record = getblog.Result(
              blogId: data['blogId'],
              blogTitle: data['BlogTitle'],
              blogImage: data['BlogImage'],
              isLike: data['isLike'],
              likeCount: data['likeCount'],
              viewCounter: data['view_counter']);
          getblogsdata.add(record);

        }
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

  Future<void> bloglike(String blogid) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await blog_like(
        blogid.toString(),
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString());

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
    setState(() {});
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
