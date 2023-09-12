import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/model/GetCategoryType.dart';

import '../api/api_interface.dart';
import 'package:Plastic4trade/model/GetCategoryType.dart' as type;

class GetCategoryTypeController {

  List<type.Result> cat_data =<type.Result>[];
  Map<String ,dynamic>? data;

  Future<List<type.Result>> setType() async {
    GetCategoryType getCategory = GetCategoryType();

    var res = await getCateType();

    print(res);
    if (res['status'] == 1) {

      getCategory = GetCategoryType.fromJson(res);


      var jsonarray = res['result'];

      for (var data in jsonarray) {
        type.Result record = type.Result(
          producttypeId: data['producttypeId'],
          productType: data['ProductType']
        );

        cat_data.add(record);

      }
   print(cat_data);

  }else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return cat_data;
  }
}