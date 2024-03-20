import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'globals.dart' as AppGlobal;
import 'profile.dart'; // Import de la page profile.dart
import 'pay.dart'; // Import de la page pay.dart

class VisitePage extends StatefulWidget {
  const VisitePage({super.key, required this.title});

  final String title;

  @override
  State<VisitePage> createState() => _VisitePageState();
}

class _VisitePageState extends State<VisitePage> {
  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      Column(
        children: [
          Visitor("thomas", "thomas", "lyon", "13", "26"),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: FloatingActionButton(
                    backgroundColor: AppGlobal.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      // Redirection vers la page du profil
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage(title: 'Profile')), // Provide the title parameter
                      );
                    },
                    child: const Text(
                      "Voir profil",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: FloatingActionButton(
                    backgroundColor: AppGlobal.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      // Redirection vers la page de paiement
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PayPage(title: 'Pay')), // Provide the title parameter
                      );
                    },
                    child: const Text(
                      "Valider et payer",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      widget,
      context,
    );
  }
}

Padding Visitor(name, surname, city, rate, cost) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppGlobal.inputColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                height: 100,
                width: 100,
                color: AppGlobal.subInputColor,
                child: const Text(
                  "Photo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      surname,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      city,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      rate + "€/h",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Image.asset(
                      'assets/images/etoile.png',
                      width: 100,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(
                    cost + "€",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                ),
              ),
            ),
          ],
        ),
        onPressed: () {},
      ),
    ),
  );
}