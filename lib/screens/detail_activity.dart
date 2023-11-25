import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:myactivityapp/screens/panier.dart';
import 'package:badges/badges.dart' as badges;

class DetailPage extends StatefulWidget {
  final List<Map<String, dynamic>> activities;
  final int selectedIndex;

  const DetailPage({
    Key? key,
    required this.activities,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late List<Map<String, dynamic>> activities;
  late Map<String, dynamic> currentActivity;
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    activities = widget.activities;
    currentActivity = activities[widget.selectedIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails d\'activité'),
        actions: [
          badges.Badge(
            badgeContent: Text(
              '${cartItems.length}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            showBadge: true,
            shape: BadgeShape.circle,
            badgeColor: Colors.red,
            position: BadgePosition.topEnd(top: 0, end: 3),
            animationType: BadgeAnimationType.slide,
            child: IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PanierPage(cartItems: cartItems),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 300,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      currentActivity['image_url'] ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(

                  'titre:${currentActivity['titre'] ?? ''}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'lieu:${currentActivity['lieu'] ?? ''} ',

                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Prix:${currentActivity['prix'] ?? ''}',

                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'NbMin: ${currentActivity['nbMin'] ?? ''}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Catégorie: ${currentActivity['categories'] ?? ''}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    addToCart(currentActivity);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Ajouté au panier avec succès"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Ajouter au panier'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      cartItems.add(item);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ajouté au panier'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }
}
