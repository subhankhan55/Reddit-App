// lib/features/auth/repository/auth_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/constants/firebase_constants.dart';
import 'package:reddit_app/core/providers/firebase_provider.dart';
import 'package:reddit_app/core/type_defs.dart'; // Import FutureVoid
import 'package:reddit_app/models/user_model.dart';

final AuthRepositoryProvider = Provider((ref) =>
  AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;
        
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
      
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      UserModel userModel;
      
      if(userCredential.additionalUserInfo!.isNewUser){
         userModel = UserModel(
            uid: userCredential.user!.uid,
            name: userCredential.user!.displayName ?? '',
            // email: userCredential.user!.email ?? '',
            profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
            banner: Constants.bannerDefault,
            isAuthenticated: 'true',
            karma: 0,
            awards: [],
            // createdAt: DateTime.now(),
          );
          await _users.doc(userModel.uid).set(userModel.toMap());
       } else {
         userModel = await getUserData(userCredential.user!.uid).first;
       }
     
      print(userCredential.user?.email);
    } catch (e) {
      print(e);
      // NOTE: For simplicity, we are just printing the error, but in a real app, you would handle the failure here.
    }
  }
  
  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(
        event.data() as Map<String, dynamic>));
  }

  // NEW METHOD: Handles the actual Firebase and Google Sign Out
  FutureVoid logOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}