import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:Plastic4trade/model/getDirectory.dart';
import 'package:Plastic4trade/widget/mybottombar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import '../api/api_interface.dart';
import '../utill/constant.dart';
import '../constroller/GetCategoryController.dart';
import '../widget/FilterScreen.dart';
import '../widget/HomeAppbar.dart';
import 'package:Plastic4trade/model/getDirectory.dart' as dir;
import 'package:Plastic4trade/model/GetCategory.dart' as cat;
import 'dart:io' as io;
class Directory1 extends StatefulWidget {
  const Directory1({Key? key}) : super(key: key);

  @override
  State<Directory1> createState() => _DirectoryState();
}
class _DirectoryState extends State<Directory1> {

  int selectedIndex = 0, _defaultChoiceIndex = -1;
  int offset=0;
  int count=0;
  bool? isload;
  List<dir.Result> dir_data = [];
  List<dynamic> resultList=[];
  List<dynamic> resultList1=[];
  var business_type;
  List<String>?  ints;
  String googleApikey = "AIzaSyCyqsD3OPUWGJ5AWbN3iKbUzQGs3Q-ZlPE";
  String? location, search;

  String category_filter_id = '',category_id='""',grade_id='',type_id='',bussinesstype='',post_type='';
  TextEditingController _loc = TextEditingController();
  TextEditingController _search = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checknetowork();
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Widget init() {
    return Scaffold(
      backgroundColor: Color(0xFFDADADA),
        appBar:CustomeApp('Directory'),
      body: isload==true? Column(
          children: [
            // give the tab bar a height [can change hheight to preferred height]
            SizedBox(height: 3,),
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
                                constanst.location=place.description.toString();
                                _loc.text = location!;

                                /*

                                List<String> list = place.description.toString().split(",");
                                list.length>2?state =list[1].toString():state ='';
                                list.length>=3?country =list[2].toString():country ='';
                                city=list[0];
                                print(list);
                                print(state);
                                print(city);
                                print(country);

                                _color5=Colors.green.shade600;
                                // print(location);
                                setState(() {

                                });*/
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
                              WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                              constanst.log = geometry.location.lng.toString();
                              print(constanst.log);
                              print(constanst.lat);
                              dir_data.clear();
                              count = 0;
                              offset = 0;
                              //get_HomePostSearch();
                              _onLoading();
                              get_direcorylist();
                              setState(() {});
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
                                  WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                                  _loc.clear();
                                  count = 0;
                                  offset = 0;
                                  constanst.lat = "";
                                  constanst.log = "";
                                  dir_data.clear();
                                  _onLoading();
                                  get_direcorylist();
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
                            dir_data.clear();
                            count = 0;
                            offset = 0;
                            _onLoading();
                            get_direcorylist();
                            setState(() {});
                          },
                          onChanged: (value) {
                            if(value.isEmpty){
                              WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
                              _search.clear();
                              count = 0;
                              offset = 0;
                              dir_data.clear();
                              _onLoading();
                              get_direcorylist();
                              setState(() {});
                            }
                          },

                        ))),
                GestureDetector(
                    onTap: () {
                      ViewItem(context);
                    },
                    child: Container(
                        height: 45,
                        margin:
                        EdgeInsets.only(bottom: 3.0, left: 1.2, top: 3.0),
                        width: MediaQuery.of(context).size.width / 11.2,
                        // padding: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: Icon(
                          Icons.filter_alt,
                          color: Colors.black,
                        )))
              ],
            ),
            horiztallist(),
            directory()
            // tab bar view here


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
        print(constanst.location);
        _loc.text=constanst.location.toString();
        category_filter_id = constanst.select_categotyId.join(",");
        type_id = constanst.select_typeId.join(",");
        grade_id = constanst.select_gradeId.join(",");
        bussinesstype = constanst.selectbusstype_id.join(",");

        post_type = constanst.select_categotyType.join(",");


        dir_data.clear();
        _onLoading();

        get_direcorylist();
        constanst.select_categotyId.clear();
        constanst.select_typeId.clear();
        constanst.select_gradeId.clear();
        constanst.selectbusstype_id.clear();
        constanst.select_categotyType.clear();

        setState(() {});

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

                  /*  childAspectRatio:MediaQuery.of(context).size.height/330,
                    mainAxisSpacing: 4.0,
                    crossAxisCount: 1,
                  ),*/
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: dir_data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    dir.Result record = dir_data[index];
                    String colorString="";
                    print(resultList);


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
                                    Text(record.userImage.toString(),
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf'),)),


                          Container(
                              margin: const EdgeInsets.fromLTRB(10.0,2.0,0,0),
                              child: Text(resultList[index].toString(),
                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')?.copyWith(color: Colors.black45))),
                              Container(
                                  margin: const EdgeInsets.fromLTRB(10.0,2.0,0,0),
                                  child:  Text(record.address.toString(),
                                      style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500,fontFamily: 'assets\fonst\Metropolis-Black.otf'),)),
                                // Text('Manufacture | Trader'),
                                 ]
                                ),
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

                              ],
                            ),

                           

                          ),

                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                               //height: 50,
                                margin: const EdgeInsets.fromLTRB(10.0,2.0,0.0,0),
                                child:  Text(
                                  resultList1[index].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily:
                                      'assets\fonst\Metropolis-Black.otf',
                                      fontSize: 13,
                                      color: Colors.black),
                                  maxLines: 2,
                                )),
                          ),
                          SizedBox(height: 5.0,)

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
                                  if(_defaultChoiceIndex==-1){
                                    category_filter_id="";
                                   dir_data.clear();
                                    _onLoading();
                                  get_direcorylist()();
                                  }else{
                                    category_filter_id=result.categoryId.toString();
                                    dir_data.clear();
                                    _onLoading();
                                    get_direcorylist();
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
  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      get_categorylist();
      get_direcorylist();



      // get_data();
    }
  }

  get_direcorylist() async {
    getDirectory getdir = getDirectory();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await get_directory(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),  offset.toString(),category_filter_id,grade_id,type_id,bussinesstype,post_type,constanst.lat,constanst.log,_search.text.toString());
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getdir = getDirectory.fromJson(res);
      /*resultList = salePostList.result;
      print(resultList);*/
      if (res['result'] != null) {
        jsonarray = res['result'];

        print(jsonarray);
        //resultList = getdir.result;

        String bt_type="";
        List b_type=[];

        for (var data in jsonarray) {
          dir.Result record = dir.Result(
              userImage: data['username'],
              address: data['address'],
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
          dir_data.add(record);
        }

        print(business_type);

        isload = true;
        print(dir_data);
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

}
