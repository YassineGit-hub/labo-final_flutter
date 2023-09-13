import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'fonctions.dart';
import 'nextscreen.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    home: Profile(),
    theme: ThemeData(fontFamily: 'Poppins'),
  ));
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? adresseCourriel;
  String numeroDossier = "vide";
  String nomInstitution = "vide";
  String imagePath = 'images/default_image.png';
  File? _imageFile;
  String? nom;
  String? prenom;

  Future<void> _editField(String fieldName, String? currentValue) async {
    String? newValue = await showEditDialog(context, currentValue);

    if (newValue != null) {
      setState(() {
        switch (fieldName) {
          case 'Adresse Courriel':
            adresseCourriel = newValue;
            break;
          case 'Numero de Dossier':
            numeroDossier = newValue;
            break;
          case 'Nom de l’institution':
            nomInstitution = newValue;
            break;
          case 'Prenom':
            prenom = newValue;
            break;
          case 'Nom':
            nom = newValue;
            break;
          default:
            break;
        }
      });

      _saveProfileToFirebase();
    }
  }

  Future<void> _changeProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Téléchargement de l'image vers Firebase Storage
      String imageUrl = await _uploadImageToFirebase(_imageFile!);

      // Sauvegarde de l'URL de l'image dans Firestore
      await _saveImageUrlToFirestore(imageUrl);
    }
  }

  Future<String> _uploadImageToFirebase(File imageFile) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final ref = FirebaseStorage.instance.ref().child('profile_images').child(user.uid + '.jpg');
    await ref.putFile(imageFile);

    return await ref.getDownloadURL();
  }

  Future<void> _saveImageUrlToFirestore(String imageUrl) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('users').doc(user.uid).update({'profileImageUrl': imageUrl});
  }

  @override
  void initState() {
    super.initState();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    if (user != null) {
      adresseCourriel = user.email;

      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      _firestore
          .collection('users')
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            nom = documentSnapshot.get('prenom');
            prenom = documentSnapshot.get('nom');
            adresseCourriel = documentSnapshot.get('adresseCourriel');
            numeroDossier = documentSnapshot.get('numeroDossier');
            nomInstitution = documentSnapshot.get('nomInstitution');
            imagePath = documentSnapshot.get('profileImageUrl') ?? 'images/default_image.png';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigateWithTransition(context, NextScreen());
        return false;
      },
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple[800]!, Colors.deepPurpleAccent],
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    _changeProfileImage();
                  },
                  child: CircleAvatar(
                    radius: 65.0,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (imagePath.startsWith('http')
                            ? NetworkImage(imagePath)
                            : AssetImage(imagePath)) as ImageProvider<Object>,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () => _editField('Prenom', prenom),
                  child: Text(prenom ?? '', style: const TextStyle(color: Colors.white, fontSize: 20.0)),
                ),
                GestureDetector(
                  onTap: () => _editField('Nom', nom),
                  child: Text(nom ?? '', style: const TextStyle(color: Colors.white, fontSize: 20.0)),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                child: Container(
                  width: 310.0,
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Information",
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Divider(color: Colors.grey[300]),
                      buildFieldRow(Icons.email, 'Adresse Courriel', adresseCourriel),
                      buildFieldRow(Icons.folder, 'Numero de Dossier', numeroDossier),
                      buildFieldRow(Icons.school, 'Nom de l’institution', nomInstitution),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget buildFieldRow(IconData icon, String fieldName, String? fieldValue) {
    return ListTile(
      leading: Icon(
        icon,
        size: 35,
        color:const  Color.fromARGB(255, 64, 113, 177),
      ),
      title: Text(fieldName),
      subtitle: Text(fieldValue ?? 'Non défini'),
      trailing: IconButton(
        icon: Icon(
          Icons.edit,
          color: Colors.blueAccent[400],
          size: 30,
        ),
        onPressed: () {
          _editField(fieldName, fieldValue);
        },
      ),
    );
  }

  Future<String?> showEditDialog(BuildContext context, String? currentValue) async {
    String? newText = currentValue;

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier le champ'),
          content: TextField(
            controller: TextEditingController(text: newText),
            onChanged: (value) {
              newText = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: const Text('Confirmer'),
              onPressed: () {
                Navigator.of(context).pop(newText);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveProfileToFirebase() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(user.uid).set({
        'prenom': nom,
        'nom': prenom,
        'adresseCourriel': adresseCourriel,
        'numeroDossier': numeroDossier,
        'nomInstitution': nomInstitution,
      });
    }
  }
}
