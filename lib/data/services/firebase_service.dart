import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fintech_app/data/models/user_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Auth Methods
  Future<User?> signUpWithEmail(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);

      // Create user document in Firestore
      await createUserDocument(userCredential.user!, name);

      return userCredential.user;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> sendOTP(String phoneNumber) async {
    // For audio OTP support - using phone auth
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e.message ?? 'Verification failed';
      },
      codeSent: (String verificationId, int? resendToken) {
        // Store verification ID
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> verifyOTP(String verificationId, String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpCode,
    );
    await _auth.signInWithCredential(credential);
  }

  // Firestore Methods
  Future<void> createUserDocument(User user, String name) async {
    final userModel = UserModel(
      uid: user.uid,
      name: name,
      email: user.email ?? '',
      profilePhoto: user.photoURL,
      referralCode: _generateReferralCode(user.uid),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(user.uid).set(userModel.toJson());
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        ...data,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update user data: $e');
    }
  }

  Future<void> updateBalance(String uid, double newBalance) async {
    await updateUserData(uid, {'balance': newBalance});
  }

  Future<void> updateGoldBalance(String uid, double newGoldBalance) async {
    await updateUserData(uid, {'goldBalance': newGoldBalance});
  }

  String _generateReferralCode(String uid) {
    return uid.substring(0, 8).toUpperCase();
  }

  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'This email is already registered';
        case 'invalid-email':
          return 'Invalid email address';
        case 'weak-password':
          return 'Password is too weak';
        case 'user-not-found':
          return 'User not found';
        case 'wrong-password':
          return 'Wrong password';
        default:
          return error.message ?? 'Authentication failed';
      }
    }
    return 'An error occurred';
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}