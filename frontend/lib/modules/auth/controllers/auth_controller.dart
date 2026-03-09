import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/auth_service.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final authService = Get.find<AuthService>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    isLoading.value = true;
    final result = await authService.login(
      emailController.text,
      passwordController.text,
    );
    isLoading.value = false;

    if (result['token'] != null) {
      final user = result['user'];
      if (user != null && user['role'] == 'admin') {
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    } else {
      Get.snackbar('Error', result['message'] ?? 'Login failed');
    }
  }

  Future<void> register() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    isLoading.value = true;
    final result = await authService.register({
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
    });
    isLoading.value = false;

    if (result['token'] != null) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.snackbar('Error', result['message'] ?? 'Registration failed');
    }
  }
}
