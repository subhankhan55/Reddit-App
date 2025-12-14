// lib/router.dart

import 'package:flutter/material.dart';
import 'package:reddit_app/features/auth/screen/login_screen.dart';
import 'package:reddit_app/features/home/screens/home_screen.dart';
import 'package:reddit_app/features/post/screens/add_post_screen.dart';
import 'package:routemaster/routemaster.dart';
import 'package:reddit_app/features/home/screens/profile_screen.dart'; // <-- NEW IMPORT

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen())
  });
//login
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/add-post': (_) => const MaterialPage(child: AddPostScreen()),
  '/user-profile': (_) => const MaterialPage(child: ProfileScreen()), // <-- NEW ROUTE
  });