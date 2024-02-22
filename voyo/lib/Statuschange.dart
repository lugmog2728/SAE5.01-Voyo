import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;

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
    return AppGlobal.Menu(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: telephoneController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Numéro de téléphone",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: ribController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "RIB/iBAN",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: tarifController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Tarif horaire",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Sélectionner un jour',
                  ),
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: debutController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Horaire de début",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: finController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Horaire de fin",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _ajouterHoraire,
                  child: Text('Ajouter horaire'),
                ),
              ),
              for (final horaire in horaires)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        '${horaire['jour']} - Début: ${horaire['debut']}, Fin: ${horaire['fin']}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _confirmer,
                  child: Text('Confirmer'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LinearProgressIndicator(
                  value: _progressValue,
                ),
              ),
            ],
          ),
        ),
      ),
      widget,
      context,
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