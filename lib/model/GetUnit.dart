class GetUnit {
  GetUnit({
     this.status,
     this.message,
     this.result,
  });
   int? status;
   String? message;
   List<Result>? result;

  GetUnit.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    result = List.from(json['result']).map((e)=>Result.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['result'] = result?.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Result {
  Result({
    required this.Unit,
  });
  late final List<String> Unit;

  Result.fromJson(Map<String, dynamic> json){
    Unit = List.castFrom<dynamic, String>(json['Unit']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Unit'] = Unit;
    return _data;
  }
}