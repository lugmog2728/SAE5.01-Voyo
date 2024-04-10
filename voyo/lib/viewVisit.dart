// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'pay.dart';
import 'globals.dart' as AppGlobal;
import 'package:intl/intl.dart';
import "availibility.dart";
import 'profile.dart';

// ignore: must_be_immutable
class ViewVisitPage extends StatefulWidget {
  ViewVisitPage({
    Key? key,
    required this.title,
    required this.idVisit,
  }) : super(key: key);

  final String title;
  final int idVisit;

  @override
  State<ViewVisitPage> createState() => _ViewVisitePageState();
}

class _ViewVisitePageState extends State<ViewVisitPage> {
  // ignore: prefer_typing_uninitialized_variables
  var visitor;
  // ignore: prefer_typing_uninitialized_variables
  var user;
  // ignore: prefer_typing_uninitialized_variables
  var visit;
  // ignore: prefer_typing_uninitialized_variables
  var pointToCheck;

  String _whoIsConnect = "";

  @override
  void initState() {
    super.initState();
    fetchVisit().then((_) {
      fetchHouseById();
      fetchVisitor();
      fetchUser();
      setState(() {
        _whoIsConnect = whoIsConnect();
      });
    });
    fetchPTC();
  }

  Future<void> fetchVisit() async {
    try {
      final Map<String, dynamic>? jsonData = await AppGlobal.fetchDataMap(
          '${AppGlobal.UrlServer}Visit/GetVisitDemandeById?id=${widget.idVisit}');
      if (jsonData != null) {
        setState(() {
          visit = jsonData;
        });
      }
    } catch (error) {
      print('Error fetching visit: $error');
    }
  }

  Future<void> fetchHouseById() async {
    try {
      final jsonData = await AppGlobal.fetchDataString(
          '${AppGlobal.UrlServer}House/GetTypeHouseById?id=${visit['HousingTypeId']}');
      if (jsonData != null) {
        setState(() {
          visit['HousingTypeId'] = jsonData;
        });
      }
    } catch (error) {
      print('Error fetching housingTypeId: $error');
    }
  }

  Future<void> fetchPTC() async {
    try {
      final List? jsonData = await AppGlobal.fetchData(
          '${AppGlobal.UrlServer}Pointcheck/GetPointByIdVisit?id=${widget.idVisit}');
      if (jsonData != null) {
        setState(() {
          pointToCheck = jsonData;
        });
      }
    } catch (error) {
      print('Error fetching ptc: $error');
    }
  }

  Future<void> fetchUser() async {
    try {
      final Map<String, dynamic>? jsonData = await AppGlobal.fetchDataMap(
          '${AppGlobal.UrlServer}User/GetUserByID?id=${visit['UserId']}');
      if (jsonData != null) {
        setState(() {
          user = jsonData;
          print(user);
        });
      }
    } catch (error) {
      print('Error fetching user: $error');
    }
  }

  Future<void> fetchVisitor() async {
    try {
      final Map<String, dynamic>? jsonData = await AppGlobal.fetchDataMap(
          '${AppGlobal.UrlServer}Visitor/GetVisitorByID?Id=${visit['VisitorId']}');
      if (jsonData != null) {
        setState(() {
          visitor = jsonData;
        });

      }
    } catch (error) {
      print('Error fetching visitors: $error');
    }
  }

  String whoIsConnect(){
    if (visitor['User']['Id'] == AppGlobal.idUser) {
      return "visitor";
    }
    return "user";
  }

  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Logement",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Type de logement : ${visit['HousingTypeId']}",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        "Ville : ${visit['City']} (${visit['PostalCode']})",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        "Adresse : ${visit['Street']}",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_whoIsConnect == "user")
              Profil(context, visitor['User']['Id'], visitor['User']['Name'], visitor['User']['FirstName'])
            else
              if (user['User'] == null)
                Profil(context, user['Id'], user['Name'], user['FirstName'])
              else
                Profil(context, user['User']['Id'], user['User']['Name'], user['User']['FirstName']),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Point à vérifier",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        for (var point in pointToCheck)
                          Text(
                            "${point['Wording']}",
                            style: const TextStyle(fontSize: 16.0),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_whoIsConnect == "visitor" )
              ElevatedButton(
                style: AppGlobal.buttonStyle,
                onPressed: () {},
                child: Text('Accepter la demande'), // Texte affiché sur le bouton
              )
          ]
        ),
      ),
      widget,
      context,
    );
  }
}



Padding Profil(BuildContext context, int id, String name, String surname) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: AppGlobal.inputColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage(title: 'Profile', idUser: id)),
          );
        },
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      surname,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
