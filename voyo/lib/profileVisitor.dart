import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'globals.dart' as AppGlobal;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      SingleChildScrollView(
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row (
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              const Expanded (
                child: Padding (
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Statut : Utilisateur",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: FloatingActionButton(
                    backgroundColor: AppGlobal.secondaryColor,
                    onPressed: null,
                    child: const Text('Modifier')
                    ),
                  ),
                ),
              ],
            ),
            Row(children: [ 
              Container (
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 16, right: 16),
                width: 140,
                height: 180,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/profilePicture.jpg'))
                ),
              ),

              Container (
                alignment: Alignment.center,
                height: 180,
                child : Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 150,
                      decoration: BoxDecoration (
                        border: Border (
                          bottom: BorderSide (
                            color: AppGlobal.secondaryColor,
                            width: 3,
                          )
                        )
                      ),
                      child: const Text (
                        'Thomas',
                        style: TextStyle (
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    Container (
                      alignment: Alignment.centerLeft,
                      width: 150,
                      decoration: BoxDecoration (
                        border: Border (
                          bottom: BorderSide (
                            color: AppGlobal.secondaryColor,
                            width: 3,
                            )
                          )
                        ),
                      child: const Text (
                        'Thomas',
                        style: TextStyle (
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),

                  Container (
                      alignment: Alignment.centerLeft,
                      width: 150,
                      decoration: BoxDecoration (
                        border: Border (
                          bottom: BorderSide (
                            color: AppGlobal.secondaryColor,
                            width: 3,
                            )
                          )
                        ),
                      child: const Text (
                        'Saint-Poutier-Sur-Rhône',
                        style: TextStyle (
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    Container (
                      alignment: Alignment.centerLeft,
                      width: 150,
                      decoration: BoxDecoration (
                        border: Border (
                          bottom: BorderSide (
                            color: AppGlobal.secondaryColor,
                            width: 3,
                            )
                          )
                        ),
                      child: const Text (
                        '50 €',
                        style: TextStyle (
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ]),
                ),
              ]
            ),

            Container (
              alignment: Alignment.centerLeft,
              width: 150,
              padding: const EdgeInsets.only(left: 16),
                
              child: etoile(2, 20.0, 50.0)
            ),

            Container(
              alignment: Alignment.centerLeft,
              width: 150,
              margin: const EdgeInsets.only(left: 16),
              child: const Column ( 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text (
                    'Horaire',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )
                  ),

                  Text (
                    'Lundi: 16h à 18h',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                  Text (
                    'Mardi: 14h à 16h',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                  Text (
                    'Vendredi: 12h à 18h',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ],
              ),
            ),

            Container (
              alignment: Alignment.center,
              margin: const EdgeInsets.all(16),
              child: Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text (
                    'Commentaire',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  Comment('Utilisateur aléatoire', 'assets/images/profilePicture.jpg', '12/10/2023', 'Voici un commentaire des plus petinenant sur un ivisteur très charismatique', 4, context),
                  Comment('Utilisateur aléatoire', 'assets/images/profilePicture.jpg', '02/02/2024', 'NUL à chier mais 2 étoiles parce que j''ai pas race',2 ,context),
                ],
              ),
            )
          ]
        ),
      ), widget, context
    );
  }
}

Row etoile(nbetoile, w, h) {
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

Container Comment(uti, img, date, txt, nbEt, context) {
  return Container(
    alignment: Alignment.center,
    margin: const EdgeInsets.only(bottom: 10),
    color: AppGlobal.primaryColor,
    child: Column (
      children: [
        Row (
          children: [
            Container (
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top:2, left: 10),
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(img),
                  fit: BoxFit.cover,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: const Border(
                  bottom: BorderSide(color: Colors.black),
                  top: BorderSide(color: Colors.black),
                  right: BorderSide(color: Colors.black),
                  left: BorderSide(color: Colors.black),
                )
              ),
            ),

            Padding (
              padding: const EdgeInsets.only(right:16, left: 16, top:3),
              child: Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text (
                    uti,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )
                  ),

                  etoile(nbEt,10.0,15.0)
                ],
              )
            ),
            Expanded(
              child: Container (
                alignment: Alignment.topRight,
                margin: const EdgeInsets.all(5),
                child: Text (
                  date,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                  ),
                )
              )
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right:5, left: 5, top:3),
          child: Text(
            txt,
          ),
        ),
      ],
    ),
  );
}