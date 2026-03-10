import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../routes/app_pages.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    // Explicitly find or put the controller in case binding fails
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController(), permanent: true);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: _buildAppBar(context),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: Obx(
        () => controller.cartItems.isEmpty
            ? _buildEmptyCart()
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      itemCount: controller.cartItems.length,
                      itemBuilder: (context, index) =>
                          _CartItemCard(cartItem: controller.cartItems[index], index: index, controller: controller),
                    ),
                  ),
                  _buildCheckoutSection(context),
                ],
              ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: const Text(
        'My Cart',
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2D3D), fontSize: 18),
      ),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                if (controller.cartItems.isNotEmpty) {
                  _confirmClear(context);
                } else {
                  Get.snackbar(
                    'Cart Empty',
                    'There are no items to clear.',
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                  );
                }
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor.withValues(alpha: 0.1), AppTheme.primaryColor.withValues(alpha: 0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(child: Text('🛒', style: TextStyle(fontSize: 52))),
          ),
          const SizedBox(height: 28),
          const Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E2D3D)),
          ),
          const SizedBox(height: 10),
          Text('Add delicious items to get started', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          const SizedBox(height: 36),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.restaurant_menu_rounded, size: 18),
              label: const Text('Browse Menu'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(2)),
            ),
          ),
          // price rows
          _priceRow('Subtotal', '\$${controller.subtotal.toStringAsFixed(2)}', false),
          const SizedBox(height: 10),
          _priceRow('Delivery Fee', '\$5.00', false),
          const SizedBox(height: 10),
          _priceRow('Tax (5%)', '\$${(controller.subtotal * 0.05).toStringAsFixed(2)}', false),
          const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(thickness: 1.2)),
          _priceRow('Total', '\$${(controller.total + controller.subtotal * 0.05).toStringAsFixed(2)}', true),
          const SizedBox(height: 20),
          // Checkout button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.orderTracking),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, bool isBold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? const Color(0xFF1E2D3D) : Colors.grey[500],
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 17 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isBold ? AppTheme.primaryColor : const Color(0xFF1E2D3D),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontSize: isBold ? 17 : 14,
          ),
        ),
      ],
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to remove all items?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () {
              controller.clearCart();
              Get.back();
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final dynamic cartItem;
  final int index;
  final CartController controller;

  const _CartItemCard({required this.cartItem, required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    final item = cartItem['item'];
    return Dismissible(
      key: Key('cart_item_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red[50]!, Colors.red[100]!],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_sweep_rounded, color: Colors.red[400], size: 26),
            const SizedBox(height: 2),
            Text(
              'Remove',
              style: TextStyle(color: Colors.red[400], fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      onDismissed: (_) => controller.removeFromCart(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: item['imageUrl'] ?? '',
                width: 74,
                height: 74,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 74,
                  height: 74,
                  color: const Color(0xFFF5F5F5),
                  child: const Icon(Icons.fastfood_rounded, color: Colors.grey),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 74,
                  height: 74,
                  color: const Color(0xFFF5F5F5),
                  child: const Center(child: Text('🍔', style: TextStyle(fontSize: 28))),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E2D3D)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(cartItem['restaurant']['name'] ?? '', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${(item['price'] * cartItem['quantity']).toStringAsFixed(2)}',
                        style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      // Quantity controls
                      Row(
                        children: [
                          _qtyBtn(
                            Icons.remove,
                            () => controller.decreaseQuantity(index),
                            const Color(0xFFF7F7FA),
                            const Color(0xFF1E2D3D),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '${cartItem['quantity']}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E2D3D)),
                            ),
                          ),
                          _qtyBtn(Icons.add, () => controller.increaseQuantity(index), AppTheme.primaryColor, Colors.white),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, Color bg, Color iconColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 16, color: iconColor),
      ),
    );
  }
}
