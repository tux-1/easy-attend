import 'package:easyattend/core/router/not_found_screen.dart';
import 'package:easyattend/modules/auth/ui/screens/get_started_screen.dart';
import 'package:easyattend/modules/auth/ui/screens/log_in_screen.dart';
import 'package:easyattend/modules/auth/ui/screens/register_screen.dart';
import 'package:easyattend/modules/generate/ui/views/lecture_qr_code_screen.dart';
import 'package:easyattend/modules/home/ui/home_screen.dart';
import 'package:easyattend/modules/settings/ui/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  AppRoutes._();

  // Route paths
  static const String home = '/';
  static const String register = '/register';
  static const String login = '/login';

  static const String getStarted = "/get-started";
  static const String lectureQrCode = '/lecture/:id';
  static const String settingsScreen = '/settings';
}

final goRouterProvider = Provider<GoRouter>((ref) {

  return GoRouter(
    debugLogDiagnostics: true,

    initialLocation:
        FirebaseAuth.instance.currentUser == null
            ? AppRoutes.getStarted
            : AppRoutes.home,
        
    routes: [
      GoRoute(
        path: AppRoutes.getStarted,
        builder: (_, __) => const GetStartedScreen(),
      ),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(path: AppRoutes.home, builder: (_, __) => HomeScreen()),
      GoRoute(path: AppRoutes.settingsScreen, builder: (_, __) => SettingsScreen()),

      GoRoute(
        name: AppRoutes.lectureQrCode,
        path: AppRoutes.lectureQrCode,
        builder: (BuildContext context, GoRouterState state) {
          final String id = state.pathParameters['id']!;
          return LectureQrCodeScreen(id: id);
        },
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
