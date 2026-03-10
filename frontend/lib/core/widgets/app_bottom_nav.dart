import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modules/cart/controllers/cart_controller.dart';
import '../../routes/app_pages.dart';
import '../theme/app_theme.dart';

/// Shared bottom navigation bar used across Home, Cart, Orders, and Profile screens.
/// Pass [currentIndex]: 0=Home, 1=Cart, 2=Orders, 3=Profile
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  void _onTap(int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        Get.offAllNamed(AppRoutes.home);
        break;
      case 1:
        Get.offAllNamed(AppRoutes.cart);
        break;
      case 2:
        Get.offAllNamed(AppRoutes.orderTracking);
        break;
      case 3:
        Get.offAllNamed(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.isRegistered<CartController>() ? Get.find<CartController>() : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              _NavItem(icon: Icons.home_rounded, label: 'Home', isActive: currentIndex == 0, onTap: () => _onTap(0)),
              // Cart with live badge
              Expanded(
                child: GestureDetector(
                  onTap: () => _onTap(1),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        cartController != null
                            ? Obx(() {
                                final count = cartController.cartItems.length;
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Icon(
                                      currentIndex == 1 ? Icons.shopping_bag_rounded : Icons.shopping_bag_outlined,
                                      color: currentIndex == 1 ? AppTheme.primaryColor : Colors.grey[400],
                                      size: 24,
                                    ),
                                    if (count > 0)
                                      Positioned(
                                        top: -6,
                                        right: -8,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: AppTheme.primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '$count',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              })
                            : Icon(
                                currentIndex == 1 ? Icons.shopping_bag_rounded : Icons.shopping_bag_outlined,
                                color: currentIndex == 1 ? AppTheme.primaryColor : Colors.grey[400],
                                size: 24,
                              ),
                        const SizedBox(height: 4),
                        Text(
                          'Cart',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: currentIndex == 1 ? FontWeight.bold : FontWeight.normal,
                            color: currentIndex == 1 ? AppTheme.primaryColor : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _NavItem(
                icon: currentIndex == 2 ? Icons.receipt_long_rounded : Icons.receipt_long_outlined,
                label: 'Orders',
                isActive: currentIndex == 2,
                onTap: () => _onTap(2),
              ),
              _NavItem(
                icon: currentIndex == 3 ? Icons.person_rounded : Icons.person_outline_rounded,
                label: 'Profile',
                isActive: currentIndex == 3,
                onTap: () => _onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isActive ? AppTheme.primaryColor : Colors.grey[400], size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? AppTheme.primaryColor : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
