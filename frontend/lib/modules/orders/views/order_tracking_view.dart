import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class OrderTrackingView extends StatelessWidget {
  const OrderTrackingView({super.key});

  // Status index: 0=placed, 1=confirmed, 2=preparing, 3=on_the_way, 4=delivered
  static const _steps = [
    {'icon': Icons.receipt_long, 'label': 'Order Placed', 'desc': 'Your order has been received'},
    {'icon': Icons.check_circle_outline, 'label': 'Confirmed', 'desc': 'Restaurant confirmed your order'},
    {'icon': Icons.restaurant, 'label': 'Preparing', 'desc': 'The restaurant is preparing your food'},
    {'icon': Icons.delivery_dining, 'label': 'On the Way', 'desc': 'Your courier is heading to you'},
    {'icon': Icons.home_outlined, 'label': 'Delivered', 'desc': 'Enjoy your meal!'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final statusStr = args['status'] as String? ?? 'preparing';
    final currentStep = _statusToStep(statusStr);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Order Status', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Order confirmed banner
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'Order Confirmed!',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Estimated delivery: 30-40 min',
                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Order #${args['orderId'] ?? '0001'}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            // Timeline
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Timeline',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2D3D)),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(_steps.length, (i) {
                    final isCompleted = i <= currentStep;
                    final isActive = i == currentStep;
                    final isLast = i == _steps.length - 1;
                    return _buildTimelineStep(
                      context,
                      icon: _steps[i]['icon'] as IconData,
                      label: _steps[i]['label'] as String,
                      desc: _steps[i]['desc'] as String,
                      isCompleted: isCompleted,
                      isActive: isActive,
                      isLast: isLast,
                      theme: theme,
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Delivery partner card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.delivery_dining, color: theme.primaryColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your Delivery Partner', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        SizedBox(height: 4),
                        Text('Robert Fox', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('★ 4.9  •  250+ deliveries', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.call, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: () => Get.offAllNamed(AppRoutes.home),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('Back to Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildTimelineStep(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String desc,
    required bool isCompleted,
    required bool isActive,
    required bool isLast,
    required ThemeData theme,
  }) {
    final color = isCompleted ? theme.primaryColor : Colors.grey[300]!;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator column
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isCompleted ? theme.primaryColor : Colors.grey[100],
                    shape: BoxShape.circle,
                    border: isActive
                        ? Border.all(color: theme.primaryColor.withOpacity(0.3), width: 4)
                        : null,
                  ),
                  child: Icon(icon, size: 16, color: isCompleted ? Colors.white : Colors.grey[400]),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: color,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Text content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? const Color(0xFF1E2D3D) : Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          if (isCompleted && !isActive)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Icon(Icons.check, color: theme.primaryColor, size: 16),
            ),
        ],
      ),
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
