import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/app_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/language_provider.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is initialized before async calls

  // Make sure to use real values for these in your actual app
  await SupabaseService().initialize(
      'https://zdawprzqlmhmflbuajlo.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpkYXdwcnpxbG1obWZsYnVhamxvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA1NzQ5MDksImV4cCI6MjA1NjE1MDkwOX0.QhSazeIFBFfDpDBbA7QhO-87FBTn51KZQ1pcaD7lg_g',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'Your App Name',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          locale: languageProvider.currentLocale,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/main': (context) => const MainScreen(),
          },
        );
      },
    );
  }
}