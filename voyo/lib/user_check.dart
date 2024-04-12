import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;


class UserCheckPage extends StatefulWidget {
  const UserCheckPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<UserCheckPage> createState() => _UserCheckPageState();
}



class _UserCheckPageState extends State<UserCheckPage> {
  List<Map<String, dynamic>> visitors = [];
  bool valideAuto = false;

  void initState() {
    super.initState();
    fetchVisitor().then((allVisitor) {
      if (allVisitor != null) {
        for (var visitor in allVisitor) {
          if (visitor['State'] == "Attente") {
            visitors.add(visitor);
          }
          setState(() {
            visitors;
          });
        }
      }
    });
  }


  Future<List<dynamic>?> fetchVisitor() async {
    try {
      final List<dynamic>? jsonData = await AppGlobal.fetchData('${AppGlobal.UrlServer}Visitor/GetVisitor');
      return jsonData;
    } catch (error) {
      print('Error fetching visitors: $error');
      return null;
    }
  }

  Future<void> fetchAutoValide() async {
    try {
      final List<dynamic>? jsonData = await AppGlobal.fetchData('${AppGlobal.UrlServer}Visitor/GetValidationAuto');
      initState(){
        valideAuto = jsonData as bool;
      }

    } catch (error) {
      print('Error fetching autodemande: $error');
      return null;
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
              for (var visitor in visitors)
                _buildVisitorCard(
                  visitor['User']['ProfilPicture'],
                  visitor['User']['Name'],
                  visitor['User']['FirstName'],
                  visitor['Id']
                ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Validation automatique'),
                value: valideAuto,
                onChanged: (newValue) {
                  AppGlobal.fetchData('${AppGlobal.UrlServer}Visitor/ValidationAuto?active=$newValue');
                  setState(() {
                    visitors = [];
                  });
                },
              ),
            ],
          ),
        ),
      ),
      widget,
      context,
    );
  }

  Widget _buildVisitorCard(String image, String firstName, String lastName, int id) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: AppGlobal.subInputColor,
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(image),
            radius: 30,
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nom: $lastName'),
              Text('Prénom: $firstName'),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              AppGlobal.fetchData('${AppGlobal.UrlServer}Visitor/ChangeStatusVisitor?id=${id}&status=Refuser');
              setState(() {
                visitors.removeWhere((visitor) => visitor['Id'] == id);
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              AppGlobal.fetchData('${AppGlobal.UrlServer}Visitor/ChangeStatusVisitor?id=${id}&status=Valider');
              setState(() {
                visitors.removeWhere((visitor) => visitor['Id'] == id);
              });
            },
          ),
        ],
      ),
    );
  }
}
