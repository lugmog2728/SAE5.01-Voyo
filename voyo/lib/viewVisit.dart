// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'pay.dart';
import 'globals.dart' as AppGlobal;
import 'package:intl/intl.dart';
import "availibility.dart";
import 'profile.dart';

// ignore: must_be_immutable
class ViewVisitPage extends StatefulWidget {
  ViewVisitPage({
    Key? key,
    required this.title,
    required this.idVisit,
  }) : super(key: key);

  final String title;
  final int idVisit;

  @override
  State<ViewVisitPage> createState() => _ViewVisitePageState();
}

class _ViewVisitePageState extends State<ViewVisitPage> {
  // ignore: prefer_typing_uninitialized_variables
  var visitor;
  // ignore: prefer_typing_uninitialized_variables
  var user;
  // ignore: prefer_typing_uninitialized_variables
  var visit;
  // ignore: prefer_typing_uninitialized_variables
  var pointToCheck;

  @override
  void initState() {
    super.initState();
    fetchVisit().then((_) {
      fetchVisitor();
      fetchUser();
    });
    fetchPTC();
  }

  Future<void> fetchVisit() async {
    try {
      final Map<String, dynamic>? jsonData = await AppGlobal.fetchDataMap(
          '${AppGlobal.UrlServer}Visit/GetVisitDemandeById?id=${widget.idVisit}');
      if (jsonData != null) {
        visit = jsonData;
        //print(visit);
      }
    } catch (error) {
      print('Error fetching visit: $error');
    }
  }

  Future<void> fetchPTC() async {
    try {
      final List? jsonData = await AppGlobal.fetchData(
          '${AppGlobal.UrlServer}Pointcheck/GetPointByIdVisit?id=${widget.idVisit}');
      if (jsonData != null) {
        pointToCheck = jsonData;
        //print(pointToCheck[0]['Id']);
      }
    } catch (error) {
      print('Error fetching ptc: $error');
    }
  }

  Future<void> fetchUser() async {
    try {
      final Map<String, dynamic>? jsonData = await AppGlobal.fetchDataMap(
          '${AppGlobal.UrlServer}User/GetUserByID?UserId=${visit['UserId']}');
      if (jsonData != null) {
        user = jsonData;
      }
    } catch (error) {
      print('Error fetching user: $error');
    }
  }

  Future<void> fetchVisitor() async {
    try {
      print('${AppGlobal.UrlServer}Visitor/GetVisitorByID?Id=${visit['VisitorId']}');
      final Map<String, dynamic>? jsonData = await AppGlobal.fetchDataMap(
          '${AppGlobal.UrlServer}Visitor/GetVisitorByID?Id=${visit['VisitorId']}');
      if (jsonData != null) {
        visitor = jsonData;
        print(visitor['Id']);
      }
    } catch (error) {
      print('Error fetching visitors: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
      widget,
      context,
    );
  }
}

Padding Visitor(context, id, name, surname, city, rate, cost, price, star) => Padding(
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

                      AppGlobal.etoile(star, 20, 50)
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
                    child: Text(price + "€",
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
              MaterialPageRoute(builder: (context) => ProfilePage(title: 'Profile', idUser: id)), 
            );
          },

        ),
      ),
    );
