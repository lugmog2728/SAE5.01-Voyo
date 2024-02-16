import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;
import 'home.dart' as homePage;
import 'newaccount.dart' as newAccountPage;

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key, required this.title});

  final String title;

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
        Wrap(children: [
          Form(
            autovalidateMode: AutovalidateMode.always,
            onChanged: () {
              Form.of(primaryFocus!.context!).save();
            },
            child: Wrap(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Identifiant",
                      filled: true,
                      fillColor: AppGlobal.buttonback,
                      border: InputBorder.none,
                    ),
                    onSaved: (String? value) {
                      debugPrint('Value for field saved as ');
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Mot de passe",
                      filled: true,
                      fillColor: AppGlobal.buttonback,
                      border: InputBorder.none,
                    ),
                    onSaved: (String? value) {
                      debugPrint('Value for field saved as ');
                    },
                  ),
                ),
              ),
              Center(
                  child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const homePage.HomePage(title: "Acceuil")),
                  );
                },
                child: const Text(
                  'Connexion',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )),
              Center(
                  child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const newAccountPage.newAccountPage(
                                title: "Créer un compte")),
                  );
                },
                child: const Text(
                  'Créer un compte',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ))
            ]),
          ),
        ]),
        widget,
        context);
  }
}
