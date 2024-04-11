import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;
import 'home.dart' as HomePage; // Importer la page d'accueil
import 'dart:convert';
import 'package:http/http.dart' as http;

class PayPage extends StatefulWidget {
  const PayPage({Key? key, required this.title, required this.idDemande}) : super(key: key);

  final String title;
  final int idDemande;

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  int _selectedMonth = 1;
  int _selectedYear = DateTime.now().year;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10), // Limite à 10 ans à partir de la date actuelle
    );
    if (pickedDate != null) {
      setState(() {
        _selectedMonth = pickedDate.month;
        _selectedYear = pickedDate.year;
      });
    }
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
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Numéro de carte",
                    filled: true,
                    fillColor: AppGlobal.buttonback,
                  ),
                  maxLength: 16, // Limite de 16 caractères pour le numéro de carte
                  onSaved: (String? value) {
                    debugPrint('Card number saved as $value');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Date d'expiration",
                            filled: true,
                            fillColor: AppGlobal.buttonback,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${_selectedMonth.toString().padLeft(2, '0')} / $_selectedYear",
                                style: TextStyle(fontSize: 16),
                              ),
                              Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Code de sécurité",
                            filled: true,
                            fillColor: AppGlobal.buttonback,
                          ),
                          maxLength: 3, // Limite de 3 caractères pour le code de sécurité
                          onSaved: (String? value) {
                            debugPrint('Security code saved as $value');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    // Appeler la fonction de paiement avec l'ID de la demande
                    _verifyAndPay(widget.idDemande);
                  },
                  child: const Text(
                    'Payer',
                    style: TextStyle(color: Colors.black),
                  ),
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

  Future<void> _verifyAndPay(int idDemande) async {
    // Vérifier le paiement en envoyant une requête à l'API
    var url = '${AppGlobal.UrlServer}Visit/PaidVisit?id=$idDemande';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Paiement réussi
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage.HomePage(title: 'Home')),
      );
    } else {
      // Gérer les erreurs de paiement
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors du paiement'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}