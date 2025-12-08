//log out
import 'package:flutter/material.dart';
import 'package:reddit_app/features/auth/screen/login_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen())
  });
//login
