import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;

class ManageUserPage extends StatefulWidget {
  const ManageUserPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ManageUserPage> createState() => _ManageUserPageState();
}

class _ManageUserPageState extends State<ManageUserPage> {
  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barre de recherche
              TextField(
                decoration: InputDecoration(
                  labelText: 'Recherche d\'un utilisateur',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              SizedBox(height: 16),
              // Rectangle 1
              _buildUserCard('assets/user1.jpg', 'John', 'Doe'),
              SizedBox(height: 16),
              // Rectangle 2
              _buildUserCard('assets/user2.jpg', 'Jane', 'Doe'),
              SizedBox(height: 16),
              // Rectangle 3
              _buildUserCard('assets/user3.jpg', 'Alice', 'Smith'),
            ],
          ),
        ),
      ),
      widget,
      context,
    );
  }

  Widget _buildUserCard(String image, String firstName, String lastName) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[300],
      child: Row(
        children: [
          // Photo de l'utilisateur
          CircleAvatar(
            backgroundImage: AssetImage(image), // Ajoutez le chemin de la photo
            radius: 30,
          ),
          SizedBox(width: 16),
          // Nom et prénom de l'utilisateur
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nom: $lastName'),
              Text('Prénom: $firstName'),
            ],
          ),
        ],
      ),
    );
  }
}
