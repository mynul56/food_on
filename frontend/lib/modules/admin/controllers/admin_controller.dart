import 'package:get/get.dart';

import '../../../core/utils/ui_utils.dart';
import '../../../data/providers/admin_service.dart';

class AdminController extends GetxController {
  final adminService = Get.find<AdminService>();

  final isLoading = false.obs;
  final stats = <String, dynamic>{}.obs;
  final orders = [].obs;
  final restaurants = [].obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        adminService.getStats(),
        adminService.getAllOrders(),
        adminService.getAllRestaurants(),
      ]);
      stats.value = results[0] as Map<String, dynamic>;
      orders.value = results[1] as List;
      restaurants.value = results[2] as List;
    } catch (e) {
      AppUIUtils.showError('Failed to load admin data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addRestaurant(Map<String, dynamic> data) async {
    try {
      final success = await adminService.createRestaurant(data);
      if (success) {
        AppUIUtils.showSuccess('Restaurant added successfully');
        await fetchData();
      } else {
        AppUIUtils.showError('Failed to add restaurant');
      }
    } catch (e) {
      AppUIUtils.showError('Error adding restaurant');
    }
  }

  Future<void> deleteRestaurant(String id) async {
    try {
      final success = await adminService.deleteRestaurant(id);
      if (success) {
        AppUIUtils.showSuccess('Restaurant removed');
        await fetchData();
      } else {
        AppUIUtils.showError('Failed to delete restaurant');
      }
    } catch (e) {
      AppUIUtils.showError('Error deleting restaurant');
    }
  }

  Future<void> updateStatus(String id, String status) async {
    try {
      final success = await adminService.updateOrderStatus(id, status);
      if (success) {
        AppUIUtils.showSuccess('Order status updated to $status');
        await fetchData();
      } else {
        AppUIUtils.showError('Failed to update order status');
      }
    } catch (e) {
      AppUIUtils.showError('Error updating order status');
    }
  }
}
