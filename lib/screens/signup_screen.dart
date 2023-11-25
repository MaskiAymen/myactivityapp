import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Home.dart';
import '../utils/colors_utils.dart';
import '../widgets/reusable_widget.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "S'enregistrer",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  hexStringToColor("CB2B93"),
                  hexStringToColor("9546C4"),
                  hexStringToColor("5E61F4"),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                reusablaTextField(
                  "Entrer votre nom d'utilisateur",
                  Icons.person_outline,
                  false,
                  _userNameTextController,
                ),
                SizedBox(
                  height: 20,
                ),
                reusablaTextField(
                  "Entrer votre email",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                ),
                SizedBox(
                  height: 20,
                ),
                reusablaTextField(
                  "Entrer votre mot de passe (au moins 8 caractères)",
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                ),
                SizedBox(
                  height: 20,
                ),
                signInSignUpButton(
                  context,
                  false,
                      () {
                    // Vérifier que le mot de passe a au moins 8 caractères
                    if (_passwordTextController.text.length >= 8) {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      )
                          .then((value) {
                        // Message et log en cas de création de compte réussie
                        print("Création d'un nouveau compte réussie !");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Création du compte réussie !'),
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(),
                          ),
                        );
                      }).onError((error, stackTrace) {
                        // Message et log en cas d'erreur de création de compte
                        print("Erreur lors de la création du compte : ${error.toString()}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text('Erreur lors de la création du compte : ${error.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                    } else {
                      // Message et log en cas de mot de passe trop court
                      print("Le mot de passe doit contenir au moins 8 caractères !");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Le mot de passe doit contenir au moins 8 caractères.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
