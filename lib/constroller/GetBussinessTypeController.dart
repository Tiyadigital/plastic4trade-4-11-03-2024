import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/model/GetCategory.dart';

import '../api/api_interface.dart';
import 'package:Plastic4trade/model/GetBusinessType.dart' as bt;

import '../model/GetBusinessType.dart';

class GetBussinessTypeController {
  List<bt.Result> buss = <bt.Result>[];


  Future<List<bt.Result>> getBussiness_Type() async {
    GetBusinessType getbuss_type = GetBusinessType();

    var res = await getBussinessType();

    print(res);
    if (res['status'] == 1) {
      getbuss_type = GetBusinessType.fromJson(res);

      var jsonarray = res['result'];


      for (var data in jsonarray) {

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
