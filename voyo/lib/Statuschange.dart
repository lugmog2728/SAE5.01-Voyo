import 'package:flutter/material.dart';

class ChangementStatutPage extends StatefulWidget {
  const ChangementStatutPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ChangementStatutPage> createState() => _ChangementStatutPageState();
}

class _ChangementStatutPageState extends State<ChangementStatutPage> {
  final List<String> jours = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
  String? selectedJour;
  final List<Map<String, String>> horaires = [];
  final TextEditingController debutController = TextEditingController();
  final TextEditingController finController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController ribController = TextEditingController();
  final TextEditingController tarifController = TextEditingController();
  double _progressValue = 0.0;

  void _ajouterHoraire() {
    if (selectedJour != null && debutController.text.isNotEmpty && finController.text.isNotEmpty) {
      setState(() {
        horaires.add({
          'jour': selectedJour!,
          'debut': debutController.text,
          'fin': finController.text,
        });
        debutController.clear();
        finController.clear();
      });
    }
  }

  void _confirmer() {
    setState(() {
      _progressValue = 0.0; // Réinitialiser la barre de progression
    });
    // Action de confirmation à implémenter ici
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Informations
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Informations',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: telephoneController,
                        decoration: InputDecoration(
                          labelText: "Numéro de téléphone",
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: ribController,
                        decoration: InputDecoration(
                          labelText: "RIB/iBAN",
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: tarifController,
                        decoration: InputDecoration(
                          labelText: "Tarif horaire",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Horaires
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Horaires',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedJour,
                        onChanged: (newValue) {
                          setState(() {
                            selectedJour = newValue;
                          });
                        },
                        items: jours.map((jour) {
                          return DropdownMenuItem(
                            value: jour,
                            child: Text(jour),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: debutController,
                        decoration: InputDecoration(
                          labelText: "Horaire de début",
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: finController,
                        decoration: InputDecoration(
                          labelText: "Horaire de fin",
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _ajouterHoraire,
                        child: Text('Ajouter horaire'),
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final horaire in horaires)
                            Card(
                              child: ListTile(
                                title: Text(
                                  '${horaire['jour']} - Début: ${horaire['debut']}, Fin: ${horaire['fin']}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _confirmer,
                child: Text('Confirmer'),
              ),
              SizedBox(height: 20),
              LinearProgressIndicator(
                value: _progressValue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    debutController.dispose();
    finController.dispose();
    telephoneController.dispose();
    ribController.dispose();
    tarifController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: ChangementStatutPage(title: 'Changement de statut'),
  ));
}
