import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/theme/app_theme.dart';
import 'data/providers/auth_service.dart';
import 'data/providers/socket_service.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = Get.put(AuthService(), permanent: true);
  await authService.waitForInit();
  Get.put(SocketService(), permanent: true);
  runApp(const FoodOnApp());
}

class FoodOnApp extends StatelessWidget {
  const FoodOnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Food ON',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
