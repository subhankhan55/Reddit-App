// lib/features/post/repository/post_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/constants/firebase_constants.dart';
import 'package:reddit_app/core/providers/firebase_provider.dart';
import 'package:reddit_app/core/type_defs.dart';
import 'package:reddit_app/models/post_model.dart';

// 1. Provider for the PostRepository
final PostRepositoryProvider = Provider((ref) {
  return PostRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // 2. FIX: Public getter for the 'posts' Firestore collection
  CollectionReference get posts => _firestore.collection(FirebaseConstants.postsCollection);

  // 3. Method to create a post (Simplified: throws exception on error, returns void on success)
  FutureVoid addPost(PostModel post) async {
    try {
      await posts.doc(post.id).set(post.toMap());
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? 'An unknown Firebase error occurred.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // 4. Method to fetch ALL posts for the Global Feed
  Stream<List<PostModel>> fetchAllPosts() {
    return posts
        .orderBy('createdAt', descending: true) // Order by latest first
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // 5. Method to fetch posts by a specific user (for the Profile Screen)
  Stream<List<PostModel>> fetchUserPosts(String uid) {
    return posts
        .where('authorUid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}