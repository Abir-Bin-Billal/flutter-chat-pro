class UserModel {
  String uid;
  String name;
  String phoneNumber;
  String image;
  String token;
  String aboutMe;
  String lastSeen;
  String createdAt;
  bool isOnline;
  List<String> friendsUIDs;
  List<String> friendRequestsUIDs;
  List<String> sentFriendRequestsUIDs;

  UserModel({
    required this.uid,
    required this.name,
    required this.phoneNumber,
    required this.image,
    required this.token,
    required this.aboutMe,
    required this.lastSeen,
    required this.createdAt,
    required this.isOnline,
    required this.friendsUIDs,
    required this.friendRequestsUIDs,
    required this.sentFriendRequestsUIDs,
  });

  /// Convert JSON to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      image: json['image'] ?? '',
      token: json['token'] ?? '',
      aboutMe: json['aboutMe'] ?? '',
      lastSeen: json['lastSeen'] ?? '',
      createdAt: json['createdAt'] ?? '',
      isOnline: json['isOnline'] ?? false,
      friendsUIDs: List<String>.from(json['friendsUIDs'] ?? []),
      friendRequestsUIDs: List<String>.from(json['friendRequestsUIDs'] ?? []),
      sentFriendRequestsUIDs: List<String>.from(json['sentFriendRequestsUIDs'] ?? []),
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'phoneNumber': phoneNumber,
      'image': image,
      'token': token,
      'aboutMe': aboutMe,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
      'isOnline': isOnline,
      'friendsUIDs': friendsUIDs,
      'friendRequestsUIDs': friendRequestsUIDs,
      'sentFriendRequestsUIDs': sentFriendRequestsUIDs,
    };
  }
}
