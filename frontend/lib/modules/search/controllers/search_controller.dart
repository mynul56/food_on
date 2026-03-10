import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/restaurant_service.dart';

class SearchController extends GetxController {
  final RestaurantService _restaurantService = Get.find<RestaurantService>();

  final TextEditingController searchTextController = TextEditingController();

  var allRestaurants = <dynamic>[].obs;
  var filteredRestaurants = <dynamic>[].obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAll();
    debounce(
      searchQuery,
      (_) => _filter(),
      time: const Duration(milliseconds: 300),
    );
  }

  Future<void> _loadAll() async {
    isLoading.value = true;
    final results = await _restaurantService.getRestaurants();
    allRestaurants.assignAll(results);
    filteredRestaurants.assignAll(results);
    isLoading.value = false;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void _filter() {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) {
      filteredRestaurants.assignAll(allRestaurants);
      return;
    }
    filteredRestaurants.assignAll(
      allRestaurants.where((r) {
        final name = (r['name'] ?? '').toString().toLowerCase();
        final cuisine = (r['cuisine'] ?? '').toString().toLowerCase();
        return name.contains(q) || cuisine.contains(q);
      }).toList(),
    );
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    filteredRestaurants.assignAll(allRestaurants);
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}
