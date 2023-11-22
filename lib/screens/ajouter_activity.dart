import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myactivityapp/screens/home_screen.dart';

import 'package:myactivityapp/screens/signin_screen.dart';
import 'package:tflite/tflite.dart';

class AjoutActivity extends StatefulWidget {
  const AjoutActivity({super.key});

  @override
  State<AjoutActivity> createState() => _AjoutActivityState();
}

class _AjoutActivityState extends State<AjoutActivity> {
  File? _image;
  List? _output;

  Future<void> _prendrePhoto() async {
    //Pick an image from camera or gallery
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      setState(() {
        _image = File(image.path);
        detecterImage(_image!);
      });
    }
    ;
    detecterImage(_image!);
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: 'assets/model.tflite', labels: 'assets/labels.txt');
  }

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  detecterImage(File image) async {
    print("okkkkkkkkkkkkkk" + image.path);
    var prediction = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = prediction!;
      print(_output);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Ajouter une activité')),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_return,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Deconnexion");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              });
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    _image == null
                        ? Text('Upload votre image')
                        : Image.file(
                            _image!,
                            width: 100,
                            height: 100,
                          ),
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1))
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 4, color: Colors.blue),
                            color: Colors.blue),
                        child: GestureDetector(
                          onTap: () {
                            _prendrePhoto();
                          },
                          child: Icon(
                            Icons.upload,
                            size: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //les ligne des formulaire
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.center,
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        maxLength: 25,
                        decoration: InputDecoration(
                            hintText: "titre",
                            hintStyle: TextStyle(color: Colors.red),
                            labelText: "titre de votre activité",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.red)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(color: Colors.green)),
                            prefixIcon: Icon(Icons.title)),
                      ),
                      TextFormField(
                        maxLength: 25,
                        decoration: InputDecoration(
                            hintText: "prix",
                            hintStyle: TextStyle(color: Colors.red),
                            labelText: "entrer le prix",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.red)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(color: Colors.green)),
                            prefixIcon: Icon(Icons.price_change)),
                      ),
                      TextFormField(
                        maxLength: 25,
                        decoration: InputDecoration(
                            hintText: "lieu",
                            hintStyle: TextStyle(color: Colors.red),
                            labelText: "Definir le lieu de votre activité",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.red)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(color: Colors.green)),
                            prefixIcon: Icon(Icons.map_sharp)),
                      ),
                      Container(
                        child: Column(
                          children: [
                            _output != null
                                ? Text(
                                    (_output![0]['label'])
                                        .toString()
                                        .substring(2),
                                    style: TextStyle(fontSize: 28),
                                  )
                                : Text(''),
                            _output != null
                                ? Text(
                                    'Degé de confiance: ' +
                                        (_output![0]['confidence']).toString(),
                                    style: TextStyle(fontSize: 28))
                                : Text('')
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              HomeScreen();
                            },
                            child: Text(
                              "Annuler",
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2,
                                  color: Colors.black),
                            ),
                            style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              HomeScreen();
                            },
                            child: Text(
                              "Ajouter",
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2,
                                  color: Colors.blue),
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
