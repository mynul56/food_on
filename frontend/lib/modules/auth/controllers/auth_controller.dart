import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../core/utils/ui_utils.dart';

class AuthController extends GetxController {
  final authService = Get.find<AuthService>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      AppUIUtils.showError('Please fill all fields');
      return;
    }

    isLoading.value = true;
    try {
      final result = await authService.login(
        emailController.text,
        passwordController.text,
      );

      if (result['token'] != null) {
        final user = result['user'];
        AppUIUtils.showSuccess('Welcome back, ${user['name']}!');
        if (user != null && user['role'] == 'admin') {
          Get.offAllNamed(AppRoutes.adminDashboard);
        } else {
          Get.offAllNamed(AppRoutes.home);
        }
      } else {
        AppUIUtils.showError(result['message'] ?? 'Login failed');
      }
    } catch (e) {
      AppUIUtils.showError('An unexpected error occurred during login');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty) {
      AppUIUtils.showError('Please fill all fields');
      return;
    }

    isLoading.value = true;
    try {
      final result = await authService.register({
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      });

      if (result['token'] != null) {
        AppUIUtils.showSuccess('Registration successful!');
        Get.offAllNamed(AppRoutes.home);
      } else {
        AppUIUtils.showError(result['message'] ?? 'Registration failed');
      }
    } catch (e) {
      AppUIUtils.showError('An unexpected error occurred during registration');
    } finally {
      isLoading.value = false;
    }
  }
}
