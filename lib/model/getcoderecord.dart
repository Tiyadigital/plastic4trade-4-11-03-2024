class Getcoderecord {
  int? status;
  String? message;
  List<CoderecordResult>? result;

  Getcoderecord({this.status, this.message, this.result});

  Getcoderecord.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <CoderecordResult>[];
      json['result'].forEach((v) {
        result!.add(new CoderecordResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CoderecordResult {
  int? id;
  String? codeId;
  String? categoryId;
  String? productgradeId;
  String? companyId;
  String? country;
  String? state;
  String? price;
  String? currency;
  String? changed;
  String? priceDate;
  String? notificationStatus;
  String? createdAt;
  String? updatedAt;
  String? sign;

  CoderecordResult(
      {this.id,
        this.codeId,
        this.categoryId,
        this.productgradeId,
        this.companyId,
        this.country,
        this.state,
        this.sign,
        this.price,
        this.currency,
        this.changed,
        this.priceDate,
        this.notificationStatus,
        this.createdAt,
        this.updatedAt,
        });

  CoderecordResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    codeId = json['code_id'];
    categoryId = json['category_id'];
    productgradeId = json['productgrade_id'];
    companyId = json['company_id'];
    country = json['country'];
    state = json['state'];
    price = json['price'];
    currency = json['currency'];
    changed = json['changed'];
    priceDate = json['price_date'];
    notificationStatus = json['notification_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sign = json['sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code_id'] = this.codeId;
    data['category_id'] = this.categoryId;
    data['productgrade_id'] = this.productgradeId;
    data['company_id'] = this.companyId;
    data['country'] = this.country;
    data['state'] = this.state;
    data['price'] = this.price;
    data['currency'] = this.currency;
    data['changed'] = this.changed;
    data['price_date'] = this.priceDate;
    data['notification_status'] = this.notificationStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['sign'] = this.sign;
    return data;
  }
}
