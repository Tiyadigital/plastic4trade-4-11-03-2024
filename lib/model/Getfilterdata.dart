class Getfilterdata {
  int? _status;
  List<Category>? _category;
  List<Productgrade>? _productgrade;
  List<Producttype>? _producttype;
  List<Businesstype>? _businesstype;

  Getfilterdata(
      {int? status,
        List<Category>? category,
        List<Productgrade>? productgrade,
        List<Producttype>? producttype,
        List<Businesstype>? businesstype}) {
    if (status != null) {
      this._status = status;
    }
    if (category != null) {
      this._category = category;
    }
    if (productgrade != null) {
      this._productgrade = productgrade;
    }
    if (producttype != null) {
      this._producttype = producttype;
    }
    if (businesstype != null) {
      this._businesstype = businesstype;
    }
  }

  int? get status => _status;
  set status(int? status) => _status = status;
  List<Category>? get category => _category;
  set category(List<Category>? category) => _category = category;
  List<Productgrade>? get productgrade => _productgrade;
  set productgrade(List<Productgrade>? productgrade) =>
      _productgrade = productgrade;
  List<Producttype>? get producttype => _producttype;
  set producttype(List<Producttype>? producttype) => _producttype = producttype;
  List<Businesstype>? get businesstype => _businesstype;
  set businesstype(List<Businesstype>? businesstype) =>
      _businesstype = businesstype;

  Getfilterdata.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if (json['category'] != null) {
      _category = <Category>[];
      json['category'].forEach((v) {
        _category!.add(new Category.fromJson(v));
      });
    }
    if (json['productgrade'] != null) {
      _productgrade = <Productgrade>[];
      json['productgrade'].forEach((v) {
        _productgrade!.add(new Productgrade.fromJson(v));
      });
    }
    if (json['producttype'] != null) {
      _producttype = <Producttype>[];
      json['producttype'].forEach((v) {
        _producttype!.add(new Producttype.fromJson(v));
      });
    }
    if (json['businesstype'] != null) {
      _businesstype = <Businesstype>[];
      json['businesstype'].forEach((v) {
        _businesstype!.add(new Businesstype.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    if (this._category != null) {
      data['category'] = this._category!.map((v) => v.toJson()).toList();
    }
    if (this._productgrade != null) {
      data['productgrade'] =
          this._productgrade!.map((v) => v.toJson()).toList();
    }
    if (this._producttype != null) {
      data['producttype'] = this._producttype!.map((v) => v.toJson()).toList();
    }
    if (this._businesstype != null) {
      data['businesstype'] =
          this._businesstype!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int? _id;
  String? _categoryName;

  Category({int? id, String? categoryName}) {
    if (id != null) {
      this._id = id;
    }
    if (categoryName != null) {
      this._categoryName = categoryName;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get categoryName => _categoryName;
  set categoryName(String? categoryName) => _categoryName = categoryName;

  Category.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['category_name'] = this._categoryName;
    return data;
  }
}

class Productgrade {
  int? _id;
  String? _productGrade;

  Productgrade({int? id, String? productGrade}) {
    if (id != null) {
      this._id = id;
    }
    if (productGrade != null) {
      this._productGrade = productGrade;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get productGrade => _productGrade;
  set productGrade(String? productGrade) => _productGrade = productGrade;

  Productgrade.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productGrade = json['product_grade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['product_grade'] = this._productGrade;
    return data;
  }
}

class Producttype {
  int? _id;
  String? _productType;

  Producttype({int? id, String? productType}) {
    if (id != null) {
      this._id = id;
    }
    if (productType != null) {
      this._productType = productType;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get productType => _productType;
  set productType(String? productType) => _productType = productType;

  Producttype.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productType = json['product_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['product_type'] = this._productType;
    return data;
  }
}

class Businesstype {
  int? _id;
  String? _businessType;

  Businesstype({int? id, String? businessType}) {
    if (id != null) {
      this._id = id;
    }
    if (businessType != null) {
      this._businessType = businessType;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get businessType => _businessType;
  set businessType(String? businessType) => _businessType = businessType;

  Businesstype.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _businessType = json['business_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['business_type'] = this._businessType;
    return data;
  }
}
