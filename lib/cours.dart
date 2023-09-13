import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'nextscreen.dart';
import 'coursclass.dart';
import 'details.dart';
import 'fonctions.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Espace Etudiants',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ListCours(),
    );
  }
}




class ListCours extends StatefulWidget {
  @override
  _ListCoursState createState() => _ListCoursState();
}

class _ListCoursState extends State<ListCours> {
  late Stream<QuerySnapshot> coursStream;

  @override
  void initState() {
    super.initState();
    coursStream = FirebaseFirestore.instance.collection('cours').snapshots();
  }



   @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigateWithTransition(context, NextScreen());
        return false;
      },
    child: StreamBuilder<QuerySnapshot>(
      stream: coursStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Une erreur est survenue');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        List<Cours> listeDesCours = snapshot.data!.docs.map((DocumentSnapshot document) {
          return Cours.fromFirestore(document);
        }).toList();

        
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
            body: Center(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: listeDesCours.length,
                itemBuilder: (BuildContext context, int index) {
                  final cours = listeDesCours[index];
                  return ListTile(
                    onTap: () {
                      navigateWithTransition(context, EcranDetailCours(cours: cours,));
                    },
                    title: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: cours.couleur,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'hero-${cours.titre}',
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(cours.imagePath),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Text(
                            cours.titre,
                            style:const  TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        
      }
    ),
    );
  }
}

