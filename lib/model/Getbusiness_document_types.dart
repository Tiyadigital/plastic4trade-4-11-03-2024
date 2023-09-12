class Getbusiness_document_types {
  int? _status;
  String? _message;
  List<Types>? _types;

  Getbusiness_document_types(
      {int? status, String? message, List<Types>? types}) {
    if (status != null) {
      this._status = status;
    }
    if (message != null) {
      this._message = message;
    }
    if (types != null) {
      this._types = types;
    }
  }

  int? get status => _status;
  set status(int? status) => _status = status;
  String? get message => _message;
  set message(String? message) => _message = message;
  List<Types>? get types => _types;
  set types(List<Types>? types) => _types = types;

  Getbusiness_document_types.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _message = json['message'];
    if (json['types'] != null) {
      _types = <Types>[];
      json['types'].forEach((v) {
        _types!.add(new Types.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['message'] = this._message;
    if (this._types != null) {
      data['types'] = this._types!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Types {
  int? _id;
  String? _name;
  String? _createdAt;
  String? _updatedAt;
  Null? _deletedAt;

  Types(
      {int? id,
        String? name,
        String? createdAt,
        String? updatedAt,
        Null? deletedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (name != null) {
      this._name = name;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (deletedAt != null) {
      this._deletedAt = deletedAt;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  Null? get deletedAt => _deletedAt;
  set deletedAt(Null? deletedAt) => _deletedAt = deletedAt;

  Types.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['deleted_at'] = this._deletedAt;
    return data;
  }
}
