import 'package:flutter/material.dart';
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
        Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Statut : Utilisateur",
                    textAlign: TextAlign.end,
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
                      child: const Text('Modifier')),
                ),
              ),
            ],
          ),
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                alignment: Alignment.center,
                color: AppGlobal.secondaryColor,
                width: 140,
                height: 180,
                child: const Text("Photo"),
              ),
            ),
          ]),
        ]),
        widget,
        context);
  }
}
