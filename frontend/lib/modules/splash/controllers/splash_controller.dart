import 'package:get/get.dart';

import '../../../data/providers/auth_service.dart';
import '../../../data/providers/socket_service.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startAnimationAndNavigate();
  }

  void _startAnimationAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final authService = Get.find<AuthService>();
    final token = authService.token;

    if (token != null && token.isNotEmpty) {
      final user = authService.currentUser;
      final role = user?['role'] ?? 'user';

      // Reconnect socket for returning user
      final socket = Get.find<SocketService>();
      if (user != null) socket.joinUserRoom('${user['id']}');

      if (role == 'superadmin') {
        Get.offAllNamed(AppRoutes.superAdminDashboard);
      } else if (role == 'admin' || role == 'restaurant') {
        Get.offAllNamed(AppRoutes.restaurantAdminDashboard);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }
}
