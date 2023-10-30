// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:fluttertoast/fluttertoast.dart';

import '../api/api_interface.dart';


class GetUnitController {

  Future<List<String>> setunit() async {

    var res = await getUnit();
    var jsonArray;
    if (res['status'] == 1) {

      jsonArray = res['result'][0]['Unit'].cast<String>();




  }else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonArray;
  }
}