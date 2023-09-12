class gethome_quicknews {
  int? status;
  String? message;
  String? result;

  gethome_quicknews({this.status, this.message, this.result});

  gethome_quicknews.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}
