import 'package:get/get.dart';

import '../modules/address/views/address_view.dart';
import '../modules/admin/bindings/admin_binding.dart';
import '../modules/admin/views/admin_dashboard_view.dart';
import '../modules/admin/views/admin_restaurants_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/restaurant/bindings/restaurant_binding.dart';
import '../modules/restaurant/views/restaurant_view.dart';
import '../modules/restaurant_admin/bindings/restaurant_admin_binding.dart';
import '../modules/restaurant_admin/views/restaurant_admin_dashboard_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/super_admin/bindings/super_admin_binding.dart';
import '../modules/super_admin/views/super_admin_dashboard_view.dart';
import '../modules/super_admin/views/super_admin_restaurants_view.dart';
import '../modules/super_admin/views/super_admin_users_view.dart';

class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const main = '/main';
  // Legacy aliases kept so any Get.toNamed('/home') still compiles
  static const home = '/main';
  static const restaurantDetails = '/restaurant-details';
  static const cart = '/main';
  static const orderTracking = '/main';
  static const profile = '/main';
  static const adminDashboard = '/admin-dashboard';
  static const adminOrders = '/admin-orders';
  static const adminRestaurants = '/admin-restaurants';
  static const search = '/search';
  static const notifications = '/notifications';
  static const address = '/address';
  // Super Admin
  static const superAdminDashboard = '/super-admin-dashboard';
  static const superAdminUsers = '/super-admin-users';
  static const superAdminRestaurants = '/super-admin-restaurants';
  // Restaurant Admin
  static const restaurantAdminDashboard = '/restaurant-admin-dashboard';
}

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashView(), binding: SplashBinding()),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingView(), binding: OnboardingBinding()),
    GetPage(name: AppRoutes.login, page: () => const LoginView(), binding: AuthBinding()),
    GetPage(name: AppRoutes.register, page: () => const RegisterView(), binding: AuthBinding()),
    GetPage(name: AppRoutes.main, page: () => const MainView(), binding: MainBinding()),
    GetPage(name: AppRoutes.restaurantDetails, page: () => const RestaurantView(), binding: RestaurantBinding()),
    // Admin Pages
    GetPage(name: AppRoutes.adminDashboard, page: () => const AdminDashboardView(), binding: AdminBinding()),
    GetPage(name: AppRoutes.adminRestaurants, page: () => const AdminRestaurantsView(), binding: AdminBinding()),
    // Standalone push pages
    GetPage(name: AppRoutes.search, page: () => const SearchView(), binding: SearchBinding()),
    GetPage(name: AppRoutes.notifications, page: () => const NotificationsView(), binding: NotificationsBinding()),
    GetPage(name: AppRoutes.address, page: () => const AddressView()),
    // Super Admin Pages
    GetPage(name: AppRoutes.superAdminDashboard, page: () => const SuperAdminDashboardView(), binding: SuperAdminBinding()),
    GetPage(name: AppRoutes.superAdminUsers, page: () => const SuperAdminUsersView(), binding: SuperAdminBinding()),
    GetPage(
      name: AppRoutes.superAdminRestaurants,
      page: () => const SuperAdminRestaurantsView(),
      binding: SuperAdminBinding(),
    ),
    // Restaurant Admin Pages
    GetPage(
      name: AppRoutes.restaurantAdminDashboard,
      page: () => const RestaurantAdminDashboardView(),
      binding: RestaurantAdminBinding(),
    ),
  ];
}
