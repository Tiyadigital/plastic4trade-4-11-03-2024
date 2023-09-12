import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Plastic4trade/model/getFollowerList.dart' as getfllow;
import 'package:Plastic4trade/model/getFollowingList.dart' as getfllowing;

import '../api/api_interface.dart';
import '../model/common.dart';
import '../model/getFollowerList.dart';
import '../model/getFollowingList.dart';

class follower extends StatefulWidget {
  const follower({Key? key}) : super(key: key);

  @override
  State<follower> createState() => _followerState();
}


class _followerState extends State<follower>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<getfllow.Result> getfollowdata = [];
  List<getfllowing.Result> getfllowingdata = [];
  int? totalfollowers = 0,
      totalfollowing = 0;
  String? followstatus = 'follow';
  bool? loading = false;
  TextEditingController follower_search = TextEditingController();
  TextEditingController following_search = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    checknetowork();
    super.initState();
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
        title: Text('Followers/Followings',
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
      body: loading == true ? Padding(
        padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
        child: Column(
          children: [
            // give the tab bar a height [can change hheight to preferred height]
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
                      'Followers ($totalfollowers)',
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
                      'Following ($totalfollowing)',
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
            Expanded(
                child: TabBarView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _tabController,
                    // first tab bar view widget
                    children: [
                      follower(),
                      followering()
                      /*news()*/
                    ])

              // second tab bar view widget
            ),
          ],
        ),
      ) :Center(
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
    );
  }

  Widget follower() {
    return Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.fromLTRB(0, 8.0, 0.0, 5.0),
          child: Container(
              height: 50,
              /*decoration: BoxDecoration(
    border: Border.all(width: 1),
    borderRadius: BorderRadius.circular(50.0),
    color: Color.fromARGB(255, 0, 91, 148)),*/

              child: TextFormField(
                controller: follower_search,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                textCapitalization: TextCapitalization.words,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,

                textInputAction: TextInputAction.search,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r"[a-zA-Z]+|\s"),
                  ),
                  // LengthLimitingTextInputFormatter(50)
                ],
                // textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Search User",
                  hintStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                      ?.copyWith(color: Colors.black45),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20),
                  prefixIcon: Icon(Icons.search),

                  focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 1, color: Colors.black45),
                      borderRadius:
                      BorderRadius.circular(12.0)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black45),
                      borderRadius: BorderRadius.circular(12.0)),


                  //errorText: _validusernm ? 'Name is not empty' : null),
                ),
                onFieldSubmitted: (value) {
                  print(follower_search.text.toString());
                  getfollowdata.clear();

                  _onLoading();
                  get_follwer();
                  setState(() {});
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    getfollowdata.clear();
                    _onLoading();
                    get_follwer();
                    setState(() {});
                  }
                },

              ))),
      Expanded(
          child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: FutureBuilder(

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
                          physics: const ScrollPhysics(),
                          itemCount: getfollowdata.length,
                          padding: EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
                          itemBuilder: (context, index) {
                            // Choice record = choices[index];
                            getfllow.Result result = getfollowdata[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {});
                              },
                              child: Container(
                                  height: 80,

                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))
                                    ),
                                    elevation: 5,
                                    child: Container(
                                      child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5.0, 0, 5.0, 0.0),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 25,
                                                  backgroundImage: result.image
                                                      .toString() != ''
                                                      ? NetworkImage(
                                                      result.image
                                                          .toString()) as ImageProvider
                                                      : AssetImage(
                                                      'assets/plastic4trade logo final 1 (2).png'),
                                                )),
                                            Expanded(

                                                child: Text(
                                                    result.name.toString(),
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight
                                                            .w400,
                                                        color: Colors.black,
                                                        fontFamily: 'assets\fonst\Metropolis-Black.otf'))
                                            ),
                                            Padding(padding: EdgeInsets.only(
                                                right: 10),

                                                child: result.isFollowing == 1
                                                    ? Container(

                                                    padding: EdgeInsets.all(
                                                        5.0),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 0, 91, 148),
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(50)),
                                                    ),
                                                    height: 25,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 6.5,
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          setfollowUnfollow('1',
                                                              result.id
                                                                  .toString());
                                                          followstatus =
                                                          'followed';
                                                          setState(() {

                                                          });
                                                        },
                                                        child: Text('followed',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight
                                                                  .w500),
                                                          textAlign: TextAlign
                                                              .center,))
                                                )
                                                    : Container(

                                                    padding: EdgeInsets.all(
                                                        5.0),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 0, 91, 148),
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(50)),
                                                    ),
                                                    height: 25,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 6.5,
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          setfollowUnfollow('1',
                                                              result.id
                                                                  .toString());

                                                          result.isFollowing ==
                                                              1;
                                                          setState(() {

                                                          });
                                                        },
                                                        child: Text('follow',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight
                                                                  .w500),
                                                          textAlign: TextAlign
                                                              .center,))
                                                )
                                            ),
                                          ]),
                                    ),
                                  )),
                            );
                          });
                    }
                  })))
    ]);
  }

  Widget followering() {
    return Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.fromLTRB(0, 8.0, 0.0, 5.0),
          child: SizedBox(
              height: 45,
              child: TextFormField(
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                textCapitalization: TextCapitalization.words,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,
                controller: following_search,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r"[a-zA-Z]+|\s"),
                  ),
                  // LengthLimitingTextInputFormatter(50)
                ],

                onFieldSubmitted: (value) {
                  getfollowdata.clear();
                  _onLoading();
                  get_following();
                  setState(() {});
                },
                onChanged: (value) {
                  getfollowdata.clear();
                  _onLoading();
                  get_following();
                  setState(() {});
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Search User",
                  hintStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                      ?.copyWith(color: Colors.black45),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20),
                  prefixIcon: Icon(Icons.search),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 1, color: Colors.black45),
                      borderRadius:
                      BorderRadius.circular(15.0)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black45),
                      borderRadius: BorderRadius.circular(15.0)),

                  //errorText: _validusernm ? 'Name is not empty' : null),
                ),
              ))),
      Expanded(
          child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: FutureBuilder(

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
                          physics: const ScrollPhysics(),
                          itemCount: getfllowingdata.length,
                          padding: EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
                          itemBuilder: (context, index) {
                            // Choice record = choices[index];

                            getfllowing.Result result = getfllowingdata[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {});
                              },
                              child: Container(
                                  height: 80,

                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))
                                    ),
                                    elevation: 5,
                                    child: Container(
                                      child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5.0, 0, 5.0, 0.0),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 25,
                                                  backgroundImage: result.image
                                                      .toString() != ''
                                                      ? NetworkImage(
                                                      result.image
                                                          .toString()) as ImageProvider
                                                      : AssetImage(
                                                      'assets/plastic4trade logo final 1 (2).png'),
                                                )),
                                            Expanded(

                                                child: Text(
                                                  result.name.toString(),
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      color: Colors.black,
                                                      fontFamily: 'assets\fonst\Metropolis-Black.otf'),)
                                            ),
                                            Padding(padding: EdgeInsets.only(
                                                right: 10),
                                                child: Container(

                                                    padding: EdgeInsets.all(
                                                        5.0),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 0, 91, 148),
                                                      borderRadius: BorderRadius
                                                          .all(
                                                          Radius.circular(50)),
                                                    ),
                                                    height: 25,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width / 6.5,
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          //getfllowingdata.clear();
                                                          getfllowingdata
                                                              .removeAt(index);
                                                          totalfollowing =
                                                              getfllowingdata
                                                                  .length;
                                                          setfollowUnfollow('0',
                                                              result.id
                                                                  .toString());

                                                          setState(() {

                                                          });
                                                        },
                                                        child: Text('Unfollow',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight
                                                                  .w500),
                                                          textAlign: TextAlign
                                                              .center,))
                                                )),
                                          ]),
                                    ),
                                  )),
                            );
                          });
                    }
                  })))
    ]);
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      // getPackage();
      get_follwer();
      get_following();
      loading = true;

      // get_data();
    }
  }

  Future<void> get_follwer() async {
    getfollowdata.clear();
    getFollowerList getfollwelist = getFollowerList();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getFollowerLists(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        _pref.getString('user_id').toString(), follower_search.text);

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getfollwelist = getFollowerList.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];
        totalfollowers = res['totalFollowers'];

        for (var data in jsonarray) {
          getfllow.Result record = getfllow.Result(
              isFollowing: data['is_following'],
              name: data['name'],
              id: data['id'],
              image: data['image'],
              status: data['Status']
          );

          getfollowdata.add(record);
          //loadmore = true;
        }

        print(getfollowdata);
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

  Future<void> get_following() async {
    getfllowingdata.clear();
    getFollowingList getfollwinglist = getFollowingList();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getfollwingList(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        _pref.getString('user_id').toString(),
        following_search.text.toString());

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getfollwinglist = getFollowingList.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];
        totalfollowing = res['totalFollowing'];

        for (var data in jsonarray) {
          getfllowing.Result record = getfllowing.Result(
              name: data['name'],
              id: data['id'],
              image: data['image'],
              status: data['Status']
          );

          getfllowingdata.add(record);
          //loadmore = true;
        }

        print(getfllowingdata);
        if (mounted) {
          setState(() {

          });
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }

  Future<void> setfollowUnfollow(String follow, String otherUserId) async {
    common_par getsimmilar = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();


    var res = await followUnfollow(
        follow, otherUserId, _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = common_par.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];


        get_following();

        // setState(() {});
        if (mounted) {
          setState(() {

          });
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
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
          ),

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
}