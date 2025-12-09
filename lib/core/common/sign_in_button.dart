import 'package:flutter/material.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/theme/pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/features/auth/repository/auth_repository.dart';

//Provider Ref allows provider to interact with provider
//Widet Ref allows Widget to interact with provider
// Thats why we use ConsumerWidget
class SignInButton extends ConsumerWidget{
  const SignInButton({super.key});
  void signInWithGoogle(WidgetRef ref){
    ref.read(AuthRepositoryProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
              onPressed: () =>signInWithGoogle(ref),
              icon: Image.asset(Constants.googlePath, width: 35),
              label: const Text('Continue with Google', style: TextStyle(fontSize: 18),),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.greyColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  ),
              )
              ),
    );
    
  }
}