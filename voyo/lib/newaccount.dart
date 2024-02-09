import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;

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
        Wrap(
            children: [
              Form(
                autovalidateMode: AutovalidateMode.always,
                onChanged: () {
                  Form.of(primaryFocus!.context!).save();
                },
                child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nom",
                              filled: true,
                              fillColor: AppGlobal.buttonback,

                            ),
                            onSaved: (String? value) {
                              debugPrint(
                                  'Value for field saved as ');
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
                              border: InputBorder.none,
                              hintText: "Prénom",
                              filled: true,
                              fillColor: AppGlobal.buttonback,

                            ),
                            onSaved: (String? value) {
                              debugPrint(
                                  'Value for field saved as ');
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
                              hintText: "Date de naissance",
                              filled: true,
                              fillColor: AppGlobal.buttonback,
                              border: InputBorder.none,

                            ),
                            onSaved: (String? value) {
                              debugPrint(
                                  'Value for field saved as ');
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
                              border: InputBorder.none,
                              hintText: "Ville",
                              filled: true,
                              fillColor: AppGlobal.buttonback,

                            ),
                            onSaved: (String? value) {
                              debugPrint(
                                  'Value for field saved as ');
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
                              border: InputBorder.none,
                              hintText: "Code postal",
                              filled: true,
                              fillColor: AppGlobal.buttonback,

                            ),
                            onSaved: (String? value) {
                              debugPrint(
                                  'Value for field saved as ');
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
                              border: InputBorder.none,
                              hintText: "Adresse postal",
                              filled: true,
                              fillColor: AppGlobal.buttonback,

                            ),
                            onSaved: (String? value) {
                              debugPrint(
                                  'Value for field saved as ');
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
                              border: InputBorder.none,
                              hintText: "Adresse mail",
                              filled: true,
                              fillColor: AppGlobal.buttonback,

                            ),
                            onSaved: (String? value) {
                              debugPrint(
                                  'Value for field saved as ');
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
                              border: InputBorder.none,
                              hintText: "Mot de passe",
                              filled: true,
                              fillColor: AppGlobal.buttonback,

                            ),
                            onSaved: (String? value) {
                              debugPrint(
                                  'Value for field saved as ');
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
                              border: InputBorder.none,
                              hintText: "Confirmation mot de passe",
                              filled: true,
                              fillColor: AppGlobal.buttonback,

                            ),
                            onSaved: (String? value) {
                              debugPrint(
                                  'Value for field saved as ');
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
                              border: InputBorder.none,
                              hintText: "Photo",
                              filled: true,
                              fillColor: AppGlobal.buttonback,

                            ),
                            onSaved: (String? value) {
                              debugPrint(
                                  'Value for field saved as ');
                            },
                          ),
                        ),
                      ),
                      Center(child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                          onPrimary: Colors.white,
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Parcourir',
                          style: TextStyle(

                            color: Colors.black,

                          ),
                        ),
                      )
                      ),
                      Center(child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                          onPrimary: Colors.white,
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Valider',
                          style: TextStyle(

                            color: Colors.black,

                          ),
                        ),
                      )
                      )


                    ]
                ),
              ),
            ]
        ),
        widget,context);
  }
}