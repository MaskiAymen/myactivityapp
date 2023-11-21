import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors_utils.dart';
import '../widgets/reusable_widget.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

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
      body: Container(width: MediaQuery
          .of(context)
          .size
          .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4"),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                reusablaTextField("Entrer votre nom d'utilisateur",
                    Icons.person_outline, false, _userNameTextController),
                SizedBox(
                  height: 20,
                ),
                reusablaTextField("Entrer votre email",
                    Icons.person_outline, false, _emailTextController),
                SizedBox(
                  height: 20,
                ),
                reusablaTextField("Entrer votre mot de passe",
                    Icons.lock_outline, true, _passwordTextController),
                SizedBox(
                  height: 20,
                ),
                signInSignUpButton(
                  context,
                  false,
                      () {
                    FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text).then((value) {
                          print("Créer un nouveau compte");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              HomeScreen()));
                    }
                    ).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                    });
                        
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
