import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fundfinderff/Screens/BottomBar/bottombar.dart';
import 'package:fundfinderff/Screens/Login/login.dart';
import 'package:fundfinderff/Screens/Login/Signin.dart';
import 'package:fundfinderff/Screens/UserInfo/userinfo.dart';
import 'package:fundfinderff/Screens/Chatbot/chat_provider.dart';
import 'package:fundfinderff/state/auth_provider.dart';
import 'package:fundfinderff/state/profile_provider.dart';
import 'package:fundfinderff/state/match_provider.dart';
import 'package:fundfinderff/state/theme_provider.dart';
import 'package:fundfinderff/theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..init()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FundFinder',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: context.watch<ThemeProvider>().themeMode,
      routes: {
        '/login': (context) => const Login(),
        '/signin': (context) => const Signin(),
        '/userinfo': (context) => const Userinfo(),
        '/home': (context) => const BottomNav(),
      },
      home: const AuthGate(),
    );
  }
}

/// Replaces the old FirebaseAuth.authStateChanges() StreamBuilder, whose two
/// branches both returned Signin() - meaning the app always opened on
/// sign-up regardless of login state. This checks the actual stored access
/// token instead.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.checkAuthStatus();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => authProvider.isLoggedIn ? const BottomNav() : const Login(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
