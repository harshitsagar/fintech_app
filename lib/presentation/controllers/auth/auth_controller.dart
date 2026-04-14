import 'package:get/get.dart';
import 'package:fintech_app/core/routes/app_routes.dart';
import 'package:fintech_app/data/models/user_model.dart';
import 'package:fintech_app/data/services/firebase_service.dart';
import 'package:fintech_app/presentation/controllers/user/user_controller.dart';

class AuthController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  final UserController userController = Get.put(UserController());

  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var hasSeenOnboarding = false.obs;
  var currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _checkOnboardingStatus();
    _checkAuthStatus();
  }

  void _checkOnboardingStatus() {
    hasSeenOnboarding.value = false; // You can implement SharedPreferences here
  }

  void _checkAuthStatus() {
    final user = _firebaseService.getCurrentUser();
    if (user != null) {
      isLoggedIn.value = true;
      _loadUserData(user.uid);
    }
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final userData = await _firebaseService.getUserData(uid);
      if (userData != null) {
        currentUser.value = userData;
        userController.setUser(userData);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      final user = await _firebaseService.signInWithEmail(email, password);
      if (user != null) {
        isLoggedIn.value = true;
        await _loadUserData(user.uid);
        AppRoutes.router.go('/dashboard');
        Get.snackbar('Success', 'Welcome back!');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      isLoading.value = true;
      final user = await _firebaseService.signUpWithEmail(email, password, name);
      if (user != null) {
        isLoggedIn.value = true;
        await _loadUserData(user.uid);
        AppRoutes.router.go('/dashboard');
        Get.snackbar('Success', 'Account created successfully!');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      isLoading.value = true;
      await _firebaseService.sendPasswordResetEmail(email);
      AppRoutes.router.pop();
      Get.snackbar('Success', 'Password reset email sent!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
    isLoggedIn.value = false;
    currentUser.value = null;
    AppRoutes.router.go('/login');
    Get.snackbar('Success', 'Signed out successfully');
  }

  void setOnboardingSeen() {
    hasSeenOnboarding.value = true;
  }
}