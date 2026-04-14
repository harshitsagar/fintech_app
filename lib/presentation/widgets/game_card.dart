import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fintech_app/presentation/screens/dashboard/dashboard_screen.dart';

class GameCard extends StatelessWidget {
  final GameModel game;

  const GameCard({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [game.color, game.color.withOpacity(0.7)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              game.icon,
              size: 30.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            game.name,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            game.reward,
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Play Now',
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                color: const Color(0xFF2563EB),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}