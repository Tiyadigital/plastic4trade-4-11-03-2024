// ignore_for_file: camel_case_types

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

class BussinessPro_dialog extends StatefulWidget {
  const BussinessPro_dialog({Key? key}) : super(key: key);

  @override
  State<BussinessPro_dialog> createState() => _BussinessPro_dialogState();
}

class _BussinessPro_dialogState extends State<BussinessPro_dialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 15, top: 15),
              child: const Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.clear),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Image(
            image: const AssetImage('assets/bussines_profile.png'),
            height: MediaQuery.of(context).size.height / 5.8,
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox(
            height: 30,
          ),
          Text('Register Now! \n Grow your Business',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf')
                  .copyWith(fontSize: 23)),
          const SizedBox(
            height: 20,
          ),
          Text(
              'Please Add your Business Profile \n  to Grow Your Plastic Business Globally  \n and Connect with Buyers & Suppliers Worldwide.',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'assets/fonst/Metropolis-Black.otf',
                      color: Color.fromARGB(255, 0, 91, 148))
                  .copyWith(fontSize: 14)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                height: 55,
                margin: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(50.0),
                    color: const Color.fromARGB(255, 0, 91, 148)),
                child: TextButton(
                  onPressed: () {
                    getBussinessProfile();
                    if (constanst.isprofile) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register2(),
                          ));
                    } else {
                      if (constanst.redirectpage == "sale_buy") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Buyer_sell_detail(
                                      prod_id: constanst.productId,
                                      post_type: constanst.post_type,
                                    )));
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Buyer_sell_detail(
                                      prod_id: constanst.productId,
                                      post_type: constanst.post_type,
                                    )));
                      } else if (constanst.redirectpage == "add_post") {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const AddPost()));
                      } else if (constanst.redirectpage == "chat") {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const Chat()));
                      } else if (constanst.redirectpage == "live_price") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LivepriceScreen()));
                      } else if (constanst.redirectpage ==
                          "Manage_Sell_Posts") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const managesellpost(Title: 'Manage Sell Posts'),
                            ));
                      } else if (constanst.redirectpage == "Manage_Buy_Posts") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const managebuypost(Title: 'Manage Buy Posts'),
                            ));
                      } else if (constanst.redirectpage == "update_category") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UpdateCategoryScreen(),
                            ));
                      } else if (constanst.redirectpage == "edit_profile") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Bussinessinfo(),
                            ));
                      }
                    }
                  },
                  child: const Text('Proceed',
                      style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'assets/fonst/Metropolis-Black.otf')),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  getBussinessProfile() async {
    GetmybusinessprofileController bt = GetmybusinessprofileController();
    SharedPreferences pref = await SharedPreferences.getInstance();
    constanst.getmyprofile = bt.Getmybusiness_profile(
        pref.getString('user_id').toString(),
        pref.getString('api_token').toString());
  }
}