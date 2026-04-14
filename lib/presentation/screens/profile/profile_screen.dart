import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fintech_app/presentation/controllers/auth/auth_controller.dart';
import 'package:fintech_app/presentation/controllers/user/user_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  final nameController = TextEditingController();
  final isEditing = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          Obx(() => TextButton(
            onPressed: () {
              if (isEditing.value) {
                // Save changes
                userController.updateProfile(
                  nameController.text,
                  null,
                );
              }
              isEditing.value = !isEditing.value;
            },
            child: Text(
              isEditing.value ? 'Save' : 'Edit',
              style: TextStyle(
                color: const Color(0xFF2563EB),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          )),
        ],
      ),
      body: Obx(() {
        final user = userController.userData.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        nameController.text = user.name;

        return SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              // Profile Photo
              GestureDetector(
                onTap: isEditing.value ? () async {
                  final picker = ImagePicker();
                  final image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    // Upload image logic here
                    Get.snackbar('Success', 'Profile photo updated');
                  }
                } : null,
                child: Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: 3.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.r,
                        offset: Offset(0, 5.h),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 48.r,
                    backgroundColor: Colors.transparent,
                    backgroundImage: user.profilePhoto != null
                        ? NetworkImage(user.profilePhoto!)
                        : null,
                    child: user.profilePhoto == null
                        ? Icon(
                      Icons.person,
                      size: 50.sp,
                      color: Colors.white,
                    )
                        : null,
                  ),
                ),
              ),
              if (isEditing.value)
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    'Tap to change photo',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                ),
              SizedBox(height: 24.h),

              // User Details Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        icon: Icons.person_outline,
                        label: 'Name',
                        value: user.name,
                        isEditing: isEditing.value,
                        controller: nameController,
                      ),
                      Divider(height: 24.h),
                      _buildInfoRow(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: user.email,
                        isEditing: false,
                      ),
                      Divider(height: 24.h),
                      _buildInfoRow(
                        icon: Icons.code,
                        label: 'Referral Code',
                        value: user.referralCode,
                        isEditing: false,
                      ),
                      Divider(height: 24.h),
                      _buildInfoRow(
                        icon: Icons.people_outline,
                        label: 'Referrals',
                        value: '${user.referralCount} friends',
                        isEditing: false,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Account Settings
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Manage notification preferences',
                      onTap: () {
                        Get.snackbar('Info', 'Notification settings coming soon');
                      },
                    ),
                    Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.security_outlined,
                      title: 'Security',
                      subtitle: 'Change password, 2FA',
                      onTap: () {
                        Get.snackbar('Security', 'Security settings coming soon');
                      },
                    ),
                    Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      subtitle: 'English (US)',
                      onTap: () {
                        Get.snackbar('Info', 'Language settings coming soon');
                      },
                    ),
                    Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'FAQs, Contact us',
                      onTap: () {
                        Get.snackbar('Info', 'Support section coming soon');
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Logout Button
              ElevatedButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.pop();
                            authController.signOut();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50.h),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isEditing,
    TextEditingController? controller,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: Colors.grey.shade600),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: Colors.grey.shade500,
                ),
              ),
              SizedBox(height: 4.h),
              isEditing && controller != null
                  ? TextFormField(
                controller: controller,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                ),
              )
                  : Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2563EB)),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 12.sp,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Icon(Icons.chevron_right, size: 20.sp),
      onTap: onTap,
    );
  }
}