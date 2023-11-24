import 'package:flutter/material.dart';

class PanierPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  PanierPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
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
}
