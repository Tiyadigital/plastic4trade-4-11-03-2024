// ignore_for_file: camel_case_types, non_constant_identifier_names, unnecessary_null_comparison

import 'package:flutter/material.dart';

import '../widget/FilterScreen.dart';
import '../widget/HomeAppbar.dart';
import 'other_user_profile.dart';

class premum_member extends StatefulWidget {
  const premum_member({Key? key}) : super(key: key);

  @override
  State<premum_member> createState() => _DirectoryState();
}

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final String icon;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
  Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
  Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
  Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
  Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
  Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
];

class Choice1 {
  const Choice1({required this.title, required this.icon});

  final String title;
  final String icon;
}

List<String> cat_data = [
  'HDPE',
  'LDPE',
  'PP',
  'LLDPL',
  'BOPP',
  'PLC',
  'UPVC',
  'HDPE',
  'LDPE',
  'PP',
  'LLDPL',
  'BOPP',
  'PLC',
  'UPVC'
];
const List<Choice1> choicess = <Choice1>[
  Choice1(
      title: 'LLDPE Price Update',
      icon: 'assets/plastic4trade logo final 1 (2).png'),
  Choice1(
      title: 'LLDPE Price Update',
      icon: 'assets/plastic4trade logo final 1 (2).png'),
  Choice1(
      title: 'LLDPE Price Update',
      icon: 'assets/plastic4trade logo final 1 (2).png'),
  Choice1(
      title: 'LLDPE Price Update',
      icon: 'assets/plastic4trade logo final 1 (2).png'),
];

class _DirectoryState extends State<premum_member> {
  int selectedIndex = 0, _defaultChoiceIndex = -1;
  List<String> cat_data = [
    'HDPE',
    'LDPE',
    'PP',
    'LLDPL',
    'BOPP',
    'PLC',
    'UPVC',
    'HDPE',
    'LDPE',
    'PP',
    'LLDPL',
    'BOPP',
    'PLC',
    'UPVC'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDADADA),
      appBar: CustomeApp('PremiumMember'),
      body: Column(children: [
        // give the tab bar a height [can change hheight to preferred height]
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                decoration: const BoxDecoration(
                  //color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                        topLeft: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0))),
                height: 45,
                width: MediaQuery.of(context).size.width / 2.6,
                child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Card(
                      color: Colors.white,
                        //margin: EdgeInsets.all(10),
                        shape: const StadiumBorder(
                            side: BorderSide(
                                style: BorderStyle.solid, color: Colors.white)),
                        child: Container(
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(63.05),
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
                            // mainAxisAlignment:
                            //     MainAxisAlignment.spaceEvenly,
                            children: const [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: ImageIcon(
                                      AssetImage('assets/location.png'))),
                              Text(
                                'Ahmedabad',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf'),
                              )
                            ],
                          ),
                        )))),
            SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width / 1.9,
                child: Card(
                    //margin: EdgeInsets.all(10),
                    shape: const StadiumBorder(
                        side: BorderSide(
                            style: BorderStyle.solid, color: Colors.white)),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(63.05),
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
                        // mainAxisAlignment:
                        //     MainAxisAlignment.spaceEvenly,
                        children: const [
                          Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: ImageIcon(AssetImage('assets/search.png'))),
                          Text('Search',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily:
                                      'assets/fonst/Metropolis-Black.otf'))
                        ],
                      ),
                    ))),
            GestureDetector(
                onTap: () {
                  ViewItem(context);
                },
                child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width / 11.5,
                    // padding: EdgeInsets.only(right: 5),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white),
                    child: const Icon(
                      Icons.filter_alt,
                      color: Colors.black,
                    )))
          ],
        ),
        horiztallist(),
        directory()
        // tab bar view here
      ]),
    );
  }

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
        builder: (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize:
                0.85, // Initial height as a fraction of screen height
            builder: (BuildContext context, ScrollController scrollController) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return const FilterScreen();
                },
              );
            }));
  }

  Widget directory() {
    return Expanded(
        child: Container(
            //height: 200,

            padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0),
            width: MediaQuery.of(context).size.width,
            child:
            // FutureBuilder(
            //     //future: load_category(),
            //     builder: (context, snapshot) {
            //   if (snapshot.hasError) {
            //     return Text('Error: ${snapshot.error}');
            //   } else {
            //     //List<dynamic> users = snapshot.data as List<dynamic>;
            //     return
                  ListView.builder(
                  //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  // crossAxisCount: 2,
                  // mainAxisSpacing: 5,
                  // crossAxisSpacing: 5,
                  /*  // childAspectRatio: .90,
                    childAspectRatio:MediaQuery.of(context).size.height/330,
                    mainAxisSpacing: 4.0,
                    crossAxisCount: 1,
                  ),*/
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: choices.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: (() {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) =>
                                  other_user_profile(1)));
                        }),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            //margin: const EdgeInsets.all(8.0),
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
                            child: Column(children: [
                              SizedBox(
                                // margin: EdgeInsets.all(10.0),
                                height: 75,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  10.0, 10.0, 0, 0),
                                              child: const Text(
                                                'Milan Patel',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf'),
                                              )),

                                          Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  10.0, 2.0, 0, 0),
                                              child: Text(
                                                  'Manufacture | Trader',
                                                  style: const TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'assets/fonst/Metropolis-Black.otf')
                                                      .copyWith(
                                                          color:
                                                              Colors.black45))),
                                          Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  10.0, 2.0, 0, 0),
                                              child: const Text(
                                                'Ahmedabad, GJ, India',
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'assets/fonst/Metropolis-Black.otf'),
                                              )),
                                          // Text('Manufacture | Trader'),
                                        ]),
                                    Container(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                6,
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 5.0, 5.0, 0),
                                        child: const Image(
                                            image: AssetImage(
                                                'assets/Ellipse 13.png'))),
                                  ],
                                ),
                              ),

                              Container(
                                  //height: 50,
                                  margin: const EdgeInsets.fromLTRB(
                                      10.0, 2.0, 0.0, 0),
                                  child: const Text(
                                    'White PP Natural PP PPCP, Grinding, Mix Scrap Pipe, UPVC, +10 more',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily:
                                            'assets/fonst/Metropolis-Black.otf',
                                        fontSize: 13,
                                        color: Colors.black),
                                    maxLines: 2,
                                  )),
                              //SizedBox(height: 5.0,)
                            ]),
                          ),
                        ));
                  },
                ),
            //   }
            // }
            // )
        ));
  }

  Widget horiztallist() {
    return Container(
        height: 50,
        margin: const EdgeInsets.fromLTRB(10.0, 2.0, 0, 0),
        //margin: EdgeInsets.fromLTRB(10, 2.0, 0.0, 0),
        child:
        // FutureBuilder(
        //   future: ,
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
                shrinkWrap: false,
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: cat_data.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: ChoiceChip(
                        label: Text(cat_data[index].toString()),
                        selected: _defaultChoiceIndex == index,
                        selectedColor: Colors.green,
                        onSelected: (bool selected) {
                          setState(() {
                            _defaultChoiceIndex = selected ? index : 0;
                          });
                        },
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        backgroundColor: Colors.white,
                        labelStyle: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontFamily: 'assets/fonst/Metropolis-Black.otf'),
                      ));
                }),
        //   }
        // })
    );
  }
}
