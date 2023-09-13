import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'fonctions.dart'; // Import this to get the `parseColor` function

class Cours {
  final String id;
  final String titre;
  final String description;
  final String imagePath;
  final Color couleur;

  Cours({
    required this.id,
    required this.titre,
    required this.description,
    required this.imagePath,
    required this.couleur,
  });

  factory Cours.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Cours(
      id: doc.id,
      titre: data['titre'] ?? 'Default Title',
      description: data['description'] ?? 'Default Description',
      imagePath: data['imagePath'] ?? 'Default Image Path',
      couleur: parseColor(data['couleur'] ?? 'Default Color'),
    );
  }
}
