// lib/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/post/controller/post_controller.dart';
import 'package:routemaster/routemaster.dart'; // Needed for navigation

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // Function to navigate to the post creation screen
  void navigateToAddPost(BuildContext context) {
    Routemaster.of(context).push('/add-post');
  }

  // NEW FUNCTION: Function to navigate to the user profile screen
  void navigateToUserProfile(BuildContext context) {
    Routemaster.of(context).push('/user-profile');
  }

  // Function to log out the user
  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if the user is a guest (userProvider will be null if logged out)
    final user = ref.watch(userProvider);
    final isGuest = user == null;
    
    // Get the current user's data to display the profile picture
    final userData = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Feed'),
        centerTitle: false,
        actions: [
          // 1. Profile Navigation Button
          if (!isGuest && userData != null) // Only show if user is logged in
            GestureDetector(
              onTap: () => navigateToUserProfile(context),
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(userData.profilePic),
                  radius: 16,
                ),
              ),
            ),

          // 2. Logout Button
          IconButton(
            onPressed: isGuest ? null : () => logOut(ref),
            icon: const Icon(Icons.logout),
            tooltip: 'Log Out',
          ),
        ],
      ),
      // Display the Global Post Feed
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
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post Title
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Post Description Snippet
                      Text(
                        post.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6)),
                      ),
                      const SizedBox(height: 8),
                      // Author and Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // Displaying only the first 5 characters of UID as placeholder for author name
                            'Posted by: ${post.authorUid.substring(0, 5)}...', 
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            post.createdAt.toString().substring(0, 16),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
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
      // Floating Action Button to Add Post (Only visible if logged in)
      floatingActionButton: isGuest
          ? null
          : FloatingActionButton(
              onPressed: () => navigateToAddPost(context),
              child: const Icon(Icons.add),
            ),
    );
  }
}
