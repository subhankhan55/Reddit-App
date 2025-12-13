// lib/features/post/screens/add_post_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/features/post/controller/post_controller.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  // Function to submit the post
  void sharePost() {
    if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).createPost(
        context: context,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
      );
    } else {
      // Simple error handling for empty fields
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in both the title and the body of the post.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the loading state of the PostController
    final isLoading = ref.watch(postControllerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Text Post'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text('POST', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Title Input Field
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter Title here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    maxLength: 30, // Keep titles short
                  ),
                  const SizedBox(height: 12),
                  // Description/Body Input Field
                  Expanded(
                    child: TextField(
                      controller: descriptionController,
                      maxLines: null, // Allows multiline input
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter post body (text only)',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}