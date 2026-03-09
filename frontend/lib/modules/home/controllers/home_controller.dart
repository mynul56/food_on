import 'package:get/get.dart';
import '../../../data/providers/restaurant_service.dart';

class HomeController extends GetxController {
  final restaurantService = Get.put(RestaurantService());

  var restaurants = <dynamic>[].obs;
  var isLoading = true.obs;
  var selectedCategory = 'All'.obs;

  final categories = [
    {'name': 'All', 'icon': '🍴'},
    {'name': 'Burger', 'icon': '🍔'},
    {'name': 'Pizza', 'icon': '🍕'},
    {'name': 'Sushi', 'icon': '🍣'},
    {'name': 'Dessert', 'icon': '🍰'},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    isLoading.value = true;
    final result = await restaurantService.getRestaurants();
    restaurants.assignAll(result);
    isLoading.value = false;
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    // In a real app, we'd fetch filtered data from API
  }
}
