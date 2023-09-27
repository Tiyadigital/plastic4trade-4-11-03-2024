import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/chat_user.dart';
import '../model/chat_userlist.dart';
import 'ChartDetail.dart';
import 'Videos.dart';
import 'dart:io' show Platform;

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}


class _ChatState extends State<Chat> {

  late Size mq;
  late var yourStream = null;
  List<ChatUser> _list = [];
   List<String> _username = [];
   List<String> _userImage = [];
   List<String> _userId = [];
  //late final Function() onViewChat;
  var userList;
  String? customUserId;
  //String? count;
  String? username;
  bool? load=false;
  List<chat_userlist> childList = [];
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  //search status
  bool _isSearching = false;
   var jsonData=null;
  final messages=null;
//  final databaseReference = FirebaseDatabase.instance.reference();


/*  Future<void> decrementAndViewChatCount(int index) async {
    if (childList[index].count!= null) {
      // Decrement the count locally
      setState(() {
        childList[index].count ="0";
      });
    }}*/








@override
  void initState() {
    // TODO: implement initState

    super.initState();
    getUserList();

  }


  Future<void> updateChatCountToZero(String count, String receiverId, String senderId) async {
    try {
      Fluttertoast.showToast(msg: 'in');

      // Get a reference to the Firestore document for this chat
      var collection = FirebaseFirestore.instance.collection('users');
      var docRef = collection.doc('$receiverId-$senderId');


      var documentSnapshot = await docRef.get();

      print('ABC123 $documentSnapshot');
      if (documentSnapshot.exists) {

         print(docRef.path);
         docRef.update({count:"0"});
         print('Success ${docRef.update({count:"0"})}');
        Fluttertoast.showToast(msg: 'Success');
      } else {
        // Document not found, handle the error
        print('Document not found');
        Fluttertoast.showToast(msg: 'Document not found');
      }
    } catch (error) {
      print('Error updating count: $error');
      Fluttertoast.showToast(msg: 'Update failed: $error');
    }
  }


  Future<List<String>> fetchUserData(List<String> userIds) async {
    List<String> userData = [];
    getUserList();
    // Get a reference to the Firestore collection
    CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

    // Loop through the user IDs and fetch data for each user
    for (String userId in userIds) {
      DocumentSnapshot snapshot = await usersCollection.doc(userId).get();
      if (snapshot.exists) {
        // Extract the data you want to display from the document snapshot
        String userDataItem = snapshot.get(
            'data'); // Replace 'data' with the actual field name in your Firestore document
        userData.add(userDataItem);
      }
    }

    return userData;
  }

  getUserList() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
  if(Platform.isAndroid) {
    await Firebase.initializeApp(name: 'Plastic4Trade',
        options: FirebaseOptions(
            apiKey: "AIzaSyCTqG3cUX04ACxu1U4tRhfTrI_odai_ZPY",
            appId: "1:929685037367:android:4ee71ab0f0e0608492fab2",
            messagingSenderId: "929685037367",
            projectId: "plastic4trade-55372",
            databaseURL: "https://plastic4trade-55372-default-rtdb.firebaseio.com/"));
  } else if(Platform.isAndroid) {
    await Firebase.initializeApp(name: 'Plastic4Trade',
        options: FirebaseOptions(
            apiKey: "AIzaSyCTqG3cUX04ACxu1U4tRhfTrI_odai_ZPY",
            appId: "1:929685037367:ios:2ff9d0954f9bc0e292fab2",
            messagingSenderId: "929685037367",
            projectId: "plastic4trade-55372",
            databaseURL: "https://plastic4trade-55372-default-rtdb.firebaseio.com/"));
  }
    print('hee1');
    UserCredential userCredential = await signInAnonymously();
    /*FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;*/
    FirebaseAuth auth = FirebaseAuth.instance;

    final currentUser = auth.currentUser;
    customUserId = _pref.getString('user_id').toString();
    //count = _pref.getString('count').toString();
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
    yourStream = FirebaseFirestore.instance.collection('users').where(
        'senderId', isEqualTo: '14969');
    print('yourStream $yourStream');
    DatabaseReference newRef1 = FirebaseDatabase.instance.reference().child(
        "users").child('users');
    Future<DataSnapshot> newRef2 = FirebaseDatabase.instance.reference().child(
        "users").get();

    print(newRef2);
    //newRef1.ref.onValue.map((event) => event.snapshot);

    print(newRef1.path);
    print('hooooo');
    newRef2.then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        // Data exists in the snapshot

        var data = snapshot.value;


        //print(snapshot.value);
        snapshot.children.forEach((childSnapshot) {
          // Retrieve the data from each child
        //  print(childSnapshot.value);
          String childData = childSnapshot.key.toString();
          //print(childData);
          chat_userlist login = chat_userlist();
          List<String> parts = childData.split('-');
          if(parts.length==2) {
            if (parts[0].toString() == customUserId) {
              _userId.contains(parts[1].toString())?null:_userId.add(parts[1].toString());
              print('listofIDs');
              print(_userId);
             // print(parts[0].toString());
              // print(childSnapshot.children.)
              jsonData = childSnapshot.value;
              //var res =chat_userlist.fromJson(jsonData);
              print(childSnapshot.value);
              var convertedMap = jsonData.cast<String, dynamic>();
              login = chat_userlist.fromJson(convertedMap) ;

              childList.add(login);
              print('username ${login.userName2.toString()}');
              _username.add(login.userName2.toString());
              _userImage.add(login.userImage2.toString());
              print(parts[0].toString());
              print(parts);
              print(parts[1].toString());
              print(customUserId);

              //chat_userlist child = chat_userlist.fromJson(childSnapshot.value); // Create Child object from the snapshot
            } else if (parts[1].toString() == customUserId) {
              _userId.contains(parts[0].toString())?null:_userId.add(parts[0].toString());
              print('listofIDs');
              print(_userId);
              // print(childSnapshot.children.)
              jsonData = childSnapshot.value;
              print(childSnapshot.value);
              var convertedMap = jsonData.cast<String, dynamic>();
              login = chat_userlist.fromJson(convertedMap) ;
              print('dsfsffrfr');
              childList.add(login);
              print('username ${login.userName1.toString()}');
              _username.add(login.userName1.toString());
              _userImage.add(login.userImage1.toString());
              print('math $jsonData');


            }
          }

        });



      } else {
        // Data does not exist in the snapshot
        print("No data found");
      }
      print('--------------------');
      load = true;
      setState(() {
        print(childList);
      });

    });

    return yourStream;

  }
  List<chat_userlist> parseMessages(String jsonData) {
    final parsed = json.decode(jsonData).cast<Map<String, dynamic>>();
    return parsed.map<chat_userlist>((json) => chat_userlist.fromJson(json)).toList();
  }
 /* List<chat_userlist>? parseMessages(String jsonData) {
    final List<dynamic> messagesData = json.decode(jsonData);

    return messagesData.map((data) {
      return chat_userlist(
        count: data[''],
        mediaName: data[''],
        mediaType: data[''],
        messageText: data['messageText'],
        messageTime: data['messageTime'],
        senderId: data['senderId'],
        userImage2: data[''],
        userName2: data[''],
        userImage1: data['userImage1'],
        userName1: data['userName1'],

      );
    }).toList();

  }*/
  @override
  Widget build(BuildContext context) {
    return init();
  }

  Future<UserCredential> signInAnonymously() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInAnonymously();
    return userCredential;
  }


  //final DatabaseReference messagesRef = FirebaseDatabase.instance.reference().child('messages');


  Stream<QuerySnapshot<Map<String, dynamic>>> getDataStream() {
    // Replace 'collectionPath' with the actual path to your Firestore collection
    return FirebaseFirestore.instance.collection('users').snapshots();
  }




/*  Future<List<String>> getSenderReceiverList(String currentUserId) async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore
        .collection('users')
        .where('senderId', isEqualTo: currentUserId)
        .get();

    print(querySnapshot.docs);
    List<String> receiverList = [];
    for (final doc in querySnapshot.docs) {
      final receiver = doc['receiver'] as String;
      if (!receiverList.contains(receiver)) {
        receiverList.add(receiver);
      }
    }

    return receiverList;
  }*/
  Widget init() {
    return Scaffold(
      backgroundColor: const Color(0xFFDADADA),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: Text('Messages',
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
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Videos()));
              },
              child: SizedBox(
                  width: 40,
                  child: Image.asset(
                    'assets/Play.png',
                  )))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 8, 10, 8.0),
        child: Column(
          children: [
            // give the tab bar a height [can change hheight to preferred height]
            Padding(
                padding: EdgeInsets.fromLTRB(0, 8.0, 0.0, 5.0),
                child: SizedBox(
                    height: 50,
                    child:
                    TextFormField(
                      style: TextStyle(fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                      textCapitalization: TextCapitalization.words,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.text,

                      textInputAction: TextInputAction.next,

                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Search People or Messages",
                        hintStyle: TextStyle(fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontFamily: 'assets\fonst\Metropolis-Black.otf')
                            ?.copyWith(color: Colors.black45),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 20),
                        prefixIcon: Icon(Icons.search),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 1, color: Colors.grey),
                            borderRadius:
                            BorderRadius.circular(15.0)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(15.0)),

                        //errorText: _validusernm ? 'Name is not empty' : null),
                      ),
                    )
                )),

            //
            //tab bar view here
            Expanded(child: load==true?chatlist():Container(child: Center(
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
            ))

          ],
        ),
      ),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/floating_back.png")),
            borderRadius: BorderRadius.circular(30)
        ),
        child: IconButton(onPressed: () {

        }, icon: Icon(Icons.add, color: Colors.white, size: 40),
        ),
        //
      ),
    );
  }

   Widget chatlist()  {


    /* final userDoc = await FirebaseFirestore.instance
         .collection('users')
         .doc(currentUser?.uid)
         .get();*/
     //print('hee3 ${userDoc.id}');
     // print('hee6 ${userDoc.reference.snapshots().}');
     // await currentUser!.reload();

     // Assuming 'userList' is an array field in the 'users' document
   //  final userList1 = userDoc.data()?['userList'] as List<dynamic>?;
    // final userList = userDoc.data()?['userList'] as List<dynamic>?;
    // print('hee4');
   //  print('userList $userList1');
    // final currentUserId = currentUser?.displayName;
     // fetchData();
     /*final userCollection = FirebaseFirestore.instance.collection('users');
     print(userCollection.snapshots());
     final currentUser1 = FirebaseAuth.instance.currentUser;
     yourStream = FirebaseFirestore.instance.collection('users').where(
         'senderId', isEqualTo: '14969');
     print('yourStream $yourStream');
     DatabaseReference newRef1 = FirebaseDatabase.instance.reference().child(
         "users").child('users');
     Future<DataSnapshot> newRef2 = FirebaseDatabase.instance.reference().child(
         "users").get();

     print(newRef2);
     //newRef1.ref.onValue.map((event) => event.snapshot);

     print(newRef1.path);
     print('hooooo');
     newRef2.then((DataSnapshot snapshot) {
       if (snapshot.value != null) {
         // Data exists in the snapshot

         var data = snapshot.value;

         chat_userlist login = chat_userlist();
         //print(snapshot.value);
         snapshot.children.forEach((childSnapshot) {
           // Retrieve the data from each child
           //  print(childSnapshot.value);
           String childData = childSnapshot.key.toString();
           //print(childData);
           List<String> parts = childData.split('-');
           if(parts.length==2) {
             if (parts[0].toString() == customUserId) {
               print(parts[0].toString());
               // print(childSnapshot.children.)
               jsonData = childSnapshot.value;
               //var res =chat_userlist.fromJson(jsonData);
               print(childSnapshot.value);
               var convertedMap = jsonData.cast<String, dynamic>();
               login = chat_userlist.fromJson(convertedMap) ;
               print('dsfsffrfr');
               childList.add(login);
               print(parts[0].toString());
               print(parts);
               print(parts[1].toString());
               print(customUserId);

               //chat_userlist child = chat_userlist.fromJson(childSnapshot.value); // Create Child object from the snapshot
             } else if (parts[1].toString() == customUserId) {
               // print(childSnapshot.children.)
               jsonData = childSnapshot.value;
               print(childSnapshot.value);
               var convertedMap = jsonData.cast<String, dynamic>();
               login = chat_userlist.fromJson(convertedMap) ;
               print('dsfsffrfr');
               childList.add(login);


               print('math $jsonData');


             }
           }

         });



       } else {
         // Data does not exist in the snapshot
         print("No data found");
       }
       print('--------------------');
       load = true;
       setState(() {
         print(childList);
       });

     });*/



     return FutureBuilder(

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
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: childList.length,
            itemBuilder: (BuildContext context, int index) {
              chat_userlist record = childList[index];
              print(customUserId);
              print(record.senderId);
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(record.messageTime.toString()));

              String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
              var date =getTextForDate(DateTime.parse(formattedDateTime));
            /*  fetchCountFromFirebase(record.senderId).then((count) {
                setState(() {
                  record.count = count;
                });
              });*/

              return Container(

                  //height: 200,
                  child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Stack(clipBehavior: Clip.antiAlias, children: [
                        Positioned.fill(
                          child: Builder(
                              builder: (context) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Container(
                                      height: 50,
                                      color: Colors.red.shade600,
                                    ),
                                  )),
                        ),
                        ClipRRect(
                            //clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(15),
                            child: SlidableAutoCloseBehavior(
                                child: Slidable(
                              direction: Axis.horizontal,
                              endActionPane: ActionPane(
                                motion: const BehindMotion(),
                                extentRatio: 0.25,
                                children: [
                                  Expanded(
                                    // flex: 1,
                                    child: Container(
                                      //height: 180,

                                      // margin: const EdgeInsets.symmetric(
                                      //     horizontal: 8, vertical: 4.8),
                                      color: Colors.red.shade600,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              child: Container(
                                                width: double.infinity,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {},
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
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                onTap: ()  {
                                  updateChatCountToZero(
                                    "1",
                                     "14969",
                                      "19559",
                                     );
                                //  Fluttertoast.showToast(msg: record.senderId.toString());
                                 // Fluttertoast.showToast(msg: _userId.toString());
                                  //decrementAndViewChatCount(index);
                                  setState(() {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) =>
                                        ChartDetail('${_userId[index]}',
                                            '${_username[index]}','${_userImage[index]}')));
                                  });
                                },
                                child: Container(
                                  //height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Stack(
                                                fit: StackFit.passthrough,
                                                children: <Widget>[
                                                  Container(
                                                    width: 45.0,
                                                    height: 45.0,
                                                    margin: EdgeInsets.all(15.0),
                                                    decoration: BoxDecoration(
                                                      //  color: const Color(0xff7c94b6),
                                                         image: DecorationImage(
                                                    image: NetworkImage('assets/Ellipse 13.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                      // borderRadius: BorderRadius.all( Radius.circular(50.0)),
                                                      // border: Border.all(
                                                      //   color: const Color(0xffFFC107),
                                                      //   width: 2.0,
                                                      // ),
                                                    ),
                                                    child:  CircleAvatar(
                                                      radius: 100.0,
                                                      backgroundImage: NetworkImage(_userImage[index]) as ImageProvider,
                                                      //File imageFile = File(pickedFile.path);

                                                      backgroundColor: Color.fromARGB(255, 240, 238, 238),
                                                    ),
                                                  ),
                                                ]),
                                            IntrinsicWidth(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [

                                                  Text(
                                                      '${_username[index]}',
                                                      style: record.count==0? TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                          ?.copyWith(
                                                          fontSize: 15,
                                                          color:
                                                          Color.fromARGB(255, 0, 91, 148),fontWeight: FontWeight.bold)
                                                          : TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                          ?.copyWith(
                                                          fontSize: 15,
                                                          color: Colors.black),
                                                      maxLines: 1,

                                                      softWrap: false),

                                                  SizedBox(height: 3,),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width/1.76,
                                                    child: Text(
                                                        '${record.messageText}',
                                                        style:record.count!="0"? TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                            ?.copyWith(
                                                            color:
                                                            Color.fromARGB(255, 0, 91, 148),fontWeight: FontWeight.bold):
                                                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                            ?.copyWith(
                                                            color:
                                                            Colors.grey)
                                                        ,
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
                                      padding: EdgeInsets.only(top: 5,right: 5),
                                    child: IntrinsicWidth(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                           // mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '$date',
                                                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                      ?.copyWith(
                                                    fontSize: 11,
                                                      color:
                                                      Colors.grey),
                                                  maxLines: 1,
                                                  softWrap: false),
                                              SizedBox(height: 12,),
                                              Visibility(
                                                visible: record.count=="0"?false:true,
                                                child: Container(
                                                //color: Color.fromARGB(255, 0, 91, 148),
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(255, 0, 91, 148),
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 1.0,
                                                      style: BorderStyle.solid),

                                                  shape: BoxShape.circle),
                                      child: Center(
                                          child: Text(record.count.toString(),
                                              style:
                                              TextStyle(color: Colors.white))),
                                    )),

                                              ])
                                            ),
                                        )
                                    ])),
                                ),
                              ),
                            ))
                      ])));
            });

        return CircularProgressIndicator();
      }
    });
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
/*  Widget chatlist() {

    //final messages = parseMessages(jsonData);

    return ListView.builder(
      itemCount: childList.length,
      itemBuilder: (BuildContext context, int index) {
        chat_userlist message = childList[index];
        return ListTile(
          title: Text(message.userName1.toString()),
          subtitle: Text(message.userName1.toString()),
          // Customize the ListTile as needed
        );
      },

    );

  }*/


}
