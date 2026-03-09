import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.onboardingData.length,
                itemBuilder: (context, index) {
                  final data = controller.onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(data['image']!, height: 300),
                        const SizedBox(height: 40),
                        Text(
                          data['title']!,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          data['description']!,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Row(
                      children: List.generate(
                        controller.onboardingData.length,
                        (index) => Container(
                          margin: const EdgeInsets.only(right: 5),
                          height: 10,
                          width: controller.currentPage.value == index
                              ? 25
                              : 10,
                          decoration: BoxDecoration(
                            color: controller.currentPage.value == index
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => ElevatedButton(
                      onPressed: controller.next,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(120, 50),
                      ),
                      child: Text(
                        controller.currentPage.value ==
                                controller.onboardingData.length - 1
                            ? 'Get Started'
                            : 'Next',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
