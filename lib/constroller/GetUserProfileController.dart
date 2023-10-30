// ignore_for_file: non_constant_identifier_names

import 'package:fluttertoast/fluttertoast.dart';

import '../api/api_interface.dart';
import 'package:Plastic4trade/model/getUserProfile.dart' as user;


class GetUserProfileController {
  user.User? record;

  Future<user.User?> getUser_profile( String userId,String userToken) async {

    var res = await getuser_Profile(userId,userToken);

    if (res['status'] == 1) {

      var  jsonArray = res['user'];


     // for (var data in  jsonArray) {

        user.User record = user.User(
         countryCode:  jsonArray['countryCode'],
          phoneno:  jsonArray['phoneno'],
          email:  jsonArray['email'],
          password: jsonArray['password'],
          imageUrl:  jsonArray['image_url']


        );

       // buss.add(record);
     // }


    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    return record;
  }
}
