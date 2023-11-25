import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PanierPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  PanierPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _addToFirestore(context); // Passer le contexte à la fonction
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> item = cartItems[index];

        // Déterminez une couleur de fond en fonction de l'indice de la liste
        Color backgroundColor = index.isEven ? Colors.grey[200]! : Colors.white;

        return Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          color: backgroundColor,
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            title: Text(
              item['titre'] ?? '',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${item['lieu'] ?? ''} - ${item['prix'] ?? ''}'),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                item['image_url'] ?? '',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _addToFirestore(BuildContext context) async {
    CollectionReference panierCollection =
    FirebaseFirestore.instance.collection('panier');

    for (Map<String, dynamic> item in cartItems) {
      await panierCollection.add(item);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Les items ont été ajoutés au panier dans Firestore.'),
      ),
    );
  }
}
