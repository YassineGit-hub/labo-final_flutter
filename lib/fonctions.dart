import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'cours.dart';
import 'coursClass.dart';
import 'nextscreen.dart';

// authentification function

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> signInWithEmailAndPassword({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    final UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Connexion réussie!')));

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ListCours()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Erreur de connexion: Veuillez vérifier votre nom d\'utilisateur et votre mot de passe')));
    }
  } catch (e) {
    print(e);
  }
}

// save data to firebase from signup form
Future<void> saveData({
  required String nom,
  required String prenom,
  required String email,
  required String motdepasse,
  required BuildContext context,
}) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: motdepasse,
    );
    String uid = userCredential.user?.uid ?? '';
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'nom': nom,
      'prenom': prenom,
      'email': email,
    });
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Utilisateur enregistré avec succès')));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la création de l\'utilisateur : $e')));
  }
}
// 

//function to change color from string to Color type

Color parseColor(String colorStr) {
  colorStr = colorStr.trim(); 
  
  
  final namedColors = {
    "Colors.teal": Colors.teal,
    "Colors.lightGreen": Colors.lightGreen,
    "Colors.redAccent": Colors.redAccent,
    "Colors.brown": Colors.brown,
    "Colors.orangeAccent": Colors.orangeAccent,
    "Colors.blueAccent": Colors.blueAccent,
    "Colors.greenAccent": Colors.greenAccent,
    "Colors.deepPurpleAccent": Colors.deepPurpleAccent,
    "Colors.pink": Colors.pink,
    "Colors.grey": Colors.grey,
    "Colors.yellow": Colors.yellow
  };

  return namedColors[colorStr] ?? (throw FormatException("Unknown color format: $colorStr"));
}


//function to validate email:

   String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer une adresse e-mail.';
  }
  
  if (!EmailValidator.validate(value)) {
    return 'Veuillez entrer une adresse e-mail valide.';
  }
  
  return null;
}

//function to validate name:

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un nom';
    }
    if (value.length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    if (value.length > 50) {
      return 'Le nom ne doit pas dépasser 50 caractères';
    }

    return null;
  }

//map data from firebase
 Map<String, dynamic> coursToMap(Cours cours) {
    return {
      'titre': cours.titre,
      'description': cours.description,
      'imagePath': cours.imagePath,
      'couleur': cours.couleur.value,
    };
}

//signOut function
  Future<void> deconnexion(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NextScreen()));
  }
     
// navigation fonction

void navigateWithTransition(BuildContext context, Widget page, {Duration duration = const Duration(milliseconds: 300)}) {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var opacityAnimation = animation.drive(tween);
        return FadeTransition(opacity: opacityAnimation, child: child);
      },
    ),
  );
}
