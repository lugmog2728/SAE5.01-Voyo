import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;

class AdminUserProfilePage extends StatefulWidget {
  const AdminUserProfilePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AdminUserProfilePage> createState() => _AdminUserProfilePageState();
}

class _AdminUserProfilePageState extends State<AdminUserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Texte Statut: Utilisateur
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Statut: Utilisateur',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // Bloc d'informations sur l'utilisateur
              Container(
                padding: EdgeInsets.all(8.0),
                color: Colors.grey[300],
                child: Row(
                  children: [
                    // Photo de l'utilisateur (remplacez le chemin par votre photo)
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/user_photo.jpg'),
                      radius: 60,
                    ),
                    SizedBox(width: 16),
                    // Nom, prénom et ville de l'utilisateur
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nom: John Doe'),
                          Text('Prénom: Jane'),
                          Text('Ville: New York'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Encoche "Désactiver profil"
              ListTile(
                title: Text('Désactiver profil'),
                trailing: Switch(
                  value: true, // Mettez la valeur actuelle de désactivation ici
                  onChanged: (value) {
                    // Action lorsque l'interrupteur est changé
                  },
                ),
              ),
              SizedBox(height: 16),
              // Bouton "Bannir"
              ElevatedButton(
                onPressed: () {
                  // Action lorsque le bouton est pressé
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                ),
                child: Text('Bannir'),
              ),
            ],
          ),
        ),
      ),
      widget,
      context,
    );
  }
}
