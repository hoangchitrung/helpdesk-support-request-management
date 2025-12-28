import 'package:flutter/material.dart';
import 'package:src/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:src/screens/auth/register_screen.dart';
import 'package:src/screens/users/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Helpdesk Support Request App",
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
