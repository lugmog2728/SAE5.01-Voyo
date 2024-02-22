import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;
import 'choose_visitor.dart' as visitePage;

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
        Wrap(children: [
          Form(
            autovalidateMode: AutovalidateMode.always,
            onChanged: () {
              Form.of(primaryFocus!.context!).save();
            },
            child: Wrap(children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2),
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
                      debugPrint('Value for field saved as ');
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2),
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
                      debugPrint('Value for field saved as ');
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2),
                child: Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Type de logement",
                      filled: true,
                      fillColor: AppGlobal.inputColor,
                      border: InputBorder.none,
                    ),
                    onSaved: (String? value) {
                      debugPrint('Type de logement');
                    },
                  ),
                ),
              ),
            ]),
          ),
          Visitor("thomas", "thomas", "lyon", "13", "26", context),
          Visitor("thomas", "thomas", "lyon", "13", "26", context),
          Visitor("thomas", "thomas", "lyon", "13", "26", context),
        ]),
        widget,
        context);
  }
}

Padding Visitor(name, surname, city, rate, cost, context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppGlobal.inputColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
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
                  )),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      surname,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      city,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      rate + "€/h",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Image.asset(
                      'assets/images/etoile.png',
                      width: 100,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(cost + "€",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                      )),
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                ),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const visitePage.VisitePage(title: "Demande de visite")),
          );
        },
      ),
    ),
  );
}
