import 'package:get/get.dart';

import '../controllers/restaurant_admin_controller.dart';

class RestaurantAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestaurantAdminController>(() => RestaurantAdminController());
  }
}
