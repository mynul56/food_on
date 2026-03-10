import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/constants.dart';

class AuthService extends GetxService {
  late SharedPreferences _prefs;
  final _token = RxnString();
  String? get token => _token.value;

  @override
  void onInit() async {
    _prefs = await SharedPreferences.getInstance();
    _token.value = _prefs.getString(AppConstants.tokenKey);
    super.onInit();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('${AppConstants.apiUrl}/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final data = jsonDecode(response.body);
          if (data['token'] != null) {
            await saveToken(data['token']);
            await _prefs.setString(
              AppConstants.userKey,
              jsonEncode(data['user']),
            );
          }
          return data;
        } catch (e) {
          return {'message': 'Invalid server response'};
        }
      } else {
        try {
          final data = jsonDecode(response.body);
          return {
            'message':
                data['message'] ??
                'Login failed. Status: ${response.statusCode}',
          };
        } catch (e) {
          return {'message': 'Login failed. Status: ${response.statusCode}'};
        }
      }
    } catch (e) {
      return {'message': 'Connection error: ${e.toString().split('\n')[0]}'};
    }
  }

  Future<void> saveToken(String token) async {
    _token.value = token;
    await _prefs.setString(AppConstants.tokenKey, token);
  }

  Future<void> logout() async {
    _token.value = null;
    await _prefs.remove(AppConstants.tokenKey);
    await _prefs.remove(AppConstants.userKey);
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.apiUrl}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      final data = jsonDecode(response.body);
      if (data['token'] != null) {
        await saveToken(data['token']);
      }
      return data;
    } catch (e) {
      return {'message': 'Connection error'};
    }
  }
}
