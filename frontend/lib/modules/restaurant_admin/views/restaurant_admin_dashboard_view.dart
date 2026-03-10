import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/providers/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../controllers/restaurant_admin_controller.dart';

class RestaurantAdminDashboardView extends GetView<RestaurantAdminController> {
  const RestaurantAdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Obx(() {
        if (controller.isLoadingRestaurant.value && controller.restaurant.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return NestedScrollView(headerSliverBuilder: (ctx, _) => [_buildHeader(ctx)], body: _buildBody(context));
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditItemDialog(context),
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Item',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppTheme.secondaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E2D3D), Color(0xFF2E4057)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          child: Obx(() {
            final rData = controller.restaurant;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('Restaurant Admin', style: TextStyle(color: Colors.white60, fontSize: 12)),
                      const SizedBox(height: 6),
                      Text(
                        rData['name'] ?? 'My Restaurant',
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      if (rData['cuisine'] != null)
                        Text(rData['cuisine'], style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _headerBtn(Icons.edit_outlined, 'Edit Info', () => _showEditRestaurantDialog(context)),
                    const SizedBox(height: 6),
                    _headerBtn(Icons.logout, 'Logout', () async {
                      await Get.find<AuthService>().logout();
                      Get.offAllNamed(AppRoutes.login);
                    }),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _headerBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 14),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchRestaurant();
        await controller.fetchMenuItems();
      },
      child: Column(
        children: [
          // Category tabs
          _buildCategoryTabs(),
          // Menu list
          Expanded(child: _buildMenuList(context)),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Obx(
      () => Container(
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: controller.categories.map((cat) {
              final active = controller.selectedCategory.value == cat;
              return GestureDetector(
                onTap: () => controller.selectedCategory.value = cat,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? AppTheme.primaryColor : const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: active ? Colors.white : Colors.grey[600],
                      fontWeight: active ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingMenu.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final items = controller.filteredItems;
      if (items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🍽️', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              Text('No items in ${controller.selectedCategory.value}', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          final item = items[i];
          return _MenuItemCard(
            item: item,
            onEdit: () => _showAddEditItemDialog(context, item: item),
            onDelete: () => Get.defaultDialog(
              title: 'Delete Item',
              middleText: 'Remove "${item['name']}"?',
              textConfirm: 'Delete',
              textCancel: 'Cancel',
              confirmTextColor: Colors.white,
              buttonColor: Colors.red,
              onConfirm: () {
                Get.back();
                controller.deleteMenuItem('${item['id']}');
              },
            ),
            onToggle: () => controller.toggleItemAvailability('${item['id']}', item['isAvailable'] != false),
          );
        },
      );
    });
  }

  void _showAddEditItemDialog(BuildContext context, {dynamic item}) {
    final nameCtrl = TextEditingController(text: item?['name'] ?? '');
    final descCtrl = TextEditingController(text: item?['description'] ?? '');
    final priceCtrl = TextEditingController(text: item?['price']?.toString() ?? '');
    final categoryCtrl = TextEditingController(text: item?['category'] ?? 'Main Course');
    final imageUrlCtrl = TextEditingController(text: item?['imageUrl'] ?? '');
    var isVeg = (item?['isVeg'] == true).obs;
    var isAvailable = (item?['isAvailable'] != false).obs;
    XFile? pickedImage;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(item == null ? 'Add Menu Item' : 'Edit Menu Item', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image picker
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                    if (picked != null) {
                      pickedImage = picked;
                      imageUrlCtrl.text = ''; // clear URL when file picked
                    }
                  },
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6FA),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined, color: AppTheme.primaryColor, size: 36),
                        SizedBox(height: 6),
                        Text('Tap to pick image', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('— or paste image URL —', style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 8),
                _field(imageUrlCtrl, 'Image URL', Icons.image),
                const SizedBox(height: 12),
                _field(nameCtrl, 'Item Name *', Icons.fastfood),
                const SizedBox(height: 12),
                _field(descCtrl, 'Description', Icons.description, maxLines: 2),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _field(priceCtrl, 'Price *', Icons.attach_money, inputType: TextInputType.number)),
                    const SizedBox(width: 10),
                    Expanded(child: _field(categoryCtrl, 'Category', Icons.category)),
                  ],
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Switch(value: isVeg.value, onChanged: (v) => isVeg.value = v, activeThumbColor: Colors.green),
                            const Text('Veg', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Switch(
                              value: isAvailable.value,
                              onChanged: (v) => isAvailable.value = v,
                              activeThumbColor: AppTheme.primaryColor,
                            ),
                            const Text('Available', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          Obx(
            () => ElevatedButton(
              onPressed: controller.isSaving.value
                  ? null
                  : () {
                      if (nameCtrl.text.trim().isEmpty || priceCtrl.text.trim().isEmpty) return;
                      Get.back();
                      controller.addOrUpdateMenuItem(
                        itemId: item != null ? '${item['id']}' : null,
                        name: nameCtrl.text.trim(),
                        description: descCtrl.text.trim(),
                        price: double.tryParse(priceCtrl.text) ?? 0,
                        category: categoryCtrl.text.trim().isEmpty ? 'Main Course' : categoryCtrl.text.trim(),
                        isVeg: isVeg.value,
                        isAvailable: isAvailable.value,
                        imageUrl: imageUrlCtrl.text.trim().isNotEmpty ? imageUrlCtrl.text.trim() : null,
                        imageFile: pickedImage,
                      );
                    },
              child: Text(item == null ? 'Add' : 'Save'),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditRestaurantDialog(BuildContext context) {
    final r = controller.restaurant;
    final nameCtrl = TextEditingController(text: r['name'] ?? '');
    final descCtrl = TextEditingController(text: r['description'] ?? '');
    final cuisineCtrl = TextEditingController(text: r['cuisine'] ?? '');
    final imgCtrl = TextEditingController(text: r['imageUrl'] ?? '');
    final addrCtrl = TextEditingController(text: r['address'] ?? '');
    final phoneCtrl = TextEditingController(text: r['phone'] ?? '');
    final feeCtrl = TextEditingController(text: r['deliveryFee']?.toString() ?? '');
    final timeCtrl = TextEditingController(text: r['deliveryTime'] ?? '');

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Restaurant Info', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field(nameCtrl, 'Name', Icons.store),
              const SizedBox(height: 10),
              _field(descCtrl, 'Description', Icons.description, maxLines: 2),
              const SizedBox(height: 10),
              _field(cuisineCtrl, 'Cuisine', Icons.restaurant_menu),
              const SizedBox(height: 10),
              _field(imgCtrl, 'Image URL', Icons.image),
              const SizedBox(height: 10),
              _field(addrCtrl, 'Address', Icons.location_on),
              const SizedBox(height: 10),
              _field(phoneCtrl, 'Phone', Icons.phone, inputType: TextInputType.phone),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _field(feeCtrl, 'Delivery Fee', Icons.delivery_dining, inputType: TextInputType.number)),
                  const SizedBox(width: 10),
                  Expanded(child: _field(timeCtrl, 'Delivery Time', Icons.timer)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.updateRestaurantInfo({
                'name': nameCtrl.text.trim(),
                'description': descCtrl.text.trim(),
                'cuisine': cuisineCtrl.text.trim(),
                'imageUrl': imgCtrl.text.trim(),
                'address': addrCtrl.text.trim(),
                'phone': phoneCtrl.text.trim(),
                'deliveryFee': double.tryParse(feeCtrl.text) ?? 2.99,
                'deliveryTime': timeCtrl.text.trim(),
              });
            },
            child: const Text('Save'),
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

class _MenuItemCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const _MenuItemCard({required this.item, required this.onEdit, required this.onDelete, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isAvailable = item['isAvailable'] != false;
    final isVeg = item['isVeg'] == true;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
        border: isAvailable ? null : Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: item['imageUrl'] ?? '',
              width: 68,
              height: 68,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 68,
                height: 68,
                color: const Color(0xFFF5F6FA),
                child: const Icon(Icons.fastfood, color: Colors.grey),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 68,
                height: 68,
                color: const Color(0xFFF5F6FA),
                child: const Center(child: Text('🍔', style: TextStyle(fontSize: 28))),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['name'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2D3D)),
                      ),
                    ),
                    if (isVeg)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.green),
                        ),
                        child: const Text(
                          'V',
                          style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                if (item['description'] != null)
                  Text(
                    item['description'],
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '\$${(item['price'] ?? 0).toStringAsFixed(2)}',
                      style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isAvailable ? Colors.green.shade50 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isAvailable ? 'Available' : 'Unavailable',
                        style: TextStyle(
                          fontSize: 10,
                          color: isAvailable ? Colors.green : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(item['category'] ?? '', style: TextStyle(fontSize: 10, color: Colors.grey[400])),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(
                  isAvailable ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 18,
                  color: isAvailable ? Colors.grey : Colors.green,
                ),
                onPressed: onToggle,
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
