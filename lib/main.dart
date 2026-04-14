import 'package:fintech_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fintech_app/core/routes/app_routes.dart';
import 'package:fintech_app/core/theme/app_theme.dart';
import 'package:fintech_app/presentation/controllers/auth/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp.router(
          title: 'FinTech App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          routerDelegate: AppRoutes.router.routerDelegate,
          routeInformationParser: AppRoutes.router.routeInformationParser,
          routeInformationProvider: AppRoutes.router.routeInformationProvider,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}