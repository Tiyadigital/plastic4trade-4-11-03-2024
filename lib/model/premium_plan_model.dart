class ShowPremiumPlan {
  List<Plan>? plan;
  int? status;
  String? message;

  ShowPremiumPlan({this.plan, this.status, this.message});

  ShowPremiumPlan.fromJson(Map<String, dynamic> json) {
    if (json['plan'] != null) {
      plan = <Plan>[];
      json['plan'].forEach((v) {
        plan!.add(new Plan.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.plan != null) {
      data['plan'] = this.plan!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Plan {
  int? id;
  String? sequence;
  String? name;
  String? livePrice;
  String? livePriceDecription;
  String? news;
  String? newsDecription;
  String? chat;
  String? chatDescription;
  String? showMyContact;
  String? otherContactShow;
  int? businessProfile;
  String? businessProfileDecription;
  int? notificationAds;
  String? notificationAdsDescription;
  int? paidPost;
  String? paidPostDecription;
  String? directory;
  String? directoryDescription;
  String? exhibition;
  String? exhibitionDecription;
  int? timeDuration;
  String? timeDurationInText;
  String? priceInr;
  String? priceDoller;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<Services>? services;

  Plan(
      {this.id,
        this.sequence,
        this.name,
        this.livePrice,
        this.livePriceDecription,
        this.news,
        this.newsDecription,
        this.chat,
        this.chatDescription,
        this.showMyContact,
        this.otherContactShow,
        this.businessProfile,
        this.businessProfileDecription,
        this.notificationAds,
        this.notificationAdsDescription,
        this.paidPost,
        this.paidPostDecription,
        this.directory,
        this.directoryDescription,
        this.exhibition,
        this.exhibitionDecription,
        this.timeDuration,
        this.timeDurationInText,
        this.priceInr,
        this.priceDoller,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.services});

  Plan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sequence = json['sequence'];
    name = json['name'];
    livePrice = json['live_price'];
    livePriceDecription = json['live_price_decription'];
    news = json['news'];
    newsDecription = json['news_decription'];
    chat = json['chat'];
    chatDescription = json['chat_description'];
    showMyContact = json['show_my_contact'];
    otherContactShow = json['other_contact_show'];
    businessProfile = json['business_profile'];
    businessProfileDecription = json['business_profile_decription'];
    notificationAds = json['notification_ads'];
    notificationAdsDescription = json['notification_ads_description'];
    paidPost = json['paid_post'];
    paidPostDecription = json['paid_post_decription'];
    directory = json['directory'];
    directoryDescription = json['directory_description'];
    exhibition = json['exhibition'];
    exhibitionDecription = json['exhibition_decription'];
    timeDuration = json['time_duration'];
    timeDurationInText = json['time_duration_in_text'];
    priceInr = json['price_inr'];
    priceDoller = json['price_doller'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sequence'] = this.sequence;
    data['name'] = this.name;
    data['live_price'] = this.livePrice;
    data['live_price_decription'] = this.livePriceDecription;
    data['news'] = this.news;
    data['news_decription'] = this.newsDecription;
    data['chat'] = this.chat;
    data['chat_description'] = this.chatDescription;
    data['show_my_contact'] = this.showMyContact;
    data['other_contact_show'] = this.otherContactShow;
    data['business_profile'] = this.businessProfile;
    data['business_profile_decription'] = this.businessProfileDecription;
    data['notification_ads'] = this.notificationAds;
    data['notification_ads_description'] = this.notificationAdsDescription;
    data['paid_post'] = this.paidPost;
    data['paid_post_decription'] = this.paidPostDecription;
    data['directory'] = this.directory;
    data['directory_description'] = this.directoryDescription;
    data['exhibition'] = this.exhibition;
    data['exhibition_decription'] = this.exhibitionDecription;
    data['time_duration'] = this.timeDuration;
    data['time_duration_in_text'] = this.timeDurationInText;
    data['price_inr'] = this.priceInr;
    data['price_doller'] = this.priceDoller;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  String? title;
  String? value;
  String? description;

  Services({this.title, this.value, this.description});

  Services.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    value = json['value'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['value'] = this.value;
    data['description'] = this.description;
    return data;
  }
}