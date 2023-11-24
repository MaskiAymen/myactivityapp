import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tflite/tflite.dart';

import 'home_screen.dart';

class AjoutActivity extends StatefulWidget {
  const AjoutActivity({Key? key}) : super(key: key);

  @override
  State<AjoutActivity> createState() => _AjoutActivityState();
}

class _AjoutActivityState extends State<AjoutActivity> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _lieuController = TextEditingController();
  final TextEditingController _nbMinController = TextEditingController();

  File? _image;
  List? _output;

  Future<void> _prendrePhoto() async {
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
    print("valide" + image.path);
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

  void _storeDataInFirestore() async {
    try {
      if (_image == null) {
        print('Image not selected.');
        return;
      }

      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('activity_image_${DateTime.now().millisecondsSinceEpoch}.png');

      UploadTask uploadTask = storageReference.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('activites').add({
        'titre': _nameController.text,
        'prix': _prixController.text,
        'nbMin': _nbMinController.text,
        'lieu': _lieuController.text,
        'image_url': downloadURL,
        'categories':
        _output != null ? _output![0]['label'].toString().substring(2) : '',
      });

      // Afficher le message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Activité ajoutée avec succès!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Retour à l'écran précédent
      Navigator.pop(context);
    } catch (e) {
      print('Error: $e');
      // Handle the error gracefully
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une activité'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.keyboard_return, color: Colors.brown),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Deconnexion");
                Navigator.pop(context);
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 4, color: Colors.blue),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: _image == null
                          ? Center(
                        child: Text(
                          'Ajouter une image',
                          textAlign: TextAlign.center,
                        ),
                      )
                          : ClipOval(
                        child: Image.file(
                          _image!,
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          _prendrePhoto();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 4, color: Colors.blue),
                            color: Colors.blue,
                          ),
                          child: Icon(
                            Icons.upload,
                            size: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _buildTextField(
                  _nameController,
                  'Titre de votre activité',
                  Icons.title,
                  'Veuillez entrer le titre de votre activité',
                ),
                SizedBox(height: 10),
                _buildTextField(
                  _prixController,
                  'Prix',
                  Icons.price_change,
                  'Veuillez entrer le prix',
                ),
                SizedBox(height: 10),
                _buildTextField(
                  _nbMinController,
                  'Nombre de personnes minimum',
                  Icons.group,
                  'Veuillez entrer le nombre minimum de personnes',
                ),
                SizedBox(height: 10),
                _buildTextField(
                  _lieuController,
                  'Lieu',
                  Icons.map_sharp,
                  'Veuillez entrer le lieu de votre activité',
                ),
                SizedBox(height: 10),
                _output != null
                    ? Text(
                  'Catégorie: ${_output![0]['label'].toString().substring(2)}',
                  style: TextStyle(fontSize: 18),
                )
                    : Container(),
                SizedBox(height: 10),
                _output != null
                    ? Text(
                  'Degré de confiance: ${(_output![0]['confidence'] * 100).toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 18),
                )
                    : Container(),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Annuler',
                        style: TextStyle(fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        primary: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _storeDataInFirestore();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Activité ajoutée avec succès"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(),
                                      ),
                                    );
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'Ajouter',
                        style: TextStyle(fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String labelText,
      IconData icon,
      String hintText,
      ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
