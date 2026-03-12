import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/ui_utils.dart';
import '../../../data/providers/auth_service.dart';
import '../../../data/providers/socket_service.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final authService = Get.find<AuthService>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;

  void toggleObscurePassword() => obscurePassword.toggle();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      AppUIUtils.showError('Please fill all fields');
      return;
    }

    isLoading.value = true;
    try {
      final result = await authService.login(email, password);

      if (result['token'] != null) {
        final user = result['user'];
        AppUIUtils.showSuccess('Welcome back, ${user['name']}!');

        // Connect socket for this user
        final socket = Get.find<SocketService>();
        socket.joinUserRoom('${user['id']}');

        final role = user['role'] ?? 'user';
        if (role == 'superadmin') {
          Get.offAllNamed(AppRoutes.superAdminDashboard);
        } else if (role == 'admin' || role == 'restaurant') {
          Get.offAllNamed(AppRoutes.restaurantAdminDashboard);
        } else {
          Get.offAllNamed(AppRoutes.main);
        }
      } else {
        AppUIUtils.showError(result['message'] ?? 'Login failed');
      }
    } catch (e) {
      AppUIUtils.showError('An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      AppUIUtils.showError('Please fill all required fields');
      return;
    }
    if (password.length < 6) {
      AppUIUtils.showError('Password must be at least 6 characters');
      return;
    }

    isLoading.value = true;
    try {
      final result = await authService.register({
        'name': name,
        'email': email,
        'password': password,
        if (phoneController.text.trim().isNotEmpty) 'phoneNumber': phoneController.text.trim(),
      });

      if (result['token'] != null) {
        AppUIUtils.showSuccess('Account created successfully!');
        final socket = Get.find<SocketService>();
        final user = result['user'];
        if (user != null) socket.joinUserRoom('${user['id']}');
        Get.offAllNamed(AppRoutes.main);
      } else {
        AppUIUtils.showError(result['message'] ?? 'Registration failed');
      }
    } catch (e) {
      AppUIUtils.showError('An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }
}
