class GetPriceList {
  int? status;
  String? message;
  List<Result>? result;

  GetPriceList({this.status, this.message, this.result});

  GetPriceList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
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

class Result {
  int? priceId;
  String? codeId;
  String? codeName;
  String? category;
  String? grade;
  String? company;
  String? country;
  String? state;
  String? currency;
  String? price;
  String? changed;
  String? priceDate;
  String? updatedAt;

  Result(
      {this.priceId,
        this.codeId,
        this.codeName,
        this.category,
        this.grade,
        this.company,
        this.country,
        this.state,
        this.currency,
        this.price,
        this.changed,
        this.priceDate,
        this.updatedAt});

  Result.fromJson(Map<String, dynamic> json) {
    priceId = json['priceId'];
    codeId = json['codeId'];
    codeName = json['CodeName'];
    category = json['Category'];
    grade = json['Grade'];
    company = json['Company'];
    country = json['Country'];
    state = json['State'];
    currency = json['Currency'];
    price = json['Price'];
    changed = json['Changed'];
    priceDate = json['PriceDate'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['priceId'] = this.priceId;
    data['codeId'] = this.codeId;
    data['CodeName'] = this.codeName;
    data['Category'] = this.category;
    data['Grade'] = this.grade;
    data['Company'] = this.company;
    data['Country'] = this.country;
    data['State'] = this.state;
    data['Currency'] = this.currency;
    data['Price'] = this.price;
    data['Changed'] = this.changed;
    data['PriceDate'] = this.priceDate;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
