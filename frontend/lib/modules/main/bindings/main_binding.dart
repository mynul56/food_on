import 'package:get/get.dart';

import '../../cart/controllers/cart_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(NotificationsController(), permanent: true);
    Get.lazyPut(() => SearchController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ProfileController());
  }
}
