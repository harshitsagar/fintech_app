import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fintech_app/presentation/controllers/user/user_controller.dart';
import 'package:fintech_app/presentation/widgets/balance_card.dart';
import 'package:fintech_app/presentation/widgets/gold_balance_card.dart';
import 'package:fintech_app/presentation/widgets/game_card.dart';
import 'package:fintech_app/presentation/widgets/blog_card.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final UserController userController = Get.find<UserController>();

  final List<String> advertisements = [
    'https://picsum.photos/seed/1/400/200',
    'https://picsum.photos/seed/2/400/200',
    'https://picsum.photos/seed/3/400/200',
  ];

  final List<GameModel> games = [
    GameModel(
      name: 'Spin & Win',
      icon: Icons.casino,
      color: const Color(0xFFEF4444),
      reward: 'Up to ₹500',
    ),
    GameModel(
      name: 'Lucky Number',
      icon: Icons.numbers,
      color: const Color(0xFF10B981),
      reward: 'Up to ₹1000',
    ),
    GameModel(
      name: 'Treasure Hunt',
      icon: Icons.map,
      color: const Color(0xFFF59E0B),
      reward: 'Up to ₹2000',
    ),
  ];

  final List<BlogModel> blogs = [
    BlogModel(
      title: 'How to Start Investing in Gold',
      excerpt: 'Learn the basics of gold investment...',
      imageUrl: 'https://picsum.photos/seed/gold/400/200',
      date: '2024-01-15',
    ),
    BlogModel(
      title: 'Top 5 Investment Strategies',
      excerpt: 'Maximize your returns with these strategies...',
      imageUrl: 'https://picsum.photos/seed/strategy/400/200',
      date: '2024-01-10',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              context.push('/profile');
            },
          ),
        ],
      ),
      body: Obx(() => RefreshIndicator(
        onRefresh: () async {
          // Refresh user data
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Cards Row
              Row(
                children: [
                  Expanded(
                    child: BalanceCard(
                      balance: userController.balance.value,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GoldBalanceCard(
                      goldBalance: userController.goldBalance.value,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Quick Action Buttons
              _buildQuickActions(),
              SizedBox(height: 24.h),

              // Advertisement Section
              _buildAdvertisementSection(),
              SizedBox(height: 24.h),

              // Games Section
              _buildGamesSection(),
              SizedBox(height: 24.h),

              // Referral Section
              _buildReferralSection(),
              SizedBox(height: 24.h),

              // YouTube Section
              _buildYouTubeSection(),
              SizedBox(height: 24.h),

              // Blog Section
              _buildBlogSection(),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildActionButton(
              icon: Icons.add_circle_outline,
              label: 'Deposit',
              onTap: () {},
            ),
            SizedBox(width: 12.w),
            _buildActionButton(
              icon: Icons.trending_up,
              label: 'Portfolio',
              onTap: () {},
            ),
            SizedBox(width: 12.w),
            _buildActionButton(
              icon: Icons.token,
              label: 'Token',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Icon(icon, size: 28.sp, color: const Color(0xFF2563EB)),
              SizedBox(height: 8.h),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvertisementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Offers',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        CarouselSlider(
          options: CarouselOptions(
            height: 180.h,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
          ),
          items: advertisements.map((url) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGamesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Play & Earn',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 180.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: games.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return GameCard(game: games[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReferralSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF2563EB), const Color(0xFF7C3AED)],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.share,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Invite Friends & Earn',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Share your referral code and earn ₹100 for every friend who joins!',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    userController.userData.value?.referralCode ?? 'LOADING',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Copy referral code
                  },
                  child: Icon(
                    Icons.copy,
                    color: const Color(0xFF2563EB),
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYouTubeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Watch & Learn',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          height: 200.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_filled,
                  size: 48.sp,
                  color: Colors.red,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Watch Investment Tips',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBlogSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest Articles',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: blogs.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            return BlogCard(blog: blogs[index]);
          },
        ),
      ],
    );
  }
}

class GameModel {
  final String name;
  final IconData icon;
  final Color color;
  final String reward;

  GameModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.reward,
  });
}

class BlogModel {
  final String title;
  final String excerpt;
  final String imageUrl;
  final String date;

  BlogModel({
    required this.title,
    required this.excerpt,
    required this.imageUrl,
    required this.date,
  });
}