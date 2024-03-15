import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;

class UserCheckPage extends StatefulWidget {
  const UserCheckPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<UserCheckPage> createState() => _UserCheckPageState();
}

class _UserCheckPageState extends State<UserCheckPage> {
  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Rectangle 1
              _buildVisitorCard('Visitor 1', 'John', 'Doe'),
              SizedBox(height: 16),
              // Rectangle 2
              _buildVisitorCard('Visitor 2', 'Jane', 'Doe'),
              SizedBox(height: 16),
              // Rectangle 3
              _buildVisitorCard('Visitor 3', 'Alice', 'Smith'),
              SizedBox(height: 16),
              // Rectangle 4
              _buildVisitorCard('Visitor 4', 'Bob', 'Johnson'),
              SizedBox(height: 16),
              // Check box pour la validation automatique
              CheckboxListTile(
                title: Text('Validation automatique'),
                value: false, // Remplacez false par l'état de la checkbox
                onChanged: (newValue) {
                  // Action lorsque la valeur de la checkbox change
                  setState(() {
                    // Mettre à jour l'état de la checkbox ici
                  });
                },
              ),
            ],
          ),
        ),
      ),
      widget,
      context,
    );
  }

  Widget _buildVisitorCard(String image, String firstName, String lastName) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.grey[300],
      child: Row(
        children: [
          // Photo du visiteur
          CircleAvatar(
            backgroundImage: AssetImage(image), // Ajoutez le chemin de la photo
            radius: 30,
          ),
          SizedBox(width: 16),
          // Nom et prénom du visiteur
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nom: $lastName'),
              Text('Prénom: $firstName'),
            ],
          ),
          Spacer(),
          // Bouton pour annuler
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              // Action lorsque le bouton pour annuler est pressé
            },
          ),
          // Bouton pour valider
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Action lorsque le bouton pour valider est pressé
            },
          ),
        ],
      ),
    );
  }
}
