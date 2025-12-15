// lib/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/post/controller/post_controller.dart';
import 'package:routemaster/routemaster.dart'; 
// NEW IMPORT for theme control
import 'package:reddit_app/theme/theme_controller.dart'; 


class HomeScreen extends ConsumerWidget { 
  const HomeScreen({super.key});

  void navigateToAddPost(BuildContext context) {
    Routemaster.of(context).push('/add-post');
  }
  void navigateToUserProfile(BuildContext context) {
    Routemaster.of(context).push('/user-profile');
  }

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToLogin(WidgetRef ref, BuildContext context) {
    // 1. Reset the guest flag to false.
    ref.read(isGuestProvider.notifier).update((state) => false);
    
    // 2. Pop the current route (HomeScreen).
    Routemaster.of(context).pop(); 
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isGuest = user == null;
    final userData = ref.watch(userProvider);
    
    // Determine the current theme brightness to show the opposite icon
    final currentThemeIsDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Feed'),
        centerTitle: false,
        actions: [
          // 1. DYNAMIC BUTTON (Logout or Sign In)
          if (isGuest)
            // Guest Mode: Functional Sign In button
            TextButton(
              onPressed: () => navigateToLogin(ref, context), 
              child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          else
            // Logged-In Mode: Theme Toggle, Profile Icon, and Logout Button
            Row(
              children: [
                
                // --- NEW: THEME TOGGLE BUTTON ---
                IconButton(
                  // Show sun if currently dark, show moon if currently light
                  icon: Icon(currentThemeIsDark ? Icons.light_mode : Icons.dark_mode),
                  onPressed: () {
                    // Call the toggleTheme method from the ThemeNotifier
                    ref.read(themeNotifierProvider.notifier).toggleTheme();
                  },
                  tooltip: 'Toggle Theme',
                ),
                // --- END NEW ---

                // Profile Placeholder
                GestureDetector( 
                  onTap: () => navigateToUserProfile(context),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0), 
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Text(userData!.name[0]), 
                      radius: 16,
                    ),
                  ),
                ),
                // Logout Button
                IconButton(
                  onPressed: () => logOut(ref), 
                  icon: const Icon(Icons.logout),
                  tooltip: 'Log Out',
                ),
              ],
            ),
        ],
      ),
      // ... (rest of the body remains the same)
      body: ref.watch(guestPostsProvider).when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text('No posts yet! Be the first to post.'));
          }
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              
              return Card(
                key: ValueKey(post.id), 
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      Text(post.description, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6))),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Posted by: ${post.authorUid.substring(0, 5)}...', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(post.createdAt.toString().substring(0, 16), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
      floatingActionButton: isGuest
          ? null
          : FloatingActionButton(
              onPressed: () => navigateToAddPost(context),
              child: const Icon(Icons.add),
            ),
    );
  }
}