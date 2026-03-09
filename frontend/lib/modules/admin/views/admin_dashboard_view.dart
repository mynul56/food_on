import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../data/providers/auth_service.dart';

class AdminDashboardView extends GetView<AdminController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.adminRestaurants),
            icon: const Icon(Icons.restaurant),
            tooltip: 'Manage Restaurants',
          ),
          IconButton(
            onPressed: () {
              Get.find<AuthService>().logout();
              Get.offAllNamed(AppRoutes.login);
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsSection(context),
              const SizedBox(height: 30),
              Text(
                'Recent Orders',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildOrdersList(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final stats = controller.stats;
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          context,
          'Revenue',
          '\$${stats['totalRevenue']?.toStringAsFixed(2) ?? '0.00'}',
          Icons.attach_money,
          Colors.green,
        ),
        _buildStatCard(
          context,
          'Orders',
          stats['totalOrders']?.toString() ?? '0',
          Icons.shopping_bag,
          Colors.blue,
        ),
        _buildStatCard(
          context,
          'Restaurants',
          stats['activeRestaurants']?.toString() ?? '0',
          Icons.restaurant,
          Colors.red,
        ),
        _buildStatCard(context, 'Users', 'Active', Icons.people, Colors.orange),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context) {
    if (controller.orders.isEmpty) {
      return const Center(child: Text('No orders found'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.orders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final order = controller.orders[index];
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${order['id']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildStatusBadge(order['status']),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(order['restaurant']?['name'] ?? 'Unknown Restaurant'),
                  Text(
                    '\$${order['totalAmount']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (order['status'] == 'pending')
                    TextButton.icon(
                      onPressed: () => controller.updateStatus(
                        order['id'].toString(),
                        'preparing',
                      ),
                      icon: const Icon(Icons.timer_outlined, size: 18),
                      label: const Text('Prepare'),
                    ),
                  if (order['status'] == 'preparing')
                    TextButton.icon(
                      onPressed: () => controller.updateStatus(
                        order['id'].toString(),
                        'delivered',
                      ),
                      icon: const Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: Colors.green,
                      ),
                      label: const Text(
                        'Deliver',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Details'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'preparing':
        color = Colors.blue;
        break;
      case 'delivered':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
