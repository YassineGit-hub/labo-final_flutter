import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:labo_final/cours.dart';
import 'login.dart';
import 'signup.dart';
import 'profile.dart';
import 'fonctions.dart'; 

class NextScreen extends StatefulWidget {
  NextScreen({Key? key}) : super(key: key);

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  int currentIndex = 0;

  @override
Widget build(BuildContext context) {
  final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

  return Scaffold(
    appBar: AppBar(
              title:const  Text('Espace Etudiants'),
              backgroundColor: Colors.blue,
              actions: [
                IconButton(
                  icon:const Icon(Icons.logout),
                  onPressed: () => deconnexion(context),
                ),
              ],
            ),
    body:const Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Bienvenue à l\'espace étudiants!',
        style: TextStyle(
          color: Color.fromARGB(255, 255, 68, 68),
          fontSize: 24,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Image(image: AssetImage('images/splash.jpg')),
      )
    ],
  ),
),

    bottomNavigationBar: BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(Icons.person),
        ),
        BottomNavigationBarItem(
          label: 'Login',
          icon: Icon(Icons.login),
        ),
        BottomNavigationBarItem(
          label: 'SignUp',
          icon: Icon(Icons.add_box),
        ),
      ],
      currentIndex: currentIndex,
      
      onTap: (int index) async {
        if (index == 0) {
          
          if (user != null) {
            navigateWithTransition(context, Profile());
          } else {
            navigateWithTransition(context, const LoginPage());
          }
        } else if (index == 1) {
          
          if (user != null) {
            navigateWithTransition(context, ListCours());
          } else {
            navigateWithTransition(context, const LoginPage());
          }
        } else if (index == 2) {
          navigateWithTransition(context, const Signup());
        }
      },
    ),
  );
}
}
