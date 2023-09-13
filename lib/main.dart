import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:labo_final/cours.dart';
import 'login.dart';
import 'fonctions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Espace Etudiants',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(305, 164, 183, 58)),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
        splash: const Icon(Icons.school, size: 100),
        splashTransition: SplashTransition.scaleTransition,
        duration: 2000,
        backgroundColor: Colors.blue,
        nextScreen: SplashScreen(), 
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkSessionAndNavigate();
  }

  void checkSessionAndNavigate() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    print(user);

    await Future.delayed(const Duration(seconds: 2));

    if (user != null) {
      navigateWithTransition(context, ListCours());
    } else {
      navigateWithTransition(context, LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

@override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Espace Etudiants',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(305, 164, 183, 58)),
      useMaterial3: true,
    ),
    home: AnimatedSplashScreen(
      splash: const Icon(Icons.school, size: 100),
      splashTransition: SplashTransition.scaleTransition,
      duration: 2000,
      backgroundColor: Colors.blue,
      nextScreen: SplashScreen(),
    ),
  );
}





