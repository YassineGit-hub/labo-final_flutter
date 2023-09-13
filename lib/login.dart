import 'package:flutter/material.dart';
import 'package:labo_final/cours.dart';
import 'nextscreen.dart';
import 'fonctions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final TextEditingController _motdepasseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigateWithTransition(context, NextScreen());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor:  Color.fromARGB(255, 219, 219, 193),
                        labelText: 'Entrez votre email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                          borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        prefixIcon: Icon(Icons.email),
                      ),
                      controller: _emailController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration:const  InputDecoration(
                        filled: true,
                        fillColor:  Color.fromARGB(255, 219, 219, 193),
                        labelText: 'Entrez votre mot de passe',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                          borderSide: BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      controller: _motdepasseController,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _motdepasseController.text,
                        context: context,
                      );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 87, 101, 0)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      navigateWithTransition(context, ListCours());
                    },
                    child: const Text(
                      'SignUp',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}
