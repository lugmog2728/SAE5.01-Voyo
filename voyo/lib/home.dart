import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "Addresse",
                              filled: true,
                              fillColor: AppGlobal.inputColor,
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
                              hintText: "Date",
                              filled: true,
                              fillColor: AppGlobal.inputColor,
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
                              hintText: "Addresse",
                              filled: true,
                              fillColor: AppGlobal.inputColor,
                              border: InputBorder.none,
                            ),
                            onSaved: (String? value) {
                              debugPrint(
                                  'Type de logement');
                            },
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            ]
        ),
        widget);
  }
}