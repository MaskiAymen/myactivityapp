
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myactivityapp/screens/signin_screen.dart';

import 'detail_activity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Activité')),
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

      body:

      _buildBody(),
    );
  }
  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return FutureBuilder(
        future: getActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> activities = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> activity = activities[index];
                return Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage()));
                    },child: ListTile(
                    title: Text(activity['Titre']),
                    subtitle: Text('${activity['Lieu']} - ${activity['Prix']}'),
                    leading: Image.network(activity['Image']),
                  ),
                  ),
                );
              },
            );
          }
        },
      );
    } else if (_selectedIndex == 1) {
      // Contenu d'Ajout
      return Text('Contenu d\'Ajout');
    } else {
      // Contenu de Profil
      return Text('Contenu de Profil');
    }
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<List<Map<String, dynamic>>> getActivities() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('activites').get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
