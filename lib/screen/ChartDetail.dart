// ignore_for_file: must_be_immutable, non_constant_identifier_names, prefer_typing_uninitialized_variables, avoid_print

import 'dart:async';
import 'dart:developer';
import 'dart:io' as io;
import 'dart:io' show Platform;

//import 'package:image_picker/image_picker.dart';
import 'package:Plastic4trade/utill/constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/ChatMessage.dart';
import '../model/message.dart';

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
  io.File? file;
  TextEditingController textMessage = TextEditingController();
  String? customUserId, imageurl, userName;
  var jsonData;
  Map<String, dynamic>? data;
  List<Map<String, dynamic>>? data1;

  List<Message> childList = [];

  _ChartDetailState();

  List<MapEntry<String, dynamic>>? messageList;

  final scrollController = ScrollController();

  final ScrollController _scrollController = ScrollController();
  final StreamController<DataSnapshot> _dataStreamController =
      StreamController<DataSnapshot>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserList();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );
      }
    });
  }

@override
Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDADADA),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16.0,
              backgroundImage: NetworkImage(
                widget.user_image.toString(),
              ),
              //File imageFile = File(pickedFile.path);

              backgroundColor: const Color.fromARGB(255, 240, 238, 238),
            ),
            const SizedBox(
              width: 2,
            ),
            Text(
              widget.user_name!,
              softWrap: false,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontFamily: 'Metropolis',
              ),
            ),
          ],
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
      body: Column(
        children: [
          Expanded(
            child: buildListMessage(),
          ),
          addchat()
        ],
      ),
    );
  }

  void sendMessage(String receiverId, String senderId, String messageText) {
    DatabaseReference messagesRef =
        FirebaseDatabase.instance.ref().child('messages');

    DatabaseReference receiverRef = messagesRef.child('$senderId-$receiverId');
    DatabaseReference newMessageRef = receiverRef.push();

    newMessageRef.set({
      'mediaName': '',
      'mediaType': 'text',
      'messageText': messageText,
      'messageTime': DateTime.now().millisecondsSinceEpoch,
      'senderId': senderId,
      // This will use the server's timestamp
    }).catchError(
      (error) => print('Failed to send message: $error'),
    );
  }

  void setUserData(
      String receiverId, String senderId, String messageText) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    DatabaseReference messagesRef =
        FirebaseDatabase.instance.ref().child('users');

    DatabaseReference receiverRef = messagesRef.child('$senderId-$receiverId');
    // DatabaseReference newMessageRef = receiverRef.push();

    receiverRef.set({
      "count": "0",
      'mediaName': '',
      'mediaType': 'text',
      'messageText': messageText,
      "messageTime": DateTime.now().millisecondsSinceEpoch,
      "senderId": senderId,
      "userImage1": widget.user_image,
      "userImage2": imageurl,
      "userName1": widget.user_name,
      "userName2": userName,
    }).catchError(
      (error) => print('Failed to send message: $error'),
    );
  }

  Future getUserList() async {
    messageList = [];
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
                "https://plastic4trade-55372-default-rtdb.firebaseio.com/"),
      );
    } else if (Platform.isAndroid) {
      await Firebase.initializeApp(
        name: 'Plastic4Trade',
        options: const FirebaseOptions(
            apiKey: "AIzaSyCTqG3cUX04ACxu1U4tRhfTrI_odai_ZPY",
            appId: "1:929685037367:ios:2ff9d0954f9bc0e292fab2",
            messagingSenderId: "929685037367",
            projectId: "plastic4trade-55372",
            databaseURL:
                "https://plastic4trade-55372-default-rtdb.firebaseio.com/"),
      );
    }

    customUserId = pref.getString('user_id').toString();
    imageurl = pref.getString('userImage').toString();
    userName = pref.getString('name').toString();
    return messageList;
    return messageList;
  }

  // List<Message> extractMessages() {
  //   List<Message> messages = [];
  //   data?.forEach((key, value) {
  //     messages.add(
  //       Message(
  //         messageText: value['messageText'],
  //         messageTime: value['messageTime'],
  //         senderId: value['senderId'],
  //         mediaType: value['mediaType'],
  //         mediaName: value['mediaName'],
  //       ),
  //     );
  //   });
  //   return messages;
  // }

  Stream<List<MapEntry<String, dynamic>>> getMessageStream() {
    messageList?.clear();

    final controller = StreamController<List<MapEntry<String, dynamic>>>();
    controller.add(messageList!);
    controller.close();
    return controller.stream;
  }

  Widget buildListMessage() {
    return StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref().child("messages").onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
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
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Text('No data available');
          } else {
            DataSnapshot? dataSnapshot = snapshot.data?.snapshot;
            if (dataSnapshot != null) {
              for (var childSnapshot in dataSnapshot.children) {
                String childData = childSnapshot.key.toString();

                List<String> parts = childData.split('-');
                print("parts:- $parts");
                print("customUserId:- $customUserId");
                print("user_id:-${widget.user_id}");
                if (parts.length == 2) {
                  if (parts[0].toString() == customUserId && parts[1].toString() == widget.user_id) {
                    dynamic myVariable = childSnapshot.value;
                    data = myVariable!.cast<String, dynamic>();
                    messageList!.addAll(data!.entries.toList());
                    messageList!.sort(
                      (a, b) => a.value["messageTime"].compareTo(
                        b.value["messageTime"],
                      ),
                    );
                  } else if (parts[1].toString() == customUserId &&
                      parts[0].toString() == widget.user_id) {
                    jsonData = childSnapshot.value;
                    dynamic myVariable = childSnapshot.value;
                    data = myVariable!.cast<String, dynamic>();
                    messageList = data!.entries.toList();
                    messageList!.sort(
                      (a, b) => a.value["messageTime"].compareTo(
                        b.value["messageTime"],
                      ),
                    );
                  }
                }
              }

              print("UserData ==> $messageList");
              if (messageList != null && messageList!.isNotEmpty) {
                return ListView.builder(
                  reverse: true,
                  controller: scrollController,
                  itemCount: messageList?.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    List<dynamic> reversedList =
                        List.from(messageList?.reversed as Iterable);

                    final entry = reversedList[index];
                    final messageText = entry.value['messageText'];
                    final messageTime = entry.value['messageTime'];
                    final senderId = entry.value['senderId'];

                    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                      int.parse(messageTime.toString()),
                    );

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
                                  backgroundImage: NetworkImage(
                                    widget.user_image.toString(),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 240, 238, 238),
                                ),
                                const SizedBox(width: 5),
                                messageText.toString().startsWith(
                                        'https://firebasestorage.googleapis.com')
                                    ? Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                        ),
                                        padding: const EdgeInsets.only(
                                          left: 15,
                                          top: 5,
                                          bottom: 5.0,
                                          right: 7.0,
                                        ),
                                        decoration: const BoxDecoration(
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
                                              style: const TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'assets/fonst/Metropolis-Black.otf')
                                                  .copyWith(
                                                color: const Color.fromARGB(
                                                    255, 0, 91, 148),
                                              ),
                                            ),
                                            Image.network(
                                              messageText.toString(),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  datetime,
                                                  style: const TextStyle(
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
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .6,
                                        ),
                                        padding: const EdgeInsets.only(
                                          left: 15,
                                          top: 5,
                                          bottom: 5.0,
                                          right: 7.0,
                                        ),
                                        decoration: const BoxDecoration(
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
                                              style: const TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'assets/fonst/Metropolis-Black.otf')
                                                  .copyWith(
                                                color: const Color.fromARGB(
                                                    255, 0, 91, 148),
                                              ),
                                            ),
                                            Text(
                                              messageText.toString(),
                                              maxLines: null,
                                              style: const TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'assets/fonst/Metropolis-Black.otf'),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  datetime,
                                                  style: const TextStyle(
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
                                          'https://firebasestorage.googleapis.com',
                                        )
                                    ? Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 0, 91, 148),
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            bottomRight: Radius.circular(0.0),
                                            topLeft: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                          ),
                                        ),
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                                  style: const TextStyle(
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
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 0, 91, 148),
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            bottomRight: Radius.circular(0.0),
                                            topLeft: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                          ),
                                        ),
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                              style: const TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'assets/fonst/Metropolis-Black.otf')
                                                  .copyWith(
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
                                                  style: const TextStyle(
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
                                const SizedBox(width: 5),
                                CircleAvatar(
                                  radius: 10.0,
                                  backgroundImage: NetworkImage(
                                    imageurl.toString(),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 240, 238, 238),
                                ),
                              ],
                            ),
                    );
                  },
                );
              } else {
                return const Text('No data available');
              }
            } else {
              return const Text('No data available');
            }
          }
        });
  }

  Future<void> fetchDataAndUpdateStream() async {
    try {
      DataSnapshot snapshot =
          await FirebaseDatabase.instance.ref().child("messages").get();
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
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(
                10,
                10,
                0,
                5,
              ),
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
                              color: const Color(0xFFDADADA),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: const Icon(
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
                              color: const Color.fromARGB(255, 0, 91, 148),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                  const SizedBox(
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
                        hintStyle: const TextStyle(
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
                  const SizedBox(
                    width: 10,
                  ),
                  istext
                      ? GestureDetector(
                        onTap: (){
                          if (messageList == null) {
                            setUserData(
                                widget.user_id.toString(),
                                customUserId.toString(),
                                textMessage.text);
                          }

                          sendMessage(widget.user_id.toString(),
                              customUserId.toString(), textMessage.text);
                          setState(() {
                            messageList?.clear();
                            getUserList();
                          });
                          setState(() {
                            textMessage.text = '';
                            istext = false;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 91, 148),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      )
                      : GestureDetector(
                        onTap: (){},
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 91, 148),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.keyboard_voice,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
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
                    const SizedBox(
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
                            const SizedBox(
                              width: 68,
                              child: Text(
                                'Image',
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf'),
                                textAlign: TextAlign.center,
                              ),
                            )
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
                                    setState(() {
                                      isimage = isimage = false;
                                    });

                                    constanst.messages.add(
                                      ChatMessage(
                                          messageContent: "",
                                          userType: "sender",
                                          msgtype: "pdf",
                                          fillname: files.name),
                                    );
                                  } else {}
                                }),
                            const SizedBox(
                              width: 68,
                              child: Text(
                                'Attach Document',
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf'),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bottomsheet() {
    return Dialog(
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 100.0,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: <Widget>[
              const Text(
                "Choose Profile Photo",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.camera,
                      color: Color.fromARGB(255, 0, 91, 148),
                    ),
                    label: const Text(
                      'Camera',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 91, 148),
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Color.fromARGB(255, 0, 91, 148),
                    ),
                    label: const Text(
                      'Gallery',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 91, 148),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  ViewItem(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (context) => const YourWidget(),
    );
  }
}

class YourWidget extends StatefulWidget {
  const YourWidget({Key? key}) : super(key: key);

  @override
  State<YourWidget> createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  String? assignedName;
  bool gender = false;
  io.File? file;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
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
                            setState(() {});
                            return bottomsheet();
                          },
                        );
                      }),
                  const SizedBox(
                    width: 68,
                    child: Text(
                      'Image',
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                      textAlign: TextAlign.center,
                    ),
                  )
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
                          constanst.messages.add(
                            ChatMessage(
                                messageContent: "",
                                userType: "sender",
                                msgtype: "pdf",
                                fillname: files.name),
                          );
                        } else {}
                      }),
                  const SizedBox(
                    width: 68,
                    child: Text(
                      'Attach Document',
                      style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }

  Widget bottomsheet() {
    return Dialog(
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 100.0,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: <Widget>[
              const Text(
                "Choose Profile Photo",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.camera,
                      color: Color.fromARGB(255, 0, 91, 148),
                    ),
                    label: const Text('Camera'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(Icons.image),
                    label: const Text('Gallary'),
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
