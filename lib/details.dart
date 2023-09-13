import 'package:flutter/material.dart';
import 'coursclass.dart';
import 'video.dart';
import 'fonctions.dart';

class EcranDetailCours extends StatelessWidget {
  final Cours cours;

  EcranDetailCours({required this.cours});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(cours.titre),
        backgroundColor: cours.couleur,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => deconnexion(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            height: 400,
            child: Hero(
              tag: 'hero-${cours.titre}',
              child: Image.network(
                cours.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 16.0,
            right: 16.0,
            top: 430.0,
            child: GestureDetector(
              onTap: () {
                navigateWithTransition(context, VideoPage());
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${cours.titre} ',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const TextSpan(
                      text: '(voir la video)',
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16.0,
            right: 16.0,
            top: 470.0,
            child: Container(
              color: Colors.blueGrey,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                cours.description,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
