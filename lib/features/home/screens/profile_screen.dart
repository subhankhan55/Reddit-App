// lib/features/home/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/post/controller/post_controller.dart';
import 'package:reddit_app/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current UserModel from Riverpod
    final user = ref.watch(userProvider);

    // Safety check: The user should always be logged in here, but we check anyway.
    if (user == null) {
      return const ErrorText(error: 'User data not found. Please log in again.');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. Profile Header ---
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).cardColor,
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePic),
                    radius: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'u/${user.name}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Karma: ${user.karma}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Placeholder for an Edit Profile Button (Optional future feature)
                  OutlinedButton(
                    onPressed: () {
                      // Navigate to edit profile screen (not implemented yet)
                    },
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
            
            const Divider(thickness: 8),

            // --- 2. User's Posts Feed ---
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Posts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Watch the userPostsProvider to show posts by this specific user
            ref.watch(userPostsProvider(user.uid)).when(
              data: (posts) {
                if (posts.isEmpty) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text('You have not created any posts yet.'),
                  ));
                }

                // Use ListView.builder inside a Column requires shrinking it
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), // Important for nested scroll views
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              post.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6)),
                            ),
                            // Simplified post footer, showing only creation time
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Posted on: ${post.createdAt.toString().substring(0, 16)}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
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
          ],
        ),
      ),
    );
  }
}