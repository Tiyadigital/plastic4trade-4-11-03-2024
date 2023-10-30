class EventDetails {
  final int? status;
  final String? message;
  final EventData? data;
  final List<LikedUser>? likedUser;

  EventDetails({
     this.status,
     this.message,
     this.data,
     this.likedUser,
  });

  factory EventDetails.fromJson(Map<String, dynamic> json) {
    return EventDetails(
      status: json['status'],
      message: json['message'],
      data: EventData.fromJson(json['data']),
      likedUser: List<LikedUser>.from(
        json['liked_user'].map((user) => LikedUser.fromJson(user)),
      ),
    );
  }
}

class EventData {
  final int id;
  final String? shortDescription;
  final String title;
  final String longDescription;
  final String metaDescription;
  final String image;
  final String likeCounter;
  final int viewCounter;
  final String startDate;
  final String endDate;
  final String slug;
  final String slugWithLocation;
  final String status;
  final String location;
  final String city;
  final String state;
  final String country;
  final String latitude;
  final String longitude;
  final String notificationStatus;
  final String? facebookLink;
  final String? twitterLink;
  final String? linkedinLink;
  final String? intagramLink;
  final String? youtubeLink;
  final String? organizerName;
  final String? organizerAddress;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String isLike;
  final String imageUrl;

  EventData({
    required this.id,
    this.shortDescription,
    required this.title,
    required this.longDescription,
    required this.metaDescription,
    required this.image,
    required this.likeCounter,
    required this.viewCounter,
    required this.startDate,
    required this.endDate,
    required this.slug,
    required this.slugWithLocation,
    required this.status,
    required this.location,
    required this.city,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.notificationStatus,
    this.facebookLink,
    this.twitterLink,
    this.linkedinLink,
    this.intagramLink,
    this.youtubeLink,
    this.organizerName,
    this.organizerAddress,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isLike,
    required this.imageUrl,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      id: json['id'],
      shortDescription: json['short_description'],
      title: json['title'],
      longDescription: json['long_description'],
      metaDescription: json['meta_description'],
      image: json['image'],
      likeCounter: json['like_counter'],
      viewCounter: json['view_counter'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      slug: json['slug'],
      slugWithLocation: json['slug_with_location'],
      status: json['status'],
      location: json['location'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      notificationStatus: json['notification_status'],
      facebookLink: json['facebook_link'],
      twitterLink: json['twitter_link'],
      linkedinLink: json['linkedin_link'],
      intagramLink: json['intagram_link'],
      youtubeLink: json['youtube_link'],
      organizerName: json['organizer_name'],
      organizerAddress: json['organizer_address'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      isLike: json['isLike'],
      imageUrl: json['image_url'],
    );
  }
}

class LikedUser {
  final String userId;
  final String username;
  final String profileImage;
  final String createdAt;

  LikedUser({
    required this.userId,
    required this.username,
    required this.profileImage,
    required this.createdAt,
  });

  factory LikedUser.fromJson(Map<String, dynamic> json) {
    return LikedUser(
      userId: json['userId'],
      username: json['username'],
      profileImage: json['profile_image'],
      createdAt: json['created_at'],
    );
  }
}
