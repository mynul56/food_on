import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../../../data/providers/restaurant_service.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchController>(() => SearchController());
    if (!Get.isRegistered<RestaurantService>()) {
      Get.lazyPut<RestaurantService>(() => RestaurantService());
    }
  }
}
