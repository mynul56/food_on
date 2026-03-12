import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../../main/controllers/main_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.all(50),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Personal Info Card ---
                    _sectionLabel('Personal Information'),
                    const SizedBox(height: 12),
                    _card(
                      child: Column(
                        children: [
                          _inputField(
                            label: 'Full Name',
                            icon: Icons.person_outline_rounded,
                            textController: controller.nameController,
                          ),
                          const SizedBox(height: 14),
                          _inputField(
                            label: 'Email',
                            icon: Icons.email_outlined,
                            textController: controller.emailController,
                            enabled: false,
                          ),
                          const SizedBox(height: 14),
                          _inputField(
                            label: 'Phone Number',
                            icon: Icons.phone_outlined,
                            textController: controller.phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 18),
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: controller.isSaving.value ? null : controller.updateProfile,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: controller.isSaving.value
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                                      )
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.save_rounded, size: 18),
                                          SizedBox(width: 8),
                                          Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- Quick Actions ---
                    _sectionLabel('Account'),
                    const SizedBox(height: 12),
                    _card(
                      child: Column(
                        children: [
                          _actionTile(
                            icon: Icons.shopping_bag_outlined,
                            label: 'My Orders',
                            subtitle: 'Track your past orders',
                            color: const Color(0xFF5B8DEF),
                            onTap: () => Get.find<MainController>().goToTab(2),
                          ),
                          _divider(),
                          _actionTile(
                            icon: Icons.location_on_outlined,
                            label: 'Saved Addresses',
                            subtitle: 'Manage delivery locations',
                            color: const Color(0xFF2ECC71),
                            onTap: () => Get.toNamed(AppRoutes.address),
                          ),
                          _divider(),
                          _actionTile(
                            icon: Icons.notifications_outlined,
                            label: 'Notifications',
                            subtitle: 'Order updates & offers',
                            color: const Color(0xFFF4A041),
                            onTap: () => Get.toNamed(AppRoutes.notifications),
                          ),
                          _divider(),
                          _actionTile(
                            icon: Icons.help_outline_rounded,
                            label: 'Help & Support',
                            subtitle: 'support@foodon.app',
                            color: const Color(0xFF9B59B6),
                            onTap: () => Get.snackbar(
                              'Help & Support',
                              'Email us at support@foodon.app',
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- App Settings ---
                    _sectionLabel('Settings'),
                    const SizedBox(height: 12),
                    _card(
                      child: Column(
                        children: [
                          _actionTile(
                            icon: Icons.language_rounded,
                            label: 'Language',
                            subtitle: 'English',
                            color: Colors.teal,
                            onTap: () {},
                          ),
                          _divider(),
                          _actionTile(
                            icon: Icons.privacy_tip_outlined,
                            label: 'Privacy Policy',
                            subtitle: 'How we use your data',
                            color: Colors.blueGrey,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- Sign Out ---
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton.icon(
                        onPressed: controller.logout,
                        icon: const Icon(Icons.logout_rounded, color: AppTheme.primaryColor),
                        label: const Text(
                          'Sign Out',
                          style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppTheme.secondaryColor,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E2D3D), Color(0xFF2D4A6E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.04)),
                ),
              ),
              Positioned(
                left: -20,
                bottom: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.04)),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Obx(
                      () => GestureDetector(
                        onTap: controller.pickAndUploadProfilePicture,
                        child: Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppTheme.primaryColor, AppTheme.primaryLight],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withValues(alpha: 0.4),
                                    blurRadius: 14,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: controller.userProfilePicture.value.isNotEmpty
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: controller.userProfilePicture.value,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => const CircularProgressIndicator(),
                                        errorWidget: (_, __, ___) => Center(
                                          child: Text(
                                            controller.userName.value.isNotEmpty
                                                ? controller.userName.value[0].toUpperCase()
                                                : 'U',
                                            style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        controller.userName.value.isNotEmpty
                                            ? controller.userName.value[0].toUpperCase()
                                            : 'U',
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.primaryColor, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt_rounded, size: 14, color: AppTheme.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => Text(
                        controller.userName.value.isNotEmpty ? controller.userName.value : 'User',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          controller.userRole.value.capitalize ?? 'User',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E2D3D)),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Divider(color: Colors.grey[100], thickness: 1),
    );
  }

  Widget _inputField({
    required String label,
    required IconData icon,
    required TextEditingController textController,
    TextInputType? keyboardType,
    bool enabled = true,
  }) {
    return TextField(
      controller: textController,
      keyboardType: keyboardType,
      enabled: enabled,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
        prefixIcon: Icon(icon, size: 19, color: AppTheme.primaryColor),
        filled: true,
        fillColor: enabled ? const Color(0xFFF9F9F9) : const Color(0xFFF0F0F0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey[100]!),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(13)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E2D3D)),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
