// ignore_for_file: non_constant_identifier_names

import 'package:Plastic4trade/utill/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_interface.dart';

import 'package:Plastic4trade/model/Getmybusinessprofile.dart' as profile;

import '../model/Getmybusinessprofile.dart';

class GetmybusinessprofileController {
  profile.Getmybusinessprofile buss = profile.Getmybusinessprofile();

  Future<profile.Getmybusinessprofile?> Getmybusiness_profile(
      String userId, String apiToken) async {
    // Getmybusinessprofile getmyprofile = Getmybusinessprofile();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var res = await getbussinessprofile(
      userId,
      apiToken,
    );

    if (res['status'] == 1) {
      buss = Getmybusinessprofile.fromJson(res);
      if(buss.user?.imageUrl!=null){
        pref.setString('userImage',buss.user!.imageUrl.toString()).toString();
        constanst.image_url=pref.getString('userImage').toString();
      }else{
        constanst.image_url=null;
      }
      if (buss.profile == null) {
        constanst.isprofile = true;
      }
      if (buss.user!.categoryId == null) {
        constanst.iscategory = true;
      }
      if (buss.user!.typeId == null) {
        constanst.istype = true;
      }
      if (buss.user!.gradeId == null) {
        constanst.isgrade = true;
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
