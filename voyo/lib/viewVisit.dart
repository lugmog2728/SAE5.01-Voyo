// ignore_for_file: library_prefixes
import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;
import 'profile.dart';
import 'rdv_close.dart';


// ignore: must_be_immutable
class ViewVisitPage extends StatefulWidget {
  const ViewVisitPage({
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

  String _whoIsConnect ="";
  
  @override
  void initState() {
    super.initState();
    fetchVisit().then((_) {
      fetchHouseById();
      fetchVisitor().then((_) {
        setState(() {
          _whoIsConnect = whoIsConnect();
        });
      });
      fetchUser();
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
            Text(visit["statut"]),
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
            Profil(context, visitor['User']['Id'], visitor['User']['Name'], visitor['User']['FirstName'], visitor['User']['ProfilPicture'])
            else if (_whoIsConnect == "visitor")
              if (user['User'] == null)
                Profil(context, user['Id'], user['Name'], user['FirstName'], user['ProfilPicture'])
              else
                Profil(context, user['User']['Id'], user['User']['Name'], user['User']['FirstName'], user['User']['ProfilPicture']),
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
              if ( visit["statut"] == "Confirmer")
                ElevatedButton(
                  style: AppGlobal.buttonStyle,
                  onPressed: () {
                    AppGlobal.sendData("${AppGlobal.UrlServer}Visit/StartVisit?id=${widget.idVisit}");
                  },
                  child: const Text('Débuter la visite'),
                )
              else if ( visit["statut"] == "Payer")
                ElevatedButton(
                  style: AppGlobal.buttonStyle,
                  onPressed: () {
                    AppGlobal.sendData("${AppGlobal.UrlServer}Visit/ConfirmedVisit?id=${widget.idVisit}").then((_){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewVisitPage(
                            title: "Demande de visite",
                            idVisit: widget.idVisit,
                          ),
                        ),
                      );
                    });

                  },
                  child: const Text('Accepter la demande'),
                )
            else
              if (visit["statut"] == "Démarrer")
                const Column(
                  children: [
                    Text("La visite est en cours"),
                    Text("vous recevrez le compte rendu une fois terminé"),
                  ],
                ),
              if (visit["statut"] == "Payer")
                const Text("En attente d'une réponse du visiteur"),
              if (visit["statut"] == "Confirmer")
                const Text("La visite a été acceptée, elle débutera bientôt"),
              if (visit["statut"] == "Terminer")
                ElevatedButton(
                  style: AppGlobal.buttonStyle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RdvClosePage(
                          idVisit: widget.idVisit,
                        ),
                      ),
                    );
                  },
                  child: const Text('Clore la visite'),
                ),
          ]
        ),
      ),
      widget,
      context,
    );
  }
}



Padding Profil(BuildContext context, int id, String name, String surname, String imageUrl) {
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
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(8.0),
              height: 100,
              width: 100,
              color: AppGlobal.subInputColor,
              child: Image.network("${AppGlobal.UrlServer}image/$imageUrl", width: 100, height: 100,
              errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/placeholder.webp",width: 100, height: 100)),
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
