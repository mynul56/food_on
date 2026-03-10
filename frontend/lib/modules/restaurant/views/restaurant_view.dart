import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../cart/controllers/cart_controller.dart';
import '../controllers/restaurant_controller.dart';

class RestaurantView extends GetView<RestaurantController> {
  const RestaurantView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final restaurant = controller.restaurant;
        final menuItems = (restaurant['menuItems'] as List? ?? []);

        return CustomScrollView(
          slivers: [
            // Hero image app bar
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              backgroundColor: theme.primaryColor,
              leading: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black87),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: restaurant['imageUrl'] ?? '',
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.restaurant,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.restaurant,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Restaurant info header
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2D3D),
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (restaurant['description'] != null)
                      Text(
                        restaurant['description'],
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _infoChip(
                          Icons.star,
                          '${restaurant['rating'] ?? '4.5'}',
                          Colors.amber,
                        ),
                        const SizedBox(width: 10),
                        _infoChip(
                          Icons.delivery_dining,
                          restaurant['deliveryTime'] != null
                              ? '${restaurant['deliveryTime']} min'
                              : '30-40 min',
                          theme.primaryColor,
                        ),
                        const SizedBox(width: 10),
                        _infoChip(
                          Icons.monetization_on_outlined,
                          restaurant['deliveryFee'] != null
                              ? '\$${restaurant['deliveryFee']}'
                              : '\$2.99',
                          Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                  ],
                ),
              ),
            ),

            // Menu section header
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: const Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2D3D),
                  ),
                ),
              ),
            ),

            // Menu items
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = menuItems[index];
                  return _MenuItemCard(
                    item: item,
                    cartController: cartController,
                    restaurant: restaurant,
                  );
                }, childCount: menuItems.length),
              ),
            ),
          ],
        );
      }),

      // Floating cart bar
      bottomNavigationBar: Obx(() {
        if (cartController.cartItems.isEmpty) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ElevatedButton(
            onPressed: () => Get.toNamed('/cart'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${cartController.cartItems.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Text(
                  'View Cart',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${cartController.total.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final dynamic item;
  final CartController cartController;
  final dynamic restaurant;

  const _MenuItemCard({
    required this.item,
    required this.cartController,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Item image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: CachedNetworkImage(
              imageUrl: item['imageUrl'] ?? '',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 100,
                height: 100,
                color: Colors.grey[100],
                child: const Icon(Icons.fastfood, color: Colors.grey),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 100,
                height: 100,
                color: Colors.grey[100],
                child: const Icon(Icons.fastfood, color: Colors.grey),
              ),
            ),
          ),
          // Item details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  if (item['description'] != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      item['description'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${item['price']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          cartController.addToCart(item, restaurant);
                          Get.snackbar(
                            'Added!',
                            '${item['name']} added to cart',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 1),
                            margin: const EdgeInsets.all(16),
                            backgroundColor: const Color(0xFF1E2D3D),
                            colorText: Colors.white,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
