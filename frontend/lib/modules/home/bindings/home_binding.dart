import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // CartController is permanent so it persists across all routes
    Get.put(CartController(), permanent: true);
    Get.lazyPut(() => HomeController());
  }
}
