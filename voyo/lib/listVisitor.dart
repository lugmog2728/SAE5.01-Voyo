import 'dart:convert';
import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;
import 'choose_visitor.dart' as visitePage;
import 'package:dio/dio.dart';

class listVisitor extends StatefulWidget {
  const listVisitor({Key? key, required this.title, required this.id});

  final String title;
  final int id;

  @override
  State<listVisitor> createState() => _HomePageState();
}

class _HomePageState extends State<listVisitor> {
  var listHouseType = [""];
  var houseType = "";
  var listVisitor = [];
  var city = "";
  var date = "";

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
      }
    } catch (e) {
      print(e);
    }
  }

  void getDataVisitor() async {
    try {
      var response = await Dio().get(
          '${AppGlobal.UrlServer}visitor/GetVisitor?typeHouse=$houseType&city=$city&date=$date');
      if (response.statusCode == 200) {
        setState(() {
          listVisitor = json.decode(response.data) as List;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      SingleChildScrollView(
        child: Wrap(
          children: [
            Form(
              autovalidateMode: AutovalidateMode.always,
              onChanged: () {
                Form.of(primaryFocus!.context!).save();
              },
              child: Wrap(
                children: [
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
                          setState(() {
                            city = value ?? "";
                          });
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
                          setState(() {
                            date = value ?? "";
                          });
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
                              visible: false,
                              child: Icon(Icons.arrow_downward)),
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 0,
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              houseType = value!;
                            });
                            getDataVisitor();
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
                ],
              ),
            ),
            for (var visitor in listVisitor)
              Visitor(
                name: visitor['User']['Name'],
                surname: visitor['User']['FirstName'],
                city: visitor['User']['City'],
                rate: visitor['HourlyRate'].toString(),
                cost: visitor['Price'].toString(),
                id: visitor['User']['Id'],
                houseType : houseType,
                imageUrl: visitor['User']['ProfilPicture'],
                nbetoile: visitor['Rating'],
                context: context,
                widget: widget
              ),
          ],
        ),
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
  required int id,
  required String houseType,
  required String imageUrl,
  required int nbetoile,
  required BuildContext context,
  widget
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
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(8.0),
              height: 100,
              width: 100,
              color: AppGlobal.subInputColor,
              child: Image.network("${AppGlobal.UrlServer}image/$imageUrl", width: 100, height: 100,
              errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/placeholder.webp",width: 100, height: 100)),
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
                    AppGlobal.etoile(nbetoile, 10, 20)
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
                idVisitor: id,
                houseType: houseType,
              ),
            ),
          );
        },
      ),
    ),
  );
}
