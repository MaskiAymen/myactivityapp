import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myactivityapp/screens/home_screen.dart';
import 'package:text_hover/text_hover.dart';

import '../widgets/reusable_widget.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activité'),
      ),
      body: _buildBody(),
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
            List<Map<String, dynamic>> activities =
                snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> activity = activities[index];
                return Stack(
                  children: [
                    SizedBox(
                        width: double.infinity,
                        child: Image.network(
                          activity['Image'],
                        )),
                  //  buttonArrow(context),
                    Container(
                      padding: const EdgeInsets.all(160.0),
                      child: ListTile(
                        title: Text(activity['Titre']),
                        subtitle:
                            Text('${activity['Lieu']} - ${activity['Prix']}'),
                      ),
                    )
                  ],
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

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
