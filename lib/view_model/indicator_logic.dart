import 'dart:async';

import 'package:flutter/material.dart';
import 'package:perfumes_app/core/constants/ads_images.dart';

void startAutoPlay(
  PageController pageController,
  int currentPage,
  Function(int) onPageChanged,
) {
  Timer.periodic(Duration(seconds: 3), (Timer timer) {
    if (currentPage < imageUrls.length - 1) {
      onPageChanged(currentPage + 1);
    } else {
      onPageChanged(0);
    }
    pageController.animateToPage(
      currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  });
}
