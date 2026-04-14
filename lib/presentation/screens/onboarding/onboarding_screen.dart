import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/presentation/controllers/auth/auth_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final AuthController authController = Get.find<AuthController>();

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: 'Smart Investing',
      description: 'Invest in gold, stocks, and crypto with ease',
      icon: Icons.trending_up,
      color: const Color(0xFF2563EB),
    ),
    OnboardingData(
      title: 'Secure Transactions',
      description: 'Your money is safe with bank-level security',
      icon: Icons.security,
      color: const Color(0xFF7C3AED),
    ),
    OnboardingData(
      title: 'Earn Rewards',
      description: 'Play games and earn real rewards',
      icon: Icons.emoji_events,
      color: const Color(0xFFF59E0B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_onboardingData[index]);
                },
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180.w,
            height: 180.w,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.icon,
              size: 80.sp,
              color: data.color,
            ),
          ),
          SizedBox(height: 48.h),
          Text(
            data.title,
            style: GoogleFonts.poppins(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length,
                  (index) => Container(
                width: 8.w,
                height: 8.w,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? const Color(0xFF2563EB)
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),
          SizedBox(height: 32.h),
          ElevatedButton(
            onPressed: () async {
              if (_currentPage == _onboardingData.length - 1) {
                await authController.setOnboardingSeen();
                if (mounted) context.go('/login');
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50.h),
            ),
            child: Text(
              _currentPage == _onboardingData.length - 1 ? 'Get Started' : 'Next',
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          if (_currentPage == _onboardingData.length - 1)
            TextButton(
              onPressed: () async {
                await authController.setOnboardingSeen();
                if (mounted) context.go('/login');
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}