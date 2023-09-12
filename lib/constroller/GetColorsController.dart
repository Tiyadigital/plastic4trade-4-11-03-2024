import 'package:fluttertoast/fluttertoast.dart';

import '../api/api_interface.dart';
import 'package:Plastic4trade/model/GetColors.dart' as color;

import '../model/GetColors.dart';

class GetColorsController {

  List<color.Result> color_data =<color.Result>[];
  Map<String ,dynamic>? data;
  Future<List<color.Result>> setlogin() async {
    GetColors getcoloregory = GetColors();

    var res = await getColors();

    print(res);
    if (res['status'] == 1) {

      getcoloregory = GetColors.fromJson(res);
      print('hello');

      var jsonarray = res['result'];
      print(jsonarray);
      for (var data in jsonarray) {

        color.Result record = color.Result(
          colorId: data['colorId'],
          colorName: data['ColorName'],
        );
        color_data.add(record);

      }
   print(color_data);

  }else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return color_data;
  }
}