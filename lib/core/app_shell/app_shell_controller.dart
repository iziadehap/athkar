import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  // Track the current active screen index
  var currentIndex = 0.obs;

  // The PageController handles the underlying sliding physics
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentIndex.value);
  }

  // Smoothly slide to the page when a tab item is clicked
  void animateToPage(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Update index cleanly if the user physically swipes the screen
  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}