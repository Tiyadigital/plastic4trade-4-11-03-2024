import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Plastic4trade/screen/AddPost.dart';
import 'package:Plastic4trade/screen/GradeScreen.dart';
import 'package:Plastic4trade/screen/Register2.dart';
import 'package:Plastic4trade/screen/Type.dart';
import 'package:Plastic4trade/utill/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constroller/Getmybusinessprofile.dart';
import '../screen/Bussinessinfo.dart';
import '../screen/Buyer_sell_detail.dart';
import '../screen/CategoryScreen.dart';
import '../screen/Chat.dart';
import '../screen/Liveprice.dart';
import '../screen/ManageBuyPost.dart';
import '../screen/ManageSellPost.dart';
import '../screen/updateCategoryScreen.dart';
import 'MainScreen.dart';

class Category_dialog extends StatefulWidget {
  const Category_dialog({Key? key}) : super(key: key);

  @override
  State<Category_dialog> createState() => _BussinessPro_dialogState();
}

class _BussinessPro_dialogState extends State<Category_dialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      elevation: 0,

      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35.0),
      ),
      child :
      Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            margin: EdgeInsets.only(right: 15,top: 15),
            child: Align(
              alignment: Alignment.topRight,
              child: Icon(Icons.clear),
            ),
          ),
        ),
        SizedBox(height: 10,),
        Image(image:AssetImage('assets/bussines_profile.png'),height:MediaQuery.of(context).size.height/5.8,width: MediaQuery.of(context).size.width, ),
        SizedBox(height: 30,),
        Text('Select Interest \n Match Your Products',maxLines: 2,textAlign: TextAlign.center,style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700, color: Colors.black,fontFamily: 'assets\fonst\Metropolis-Black.otf').copyWith(fontSize: 23)),
        SizedBox(height: 20,),
        Text('Please Select your Interest from the \n Category, Type, and Grade to Match your Product Perfectly,  and Get your Interested Product Notification',maxLines: 4,textAlign: TextAlign.center,style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500,fontFamily: 'assets\fonst\Metropolis-Black.otf')?.copyWith(fontSize: 14)),
       /* SizedBox(height: 10,),
        Text('Add Business Profile \n Select your product interests \n Add at least 1 sale post or buy post',maxLines: 3,textAlign: TextAlign.center,style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500,fontFamily: 'assets\fonst\Metropolis-Black.otf')?.copyWith(fontSize: 14,color: Colors.grey,height: 2),),
        SizedBox(height: 10,),*/
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3.5,
              height: 55,
              margin: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Color.fromARGB(255, 0, 91, 148)),
                borderRadius: BorderRadius.circular(50.0),
                // color: Color.fromARGB(255, 0, 91, 148)
              ),
              child: TextButton(
                onPressed: () {
                  constanst.appopencount1=2;
                  Navigator.pop(context);
                  if(constanst.isprofile){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register2(),
                        ));
                  } else{
                    if(constanst.redirectpage=="sale_buy"){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => Buyer_sell_detail(prod_id: constanst.productId,post_type: constanst.post_type,)));
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ));
                      /*Navigator.push(
            context, MaterialPageRoute(builder: (context) => Buyer_sell_detail(prod_id: constanst.productId,post_type: constanst.post_type,)));*/
                    }else if(constanst.redirectpage=="add_post"){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => AddPost()));
                    }else if(constanst.redirectpage=="chat"){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Chat()));
                    }else if(constanst.redirectpage=="live_price"){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => LivepriceScreen()));
                    }else if(constanst.redirectpage=="Manage_Sell_Posts"){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => managesellpost(Title: 'Manage Sell Posts'),
                          ));
                    }else if(constanst.redirectpage=="Manage_Buy_Posts"){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => managebuypost(Title: 'Manage Buy Posts'),
                          ));
                    }else if(constanst.redirectpage=="update_category"){
                     /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateCategoryScreen(),
                          ));*/
                    }else if(constanst.redirectpage=="edit_profile"){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Bussinessinfo(),
                          ));
                    }else if(constanst.redirectpage=="add_cat"){
                     /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryScreen(),
                          ));*/
                     /* Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MainScreen(0),
                          )).then((value) => Navigator.of(context).pop());*/

                     // Navigator.pop(context);
                    }else if(constanst.redirectpage=="add_type"){
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Type(),
                          ));*/
                    /*  Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MainScreen(0),
                          )).then((value) => Navigator.of(context).pop());*/

                    }else if(constanst.redirectpage=="add_grade"){
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Grade(),
                          ));*/
                 /*     Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MainScreen(0),
                          )).then((value) => Navigator.of(context).pop());*/

                    }
                    /*Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => Buyer_sell_detail(prod_id: constanst.productId,post_type: constanst.post_type,)),
                        ModalRoute.withName('/'));*/
                  }


                },
                child: Text('Skip',
                    style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 0, 91, 148),
                        fontFamily: 'assets\fonst\Metropolis-Black.otf')),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3.5,
              height: 55,
              margin: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(50.0),
                  color: Color.fromARGB(255, 0, 91, 148)
              ),
              child: TextButton(
                onPressed: () {
                  constanst.appopencount1=2;
                  Navigator.pop(context);
                  getBussinessProfile();
                  print('bottom');
                  print(constanst.isgrade );
                  print(constanst.isprofile );
                  print(constanst.istype );
                  print(constanst.iscategory);
                  if(constanst.isprofile){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register2(),
                        ));
                  }
                  else if(constanst.iscategory){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryScreen(),
                        ));
                  } else if(constanst.istype){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Type(),
                        ));
                  } else if(constanst.isgrade){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Grade(),
                        ));
                  } /*else if(constanst.redirectpage=="sale_buy"){
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => Buyer_sell_detail(prod_id: constanst.productId,post_type: constanst.post_type,)),
                        ModalRoute.withName('/'));

                  }*/
                  /*else if(constanst.iscategory){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryScreen(),
                        ));
                  }else if(constanst.istype){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Type(),
                        ));
                  }else if(constanst.isgrade){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Grade(),
                        ));
                  }else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPost(),
                        ));
                  }*/

                },
                child: Text('Proceed',
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
    ),);
  }
  getBussinessProfile() async {
    /* Getmybusinessprofile register = Getmybusinessprofile();
    SharedPreferences _pref = await SharedPreferences.getInstance();


    var res = await getbussinessprofile(_pref.getString('user_id').toString(),
      _pref.getString('api_token').toString(),);

    if (res['status'] == 1) {
      register = Getmybusinessprofile.fromJson(res);
      if(register.profile==null){
        constanst.isprofile=true;
      }else if(register.user!.categoryId.isEmpty){
        constanst.iscategory=true;
      }else if(register.user!.typeId.isEmpty){
        constanst.istype=true;
      }else if(register.user!.gradeId.isEmpty){
        constanst.isgrade=true;
      }
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: res['message']);

      setState(() {});
    }*/
    GetmybusinessprofileController bt = await GetmybusinessprofileController();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    constanst.getmyprofile = bt.Getmybusiness_profile(_pref.getString('user_id').toString(),
        _pref.getString('api_token').toString());


    // setState(() {});
    // print(constanst.btype_data);
  }
}
