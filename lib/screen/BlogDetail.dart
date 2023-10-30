// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_typing_uninitialized_variables, non_constant_identifier_names, unnecessary_null_comparison, import_of_legacy_library_into_null_safe, depend_on_referenced_packages, must_be_immutable

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';

class BlogDetail extends StatefulWidget {
  String blog_id;

   BlogDetail({Key? key,required this.blog_id}) : super(key: key);

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  PackageInfo? packageInfo;
  String? packageName;
  String? title;
  bool isload=false;
  String? blog_date;
  int? blogId;
  String? long_text;
  String? blog_image;
  String? blog_title;
  String? isLike;
  String? likeCount;
  var create_formattedDate;

  @override
  void initState() {
    checknetowork();
    super.initState();
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: 'Internet Connection not available');
    } else {
      getPackage();
      get_Blogdetail();
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
          title: const Text('Blog Detail',
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
        body: isload
            ?SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(children: [
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
                  height: 150,
                  child: Image.network(blog_image.toString(),)
              ),
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  child: Row(
                    children: [
                      isLike=="0"?
                      GestureDetector(
                          onTap: () {
                            bloglike(blogId.toString());
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
                            bloglike(blogId.toString());
                            isLike='0';
                            int like=int.parse(likeCount.toString());
                            like=like-1;
                            likeCount=like.toString();
                            //getnewsdata.clear();
                            // get_News();
                            setState(() {});
                          },
                          child : Image.asset('assets/like1.png',width: 50,height: 28,)),
                      Text('Like ($likeCount)',
                          style: const TextStyle(
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
                              Text('Views (230)', style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf')
                                  .copyWith(fontSize: 13, color: Theme
                                  .of(context)
                                  .colorScheme.secondary))
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
                                Text('Send', style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf')
                                    .copyWith(fontSize: 13, color: Theme
                                    .of(context)
                                    .colorScheme.secondary))
                              ],
                            )
                        ),
                        onTap: () {
                          shareImage(url: blog_image.toString(), title: blog_title.toString());
                        },
                      )
                    ],
                  )),
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(

                            alignment: Alignment.topLeft,

                            child: Text(blog_title.toString(),
                                style: const TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700, color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf')
                                    .copyWith(fontSize: 16)),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child:
                          Align(

                            alignment: Alignment.topLeft,

                            child: Text(create_formattedDate,
                                style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets/fonst/Metropolis-Black.otf')),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child:
                          Align(

                            alignment: Alignment.topLeft,

                            child: Html(data: long_text),
                          )),

                    ],
                  )
              ),

            ])):

        Center(
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
    );
  }

  Future<void> get_Blogdetail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: widget.blog_id.toString());
    var res = await getblogsdetail(pref.getString('user_id').toString(),
        pref.getString('api_token').toString(), widget.blog_id.toString());
    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];

          long_text = jsonArray['LongContent'];
          blog_date = jsonArray['BlogDate'];
          blog_title = jsonArray['BlogTitle'];
          blog_image = jsonArray['BlogImage'];
        likeCount=jsonArray['likeCount'];
        isLike=jsonArray['isLike'];
        blogId=jsonArray['blogId'];

        DateFormat format = DateFormat("yyyy-MM-dd");
        var curret_date = format.parse(blog_date.toString());

        DateTime? dt1 = DateTime.parse(curret_date.toString());

        // print(dt1);
        create_formattedDate =
        dt1 != null ? DateFormat('dd MMMM, yyyy').format(dt1) : "";

        isload = true;
        setState(() {});
      } else {
        Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: res['message']);
      }
      return jsonArray;
     
    }
  }
  Future<void> bloglike(String blogid) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await blog_like(blogid.toString(),pref.getString('user_id').toString(),
        pref.getString('api_token').toString());

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];
        isload=true;
        setState(() { });

        if (mounted) {

        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonArray;
   
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