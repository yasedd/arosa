import 'package:arosa/pages/About.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pages/State_tools.dart';
import 'auth/Singup_page.dart';
import 'package:flutter/material.dart';
import 'auth/Login_page.dart';
import 'pages/Home_page.dart';
import 'pages/User_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: State_tools(),
      theme: ThemeData(
          primaryColor: Colors.blueAccent,
          listTileTheme: const ListTileThemeData(
              titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(196, 0, 0, 0))),
          textTheme: const TextTheme(
              titleLarge:
                  TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      debugShowCheckedModeBanner: false,
      routes: {
        'Home': (context) => const Home_page(),
        'Login': (context) => const Login_page(),
        'SignUp': (context) => const Signup_page(),
        'User_info': (context) => const User_info(),
        'About': (context) => const About(),
        'State_tools': (context) => const State_tools()
      },
    );
  }
}
