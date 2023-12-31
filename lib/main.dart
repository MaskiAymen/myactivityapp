import 'package:firebase_core/firebase_core.dart';
import 'package:myactivityapp/Home.dart';
import 'package:myactivityapp/screens/ajouter_activity.dart';
import 'package:myactivityapp/screens/detail_activity.dart';
import 'package:myactivityapp/screens/signin_screen.dart';


import 'firebase_options.dart';
import 'package:flutter/material.dart';


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
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const SignInScreen(),
      //home: const Home(),
      home: const SignInScreen(),
    );
  }
}