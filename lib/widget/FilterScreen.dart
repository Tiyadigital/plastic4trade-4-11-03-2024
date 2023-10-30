import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:Plastic4trade/screen/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Plastic4trade/model/Getfilterdata.dart' as filter;
import '../api/api_interface.dart';
import '../model/Getfilterdata.dart';
import '../screen/CategoryScreen.dart';
import '../screen/ExhibitorScreen.dart';
import '../utill/constant.dart';


class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  int? _radioValue = 0;
  int? _managerValue = 0;
  String? assignedName;
  bool gender = false;
  bool? iscategory,istype,isgrade,isbussiness_type,ispost_type,islocation,isload;
  String category_id = '',grade_id='',type_id='',bussinesstype='',post_type='';
  List<filter.Category> category_data= [];
  List<filter.Businesstype> bussines_data= [];
  List<filter.Producttype> product_type= [];
  List<filter.Productgrade> product_grade= [];
  List<RadioModel> sampleData1 = <RadioModel>[];
  String googleApikey = "AIzaSyCyqsD3OPUWGJ5AWbN3iKbUzQGs3Q-ZlPE";
  List<String> select_categotyId=[];
  String? location, search;


  Color _color1 = Colors.black;
  Color _color2 = Colors.black;
  Color _color3 = Colors.black;
  Color _color4 = Colors.black;
  Color _color5 = Colors.black;
  Color _color6 = Colors.black;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleData1.add(new RadioModel(false, 'Buy Post'));
    sampleData1.add(new RadioModel(
      false,
      'Sell Post',
    ));
    checknetowork();
  }

  Future<void> checknetowork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: 'Internet Connection not available');
      //isprofile=true;
    } else {
      clear();
      get_Filterdata();

      // get_data();
    }
  }

  clear(){
    category_data.clear();
    product_type.clear();
    product_grade.clear();
    bussines_data.clear();
    constanst.category_itemsCheck.clear();
    constanst.Type_itemsCheck.clear();
    constanst.Grade_itemsCheck.clear();
    constanst.bussiness_type_itemsCheck.clear();

  }
  get_Filterdata() async {
    Getfilterdata getfilter = Getfilterdata();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    var res = await getfilterdata();
    var jsonarray;
    print(res);
    if (res['status'] == 1) {
      getfilter = Getfilterdata.fromJson(res);

      for (var item in res['category']) {
        category_data.add(Category.fromJson(item));
      }

      for (var item in res['producttype']) {
        product_type.add(Producttype.fromJson(item));
      }

      for (var item in res['businesstype']) {
        bussines_data.add(Businesstype.fromJson(item));
      }

      for (var item in res['productgrade']) {
        product_grade.add(Productgrade.fromJson(item));
      }

      for (int i = 0; i < category_data.length; i++) {
        constanst.category_itemsCheck.add(Icons.circle_outlined);
      }

      for (int i = 0; i < product_type.length; i++) {
        constanst.Type_itemsCheck.add(Icons.circle_outlined);
      }

      for (int i = 0; i < product_grade.length; i++) {
        constanst.Grade_itemsCheck.add(Icons.circle_outlined);
      }

      for (int i = 0; i < bussines_data.length; i++) {
        constanst.bussiness_type_itemsCheck.add(Icons.circle_outlined);
      }
      isload=true;
      //category_data=res['category'];
    
      
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;

  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 5),
            Image.asset(
              'assets/hori_line.png',
              width: 150,
              height: 5,
            ),
            SizedBox(height: 12),
            Center(
              child: Text('Filter',
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'assets\fonst\Metropolis-Black.otf')),
            ),
            SizedBox(height: 5),
            //-------CircularCheckBox()
            Divider(color: Colors.grey),
            IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.35,

                      alignment: Alignment.center,
                      child: ScreenA()),
                  Container(
                    width: MediaQuery.of(context).size.width / 60,
                    child: VerticalDivider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.60,
                    height: MediaQuery.of(context).size.height/1.50,
                    //color: Colors.blue,
                    //alignment: Alignment.center,
                    child: isload==true?ScreenB():Container()




                    ),

                ],
              ),
            ),

            Divider(color: Colors.grey),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  height: 60,
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.symmetric(horizontal:20,vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1,color: Color.fromARGB(255, 0, 91, 148)),
                      borderRadius: BorderRadius.circular(50.0),
                     // color: Color.fromARGB(255, 0, 91, 148)
                    ),
                  child: TextButton(
                    onPressed: () {
                      constanst.select_categotyId.clear();
                      constanst.select_typeId.clear();
                      constanst.select_gradeId.clear();
                      constanst.selectbusstype_id.clear();
                      constanst.select_categotyType.clear();
                      constanst.lat="";
                      constanst.log="";
                      constanst.location="";
                        Navigator.pop(context);


                    },
                    child: Text('Cancel',
                        style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w800,
                            color: Color.fromARGB(255, 0, 91, 148),
                            fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  height: 60,
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(50.0),
                      color: Color.fromARGB(255, 0, 91, 148)
                  ),
                  child: TextButton(
                    onPressed: () {

                        Navigator.pop(context);
                        /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Exhibitor()));*/



                    },
                    child: Text('Apply',
                        style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'assets\fonst\Metropolis-Black.otf')),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget ScreenA() {
    return Column(children: [
      SizedBox(
        height: 50,
        child:
            Align(child: TextButton(onPressed: () {
              iscategory=true;istype=false;isgrade=false;isbussiness_type=false;ispost_type=false;islocation=false;
              _color1=Color.fromARGB(255, 0, 91, 148);
               _color2 = Colors.black;
               _color3 = Colors.black;
               _color4 = Colors.black;
               _color5 = Colors.black;
               _color6 = Colors.black;
              setState(() {});
            }, child: Text('Category',style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf').copyWith(fontWeight: FontWeight.w500,color:_color1),))),
      ),
      Divider(color: Colors.grey),
      SizedBox(
        height: 50,
        child:
        Align(child: TextButton(onPressed: () {
          iscategory=false;istype=true;isgrade=false;isbussiness_type=false;ispost_type=false;islocation=false;
          _color2=Color.fromARGB(255, 0, 91, 148);
          _color1 = Colors.black;
          _color3 = Colors.black;
          _color4 = Colors.black;
          _color5 = Colors.black;
          _color6 = Colors.black;
          setState(() {});
        }, child: Text('Type',style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf').copyWith(fontWeight: FontWeight.w500,color:_color2),))),
      ),
      Divider(color: Colors.grey),
      SizedBox(
        height: 50,
        child:
        Align(child: TextButton(onPressed: () {
          iscategory=false;istype=false;isgrade=true;isbussiness_type=false;ispost_type=false;islocation=false;
          _color3=Color.fromARGB(255, 0, 91, 148);
          _color1 = Colors.black;
          _color2 = Colors.black;
          _color4 = Colors.black;
          _color5 = Colors.black;
          _color6 = Colors.black;
          setState(() {});
        }, child: Text('Grade',style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf').copyWith(fontWeight: FontWeight.w500,color:_color3),))),
      ),
      Divider(color: Colors.grey),
      SizedBox(
        height: 50,
        child:
        Align(child: TextButton(onPressed: () {
          iscategory=false;istype=false;isgrade=false;isbussiness_type=true;ispost_type=false;islocation=false;
          _color4=Color.fromARGB(255, 0, 91, 148);
          _color1 = Colors.black;
          _color2 = Colors.black;
          _color3 = Colors.black;
          _color5 = Colors.black;
          _color6 = Colors.black;
          setState(() {});
        }, child: Text('Business Type',style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf').copyWith(fontWeight: FontWeight.w500,color:_color4),))),
      ),
      Divider(color: Colors.grey),
      SizedBox(
        height: 50,
        child:
        Align(child: TextButton(onPressed: () {
          iscategory=false;istype=false;isgrade=false;isbussiness_type=false;ispost_type=true;islocation=false;
          _color5=Color.fromARGB(255, 0, 91, 148);
          _color1 = Colors.black;
          _color2 = Colors.black;
          _color3 = Colors.black;
          _color4 = Colors.black;
          _color6 = Colors.black;
          setState(() {});
        }, child: Text('Post Type',style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf').copyWith(fontWeight: FontWeight.w500,color:_color5),))),
      ),
      Divider(color: Colors.grey),
      SizedBox(
        height: 50,
        child:
        Align(child: TextButton(onPressed: () {
          iscategory=false;istype=false;isgrade=false;isbussiness_type=false;ispost_type=false;islocation=true;
          _color6=Color.fromARGB(255, 0, 91, 148);
          _color1 = Colors.black;
          _color2 = Colors.black;
          _color4 = Colors.black;
          _color5 = Colors.black;
          _color3 = Colors.black;
          setState(() {});
        }, child: GestureDetector(child: Text('Location',style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf').copyWith(fontWeight: FontWeight.w500,color:_color6),),
                                 onTap: () {
                                   search_location();
                                 }, ))),
      ),
      Divider(color: Colors.grey),
      SizedBox(
        height: MediaQuery.of(context).size.height/6.5,
      )
    ]);
  }
  Widget ScreenB() {
    return SizedBox(

      child:iscategory==true?category():istype==true?type():isgrade==true?grade():isbussiness_type==true?bussiness_type():ispost_type==true?posttype():Container()
    );
  }

  Widget category(){
    return  ListView.builder(
        shrinkWrap: true,
        itemCount: category_data.length,
        // physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          filter.Category category =category_data[index];
          return GestureDetector(
            onTap: () {
              gender=true;
              if (constanst.category_itemsCheck[index] == Icons.circle_outlined) {
                if( constanst.select_categotyId.length<=2) {
                  constanst.category_itemsCheck[index] =
                      Icons.check_circle_outline;

                  category_id =
                      category
                          .id
                          .toString();
                  constanst
                      .select_categotyId
                      .add(
                      category_id);
                  setState(() {});
                  //print('sdrsr $category_id');
                  print(constanst.select_categotyId);
                } else {
                  Fluttertoast.showToast(msg: 'You Can Select Maximum 3 Category');
                }
              } else {
                constanst.category_itemsCheck[index] =
                    Icons.circle_outlined;
                category_id =
                    category
                        .id
                        .toString();
                constanst
                    .select_categotyId
                    .remove(
                    category_id);
                print('remove $category_id');
                print(constanst.select_categotyId);
                setState(() {});
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width*4.0,
              decoration: BoxDecoration(
                color: Colors.transparent
              ),
              child:
                  Row(
                    children: [
                      IconButton(
                          icon: constanst.category_itemsCheck[index] == Icons.circle_outlined
                              ? Icon(Icons.circle_outlined,
                              color: Colors.black45)
                              : Icon(Icons.check_circle,
                              color: Colors.green.shade600),
                          onPressed: () {
                            //setState(() {
                              gender=true;
                              if (constanst.category_itemsCheck[index] == Icons.circle_outlined) {
                               if( constanst.select_categotyId.length<=2) {
                                 constanst.category_itemsCheck[index] =
                                     Icons.check_circle_outline;

                                 category_id =
                                     category
                                         .id
                                         .toString();
                                 constanst
                                     .select_categotyId
                                     .add(
                                     category_id);
                                 setState(() {});
                                 //print('sdrsr $category_id');
                                 print(constanst.select_categotyId);
                               } else {
                                 Fluttertoast.showToast(msg: 'You Can Select Maximum 3 Category');
                               }
                              } else {
                                constanst.category_itemsCheck[index] =
                                    Icons.circle_outlined;
                                category_id =
                                    category
                                        .id
                                        .toString();
                                constanst
                                    .select_categotyId
                                    .remove(
                                    category_id);
                                print('remove $category_id');
                                print(constanst.select_categotyId);
                                setState(() {});
                              }
                           //});
                          }),
                      Text(category.categoryName.toString(),
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),

            ),
          );
        });
  }

  Widget type(){
    return   ListView.builder(
        shrinkWrap: true,
        itemCount: product_type.length,
        // physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          filter.Producttype category =product_type[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                gender=true;
                if (constanst.Type_itemsCheck[index] == Icons.circle_outlined) {
                  if( constanst.select_typeId.length<=2) {
                    constanst.Type_itemsCheck[index] = Icons.check_circle_outline;
                    type_id =
                        category
                            .id
                            .toString();
                    constanst
                        .select_typeId
                        .add(
                        type_id);
                    setState(() {});
                  }else {
                    Fluttertoast.showToast(msg: 'You Can Select Maximum 3 Type');
                  }
                } else {
                  constanst.Type_itemsCheck[index] =
                      Icons.circle_outlined;
                  type_id =
                      category
                          .id
                          .toString();
                  constanst
                      .select_typeId
                      .remove(
                      type_id);
                }
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width*4.0,
              decoration: BoxDecoration(
                  color: Colors.transparent
              ),
              child:
              Row(
                children: [
                  IconButton(
                      icon: constanst.Type_itemsCheck[index] == Icons.circle_outlined
                          ? Icon(Icons.circle_outlined,
                          color: Colors.black45)
                          : Icon(Icons.check_circle,
                          color: Colors.green.shade600),
                      onPressed: () {
                        setState(() {
                          gender=true;
                          if (constanst.Type_itemsCheck[index] == Icons.circle_outlined) {
            if( constanst.select_typeId.length<=2) {
              constanst.Type_itemsCheck[index] = Icons.check_circle_outline;
              type_id =
                  category
                      .id
                      .toString();
              constanst
                  .select_typeId
                  .add(
                  type_id);
              setState(() {});
            }else {
              Fluttertoast.showToast(msg: 'You Can Select Maximum 3 Type');
            }
                          } else {
                            constanst.Type_itemsCheck[index] =
                                Icons.circle_outlined;
                            type_id =
                                category
                                    .id
                                    .toString();
                            constanst
                                .select_typeId
                                .remove(
                                type_id);
                          }
                        });
                      }),
                  Text(category.productType.toString(),
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: 'assets\fonst\Metropolis-Black.otf'
                         ),
                      softWrap: false,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),

            ),
          );
        });;
  }

  Widget grade(){
    return   ListView.builder(
        shrinkWrap: true,
        itemCount: product_grade.length,
        // physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          filter.Productgrade category =product_grade[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                gender=true;
                if (constanst.Grade_itemsCheck[index] == Icons.circle_outlined) {
                  if(constanst
                      .select_gradeId.length<=2) {
                    constanst.Grade_itemsCheck[index] =
                        Icons.check_circle_outline;
                    grade_id =
                        category
                            .id
                            .toString();
                    constanst
                        .select_gradeId
                        .add(
                        grade_id);
                  }  else {
                    Fluttertoast.showToast(msg: 'You Can Select Maximum 3 Grade');
                  }
                } else {
                  constanst.Grade_itemsCheck[index] =
                      Icons.circle_outlined;
                  grade_id =
                      category
                          .id
                          .toString();
                  constanst
                      .select_gradeId
                      .remove(
                      grade_id);
                }
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width*4.0,
              decoration: BoxDecoration(
                  color: Colors.transparent
              ),
              child:
              Row(
                children: [
                  IconButton(
                      icon: constanst.Grade_itemsCheck[index] == Icons.circle_outlined
                          ? Icon(Icons.circle_outlined,
                          color: Colors.black45)
                          : Icon(Icons.check_circle,
                          color: Colors.green.shade600),
                      onPressed: () {
                        setState(() {
                          gender=true;
                          if (constanst.Grade_itemsCheck[index] == Icons.circle_outlined) {
                            if(constanst
                                .select_gradeId.length<=2) {
                              constanst.Grade_itemsCheck[index] =
                                  Icons.check_circle_outline;
                              grade_id =
                                  category
                                      .id
                                      .toString();
                              constanst
                                  .select_gradeId
                                  .add(
                                  grade_id);
                            }  else {
                              Fluttertoast.showToast(msg: 'You Can Select Maximum 3 Grade');
                            }
                          } else {
                            constanst.Grade_itemsCheck[index] =
                                Icons.circle_outlined;
                            grade_id =
                                category
                                    .id
                                    .toString();
                            constanst
                                .select_gradeId
                                .add(
                                grade_id);
                          }
                        });
                      }),
                  Text(category.productGrade.toString(),
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),

            ),
          );
        });
  }

  Widget bussiness_type(){
    return   ListView.builder(
        shrinkWrap: true,
        itemCount: bussines_data.length,
        // physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          filter.Businesstype category =bussines_data[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                gender=true;
                if (constanst.bussiness_type_itemsCheck[index] == Icons.circle_outlined) {
                  if( constanst
                      .selectbusstype_id.length<=2) {
                    constanst.bussiness_type_itemsCheck[index] =
                        Icons.check_circle_outline;
                    bussinesstype =
                        category
                            .id
                            .toString();
                    constanst
                        .selectbusstype_id
                        .add(
                        bussinesstype);
                    setState(() {});
                  }
                  else {
                    Fluttertoast.showToast(msg: 'You Can Select Maximum 3 Bussiness Type');
                  }
                } else {
                  constanst.bussiness_type_itemsCheck[index] =
                      Icons.circle_outlined;
                  bussinesstype =
                      category
                          .id
                          .toString();
                  constanst
                      .selectbusstype_id
                      .remove(
                      bussinesstype);
                  setState(() {});
                }
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width*4.0,
              decoration: BoxDecoration(
                  color: Colors.transparent
              ),
              child: Row(
                children: [
                  IconButton(
                      icon: constanst.bussiness_type_itemsCheck[index] == Icons.circle_outlined
                          ? Icon(Icons.circle_outlined,
                          color: Colors.black45)
                          : Icon(Icons.check_circle,
                          color: Colors.green.shade600),
                      onPressed: () {
                        setState(() {
                          gender=true;
                          if (constanst.bussiness_type_itemsCheck[index] == Icons.circle_outlined) {
                            if( constanst
                                .selectbusstype_id.length<=2) {
                              constanst.bussiness_type_itemsCheck[index] =
                                  Icons.check_circle_outline;
                              bussinesstype =
                                  category
                                      .id
                                      .toString();
                              constanst
                                  .selectbusstype_id
                                  .add(
                                  bussinesstype);
                              setState(() {});
                            }
                          else {
                            Fluttertoast.showToast(msg: 'You Can Select Maximum 3 Bussiness Type');
                          }
                          } else {
                            constanst.bussiness_type_itemsCheck[index] =
                                Icons.circle_outlined;
                            bussinesstype =
                                category
                                    .id
                                    .toString();
                            constanst
                                .selectbusstype_id
                                .remove(
                                bussinesstype);
                            setState(() {});
                          }
                        });
                      }),
                  Text(category.businessType.toString(),
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontFamily: 'assets\fonst\Metropolis-Black.otf'),
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          );
        });
  }

  Widget posttype(){
    return Padding(
        padding: EdgeInsets.only(left: 0.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (sampleData1
                      .first.isSelected ==
                      false) {
                    sampleData1.first.isSelected =
                    true;
                    /* sampleData1.last.isSelected =
                                                      false;*/

                    post_type = 'BuyPost';
                    constanst.select_categotyType
                        .add(post_type.toString());
                    print(constanst
                        .select_categotyType);
                  } else {
                    sampleData1.first.isSelected =
                    false;
                    constanst.select_categotyType
                        .remove('BuyPost');
                    print(constanst
                        .select_categotyType);
                  }
                });
              },
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width*4.0,
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    color: Colors.transparent
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      child: Row(children: [
                        sampleData1.first.isSelected == true
                            ? Icon(Icons.check_circle,
                            color:
                            Colors.green.shade600)
                            : Icon(Icons.circle_outlined,
                            color: Colors.black38),
                        SizedBox(width: 10,),
                        Text('Buy Post',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontSize: 17))
                      ]),
                      onTap: () {
                        setState(() {
                          if (sampleData1
                              .first.isSelected ==
                              false) {
                            sampleData1.first.isSelected =
                            true;
                            /* sampleData1.last.isSelected =
                                                        false;*/

                            post_type = 'BuyPost';
                            constanst.select_categotyType
                                .add(post_type.toString());
                            print(constanst
                                .select_categotyType);
                          } else {
                            sampleData1.first.isSelected =
                            false;
                            constanst.select_categotyType
                                .remove('BuyPost');
                            print(constanst
                                .select_categotyType);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: () {
                setState(() {
                  print(sampleData1.last.isSelected);
                  if (sampleData1.last.isSelected ==
                      false) {
                    sampleData1.last.isSelected =
                    true;
                    setState(() {});
                    /* sampleData1.last.isSelected =
                                                      false;*/

                    post_type = 'SellPost';
                    constanst.select_categotyType
                        .add(post_type.toString());
                    print(constanst
                        .select_categotyType);
                  } else {
                    sampleData1.last.isSelected =
                    false;
                    constanst.select_categotyType
                        .remove('SellPost');
                    print(constanst
                        .select_categotyType);
                  }
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width*4.0,
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    color: Colors.transparent
                ),
                /*width: MediaQuery.of(context).size.width /
                    2.0,*/
                height: 30,
                child: GestureDetector(
                  child: Row(children: [
                    sampleData1.last.isSelected == true
                        ? Icon(Icons.check_circle,
                        color: Colors.green.shade600)
                        : Icon(Icons.circle_outlined,
                        color: Colors.black38),
                    SizedBox(width: 10,),
                    Text('Sell Post',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontSize: 17))
                  ]),
                  onTap: () {
                    setState(() {
                      print(sampleData1.last.isSelected);
                      if (sampleData1.last.isSelected ==
                          false) {
                        sampleData1.last.isSelected =
                        true;
                        setState(() {});
                        /* sampleData1.last.isSelected =
                                                      false;*/

                        post_type = 'SellPost';
                        constanst.select_categotyType
                            .add(post_type.toString());
                        print(constanst
                            .select_categotyType);
                      } else {
                        sampleData1.last.isSelected =
                        false;
                        constanst.select_categotyType
                            .remove('SellPost');
                        print(constanst
                            .select_categotyType);
                      }
                    });
                  },
                ),
              ),
            )
          ],
        ));
  }

   search_location() async {
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
     print(constanst.log);

     setState(() {});
     // var newlatlang = LatLng(lat, log);

     //move map camera to selected place with animation
     //mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
   }

  }
}
