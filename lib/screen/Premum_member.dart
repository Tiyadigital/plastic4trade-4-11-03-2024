import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Plastic4trade/widget/mybottombar.dart';
import 'dart:ui';

import '../widget/FilterScreen.dart';
import '../widget/HomeAppbar.dart';

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

const List<Choice> choices = const <Choice>[
  const Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
  const Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
  const Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
  const Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
  const Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
  const Choice(title: 'IFB YELLOW ABS', icon: 'assets/image 3.png'),
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
const List<Choice1> choicess = const <Choice1>[
  const Choice1(
      title: 'LLDPE Price Update',
      icon: 'assets/plastic4trade logo final 1 (2).png'),
  const Choice1(
      title: 'LLDPE Price Update',
      icon: 'assets/plastic4trade logo final 1 (2).png'),
  const Choice1(
      title: 'LLDPE Price Update',
      icon: 'assets/plastic4trade logo final 1 (2).png'),
  const Choice1(
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
    return init();
  }

  Widget init() {
    return Scaffold(
      backgroundColor: Color(0xFFDADADA),
        appBar:CustomeApp('PremiumMember'),
      body:  Column(
          children: [
            // give the tab bar a height [can change hheight to preferred height]
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                            topLeft: Radius.circular(40.0),
                            bottomLeft: Radius.circular(40.0))),
                    height: 45,
                    width: MediaQuery.of(context).size.width / 2.6,
                    child: Padding(padding: EdgeInsets.only(left: 5.0),
                        child: Card(
                          //margin: EdgeInsets.all(10),
                            shape: StadiumBorder(
                                side: BorderSide(style: BorderStyle.solid,
                                    color: Colors.white)),
                            child: Row(
                              // mainAxisAlignment:
                              //     MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child:
                                    ImageIcon(AssetImage('assets/location.png'))),
                                Text('Ahmedabad',
                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),)
                              ],
                            )))),
                Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width / 1.9,
                    child: Card(
                      //margin: EdgeInsets.all(10),
                        shape: StadiumBorder(
                            side: BorderSide(style: BorderStyle.solid,color: Colors.white)),
                        child: Row(
                          // mainAxisAlignment:
                          //     MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child:
                                ImageIcon(AssetImage('assets/search.png'))),
                            Text('Search',
                                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'))
                          ],
                        ))),
                GestureDetector(
                    onTap: () {
                      ViewItem(context);
                    },
                    child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width /11.5,
                        // padding: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 0, 91, 148)
                        ),
                        child: Icon(Icons.filter_alt,color: Colors.white,)
                    )
                )
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
                  return FilterScreen();
                },
              );
            }));
    /*.then(
          (value) {
        print(constanst.select_categotyId);
        category_id = constanst.select_categotyId.join(",");
        type_id = constanst.select_typeId.join(",");
        grade_id = constanst.select_gradeId.join(",");
        bussinesstype = constanst.selectbusstype_id.join(",");

        post_type = constanst.select_categotyType.join(",");


        exhibitor_data.clear();
        _onLoading();

        get_Exhibitorlist();
        constanst.select_categotyId.clear();
        constanst.select_typeId.clear();
        constanst.select_gradeId.clear();
        constanst.selectbusstype_id.clear();
        constanst.select_categotyType.clear();

        setState(() {});

      },
    );*/
  }
  Widget directory() {
    return Expanded(
    child:Container(
      //height: 200,
      
          padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0),
          width: MediaQuery.of(context).size.width,
          child:
            FutureBuilder(
                //future: load_category(),
                builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                //List<dynamic> users = snapshot.data as List<dynamic>;
                return ListView.builder(
                  //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    // crossAxisCount: 2,
                    // mainAxisSpacing: 5,
                    // crossAxisSpacing: 5,
                  /*  // childAspectRatio: .90,
                    childAspectRatio:MediaQuery.of(context).size.height/330,
                    mainAxisSpacing: 4.0,
                    crossAxisCount: 1,
                  ),*/
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: choices.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Choice record = choices[index];
                    return GestureDetector(
                      onTap: (() {

                      }),
                      child: Card(
                        
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          child: Column(children: [
                          Container(
                           // margin: EdgeInsets.all(10.0),
                            height: 75,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: const EdgeInsets.fromLTRB(10.0,10.0,0,0),
                                  child:
                                    Text('Milan Patel',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),)),


                          Container(
                              margin: const EdgeInsets.fromLTRB(10.0,2.0,0,0),
                              child: Text('Manufacture | Trader',
                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')?.copyWith(color: Colors.black45))),
                              Container(
                                  margin: const EdgeInsets.fromLTRB(10.0,2.0,0,0),
                                  child:  Text('Ahmedabad, GJ, India',
                                      style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500,fontFamily: 'assets\fonst\Metropolis-Black.otf'),)),
                                // Text('Manufacture | Trader'),
                                 ]
                                ),
                                Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width/6,
                                    margin: EdgeInsets.fromLTRB(0,5.0, 5.0,0),
                                    child: Image(
                                        image: AssetImage(
                                            'assets/Ellipse 13.png'))),

                              ],
                            ),

                           

                          ),

                          Container(
                             //height: 50,
                              margin: const EdgeInsets.fromLTRB(10.0,2.0,0.0,0),
                              child:  Text(
                                'White PP Natural PP PPCP, Grinding, Mix Scrap Pipe, UPVC, +10 more',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily:
                                    'assets\fonst\Metropolis-Black.otf',
                                    fontSize: 13,
                                    color: Colors.black),
                                maxLines: 2,
                              )),
                          //SizedBox(height: 5.0,)

                        ]),
                      ),
                    ));
                  },
                );
              }

              return CircularProgressIndicator();
            })
          ));

  }
  Widget horiztallist() {
    return Container(
        height: 50,

        margin: EdgeInsets.fromLTRB(10.0, 2.0,0,0),
        //margin: EdgeInsets.fromLTRB(10, 2.0, 0.0, 0),
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
                    shrinkWrap: false,
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: cat_data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child:
                                ChoiceChip(
                                  label: Text(cat_data[index].toString()),
                                  selected: _defaultChoiceIndex == index,
                                  selectedColor: Colors.green,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _defaultChoiceIndex = selected ? index : 0;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),bottomRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))),
                                  backgroundColor:
                                  Colors.white,
                                  labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                                )
                              );
                    });
              }
            }));
  }


}
