// lib/theme/theme_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/theme/pallete.dart';

// 1. Theme State Provider
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeData>(
  (ref) {
    // Initial state defaults to Dark Mode
    return ThemeNotifier();
  },
);

class ThemeNotifier extends StateNotifier<ThemeData> {
  // Initial state is Dark Mode
  ThemeNotifier() : super(Pallete.darkModeAppTheme);

  // 2. Public method to toggle the theme
  void toggleTheme() {
    if (state.brightness == Brightness.dark) {
      // If currently dark, switch to light
      state = Pallete.lightModeAppTheme;
    } else {
      // If currently light, switch to dark
      state = Pallete.darkModeAppTheme;
    }
  }
}