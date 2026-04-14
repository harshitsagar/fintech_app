import 'package:get/get.dart';
import 'package:fintech_app/data/models/user_model.dart';
import 'package:fintech_app/data/services/firebase_service.dart';

class UserController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  var userData = Rxn<UserModel>();
  var balance = 0.0.obs;
  var goldBalance = 0.0.obs;

  void setUser(UserModel user) {
    userData.value = user;
    balance.value = user.balance;
    goldBalance.value = user.goldBalance;
  }

  Future<void> updateProfile(String name, String? profilePhoto) async {
    try {
      final uid = _firebaseService.getCurrentUser()?.uid;
      if (uid != null) {
        await _firebaseService.updateUserData(uid, {
          'name': name,
          if (profilePhoto != null) 'profilePhoto': profilePhoto,
        });

        if (userData.value != null) {
          userData.value = UserModel(
            uid: userData.value!.uid,
            name: name,
            email: userData.value!.email,
            profilePhoto: profilePhoto ?? userData.value!.profilePhoto,
            balance: userData.value!.balance,
            goldBalance: userData.value!.goldBalance,
            referralCode: userData.value!.referralCode,
            referralCount: userData.value!.referralCount,
            createdAt: userData.value!.createdAt,
            updatedAt: DateTime.now(),
          );
        }

        Get.snackbar('Success', 'Profile updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    }
  }
}