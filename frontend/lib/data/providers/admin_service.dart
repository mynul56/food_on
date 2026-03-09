import 'package:get/get.dart';
import '../../core/utils/constants.dart';
import '../../routes/app_pages.dart';
import 'auth_service.dart';

class AdminService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppConstants.apiUrl;
    httpClient.addRequestModifier<dynamic>((request) {
      final token = Get.find<AuthService>().token;
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
    httpClient.addResponseModifier<dynamic>((request, response) {
      if (response.statusCode == 401) {
        Get.find<AuthService>().logout();
        Get.offAllNamed(AppRoutes.login);
        Get.snackbar('Session Expired', 'Please login again');
      }
      return response;
    });
    super.onInit();
  }

  Future<Map<String, dynamic>> getStats() async {
    final response = await get('/admin/stats');
    if (response.status.hasError) {
      return {'error': response.statusText};
    }
    return response.body;
  }

  Future<List<dynamic>> getAllOrders() async {
    final response = await get('/orders/all');
    if (response.status.hasError) {
      return [];
    }
    return response.body as List<dynamic>;
  }

  Future<bool> updateOrderStatus(String id, String status) async {
    final response = await patch('/orders/$id/status', {'status': status});
    return !response.status.hasError;
  }

  Future<List<dynamic>> getAllRestaurants() async {
    final response = await get('/restaurants');
    if (response.status.hasError) {
      return [];
    }
    return response.body as List<dynamic>;
  }

  Future<bool> deleteRestaurant(String id) async {
    final response = await delete('/restaurants/$id');
    return !response.status.hasError;
  }
}
