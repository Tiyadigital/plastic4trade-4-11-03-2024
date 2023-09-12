class getannualcapacity {
  int? status;
  String? message;
  List<Annual>? annual;

  getannualcapacity({this.status, this.message, this.annual});

  getannualcapacity.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['annual'] != null) {
      annual = <Annual>[];
      json['annual'].forEach((v) {
        annual!.add(new Annual.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.annual != null) {
      data['annual'] = this.annual!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Annual {
  int? id;
  String? name;
  String? createdAt;
  String? deletedAt;
  Null? updatedAt;

  Annual({this.id, this.name, this.createdAt, this.deletedAt, this.updatedAt});

  Annual.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    deletedAt = json['deleted_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['deleted_at'] = this.deletedAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
