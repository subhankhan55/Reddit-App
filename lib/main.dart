// lib/main.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/models/user_model.dart';
import 'package:reddit_app/router.dart';
// NEW IMPORT
import 'package:reddit_app/theme/theme_controller.dart'; 
// REMOVED: import 'package:reddit_app/theme/pallete.dart'; (Not strictly needed here now)

import 'package:firebase_core/firebase_core.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  
  void getData(WidgetRef ref, User data) async {
    userModel = await ref.watch(authControllerProvider.notifier).getUserData(data.uid).first;
    ref.read(userProvider.notifier).update((state)=>userModel);
    setState(() {
      
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Watch the new isGuestProvider flag
    final isGuest = ref.watch(isGuestProvider); 
    
    // NEW: Watch the dynamic theme provider
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(authStateChangesProvider).when(data:(data)=>MaterialApp.router(
      title: 'Reddit App',
      // FIX: Use the dynamic theme from the provider
      theme: currentTheme, 
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        
        // 1. Logged In User logic
        if (data != null) {
            getData(ref, data);
            if(userModel!=null){
                return loggedInRoute; 
            }
        }
        
        // 2. Guest Mode (User clicked Skip)
        if (data == null && isGuest) {
            return loggedInRoute; 
        }
        
        // 3. Default (Initial App Launch)
        return loggedOutRoute;
      }),
      routeInformationParser: const  RoutemasterParser(),
    ),error:(error, StackTrace)=>ErrorText(error: error.toString()), loading: ()=>const Loader(),);  
  }
}