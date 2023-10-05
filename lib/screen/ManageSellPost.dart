import 'dart:io';

import 'package:Plastic4trade/screen/Type.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/screen/updatePost.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Plastic4trade/model/GetSalePostList.dart' as homepost;
import 'package:Plastic4trade/utill/constant.dart';
import '../api/api_interface.dart';
import '../model/GetSalePostList.dart';
import '../model/common.dart';
import '../widget/HomeAppbar.dart';
import 'AddPost.dart';
import 'CategoryScreen.dart';
import 'GradeScreen.dart';
import 'Register2.dart';
import 'Videos.dart';

class managesellpost extends StatefulWidget {
  final String Title;
  const managesellpost({Key? key, required this.Title}) : super(key: key);

  @override
  State<managesellpost> createState() => _managesellpostState();
}

class _managesellpostState extends State<managesellpost> {
  List<String> selectedItemValue = <String>[];
  int offset = 0;
  bool isload = false;
  var jsonarray;
  GetSalePostList salePostList = new GetSalePostList();
  List<homepost.Result>? resultList;
  List<homepost.PostColor> colors = [];
  List<homepost.Result> salepostlist_data = [];
  var color_array;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checknetowork();
  }

  @override
  Widget build(BuildContext context) {
    return initwidget();
  }

  Widget initwidget() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFDADADA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text('Manage Sell Posts',
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
                    context, MaterialPageRoute(builder: (context) => Videos()));
              },
              child: SizedBox(
                  width: 40,
                  child: Image.asset(
                    'assets/Play.png',
                  ))),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [category()],
      )),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage("assets/floating_back.png")),
            borderRadius: BorderRadius.circular(30)),
        child: IconButton(
          onPressed: () {
            constanst.redirectpage = "add_post";

            if (constanst.appopencount == constanst.appopencount1) {
              if (!constanst.isgrade &&
                  !constanst.istype &&
                  !constanst.iscategory &&
                  !constanst.isprofile) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPost(),
                    ));
              } else if (constanst.isprofile) {
                showInformationDialog(context);
              } else if (constanst.iscategory) {
                constanst.redirectpage = "add_cat";
                categoryDialog(context);
              } else if (constanst.isgrade) {
                constanst.redirectpage = "add_type";
                categoryDialog(context);
              } else if (constanst.istype) {
                constanst.redirectpage = "add_grade";
                categoryDialog(context);
              }
            } else {
              if (constanst.isprofile) {
                showInformationDialog(context);
              } else if (constanst.iscategory) {
                constanst.redirectpage = "add_cat";
                categoryDialog(context);
              } else if (constanst.isgrade) {
                constanst.redirectpage = "add_type";
                categoryDialog(context);
              } else if (constanst.istype) {
                constanst.redirectpage = "add_grade";
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Grade(),
                    ));
              } else if (constanst.step != 11) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPost(),
                    ));
              } else if (!constanst.isgrade &&
                  !constanst.istype &&
                  !constanst.iscategory &&
                  !constanst.isprofile) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPost(),
                    ));
              }
            }
          },
          icon: const Icon(Icons.add, color: Colors.white, size: 40),
        ),
        //
      ),
    );
  }

  Widget category() {
    return isload == true
        ? Padding(
            padding: EdgeInsets.all(15),
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
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: salepostlist_data.length,
                    itemBuilder: (context, index) {
                      print(salePostList.result);
                      Result? record = salePostList.result![index];
                      print('record1233');
                      print(record);
                      //homepost.Result record = salepostlist_data[index];
                      //Color color=Colors.white;
                      homepost.PostColor result = colors[index];
                      final hexCode =
                          result.haxCode.toString().replaceAll('#', '');

                      for (int i = 0; i < salepostlist_data.length; i++) {
                        selectedItemValue.add(record!.productStatus.toString());
                      }
                      // if(record.postColor!=null) {

                      // }

                      return GestureDetector(
                        onTap: () {
                          setState(() {});
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              // border: Border.all(width: 1),
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white),
                          child: Row(children: [
                            Stack(fit: StackFit.passthrough, children: <Widget>[
                              Container(
                                height: 120,
                                width: 100,
                                margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    //color: Colors.black26,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  /*shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10.0)),*/
                                  child: Image(
                                    image: NetworkImage(
                                        record!.mainproductImage.toString()),
                                    fit: BoxFit.cover,
                                    height: 150,
                                    width: 170,
                                  ),
                                ),
                                /* child:Image(
                                errorBuilder: (context, object, trace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(
                                          255, 223, 220, 220),
                                    ),
                                  );
                                },
                                image: NetworkImage(result.mainproductImage.toString()),fit: BoxFit.cover,width: 170,height: 150,
                            ),*/
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
                            ]),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    child: Text('${record.postName}',
                                        style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromARGB(
                                                    255, 0, 91, 148),
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf')
                                            ?.copyWith(
                                                fontSize: 12,
                                                color: Colors.black),
                                        maxLines: 2,
                                        softWrap: false),
                                  ),
                                  SizedBox(
                                      height: 20,
                                      child: Text(
                                          record.categoryName.toString() +
                                              " | " +
                                              record.productType.toString() +
                                              " | " +
                                              record.productGrade.toString(),
                                          style: TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      'assets\fonst\Metropolis-Black.otf')
                                              ?.copyWith(
                                                  fontSize: 11,
                                                  color: Colors.black),
                                          maxLines: 2,
                                          softWrap: false)),
                                  SizedBox(
                                      height: 15,
                                      child: Text(
                                        "${record.state} ${record.country}",
                                        style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    'assets\fonst\Metropolis-Black.otf')
                                            ?.copyWith(
                                                fontSize: 11,
                                                color: Colors.black),
                                      )),
                                  SizedBox(
                                      height: 20,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            child: Text('Qty:',
                                                style: TextStyle(
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            'assets\fonst\Metropolis-Black.otf')
                                                    ?.copyWith(
                                                        fontSize: 11,
                                                        color: Colors.black),
                                                softWrap: false),
                                          ),
                                          Text(
                                              record.postQuntity.toString() +
                                                  ' ' +
                                                  record.unit.toString(),
                                              style: TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          'assets\fonst\Metropolis-Black.otf')
                                                  ?.copyWith(
                                                      fontSize: 11,
                                                      color: Colors.black),
                                              maxLines: 1,
                                              softWrap: false),
                                        ],
                                      )),
                                  /* Icon(
                                    Icons.circle,
                                    size: 13,
                                    color: Color(
                                        int.parse('FF$hexCode', radix: 16)),
                                  ),*/
                                  // list_view(index),

                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      // crossAxisCount: 2,
                                      // mainAxisSpacing: 5,
                                      // crossAxisSpacing: 5,
                                      // childAspectRatio: .90,

                                      childAspectRatio:
                                          MediaQuery.of(context).size.height /
                                              1000,
                                      //MediaQuery.of(context).size.aspectRatio * 1.3,
                                      crossAxisSpacing: 0.0,
                                      mainAxisSpacing: 0.0,
                                      crossAxisCount: 15,
                                    ),
                                    itemCount: record.postColor?.length ?? 0,
                                    itemBuilder: (context, colorIndex) {
                                      PostColor? color =
                                          record?.postColor?[colorIndex];
                                      String colorString = resultList![index]
                                          .postColor![colorIndex]
                                          .haxCode
                                          .toString();

                                      String newStr = colorString.substring(1);

                                      Color colors =
                                          Color(int.parse(newStr, radix: 16))
                                              .withOpacity(1.0);
                                      return Container(
                                          margin: EdgeInsets.zero,
                                          padding: EdgeInsets.zero,
                                          child: newStr == 'ffffff'
                                              ? const Icon(Icons.circle_outlined,
                                                  size: 15)
                                              : Icon(Icons.circle_rounded,
                                                  size: 15, color: colors));
                                    },
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      //prd_cap_dropdown(listitem,'select ')
                                      SizedBox(
                                          width: 105,
                                          child: Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  0.0, 0.0, 0.0, 0),
                                              child: Container(
                                                  height: 30,
                                                  width: 80,
                                                  padding: const EdgeInsets.only(
                                                    left: 5.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              280.0),
                                                      color: Colors.white),
                                                  child: DropdownButton(
                                                    value:
                                                        selectedItemValue[index]
                                                            .toString(),
                                                    items: _dropDownItem(),
                                                    //hint: Text('Enter team'),
                                                    onChanged: (value) {
                                                      selectedItemValue[index] =
                                                          value!;
                                                      setState(() {
                                                        print(
                                                            '${index} and ${value}');
                                                        set_prod_status(
                                                            record.productId
                                                                .toString(),
                                                            value);
                                                      });
                                                    },
                                                    isExpanded: true,
                                                    underline: Container(),
                                                    hint: const Center(
                                                        child: Text(
                                                      'Select',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                                  )))),
                                      SizedBox(
                                          child: GestureDetector(
                                        onTap: () {
                                          set_pushnotification(
                                              record.productId.toString());
                                        },
                                        child: Image.asset('assets/flash.png',
                                            width: 30, height: 30),
                                      )),
                                      SizedBox(
                                          child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdatePOst(
                                                          'SalePost',
                                                          record.productId
                                                              .toString())));
                                        },
                                        child: Image.asset('assets/edit1.png',
                                            width: 30, height: 30),
                                      )),
                                      SizedBox(
                                          child: GestureDetector(
                                        onTap: () {
                                          if (salepostlist_data.length == 1) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Minimum 1 Sale Post or Buy Post Is Required');
                                          } else {
                                            delete_confirm(
                                                context,
                                                record.productId.toString(),
                                                index);
                                          }
                                        },
                                        child: Image.asset(
                                          'assets/delete1.png',
                                          width: 30,
                                          height: 30,
                                        ),
                                      )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      );
                    });

                return CircularProgressIndicator();
              }
            }))
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
            : Container());
  }

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = ["Available", "On Going", "Sold Out"];
    return ddl
        .map((value) => DropdownMenuItem(
              value: value,
              child: SizedBox(
                width: 55,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ))
        .toList();
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      get_salepostlist();

      // get_data();
    }
  }

  get_salepostlist() async {
    salePostList = GetSalePostList();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getsale_PostList(
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString(),
        '20',
        offset.toString(),
        _pref.getString('user_id').toString());

    print(res);
    if (res['status'] == 1) {
      salePostList = GetSalePostList.fromJson(res);
      print('hellooooo');
      resultList = salePostList.result;

      print(resultList![0].postColor);
      if (res['result'] != null) {
        jsonarray = res['result'];
        print(res['result']);
        //   List<Result>? results = res['result'];
        //   print(results);

        for (var data in jsonarray) {
          homepost.Result record = homepost.Result(
              postName: data['PostName'],
              categoryName: data['CategoryName'],
              productGrade: data['ProductGrade'],
              currency: data['Currency'],
              productPrice: data['ProductPrice'],
              state: data['State'],
              country: data['Country'],
              postType: data['PostType'],
              isPaidPost: data['is_paid_post'],
              productId: data['productId'],
              productType: data['ProductType'],
              unit: data['Unit'],
              postQuntity: data['PostQuntity'],
              productStatus: data['product_status'],
              /*postColor: data['PostColor'],*/
              mainproductImage: data['mainproductImage']);

          color_array = data['PostColor'];
          if (color_array != null) {
            for (var data in color_array) {
              homepost.PostColor record = homepost.PostColor(
                  colorName: data['colorName'], haxCode: data['HaxCode']);
              print(record.haxCode);
              colors.add(record);
            }

            print(colors);
            print(colors.length);
          }
          salepostlist_data.add(record);
        }

        print(color_array);

        isload = true;
        print(salepostlist_data);
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

  set_prod_status(String prod_id, String prod_status) async {
    common_par gethomepost = common_par();

    var res = await save_prostatus(prod_id, prod_status);
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      // Fluttertoast.showToast(msg: res['message']);
      gethomepost = common_par.fromJson(res);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }

  set_pushnotification(String prod_id) async {
    common_par gethomepost = common_par();

    var res = await push_notification(prod_id);
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      Fluttertoast.showToast(msg: res['message']);
      gethomepost = common_par.fromJson(res);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }

  delete_salepost(String prod_id, int index) async {
    common_par gethomepost = common_par();

    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await deletesalepost(
        prod_id,
        _pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      gethomepost = common_par.fromJson(res);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonarray;
  }

  Future<bool> delete_confirm(
    BuildContext context,
    String prod_id,
    int index,
  ) async {
    bool exitapp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Delete Post'),
              content:
                  const Text('Are you sure you want to delete this post ?'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: 'Product Delete Successfully');
                      salepostlist_data.removeAt(index);
                      setState(() {});
                      delete_salepost(prod_id, index);
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Yes')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No')),
              ]);
        });
    return exitapp ?? false;
  }

  /* list_view(int index) {

     String colorString;
     int j=0;
     colorString=resultList![index].postColor![j].haxCode.toString();


     String newStr = colorString.substring(1);

     Color color = Color(
         int.parse(newStr, radix: 16))
         .withOpacity(1.0);

     return Row(
       children: [
        for(int i=0;i<resultList![index].postColor!.length;i++)
          Container(

              child: newStr == 'ffffff' ?
              Icon(Icons.circle_outlined, size: 15)
                  : Icon(Icons.circle_rounded, size: 15,
                  color: color)
          ),



       ],
     );
            }*/
}
