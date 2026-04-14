import 'package:firebase_auth/firebase_auth.dart';
import 'package:fintech_app/data/services/firebase_service.dart';

class SignInUseCase {
  final FirebaseService firebaseService;

  SignInUseCase(this.firebaseService);

  Future<User?> execute(String email, String password) async {
    return await firebaseService.signInWithEmail(email, password);
  }
}