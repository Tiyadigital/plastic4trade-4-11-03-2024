import 'package:fluttertoast/fluttertoast.dart';

import '../api/api_interface.dart';
import 'package:Plastic4trade/model/GetCategory.dart' as cat;

class GetCategoryController {

  List<cat.Result> cat_data =<cat.Result>[];
  Map<String ,dynamic>? data;
  Future<List<cat.Result>> setlogin() async {

    var res = await getCategoryList();

    if (res['status'] == 1) {


      var jsonarray = res['result'];
      for (var data in jsonarray) {
        cat.Result record = cat.Result(
          categoryId: data['categoryId'],
          categoryName: data['CategoryName'],
        );
        cat_data.add(record);

      }

  }else {
      Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: res['message']);
    }
    return cat_data;
  }
}