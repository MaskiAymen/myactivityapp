import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myactivityapp/screens/signin_screen.dart';

import 'detail_activity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> categories = ['Tous', 'foot', 'basketball', 'tennis'];
  String selectedCategory = 'Tous';
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Activité - $selectedCategory')),
        actions: [
          _buildFilterButton(),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Deconnexion");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              });
            },
          )
        ],
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

            if (selectedCategory != 'Tous') {
              activities = activities
                  .where((activity) =>
              activity['categories']?.toLowerCase() ==
                  selectedCategory.toLowerCase())
                  .toList();
            }

            return Column(
              children: [
                _buildFilterBar(),
                Text(
                  'Catégorie sélectionnée: $selectedCategory',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic>? activity = activities[index];

                      if (activity == null) {
                        return SizedBox.shrink();
                      }

                      String title = activity['titre'] ?? '';
                      String lieu = activity['lieu'] ?? '';
                      String prix = activity['prix'] ?? '';
                      String nbMin = activity['nbMin'] ?? '';
                      String image = activity['image_url'] ?? '';

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          margin:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    activities: activities,
                                    selectedIndex: index,
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              title: Container(
                                color: Colors.indigo,
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              subtitle: Container(
                                color: Colors.blue,
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  '$lieu - $prix - $nbMin' ,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  child: Image.network(
                                    image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      );
    } else if (_selectedIndex == 1) {
      return Text('Contenu d\'Ajout');
    } else {
      return Text('Contenu de Profil');
    }
  }

  Widget _buildFilterButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: selectedCategory,
        onChanged: (String? newValue) {
          setState(() {
            selectedCategory = newValue!;
          });
        },
        items: categories.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: categories.map((category) {
          return ElevatedButton(
            onPressed: () {
              setState(() {
                selectedCategory = category;
              });
            },
            style: ElevatedButton.styleFrom(
              primary: selectedCategory == category
                  ? Colors.blue
                  : Theme.of(context).primaryColor,
            ),
            child: Text(
              category,
              style: TextStyle(
                color: selectedCategory == category ? Colors.white : Colors.black,
              ),
            ),
          );
        }).toList(),
      ),
    );
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
