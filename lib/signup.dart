import 'package:flutter/material.dart';
import 'login.dart';
import 'nextscreen.dart';
import 'fonctions.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

final _formKey = GlobalKey<FormState>();

class _SignupState extends State<Signup> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final TextEditingController _motdepasseController = TextEditingController();

  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigateWithTransition(context, NextScreen());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SignUp'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 219, 219, 193),
                          labelText: 'Entrez votre nom',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          prefixIcon: Icon(Icons.person),
                        ),
                        controller: _nomController,
                        validator: validateName,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 219, 219, 193),
                          labelText: 'Entrez votre prenom',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          prefixIcon: Icon(Icons.person_2),
                        ),
                        controller: _prenomController,
                        validator: validateName,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        // style: TextStyle(
                        //     color: const Color.fromARGB(255, 219, 219, 193)),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 219, 219, 193),
                          labelText: 'Entrez votre email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          prefixIcon: Icon(Icons.email),
                        ),
                        controller: _emailController,
                        validator: validateEmail,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        obscureText: true,
                        // style: TextStyle(
                        //     color: const Color.fromARGB(255, 219, 219, 193)),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 219, 219, 193),
                          labelText: 'Entrez votre mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        controller: _motdepasseController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 8) {
                            return 'Entrer un mot de passe valide';
                          }
                          return null;
                        },
                      ),
                    ),
                    
                    CheckboxListTile(
                      title: const Text('Accepter les conditions d\'utilisation'),
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      }),
                    ElevatedButton(
                      onPressed: () {
                        if (!_acceptTerms) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'Veuillez accepter les conditions d\'utilisation.')));
                          return;
                        }

                        if (_formKey.currentState!.validate()) {
                          saveData(
                            nom: _nomController.text,
                            prenom: _prenomController.text,
                            email: _emailController.text,
                            motdepasse: _motdepasseController.text,
                            context: context,
                          );
                          navigateWithTransition(context, const LoginPage(),
                          );
                          
                        }
                      },
                      child: const Text(
                        'Soumettre',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 87, 101, 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      ),
    );
  }
}
