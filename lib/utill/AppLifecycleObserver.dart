import 'package:Plastic4trade/utill/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

      int appOpenCount = await getAppOpenCount();
      appOpenCount++;
      await saveAppOpenCount(appOpenCount);
    //}
  }
  Future<int> getAppOpenCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    constanst.appopencount = prefs.getInt('appOpenCount') ?? 1;
    Fluttertoast.showToast(msg: 'rtt ${constanst.appopencount}');
    return prefs.getInt('appOpenCount') ?? 1;
  }
  Future<void> saveAppOpenCount(int count) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('appOpenCount', count);
  }
}
