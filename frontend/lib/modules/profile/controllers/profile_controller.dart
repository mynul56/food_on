import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/constants.dart';
import '../../../data/providers/auth_service.dart';

class ProfileController extends GetxController {
  final _authService = Get.find<AuthService>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  var isLoading = false.obs;
  var isSaving = false.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;
  var userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    fetchProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.userKey);
    if (userJson != null) {
      final user = jsonDecode(userJson) as Map<String, dynamic>;
      userName.value = user['name'] ?? '';
      userEmail.value = user['email'] ?? '';
      userPhone.value = user['phone'] ?? '';
      userRole.value = user['role'] ?? 'user';
      nameController.text = userName.value;
      emailController.text = userEmail.value;
      phoneController.text = userPhone.value;
    }
  }

  Future<void> fetchProfile() async {
    final token = _authService.token;
    if (token == null) return;
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.apiUrl}/auth/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        userName.value = data['name'] ?? '';
        userEmail.value = data['email'] ?? '';
        userPhone.value = data['phone'] ?? '';
        userRole.value = data['role'] ?? 'user';
        nameController.text = userName.value;
        emailController.text = userEmail.value;
        phoneController.text = userPhone.value;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.userKey, jsonEncode(data));
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    final token = _authService.token;
    if (token == null) return;
    isSaving.value = true;
    try {
      final response = await http.put(
        Uri.parse('${AppConstants.apiUrl}/auth/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        userName.value = data['name'] ?? nameController.text.trim();
        final prefs = await SharedPreferences.getInstance();
        final userJson = prefs.getString(AppConstants.userKey);
        if (userJson != null) {
          final user = jsonDecode(userJson) as Map<String, dynamic>;
          user['name'] = data['name'] ?? nameController.text.trim();
          user['phone'] = data['phone'] ?? phoneController.text.trim();
          await prefs.setString(AppConstants.userKey, jsonEncode(user));
        }
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E2D3D),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update profile. Try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (_) {
      Get.snackbar(
        'Error',
        'Connection error. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isSaving.value = false;
    }
  }

  void logout() {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textConfirm: 'Logout',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFFF4B2B),
      onConfirm: () async {
        await _authService.logout();
        Get.offAllNamed('/login');
      },
    );
  }
}
