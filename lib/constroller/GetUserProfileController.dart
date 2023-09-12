import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/model/GetCategory.dart';

import '../api/api_interface.dart';
import 'package:Plastic4trade/model/getUserProfile.dart' as user;

import '../model/getUserProfile.dart';

class GetUserProfileController {
 // List<user.User> buss = <user.User>[];
  user.User? record;

  Future<user.User?> getUser_profile( String user_id,String user_token) async {
     getUserProfile getprofile = getUserProfile();

    var res = await getuser_Profile(user_id,user_token);

    print(res);
    if (res['status'] == 1) {
      getprofile = getUserProfile.fromJson(res);

      var jsonarray = res['user'];


      print(jsonarray);
     // for (var data in jsonarray) {

        user.User record = user.User(
         countryCode: jsonarray['countryCode'],
          phoneno: jsonarray['phoneno'],
          email: jsonarray['email'],
          password:jsonarray['password'],
          imageUrl: jsonarray['image_url']


        );

       // buss.add(record);
     // }


    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    return record;
  }
}
