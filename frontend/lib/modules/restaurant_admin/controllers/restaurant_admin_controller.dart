import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/ui_utils.dart';
import '../../../data/providers/auth_service.dart';

class RestaurantAdminController extends GetxController {
  final _auth = Get.find<AuthService>();
  final _dio = Dio();

  final isLoadingMenu = false.obs;
  final isLoadingRestaurant = false.obs;
  final isSaving = false.obs;

  final menuItems = <dynamic>[].obs;
  final restaurant = <String, dynamic>{}.obs;
  final selectedCategory = 'All'.obs;

  final categories = <String>['All'];

  String? get restaurantId => _auth.currentUser?['restaurantId']?.toString();

  @override
  void onInit() {
    super.onInit();
    fetchRestaurant();
    fetchMenuItems();
  }

  String get _token => _auth.token ?? '';

  Map<String, String> get _headers => {'Authorization': 'Bearer $_token', 'Content-Type': 'application/json'};

  Future<void> fetchRestaurant() async {
    final rId = restaurantId;
    if (rId == null) return;
    isLoadingRestaurant.value = true;
    try {
      final resp = await http.get(Uri.parse('${AppConstants.apiUrl}/restaurants/$rId'), headers: _headers);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        restaurant.value = data;
      }
    } catch (_) {
      AppUIUtils.showError('Failed to load restaurant');
    } finally {
      isLoadingRestaurant.value = false;
    }
  }

  Future<void> fetchMenuItems() async {
    final rId = restaurantId;
    if (rId == null) return;
    isLoadingMenu.value = true;
    try {
      final resp = await http.get(Uri.parse('${AppConstants.apiUrl}/menu/restaurant/$rId'), headers: _headers);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as List;
        menuItems.value = data;
        // Build category list
        final cats = {'All', ...data.map((e) => e['category']?.toString() ?? 'Other')};
        categories
          ..clear()
          ..addAll(cats.toList());
      }
    } catch (_) {
      AppUIUtils.showError('Failed to load menu items');
    } finally {
      isLoadingMenu.value = false;
    }
  }

  List get filteredItems {
    if (selectedCategory.value == 'All') return menuItems;
    return menuItems.where((e) => e['category'] == selectedCategory.value).toList();
  }

  Future<void> addOrUpdateMenuItem({
    String? itemId,
    required String name,
    required String description,
    required double price,
    required String category,
    required bool isVeg,
    required bool isAvailable,
    String? imageUrl,
    XFile? imageFile,
  }) async {
    final rId = restaurantId;
    if (rId == null) return;
    isSaving.value = true;
    try {
      final uri = itemId != null ? '${AppConstants.apiUrl}/menu/$itemId' : '${AppConstants.apiUrl}/menu';
      final method = itemId != null ? 'PUT' : 'POST';

      FormData formData = FormData.fromMap({
        'restaurantId': rId,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'isVeg': isVeg.toString(),
        'isAvailable': isAvailable.toString(),
        if (imageUrl != null && imageUrl.isNotEmpty) 'imageUrl': imageUrl,
        if (imageFile != null) 'image': await MultipartFile.fromFile(imageFile.path, filename: imageFile.name),
      });

      final resp = method == 'POST'
          ? await _dio.post(
              uri,
              data: formData,
              options: Options(headers: {'Authorization': 'Bearer $_token'}),
            )
          : await _dio.put(
              uri,
              data: formData,
              options: Options(headers: {'Authorization': 'Bearer $_token'}),
            );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        AppUIUtils.showSuccess(itemId != null ? 'Menu item updated' : 'Menu item added');
        await fetchMenuItems();
      } else {
        AppUIUtils.showError('Failed to save menu item');
      }
    } catch (e) {
      AppUIUtils.showError('Error saving menu item');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteMenuItem(String itemId) async {
    try {
      final resp = await http.delete(Uri.parse('${AppConstants.apiUrl}/menu/$itemId'), headers: _headers);
      if (resp.statusCode == 200) {
        AppUIUtils.showSuccess('Item deleted');
        menuItems.removeWhere((e) => '${e['id']}' == itemId);
      } else {
        AppUIUtils.showError('Failed to delete item');
      }
    } catch (_) {
      AppUIUtils.showError('Error');
    }
  }

  Future<void> toggleItemAvailability(String itemId, bool current) async {
    try {
      final resp = await http.put(
        Uri.parse('${AppConstants.apiUrl}/menu/$itemId'),
        headers: _headers,
        body: jsonEncode({'isAvailable': !current}),
      );
      if (resp.statusCode == 200) {
        final idx = menuItems.indexWhere((e) => '${e['id']}' == itemId);
        if (idx != -1) {
          menuItems[idx] = {...menuItems[idx] as Map, 'isAvailable': !current};
          menuItems.refresh();
        }
      }
    } catch (_) {}
  }

  Future<void> updateRestaurantInfo(Map<String, dynamic> data) async {
    final rId = restaurantId;
    if (rId == null) return;
    try {
      final resp = await http.put(
        Uri.parse('${AppConstants.apiUrl}/restaurants/$rId'),
        headers: _headers,
        body: jsonEncode(data),
      );
      if (resp.statusCode == 200) {
        AppUIUtils.showSuccess('Restaurant updated');
        fetchRestaurant();
      } else {
        AppUIUtils.showError('Failed to update restaurant');
      }
    } catch (_) {
      AppUIUtils.showError('Error');
    }
  }
}
