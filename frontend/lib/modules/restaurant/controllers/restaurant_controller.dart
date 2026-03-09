import 'package:get/get.dart';
import '../../../data/providers/restaurant_service.dart';

class RestaurantController extends GetxController {
  final restaurantService = Get.find<RestaurantService>();
  final int restaurantId = Get.arguments['id'];

  var restaurant = {}.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    isLoading.value = true;
    final result = await restaurantService.getRestaurantById(restaurantId);
    restaurant.value = result;
    isLoading.value = false;
  }
}
