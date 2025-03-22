import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/main_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/app_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/language_provider.dart';
import 'providers/week_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures Flutter is initialized before async calls

  // Load environment variables
  await dotenv.load();

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => WeekProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, AuthService>(
      builder: (context, languageProvider, authService, child) {
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
          home: authService.currentUser != null
              ? const MainScreen()
              : const SplashScreen(),
          onGenerateRoute: (settings) {
            if (authService.currentUser == null &&
                settings.name != '/splash' &&
                settings.name != '/login' &&
                settings.name != '/signup') {
              return MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              );
            }
            // Return null to use the routes defined below
            return null;
          },
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
