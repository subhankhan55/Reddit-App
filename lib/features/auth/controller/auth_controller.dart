import 'package:reddit_app/features/auth/repository/auth_repository.dart';

final AuthControllerProvider = Provider((ref)=>AuthController(authRepository: ref.read(authRepositoryProvider),),);

class AuthController {
  final AuthRepository _authRepository;
  AuthController({required AuthRepository authRepository)} : _authRepository = authRepository;
  void signWithGoogle(){
    _authRepository.signWithGoogle(); 
  }
}
