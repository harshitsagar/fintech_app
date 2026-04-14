import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class GoldBalanceCard extends StatelessWidget {
  final double goldBalance;

  const GoldBalanceCard({
    super.key,
    required this.goldBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFFBBF24), const Color(0xFFF59E0B)],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gold Balance',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '${goldBalance.toStringAsFixed(2)} g',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '≈ ₹${(goldBalance * 5000).toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}