import 'package:get/get.dart';
import '../../../data/providers/admin_service.dart';
import '../controllers/admin_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminService>(() => AdminService());
    Get.lazyPut<AdminController>(() => AdminController());
  }
}
