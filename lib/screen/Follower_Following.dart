// ignore_for_file: camel_case_types, unnecessary_null_comparison, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:io';

import 'package:Plastic4trade/model/getFollowerList.dart' as getfllow;
import 'package:Plastic4trade/model/getFollowingList.dart' as getfllowing;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';

class follower extends StatefulWidget {
  final initialIndex;
  const follower({Key? key, this.initialIndex}) : super(key: key);

  @override
  State<follower> createState() => _followerState();
}

class _followerState extends State<follower>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<getfllow.Result> getfollowdata = [];
  List<getfllowing.Result> getfllowingdata = [];
  int? totalfollowers = 0, totalfollowing = 0;
  String? followstatus = 'follow';
  bool? loading = false;
  TextEditingController follower_search = TextEditingController();
  TextEditingController following_search = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: widget.initialIndex, vsync: this);
    checkNetwork();
    super.initState();
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
        title: const Text(
          'Followers/Followings',
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
      body: loading == true
          ? Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
              child: Column(
                children: [
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
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                        color: const Color.fromARGB(255, 0, 91, 148),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: [

                        Tab(
                          child: Text(
                            'Followers ($totalfollowers)',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Metropolis',
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Following ($totalfollowing)',
                            style: const TextStyle(
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
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _tabController,
                      // first tab bar view widget
                      children: [
                        follower(),
                        following(),
                      ],
                    ),
                  ),
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
                      : Container(),
            ),
    );
  }

  Widget follower() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8.0, 0.0, 5.0),
          child: SizedBox(
            height: 50,
            child: TextFormField(
              controller: follower_search,
              style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontFamily: 'assets/fonst/Metropolis-Black.otf'),
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
                hintStyle: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf')
                    .copyWith(color: Colors.black45),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                prefixIcon: const Icon(Icons.search),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black45),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black45),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onFieldSubmitted: (value) {
                getfollowdata.clear();

                _onLoading();
                getFollower();
                setState(() {});
              },
              onChanged: (value) {
                if (value.isEmpty) {
                  getfollowdata.clear();
                  _onLoading();
                  getFollower();
                  setState(() {});
                }
              },
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none &&
                    snapshot.hasData == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: getfollowdata.length,
                    padding: const EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
                    itemBuilder: (context, index) {
                      getfllow.Result result = getfollowdata[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {});
                        },
                        child: SizedBox(
                          height: 80,
                          child: Card(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            elevation: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      5.0, 0, 5.0, 0.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 25,
                                    backgroundImage: result.image.toString() !=
                                            ''
                                        ? NetworkImage(
                                            result.image.toString(),
                                          ) as ImageProvider
                                        : const AssetImage(
                                            'assets/plastic4trade logo final 1 (2).png'),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    result.name.toString(),
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: result.isFollowing == 1
                                      ? Container(
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: const BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 0, 91, 148),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                          ),
                                          height: 25,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              6.5,
                                          child: GestureDetector(
                                            onTap: () {
                                              setfollowUnfollow(
                                                '1',
                                                result.id.toString(),
                                              );
                                              followstatus = 'followed';
                                              setState(() {});
                                            },
                                            child: const Text(
                                              'followed',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.all(5.0),
                                          decoration: const BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 0, 91, 148),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50),
                                            ),
                                          ),
                                          height: 25,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              6.5,
                                          child: GestureDetector(
                                            onTap: () {
                                              setfollowUnfollow(
                                                '1',
                                                result.id.toString(),
                                              );

                                              result.isFollowing == 1;
                                              setState(() {});
                                            },
                                            child: const Text(
                                              'follow',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget following() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8.0, 0.0, 5.0),
          child: SizedBox(
            height: 45,
            child: TextFormField(
              style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontFamily: 'assets/fonst/Metropolis-Black.otf'),
              textCapitalization: TextCapitalization.words,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.text,
              controller: following_search,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r"[a-zA-Z]+|\s"),
                ),
              ],
              onFieldSubmitted: (value) {
                getfollowdata.clear();
                _onLoading();
                getFollowing();
                setState(() {});
              },
              onChanged: (value) {
                getfollowdata.clear();
                _onLoading();
                getFollowing();
                setState(() {});
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Search User",
                hintStyle: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'assets/fonst/Metropolis-Black.otf')
                    .copyWith(color: Colors.black45),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                prefixIcon: const Icon(Icons.search),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black45),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black45),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none &&
                    snapshot.hasData == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: getfllowingdata.length,
                    padding: const EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
                    itemBuilder: (context, index) {
                      getfllowing.Result result = getfllowingdata[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {});
                        },
                        child: SizedBox(
                          height: 80,
                          child: Card(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            elevation: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      5.0, 0, 5.0, 0.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 25,
                                    backgroundImage: result.image.toString() !=
                                            ''
                                        ? NetworkImage(
                                            result.image.toString(),
                                          ) as ImageProvider
                                        : const AssetImage(
                                            'assets/plastic4trade logo final 1 (2).png'),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    result.name.toString(),
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 0, 91, 148),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                    ),
                                    height: 25,
                                    width:
                                        MediaQuery.of(context).size.width / 6.5,
                                    child: GestureDetector(
                                      onTap: () {
                                        getfllowingdata.removeAt(index);
                                        totalfollowing = getfllowingdata.length;
                                        setfollowUnfollow(
                                          '0',
                                          result.id.toString(),
                                        );

                                        setState(() {});
                                      },
                                      child: const Text(
                                        'Unfollow',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> checkNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      getFollower();
      getFollowing();
      loading = true;
    }
  }

  Future<void> getFollower() async {
    getfollowdata.clear();
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getFollowerLists(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString(),
        pref.getString('user_id').toString(),
        follower_search.text);

    var jsonarray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonarray = res['result'];
        totalfollowers = res['totalFollowers'];

        for (var data in jsonarray) {
          getfllow.Result record = getfllow.Result(
              isFollowing: data['is_following'],
              name: data['name'],
              id: data['id'],
              image: data['image'],
              status: data['Status']);

          getfollowdata.add(record);
        }

        if (mounted) {
          setState(() {});
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
  }

  Future<void> getFollowing() async {
    getfllowingdata.clear();
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await getfollwingList(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
      pref.getString('user_id').toString(),
      following_search.text.toString(),
    );

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];
        totalfollowing = res['totalFollowing'];

        for (var data in jsonArray) {
          getfllowing.Result record = getfllowing.Result(
              name: data['name'],
              id: data['id'],
              image: data['image'],
              status: data['Status']);
          getfllowingdata.add(record);
        }

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

  Future<void> setfollowUnfollow(String follow, String otherUserId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await followUnfollow(
      follow,
      otherUserId,
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
    );

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];
        getFollowing();

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
                          : Container(),
                ),
              ),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(dialogContext)
          .pop(); // Use dialogContext to close the dialog
      // Dialog closed
    });
  }
}
