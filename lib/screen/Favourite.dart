import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/model/getFollowingList.dart';
import 'package:Plastic4trade/widget/HomeAppbar.dart';
import 'package:Plastic4trade/model/GetFavoriteList.dart' as fav;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';
import '../model/CommonPostdetail.dart';
import '../model/GetFavoriteList.dart';
class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}


class _FavouriteState extends State<Favourite> {



 List<fav.Result> favlist=[];
 bool isload=false;
 @override
  void initState() {
    // TODO: implement initState
   get_fav();
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }
  Widget init() {
    return  Scaffold(
      backgroundColor: Color(0xFFDADADA),
      appBar:CustomeApp('Favourite'),
        body: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [


              isload==true?fav_list(): Center(
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
            ])),

        // bottomNavigationBar: BottomMenu(
        //   selectedIndex: selectedIndex,
        //   onClicked: onClicked,
        // ),

    );
  }
  Widget fav_list() {
    return Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
        child: FutureBuilder(
          //future: load_category(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Align(
                  alignment: Alignment.center,
                  child:Text('Error: ${snapshot.error}') ,
                );
              } else if (snapshot.hasData){
                return Text('Data Not Found ');
              }
              else {
                //List<dynamic> users = snapshot.data as List<dynamic>;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    // crossAxisCount: 2,
                    // mainAxisSpacing: 5,
                    // crossAxisSpacing: 5,
                    // childAspectRatio: .90,
                    childAspectRatio:MediaQuery.of(context).size.height/1150,
                    mainAxisSpacing: 3.0,
                    crossAxisCount: 2,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: favlist.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    fav.Result record = favlist[index];
                    return GestureDetector(
                      onTap: (() {

                      }),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(children: [
                          Stack(
                              fit: StackFit.passthrough,

                              children: <Widget>[
                                Container(
                                  height: 150,
                                  margin: EdgeInsets.all(5.0),
                                  child: Image(
                                    errorBuilder: (context, object, trace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color.fromARGB(255, 223, 220, 220),
                                        ),
                                      );
                                    },
                                    image: NetworkImage(record.mainproductImage ?? ''
                                      //data[index]['member_image'] ?? '',
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 0, 148, 95),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    // color: Color.fromARGB(0,255, 255, 255),
                                    child: Text(
                                        '₹' + record.productPrice.toString(),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w800,
                                            fontFamily:
                                            'assets\fonst\Metropolis-Black.otf',
                                            color: Colors.white)),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Container(

                                    color: Color.fromARGB(0,255, 255, 255),
                                    child: Center(
                                        child: GestureDetector(child:Image.asset('assets/fav.png',height: 30,width: 30,),
                                          onTap: () {
                                          setState(() {
                                            //choices.r
                                            getremove_product(record.productId.toString());
                                            favlist.removeAt(index);
                                          });

                                          },)
                                    ),
                                  ),
                                ),]),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                    padding:
                                    EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(record.productName.toString(),
                                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-SemiBold.otf'),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)),
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                        record.productType.toString() +
                                            ' | ' +
                                            record.productGrade.toString(),
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.grey,
                                          fontFamily: 'Metropolis',
                                        ),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  )),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(top: 10.0, left: 10.0),
                                    child: Text(
                                        record.state.toString() +
                                            ',' +
                                            record.country.toString(),
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.grey,
                                          fontFamily: 'Metropolis',
                                        ),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  )),


                            ],
                          )
                        ]),
                      ),
                    );
                  },
                );
              }


            }));
  }

  Future<void> get_fav() async {
    GetFavoriteList getfollwinglist = GetFavoriteList();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await favList(_pref.getString('user_id').toString(),
      _pref.getString('api_token').toString());

    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getfollwinglist = GetFavoriteList.fromJson(res);
      if (res['result'] != null) {
        jsonarray = res['result'];
        //totalfollowing=res['totalFollowing'];

        for (var data in jsonarray) {
          fav.Result record = fav.Result(
              productName: data['ProductName'],
              categoryName: data['CategoryName'],
              productGrade: data['ProductGrade'],
              currency: data['Currency'],
              productPrice: data['ProductPrice'],
              postType: data['PostType'],
              //isPaidPost: data['is_paid_post'],
              productType: data['ProductType'],
              country: data['Country'],
              city: data['City'],
              productId: data['productId'],
              mainproductImage: data['mainproductImage'],
            state: data['State']


          );

          favlist.add(record);
          //loadmore = true;
        }
        isload==true;
        print(favlist);
        if (mounted) {
          setState(() {

          });
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;

  }
 getremove_product(String prod_id) async {
   CommonPostdetail commonPostdetail = CommonPostdetail();
   SharedPreferences _pref = await SharedPreferences.getInstance();
   Fluttertoast.showToast(msg: prod_id.toString());
   var res = await removefav(_pref.getString('user_id').toString(),
       _pref.getString('api_token').toString(),prod_id.toString());
   var jsonarray;

   print(res);
   if (res['status'] == 1) {

     commonPostdetail = CommonPostdetail.fromJson(res);
     //if (res['result'] != null) {
     jsonarray = res['result'];
     //Fluttertoast.showToast(msg: res['message']);
    // prod_like=false;

     //   }




     setState(() {});
   } else {
     Fluttertoast.showToast(msg: res['message']);
   }
   setState(() {});
   return jsonarray;

 }
}

