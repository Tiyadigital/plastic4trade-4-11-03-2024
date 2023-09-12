class get_graph {
  int? status;
  String? message;
  List<LastYearRecord>? lastYearRecord;
  List<LastMonthRecord>? lastMonthRecord;
  List<AllRecord>? allRecord;

  get_graph(
      {this.status,
        this.message,
        this.lastYearRecord,
        this.lastMonthRecord,
        this.allRecord});

  get_graph.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['last_year_record'] != null) {
      lastYearRecord = <LastYearRecord>[];
      json['last_year_record'].forEach((v) {
        lastYearRecord!.add(new LastYearRecord.fromJson(v));
      });
    }
    if (json['last_month_record'] != null) {
      lastMonthRecord = <LastMonthRecord>[];
      json['last_month_record'].forEach((v) {
        lastMonthRecord!.add(new LastMonthRecord.fromJson(v));
      });
    }
    if (json['all_record'] != null) {
      allRecord = <AllRecord>[];
      json['all_record'].forEach((v) {
        allRecord!.add(new AllRecord.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.lastYearRecord != null) {
      data['last_year_record'] =
          this.lastYearRecord!.map((v) => v.toJson()).toList();
    }
    if (this.lastMonthRecord != null) {
      data['last_month_record'] =
          this.lastMonthRecord!.map((v) => v.toJson()).toList();
    }
    if (this.allRecord != null) {
      data['all_record'] = this.allRecord!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LastYearRecord {
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

  LastYearRecord(
      {this.id,
        this.codeId,
        this.categoryId,
        this.productgradeId,
        this.companyId,
        this.country,
        this.state,
        this.price,
        this.currency,
        this.changed,
        this.priceDate,
        this.notificationStatus,
        this.createdAt,
        this.updatedAt});

  LastYearRecord.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class LastMonthRecord {
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

  LastMonthRecord(
      {this.id,
        this.codeId,
        this.categoryId,
        this.productgradeId,
        this.companyId,
        this.country,
        this.state,
        this.price,
        this.currency,
        this.changed,
        this.priceDate,
        this.notificationStatus,
        this.createdAt,
        this.updatedAt});

  LastMonthRecord.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class AllRecord {
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

  AllRecord(
      {this.id,
        this.codeId,
        this.categoryId,
        this.productgradeId,
        this.companyId,
        this.country,
        this.state,
        this.price,
        this.currency,
        this.changed,
        this.priceDate,
        this.notificationStatus,
        this.createdAt,
        this.updatedAt});

  AllRecord.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
