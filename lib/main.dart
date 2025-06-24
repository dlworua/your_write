import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/app_routes.dart';
import 'package:your_write/ui/pages/auth/email/auth_state_warpper.dart';
import 'package:your_write/ui/pages/auth/email/email_login_page.dart';
import 'package:your_write/ui/pages/main_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print(const String.fromEnvironment('GEMINI_API_KEY'));
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthStateWrapper(
        loggedInWidget: const MainPage(),
        loggedOutWidget: const EmailLoginPage(),
      ),
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
