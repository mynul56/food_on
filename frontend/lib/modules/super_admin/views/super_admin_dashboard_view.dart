import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/providers/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../controllers/super_admin_controller.dart';

class SuperAdminDashboardView extends GetView<SuperAdminController> {
  const SuperAdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Obx(() {
        if (controller.isLoadingStats.value && controller.stats.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchStats();
            await controller.fetchUsers();
            await controller.fetchRestaurants();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildHeader(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsGrid(context),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Revenue (Last 7 Days)'),
                      const SizedBox(height: 14),
                      _buildRevenueChart(context),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Quick Actions'),
                      const SizedBox(height: 14),
                      _buildQuickActions(context),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Top Restaurants'),
                      const SizedBox(height: 14),
                      _buildTopRestaurants(context),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Order Status Breakdown'),
                      const SizedBox(height: 14),
                      _buildStatusBreakdown(context),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Super Admin', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    SizedBox(height: 4),
                    Text(
                      'Food ON Control Panel',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _headerBtn(Icons.people_outline, 'Users', () => Get.toNamed(AppRoutes.superAdminUsers)),
                  const SizedBox(width: 8),
                  _headerBtn(Icons.logout, 'Logout', () async {
                    await Get.find<AuthService>().logout();
                    Get.offAllNamed(AppRoutes.login);
                  }),
                ],
              ),
            ],
          ),
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
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final s = controller.stats;
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      shrinkWrap: true,
      childAspectRatio: 1.4,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _statCard(
          'Total Revenue',
          '\$${(s['totalRevenue'] ?? 0.0).toStringAsFixed(2)}',
          Icons.payments_outlined,
          const Color(0xFF4CAF50),
          const Color(0xFFE8F5E9),
        ),
        _statCard(
          'Total Orders',
          '${s['totalOrders'] ?? 0}',
          Icons.receipt_long_outlined,
          const Color(0xFF2196F3),
          const Color(0xFFE3F2FD),
        ),
        _statCard(
          'Restaurants',
          '${s['activeRestaurants'] ?? 0}',
          Icons.store_outlined,
          AppTheme.primaryColor,
          const Color(0xFFFFEBEE),
        ),
        _statCard(
          'Total Users',
          '${s['totalUsers'] ?? 0}',
          Icons.people_outline,
          const Color(0xFFFF9800),
          const Color(0xFFFFF3E0),
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
              ),
              Text(title, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2D3D)),
    );
  }

  Widget _buildRevenueChart(BuildContext context) {
    return Obx(() {
      final data = controller.revenueByDay;
      if (data.isEmpty) {
        return Container(
          height: 120,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
          child: const Center(
            child: Text('No data for last 7 days', style: TextStyle(color: Colors.grey)),
          ),
        );
      }
      final maxRevenue = data.fold<double>(
        0,
        (prev, e) =>
            (e['revenue'] is num ? (e['revenue'] as num).toDouble() : 0) > prev ? (e['revenue'] as num).toDouble() : prev,
      );

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: data.map<Widget>((e) {
                  final rev = (e['revenue'] is num ? (e['revenue'] as num).toDouble() : 0);
                  final ratio = maxRevenue > 0 ? rev / maxRevenue : 0.0;
                  final dateStr = (e['date'] ?? '').toString();
                  final label = dateStr.length >= 10 ? dateStr.substring(5) : dateStr;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 100 * ratio,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppTheme.primaryColor, AppTheme.primaryLight],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _actionCard(
            Icons.store_rounded,
            'Manage\nRestaurants',
            const Color(0xFF5B8DEF),
            () => Get.toNamed(AppRoutes.superAdminRestaurants),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionCard(
            Icons.people_rounded,
            'Manage\nUsers',
            const Color(0xFF4CAF50),
            () => Get.toNamed(AppRoutes.superAdminUsers),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionCard(
            Icons.receipt_long_rounded,
            'All\nOrders',
            const Color(0xFFFF9800),
            () => Get.toNamed(AppRoutes.adminDashboard),
          ),
        ),
      ],
    );
  }

  Widget _actionCard(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
        ),
        child: Column(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E2D3D)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRestaurants(BuildContext context) {
    return Obx(() {
      final list = controller.topRestaurants;
      if (list.isEmpty) {
        return const Text('No data', style: TextStyle(color: Colors.grey));
      }
      return Column(
        children: list.take(5).map<Widget>((r) {
          final name = r['restaurant.name'] ?? r['restaurant']?['name'] ?? 'Restaurant';
          final revenue = (r['revenue'] is num ? (r['revenue'] as num).toDouble() : 0).toStringAsFixed(2);
          final orders = r['orderCount'] ?? 0;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: const Color(0xFFFFF0ED), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.restaurant, color: AppTheme.primaryColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E2D3D)),
                      ),
                      Text('$orders orders', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    ],
                  ),
                ),
                Text(
                  '\$$revenue',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4CAF50), fontSize: 14),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildStatusBreakdown(BuildContext context) {
    return Obx(() {
      final list = controller.ordersByStatus;
      if (list.isEmpty) return const Text('No data', style: TextStyle(color: Colors.grey));
      final statusColors = {
        'pending': Colors.orange,
        'confirmed': Colors.blue,
        'preparing': Colors.purple,
        'on_the_way': Colors.teal,
        'delivered': Colors.green,
        'cancelled': Colors.red,
      };
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: list.map<Widget>((s) {
          final status = s['status'] ?? '';
          final count = s['count'] ?? 0;
          final color = statusColors[status] ?? Colors.grey;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Text(
                  '$count',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color),
                ),
                Text(status, style: TextStyle(fontSize: 10, color: color)),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}
