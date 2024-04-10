// ignore_for_file: non_constant_identifier_names

library my_prj.globals;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'home.dart' as homePage;
import 'chat.dart' as chatPage;
import 'profile.dart' as profilPage;
import 'package:http/http.dart' as http;

Color primaryColor = const Color(0xFFFE881C);
Color secondaryColor = const Color(0xFFFEC534);
Color backgroundColor = const Color(0xFFFCFAD3);
Color inputColor = const Color(0xFFFEE486);
Color subInputColor = const Color(0xFFE4CC76);
Color buttonback = const Color(0xFFFFFEE8);
String UrlServer = "http://172.26.240.10:1080/voyo/";
int idUser = 1;

ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: primaryColor,
  foregroundColor: Colors.black
);

BoxDecoration TitleDecoration() {
  return BoxDecoration(
    border: Border(
      bottom: BorderSide(width: 4, color: secondaryColor),
    ),
  );
}

Scaffold Menu(content, widget, context) {
  return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      title: Container(
        decoration: TitleDecoration(),
        height: 45,
        child: Stack(
          children: [
            Align(child: Text(widget.title)),
            Positioned(
              left: 0,
              width: 100,
              height: 50,
              child: Image.asset('assets/images/Logo Voyo.png'),
            ),
          ],
        ),
      ),
    ),
    body: content,
    bottomNavigationBar: Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 80,
            child: Expanded(
              child: FloatingActionButton(
                backgroundColor: secondaryColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => profilPage.ProfilePage(
                              title: "Profile",
                              idUser: idUser,
                            )),
                  );
                },
                tooltip: 'Account',
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                  ),
                ),
                elevation: 0,
                child: const Icon(Icons.person),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            color: secondaryColor,
          ),
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              color: backgroundColor,
            ),
            child: FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          homePage.HomePage(title: "Page acceuil", id: widget.id)),
                );
              },
              tooltip: 'Home',
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              elevation: 0,
              child: const SizedBox(
                width: 100,
                child: Icon(Icons.home),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 80,
            child: Expanded(
              child: FloatingActionButton(
                backgroundColor: secondaryColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const chatPage.ChatPage(title: "Discussion")),
                  );
                },
                tooltip: 'Chat',
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                  ),
                ),
                elevation: 0,
                child: const Icon(Icons.message),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


Scaffold MenuConnexion(content, widget, context) {
  return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      title: Container(
        decoration: TitleDecoration(),
        height: 45,
        child: Stack(
          children: [
            Align(child: Text(widget.title)),
            Positioned(
              left: 0,
              width: 100,
              height: 50,
              child: Image.asset('assets/images/Logo Voyo.png'),
            ),
          ],
        ),
      ),
    ),
    body: content,
    bottomNavigationBar: Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 80,
            child: Expanded(
              child: FloatingActionButton(
                backgroundColor: secondaryColor,
                onPressed: () {
                },
                tooltip: 'Account',
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                  ),
                ),
                elevation: 0,
                child: const Icon(Icons.person),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            color: secondaryColor,
          ),
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              color: backgroundColor,
            ),
            child: FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
              },
              tooltip: 'Home',
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              elevation: 0,
              child: const SizedBox(
                width: 100,
                child: Icon(Icons.home),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 80,
            child: Expanded(
              child: FloatingActionButton(
                backgroundColor: secondaryColor,
                onPressed: () {
                },
                tooltip: 'Chat',
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                  ),
                ),
                elevation: 0,
                child: const Icon(Icons.message),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Row etoile(int nbetoile, double w, double h) {
  List<Widget> list = [];
  for (var i = 0; i < nbetoile; i++) {
    list.add(Image.asset(
      'assets/images/etoilePleine.png',
      width: w,
      height: h,
    ));
  }
  for (var i = 0; i < 5-nbetoile; i++) {
    list.add(Image.asset(
      'assets/images/etoileVide.png',
      width: w,
      height: h,
    ));
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      for (var img in list) img,
    ],
  );
}

Future<List<dynamic>?> fetchData(String urlString) async {
  var url = Uri.parse(urlString);

  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData;
    } else {
      print('Erreur de requête : ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Erreur de connexion : $e');
    return null;
  }
}

Future<Map<String, dynamic>?> fetchDataMap(String urlString) async {
  var url = Uri.parse(urlString);

  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      return jsonData;
    } else {
      print('Erreur de requête : ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Erreur de connexion : $e');
    return null;
  }
}

Future<String?> fetchDataString(String urlString) async {
  var url = Uri.parse(urlString);

  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      String jsonData = response.body;
      String decodedData = json.decode(jsonData);
      return decodedData.replaceAll('"', '');
    } else {
      print('Erreur de requête : ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Erreur de connexion : $e');
    return null;
  }
}

Future<bool> sendData(String urlString) async {
  var url = Uri.parse(urlString);
  try {
    await http.get(url);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> sendImage(String urlString, File image) async {
  List<int> imageBytes = await image.readAsBytes();

  var response = await http.put(
    Uri.parse(urlString),
    body: imageBytes,
    headers: {
      'Content-Type': 'image/jpeg', // Remplacer le type MIME selon votre besoin
    },
  );

  // Vérifier la réponse
  if (response.statusCode == 200) {
    // L'image a été téléchargée avec succès
    print('Image uploaded successfully');
    return true;
  } else {
    // Gérer les erreurs
    print('Failed to upload image');
    return false;
  }
}