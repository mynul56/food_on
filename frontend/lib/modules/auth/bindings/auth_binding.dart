import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../data/providers/auth_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => AuthController());
  }
}
