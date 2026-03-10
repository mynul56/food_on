import 'package:get/get.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type; // 'order', 'promo', 'system'
  final DateTime time;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    this.isRead = false,
  });
}

class NotificationsController extends GetxController {
  var notifications = <NotificationItem>[].obs;
  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDemoNotifications();
  }

  void _loadDemoNotifications() {
    final now = DateTime.now();
    notifications.assignAll([
      NotificationItem(
        id: '1',
        title: 'Order Confirmed!',
        message: 'Your order #0042 from Burger Palace has been confirmed.',
        type: 'order',
        time: now.subtract(const Duration(minutes: 10)),
        isRead: false,
      ),
      NotificationItem(
        id: '2',
        title: 'Order on the Way 🛵',
        message: 'Your food is heading your way. Estimated 20 min.',
        type: 'order',
        time: now.subtract(const Duration(minutes: 3)),
        isRead: false,
      ),
      NotificationItem(
        id: '3',
        title: 'Special Offer! 🎉',
        message: 'Get 30% off your next order. Use code: FOODON30',
        type: 'promo',
        time: now.subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      NotificationItem(
        id: '4',
        title: 'New Restaurant Added',
        message: 'Check out "The Sushi House" — now available in your area!',
        type: 'system',
        time: now.subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      NotificationItem(
        id: '5',
        title: 'Order Delivered ✅',
        message: 'Hope you enjoyed your meal! Leave a review.',
        type: 'order',
        time: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ]);
    _updateUnread();
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
      _updateUnread();
    }
  }

  void markAllAsRead() {
    for (final n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
    unreadCount.value = 0;
  }

  void _updateUnread() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }
}
