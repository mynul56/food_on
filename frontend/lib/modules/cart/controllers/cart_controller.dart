import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <dynamic>[].obs;

  void addToCart(dynamic item, dynamic restaurant) {
    // Basic logic: if item from different restaurant, we might ask to clear cart
    cartItems.add({'item': item, 'restaurant': restaurant, 'quantity': 1});
    Get.snackbar('Success', '${item['name']} added to cart');
  }

  double get subtotal => cartItems.fold(
    0,
    (sum, item) => sum + (item['item']['price'] * item['quantity']),
  );
  double get total => subtotal + 5.0; // Adding dummy delivery fee

  void clearCart() {
    cartItems.clear();
  }
}
