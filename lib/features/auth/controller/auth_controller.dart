import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:reddit_app/features/auth/repository/auth_repository.dart';
import 'package:reddit_app/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.read(AuthRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangesProvider = StreamProvider(
    (ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChanges; // Use the getter from AuthController
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
    _authRepository.signInWithGoogle();
    state=false;
  }
    Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}