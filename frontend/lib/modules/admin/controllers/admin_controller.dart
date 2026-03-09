import 'package:get/get.dart';
import '../../../data/providers/admin_service.dart';
import '../../../core/utils/ui_utils.dart';

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
      if (statsResult.containsKey('error')) {
        AppUIUtils.showError('Failed to fetch stats: ${statsResult['error']}');
      } else {
        stats.value = statsResult;
      }

      final ordersResult = await adminService.getAllOrders();
      orders.value = ordersResult;

      final restaurantsResult = await adminService.getAllRestaurants();
      restaurants.value = restaurantsResult;
    } catch (e) {
      AppUIUtils.showError('Failed to synchronize admin data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteRestaurant(String id) async {
    isLoading.value = true;
    try {
      final success = await adminService.deleteRestaurant(id);
      if (success) {
        AppUIUtils.showSuccess('Restaurant decommissioned successfully');
        await fetchData();
      } else {
        AppUIUtils.showError('Permission denied or restaurant not found');
      }
    } catch (e) {
      AppUIUtils.showError('An error occurred while deleting restaurant');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(String id, String status) async {
    isLoading.value = true;
    try {
      final success = await adminService.updateOrderStatus(id, status);
      if (success) {
        AppUIUtils.showSuccess('Order status transitioned to $status');
        await fetchData();
      } else {
        AppUIUtils.showError('Failed to update order status');
      }
    } catch (e) {
      AppUIUtils.showError('Communication error during status update');
    } finally {
      isLoading.value = false;
    }
  }
}
