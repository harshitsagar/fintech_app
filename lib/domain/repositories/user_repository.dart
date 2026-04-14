import 'package:fintech_app/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> getUserData(String uid);
  Future<void> updateUserData(String uid, Map<String, dynamic> data);
  Future<void> updateBalance(String uid, double newBalance);
  Future<void> updateGoldBalance(String uid, double newGoldBalance);
}