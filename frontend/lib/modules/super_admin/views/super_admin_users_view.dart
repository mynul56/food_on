import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/super_admin_controller.dart';

class SuperAdminUsersView extends GetView<SuperAdminController> {
  const SuperAdminUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Manage Users',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2D3D), fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E2D3D)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(
              children: [
                // Search bar
                TextField(
                  onChanged: (v) {
                    controller.searchQuery.value = v;
                    controller.fetchUsers();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by name or email…',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
                    filled: true,
                    fillColor: const Color(0xFFF5F6FA),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 8),
                // Role filter chips
                Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['all', 'user', 'admin', 'superadmin', 'restaurant', 'driver'].map((role) {
                        final active = controller.roleFilter.value == role;
                        return GestureDetector(
                          onTap: () {
                            controller.roleFilter.value = role;
                            controller.fetchUsers();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: active ? AppTheme.primaryColor : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: active ? AppTheme.primaryColor : Colors.grey.shade200),
                            ),
                            child: Text(
                              role == 'all' ? 'All' : role.capitalize ?? role,
                              style: TextStyle(
                                color: active ? Colors.white : Colors.grey[600],
                                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingUsers.value && controller.users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.users.isEmpty) {
          return const Center(
            child: Text('No users found', style: TextStyle(color: Colors.grey)),
          );
        }
        return RefreshIndicator(
          onRefresh: () => controller.fetchUsers(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.users.length + 1,
            itemBuilder: (ctx, i) {
              if (i == controller.users.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Obx(
                    () => controller.users.length < controller.userTotal.value
                        ? TextButton.icon(
                            onPressed: () => controller.fetchUsers(reset: false),
                            icon: const Icon(Icons.expand_more),
                            label: const Text('Load more'),
                          )
                        : const SizedBox.shrink(),
                  ),
                );
              }
              final user = controller.users[i];
              return _UserCard(user: user, controller: controller);
            },
          ),
        );
      }),
    );
  }
}

class _UserCard extends StatelessWidget {
  final dynamic user;
  final SuperAdminController controller;
  const _UserCard({required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
    final role = user['role'] ?? 'user';
    final isActive = user['isActive'] != false;
    final roleColors = {
      'superadmin': Colors.purple,
      'admin': Colors.blue,
      'restaurant': Colors.orange,
      'driver': Colors.teal,
      'user': Colors.green,
    };
    final color = roleColors[role] ?? Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)],
        border: isActive ? null : Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Center(
              child: Text(
                (user['name'] ?? 'U').toString().isNotEmpty ? (user['name'] ?? 'U')[0].toUpperCase() : 'U',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'] ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2D3D)),
                ),
                Text(user['email'] ?? '', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        role,
                        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (!isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                        child: const Text(
                          'Inactive',
                          style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            onSelected: (action) {
              switch (action) {
                case 'make_admin':
                  controller.updateUserRole('${user['id']}', 'admin');
                  break;
                case 'make_superadmin':
                  controller.updateUserRole('${user['id']}', 'superadmin');
                  break;
                case 'make_user':
                  controller.updateUserRole('${user['id']}', 'user');
                  break;
                case 'make_restaurant':
                  controller.updateUserRole('${user['id']}', 'restaurant');
                  break;
                case 'toggle_active':
                  controller.toggleUserStatus('${user['id']}', isActive);
                  break;
                case 'delete':
                  Get.defaultDialog(
                    title: 'Delete User',
                    middleText: 'Are you sure? This cannot be undone.',
                    textConfirm: 'Delete',
                    textCancel: 'Cancel',
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    onConfirm: () {
                      Get.back();
                      controller.deleteUser('${user['id']}');
                    },
                  );
                  break;
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'make_user', child: Text('Set as User')),
              const PopupMenuItem(value: 'make_admin', child: Text('Set as Admin')),
              const PopupMenuItem(value: 'make_restaurant', child: Text('Set as Restaurant Admin')),
              const PopupMenuItem(value: 'make_superadmin', child: Text('Set as Super Admin')),
              PopupMenuItem(value: 'toggle_active', child: Text(isActive ? 'Deactivate' : 'Activate')),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
