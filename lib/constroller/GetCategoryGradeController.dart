import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/model/GetCategoryGrade.dart';
import 'package:Plastic4trade/model/GetCategoryType.dart';

import '../api/api_interface.dart';
import 'package:Plastic4trade/model/GetCategoryGrade.dart' as grade;

class GetCategoryGradeController {

  List<grade.Result> cat_data =<grade.Result>[];
  Map<String ,dynamic>? data;

  Future<List<grade.Result>> setGrade() async {
    GetCategoryGrade getCategory = GetCategoryGrade();

    var res = await getCateGrade();

    print(res);
    if (res['status'] == 1) {

      getCategory = GetCategoryGrade.fromJson(res);


      var jsonarray = res['result'];

      for (var data in jsonarray) {
        grade.Result record = grade.Result(
          productgradeId: data['productgradeId'],
          productGrade: data['ProductGrade']
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