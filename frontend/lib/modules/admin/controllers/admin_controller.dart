import 'package:get/get.dart';
import '../../../data/providers/admin_service.dart';

class AdminController extends GetxController {
  final adminService = Get.find<AdminService>();

  var isLoading = false.obs;
  var stats = {}.obs;
  var orders = [].obs;
  var restaurants = [].obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final statsResult = await adminService.getStats();
      stats.value = statsResult;

      final ordersResult = await adminService.getAllOrders();
      orders.value = ordersResult;

      final restaurantsResult = await adminService.getAllRestaurants();
      restaurants.value = restaurantsResult;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch admin data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteRestaurant(String id) async {
    final success = await adminService.deleteRestaurant(id);
    if (success) {
      Get.snackbar('Success', 'Restaurant deleted');
      fetchData();
    } else {
      Get.snackbar('Error', 'Failed to delete restaurant');
    }
  }

  Future<void> updateStatus(String id, String status) async {
    final success = await adminService.updateOrderStatus(id, status);
    if (success) {
      Get.snackbar('Success', 'Order status updated');
      fetchData();
    } else {
      Get.snackbar('Error', 'Failed to update order status');
    }
  }
}
