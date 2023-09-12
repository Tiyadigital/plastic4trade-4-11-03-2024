import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Plastic4trade/constroller/GetBussinessTypeController.dart';
import 'package:Plastic4trade/constroller/GetCategoryTypeController.dart';
import 'package:Plastic4trade/screen/BussinessProfile.dart';
import 'package:Plastic4trade/screen/GradeScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/utill/constant.dart';
import 'package:Plastic4trade/model/GetCategoryType.dart' as type;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_interface.dart';
import '../model/common.dart';
import 'GradeUpdate.dart';

class Type_update extends StatefulWidget {
  const Type_update({Key? key}) : super(key: key);

  @override
  State<Type_update> createState() => _Type_updateState();
}

class _Type_updateState extends State<Type_update> {

  bool category3 = false;
  String  type_id='';
  bool? _isloading;
  bool _isloading1= false;
  BuildContext? dialogContext;
  @override
  void initState()  {


    super.initState();


    print('init');
    checknetwork();
  }
  void get_data() async {
    GetCategoryTypeController b_type = await GetCategoryTypeController();
    constanst.cat_typedata = b_type.setType();
    _isloading=true;
    constanst.cat_typedata!.then((value) {

      if(value!=null) {
        for (var item in value) {
          constanst.cat_type_data.add(item);
        }
      }
      _isloading=false;
      setState(() {});
    });
    //


  }

  getProfiless() async{
    common_par common = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(_pref.getString('user_id').toString());

    var res = await getbussinessprofile(_pref.getString('user_id').toString(),
      _pref.getString('api_token').toString(),);


    print(res);
    if (res['status'] == 1) {

      constanst.select_type_id=res['user']['type_id'];




      print('mytype');
      constanst.select_typeId = constanst.select_type_id.split(",");
      print(constanst.select_type_id);
      /* String myString = res['profile']['business_type'];

      List<String> stringList = myString.split(",");
      print(stringList);
      for(int i=0;i<stringList.length;i++){
        findcartItem(stringList[i].toString());
      }
      */
      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen(0)));*/
    } else {
      Fluttertoast.showToast(msg: res['message']);
      // Fluttertoast.showToast(msg: res['message']);
    }

    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return initwidget(context);
  }
  Widget initwidget(BuildContext context) {
    print(_isloading);
    setState(() {
      print(constanst.cat_type_data);
      if(constanst.cat_type_data.isEmpty){
        _isloading=true;
        print(_isloading);
      }
      for (int i = 0; i < constanst.cat_type_data.length; i++) {
        constanst.itemsCheck.add(Icons.circle_outlined);
      }
    });
    return Scaffold(

      resizeToAvoidBottomInset: true,

      body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            // height: MediaQuery.of(context).size.height,

              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                SafeArea(
                  top: true,
                  left: true,
                  right: true,

                  maintainBottomViewPadding: true,
                  child: _isloading==true?
                      Center(
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
                  :Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Image.asset('assets/back.png',
                                height: 50, width: 60),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),

                          Center(
                              child: Text('Type',style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')?.copyWith(fontSize: 20.0),)
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width /4.6,
                            height: 37,
                            margin: EdgeInsets.only(right: 10.0),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color.fromARGB(255, 0, 91, 148)),
                            child: TextButton(
                              onPressed: () {

                                // if (_formKey.currentState!.validate()) {
                                //   Fluttertoast.showToast(
                                //       msg: "Data Proccess");
                                //   vaild_data();
                                // }
                                // setState(() {});
                                /* Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Type()));*/
                                setState(() {
                                  /* if(!category3){
                              Fluttertoast.showToast(msg: 'Select yor category');
                            }else {*/
                                  constanst.itemsCheck.clear();
                                  _onLoading();
                                  setType().then((value) {
                                    print('12346 $value');
                                    Navigator.of(dialogContext!).pop();
                                    if(value){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Grade_update()));
                                    }else{
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Grade_update()));
                                    }

                                  });

                                  // }
                                });
                              },
                              child: Text('Continue',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontFamily:
                                      'assets\fonst\Metropolis-Black.otf')),
                            ),
                          ),


                        ]),



                    Padding(
                      padding: EdgeInsets.fromLTRB(27.0, 5.0, 5.0, 5.0),
                      child:  Align(
                        alignment: Alignment.topLeft,
                        child: Text('Select Your Type',style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf')?.copyWith(fontWeight:FontWeight.w400 ),),),),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: constanst.cat_type_data.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          type.Result record = constanst.cat_type_data[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                constanst.select_type_idx = index;

                                constanst.select_type_idx = index;
                                if (!constanst.select_typeId
                                    .contains(record.producttypeId.toString())) {
                                  constanst.itemsCheck[index] =
                                      Icons.check_circle_outline;


                                  constanst.select_typeId
                                      .add(record.producttypeId.toString());


                                  constanst.select_type_id =
                                      constanst.select_typeId.join(",");

                                  print(constanst.select_type_id);

                                  setState(() {});
                                  // print(constanst.colorsitemsCheck[index]==Icons.check_circle);
                                } else {
                                  constanst.itemsCheck[index] =
                                      Icons.check_circle_outline;


                                  constanst.select_typeId
                                      .remove(record.producttypeId.toString());


                                  constanst.select_type_id =
                                      constanst.select_typeId.join(",");

                                  print(constanst.select_type_id);

                                  setState(() {});
                                }
                              });
                            },
                            child: SizedBox(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Card(
                                        color: Colors.white,
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(10.0))),
                                        margin: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 5.0),
                                        child: Column(children: [

                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(children: [
                                              GestureDetector(
                                                  child: IconButton(
                                                    icon: constanst.select_typeId.contains(record.producttypeId.toString())
                                                        ? Icon(
                                                        Icons
                                                            .check_circle,
                                                        color: Colors
                                                            .green
                                                            .shade600):Icon(
                                                        Icons
                                                            .circle_outlined,
                                                        color: Colors
                                                            .black45),

                                                    onPressed: () {
                                                      setState(() {
                                                        constanst.select_type_idx = index;

                                                        constanst.select_type_idx = index;
                                                        if (!constanst.select_typeId
                                                            .contains(record.producttypeId.toString())) {
                                                          constanst.itemsCheck[index] =
                                                              Icons.check_circle_outline;


                                                          constanst.select_typeId
                                                              .add(record.producttypeId.toString());


                                                          constanst.select_type_id =
                                                              constanst.select_typeId.join(",");

                                                          print(constanst.select_type_id);

                                                          setState(() {});
                                                          // print(constanst.colorsitemsCheck[index]==Icons.check_circle);
                                                        } else {
                                                          constanst.itemsCheck[index] =
                                                              Icons.check_circle_outline;


                                                          constanst.select_typeId
                                                              .remove(record.producttypeId.toString());


                                                          constanst.select_type_id =
                                                              constanst.select_typeId.join(",");

                                                          print(constanst.select_type_id);

                                                          setState(() {});
                                                        }
                                                      });
                                                    },
                                                  )),
                                              Text(record.productType.toString(),
                                                  style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500,fontFamily: 'assets\fonst\Metropolis-Black.otf',color: Colors.black)
                                                      ?.copyWith(fontSize: 17))
                                            ]),
                                          ),
                                        ])))),
                          );
                        }),
                    Container(
                      width: MediaQuery.of(context).size.width * 1.2,
                      height: 60,
                      margin: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(50.0),
                          color: Color.fromARGB(255, 0, 91, 148)),
                      child: TextButton(
                        onPressed: () {

                          // if (_formKey.currentState!.validate()) {
                          //   Fluttertoast.showToast(
                          //       msg: "Data Proccess");
                          //   vaild_data();
                          // }
                          // setState(() {});
                          /* Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Type()));*/
                          setState(() {
                           /* if(!category3){
                              Fluttertoast.showToast(msg: 'Select yor category');
                            }else {*/
                              constanst.itemsCheck.clear();
                              _onLoading();
                              setType().then((value) {
                                print('12346 $value');
                                Navigator.of(dialogContext!).pop();
                                if(value){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Grade_update()));
                                }else{
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Grade_update()));
                                }

                              });

                           // }
                          });
                        },
                        child: Text('Continue',
                            style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontFamily:
                                'assets\fonst\Metropolis-Black.otf')),
                      ),
                    ),

                  ]),
                ),



              ]))
      ),

      );

  }
  void _onLoading() {
    dialogContext=context;

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

            ));
      },
    );

    /*Future.delayed(const Duration(seconds: 5), () {
      print('exit');
      Navigator.of(dialogContext!).pop(); // Use dialogContext to close the dialog
      print('exit1'); // Dialog closed
    });*/
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    constanst.itemsCheck.clear();
  }
  Future<bool> setType() async {

    common_par  common  = common_par();
    SharedPreferences _pref = await SharedPreferences.getInstance();

    print(constanst.select_type_id);
    var res = await addProducttype(_pref.getString('user_id').toString(),_pref.getString('api_token').toString(),constanst.select_type_id,'7');

    print(_pref.getString('user_id').toString());
    print(_pref.getString('api_token').toString());

    String? msg = res['message'];
    Fluttertoast.showToast(msg: "$msg");
    if (res['status'] == 1) {

      Fluttertoast.showToast(msg: res['message']);
      clear_data();
      _isloading1=true;
    } else {
      _isloading1=true;
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {});
    return  _isloading1;
  }

  checknetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      constanst.catdata.clear();
      _isloading=false;
      Fluttertoast.showToast(msg: 'Internet Connection not available');
    } else {
      clear_data();
      getProfiless();
      get_data();

    }

  }
  clear_data(){
    constanst.select_typeId.clear();
    constanst.select_type_id="";
    constanst.select_type_idx=0;
    constanst.itemsCheck.clear();
    constanst.cat_type_data.clear();
  }
}
