import 'dart:async';
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:Plastic4trade/utill/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/ChatMessage.dart';
import '../model/chat_userlist.dart';
import '../model/message.dart';
import 'dart:io' show Platform;

class ChartDetail extends StatefulWidget {
  String? user_name;
  String? user_image;
  String? user_id;

  ChartDetail(this.user_id, this.user_name, this.user_image, {Key? key})
      : super(key: key);

  @override
  State<ChartDetail> createState() => _ChartDetailState();
}

class _ChartDetailState extends State<ChartDetail> {
  bool istext = false;
  bool isimage = false;
  //PickedFile? _imagefiles;
  Timer? _timer;
  io.File? file;
  //final ImagePicker _picker = ImagePicker();
  TextEditingController textMessage = TextEditingController();
  String? customUserId, imageurl;
  var jsonData = null;
  Map<String, dynamic>? data = null;
  List<Map<String, dynamic>>? data1 = null;

  List<Message> childList = [];

  _ChartDetailState({Key? key});
  List<MapEntry<String, dynamic>>? messageList;

  @override
  Widget build(BuildContext context) {
    return init();
  }

  final scrollController = ScrollController();

  ScrollController _scrollController = ScrollController();
  StreamController<DataSnapshot> _dataStreamController =
      StreamController<DataSnapshot>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //_scrollController.addListener(_scrollListener);
    getUserList();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Fluttertoast.showToast(msg: "i m in down");
    /* if (_scrollController.hasClients) {
      Fluttertoast.showToast(msg: "i m in down1");
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }*/

    /*  scrollController.animateTo(
      0.5,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );*/
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );
      }
    });
    /*  WidgetsBinding.instance.addPostFrameCallback((_) {
      Fluttertoast.showToast(msg: "i m in down1");
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });*/
  }

  void _scrollListener() {
    /*if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      // Reach the bottom of the scroll view
      // Perform any desired actions here
    }*/
  }
  Widget init() {
    return Scaffold(
        backgroundColor: const Color(0xFFDADADA),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          title: Row(children: [
            CircleAvatar(
              radius: 16.0,
              backgroundImage:
                  NetworkImage(widget.user_image.toString()) as ImageProvider,
              //File imageFile = File(pickedFile.path);

              backgroundColor: Color.fromARGB(255, 240, 238, 238),
            ),
            SizedBox(
              width: 2,
            ),
            Text(widget.user_name!,
                softWrap: false,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Metropolis',
                )),
          ]),
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
        body: Container(
          child: Column(children: [
            Expanded(
              child: buildListMessage(),
            ),
            addchat()
          ]),
        ));
  }

  void sendMessage(String receiverId, String senderId, String messageText) {
    DatabaseReference messagesRef =
        FirebaseDatabase.instance.reference().child('messages');

    DatabaseReference receiverRef = messagesRef.child('$senderId-$receiverId');
    print(receiverRef.path);
    DatabaseReference newMessageRef = receiverRef.push();

    newMessageRef.set({
      'mediaName': '',
      'mediaType': 'text',
      'messageText': messageText,
      'messageTime': DateTime.now().millisecondsSinceEpoch,
      'senderId': senderId,
      // This will use the server's timestamp
    }).catchError((error) => print('Failed to send message: $error'));
  }

  getUserList() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    if (Platform.isAndroid) {
      await Firebase.initializeApp(
          name: 'Plastic4Trade',
          options: FirebaseOptions(
              apiKey: "AIzaSyCTqG3cUX04ACxu1U4tRhfTrI_odai_ZPY",
              appId: "1:929685037367:android:4ee71ab0f0e0608492fab2",
              messagingSenderId: "929685037367",
              projectId: "plastic4trade-55372",
              databaseURL:
                  "https://plastic4trade-55372-default-rtdb.firebaseio.com/"));
    } else if (Platform.isAndroid) {
      await Firebase.initializeApp(
          name: 'Plastic4Trade',
          options: FirebaseOptions(
              apiKey: "AIzaSyCTqG3cUX04ACxu1U4tRhfTrI_odai_ZPY",
              appId: "1:929685037367:ios:2ff9d0954f9bc0e292fab2",
              messagingSenderId: "929685037367",
              projectId: "plastic4trade-55372",
              databaseURL:
                  "https://plastic4trade-55372-default-rtdb.firebaseio.com/"));
    }

    FirebaseAuth auth = FirebaseAuth.instance;

    final currentUser = auth.currentUser;
    customUserId = _pref.getString('user_id').toString();
    imageurl = _pref.getString('userImage').toString();
    // constanst.count = _pref.getString('count').toString();

    // print('usergrdg ${currentUser}');
    // await  FirebaseAuth.instance.currentUser?.u(customUserId);
    // print('usergrdg ${currentUser}');
    //print('hee2');
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.uid)
        .get();
    //print('hee3 ${userDoc.id}');
    // print('hee6 ${userDoc.reference.snapshots().}');
    // await currentUser!.reload();

    // Assuming 'userList' is an array field in the 'users' document
    // final userList1 = userDoc.data()?['userList'] as List<dynamic>?;
    // final userList = userDoc.data()?['userList'] as List<dynamic>?;
    print('hee4');
    //print('userList $userList1');
    final currentUserId = currentUser?.displayName;
    // fetchData();
    final userCollection = FirebaseFirestore.instance.collection('users');
    print(userCollection.snapshots());
    final currentUser1 = FirebaseAuth.instance.currentUser;

    /*DatabaseReference newRef1 = FirebaseDatabase.instance.reference().child(
        "users").child('users');
    Future<DataSnapshot> newRef2 = FirebaseDatabase.instance.reference().child(
        "messages").get();

    print(newRef2);
    //newRef1.ref.onValue.map((event) => event.snapshot);

    // print(newRef2.key);
    print('hooooo');
    newRef2.then((DataSnapshot snapshot) {

      if (snapshot.value != null) {
        // Data exists in the snapshot

        // data = snapshot.value;

        //print(snapshot.value);
        snapshot.children.forEach((childSnapshot) {
          // Retrieve the data from each child
          //  print(childSnapshot.value);
          //  print('key');

          String childData = childSnapshot.key.toString();
          //print(childData);
          Message login = Message();
          List<String> parts = childData.split('-');
          if(parts.length==2) {
            if (parts[0].toString() == customUserId && parts[1].toString()==widget.user_id) {
              print('i m if');
              //if(parts[].toString()==widget.user_id) {
                print('key ');
                print(parts);
                print('=========================');
                // print(childSnapshot.children.)

                dynamic myVariable = childSnapshot.value;
                print('-------------for loop--------------');

                print(myVariable);
                data = myVariable!.cast<String, dynamic>();
               messageList = data!.entries.toList();
              messageList!.sort((a, b) => a.value["messageTime"].compareTo(b.value["messageTime"]));


              print('-------------for loop--------------$messageList');
              //List<String> messageTextList = messageList.map((entry) => entry.value["messageText"]).toList();

              // data=childSnapshot.value as Map<String, dynamic>?;

                jsonData = childSnapshot.value;
               // var res =chat_userlist.fromJson(jsonData);
                print('math $jsonData');
                 var convertedMap = jsonData.cast<String, dynamic>();
                print('----');
                //  print(convertedMap);
                login = Message.fromJson(convertedMap!);
                childList.add(login);
                print('math $childList');

              //}

              //print('username ${login.userName2.toString()}');
              // _username.add(login.userName2.toString());
              // _userImage.add(login.userImage2.toString());
              */ /* print(parts[0].toString());
              print(parts);
              print(parts[1].toString());
              print(customUserId);*/ /*

              //chat_userlist child = chat_userlist.fromJson(childSnapshot.value); // Create Child object from the snapshot
            } else if (parts[1].toString() == customUserId && parts[0].toString()==widget.user_id) {
             // if(parts[0].toString()==widget.user_id) {
                print('key');
                // print(childSnapshot.children.)
                jsonData = childSnapshot.value;
                print(childSnapshot.value);

                dynamic myVariable = childSnapshot.value;
                data = myVariable!.cast<String, dynamic>();
                messageList = data!.entries.toList();
                messageList!.sort((a, b) => a.value["messageTime"].compareTo(b.value["messageTime"]));
                print('-------------for loop--------------$messageList');
                //jsonData = childSnapshot.value;
                //var res =chat_userlist.fromJson(jsonData);
                print(childSnapshot.value);
                // var convertedMap = jsonData.cast<String, dynamic>();
                print('----');
                //  print(convertedMap);
                login = Message.fromJson(data!);
                childList.add(login);
                print('math $childList');
              }
            }
         // }

        });



      } else {
        // Data does not exist in the snapshot
        print("No data found");
      }
      print('--------------------');
      //   load = true;
      setState(() {
        // print(childList);
      });

    });
*/
    return messageList;
  }

  List<Message> extractMessages() {
    List<Message> messages = [];
    data?.forEach((key, value) {
      messages.add(Message(
        messageText: value['messageText'],
        messageTime: value['messageTime'],
        senderId: value['senderId'],
        mediaType: value['mediaType'],
        mediaName: value['mediaName'],
      ));
    });
    return messages;
  }

  /* Widget buildListMessage() {
    List<Message> messages = extractMessages();
    print(messages);
    return ListView.builder(
      itemCount: messageList?.length,
      shrinkWrap: false,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final entry = messageList![index];
        final messageText = entry.value['messageText'];
        final messageTime = entry.value['messageTime'];
        final senderId = entry.value['senderId'];
        final mediaType = entry.value['mediaType'];
        final mediaName = entry.value['mediaName'];

        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(messageTime.toString()));

        String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
        var datetime =getTextForDate(DateTime.parse(formattedDateTime));
        return Container(
            margin: const EdgeInsets.only(top: 5, right: 8, left: 8),
            decoration: const BoxDecoration(),
            //padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: senderId.toString()==widget.user_id
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 10.0,
                  backgroundImage: NetworkImage(widget.user_image.toString())
                  as ImageProvider,
                  //File imageFile = File(pickedFile.path);

                  backgroundColor: Color.fromARGB(255, 240, 238, 238),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .6),
                    padding: EdgeInsets.only(
                        left: 15, top: 5, bottom: 5.0, right: 7.0),
                    decoration: BoxDecoration(
                      color: Color(0xfff9f9f9),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    */ /* padding: EdgeInsets.only(
                              left: 15, top: 5, bottom: 5.0, right: 3.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E5EA),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(0.0)),
                          ),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),*/ /*
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.user_name.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                color:
                                Color.fromARGB(255, 0, 91, 148))),
                        Text(messageText.toString(),
                            maxLines: null,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(datetime,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 9)),
                          ],
                        )
                      ],
                    )),
              ],
            )
                : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               // constanst.messages[index].msgtype.toString() == 'text'?

                Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 91, 148),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(0.0),
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(10.0)),
                    ),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6),
                    child:  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(messageText.toString(),
                              maxLines: null,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w400)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(datetime,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 9)),
                            ],
                          )
                        ])
                ),
                SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 10.0,
                  backgroundImage: AssetImage('assets/Ellipse 13.png')
                  as ImageProvider,
                  //File imageFile = File(pickedFile.path);

                  backgroundColor: Color.fromARGB(255, 240, 238, 238),
                ),
              ],
            ));
      },
    );
  }*/

  Stream<List<MapEntry<String, dynamic>>> getMessageStream() {
    messageList?.clear();
    //  getUserList();
    final controller = StreamController<List<MapEntry<String, dynamic>>>();

    // Add your data to the stream controller

    controller.add(messageList!);

    // Close the stream when no longer needed
    controller.close();

    return controller.stream;
  }

  Widget buildListMessage() {
    // fetchDataAndUpdateStream();

// Use the StreamBuilder with the _dataStreamController.stream as the source
    /* return StreamBuilder<DataSnapshot>(
        stream: _dataStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for data
          return Center(child: CircularProgressIndicator(color:  Color.fromARGB(255, 0, 91, 148),));

        } else if (snapshot.hasError) {
          // If there's an error
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          // If there's no data
          return Text('No data available');
        } else {
          // If data is available
          snapshot.data?.children.forEach((childSnapshot) {
            // Retrieve the data from each child
            //  print(childSnapshot.value);
            //  print('key');

            String childData = childSnapshot.key.toString();
            //print(childData);
            Message login = Message();
            List<String> parts = childData.split('-');
            if(parts.length==2) {
              if (parts[0].toString() == customUserId && parts[1].toString()==widget.user_id) {
                print('i m if');
                //if(parts[].toString()==widget.user_id) {
                print('key ');
                print(parts);
                print('=========================');
                // print(childSnapshot.children.)

                dynamic myVariable = childSnapshot.value;
                print('-------------for loop--------------');

                print(myVariable);
                data = myVariable!.cast<String, dynamic>();
                messageList = data!.entries.toList();
                messageList!.sort((a, b) => a.value["messageTime"].compareTo(b.value["messageTime"]));


                print('-------------for loop--------------$messageList');
                //List<String> messageTextList = messageList.map((entry) => entry.value["messageText"]).toList();

                // data=childSnapshot.value as Map<String, dynamic>?;


              } else if (parts[1].toString() == customUserId && parts[0].toString()==widget.user_id) {
                // if(parts[0].toString()==widget.user_id) {
                print('key');
                // print(childSnapshot.children.)
                jsonData = childSnapshot.value;
                print(childSnapshot.value);

                dynamic myVariable = childSnapshot.value;
                data = myVariable!.cast<String, dynamic>();
                messageList = data!.entries.toList();
                messageList!.sort((a, b) => a.value["messageTime"].compareTo(b.value["messageTime"]));
                print('-------------for loop--------------$messageList');
                //jsonData = childSnapshot.value;
                //var res =chat_userlist.fromJson(jsonData);

              }
            }
            // }

          });

          return  ListView.builder(
            itemCount: messageList?.length,
            shrinkWrap: false,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final entry = messageList![index];
              final messageText = entry.value['messageText'];
              final messageTime = entry.value['messageTime'];
              final senderId = entry.value['senderId'];
              final mediaType = entry.value['mediaType'];
              final mediaName = entry.value['mediaName'];

              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(messageTime.toString()));

              String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
              var datetime =getTextForDate(DateTime.parse(formattedDateTime));
              return Container(
                  margin: const EdgeInsets.only(top: 5, right: 8, left: 8),
                  decoration: const BoxDecoration(),
                  //padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  child: senderId.toString()==widget.user_id
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 10.0,
                        backgroundImage: NetworkImage(widget.user_image.toString())
                        as ImageProvider,
                        //File imageFile = File(pickedFile.path);

                        backgroundColor: Color.fromARGB(255, 240, 238, 238),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * .6),
                          padding: EdgeInsets.only(
                              left: 15, top: 5, bottom: 5.0, right: 7.0),
                          decoration: BoxDecoration(
                            color: Color(0xfff9f9f9),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                           padding: EdgeInsets.only(
                              left: 15, top: 5, bottom: 5.0, right: 3.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E5EA),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(0.0)),
                          ),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.user_name.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                      color:
                                      Color.fromARGB(255, 0, 91, 148))),
                              Text(messageText.toString(),
                                  maxLines: null,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(datetime,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 9)),
                                ],
                              )
                            ],
                          )),
                    ],
                  )
                      : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // constanst.messages[index].msgtype.toString() == 'text'?

                      Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 0, 91, 148),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(0.0),
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0)),
                          ),
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.6),
                          child:  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(messageText.toString(),
                                    maxLines: null,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w400)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(datetime,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 9)),
                                  ],
                                )
                              ])
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CircleAvatar(
                        radius: 10.0,
                        backgroundImage: NetworkImage(imageurl.toString())
                        as ImageProvider,
                        //File imageFile = File(pickedFile.path);

                        backgroundColor: Color.fromARGB(255, 240, 238, 238),
                      ),
                    ],
                  ));
            },
          );
        }
      },
    );*/
    return StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.reference().child("messages").onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data
            return Center(
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
                        : Container());
          } else if (snapshot.hasError) {
            // If there's an error
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            // If there's no data
            return Text('No data available');
          } else {
            // If data is available
            DataSnapshot? dataSnapshot = snapshot.data?.snapshot;
            if (dataSnapshot != null) {
              dataSnapshot.children.forEach((childSnapshot) {
                // Retrieve the data from each child
                //  print(childSnapshot.value);
                //  print('key');

                String childData = childSnapshot.key.toString();
                //print(childData);
                Message login = Message();
                List<String> parts = childData.split('-');
                if (parts.length == 2) {
                  if (parts[0].toString() == customUserId &&
                      parts[1].toString() == widget.user_id) {
                    print('i m if');
                    //if(parts[].toString()==widget.user_id) {
                    print('key ');
                    print(parts);
                    print('=========================');
                    // print(childSnapshot.children.)

                    dynamic myVariable = childSnapshot.value;
                    print('-------------for loop--------------');

                    print(myVariable);
                    data = myVariable!.cast<String, dynamic>();
                    messageList = data!.entries.toList();
                    messageList!.sort((a, b) => a.value["messageTime"]
                        .compareTo(b.value["messageTime"]));

                    print('-------------for loop--------------$messageList');
                    //List<String> messageTextList = messageList.map((entry) => entry.value["messageText"]).toList();

                    // data=childSnapshot.value as Map<String, dynamic>?;
                  } else if (parts[1].toString() == customUserId &&
                      parts[0].toString() == widget.user_id) {
                    // if(parts[0].toString()==widget.user_id) {
                    print('key');
                    // print(childSnapshot.children.)
                    jsonData = childSnapshot.value;
                    print(childSnapshot.value);

                    dynamic myVariable = childSnapshot.value;
                    data = myVariable!.cast<String, dynamic>();
                    messageList = data!.entries.toList();
                    messageList!.sort((a, b) => a.value["messageTime"]
                        .compareTo(b.value["messageTime"]));
                    print('-------------for loop--------------$messageList');
                    //jsonData = childSnapshot.value;
                    //var res =chat_userlist.fromJson(jsonData);
                  }
                }
              });
              return ListView.builder(
                reverse: true,
                controller: scrollController,
                itemCount: messageList?.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  List<dynamic> reversedList =
                      List.from(messageList?.reversed as Iterable);
                  // messageList = messageList!.reversed.toList();
                  final entry = reversedList![index];
                  final messageText = entry.value['messageText'];
                  final messageTime = entry.value['messageTime'];
                  final senderId = entry.value['senderId'];
                  final mediaType = entry.value['mediaType'];
                  final mediaName = entry.value['mediaName'];

                  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                      int.parse(messageTime.toString()));

                  String formattedDateTime =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
                  var datetime =
                      getTextForDate(DateTime.parse(formattedDateTime));
                  return Container(
                    margin: const EdgeInsets.only(top: 5, right: 8, left: 8),
                    decoration: const BoxDecoration(),
                    child: senderId.toString() == widget.user_id
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 10.0,
                                backgroundImage:
                                    NetworkImage(widget.user_image.toString())
                                        as ImageProvider,
                                backgroundColor:
                                    Color.fromARGB(255, 240, 238, 238),
                              ),
                              SizedBox(width: 5),
                              messageText.toString().startsWith(
                                      'https://firebasestorage.googleapis.com')
                                  ? Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                .4,
                                      ),
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        top: 5,
                                        bottom: 5.0,
                                        right: 7.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xfff9f9f9),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.user_name.toString(),
                                            style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf')
                                                ?.copyWith(
                                              color: Color.fromARGB(
                                                  255, 0, 91, 148),
                                            ),
                                          ),
                                          Image.network(
                                            messageText.toString(),
                                            /*maxLines: null,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,*/
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                datetime,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 9,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                .6,
                                      ),
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        top: 5,
                                        bottom: 5.0,
                                        right: 7.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xfff9f9f9),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.user_name.toString(),
                                            style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf')
                                                ?.copyWith(
                                              color: Color.fromARGB(
                                                  255, 0, 91, 148),
                                            ),
                                          ),
                                          Text(
                                            messageText.toString(),
                                            maxLines: null,
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf'),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                datetime,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 9,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              messageText.toString().startsWith(
                                      'https://firebasestorage.googleapis.com')
                                  ? Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 0, 91, 148),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10.0),
                                          bottomRight: Radius.circular(0.0),
                                          topLeft: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                        ),
                                      ),
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            messageText.toString(),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                datetime,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 9,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 0, 91, 148),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10.0),
                                          bottomRight: Radius.circular(0.0),
                                          topLeft: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                        ),
                                      ),
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            messageText.toString(),
                                            maxLines: null,
                                            style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'assets\fonst\Metropolis-Black.otf')
                                                ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                datetime,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 9,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                              SizedBox(width: 5),
                              CircleAvatar(
                                radius: 10.0,
                                backgroundImage:
                                    NetworkImage(imageurl.toString())
                                        as ImageProvider,
                                backgroundColor:
                                    Color.fromARGB(255, 240, 238, 238),
                              ),
                            ],
                          ),
                  );
                },
              );
            } else {
              return Text('No data available');
            }
          }
        });

    /*  return StreamBuilder<Event>(
      stream: _databaseReference.onValue,
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
        if (snapshot.hasData) {
          // Parse the snapshot data and update your UI accordingly
          // For example, you can access the updated data using snapshot.data.snapshot.value
          // and build your UI widgets based on the new data
          return YourCustomWidget(data: snapshot.data.snapshot.value);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator(); // Show a loading indicator while waiting for data
        }
      },
    )*/
  }

  Future<void> fetchDataAndUpdateStream() async {
    try {
      DataSnapshot snapshot =
          await FirebaseDatabase.instance.reference().child("messages").get();
      _dataStreamController.add(snapshot);
    } catch (e) {
      _dataStreamController.addError(e);
    }
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

  Widget addchat() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, bottom: 5, top: 10),
                    height: 60,
                    width: double.infinity,
                    // color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        isimage
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isimage = false;
                                    //ViewItem(context);
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    //color: Color.fromARGB(255, 0, 91, 148),
                                    color: Color(0xFFDADADA),
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  child: Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.red,
                                    size: 45,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isimage = true;
                                    //ViewItem(context);
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 0, 91, 148),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: textMessage,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            minLines: 1,
                            maxLines: null,
                            onChanged: ((value) {
                              setState(() {
                                // _messageEntrer = value;
                                istext = true;
                                if (value.toString().isEmpty) {
                                  istext = false;
                                }
                              });
                            }),
                            decoration: InputDecoration(
                              hintText: "Type your message here",
                              hintMaxLines: 1,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10),
                              hintStyle: TextStyle(
                                fontSize: 16,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 0.2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Colors.black26,
                                  width: 0.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        istext
                            ? FloatingActionButton(
                                onPressed: () {
                                  sendMessage(
                                      widget.user_id.toString(),
                                      customUserId.toString(),
                                      textMessage.text);
                                  setState(() {
                                    messageList?.clear();
                                    getUserList();
                                  });
                                  //constanst.messages.add(ChatMessage(messageContent: textMessage.text.toString(), userType: 'sender', msgtype: 'text',fillname: ""));
                                  setState(() {
                                    textMessage.text = '';
                                    istext = false;
                                  });
                                },
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                // backgroundColor: Colors.blue,
                                elevation: 0,
                              )
                            : FloatingActionButton(
                                onPressed: () {},
                                child: Icon(
                                  Icons.keyboard_voice,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                // backgroundColor: Colors.blue,
                                elevation: 0,
                              ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: isimage,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                        child: Image.asset(
                                          "assets/add_image.png",
                                          width: 150,
                                          height: 120,
                                        ),
                                        onTap: () {
                                          showDialog(
                                            barrierColor: Colors.black26,
                                            context: context,
                                            builder: (context) {
                                              isimage = false;

                                              return bottomsheet();
                                            },
                                          );
                                        }),
                                    SizedBox(
                                        width: 68,
                                        child: Text(
                                          'Image',
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf'),
                                          textAlign: TextAlign.center,
                                        ))
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                        child: Image.asset(
                                          "assets/add_doc.png",
                                          width: 150,
                                          height: 120,
                                        ),
                                        onTap: () async {
                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles();

                                          if (result != null) {
                                            PlatformFile files =
                                                result.files.first;
                                            print(files.path);
                                            setState(() {
                                              isimage = isimage = false;
                                            });

                                            constanst.messages.add(ChatMessage(
                                                messageContent: "",
                                                userType: "sender",
                                                msgtype: "pdf",
                                                fillname: files.name));
                                          } else {
                                            print("No file selected");
                                          }
                                        }),
                                    SizedBox(
                                        width: 68,
                                        child: Text(
                                          'Attach Document',
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  'assets\fonst\Metropolis-Black.otf'),
                                          textAlign: TextAlign.center,
                                        ))
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      ))
                ],
              ),
            )
          ],
        ));
  }

  Widget bottomsheet() {
    return Dialog(
        elevation: 0,
        backgroundColor: Color(0xffffffff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 100.0,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: <Widget>[
                Text(
                  "Choose Profile Photo",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton.icon(
                        onPressed: () {
                          //takephoto(ImageSource.camera);
                          setState(() {});
                        },
                        icon: Icon(Icons.camera,
                            color: Color.fromARGB(255, 0, 91, 148)),
                        label: Text(
                          'Camera',
                          style:
                              TextStyle(color: Color.fromARGB(255, 0, 91, 148)),
                        )),
                    TextButton.icon(
                        onPressed: () {
                          // takephoto(ImageSource.gallery);
                          setState(() {});
                        },
                        icon: Icon(Icons.image,
                            color: Color.fromARGB(255, 0, 91, 148)),
                        label: Text(
                          'Gallary',
                          style:
                              TextStyle(color: Color.fromARGB(255, 0, 91, 148)),
                        )),
                  ],
                )
              ],
            ),
          );
        }));
  }

  /*void takephoto(ImageSource imageSource) async {
    final pickedfile = await _picker.getImage(source: imageSource);
    setState(() {
      _imagefiles = pickedfile!;
      file = io.File(_imagefiles!.path);


      setState(() {
        Navigator.of(context).pop();
       // Navigator.of(context).pop();
        isimage = false;
        constanst.messages.add(ChatMessage(messageContent: "", userType: "sender", msgtype: "image",fillname: _imagefiles!.path ));
      });
      setState(() {

      });
      print('dw');
      print(constanst.messages.length);
      // print('image path : ');
      // print(_imagefiles!.path);
    });
  }
*/
  ViewItem(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        // <-- SEE HERE
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      )),
      builder: (context) => YourWidget(),
    );
  }
}

class YourWidget extends StatefulWidget {
  const YourWidget({Key? key}) : super(key: key);

  @override
  State<YourWidget> createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  int? _radioValue = 0;
  int? _managerValue = 0;
  String? assignedName;
  bool gender = false;
  //PickedFile? _imagefiles;
  io.File? file;
  //final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    GestureDetector(
                        child: Image.asset(
                          "assets/add_image.png",
                          width: 150,
                          height: 120,
                        ),
                        onTap: () {
                          showDialog(
                            barrierColor: Colors.black26,
                            context: context,
                            builder: (context) {
                              setState(() {
                                //  isimage=false;
                              });
                              return bottomsheet();
                            },
                          );
                        }),
                    SizedBox(
                        width: 68,
                        child: Text(
                          'Image',
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                          textAlign: TextAlign.center,
                        ))
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                        child: Image.asset(
                          "assets/add_doc.png",
                          width: 150,
                          height: 120,
                        ),
                        onTap: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();

                          if (result != null) {
                            PlatformFile files = result.files.first;
                            print(files.path);
                            constanst.messages.add(ChatMessage(
                                messageContent: "",
                                userType: "sender",
                                msgtype: "pdf",
                                fillname: files.name));
                          } else {
                            print("No file selected");
                          }
                        }),
                    SizedBox(
                        width: 68,
                        child: Text(
                          'Attach Document',
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                          textAlign: TextAlign.center,
                        ))
                  ],
                )
              ],
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget bottomsheet() {
    return Dialog(
        elevation: 0,
        backgroundColor: Color(0xffffffff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 100.0,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: <Widget>[
                Text(
                  "Choose Profile Photo",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton.icon(
                        onPressed: () {
                          //takephoto(ImageSource.camera);
                          setState(() {});
                        },
                        icon: Icon(Icons.camera,
                            color: Color.fromARGB(255, 0, 91, 148)),
                        label: Text('Camera')),
                    TextButton.icon(
                        onPressed: () {
                          // takephoto(ImageSource.gallery);
                          setState(() {});
                        },
                        icon: Icon(Icons.image),
                        label: Text('Gallary')),
                  ],
                )
              ],
            ),
          );
        }));
  }

/*void takephoto(ImageSource imageSource) async {
    final pickedfile = await _picker.getImage(source: imageSource);
    setState(() {
      _imagefiles = pickedfile!;
      file = io.File(_imagefiles!.path);


      setState(() {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
       // constanst.isimage = true;
        constanst.messages.add(ChatMessage(messageContent: "", userType: "sender", msgtype: "image",fillname: _imagefiles!.path ));
      });
      print('dw');
      print(constanst.messages.length);
      // print('image path : ');
      // print(_imagefiles!.path);
    });
  }*/
}
