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
  var listUser = [];
  var listHouseType = [""];
  var city = "";


  @override
  void initState() {
    super.initState();
    getDataVisitor();
    print("Bonjour");
  }

  void getDataVisitor() async {
    try {
      setState(() {
        listUser = [];
        listHouseType = [];
        listCost = [];
        listVisitTemp = [];
        listVisit = [];
      });
      var response =
          await Dio().get('${AppGlobal.UrlServer}Visit/GetVisitDemande?id=${AppGlobal.idUser}&city=$city');
      if (response.statusCode == 200) {
        listVisitTemp = json.decode(response.data) as List;
        for (var visit in listVisitTemp) {
          listUser.add(await GetNameUser(visit));
          listHouseType.add(await GetHouseTypeName(visit['HousingTypeId']));
          listCost.add((await GetCost(visit, listHouseType.last)));
        }
        setState(() {
          listUser = listUser;
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

  Future<dynamic> GetNameUser(visit) async {
    try {
      if (visit['VisitorId'] != AppGlobal.idUser) {
        var response = await Dio().get(
            '${AppGlobal.UrlServer}Visitor/GetVisitorByID?id=${visit['VisitorId'].toString()}');
        if (response.statusCode == 200) {
          return json.decode(response.data)['User'];
        } else {
          print("error 1");
          print(response.statusCode);
        }
      } else {
        var response = await Dio().get(
            '${AppGlobal.UrlServer}User/GetUserByID?id=${visit['UserId'].toString()}');
        if (response.statusCode == 200) {
          if (json.decode(response.data)['User'] == null) {
            return json.decode(response.data);
          } else {
            return json.decode(response.data)['User'];
          }
        } else {
          print("error 2");
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
                        name: listUser[index]['Name'].toString(),
                        city: listVisit[index]['Street'].toString() +
                            " " +
                            listVisit[index]['City'].toString() +
                            " " +
                            listVisit[index]['PostalCode'].toString(),
                        cost: listCost[index],
                        typeHouse: listHouseType[index],
                        imageUrl: listUser[index]['ProfilPicture'].toString(),
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
  required String imageUrl,
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
