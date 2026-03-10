import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/constants.dart';
import '../../core/utils/ui_utils.dart';
import '../../data/providers/auth_service.dart';

class SuperAdminController extends GetxController {
  final _auth = Get.find<AuthService>();

  final isLoadingStats = false.obs;
  final isLoadingUsers = false.obs;
  final isLoadingRestaurants = false.obs;

  final stats = <String, dynamic>{}.obs;
  final users = <dynamic>[].obs;
  final restaurants = <dynamic>[].obs;
  final revenueByDay = <dynamic>[].obs;
  final ordersByStatus = <dynamic>[].obs;
  final topRestaurants = <dynamic>[].obs;

  int userPage = 1;
  final userTotal = 0.obs;
  final searchQuery = ''.obs;
  final roleFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStats();
    fetchUsers();
    fetchRestaurants();
  }

  String get _token => _auth.token ?? '';

  Map<String, String> get _headers => {'Authorization': 'Bearer $_token', 'Content-Type': 'application/json'};

  Future<void> fetchStats() async {
    isLoadingStats.value = true;
    try {
      final resp = await http.get(Uri.parse('${AppConstants.apiUrl}/admin/stats'), headers: _headers);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        stats.value = data;
        revenueByDay.value = (data['revenueByDay'] as List?) ?? [];
        ordersByStatus.value = (data['ordersByStatus'] as List?) ?? [];
        topRestaurants.value = (data['topRestaurants'] as List?) ?? [];
      }
    } catch (e) {
      AppUIUtils.showError('Failed to load stats');
    } finally {
      isLoadingStats.value = false;
    }
  }

  Future<void> fetchUsers({bool reset = true}) async {
    if (reset) {
      userPage = 1;
      users.clear();
    }
    isLoadingUsers.value = true;
    try {
      final params = {
        'page': '$userPage',
        'limit': '20',
        if (searchQuery.value.isNotEmpty) 'search': searchQuery.value,
        if (roleFilter.value != 'all') 'role': roleFilter.value,
      };
      final resp = await http.get(
        Uri.parse('${AppConstants.apiUrl}/admin/users').replace(queryParameters: params),
        headers: _headers,
      );
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final newUsers = (data['users'] as List?) ?? [];
        if (reset) {
          users.value = newUsers;
        } else {
          users.addAll(newUsers);
        }
        userTotal.value = data['total'] ?? 0;
        userPage++;
      }
    } catch (e) {
      AppUIUtils.showError('Failed to load users');
    } finally {
      isLoadingUsers.value = false;
    }
  }

  Future<void> fetchRestaurants() async {
    isLoadingRestaurants.value = true;
    try {
      final resp = await http.get(Uri.parse('${AppConstants.apiUrl}/restaurants'), headers: _headers);
      if (resp.statusCode == 200) {
        restaurants.value = jsonDecode(resp.body) as List;
      }
    } catch (_) {
      AppUIUtils.showError('Failed to load restaurants');
    } finally {
      isLoadingRestaurants.value = false;
    }
  }

  Future<void> updateUserRole(String userId, String role) async {
    try {
      final resp = await http.put(
        Uri.parse('${AppConstants.apiUrl}/admin/users/$userId'),
        headers: _headers,
        body: jsonEncode({'role': role}),
      );
      if (resp.statusCode == 200) {
        AppUIUtils.showSuccess('Role updated to $role');
        fetchUsers();
      } else {
        AppUIUtils.showError('Failed to update role');
      }
    } catch (_) {
      AppUIUtils.showError('Error updating role');
    }
  }

  Future<void> toggleUserStatus(String userId, bool currentStatus) async {
    try {
      final resp = await http.put(
        Uri.parse('${AppConstants.apiUrl}/admin/users/$userId'),
        headers: _headers,
        body: jsonEncode({'isActive': !currentStatus}),
      );
      if (resp.statusCode == 200) {
        AppUIUtils.showSuccess(!currentStatus ? 'User activated' : 'User deactivated');
        fetchUsers();
      } else {
        AppUIUtils.showError('Failed to update user status');
      }
    } catch (_) {
      AppUIUtils.showError('Error');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final resp = await http.delete(Uri.parse('${AppConstants.apiUrl}/admin/users/$userId'), headers: _headers);
      if (resp.statusCode == 200) {
        AppUIUtils.showSuccess('User deleted');
        fetchUsers();
      } else {
        AppUIUtils.showError('Failed to delete user');
      }
    } catch (_) {
      AppUIUtils.showError('Error deleting user');
    }
  }

  Future<void> deleteRestaurant(String id) async {
    try {
      final resp = await http.delete(Uri.parse('${AppConstants.apiUrl}/restaurants/$id'), headers: _headers);
      if (resp.statusCode == 200) {
        AppUIUtils.showSuccess('Restaurant removed');
        fetchRestaurants();
        fetchStats();
      } else {
        AppUIUtils.showError('Failed to delete restaurant');
      }
    } catch (_) {
      AppUIUtils.showError('Error');
    }
  }

  Future<void> addRestaurant(Map<String, dynamic> data) async {
    try {
      final resp = await http.post(
        Uri.parse('${AppConstants.apiUrl}/restaurants'),
        headers: _headers,
        body: jsonEncode(data),
      );
      if (resp.statusCode == 201) {
        AppUIUtils.showSuccess('Restaurant added');
        fetchRestaurants();
        fetchStats();
      } else {
        AppUIUtils.showError('Failed to add restaurant');
      }
    } catch (_) {
      AppUIUtils.showError('Error adding restaurant');
    }
  }

  Future<void> updateRestaurant(String id, Map<String, dynamic> data) async {
    try {
      final resp = await http.put(
        Uri.parse('${AppConstants.apiUrl}/restaurants/$id'),
        headers: _headers,
        body: jsonEncode(data),
      );
      if (resp.statusCode == 200) {
        AppUIUtils.showSuccess('Restaurant updated');
        fetchRestaurants();
      } else {
        AppUIUtils.showError('Failed to update restaurant');
      }
    } catch (_) {
      AppUIUtils.showError('Error updating restaurant');
    }
  }
}
