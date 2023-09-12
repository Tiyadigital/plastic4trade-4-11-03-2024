class Get_deteteDocument {
  int? _status;
  String? _data;

  Get_deteteDocument({int? status, String? data}) {
    if (status != null) {
      this._status = status;
    }
    if (data != null) {
      this._data = data;
    }
  }

  int? get status => _status;
  set status(int? status) => _status = status;
  String? get data => _data;
  set data(String? data) => _data = data;

  Get_deteteDocument.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['data'] = this._data;
    return data;
  }
}
