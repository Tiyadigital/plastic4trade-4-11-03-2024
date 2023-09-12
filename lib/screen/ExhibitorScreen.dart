import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:ui';
import 'package:getwidget/getwidget.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:Plastic4trade/model/getExhibitor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_interface.dart';
import '../constroller/GetCategoryController.dart';
import '../widget/FilterScreen.dart';
import '../widget/HomeAppbar.dart';
import '../utill/constant.dart';
import 'package:Plastic4trade/model/getExhibitor.dart' as exhibitor;
import 'package:Plastic4trade/model/GetCategory.dart' as cat;


class Exhibitor extends StatefulWidget {
  const Exhibitor({Key? key}) : super(key: key);

  @override
  State<Exhibitor> createState() => _DirectoryState();
}





class _DirectoryState extends State<Exhibitor> {
  String category_id = '',grade_id='',type_id='',bussinesstype='',post_type='',lat='',log='';
  final PageController controller = PageController(initialPage: 0);
  List<dynamic>? exhibitorList;
  bool? isload;
  int selectedIndex = 0, _defaultChoiceIndex = -1;
  int offset=0;
  List<exhibitor.Result> exhibitor_data = [];
  List<dynamic> resultList=[];
  List<dynamic> resultList1=[];
  List<dynamic> resultList2=[];
  var business_type;
  List<String>?  ints;
  String? location, search;
  String googleApikey = "AIzaSyCyqsD3OPUWGJ5AWbN3iKbUzQGs3Q-ZlPE";

  TextEditingController _loc = TextEditingController();
  TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('init');
    checknetowork();
  }
  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      get_categorylist();
      get_Exhibitorlist();

      // get_data();
    }
  }

  get_Exhibitorlist() async {
    getExhibitor getdir = getExhibitor();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(constanst.lat);
    print(constanst.log);
    var res = await get_exhibitor(offset.toString(),category_id,grade_id,type_id,bussinesstype,post_type,constanst.lat,constanst.log,_search.text.toString());
    var jsonarray;

    print(res);
    if (res['status'] == 1) {
      getdir = getExhibitor.fromJson(res);
      /*resultList = salePostList.result;
      print(resultList);*/
      if (res['result'] != null) {
        jsonarray = res['result'];
        exhibitorList=res['result'];

       // print(jsonarray['images']);
        //resultList = getdir.result;

        String bt_type="";
        List b_type=[];

        for (var data in jsonarray) {
          exhibitor.Result record = exhibitor.Result(
              username: data['username'],
              address: data['address'],
              businessName: data['business_name'],
              userImageUrl: data['user_image_url']);

          // business_type = data['business_type'];

          List<dynamic>? strs =(data["business_type"] as List)?.map((e) => e.toString()).toList();

          /* ints=(data["business_type"] as List)?.map((e) {
            print(e)
          },);*/
          print(ints);
          String str=strs!.join(",");
          print('str $str');
          resultList.add(str);

          List<dynamic>? strs1 =(data["product_name"] as List)?.map((e) => e.toString()).toList();
          String str1=strs1!.join(",");
          print('str $str1');
          resultList1.add(str1);

          List<dynamic>? strs2 =(data["images"] as List)?.map((e) => e.toString()).toList();
          //print('list $strs2');
          String str3=strs2!.join(",");
          print('String $str3');
         // print('str3 $str3');
          resultList2.add(str3);
          print(resultList2);
          //  print(business_type);
          /* if (business_type != null) {
           // for (var data in business_type) {

            if(bussiness_type.length>=2) {
              b_type = business_type.split(",");
              bt_type = b_type.join(',');
              print(bt_type);

              // }
              bussiness_type.add(bt_type);
              print('bussiness type $bussiness_type');
            }else{
              bussiness_type.add(bt_type);
            }
          }*/
          exhibitor_data.add(record);
        }



        isload = true;
        print(exhibitor_data);
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      isload = true;
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
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
  @override
  Widget build(BuildContext context) {
    return init();
  }

  Widget init() {
    return Scaffold(
      backgroundColor: Color(0xFFDADADA),
      appBar:CustomeApp('Exhibitor'),
      body: isload==true? Column(
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
                            bottomLeft: Radius.circular(40.0)),
                        color: Colors.white),
                    height: 40,
                    margin: EdgeInsets.only(left: 8.0),
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Padding(
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        child: TextField(
                          controller: _loc,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          readOnly: true,
                          onTap: () async {
                            var place = await PlacesAutocomplete.show(
                                context: context,
                                apiKey: googleApikey,
                                mode: Mode.overlay,
                                types: ['(cities)'],
                                strictbounds: false,
                                // components: [Component(Component.country, 'np')],
                                //google_map_webservice package
                                onError: (err) {
                                  print(err);
                                });

                            if (place != null) {
                              setState(() {
                                location = place.description.toString();
                                _loc.text = location!;

                                _onLoading();
                                exhibitor_data.clear();
                                get_Exhibitorlist();

                              });

                              //form google_maps_webservice package
                              final plist = GoogleMapsPlaces(
                                apiKey: googleApikey,
                                apiHeaders:
                                await GoogleApiHeaders().getHeaders(),
                                //from google_api_headers package
                              );
                              String placeid = place.placeId ?? "0";
                              final detail =
                              await plist.getDetailsByPlaceId(placeid);

                              final geometry = detail.result.geometry!;
                              constanst.lat = geometry.location.lat.toString();

                              constanst.log = geometry.location.lng.toString();
                              WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                              // var newlatlang = LatLng(lat, log);

                              //move map camera to selected place with animation
                              //mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                            }
                          },
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIconConstraints:
                              BoxConstraints(minWidth: 24),
                              suffixIconConstraints:
                              BoxConstraints(minWidth: 24),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(right: 2, left: 2),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.black45,
                                  size: 20,
                                ),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  _loc.clear();
                                  WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 2, left: 2),
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.black45,
                                    size: 20,
                                  ),
                                ),
                              ),
                              hintText: 'Location',
                              hintStyle:
                              TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                          onChanged: (value) {},
                        ))),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                            topLeft: Radius.circular(40.0),
                            bottomLeft: Radius.circular(40.0)),
                        color: Colors.white),
                    height: 40,
                    margin: EdgeInsets.only(left: 8.0),
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: TextField(
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          controller: _search,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIconConstraints:
                              BoxConstraints(minWidth: 24),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black45,
                                  size: 20,
                                ),
                              ),
                              hintText: 'Search',
                              hintStyle:
                              TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                          onSubmitted: (value) {
                            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                            setState(() {});
                          },
                          onChanged: (value) {
                            WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                          },

                        ))),
                GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width /11.5,
                        // padding: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 0, 91, 148)
                        ),
                        child: GestureDetector(onTap: () {
                          ViewItem(context);
                        },child: Icon(Icons.filter_alt,color: Colors.white,))
                    )
                )
              ],
            ),
            horiztallist(),
            directory()
            // tab bar view here


          ])
      :Center(
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
                        // childAspectRatio: .90,
                    /*    childAspectRatio:MediaQuery.of(context).size.height/1150,
                        mainAxisSpacing: 4.0,
                        crossAxisCount: 1,
                      ),*/
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: exhibitor_data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        exhibitor.Result record = exhibitor_data[index];

                        //print(exhibitorList![index]['images']);
                        List<dynamic> firstExhibitorImages = exhibitorList![index]['images'];

                        return GestureDetector(
                            onTap: (() {

                            }),
                            child: Card(

                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Container(
                                //margin: EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Container(
                                      margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                                      //padding: EdgeInsets.all(10.0),
                                      //transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  width: 70.0,
                                                  height: 70.0,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xff7c94b6),
                                                    image: DecorationImage(
                                                      image: NetworkImage(record.userImageUrl.toString()),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius: BorderRadius.all( Radius.circular(50.0)),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  //height: 30,
                                                  //margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                                                    padding: EdgeInsets.all(3.0),
                                                    transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                      color: const Color(0xffFFC107),
                                                    ),
                                                    child: Text('Premium',style: TextStyle(fontSize: 9,fontWeight: FontWeight.w600,color: Colors.black),)),
                                              ],
                                            ),

                                            Flexible(

                                                child:Padding(
                                                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                                                    child: Column(
                                                      children: [

                                                        Align(

                                                          child:
                                                          Text(record.username.toString(),
                                                              softWrap: false,
                                                              style: TextStyle(
                                                                  fontSize: 16.0,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: Colors.black,
                                                                  fontFamily:
                                                                  'assets\fonst\Metropolis-SemiBold.otf'),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis),
                                                          alignment: Alignment.topLeft,

                                                        ),
                                                        Align(
                                                          child:  Text(resultList[index].toString(),
                                                              softWrap: false,
                                                              style:TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')?.copyWith(fontSize: 11),
                                                              textAlign: TextAlign.left,
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis),
                                                          alignment: Alignment.topLeft,
                                                        ),




                                                        SizedBox(
                                                          //width: MediaQuery.of(context).size.width/0.9,
                                                          // height: 25,
                                                          child: Row(
                                                            children: [
                                                              ImageIcon(AssetImage(
                                                                  'assets/location.png'),size: 10),
                                                              Expanded(
                                                                  child: Text(record.address.toString(),
                                                                      softWrap: false,
                                                                      style:TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')?.copyWith(fontSize: 11),
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis))
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                )

                                            ),


                                                Image.asset("assets/call2.png",width: 30,height: 30,),

                                                SizedBox(width: 2,),

                                                Image.asset("assets/msg1.png",width: 30,height: 30,),
                                            SizedBox(width: 2,),

                                            Image.asset("assets/web.png",width: 30,height: 30,),


                                          ])
                                  ),
                                  Divider(

                                    color: Colors.black38,
                                  ),
                              Container(
                                //height: 50,
                                  margin: const EdgeInsets.fromLTRB(10.0,2.0,0.0,0),
                                  child:
                                  Align(

                                    child:
                                    Text(record.businessName.toString(),
                                        softWrap: false,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontFamily:
                                            'assets\fonst\Metropolis-SemiBold.otf'),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    alignment: Alignment.topLeft,

                                  ),
                              ),
                                  SizedBox(height: 5,),
                                  Container(
                                    margin: EdgeInsets.only(left: 15),
                                    child: Row(
                                      children: [
                                           Image.asset('assets/verify1.png',width: 20,height: 20,),
                                        SizedBox(width: 3,),
                                          Text('Verified'),
                                        SizedBox(width: 5,),
                                        Image.asset('assets/trust.png',width: 20,height: 15,),
                                        SizedBox(width: 3,),
                                        Text('Trusted')
                                      ],
                                    )
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      //height: 50,
                                        margin: const EdgeInsets.fromLTRB(10.0,10.0,10.0,0),
                                        padding: EdgeInsets.only(right: 15.0),
                                        child:  Text(
                                          resultList1[index].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily:
                                              'assets\fonst\Metropolis-Black.otf',
                                              fontSize: 13,
                                              color: Colors.black),
                                          maxLines: 2,
                                        )),
                                  ),
                                  //SizedBox(height: 5.0,)
                                  firstExhibitorImages.isNotEmpty?slider(firstExhibitorImages):Image.asset('assets/plastic4trade logo final.png')
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
                    itemCount: constanst.catdata.length,
                    itemBuilder: (context, index) {
                      cat.Result result =constanst.catdata[index];
                      return Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child:
                          ChoiceChip(

                            label: Text(constanst.catdata[index].categoryName.toString()),
                            selected: _defaultChoiceIndex == index,
                            selectedColor: Color.fromARGB(255, 0, 91, 148),


                            onSelected: (bool selected) {
                              setState(() {
                                _defaultChoiceIndex = selected ? index : 0;
                                category_id=result.categoryId.toString();
                                exhibitor_data.clear();
                                _onLoading();
                                get_Exhibitorlist();

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
  Widget slider(List firstExhibitorImages) {
    return GFCarousel(
      height: 330,
      autoPlay: true,
      pagerSize: 2.0,
      viewportFraction: 1.0,
      aspectRatio: 2,
      // hasPagination: true,
      //
      // activeIndicator: Colors.lightBlue,

      items: firstExhibitorImages.map(
            (url) {
             
          return Container(
            // decoration:BoxDecoration(
            //   borderRadius: BorderRadius.circular(25.0)),
            margin: EdgeInsets.all(15.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: Image.network(url, fit: BoxFit.cover, width: 2500.0),
            ),
          );
        },
      ).toList(),
      onPageChanged: (index) {
        setState(() {
          index;
          //cat_data.clear();
        });
      },
    );

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
            })).then(
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
    );
  }


 /* Widget slider(List firstExhibitorImages) {
    return SizedBox(
        height: 200.0,
        child: Container(
          color: Colors.grey,
          child: PageView.builder(
            controller: controller,

            itemCount: firstExhibitorImages.length,
            itemBuilder: (context, index) {
              *//*img.Result record = banner_img[index];*//*
              print('images123 $firstExhibitorImages');
              print('awd');
              print(firstExhibitorImages[index]);
              return Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    child: Image.network(firstExhibitorImages[index].toString(),
                        fit: BoxFit.fill, width: 2500.0),
                  ));


             *//* new Center(
                child: new Text(record.bannerImage.toString()),
              );*//*
            },
          ),
        ));
  }*/

}
