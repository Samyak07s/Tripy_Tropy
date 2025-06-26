import 'package:flutter/material.dart';
import 'package:tripy_tropy/presentation/screens/auth/login_screen.dart';
import 'package:tripy_tropy/presentation/screens/auth/signup_screen.dart';
import 'package:tripy_tropy/presentation/screens/home/created_page.dart';
import 'package:tripy_tropy/presentation/screens/home/creating_page.dart';
import 'package:tripy_tropy/presentation/screens/home/home_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String creating = '/creating';
  static const String created = '/created';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case creating:
        return MaterialPageRoute(builder: (_) => const ItineraryCreatingPage());
      case created:
        return MaterialPageRoute(builder: (_) => const ItineraryCreatedPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("No route found")),
          ),
        );
    }
  }
}