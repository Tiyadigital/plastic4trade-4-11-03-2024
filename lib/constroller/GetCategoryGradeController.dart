// ignore_for_file: non_constant_identifier_names

import 'package:fluttertoast/fluttertoast.dart';

import '../api/api_interface.dart';
import 'package:Plastic4trade/model/GetCategoryGrade.dart' as grade;

class GetCategoryGradeController {

  List<grade.Result> cat_data =<grade.Result>[];
  Map<String ,dynamic>? data;

  Future<List<grade.Result>> setGrade() async {

    var res = await getCateGrade();

    if (res['status'] == 1) {



      var jsonArray = res['result'];

      for (var data in jsonArray) {
        grade.Result record = grade.Result(
          productgradeId: data['productgradeId'],
          productGrade: data['ProductGrade']
        );

        cat_data.add(record);

      }

  }else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return cat_data;
  }
}