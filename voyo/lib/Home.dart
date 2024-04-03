import 'dart:convert';
import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;
import 'visite.dart' as visitePage;
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var listVisitor = [];
  var city = "";
  var id = 1;

  @override
  void initState() {
    super.initState();
    getDataVisitor();
  }

  void getDataVisitor() async {
    try {
      var response = await Dio()
          .get('${AppGlobal.UrlServer}visitor/GetVisitor?city=$city');
      if (response.statusCode == 200) {
        setState(() {
          listVisitor = json.decode(response.data) as List;
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      Stack(
        children: [
          SingleChildScrollView(
            child: Wrap(
              children: [
                Form(
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: () {
                    Form.of(primaryFocus!.context!).save();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2),
                    child: Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "Sélectionnez une ville",
                          filled: true,
                          fillColor: AppGlobal.inputColor,
                          border: InputBorder.none,
                        ),
                        onSaved: (String? value) {
                          setState(() {
                            city = value ?? "";
                          });
                          getDataVisitor();
                        },
                      ),
                    ),
                  ),
                ),
                for (var visitor in listVisitor)
                  Visitor(
                    name: visitor['User']['Name'],
                    surname: visitor['User']['FirstName'],
                    city: visitor['User']['City'],
                    rate: visitor['HourlyRate'].toString(),
                    cost: visitor['Price'].toString(),
                    context: context,
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppGlobal.secondaryColor,
                  ) ,
                  icon: const Icon(Icons.add, color: Colors.black,size: 50,),
                  onPressed: null,
                ),
              ),
        ],
      ),
      widget,
      context,
    );
  }
}

Padding Visitor({
  required String name,
  required String surname,
  required String city,
  required String rate,
  required String cost,
  required BuildContext context,
}) {
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
                ),
              ),
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
                    Text(
                      city,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      rate + "€/h",
                      style: const TextStyle(
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
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  child: Text(
                    cost + "€",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => visitePage.VisitePage(
                title: "Demande de visite",
                name: name,
                surname: surname,
                city: city,
                rate: rate,
                cost: cost,
              ),
            ),
          );
        },
      ),
    ),
  );
}
