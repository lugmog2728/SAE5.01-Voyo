import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importation de cette ligne pour FilteringTextInputFormatter
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
  final TextEditingController debutHourController = TextEditingController();
  final TextEditingController debutMinuteController = TextEditingController();
  final TextEditingController finHourController = TextEditingController();
  final TextEditingController finMinuteController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController ribController = TextEditingController();
  final TextEditingController tarifController = TextEditingController();
  double _progressValue = 0.0;

  // Fonction pour vérifier si une heure ou minute est valide (0 à 24 pour heures et 0 à 60 pour minutes)
  bool _isHoraireValide(String value) {
    try {
      int intValue = int.parse(value);
      if (intValue < 0 || intValue > 24) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void _ajouterHoraire() {
    bool debutHourValide = _isHoraireValide(debutHourController.text);
    bool debutMinuteValide = _isHoraireValide(debutMinuteController.text);
    bool finHourValide = _isHoraireValide(finHourController.text);
    bool finMinuteValide = _isHoraireValide(finMinuteController.text);

    if (selectedJour != null &&
        debutHourValide &&
        debutMinuteValide &&
        finHourValide &&
        finMinuteValide) {
      setState(() {
        horaires.add({
          'jour': selectedJour!,
          'debut': '${debutHourController.text}:${debutMinuteController.text}',
          'fin': '${finHourController.text}:${finMinuteController.text}',
        });
        debutHourController.clear();
        debutMinuteController.clear();
        finHourController.clear();
        finMinuteController.clear();
      });
    } else {
      String errorMessage = 'Veuillez entrer un horaire valide';
      if (!debutHourValide || !debutMinuteValide) {
        debutHourController.clear();
        debutMinuteController.clear();
        debutHourController.text = errorMessage;
      }
      if (!finHourValide || !finMinuteValide) {
        finHourController.clear();
        finMinuteController.clear();
        finHourController.text = errorMessage;
      }
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: debutHourController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            decoration: InputDecoration(
                              labelText: "Heure de début",
                              errorText: debutHourController.text == 'Veuillez entrer un horaire valide' ? 'Veuillez entrer un horaire valide' : null,
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: TextFormField(
                            controller: debutMinuteController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            decoration: InputDecoration(
                              labelText: "Minute de début",
                              errorText: debutMinuteController.text == 'Veuillez entrer un horaire valide' ? 'Veuillez entrer un horaire valide' : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: finHourController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            decoration: InputDecoration(
                              labelText: "Heure de fin",
                              errorText: finHourController.text == 'Veuillez entrer un horaire valide' ? 'Veuillez entrer un horaire valide' : null,
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: TextFormField(
                            controller: finMinuteController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            decoration: InputDecoration(
                              labelText: "Minute de fin",
                              errorText: finMinuteController.text == 'Veuillez entrer un horaire valide' ? 'Veuillez entrer un horaire valide' : null,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                          ListTile(
                            title: Text(
                              '${horaire['jour']} - Début: ${horaire['debut']}, Fin: ${horaire['fin']}',
                              textAlign: TextAlign.center,
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