import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/views/cart_view.dart';
import '../../home/views/home_view.dart';
import '../../orders/views/order_tracking_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  static const List<Widget> _tabs = [HomeView(), CartView(), OrderTrackingView(), ProfileView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      extendBody: true,
      body: Obx(() => IndexedStack(index: controller.currentIndex.value, children: _tabs)),
      bottomNavigationBar: _GlassBottomNav(controller: controller),
    );
  }
}

class _GlassBottomNav extends StatelessWidget {
  final MainController controller;
  const _GlassBottomNav({required this.controller});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final cartController = Get.find<CartController>();

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 14 + bottomInset),
          child: Obx(() {
            final idx = controller.currentIndex.value;
            final cartCount = cartController.cartItems.length;

            return Container(
              height: 66,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white.withValues(alpha: 0.92), Colors.white.withValues(alpha: 0.82)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withValues(alpha: 0.60), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 28,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.07),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _NavTab(
                    icon: Icons.home_rounded,
                    outlineIcon: Icons.home_outlined,
                    label: 'Home',
                    index: 0,
                    currentIndex: idx,
                    onTap: () => controller.goToTab(0),
                  ),
                  _NavTab(
                    icon: Icons.shopping_bag_rounded,
                    outlineIcon: Icons.shopping_bag_outlined,
                    label: 'Cart',
                    index: 1,
                    currentIndex: idx,
                    badge: cartCount,
                    onTap: () => controller.goToTab(1),
                  ),
                  _NavTab(
                    icon: Icons.receipt_long_rounded,
                    outlineIcon: Icons.receipt_long_outlined,
                    label: 'Orders',
                    index: 2,
                    currentIndex: idx,
                    onTap: () => controller.goToTab(2),
                  ),
                  _NavTab(
                    icon: Icons.person_rounded,
                    outlineIcon: Icons.person_outline_rounded,
                    label: 'Profile',
                    index: 3,
                    currentIndex: idx,
                    onTap: () => controller.goToTab(3),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  final IconData icon;
  final IconData outlineIcon;
  final String label;
  final int index;
  final int currentIndex;
  final int badge;
  final VoidCallback onTap;

  const _NavTab({
    required this.icon,
    required this.outlineIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryColor.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: Icon(
                      isActive ? icon : outlineIcon,
                      key: ValueKey(isActive),
                      size: 22,
                      color: isActive ? AppTheme.primaryColor : Colors.grey[400],
                    ),
                  ),
                  if (badge > 0)
                    Positioned(
                      top: -5,
                      right: -8,
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
                        child: Text(
                          '$badge',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                  color: isActive ? AppTheme.primaryColor : Colors.grey[400],
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
