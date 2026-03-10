import 'package:get/get.dart';
import '../../../data/providers/restaurant_service.dart';

class HomeController extends GetxController {
  final restaurantService = Get.put(RestaurantService());

  var restaurants = <dynamic>[].obs;
  var allRestaurants = <dynamic>[].obs;
  var isLoading = true.obs;
  var isRefreshing = false.obs;
  var selectedCategory = 'All'.obs;
  var errorMessage = ''.obs;

  final categories = [
    {'name': 'All', 'icon': '🍴'},
    {'name': 'Burger', 'icon': '🍔'},
    {'name': 'Pizza', 'icon': '🍕'},
    {'name': 'Sushi', 'icon': '🍣'},
    {'name': 'Chicken', 'icon': '🍗'},
    {'name': 'Dessert', 'icon': '🍰'},
    {'name': 'Drinks', 'icon': '🥤'},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants({bool refresh = false}) async {
    errorMessage.value = '';
    if (refresh) {
      isRefreshing.value = true;
    } else {
      isLoading.value = true;
    }
    try {
      final result = await restaurantService.getRestaurants();
      allRestaurants.assignAll(result);
      _applyFilter();
    } catch (e) {
      errorMessage.value = 'Failed to load restaurants. Pull to refresh.';
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    _applyFilter();
  }

  void _applyFilter() {
    if (selectedCategory.value == 'All') {
      restaurants.assignAll(allRestaurants);
    } else {
      restaurants.assignAll(
        allRestaurants.where((r) {
          final name = (r['name'] ?? '').toString().toLowerCase();
          final cuisine = (r['cuisine'] ?? '').toString().toLowerCase();
          return name.contains(selectedCategory.value.toLowerCase()) ||
              cuisine.contains(selectedCategory.value.toLowerCase());
        }).toList(),
      );
    }
  }
}
