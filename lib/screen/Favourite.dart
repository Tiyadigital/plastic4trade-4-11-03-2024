// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/widget/HomeAppbar.dart';
import 'package:Plastic4trade/model/GetFavoriteList.dart' as fav;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';

class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<fav.Result> favlist = [];
  bool isload = false;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    get_fav();
  }

  @override
  Widget build(BuildContext context) {
    return init();
  }

  Widget init() {
    return Scaffold(
      backgroundColor: const Color(0xFFDADADA),
      appBar: CustomeApp('Favourite'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isload == true
                ? fav_list()
                : Platform.isAndroid
                    ? const Center(
                        child: CircularProgressIndicator(
                          value: null,
                          strokeWidth: 2.0,
                          color: Color.fromARGB(255, 0, 91, 148),
                        ),
                      )
                    : Platform.isIOS
                        ? const Center(
                            child: CupertinoActivityIndicator(
                              color: Color.fromARGB(255, 0, 91, 148),
                              radius: 20,
                              animating: true,
                            ),
                          )
                        : Container()
          ],
        ),
      ),
    );
  }

  Widget fav_list() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
        child: FutureBuilder(
            //future: load_category(),
            builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Align(
              alignment: Alignment.center,
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return const Text('Data Not Found ');
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: MediaQuery.of(context).size.height / 1150,
                mainAxisSpacing: 3.0,
                crossAxisCount: 2,
              ),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: favlist.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                fav.Result record = favlist[index];
                return GestureDetector(
                  onTap: (() {}),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(children: [
                      Stack(fit: StackFit.passthrough, children: <Widget>[
                        Container(
                          height: 150,
                          margin: const EdgeInsets.all(5.0),
                          child: Image(
                            errorBuilder: (context, object, trace) {
                              return Container(
                                decoration: const BoxDecoration(
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5.0),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 0, 148, 95),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            // color: Color.fromARGB(0,255, 255, 255),
                            child: Text('₹${record.productPrice}',
                                style: const TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w800,
                                    fontFamily:
                                        'assets/fonst/Metropolis-Black.otf',
                                    color: Colors.white)),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            color: const Color.fromARGB(0, 255, 255, 255),
                            child: Center(
                                child: GestureDetector(
                              child: Image.asset(
                                'assets/fav.png',
                                height: 30,
                                width: 30,
                              ),
                              onTap: () {
                                setState(() {
                                  getremove_product(
                                      record.productId.toString());
                                  favlist.removeAt(index);
                                });
                              },
                            )),
                          ),
                        ),
                      ]),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 10.0),
                                child: Text(record.productName.toString(),
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontFamily:
                                            'assets/fonst/Metropolis-SemiBold.otf'),
                                    softWrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 10.0),
                                child: Text(
                                    '${record.productType} | ${record.productGrade}',
                                    style: const TextStyle(
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
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 10.0),
                                child: Text('${record.state},${record.country}',
                                    style: const TextStyle(
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
    SharedPreferences pref = await SharedPreferences.getInstance();

    var res = await favList(pref.getString('user_id').toString(),
        pref.getString('api_token').toString());

    var jsonArray;
    if (res['status'] == 1) {
      if (res['result'] != null) {
        jsonArray = res['result'];

        for (var data in jsonArray) {
          fav.Result record = fav.Result(
              productName: data['ProductName'],
              categoryName: data['CategoryName'],
              productGrade: data['ProductGrade'],
              currency: data['Currency'],
              productPrice: data['ProductPrice'],
              postType: data['PostType'],
              productType: data['ProductType'],
              country: data['Country'],
              city: data['City'],
              productId: data['productId'],
              mainproductImage: data['mainproductImage'],
              state: data['State'],
          );

          favlist.add(record);
        }
        isload = true;
        if (mounted) {
          setState(() {});
        }
      }
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonArray;
  }

  getremove_product(String prodId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Fluttertoast.showToast(msg: prodId.toString());
    var res = await removefav(
      pref.getString('user_id').toString(),
      pref.getString('api_token').toString(),
      prodId.toString(),
    );
    var jsonArray;

    if (res['status'] == 1) {
      jsonArray = res['result'];
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return jsonArray;
  }
}
