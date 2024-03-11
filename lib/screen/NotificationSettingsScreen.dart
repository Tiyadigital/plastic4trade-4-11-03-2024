// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

class Notificationsetting extends StatefulWidget {
  const Notificationsetting({Key? key}) : super(key: key);

  @override
  State<Notificationsetting> createState() => _NotificationsettingState();
}

class Choice {
  Choice({required this.title, required this.icon});

  String title;
  bool icon;
}

List<Choice> choices = <Choice>[
  Choice(title: 'Sell Post', icon: true),
  Choice(title: 'Buy Post', icon: true),
  Choice(title: 'Domestic', icon: true),
  Choice(title: 'International', icon: true),
  Choice(title: 'Category, Type, Grade Match', icon: true),
  Choice(title: 'Followers', icon: true),
  Choice(title: 'Post Interested', icon: true),
  Choice(title: 'Post Comment', icon: true),
  Choice(title: 'Favourite', icon: true),
  Choice(title: 'Business Profile Like', icon: true),
  Choice(title: 'User Follow', icon: true),
  Choice(title: 'User Unfollow', icon: true),
  Choice(title: 'Live Price', icon: true),
  Choice(title: 'Quick News', icon: true),
  Choice(title: 'News', icon: true),
  Choice(title: 'Blog', icon: true),
  Choice(title: 'Video', icon: true),
  Choice(title: 'Banner', icon: true),
  Choice(title: 'Chat', icon: true),
];

class _NotificationsettingState extends State<Notificationsetting> {
  @override
  Widget build(BuildContext context) {
    return initwidget();
  }

  Widget initwidget() {
    return Scaffold(
        // backgroundColor: Color.fromARGB(240, 218, 218, 218),
        backgroundColor: const Color(0xFFDADADA),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          elevation: 0,
          title: const Text('Notification Settings',
              softWrap: true,
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
        body: notificationsetting());
  }

  Widget notificationsetting() {
    return Container(
        margin: const EdgeInsets.all(10.0),
        child:
        // FutureBuilder(
        //
        //     //future: load_subcategory(),
        //     builder: (context, snapshot) {
        //   if (snapshot.connectionState == ConnectionState.none &&
        //       snapshot.hasData == null) {
        //     return const Center(child: CircularProgressIndicator());
        //   }
        //   if (snapshot.hasError) {
        //     return Text('Error: ${snapshot.error}');
        //   } else {
        //     //List<dynamic> users = snapshot.data as List<dynamic>;
        //     return
              ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: choices.length,
                padding: const EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
                itemBuilder: (context, index) {
                  Choice record = choices[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {});
                    },
                    child: SizedBox(
                        height: 65,
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: Container(
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13.05),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x3FA6A6A6),
                                  blurRadius: 16.32,
                                  offset: Offset(0, 3.26),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 0, 5.0, 0.0),
                                    child: Image.asset(
                                      'assets/Notification.png',
                                      color: Colors.black54,
                                      height: 20,
                                    )),
                                Expanded(
                                    child: Text(
                                  record.title,
                                  style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets/fonst/Metropolis-Black.otf')
                                      .copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                )),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Switch(
                                    value: record.icon,
                                    onChanged: (value) {
                                      setState(() {
                                        record.icon=value;
                                      });
                                    },
                                    activeTrackColor: const Color(0xFF38B623),
                                    activeColor: Colors.white,
                                    inactiveTrackColor: const Color(0xFFD9D9D9),
                                    inactiveThumbColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),),
                  );
                }),
        //   }
        // }
        // )
    );
  }
}
