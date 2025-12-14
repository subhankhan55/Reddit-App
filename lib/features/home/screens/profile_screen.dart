// lib/features/home/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/post/controller/post_controller.dart';
import 'package:reddit_app/models/post_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get the current user data (MUST NOT BE NULL since we are in loggedInRoute)
    final user = ref.watch(userProvider);
    final uid = user!.uid; 

    // 2. Watch the stream of posts for the current user
    final userPostsStream = ref.watch(userPostsProvider(uid));

    // 3. Build the UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        centerTitle: false,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // --- PROFILE HEADER (SliverToBoxAdapter) ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profile Picture/Avatar
                    CircleAvatar(
                      // Using a placeholder image or a simple colored avatar
                      backgroundColor: Colors.blueGrey,
                      radius: 40,
                      child: Text(
                        user.name[0], // Display first letter of name
                        style: const TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // User Name
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // User UID (as placeholder for a bio/karma display)
                    Text(
                      'UID: ${user.uid.substring(0, 8)}...',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Separator
                    const Divider(),
                  ],
                ),
              ),
            ),
            
            // --- HEADER FOR USER POSTS ---
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Your Posts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ];
        },
        
        // --- BODY: USER POST LIST (ListView) ---
        body: userPostsStream.when(
          data: (posts) {
            if (posts.isEmpty) {
              return const Center(child: Text('You have not made any posts yet!'));
            }
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                
                // Using the basic Card widget here for consistency with HomeScreen
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
                        Text(post.createdAt.toString().substring(0, 16), style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
      ),
    );
  }
}