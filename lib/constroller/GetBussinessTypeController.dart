// ignore_for_file: non_constant_identifier_names

import 'package:fluttertoast/fluttertoast.dart';

import '../api/api_interface.dart';
import 'package:Plastic4trade/model/GetBusinessType.dart' as bt;


class GetBussinessTypeController {
  List<bt.Result> buss = <bt.Result>[];


  Future<List<bt.Result>> getBussiness_Type() async {

    var res = await getBussinessType();

    if (res['status'] == 1) {

      var jsonArray = res['result'];


      for (var data in jsonArray) {

        bt.Result record = bt.Result(
          businessTypeId: data['BusinessTypeId'],
          businessType: data['BusinessType'],

        );

        buss.add(record);
      }


    } else {
      Fluttertoast.showToast(msg: res['message']);
    }

    return buss;
  }
}
