import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/restaurant_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class RestaurantView extends GetView<RestaurantController> {
  const RestaurantView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());

    return Scaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        controller.restaurant['imageUrl'] ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.restaurant['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(controller.restaurant['description'] ?? ''),
                          const Divider(height: 40),
                          const Text(
                            'Menu',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...List.generate(
                            (controller.restaurant['menuItems'] as List).length,
                            (index) {
                              final item =
                                  (controller.restaurant['menuItems']
                                      as List)[index];
                              return _buildMenuItem(
                                context,
                                item,
                                cartController,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: Obx(
        () => cartController.cartItems.isEmpty
            ? const SizedBox.shrink()
            : Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: ElevatedButton(
                  onPressed: () => Get.toNamed('/cart'),
                  child: Text(
                    'View Cart (${cartController.cartItems.length} items)',
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    dynamic item,
    CartController cartController,
  ) {
    return ListTile(
      title: Text(item['name']),
      subtitle: Text('\$${item['price']}'),
      trailing: IconButton(
        icon: const Icon(Icons.add_circle, color: Colors.red),
        onPressed: () => cartController.addToCart(item, controller.restaurant),
      ),
    );
  }
}
