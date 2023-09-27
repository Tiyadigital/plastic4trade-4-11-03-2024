
import 'package:shared_value/shared_value.dart';

final SharedValue<bool> is_logged_in = SharedValue(
  value: false, // initial value
  key: "is_logged_in", // disk storage key for shared_preferences
);

final SharedValue<String> userid = SharedValue(
  value: '', // initial value
  key: "userid", // disk storage key for shared_preferences
);

final SharedValue<String> username = SharedValue(
  value: "", // initial value
  key: "username", // disk storage key for shared_preferences
);