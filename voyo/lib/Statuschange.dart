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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.yellow, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Informations',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: telephoneController,
                        decoration: InputDecoration(
                          labelText: "Numéro de téléphone",
                          filled: true,
                          fillColor: Colors.blue[50], // Couleur de fond du champ de texte
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: ribController,
                        decoration: InputDecoration(
                          labelText: "RIB/iBAN",
                          filled: true,
                          fillColor: Colors.blue[50], // Couleur de fond du champ de texte
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: tarifController,
                        decoration: InputDecoration(
                          labelText: "Tarif horaire",
                          filled: true,
                          fillColor: Colors.blue[50], // Couleur de fond du champ de texte
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.yellow, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Horaires',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.0),
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
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: debutController,
                        decoration: InputDecoration(
                          labelText: "Horaire de début",
                          filled: true,
                          fillColor: Colors.blue[50], // Couleur de fond du champ de texte
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: finController,
                        decoration: InputDecoration(
                          labelText: "Horaire de fin",
                          filled: true,
                          fillColor: Colors.blue[50], // Couleur de fond du champ de texte
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _ajouterHoraire,
                        child: Text('Ajouter horaire'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.yellow, // Couleur de fond du bouton
                        ),
                      ),
                      SizedBox(height: 20.0),
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
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _confirmer,
                child: Text('Confirmer'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow, // Couleur de fond du bouton
                ),
              ),
              SizedBox(height: 20.0),
              LinearProgressIndicator(
                value: _progressValue,
                backgroundColor: Colors.blue[50], // Couleur de fond de la barre de progression
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow), // Couleur de remplissage de la barre de progression
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
