import 'dart:async';
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
  static final AuthController _authController = Get.find<AuthController>();

  static final GoRouter router = GoRouter(
    navigatorKey: Get.key,
    initialLocation: '/splash',
    refreshListenable: _GoRouterRefreshStream(_authController.isLoggedIn.stream),
    redirect: (context, state) {
      if (!_authController.isReady.value) {
        return null;
      }

      final bool isLoggedIn = _authController.isLoggedIn.value;
      final bool hasSeenOnboarding = _authController.hasSeenOnboarding.value;

      final bool isAuthRoute = state.matchedLocation.contains('/login') ||
          state.matchedLocation.contains('/register') ||
          state.matchedLocation.contains('/forgot-password') ||
          state.matchedLocation.contains('/otp-verification') ||
          state.matchedLocation.contains('/reset-password');

      final bool isOnboardingRoute = state.matchedLocation.contains('/onboarding');
      final bool isSplashRoute = state.matchedLocation.contains('/splash');

      if (isSplashRoute) return null;

      // 1. Force onboarding if not seen
      if (!hasSeenOnboarding) {
        return isOnboardingRoute ? null : '/onboarding';
      }

      // 2. If onboarding seen, don't allow going back to onboarding
      if (isOnboardingRoute) {
        return isLoggedIn ? '/dashboard' : '/login';
      }

      // 3. If logged in, don't allow auth routes
      if (isLoggedIn && isAuthRoute) {
        return '/dashboard';
      }

      // 4. If not logged in, force auth routes
      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
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

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}