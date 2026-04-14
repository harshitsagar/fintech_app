import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/data/services/firebase_service.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;

  const OtpVerificationScreen({
    super.key,
    required this.verificationId,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = false;
  int _remainingTime = 60;
  bool canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer() {
    if (_remainingTime > 0) {
      setState(() {
        _remainingTime--;
      });
      Future.delayed(const Duration(seconds: 1), _updateTimer);
    } else {
      setState(() {
        canResend = true;
      });
    }
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length != 6) {
      Get.snackbar('Error', 'Please enter valid 6-digit OTP');
      return;
    }

    setState(() => isLoading = true);
    try {
      await _firebaseService.verifyOTP(
        widget.verificationId,
        _otpController.text,
      );
      context.go('/dashboard');
      Get.snackbar('Success', 'Phone verified successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP. Please try again.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Center(
              child: Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified_user,
                  size: 50.sp,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Verification Code',
              style: GoogleFonts.poppins(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please enter the 6-digit code sent to your phone',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 32.h),
            TextFormField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.sp, letterSpacing: 8.w),
              decoration: InputDecoration(
                hintText: '000000',
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: isLoading ? null : _verifyOTP,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
              ),
              child: isLoading
                  ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Text('Verify', style: TextStyle(fontSize: 16.sp)),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  canResend ? "Didn't receive code? " : "Resend code in ${_remainingTime}s",
                  style: TextStyle(fontSize: 14.sp),
                ),
                if (canResend)
                  TextButton(
                    onPressed: () {
                      // Resend OTP logic
                      setState(() {
                        _remainingTime = 60;
                        canResend = false;
                        _startTimer();
                      });
                    },
                    child: Text(
                      'Resend',
                      style: TextStyle(
                        color: const Color(0xFF2563EB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            // Audio OTP Support Section
            SizedBox(height: 24.h),
            Divider(),
            SizedBox(height: 16.h),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Get.snackbar(
                    'Audio OTP',
                    'Audio OTP feature activated! Check your voice mail.',
                    duration: const Duration(seconds: 3),
                  );
                },
                icon: Icon(Icons.volume_up, size: 20.sp),
                label: Text(
                  'Get Audio OTP',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}