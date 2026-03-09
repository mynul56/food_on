import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  var currentPage = 0.obs;

  final onboardingData = [
    {
      'title': 'Discover Restaurants',
      'description':
          'Search and find the best restaurants near you with amazing dishes.',
      'image': 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png',
    },
    {
      'title': 'Easy Ordering',
      'description':
          'Pick your favorite food and order with just a few clicks.',
      'image': 'https://cdn-icons-png.flaticon.com/512/3595/3595455.png',
    },
    {
      'title': 'Fast Delivery',
      'description': 'Enjoy super fast delivery right to your doorstep.',
      'image': 'https://cdn-icons-png.flaticon.com/512/2252/2252438.png',
    },
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void next() {
    if (currentPage.value < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  void skip() {
    Get.offAllNamed(AppRoutes.login);
  }
}
