import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  var currentPage = 0.obs;

  final onboardingData = [
    {
      'title': 'Discover Restaurants',
      'description': 'Find the best restaurants near you with amazing dishes and great deals.',
      'emoji': '🍔',
    },
    {
      'title': 'Easy Ordering',
      'description': 'Pick your favorites from the menu and order in just a few taps.',
      'emoji': '🛒',
    },
    {
      'title': 'Fast Delivery',
      'description': 'Sit back and relax — your food arrives hot and fresh at your door.',
      'emoji': '🚀',
    },
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void next() {
    if (currentPage.value < onboardingData.length - 1) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  void skip() {
    Get.offAllNamed(AppRoutes.login);
  }
}
