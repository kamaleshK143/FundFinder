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

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
