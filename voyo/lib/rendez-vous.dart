import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;

class RdvPage extends StatefulWidget {
  const RdvPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RdvPage> createState() => _RdvPageState();
}

class _RdvPageState extends State<RdvPage> {
  final TextEditingController typeLogementController = TextEditingController();
  final TextEditingController villeController = TextEditingController();
  final TextEditingController rueController = TextEditingController();
  final TextEditingController codePostalController = TextEditingController();
  final TextEditingController nomUtilisateurController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  final List<String> points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: typeLogementController,
                          decoration: InputDecoration(labelText: "Type de logement"),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: villeController,
                          decoration: InputDecoration(labelText: "Ville"),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: rueController,
                          decoration: InputDecoration(labelText: "Rue"),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: codePostalController,
                          decoration: InputDecoration(labelText: "Code Postal"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Utilisateur'),
                        SizedBox(height: 10),
                        Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey, // Placeholder for user image
                          alignment: Alignment.center,
                          child: Text(
                            'Photo', // Placeholder for user image
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Action when view profile button is pressed
                          },
                          child: Text('Voir Profil'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Points',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Column(
                children: [
                  for (var i = 0; i < points.length; i++)
                    ListTile(
                      title: Text(points[i]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            points.removeAt(i);
                          });
                        },
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        points.add('Nouveau point');
                      });
                    },
                    child: Text('Ajouter Point'),
                    style: ElevatedButton.styleFrom(
                      primary: AppGlobal.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Action when cancel button is pressed
                    },
                    child: Text('Annuler RDV'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Action when start visit button is pressed
                    },
                    child: Text('Démarrer la visite'),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Image.asset(
                'assets/images/voyo_logo.png', // Path to Voyo logo image
                width: 200,
              ),
              SizedBox(height: 20.0),
              Container(
                color: AppGlobal.primaryColor,
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '© 2024 Voyo. Tous droits réservés.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
