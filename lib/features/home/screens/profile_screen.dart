// lib/features/home/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/post/controller/post_controller.dart';
import 'package:reddit_app/models/post_model.dart';

// --- Helper function to show the edit dialog ---
void _showEditDialog(BuildContext context, WidgetRef ref, PostModel post) {
  final postController = ref.read(postControllerProvider.notifier);
  // Initialize controllers with current post data
  final titleController = TextEditingController(text: post.title);
  final descriptionController = TextEditingController(text: post.description);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              maxLength: 30, 
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Basic validation
              if (titleController.text.trim().isNotEmpty && descriptionController.text.trim().isNotEmpty) {
                // Call the controller's edit method
                postController.editPost(
                  context: context,
                  post: post,
                  newTitle: titleController.text.trim(),
                  newDescription: descriptionController.text.trim(),
                );
                Navigator.of(context).pop(); // Close the dialog
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  ).then((_) {
    // Clean up controllers after dialog closes
    titleController.dispose();
    descriptionController.dispose();
  });
}
// --- End Helper Function ---


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final uid = user!.uid; 
    final userPostsStream = ref.watch(userPostsProvider(uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        centerTitle: false,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // --- PROFILE HEADER (Existing) ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profile Picture/Avatar
                    CircleAvatar(
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
                    // User UID
                    Text(
                      'UID: ${user.uid.substring(0, 8)}...',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                  ],
                ),
              ),
            ),
            
            // --- HEADER FOR USER POSTS (Existing) ---
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
                
                final postController = ref.read(postControllerProvider.notifier);

                return Card(
                  key: ValueKey(post.id),
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Post Title, Edit Button, and Delete Button Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                post.title, 
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            
                            // --- EDIT AND DELETE BUTTONS ---
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 1. EDIT BUTTON
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _showEditDialog(context, ref, post), // <-- WIRED UP EDIT
                                ),
                                // 2. DELETE BUTTON
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => postController.deletePost(context, post),
                                ),
                              ],
                            ),
                            // --- END FIX ---
                          ],
                        ),
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