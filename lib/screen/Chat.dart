// ignore_for_file: prefer_typing_uninitialized_variables, unrelated_type_equality_checks, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/chat_userlist.dart';
import 'ChartDetail.dart';
import 'Videos.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late Size mq;
  late var yourStream;
  final List<String> _username = [];
  final List<String> _userImage = [];
  final List<String> _userId = [];
  var userList;
  String? customUserId;

  String? username;
  bool? load = false;
  List<chat_userlist> childList = [];

  var jsonData;
  final messages = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserList();
  }

  Future<void> updateChatCountToZero(
      String count, String receiverId, String senderId) async {
    try {

      var collection = FirebaseFirestore.instance.collection('users');
      var docRef = collection.doc('$receiverId-$senderId');

      var documentSnapshot = await docRef.get();

      if (documentSnapshot.exists) {
        docRef.update({count: "0"});
        Fluttertoast.showToast(msg: 'Success');
      } else {
        Fluttertoast.showToast(msg: 'Document not found');
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Update failed: $error');
    }
  }

  Future<List<String>> fetchUserData(List<String> userIds) async {
    List<String> userData = [];
    getUserList();

    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    for (String userId in userIds) {
      DocumentSnapshot snapshot = await usersCollection.doc(userId).get();
      if (snapshot.exists) {
        String userDataItem = snapshot.get('data');
        userData.add(userDataItem);
      }
    }

    return userData;
  }

  getUserList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
          name: 'Plastic4Trade',
          options: const FirebaseOptions(
              apiKey: "AIzaSyCTqG3cUX04ACxu1U4tRhfTrI_odai_ZPY",
              appId: "1:929685037367:android:4ee71ab0f0e0608492fab2",
              messagingSenderId: "929685037367",
              projectId: "plastic4trade-55372",
              databaseURL:
                  "https://plastic4trade-55372-default-rtdb.firebaseio.com/"));
    }
    else if (Platform.isAndroid) {
      await Firebase.initializeApp(
          name: 'Plastic4Trade',
          options: const FirebaseOptions(
              apiKey: "AIzaSyCTqG3cUX04ACxu1U4tRhfTrI_odai_ZPY",
              appId: "1:929685037367:ios:2ff9d0954f9bc0e292fab2",
              messagingSenderId: "929685037367",
              projectId: "plastic4trade-55372",
              databaseURL:
                  "https://plastic4trade-55372-default-rtdb.firebaseio.com/"));
    }

    customUserId = pref.getString('user_id').toString();

    yourStream = FirebaseFirestore.instance.collection('users').where('senderId', isEqualTo: "14969");

    // print("DATA 1  ==  $yourStream");

    Future<DataSnapshot> newRef2 =
        FirebaseDatabase.instance.ref().child("users").get();

    newRef2.then((DataSnapshot snapshot) {


      if (snapshot.value != null) {
        for (var childSnapshot in snapshot.children) {
          String childData = childSnapshot.key.toString();

          chat_userlist login = chat_userlist();
          List<String> parts = childData.split('-');
          if (parts.length == 2) {
            if (parts[0].toString() == customUserId) {
              _userId.contains(parts[1].toString())
                  ? null
                  : _userId.add(parts[1].toString());

              jsonData = childSnapshot.value;

              var convertedMap = jsonData.cast<String, dynamic>();
              login = chat_userlist.fromJson(convertedMap);

              childList.add(login);
              _username.add(login.userName2.toString());
              _userImage.add(login.userImage2.toString());
            } else if (parts[1].toString() == customUserId) {
              _userId.contains(parts[0].toString())
                  ? null
                  : _userId.add(parts[0].toString());
              jsonData = childSnapshot.value;
              var convertedMap = jsonData.cast<String, dynamic>();
              login = chat_userlist.fromJson(convertedMap);
              childList.add(login);
              _username.add(login.userName1.toString());
              _userImage.add(login.userImage1.toString());
            }
          }
        }
      } else {
      }
      load = true;
      setState(() {});
    });


    return yourStream;
  }

  List<chat_userlist> parseMessages(String jsonData) {
    final parsed = json.decode(jsonData).cast<Map<String, dynamic>>();
    return parsed
        .map<chat_userlist>((json) => chat_userlist.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Future<UserCredential> signInAnonymously() async {
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
    return userCredential;
  }


  Widget init() {
    return Scaffold(
      backgroundColor: const Color(0xFFDADADA),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: const Text('Messages',
            softWrap: false,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: 'Metropolis',
            ),),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Videos(),
                ),
              );
            },
            child: SizedBox(
              width: 40,
              child: Image.asset(
                'assets/Play.png',
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 8, 10, 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8.0, 0.0, 5.0),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                  textCapitalization: TextCapitalization.words,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Search People or Messages",
                    hintStyle: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontFamily: 'assets/fonst/Metropolis-Black.otf')
                        .copyWith(color: Colors.black45),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    prefixIcon: const Icon(Icons.search),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.0)),
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: load == true
                  ? chatlist()
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
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage("assets/floating_back.png")),
            borderRadius: BorderRadius.circular(30)),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add, color: Colors.white, size: 40),
        ),
      ),
    );
  }

  Widget chatlist() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.hasData == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: childList.length,
            itemBuilder: (BuildContext context, int index) {
              chat_userlist record = childList[index];
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                int.parse(
                  record.messageTime.toString(),
                ),
              );

              String formattedDateTime =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
              var date = getTextForDate(DateTime.parse(formattedDateTime));

              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  clipBehavior: Clip.antiAlias,
                  children: [
                    Positioned.fill(
                      child: Builder(
                        builder: (context) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Container(
                            height: 50,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SlidableAutoCloseBehavior(
                        child: Slidable(
                          direction: Axis.horizontal,
                          endActionPane: ActionPane(
                            motion: const BehindMotion(),
                            extentRatio: 0.25,
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.red.shade600,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                  },
                                                  icon: Image.asset(
                                                      'assets/delete2.png',
                                                      color: Colors.white,
                                                      width: 30,
                                                      height: 30),
                                                ),
                                                const Text(
                                                  'Remove',
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                          onTap: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              updateChatCountToZero(
                                "1",
                                // customUserId!,
                                "14969",
                                "19559",
                              );

                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChartDetail(
                                        _userId[index],
                                        _username[index],
                                        _userImage[index]),
                                  ),
                                );
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Stack(
                                          fit: StackFit.passthrough,
                                          children: <Widget>[
                                            Container(
                                              width: 45.0,
                                              height: 45.0,
                                              margin:
                                                  const EdgeInsets.all(15.0),
                                              decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      'assets/Ellipse 13.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: CircleAvatar(
                                                radius: 100.0,
                                                backgroundImage: NetworkImage(
                                                    _userImage[index]),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 240, 238, 238),
                                              ),
                                            ),
                                          ]),
                                      IntrinsicWidth(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(_username[index],
                                                style: record.count == 0
                                                    ? const TextStyle(
                                                            fontSize: 13.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'assets/fonst/Metropolis-Black.otf')
                                                        .copyWith(
                                                            fontSize: 15,
                                                            color: const Color.fromARGB(
                                                                255, 0, 91, 148),
                                                            fontWeight:
                                                                FontWeight.bold)
                                                    : const TextStyle(
                                                            fontSize: 13.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                'assets/fonst/Metropolis-Black.otf')
                                                        .copyWith(fontSize: 15, color: Colors.black),
                                                maxLines: 1,
                                                softWrap: false),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width / 1.76,
                                              child: Text('${record.messageText}',
                                                  style: record.count != "0"
                                                      ? const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Colors.black, fontFamily: 'assets/fonst/Metropolis-Black.otf').copyWith(
                                                          color: const Color.fromARGB(
                                                              255, 0, 91, 148),
                                                          fontWeight:
                                                              FontWeight.bold)
                                                      : const TextStyle(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight
                                                                  .w400,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily: 'assets/fonst/Metropolis-Black.otf').copyWith(color: Colors.grey),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  softWrap: false),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 5, right: 5),
                                    child: IntrinsicWidth(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(date,
                                              style: const TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'assets/fonst/Metropolis-Black.otf')
                                                  .copyWith(
                                                      fontSize: 11,
                                                      color: Colors.grey),
                                              maxLines: 1,
                                              softWrap: false),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Visibility(
                                            visible: record.count == "0"
                                                ? false
                                                : true,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 0, 91, 148),
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 1.0,
                                                      style: BorderStyle.solid),
                                                  shape: BoxShape.circle),
                                              child: Center(
                                                child: Text(
                                                  record.count.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  String getTextForDate(DateTime date) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat("h:mm a").format(date);
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return DateFormat("yMd").format(date);
    }
  }
}
