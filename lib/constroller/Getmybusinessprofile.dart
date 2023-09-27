import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/model/GetCategory.dart';
import 'package:Plastic4trade/utill/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_interface.dart';

import '../model/GetBusinessType.dart';
import 'package:Plastic4trade/model/Getmybusinessprofile.dart' as profile;

import '../model/Getmybusinessprofile.dart';

class GetmybusinessprofileController {
  profile.Getmybusinessprofile buss = new profile.Getmybusinessprofile();

  Future<profile.Getmybusinessprofile?> Getmybusiness_profile(
      String user_id, String api_token) async {
    // Getmybusinessprofile getmyprofile = Getmybusinessprofile();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var res = await getbussinessprofile(
      user_id,
      api_token,
    );

    print(res);
    if (res['status'] == 1) {
      buss = Getmybusinessprofile.fromJson(res);
      if(buss.user?.imageUrl!=null){
        _pref.setString('userImage',buss.user!.imageUrl.toString()).toString();
        constanst.image_url=_pref.getString('userImage').toString();
      }else{
        constanst.image_url=null;
      }
      if (buss.profile == null) {
        print('ppppp ${buss.profile}');
        constanst.isprofile = true;
        print(constanst.isprofile);
      }
      if (buss.user!.categoryId == null) {
        print(buss.user!.categoryId);
        constanst.iscategory = true;
        print(constanst.iscategory);
      }
      if (buss.user!.typeId == null) {
        constanst.istype = true;
        print(constanst.istype);
      }
      if (buss.user!.gradeId == null) {
        constanst.isgrade = true;
        print(constanst.isgrade);
      }
    } else {}
    constanst.step = buss.user!.stepCounter!;
    if (constanst.appopencount == 1) {
      if (!constanst.isgrade &&
          !constanst.istype &&
          !constanst.iscategory &&
          !constanst.isprofile &&
          constanst.step == 11) {
        // constanst.appopencount1 = 6;
      }

    }
    return buss;
  }
}
