import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;
import 'home.dart' as homePage;
import 'user_check.dart' as user_check;
import 'newaccount.dart' as newAccountPage;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loginError = false;

  Future<void> attemptLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await http.post(
      Uri.parse('${AppGlobal.UrlServer}User/Connexion'),
      body: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      if (userData['Id'] != null) {
        AppGlobal.idUser = userData['Id'];
        // Connection success
        if (AppGlobal.idUser == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => user_check.UserCheckPage(title: "Validation visiteur")
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => homePage.HomePage(title: "Accueil")
            ),
          );
        }
      } else {
        // Connection fail
        setState(() {
          _loginError = true;
        });
      }
    } else {
      setState(() {
        _loginError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppGlobal.MenuConnexion(
      Wrap(
        children: [
          Form(
            autovalidateMode: AutovalidateMode.always,
            onChanged: () {
              Form.of(primaryFocus!.context!).save();
            },
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "E-mail",
                        filled: true,
                        fillColor: AppGlobal.buttonback,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: TextFormField(
                      controller: _passwordController,
                      textAlign: TextAlign.center,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Mot de passe",
                        filled: true,
                        fillColor: AppGlobal.buttonback,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                if (_loginError)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'E-mail ou mot de passe incorrect',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.yellow,
                      onPrimary: Colors.white,
                    ),
                    onPressed: attemptLogin,
                    child: const Text(
                      'Connexion',
                      style: TextStyle(color: Colors.black),
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
                          builder: (context) => const newAccountPage.NewAccountPage(
                            title: "Créer un compte",
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Créer votre compte',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      widget,
      context,
    );
  }
}