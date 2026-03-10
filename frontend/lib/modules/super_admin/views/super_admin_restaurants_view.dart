import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../controllers/super_admin_controller.dart';

class SuperAdminRestaurantsView extends GetView<SuperAdminController> {
  const SuperAdminRestaurantsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'All Restaurants',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2D3D), fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E2D3D)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppTheme.primaryColor),
            onPressed: () => _showAddRestaurantDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingRestaurants.value && controller.restaurants.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.restaurants.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🍽️', style: TextStyle(fontSize: 52)),
                const SizedBox(height: 16),
                const Text('No restaurants yet', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _showAddRestaurantDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Restaurant'),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchRestaurants,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.restaurants.length,
            itemBuilder: (ctx, i) {
              final r = controller.restaurants[i];
              return _RestaurantCard(
                restaurant: r,
                onEdit: () => _showAddRestaurantDialog(context, existing: r),
                onDelete: () => Get.defaultDialog(
                  title: 'Delete Restaurant',
                  middleText: 'Remove "${r['name']}"?',
                  textConfirm: 'Delete',
                  textCancel: 'Cancel',
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.red,
                  onConfirm: () {
                    Get.back();
                    controller.deleteRestaurant('${r['id']}');
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showAddRestaurantDialog(BuildContext context, {dynamic existing}) {
    final nameCtrl = TextEditingController(text: existing?['name'] ?? '');
    final descCtrl = TextEditingController(text: existing?['description'] ?? '');
    final imgCtrl = TextEditingController(text: existing?['imageUrl'] ?? '');
    final addrCtrl = TextEditingController(text: existing?['address'] ?? '');
    final cuisineCtrl = TextEditingController(text: existing?['cuisine'] ?? '');
    final phoneCtrl = TextEditingController(text: existing?['phone'] ?? '');
    final deliveryFeeCtrl = TextEditingController(text: existing?['deliveryFee']?.toString() ?? '2.99');
    final deliveryTimeCtrl = TextEditingController(text: existing?['deliveryTime'] ?? '20-30 min');

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          existing == null ? 'Add Restaurant' : 'Edit Restaurant',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field(nameCtrl, 'Restaurant Name', Icons.store),
              const SizedBox(height: 12),
              _field(descCtrl, 'Description', Icons.description, maxLines: 2),
              const SizedBox(height: 12),
              _field(cuisineCtrl, 'Cuisine Type', Icons.restaurant_menu),
              const SizedBox(height: 12),
              _field(imgCtrl, 'Image URL', Icons.image),
              const SizedBox(height: 12),
              _field(addrCtrl, 'Address', Icons.location_on),
              const SizedBox(height: 12),
              _field(phoneCtrl, 'Phone', Icons.phone, inputType: TextInputType.phone),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _field(deliveryFeeCtrl, 'Delivery Fee', Icons.delivery_dining, inputType: TextInputType.number),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: _field(deliveryTimeCtrl, 'Delivery Time', Icons.timer)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              final data = {
                'name': nameCtrl.text.trim(),
                'description': descCtrl.text.trim(),
                'imageUrl': imgCtrl.text.trim(),
                'address': addrCtrl.text.trim(),
                'cuisine': cuisineCtrl.text.trim(),
                'phone': phoneCtrl.text.trim(),
                'deliveryFee': double.tryParse(deliveryFeeCtrl.text) ?? 2.99,
                'deliveryTime': deliveryTimeCtrl.text.trim(),
              };
              Get.back();
              if (existing == null) {
                controller.addRestaurant(data);
              } else {
                controller.updateRestaurant('${existing['id']}', data);
              }
            },
            child: Text(existing == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon, {int maxLines = 1, TextInputType? inputType}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: AppTheme.primaryColor),
        filled: true,
        fillColor: const Color(0xFFF5F6FA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final dynamic restaurant;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RestaurantCard({required this.restaurant, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final r = restaurant;
    final isActive = r['isActive'] != false;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        border: isActive ? null : Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: const Color(0xFFFFF0ED), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.restaurant, color: AppTheme.primaryColor, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r['name'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E2D3D)),
                ),
                if (r['cuisine'] != null) Text(r['cuisine'], style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                Text(
                  r['address'] ?? '',
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 13),
                    Text(
                      ' ${r['rating']?.toStringAsFixed(1) ?? '0.0'}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${r['deliveryFee'] != null ? '\$${r['deliveryFee']}' : ''} delivery',
                      style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                  child: const Text('Inactive', style: TextStyle(fontSize: 9, color: Colors.red)),
                ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
