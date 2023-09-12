class getBannerImage {
  int? status;
  String? message;
  List<Result>? result;

  getBannerImage({this.status, this.message, this.result});

  getBannerImage.fromJson(Map<String, dynamic> json) {
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
  Null? heading;
  Null? subHeading;
  String? buttonLink;
  String? bannertype;
  String? bannerImage;

  Result(
      {this.heading,
        this.subHeading,
        this.buttonLink,
        this.bannertype,
        this.bannerImage});

  Result.fromJson(Map<String, dynamic> json) {
    heading = json['Heading'];
    subHeading = json['SubHeading'];
    buttonLink = json['ButtonLink'];
    bannertype = json['bannertype'];
    bannerImage = json['BannerImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Heading'] = this.heading;
    data['SubHeading'] = this.subHeading;
    data['ButtonLink'] = this.buttonLink;
    data['bannertype'] = this.bannertype;
    data['BannerImage'] = this.bannerImage;
    return data;
  }
}
