import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;

class NewAccountPage extends StatefulWidget {
  const NewAccountPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<NewAccountPage> createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
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
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Nom",
                          filled: true,
                          fillColor: AppGlobal.buttonback,
                        ),
                        onSaved: (String? value) {
                          debugPrint('Value for Nom saved as $value');
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
                          hintText: "Prénom",
                          filled: true,
                          fillColor: AppGlobal.buttonback,
                        ),
                        onSaved: (String? value) {
                          debugPrint('Value for Prénom saved as $value');
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Date de naissance",
                        filled: true,
                        fillColor: AppGlobal.buttonback,
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onSaved: (String? value) {
                        debugPrint('Value for Date de naissance saved as $value');
                      },
                      controller: TextEditingController(
                          text: _selectedDate != null ? _selectedDate!.toString().substring(0, 10) : ''),
                    ),
                  ),
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
                          hintText: "Ville",
                          filled: true,
                          fillColor: AppGlobal.buttonback,
                        ),
                        onSaved: (String? value) {
                          debugPrint('Value for Ville saved as $value');
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
                          hintText: "Code postal",
                          filled: true,
                          fillColor: AppGlobal.buttonback,
                        ),
                        onSaved: (String? value) {
                          debugPrint('Value for Code postal saved as $value');
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Adresse postal",
                    filled: true,
                    fillColor: AppGlobal.buttonback,
                  ),
                  onSaved: (String? value) {
                    debugPrint('Value for Adresse postal saved as $value');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Adresse mail",
                    filled: true,
                    fillColor: AppGlobal.buttonback,
                  ),
                  onSaved: (String? value) {
                    debugPrint('Value for Adresse mail saved as $value');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Mot de passe",
                    filled: true,
                    fillColor: AppGlobal.buttonback,
                  ),
                  onSaved: (String? value) {
                    debugPrint('Value for Mot de passe saved as $value');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Photo",
                          filled: true,
                          fillColor: AppGlobal.buttonback,
                        ),
                        onSaved: (String? value) {
                          debugPrint('Value for Photo saved as $value');
                        },
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.yellow,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Parcourir',
                        style: TextStyle(color: Colors.black),
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
                  onPressed: () {},
                  child: const Text(
                    'Valider',
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
