import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart' as AppGlobal;
import 'profile.dart';
import 'pay.dart';

class VisitePage extends StatefulWidget {
  const VisitePage({
    Key? key,
    required this.title,
    required this.name,
    required this.surname,
    required this.city,
    required this.rate,
    required this.cost,
  }) : super(key: key);

  final String title;
  final String name;
  final String surname;
  final String city;
  final String rate;
  final String cost;

  @override
  State<VisitePage> createState() => _VisitePageState();
}

class _VisitePageState extends State<VisitePage> {
  late int userId = -1;

  @override
  void initState() {
    super.initState();
    // Appeler la fonction pour récupérer l'ID de l'utilisateur au chargement de la page
    getUserIdByName();
  }

  Future<void> getUserIdByName() async {
    final response = await http.get(Uri.parse('${AppGlobal.UrlServer}User/GetUsersByName?name=${widget.name}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        // Récupérer l'ID du premier utilisateur de la liste
        userId = data[0]['Id'];
      }
    } else {
      throw Exception('Failed to load user ID');
    }
    setState(() {}); // Rafraîchir l'interface pour afficher l'ID
  }

  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      SingleChildScrollView(
        child: Column(
          children: [
            Visitor(
              widget.name,
              widget.surname,
              widget.city,
              widget.rate,
              widget.cost,
            ),
            Text('User ID: $userId'), // Afficher l'ID de l'utilisateur
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
                        // Redirection vers la page du profil avec l'ID de l'utilisateur
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage(title: 'Profile', idUser: userId)), // Utilisez userId pour transmettre l'ID de l'utilisateur
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
