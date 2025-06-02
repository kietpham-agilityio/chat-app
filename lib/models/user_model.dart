import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  const UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.blockedUsers = const [],
  });

  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final List<String> blockedUsers;

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
    List<String>? fcmToken,
    List<String>? blockedUsers,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      blockedUsers: blockedUsers ?? this.blockedUsers,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'blockedUsers': blockedUsers,
    };
  }
}
