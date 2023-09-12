import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'other_user_profile.dart';

class demo extends StatefulWidget {
  const demo({Key? key}) : super(key: key);

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: 100,
          margin: EdgeInsets.only(top: 50),
          child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
            GestureDetector(
              onTap: () {
                print('Tap');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => other_user_profile(14969),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xffFFC107),
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                            //color:  Colors.blue,
                            image: DecorationImage(
                              image: AssetImage("assets/Buyer.png"),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.circle,
                            // borderRadius: BorderRadius.all(Radius.circular(50.0)),
                            border: Border.all(
                              color: const Color(0xffFFC107),
                              width: 2.0,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(3.0),
                          transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color(0xffFFC107),
                          ),
                          child: Text(
                            'Premium',
                            style: TextStyle(fontSize: 9),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        print('Tap123');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => other_user_profile(14969!),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          border: Border.all(
                            color: const Color(0xffFFC107),
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                          child: Column(
                            children: [
                              Align(
                                child: Text(
                                  'patel'.toString(),
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontFamily:
                                        'assets\fonst\Metropolis-SemiBold.otf',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                alignment: Alignment.topLeft,
                              ),
                              Align(
                                child: Text(
                                  'grrg'.toString(),
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontFamily:
                                        'assets\fonst\Metropolis-Black.otf',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                alignment: Alignment.topLeft,
                              ),
                              SizedBox(
                                child: Row(
                                  children: [
                                    ImageIcon(AssetImage('assets/location.png')),
                                    Expanded(
                                      child: Text(
                                        'rajkot'.toString(),
                                        softWrap: false,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          fontFamily:
                                              'assets\fonst\Metropolis-Black.otf',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/follow1.png",
                  width: 50,
                  height: 50,
                ),
                Text(
                  'Followed',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              width: 10.0,
            ),
            Column(
              children: [
                Image.asset(
                  "assets/user_chat.png",
                  width: 50,
                  height: 50,
                ),
                Text(
                  'Chat',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                )
              ],
            )
          ]),
        ));
  }
}
