import 'dart:convert';
import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;
import 'listVisitor.dart' as listVisitor;
import 'package:dio/dio.dart';
import 'viewVisit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title});

  final String title;



  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var listVisit = [];
  var listVisitTemp = [];
  var listCost = [];
  var listName = [""];
  var listHouseType = [""];
  var city = "";


  @override
  void initState() {
    super.initState();
    getDataVisitor();
  }

  void getDataVisitor() async {
    try {
      setState(() {
        listName = [];
        listHouseType = [];
        listCost = [];
        listVisitTemp = [];
        listVisit = [];
      });
      debugPrint('${AppGlobal.UrlServer}Visit/GetVisitDemande?id=${AppGlobal.idUser}&city=${city}');
      var response =
          await Dio().get('${AppGlobal.UrlServer}Visit/GetVisitDemande?id=${AppGlobal.idUser}&city=${city}');
      if (response.statusCode == 200) {
        listVisitTemp = json.decode(response.data) as List;
        for (var visit in listVisitTemp) {
          listName.add(await GetNameUser(visit));
          listHouseType.add(await GetHouseTypeName(visit['HousingTypeId']));
          listHouseType.add(await GetHouseTypeName(visit['HousingTypeId']));
          listCost.add((await GetCost(visit, listHouseType.last)));
        }
        debugPrint(listName.toString());
        setState(() {
          listName = listName;
          listHouseType = listHouseType;
          listCost = listCost;
          listVisit = listVisitTemp;
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> GetHouseTypeName(id) async {
    try {
      var response = await Dio()
          .get('${AppGlobal.UrlServer}House/GetTypeHouseById?id=${id}');
      if (response.statusCode == 200) {
        return json.decode(response.data);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
    return "error";
  }

  Future<String> GetCost(visit, typehouse) async {
    try {
      var response = await Dio().get(
          '${AppGlobal.UrlServer}Visitor/GetVisitorByID?id=${visit['VisitorId'].toString()}&typeHouse=${typehouse}');
      if (response.statusCode == 200) {
        return json.decode(response.data)['Price'].toString();
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
    return "Error";
  }

  Future<String> GetNameUser(visit) async {
    try {
      if (visit['VisitorId'] != AppGlobal.idUser) {
        var response = await Dio().get(
            '${AppGlobal.UrlServer}Visitor/GetVisitorByID?id=${visit['VisitorId'].toString()}');
        if (response.statusCode == 200) {
          return json.decode(response.data)['User']['Name'];
        } else {
          print(response.statusCode);
        }
      } else {
        var response = await Dio().get(
            '${AppGlobal.UrlServer}User/GetUserByID?id=${visit['UserId'].toString()}');
        if (response.statusCode == 200) {
          return json.decode(response.data)['User']['Name'];
        } else {
          print(response.statusCode);
        }
      }
    } catch (e) {
      print(e);
    }
    return "error";
  }

  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      Expanded(
        child: Stack(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    Form(
                      autovalidateMode: AutovalidateMode.always,
                      onChanged: () {
                        Form.of(primaryFocus!.context!).save();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 4.0, right: 4.0, bottom: 2),
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
                    for (int index = 0; index < listVisit.length; index++)
                      Visit(
                        name: listName[index].toString(),
                        city: listVisit[index]['Street'].toString() +
                            " " +
                            listVisit[index]['City'].toString() +
                            " " +
                            listVisit[index]['PostalCode'].toString(),
                        cost: listCost[index],
                        typeHouse: listHouseType[index],
                        id: listVisit[index]["Id"],
                        context: context,
                      ),
                  ],
                ),
              ),
            ),
            Expanded(child: Container()),
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
                      builder: (context) =>  listVisitor.listVisitor(
                        title: "Demande de visite",
                        id: AppGlobal.idUser,
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
  required String cost,
  required int id,
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
                      name,
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
              builder: (context) => ViewVisitPage(
                title: 'Visite',
                idVisit: id,
              ),
            ),
          );
        },
      ),
    ),
  );
}
