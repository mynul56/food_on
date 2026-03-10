import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../core/utils/constants.dart';

/// Singleton real-time service using Socket.io.
/// Handles orders, cart, and notification updates in real-time.
class SocketService extends GetxService {
  late io.Socket socket;
  bool _connected = false;

  final _serverUrl = AppConstants.apiUrl.replaceAll('/api', '');

  final orderStatus = ''.obs;
  final cartUpdated = false.obs;
  final newNotification = {}.obs;

  @override
  void onInit() {
    super.onInit();
    _connect();
  }

  void _connect() {
    socket = io.io(_serverUrl, io.OptionBuilder().setTransports(['websocket']).disableAutoConnect().build());

    socket.onConnect((_) {
      _connected = true;
    });

    socket.onDisconnect((_) {
      _connected = false;
    });

    socket.on('orderStatusUpdated', (data) {
      if (data is Map) {
        orderStatus.value = data['status'] ?? '';
      }
    });

    socket.on('cartUpdated', (data) {
      cartUpdated.value = !cartUpdated.value;
    });

    socket.on('notification', (data) {
      if (data is Map) {
        newNotification.value = Map<String, dynamic>.from(data);
      }
    });

    socket.connect();
  }

  /// Call after login to join personal room
  void joinUserRoom(String userId) {
    if (_connected) {
      socket.emit('join', userId);
    } else {
      socket.onConnect((_) => socket.emit('join', userId));
    }
  }

  /// For restaurant admins
  void joinRestaurantRoom(String restaurantId) {
    socket.emit('joinRestaurant', restaurantId);
  }

  /// For admins / super admins
  void joinAdminRoom() {
    socket.emit('joinAdmin');
  }

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }
}
