import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/app_bottom_nav.dart';

class OrderTrackingView extends StatelessWidget {
  const OrderTrackingView({super.key});

  static const _steps = [
    {'icon': Icons.receipt_long_rounded, 'label': 'Order Placed', 'desc': 'We received your order'},
    {'icon': Icons.check_circle_outline_rounded, 'label': 'Confirmed', 'desc': 'Restaurant accepted your order'},
    {'icon': Icons.soup_kitchen_rounded, 'label': 'Preparing', 'desc': 'Your food is being prepared'},
    {'icon': Icons.delivery_dining_rounded, 'label': 'On the Way', 'desc': 'Rider is heading to you'},
    {'icon': Icons.home_rounded, 'label': 'Delivered', 'desc': '🎉 Enjoy your meal!'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final statusStr = args['status'] as String? ?? 'preparing';
    final orderId = args['orderId'] ?? '0042';
    final currentStep = _statusToStep(statusStr);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: CustomScrollView(
        slivers: [
          // --- Custom SliverAppBar ---
          SliverAppBar(
            expandedHeight: 0,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              'Order Tracking',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2D3D), fontSize: 18),
            ),
            centerTitle: true,
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                // --- Hero confirmation card ---
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.primaryColor, theme.primaryColor.withValues(alpha: 0.75)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -10,
                        top: -10,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.08)),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_rounded, color: Colors.white, size: 22),
                              ),
                              const SizedBox(width: 14),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Confirmed! 🎉',
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text('Estimated: 30–40 min', style: TextStyle(color: Colors.white70, fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _infoRow(Icons.tag_rounded, 'Order ID', '#$orderId'),
                          const SizedBox(height: 10),
                          _infoRow(Icons.access_time_rounded, 'Placed', 'Just now'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- Timeline card ---
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Live Tracking',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E2D3D)),
                      ),
                      const SizedBox(height: 20),
                      ...List.generate(_steps.length, (i) {
                        final done = i <= currentStep;
                        final active = i == currentStep;
                        final last = i == _steps.length - 1;
                        return _TimelineStep(
                          icon: _steps[i]['icon'] as IconData,
                          label: _steps[i]['label'] as String,
                          desc: _steps[i]['desc'] as String,
                          isDone: done,
                          isActive: active,
                          isLast: last,
                          theme: theme,
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- Rider card ---
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [theme.primaryColor.withValues(alpha: 0.15), theme.primaryColor.withValues(alpha: 0.05)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.delivery_dining_rounded, color: theme.primaryColor, size: 30),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Robert Fox',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E2D3D)),
                            ),
                            SizedBox(height: 3),
                            Text('Your Delivery Partner', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.star_rounded, color: Colors.amber, size: 13),
                                SizedBox(width: 3),
                                Text('4.9 · 250+ deliveries', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Call button
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: theme.primaryColor.withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.phone_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),

      // --- Bottom action ---
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 14),
        const SizedBox(width: 6),
        Text('$label: ', style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  int _statusToStep(String status) {
    switch (status.toLowerCase()) {
      case 'placed':
        return 0;
      case 'confirmed':
        return 1;
      case 'preparing':
        return 2;
      case 'on_the_way':
      case 'on the way':
      case 'delivering':
        return 3;
      case 'delivered':
        return 4;
      default:
        return 2;
    }
  }
}

class _TimelineStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;
  final bool isDone;
  final bool isActive;
  final bool isLast;
  final ThemeData theme;

  const _TimelineStep({
    required this.icon,
    required this.label,
    required this.desc,
    required this.isDone,
    required this.isActive,
    required this.isLast,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicator column
          SizedBox(
            width: 44,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDone ? theme.primaryColor : const Color(0xFFF0F0F0),
                    shape: BoxShape.circle,
                    border: isActive ? Border.all(color: theme.primaryColor.withValues(alpha: 0.3), width: 4) : null,
                    boxShadow: isDone
                        ? [
                            BoxShadow(
                              color: theme.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    isDone && !isActive ? Icons.check_rounded : icon,
                    size: 18,
                    color: isDone ? Colors.white : Colors.grey[400],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: isDone
                            ? LinearGradient(
                                colors: [theme.primaryColor, theme.primaryColor.withValues(alpha: 0.3)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )
                            : null,
                        color: isDone ? null : const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Text
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDone ? const Color(0xFF1E2D3D) : Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(desc, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
          ),
          if (isDone && !isActive)
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 4),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: theme.primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(Icons.done_rounded, color: theme.primaryColor, size: 14),
              ),
            ),
        ],
      ),
    );
  }
}
