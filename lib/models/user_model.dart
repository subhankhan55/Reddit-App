import 'dart:convert';


import 'package:flutter/foundation.dart';
class UserModel {
  final String uid;
  final String name;
 // final String email;
  final String profilePic;
  final String banner;
  final String isAuthenticated;
  final int karma;
  final List<String> awards;
  // final DateTime createdAt;
//constructor
  UserModel({
    required this.uid,
    required this.name,
   // required this.email,
    required this.profilePic,
    required this.karma,
    required this.awards,
    required this.banner,
    required this.isAuthenticated,  
    // required this.createdAt,
  });
  //since values cant be changed we use copywith to create a new instance with some changed values
  UserModel copyWith({
    String? uid,
    String? name,
   // String? email,
    String? profilePic,
    String? banner,
    String? isAuthenticated,
    int? karma,
    List<String>? awards,
    // DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
     // email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      banner: banner ?? this.banner,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      karma: karma ?? this.karma,
      awards: awards ?? this.awards,
      // createdAt: createdAt ?? this.createdAt,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
     // 'email': email,
      'profilePic': profilePic,
      'banner': banner,
      'isAuthenticated': isAuthenticated,
      'karma': karma,
      'awards': awards,
      // 'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
     // email: map['email'] ?? '',
      profilePic: map['profilePic'] ?? '',
      banner: map['banner'] ?? '',
      isAuthenticated: map['isAuthenticated'] ?? '',
      karma: map['karma']?.toInt() ?? 0,
      awards: List<String>.from(map['awards']),
      // createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
  String toJson() => json.encode(toMap());
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, profilePic: $profilePic, banner: $banner, isAuthenticated: $isAuthenticated, karma: $karma, awards: $awards)';
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.name == name &&
       // other.email == email &&
        other.profilePic == profilePic &&
        other.banner == banner &&
        other.isAuthenticated == isAuthenticated &&
        other.karma == karma &&
        listEquals(other.awards, awards);
  }
  @override
  int get hashCode {  
    return uid.hashCode ^
        name.hashCode ^
       // email.hashCode ^
        profilePic.hashCode ^
        banner.hashCode ^
        isAuthenticated.hashCode ^
        karma.hashCode ^
        awards.hashCode;
  }
}