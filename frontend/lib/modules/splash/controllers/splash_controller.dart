import 'package:get/get.dart';
import '../../../data/providers/auth_service.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startAnimationAndNavigate();
  }

  void _startAnimationAndNavigate() async {
    // Artificial 2-second delay to show the logo
    await Future.delayed(const Duration(seconds: 2));

    // Check auth status
    final authService = Get.find<AuthService>();
    final token = authService.token;

    if (token != null && token.isNotEmpty) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }
}
