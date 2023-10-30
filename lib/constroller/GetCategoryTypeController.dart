// ignore_for_file: non_constant_identifier_names

import 'package:fluttertoast/fluttertoast.dart';

import '../api/api_interface.dart';
import 'package:Plastic4trade/model/GetCategoryType.dart' as type;

class GetCategoryTypeController {

  List<type.Result> cat_data =<type.Result>[];
  Map<String ,dynamic>? data;

  Future<List<type.Result>> setType() async {

    var res = await getCateType();


    if (res['status'] == 1) {



      var jsonArray = res['result'];

      for (var data in jsonArray) {
        type.Result record = type.Result(
          producttypeId: data['producttypeId'],
          productType: data['ProductType']
        );

        cat_data.add(record);

      }


  }else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return cat_data;
  }
}