import 'package:easyattend/core/router/app_router.dart';
import 'package:easyattend/core/themes/app_theme.dart';
import 'package:easyattend/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() async {
  // 1. Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. Set transparent status bar
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  
  // 4. Launch app with Riverpod state management
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Configure MaterialApp with:
    // - GoRouter for navigation
    // - Dark theme
    // - No debug banner
    return MaterialApp.router(
      title: "Easyattend",
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: ref.read(goRouterProvider),
    );
  }
}

