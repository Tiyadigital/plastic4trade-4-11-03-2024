import 'package:fluttertoast/fluttertoast.dart';
import 'package:Plastic4trade/model/GetCategory.dart';

import '../api/api_interface.dart';
import 'package:Plastic4trade/model/GetCategory.dart' as cat;

class GetCategoryController {

  List<cat.Result> cat_data =<cat.Result>[];
  Map<String ,dynamic>? data;
  Future<List<cat.Result>> setlogin() async {
    GetCategory getCategory = GetCategory();

    var res = await getCategoryList();

    print(res);
    if (res['status'] == 1) {

      getCategory = GetCategory.fromJson(res);
      print('hello');

      var jsonarray = res['result'];
      for (var data in jsonarray) {
        cat.Result record = cat.Result(
          categoryId: data['categoryId'],
          categoryName: data['CategoryName'],
        );
        cat_data.add(record);

      }
   print(cat_data);

  }else {
      Fluttertoast.showToast(timeInSecForIosWeb: 2,msg: res['message']);
    }
    return cat_data;
  }
}