import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;
import 'newaccount.dart' as newAccountPage;

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
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
                  onSaved: (String? value) {
                    debugPrint('Card number saved as $value');
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Date d'expiration",
                          filled: true,
                          fillColor: AppGlobal.buttonback,
                        ),
                        onSaved: (String? value) {
                          debugPrint('Expiration date saved as $value');
                        },
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
                        onSaved: (String? value) {
                          debugPrint('Security code saved as $value');
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    // Ajouter la logique de paiement ici
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
}
