class UserEntity {
  final String uid;
  final String name;
  final String email;
  final String? profilePhoto;
  final double balance;
  final double goldBalance;
  final String referralCode;
  final int referralCount;

  UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePhoto,
    required this.balance,
    required this.goldBalance,
    required this.referralCode,
    required this.referralCount,
  });
}