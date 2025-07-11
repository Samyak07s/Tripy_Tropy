import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tripy_tropy/application/providers/auth_provider.dart';
import 'package:tripy_tropy/core/constants/app_colors.dart';
import 'package:tripy_tropy/core/routes/app_routes.dart';
import 'package:tripy_tropy/data/models/itinerary_model.dart';
import 'package:tripy_tropy/firebase_options.dart';
import 'package:tripy_tropy/presentation/screens/auth/login_screen.dart';
import 'package:tripy_tropy/presentation/screens/home/home_screen.dart';

/// ✅ Global RouteObserver for screen transitions
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);

  Hive.registerAdapter(ItineraryModelAdapter());
  await Hive.openBox<ItineraryModel>('saved_itineraries');

  runApp(const ProviderScope(child: TripyAIApp()));
}

class TripyAIApp extends ConsumerWidget {
  const TripyAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Tripy AI',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.greenAccent,
        cardColor: AppColors.surface,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.greenAccent,
          selectionColor: Colors.white24,
          selectionHandleColor: AppColors.greenAccent,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textPrimary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.greenAccent,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.greenAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.gold),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.errorRed,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,

      /// ✅ This enables route tracking for back navigation detection
      navigatorObservers: [routeObserver],

      home: authState.when(
        data: (user) => user != null ? const HomeScreen() : const LoginScreen(),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      ),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
