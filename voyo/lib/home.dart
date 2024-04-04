import 'dart:convert';
import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;
import 'visite.dart' as visitePage;
import 'listVisitor.dart' as listVisitor;
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var listVisit = [];
  var listName = [""];
  var listHouseType = [""];
  var city = "";
  var id = 6;

  @override
  void initState() {
    super.initState();
    getDataVisitor();
  }

  void getDataVisitor() async {
    try {
      listName = [""];
      var response =
          await Dio().get('${AppGlobal.UrlServer}Visit/GetVisitDemande?id=$id');
      if (response.statusCode == 200) {
        setState(() {
          listVisit = json.decode(response.data) as List;
        });
        for (var visit in listVisit){

          listName.add(await GetNameUser(visit));
          listHouseType.add(await GetHouseTypeName(visit['HousingTypeId']));
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> GetHouseTypeName(id) async {
    try {
        var response = await Dio().get(
            '${AppGlobal.UrlServer}House/GetTypeHouseById?id=${id}');
        if (response.statusCode == 200) {
          return json.decode(response.data)[0];
        } else {
          print(response.statusCode);
        }
    } catch (e) {
      print(e);
    }
    return "error";
  }

  Future<String> GetNameUser(visit) async {
    try {

      if (visit['VisitorId'] != id) {

        var response = await Dio().get(
            '${AppGlobal.UrlServer}Visitor/GetVisitorByID?id=${visit['VisitorId'].toString()}');
        if (response.statusCode == 200) {
          return json.decode(response.data)['User']['Name'];
          setState(() {
            listVisit = json.decode(response.data) as List;
          });
        } else {
          print(response.statusCode);
        }
      } else {
        var response = await Dio()
            .get('${AppGlobal.UrlServer}User/GetUserByID?id=${visit['UserId'].toString()}');
        if (response.statusCode == 200) {
          return json.decode(response.data)['User']['Name'];
          setState(() {
            listVisit = json.decode(response.data) as List;
          });
        } else {
          print(response.statusCode);
        }
      }
    } catch (e) {
      debugPrint( visit['UserId'].toString());
      print(e);
    }
    return "error";
  }

  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      Expanded(
        child:Stack(
        children: [
        Expanded(
        child:SingleChildScrollView(
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

                for(int index = 0; index < listVisit.length; index++)
                  Visit(
                    name: listName[index].toString(),
                    surname: listVisit[index]['statut'].toString(),
                    city: listVisit[index]['Street'].toString() +
                        " " +
                        listVisit[index]['City'].toString() +
                        " " +
                        listVisit[index]['PostalCode'].toString(),
                    rate: listVisit[index]['statut'].toString(),
                    cost: "10",
                    typeHouse: listHouseType[index],
                    user: listVisit[index]['statut'].toString(),
                    context: context,
                  ),
              ],
            ),
          ),
        ),
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: AppGlobal.secondaryColor,
              ),
              icon: const Icon(
                Icons.add,
                color: Colors.black,
                size: 50,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const listVisitor.listVisitor(
                      title: "Demande de visite",
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      ),
      widget,
      context,
    );
  }
}

Padding Visit({
  required String typeHouse,
  required String city,
  required String name,
  required String surname,
  required String rate,
  required String user,
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
                      typeHouse,
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
                      user,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      cost + "€",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
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
