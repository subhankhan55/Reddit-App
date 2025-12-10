// lib/models/post_model.dart

import 'package:flutter/foundation.dart';

class PostModel {
  final String id;
  final String title;
  final String description; // The body of the post
  final int karma; // Simplified score
  final List<String> upvotes;
  final List<String> downvotes;
  final String communityName;
  final String communityIcon;
  final String type; // 'text', 'image', or 'link'
  final String authorUid;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.karma,
    required this.upvotes,
    required this.downvotes,
    required this.communityName,
    required this.communityIcon,
    required this.type,
    required this.authorUid,
    required this.createdAt,
  });

  PostModel copyWith({
    String? id,
    String? title,
    String? description,
    int? karma,
    List<String>? upvotes,
    List<String>? downvotes,
    String? communityName,
    String? communityIcon,
    String? type,
    String? authorUid,
    DateTime? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      karma: karma ?? this.karma,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      communityName: communityName ?? this.communityName,
      communityIcon: communityIcon ?? this.communityIcon,
      type: type ?? this.type,
      authorUid: authorUid ?? this.authorUid,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'karma': karma,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'communityName': communityName,
      'communityIcon': communityIcon,
      'type': type,
      'authorUid': authorUid,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      karma: map['karma'] as int,
      upvotes: List<String>.from((map['upvotes'] as List<dynamic>)),
      downvotes: List<String>.from((map['downvotes'] as List<dynamic>)),
      communityName: map['communityName'] as String,
      communityIcon: map['communityIcon'] as String,
      type: map['type'] as String,
      authorUid: map['authorUid'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  @override
  String toString() {
    return 'PostModel(id: $id, title: $title, description: $description, karma: $karma, upvotes: $upvotes, downvotes: $downvotes, communityName: $communityName, communityIcon: $communityIcon, type: $type, authorUid: $authorUid, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.karma == karma &&
        listEquals(other.upvotes, upvotes) &&
        listEquals(other.downvotes, downvotes) &&
        other.communityName == communityName &&
        other.communityIcon == communityIcon &&
        other.type == type &&
        other.authorUid == authorUid &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        karma.hashCode ^
        upvotes.hashCode ^
        downvotes.hashCode ^
        communityName.hashCode ^
        communityIcon.hashCode ^
        type.hashCode ^
        authorUid.hashCode ^
        createdAt.hashCode;
  }
}