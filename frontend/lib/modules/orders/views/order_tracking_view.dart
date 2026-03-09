import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class OrderTrackingView extends StatelessWidget {
  const OrderTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Order Status',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Map Placeholder
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[200],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_outlined, size: 50, color: Colors.grey),
                    Text(
                      'Live Tracking Map',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&q=80',
                        ),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Robert Fox',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Your Delivery Partner',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Spacer(),
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(Icons.call, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Order Timeline',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  _buildTimelineItem(
                    'Order Placed',
                    'Your order has been received',
                    true,
                    true,
                  ),
                  _buildTimelineItem(
                    'Preparing',
                    'The restaurant is preparing your food',
                    true,
                    false,
                  ),
                  _buildTimelineItem(
                    'On the way',
                    'Courier is heading to your location',
                    false,
                    false,
                  ),
                  _buildTimelineItem(
                    'Delivered',
                    'Enjoy your meal!',
                    false,
                    false,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(25),
        child: ElevatedButton(
          onPressed: () => Get.offAllNamed(AppRoutes.home),
          child: const Text('Back to Home'),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String subtitle,
    bool isCompleted,
    bool isActive, {
    bool isLast = false,
  }) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.red : Colors.grey[300],
                  shape: BoxShape.circle,
                  border: isActive
                      ? Border.all(color: Colors.red.withOpacity(0.3), width: 5)
                      : null,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? Colors.red : Colors.grey[300],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCompleted || isActive ? Colors.black : Colors.grey,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
