import 'package:chat_app/core/local_database/user_db_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.country,
    this.blockedUsers = const [],
    this.avatarUrl,
    this.fcmToken,
  });

  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String country;
  final List<String> blockedUsers;
  final String? avatarUrl;
  final List<String>? fcmToken;

  /// Empty user which represents an unauthenticated user.
  static const empty = UserModel(
    uid: '',
    fullName: '',
    email: '',
    phoneNumber: '',
    country: '',
    blockedUsers: [],
  );

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? country,
    List<String>? blockedUsers,
    String? avatarUrl,
    List<String>? fcmToken,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      country: json['country'] ?? '',
      blockedUsers: List<String>.from(json['blocked_users'] ?? []),
      avatarUrl: json['avatar_url'],
      fcmToken: json['fcm_token'] != null
          ? List<String>.from(json['fcm_token'])
          : null,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      fullName: data["fullName"] ?? "",
      email: data["email"] ?? "",
      phoneNumber: data["phoneNumber"] ?? "",
      country: data["country"] ?? "",
      blockedUsers: List<String>.from(data["blockedUsers"] ?? []),
      avatarUrl: data["avatarUrl"],
      fcmToken: List<String>.from(data["fcmToken"] ?? []),
    );
  }

  factory UserModel.fromDB(UserDBModel map) {
    return UserModel(
      uid: map.uid,
      fullName: map.fullName,
      email: map.email,
      phoneNumber: map.phoneNumber,
      country: map.country,
      avatarUrl: map.avatarUrl,
      fcmToken: List.from([map.fcmToken]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'blocked_users': blockedUsers,
      'country': country,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (fcmToken != null) 'fcm_token': fcmToken,
    };
  }

  @override
  List<Object?> get props => [
    uid,
    fullName,
    email,
    phoneNumber,
    blockedUsers,
    avatarUrl,
    fcmToken,
  ];
}
