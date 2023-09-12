import 'package:fluttertoast/fluttertoast.dart';

import '../api/api_interface.dart';
import 'package:Plastic4trade/model/GetUnit.dart' as unit;

import '../model/GetColors.dart';
import '../model/GetUnit.dart';

class GetUnitController {

  Future<List<String>> setunit() async {
    GetUnit getcoloregory = GetUnit();

    var res = await getUnit();
    var jsonarray;
    print(res);
    if (res['status'] == 1) {

      getcoloregory = GetUnit.fromJson(res);
      jsonarray = res['result'][0]['Unit'].cast<String>();

      print(jsonarray);



  }else {
      Fluttertoast.showToast(msg: res['message']);
    }
    return jsonarray;
  }
}