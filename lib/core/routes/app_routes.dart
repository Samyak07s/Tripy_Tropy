import 'package:flutter/material.dart';
import 'package:tripy_tropy/presentation/screens/auth/login_screen.dart';
import 'package:tripy_tropy/presentation/screens/auth/signup_screen.dart';
import 'package:tripy_tropy/presentation/screens/home/Itinerary_screen.dart';
import 'package:tripy_tropy/presentation/screens/home/created_page.dart';
import 'package:tripy_tropy/presentation/screens/home/creating_page.dart';
import 'package:tripy_tropy/presentation/screens/home/follow_up_chat_screen.dart';
import 'package:tripy_tropy/presentation/screens/home/home_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String creating = '/creating';
  static const String created = '/created';
  static const String Itinerary = '/Itinerary';
  static const String followUpChat = '/follow';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      // case creating:
      //   final prompt = settings.arguments as String;
      //   return MaterialPageRoute(
      //     builder: (_) => ItineraryCreatingPage(prompt: prompt),
      //   );
      case created:
        return MaterialPageRoute(builder: (_) => const ItineraryCreatedPage());
      case Itinerary:
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ItineraryScreen(prompt: args),
        );

      case followUpChat:
        return MaterialPageRoute(
          builder: (_) => const FollowUpChatScreen(),
          settings: settings, // ✅ Pass arguments here
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("No route found")),
          ),
        );
    }
  }
}
