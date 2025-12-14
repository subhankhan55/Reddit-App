// lib/features/auth/controller/auth_controller.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:reddit_app/core/type_defs.dart'; 
import 'package:reddit_app/features/auth/repository/auth_repository.dart';
import 'package:reddit_app/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

// NEW PROVIDER: Tracks whether the user is in Guest Mode
final isGuestProvider = StateProvider<bool>((ref) => false); 

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.read(AuthRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangesProvider = StreamProvider(
    (ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChanges; 
});

final getUserDataProvider=StreamProvider.family((ref, String uid){
  final authController=ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository, _ref = ref, super(false) ;

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  void signInWithGoogle(BuildContext context) async{
    state=true;
    // Reset guest flag upon successful sign-in
    _ref.read(isGuestProvider.notifier).update((state) => false);
    _authRepository.signInWithGoogle(); 
    state=false;
  }
  
  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  // NEW METHOD: Handles the logout process
  void logOut() async {
    // Reset guest flag upon logging out
    _ref.read(isGuestProvider.notifier).update((state) => false);
    await _authRepository.logOut();
    // Clear the local user state in Riverpod
    _ref.read(userProvider.notifier).update((state) => null);
  }
}