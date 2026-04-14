import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:fintech_app/presentation/controllers/auth/auth_controller.dart';
import 'package:fintech_app/presentation/screens/auth/login_screen.dart';
import 'package:fintech_app/presentation/screens/auth/register_screen.dart';
import 'package:fintech_app/presentation/screens/auth/forgot_password_screen.dart';
import 'package:fintech_app/presentation/screens/auth/otp_verification_screen.dart';
import 'package:fintech_app/presentation/screens/auth/reset_password_screen.dart';
import 'package:fintech_app/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:fintech_app/presentation/screens/profile/profile_screen.dart';
import 'package:fintech_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:fintech_app/presentation/screens/splash/splash_screen.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    navigatorKey: Get.key,
    initialLocation: '/splash',
    redirect: (context, state) {
      final AuthController authController = Get.find<AuthController>();
      final bool isLoggedIn = authController.isLoggedIn.value;
      final bool hasSeenOnboarding = authController.hasSeenOnboarding.value;

      final bool isAuthRoute = state.matchedLocation.contains('/login') ||
          state.matchedLocation.contains('/register') ||
          state.matchedLocation.contains('/forgot-password');

      final bool isSplashRoute = state.matchedLocation.contains('/splash');

      if (isSplashRoute) {
        return null;
      }

      if (!hasSeenOnboarding && !isAuthRoute) {
        return '/onboarding';
      }

      if (!isLoggedIn && !isAuthRoute && !state.matchedLocation.contains('/onboarding')) {
        return '/login';
      }

      if (isLoggedIn && isAuthRoute) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/otp-verification',
        name: 'otp-verification',
        builder: (context, state) {
          final verificationId = state.extra as String?;
          return OtpVerificationScreen(verificationId: verificationId ?? '');
        },
      ),
      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        builder: (context, state) => ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => DashboardScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => ProfileScreen(),
      ),
    ],
  );
}