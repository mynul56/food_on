import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <dynamic>[].obs;

  void addToCart(dynamic item, dynamic restaurant) {
    final existingIndex = cartItems.indexWhere(
      (ci) => ci['item']['id'] == item['id'] && ci['restaurant']['id'] == restaurant['id'],
    );
    if (existingIndex != -1) {
      cartItems[existingIndex] = {...cartItems[existingIndex], 'quantity': cartItems[existingIndex]['quantity'] + 1};
    } else {
      cartItems.add({'item': item, 'restaurant': restaurant, 'quantity': 1});
    }
  }

  void increaseQuantity(int index) {
    cartItems[index] = {...cartItems[index], 'quantity': cartItems[index]['quantity'] + 1};
  }

  void decreaseQuantity(int index) {
    if (cartItems[index]['quantity'] > 1) {
      cartItems[index] = {...cartItems[index], 'quantity': cartItems[index]['quantity'] - 1};
    } else {
      removeFromCart(index);
    }
  }

  void removeFromCart(int index) {
    cartItems.removeAt(index);
  }

  double get subtotal => cartItems.fold(0, (sum, item) => sum + (item['item']['price'] * item['quantity']));

  double get total => subtotal + 5.0;

  void clearCart() {
    cartItems.clear();
  }
}
