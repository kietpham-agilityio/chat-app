import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  const UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.blockedUsers = const [],
    this.avatarUrl,
  });

  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final List<String> blockedUsers;
  final String? avatarUrl;

  /// Empty user which represents an unauthenticated user.
  static const empty = UserModel(
    uid: '',
    fullName: '',
    email: '',
    phoneNumber: '',
    blockedUsers: [],
  );

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phoneNumber,
    List<String>? blockedUsers,
    String? avatarUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      fullName: data["fullName"] ?? "",
      email: data["email"] ?? "",
      phoneNumber: data["phoneNumber"] ?? "",
      blockedUsers: List<String>.from(data["blockedUsers"] ?? []),
      avatarUrl: data["avatarUrl"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'blockedUsers': blockedUsers,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    };
  }
}
