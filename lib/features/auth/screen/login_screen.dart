// lib/features/auth/screen/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // NEW IMPORT
import 'package:reddit_app/core/common/sign_in_button.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart'; // REQUIRED IMPORT
import 'package:routemaster/routemaster.dart'; 

// Change StatelessWidget to ConsumerWidget
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  // Function to set flag and pop
  void navigateToHomeAsGuest(WidgetRef ref, BuildContext context) {
    // 1. Set the global flag to true
    ref.read(isGuestProvider.notifier).update((state) => true);
    
    // 2. Pop the current route (LoginScreen). main.dart will push HomeScreen.
    Routemaster.of(context).pop(); 
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Access ref here
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(Constants.logoPath, height: 40),
        actions: [
          TextButton(
            onPressed: () => navigateToHomeAsGuest(ref, context),
            child: const Text(
              'Skip',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'Dive into anything',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                Constants.loginEmotePath,
                height: 400,
              ),
            ),
            const SizedBox(height: 20),
            const SignInButton(),
          ],
        ),
      ),
    );
  }
}