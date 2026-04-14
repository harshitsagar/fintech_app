import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? profilePhoto;
  final double balance;
  final double goldBalance;
  final String referralCode;
  final int referralCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePhoto,
    this.balance = 0.0,
    this.goldBalance = 0.0,
    required this.referralCode,
    this.referralCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePhoto': profilePhoto,
      'balance': balance,
      'goldBalance': goldBalance,
      'referralCode': referralCode,
      'referralCount': referralCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePhoto: json['profilePhoto'],
      balance: (json['balance'] ?? 0).toDouble(),
      goldBalance: (json['goldBalance'] ?? 0).toDouble(),
      referralCode: json['referralCode'] ?? '',
      referralCount: json['referralCount'] ?? 0,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }
}