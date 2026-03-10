import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../search/controllers/search_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CartController(), permanent: true);
    Get.put(NotificationsController(), permanent: true);
    Get.lazyPut(() => SearchController());
    Get.lazyPut(() => HomeController());
  }
}
