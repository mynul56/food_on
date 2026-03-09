import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantService extends GetxService {
  final String baseUrl = 'http://localhost:5000/api';

  Future<List<dynamic>> getRestaurants() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/restaurants'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getRestaurantById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/restaurants/$id'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {};
    } catch (e) {
      return {};
    }
  }
}
