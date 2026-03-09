import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/admin_controller.dart';
import '../../../core/theme/app_theme.dart';

class AdminRestaurantsView extends GetView<AdminController> {
  const AdminRestaurantsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Manage Restaurants', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRestaurantDialog(context),
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Add Restaurant'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.fetchData,
          child: controller.restaurants.isEmpty
              ? ListView(children: [
                  const SizedBox(height: 120),
                  Center(child: Column(children: [
                    const Text('🏪', style: TextStyle(fontSize: 56)),
                    const SizedBox(height: 12),
                    Text('No restaurants yet', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                  ])),
                ])
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  itemCount: controller.restaurants.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, index) =>
                      _buildRestaurantCard(ctx, controller.restaurants[index]),
                ),
        );
      }),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, dynamic r) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              bottomLeft: Radius.circular(18),
            ),
            child: CachedNetworkImage(
              imageUrl: r['imageUrl'] ?? '',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                width: 100,
                height: 100,
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                child: const Icon(Icons.store, color: AppTheme.primaryColor, size: 36),
              ),
            ),
          ),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r['name'] ?? 'Restaurant',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    r['address'] ?? 'No address set',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 3),
                      Text(
                        '${r['rating'] ?? 0.0}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (r['isActive'] == true ? Colors.green : Colors.grey).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          r['isActive'] == true ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: r['isActive'] == true ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Actions
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => _confirmDelete(context, r['id'].toString()),
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Restaurant?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('This restaurant will be deactivated and hidden from users.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () { Get.back(); controller.deleteRestaurant(id); },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(80, 38),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddRestaurantDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final deliveryFeeCtrl = TextEditingController(text: '0');
    final deliveryTimeCtrl = TextEditingController(text: '30 min');

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add New Restaurant',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.secondaryColor)),
              const SizedBox(height: 20),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Restaurant Name *', prefixIcon: Icon(Icons.store_outlined)),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: addressCtrl,
                decoration: const InputDecoration(labelText: 'Address', prefixIcon: Icon(Icons.location_on_outlined)),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: deliveryFeeCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Delivery Fee (\$)', prefixIcon: Icon(Icons.attach_money)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: deliveryTimeCtrl,
                      decoration: const InputDecoration(labelText: 'Delivery Time', prefixIcon: Icon(Icons.timer_outlined)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 46)),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameCtrl.text.trim().isEmpty) return;
                        controller.addRestaurant({
                          'name': nameCtrl.text.trim(),
                          'address': addressCtrl.text.trim(),
                          'deliveryFee': double.tryParse(deliveryFeeCtrl.text) ?? 0,
                          'deliveryTime': deliveryTimeCtrl.text.trim(),
                        });
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(minimumSize: const Size(0, 46)),
                      child: const Text('Add'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
