import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;
import 'visite.dart' as visitePage;
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var listHouseType = [""];
  var houseType = "";
  var listVisitor;
  var City = "";
  var Date = "";

  @override
  void initState() {
    super.initState();
    getDataHouseType();
    getDataVisitor();
  }

  void getDataHouseType() async {
    try {
      var response =
          await Dio().get('${AppGlobal.UrlServer}House/GetTypeHouse');
      if (response.statusCode == 200) {
        setState(() {
          listHouseType = json.decode(response.data).cast<String>().toList();
          houseType = listHouseType[0];
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }
  void getDataVisitor() async {
    try {
      var response = await Dio().get(
          '${AppGlobal.UrlServer}visitor/GetVisitor?typeHouse=${houseType}&city=${City}&date=${Date}');
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
        SingleChildScrollView(
          child: Wrap(children: [
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
                        hintText: "City",
                        filled: true,
                        fillColor: AppGlobal.inputColor,
                        border: InputBorder.none,
                      ),
                      onSaved: (String? value) {
                        City = value ?? "";
                        getDataVisitor();
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
                        Date = value ?? "";
                        getDataVisitor();
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8.0, left: 8.0),
                  color: AppGlobal.inputColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(canvasColor: AppGlobal.subInputColor),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: houseType,
                        elevation: 0,
                        icon: const Visibility(
                            visible: false, child: Icon(Icons.arrow_downward)),
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            houseType = value!;
                            getDataVisitor();
                          });
                        },
                        items: listHouseType
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(
                              child: Text(
                                value,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            for (var visitor in listVisitor)
              Visitor(visitor['User']['Name'],visitor['User']['FirstName'], visitor['User']['City'], visitor['HourlyRate'].toString(), visitor['Price'].toString(), context),
          ]),
        ),
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
                  child: Text(cost + "€",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                      )),
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
