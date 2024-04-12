import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;

class RdvPage extends StatefulWidget {
  const RdvPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RdvPage> createState() => _RdvPageState();
}

class _RdvPageState extends State<RdvPage> {
  DateTime? _selectedDate;
  List<String> _points = [];
  TextEditingController _newPointController = TextEditingController();

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

  void _addPoint(String point) {
    setState(() {
      _points.add(point);
      _newPointController.clear(); // Clear the text field after adding the point
    });
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
              Container(
                alignment: Alignment.center,
                child: Text('Logo'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Type de logement:'),
                          SizedBox(height: 4),
                          Text('Ville:'),
                          SizedBox(height: 4),
                          Text('Rue:'),
                          SizedBox(height: 4),
                          Text('Code Postal:'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        color: Colors.grey[200],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nom d\'utilisateur:', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: Center(
                                child: Text('Photo'),
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('Voir Profil'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Liste de Points
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Liste de Points:', style: TextStyle(fontWeight: FontWeight.bold)),
                    for (String point in _points)
                      ListTile(
                        title: Text(point),
                      ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _newPointController,
                            decoration: InputDecoration(
                              labelText: 'Nouveau point',
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            String newPoint = _newPointController.text.trim();
                            if (newPoint.isNotEmpty) {
                              _addPoint(newPoint);
                            }
                          },
                          child: Text('Ajouter'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        onPrimary: Colors.white,
                      ),
                      child: Text('Annuler RDV'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                      ),
                      child: Text('Débuter la visite'),
                    ),
                  ],
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
