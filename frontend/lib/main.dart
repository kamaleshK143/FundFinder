


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fundfinderff/Screens/Login/login.dart';
import 'package:fundfinderff/Screens/UserInfo/userinfo.dart';
import 'package:fundfinderff/Screens/BottomBar/bottombar.dart';
import 'package:fundfinderff/Screens/Chatbot/chat_provider.dart'; // Import your provider
import 'package:fundfinderff/Screens/Login/Signin.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'firebase_options.dart';
import 'upload_scholarship.dart'; // Import the scholarship uploader

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Upload scholarships when the app starts
  ScholarshipUploader uploader = ScholarshipUploader();
  await uploader.uploadScholarships();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ChatProvider()), // Add Provider Here
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 👇 Add this
      routes: {
        '/login': (context) => const Login(),
        '/signin': (context) => const Signin(),
        '/userinfo': (context) => const Userinfo(),
        '/home': (context) => const BottomNav(),
      },
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return Signin(); // This should be your logged-in home
          }
          return  Signin(); // Or Login screen if you prefer
        },
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (ctx, snapshot) {
//           if (snapshot.hasData) {
//             return Login();
//           }
//           return Userinfo();
//         },
//       ),
//     );
//   }
// }
