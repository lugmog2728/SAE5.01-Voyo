import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Ajout de cette ligne pour importer FilteringTextInputFormatter
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

  TextFormField buildHourInput(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9:]'))],
      decoration: InputDecoration(
        labelText: "Horaire",
        suffixText: 'heure',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez saisir une heure valide';
        }
        // Vérifier le format de l'heure ici
        final validFormat = RegExp(r'^[0-2]?[0-9]:[0-5][0-9]$').hasMatch(value);
        if (!validFormat) {
          return 'Format d\'heure invalide. Utilisez HH:MM';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Informations',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: telephoneController,
                      decoration: InputDecoration(
                        labelText: "Numéro de téléphone",
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: ribController,
                      decoration: InputDecoration(
                        labelText: "RIB/iBAN",
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: tarifController,
                      decoration: InputDecoration(
                        labelText: "Tarif horaire",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
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
                    buildHourInput(debutController),
                    SizedBox(height: 20.0),
                    buildHourInput(finController),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _ajouterHoraire,
                      child: Text('Ajouter horaire'),
                      style: ElevatedButton.styleFrom(
                        primary: AppGlobal.primaryColor,
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
                                '${horaire['jour']} - Début: ${horaire['debut']} heure, Fin: ${horaire['fin']} heure',
                                textAlign: TextAlign.center,
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    horaires.remove(horaire);
                                  });
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _confirmer,
                child: Text('Confirmer'),
                style: ElevatedButton.styleFrom(
                  primary: AppGlobal.primaryColor,
                ),
              ),
              SizedBox(height: 20.0),
              LinearProgressIndicator(
                value: _progressValue,
                backgroundColor: AppGlobal.backgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(AppGlobal.secondaryColor),
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