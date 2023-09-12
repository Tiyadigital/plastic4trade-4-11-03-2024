import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:Plastic4trade/model/GetUpcomingExhibition.dart';
import 'package:Plastic4trade/model/common.dart';
import 'package:Plastic4trade/screen/ExhitionDetail.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:Plastic4trade/model/GetUpcomingExhibition.dart' as getnews;
import 'package:http/http.dart' as http;
import '../api/api_interface.dart';
import '../constroller/GetCategoryController.dart';
import '../widget/HomeAppbar.dart';
import 'dart:io';
import '../utill/constant.dart';
import 'package:Plastic4trade/model/GetCategory.dart' as cat;

import 'package:path_provider/path_provider.dart';

class Exhibition extends StatefulWidget {
  const Exhibition({Key? key}) : super(key: key);

  @override
  State<Exhibition> createState() => _ExhibitionState();
}





class _ExhibitionState extends State<Exhibition>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool unread = false,
      isload = false,
      alldata = true;
  List<getnews.Data> getupexbitiondata = [];
  List<getnews.Data> getpastexbitiondata = [];
  String? packageName, create_formattedDate, end_formattedDate;
  PackageInfo? packageInfo;
  String limit = "20";
  int selectedIndex = 0, _defaultChoiceIndex = -1;
  String category_filter_id="";
  final scrollercontroller = ScrollController();
  int count = 0;
  int offset = 0;
  @override
  void initState() {
    checknetowork();
    _tabController = TabController(length: 2, vsync: this);
    scrollercontroller.addListener(_scrollercontroller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      getPackage();
      get_UpcomingExhibition(offset.toString());
      get_pastExhibition(offset.toString());
      get_categorylist();
      // get_data();
    }
  }

  Widget init() {
    return Scaffold(
        backgroundColor: Color(0xFFDADADA),
        appBar: CustomeApp('Exhibition'),
        body: isload == true
            ? Column(children: [
                // give the tab bar a height [can change hheight to preferred height]
                horiztallist(),
                Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 8),
                    child: Container(
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
                              'Upcoming Exhibition',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Metropolis',
                              ),
                            ),
                          ),

                          // second tab [you can add an icon using the icon property]
                          Tab(
                            child: Text(
                              'Past Exhibition',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Metropolis',
                              ),
                            ),
                          ),
                        ],
                        onTap: (value) {
                          if (value == 0) {

                            unread = true;
                            alldata = false;
                          } else if (value == 1) {
                            alldata = true;
                            unread = false;
                          }
                        },
                      ),
                    )),
                // tab bar view here
                Expanded(
                  child: TabBarView(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _tabController,
                      // first tab bar view widget
                      children: [
                        upcoming_exhibition(),
                        past_exhibition()
                        /*news()*/
                      ]),

                  // second tab bar view widget
                ),
              ])
            : Center(
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

  Widget upcoming_exhibition() {
    return Container(
        padding: EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 0),
        //margin: EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
            //future: load_category(),
            builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            //List<dynamic> users = snapshot.data as List<dynamic>;
            return ListView.builder(
              //  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // crossAxisCount: 2,
              // mainAxisSpacing: 5,
              // crossAxisSpacing: 5,
              // childAspectRatio: .90,
              /* childAspectRatio:MediaQuery.of(context).size.height/750,
                    mainAxisSpacing: 12.0,
                    crossAxisCount: 1,
                  ),*/
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: getupexbitiondata.length,
              shrinkWrap: true,
              controller: scrollercontroller,
              itemBuilder: (context, index) {
                getnews.Data result = getupexbitiondata[index];
                DateFormat format = new DateFormat("yyyy-MM-dd");

                var curret_date = format.parse(result.startDate.toString());

                DateTime? dt1 = DateTime.parse(curret_date.toString());

                // print(dt1);
                create_formattedDate =
                    dt1 != null ? DateFormat('dd MMMM yyyy').format(dt1) : "";
                var end_date = format.parse(result.endDate.toString());

                DateTime? dt2 = DateTime.parse(end_date.toString());

                // print(dt1);
                end_formattedDate =
                    dt1 != null ? DateFormat('dd MMMM yyyy ').format(dt1) : "";
                print('islike123');
                print(result.isLike);
                return GestureDetector(
                    onTap: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExhitionDetail(blog_id: result.id.toString()),
                          ));
                    }),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(children: [
                        Container(
                          margin: EdgeInsets.all(10.0),
                          height: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            /*shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10.0)),*/
                            child: Image(
                              errorBuilder: (context, object, trace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 223, 220, 220),
                                  ),
                                );
                              },
                              image: NetworkImage(result.imageUrl ?? ''
                                  //data[index]['member_image'] ?? '',
                                  ),
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 4),
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  // child: Flexible(
                                  child: Text(result.title.toString(),
                                      maxLines: 2,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'Metropolis',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ))
                                  // )

                                  ),
                              Row(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.calendar_month_outlined,
                                              size: 20),
                                          SizedBox(width: 2),
                                          Text(
                                            create_formattedDate! +
                                                " - " +
                                                end_formattedDate!,
                                            style:TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                ?.copyWith(fontSize: 11),
                                          )
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(left: 15.0),
                                      child: Row(
                                        children: [
                                          ImageIcon(
                                              AssetImage('assets/location.png'),
                                              size: 15),
                                          SizedBox(width: 2),
                                          Text(
                                            result.location.toString(),
                                            style:TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                ?.copyWith(fontSize: 11),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  // child: Flexible(
                                  child: Text(result.metaDescription.toString(),
                                      maxLines: 2,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'Metropolis',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ))
                                  // )

                                  ),
                              Divider(height: 2.0, thickness: 2),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.6,
                                      height: 18,
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          //mainAxisSize: MainAxisSize.min,
                                          children: [
                                            result.isLike=="0"?
                                            GestureDetector(
                                                onTap: () {
                                                  Exhibitionlike(result.id.toString());
                                                  result.isLike='1';
                                                  int like=int.parse(result.likeCounter.toString());
                                                  like=like+1;
                                                  result.likeCounter=like.toString();
                                                  /*getnewsdata.clear();
                                              get_News();*/
                                                  setState(() {});
                                                },
                                        child : Image.asset('assets/like.png',width: 30,height: 28,),)
                                                :GestureDetector(
                                                onTap: () {
                                                  Exhibitionlike(result.id.toString());
                                                  result.isLike='0';
                                                  int like=int.parse(result.likeCounter.toString());
                                                  like=like-1;
                                                  result.likeCounter=like.toString();
                                                  //getnewsdata.clear();
                                                  // get_News();
                                                  setState(() {});
                                                },
                                                child : Image.asset('assets/like1.png',width: 50,height: 28,)),
                                            Text('Interested ('+ result.likeCounter.toString()+')',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontFamily: 'Metropolis',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ))
                                          ],
                                        ),
                                      )),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3.5,
                                    height: 18,
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                            onTap: () {},
                                            child: ImageIcon(
                                              AssetImage('assets/show.png'),
                                              color: Colors.black,
                                              size: 20,
                                            )),
                                        SizedBox(width: 2),
                                        Text(result.viewCounter.toString(),
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: 'Metropolis',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                          5.0,
                                      height: 18,
                                      child: Row(
                                        //mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                shareImage(url: result.imageUrl.toString(), title: result.title.toString());
                                              },
                                              child: ImageIcon(AssetImage(
                                                  'assets/Send.png'))),
                                          SizedBox(width: 2),
                                          Text('Share',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: 'Metropolis',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ))
                                        ],
                                      )),
                                  Container(
                                    height: 15,
                                  ),
                                ],
                              ),
                              Container(
                                height: 15,
                              ),
                            ]),
                      ]),
                    ));
              },
            );
          }

          return CircularProgressIndicator();
        }));
  }

  Widget past_exhibition() {
    return Container(
        padding: EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 0),
        //margin: EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
            //future: load_category(),
            builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            //List<dynamic> users = snapshot.data as List<dynamic>;
            return ListView.builder(
              //  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // crossAxisCount: 2,
              // mainAxisSpacing: 5,
              // crossAxisSpacing: 5,
              // childAspectRatio: .90,
              /* childAspectRatio:MediaQuery.of(context).size.height/750,
                    mainAxisSpacing: 12.0,
                    crossAxisCount: 1,
                  ),*/
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: getpastexbitiondata.length,
              shrinkWrap: true,
              controller: scrollercontroller,
              itemBuilder: (context, index) {
                getnews.Data result = getpastexbitiondata[index];
                DateFormat format = new DateFormat("yyyy-MM-dd");

                var curret_date = format.parse(result.startDate.toString());

                DateTime? dt1 = DateTime.parse(curret_date.toString());

                // print(dt1);
                create_formattedDate =
                    dt1 != null ? DateFormat('dd MMMM yyyy').format(dt1) : "";
                var end_date = format.parse(result.endDate.toString());

                DateTime? dt2 = DateTime.parse(end_date.toString());

                // print(dt1);
                end_formattedDate =
                    dt1 != null ? DateFormat('dd MMMM yyyy ').format(dt1) : "";
                return GestureDetector(
                    onTap: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExhitionDetail(blog_id: result.id.toString()),
                          ));
                    }),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(children: [
                        Container(
                          margin: EdgeInsets.all(10.0),
                          height: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            /*shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10.0)),*/
                            child: Image(
                              errorBuilder: (context, object, trace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 223, 220, 220),
                                  ),
                                );
                              },
                              image: NetworkImage(result.imageUrl ?? ''
                                  //data[index]['member_image'] ?? '',
                                  ),
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 4),
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  // child: Flexible(
                                  child: Text(result.title.toString(),
                                      maxLines: 2,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'Metropolis',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ))
                                  // )

                                  ),
                              Row(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.calendar_month_outlined,
                                              size: 20),
                                          SizedBox(width: 2),
                                          Text(
                                            create_formattedDate! +
                                                " - " +
                                                end_formattedDate!,
                                            style:TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                ?.copyWith(fontSize: 11),
                                          )
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(left: 15.0),
                                      child: Row(
                                        children: [
                                          ImageIcon(
                                              AssetImage('assets/location.png'),
                                              size: 15),
                                          SizedBox(width: 2),
                                          Text(
                                            result.location.toString(),
                                            style:TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500,fontFamily: 'assets\fonst\Metropolis-Black.otf')
                                                ?.copyWith(fontSize: 11),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  // child: Flexible(
                                  child: Text(result.metaDescription.toString(),
                                      maxLines: 2,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'Metropolis',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ))
                                  // )

                                  ),
                              Divider(height: 2.0, thickness: 2),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.7,
                                      height: 18,
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          //mainAxisSize: MainAxisSize.min,
                                          children: [
                                            result.isLike=="0"?
                                            GestureDetector(
                                              onTap: () {
                                                Exhibitionlike(result.id.toString());
                                                result.isLike='1';
                                                int like=int.parse(result.likeCounter.toString());
                                                like=like+1;
                                                result.likeCounter=like.toString();
                                                /*getnewsdata.clear();
                                              get_News();*/
                                                setState(() {});
                                              },
                                              child : Image.asset('assets/like.png',width: 30,height: 28,),)
                                                :GestureDetector(
                                                onTap: () {
                                                  Exhibitionlike(result.id.toString());
                                                  result.isLike='0';
                                                  int like=int.parse(result.likeCounter.toString());
                                                  like=like-1;
                                                  result.likeCounter=like.toString();
                                                  //getnewsdata.clear();
                                                  // get_News();
                                                  setState(() {});
                                                },
                                                child : Image.asset('assets/like1.png',width: 30,height: 28,)),
                                            Text('Interested ('+ result.likeCounter.toString()+')',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontFamily: 'Metropolis',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ))
                                          ],
                                        ),
                                      )),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3.5,
                                    height: 18,
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                            onTap: () {},
                                            child: ImageIcon(
                                              AssetImage('assets/show.png'),
                                              color: Colors.black,
                                              size: 20,
                                            )),
                                        SizedBox(width: 2),
                                        Text(result.viewCounter.toString(),
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: 'Metropolis',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                          5.0,
                                      height: 18,
                                      child: Row(
                                        //mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                shareImage(url: result.imageUrl.toString(), title: result.title.toString());
                                              },
                                              child: ImageIcon(AssetImage(
                                                  'assets/Send.png'))),
                                          SizedBox(width: 2),
                                          Text('Share',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: 'Metropolis',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ))
                                        ],
                                      )),
                                  Container(
                                    height: 15,
                                  ),
                                ],
                              ),
                              Container(
                                height: 15,
                              ),
                            ]),
                      ]),
                    ));
              },
            );
          }

          return CircularProgressIndicator();
        }));
  }

  Widget horiztallist() {
    return Container(
        height: 50,
        color: Colors.white,
        //margin: EdgeInsets.only(top: 5.0),
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
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: constanst.catdata.length,
                    itemBuilder: (context, index) {
                      cat.Result result =constanst.catdata[index];
                      return Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Wrap(spacing: 6.0, runSpacing: 6.0, children: <
                              Widget>[
                            ChoiceChip(
                              label: Text(
                                  constanst.catdata[index].categoryName.toString()),
                              selected: _defaultChoiceIndex == index,
                              selectedColor:  Color.fromARGB(255, 0, 91, 148),
                              onSelected: (bool selected) {
                                setState(() {
                                  _defaultChoiceIndex = selected ? index : -1;

                                  if (_tabController.index==0) {
                                    if (_defaultChoiceIndex == -1) {
                                      category_filter_id = "";
                                      getupexbitiondata.clear();
                                      _onLoading();
                                      get_UpcomingExhibition(offset.toString());
                                    } else {
                                      category_filter_id =
                                          result.categoryId.toString();
                                      getupexbitiondata.clear();
                                      _onLoading();
                                      get_UpcomingExhibition(offset.toString());
                                    }
                                  }else if (_tabController.index==1) {

                                    if (_defaultChoiceIndex == -1) {
                                      category_filter_id = "";
                                      getupexbitiondata.clear();
                                      _onLoading();
                                      get_UpcomingExhibition(offset.toString());
                                    } else {
                                      category_filter_id =
                                          result.categoryId.toString();
                                      getupexbitiondata.clear();
                                      _onLoading();
                                      get_UpcomingExhibition(offset.toString());
                                    }
                                    }

                                });
                              },
                              // padding: EdgeInsets.all(5),
                              backgroundColor: Color.fromARGB(255, 236, 232, 232),
                              labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')?.copyWith(color: _defaultChoiceIndex==index? Colors.white:Colors.black ),
                              labelPadding: EdgeInsets.symmetric(horizontal: 14.0),
                              /*shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                              ),*/
                            )
                          ]));
                    });
              }
            }));
  }

  Future<void> get_UpcomingExhibition(String offset) async {
    GetUpcomingExhibition getsimmilar = GetUpcomingExhibition();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getupcoming_exbition(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),offset.toString(),limit,category_filter_id);

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = GetUpcomingExhibition.fromJson(res);
      if (res['data'] != null) {
        jsonarray = res['data'];

        //
        for (var data in jsonarray) {
          getnews.Data record = getnews.Data(
              id: data['id'],
              isLike: data['isLike'],
              viewCounter: data['view_counter'],
              metaDescription: data['meta_description'],
              startDate: data['start_date'],
              endDate: data['end_date'],
              location: data['location'],
              imageUrl: data['image_url'],
              likeCounter: data['like_counter'],
              title: data['title']);

          getupexbitiondata.add(record);
          //loadmore = true;
        }
        //isload = true;

        print(getupexbitiondata);
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }

  Future<void> get_pastExhibition(String offset) async {
    GetUpcomingExhibition getsimmilar = GetUpcomingExhibition();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getpast_exbition(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),offset.toString(),limit,category_filter_id);

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getsimmilar = GetUpcomingExhibition.fromJson(res);
      if (res['data'] != null) {
        jsonarray = res['data'];

        //
        for (var data in jsonarray) {
          getnews.Data record = getnews.Data(
              id: data['id'],
              isLike: data['isLike'],
              viewCounter: data['view_counter'],
              metaDescription: data['meta_description'],
              startDate: data['start_date'],
              endDate: data['end_date'],
              location: data['location'],
              imageUrl: data['image_url'],
              likeCounter: data['like_counter'],
              title: data['title']);

          getpastexbitiondata.add(record);
          //loadmore = true;
        }


        print(getpastexbitiondata);
        if (mounted) {
          setState(() {});
        }
      } else {
        isload = true;
      }
    } else {
      isload = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }

  Future<void> Exhibitionlike(String news_id) async {
    common_par getsimmilar = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(news_id);
    var res = await exbitionlike_like(
        news_id.toString(),
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());

    print(res);
    if (res['status'] == 1) {
      getsimmilar = common_par.fromJson(res);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {});
  }

  void getPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
    String version = packageInfo!.version;
    String buildNumber = packageInfo!.buildNumber;
    print(
        "App Name : ${appName}, App Package Name: ${packageName},App Version: ${version}, App build Number: ${buildNumber}");
  }
  void shareImage({required String url,required String title}) async {
    final imageurl = url;
    final uri = Uri.parse(imageurl);
    final response = await http.get(uri);
    final bytes = response.bodyBytes;
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);
    await Share.shareFiles([path], text: title+"\t"+"\n"+ "\n"+'Hey check out my app at: https://play.google.com/store/apps/details?id='+packageName!);
  }
  void _scrollercontroller() {
    if (scrollercontroller.position.pixels ==
        scrollercontroller.position.maxScrollExtent) {
      print(unread);
      print(alldata);

      if (_tabController.index==0) {


        count++;
        if (count == 1) {
          offset = offset + 21;
        } else {
          offset = offset + 20;
        }
        _onLoading();
        get_UpcomingExhibition(offset.toString());
      } else if (_tabController.index==1) {
        count++;


        if (count == 1) {
          offset = offset + 21;
        } else {
          offset = offset + 20;
        }
        _onLoading();
        get_pastExhibition( offset.toString());
      }
    } /*else{
      print('hello');
    }*/
  }
  void _onLoading() {
    BuildContext dialogContext=context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context; // Store the context in a variable
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child:  SizedBox(
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
          ),/*Container(
            child: Stack(
              children: <Widget>[
                Container(
                  width: 300.0,
                  height: 150.0,
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    width: 300.0,
                    height: 150.0,
                    alignment: AlignmentDirectional.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const
                      *//*  Container(
                          margin: const EdgeInsets.only(top: 25.0),
                          child: Center(
                            child: Text(
                              "loading.. wait...",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),*//*
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )*/
        );
      },
    );

    Future.delayed(const Duration(seconds: 5), () {
      print('exit');
      Navigator.of(dialogContext).pop(); // Use dialogContext to close the dialog
      print('exit1'); // Dialog closed
    });
  }
  void get_categorylist() async {
    GetCategoryController bt = await GetCategoryController();
    constanst.cat_data = bt.setlogin();

    constanst.cat_data!.then((value) {
      if (value != null) {
        for (var item in value) {
          constanst.catdata.add(item);
        }
      }
      isload = true;
      setState(() {});
    });
    //
  }
}
