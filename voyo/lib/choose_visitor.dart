// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'pay.dart';
import 'globals.dart' as AppGlobal;
import 'package:intl/intl.dart';
import "availibility.dart";
import 'profile.dart';

// ignore: must_be_immutable
class VisitePage extends StatefulWidget {
  VisitePage({
    Key? key,
    required this.title,
    required this.idVisitor,
    required this.houseType,
  }) : super(key: key);

  final String title;
  final int idVisitor;
  String houseType;

  @override
  State<VisitePage> createState() => _VisitePageState();
}

class _VisitePageState extends State<VisitePage> {
  String? selectedHousingType;
  List<String> items = [];
  List<TextEditingController> pointToCheck = [TextEditingController()];
  TextEditingController villeController = TextEditingController();
  TextEditingController rueController = TextEditingController();
  TextEditingController CPController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String? visitorName ="";
  String? visitorSurname ="";
  String? visitorCity ="";
  String? visitorHoulyRate ="";
  String? visitorCost ="";
  String? visitorPrice = "";
  int? visitorRating = 0;

  bool isInvalid = false;

  @override
  void initState() {
    super.initState();
    selectedHousingType = widget.houseType;
    fetchVisitors(selectedHousingType!);
    AppGlobal.fetchData('${AppGlobal.UrlServer}House/GetTypeHouse')
        .then((List<dynamic>? jsonData) {
      if (jsonData != null) {
        List<String> stringArray = jsonData.cast<String>();
        setState(() {
          items = stringArray;
        });
      }
    }).catchError((error) {
      print('une erreur est survenue lors de la récupération des données : $error');
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> fetchVisitors(String selectedOption) async {
    try {
      final Map<String, dynamic>? jsonData = await AppGlobal.fetchDataMap(
          '${AppGlobal.UrlServer}Visitor/GetVisitorById?id=${widget.idVisitor}&typeHouse=$selectedHousingType');
      if (jsonData != null) {
        setState(() {
          visitorSurname = jsonData['User']['FirstName'];
          visitorName = jsonData['User']['Name'];
          visitorCity = jsonData['User']['City'];
          visitorHoulyRate = jsonData['HourlyRate'].toString();
          visitorCost = jsonData['Cost'].toString();
          visitorPrice = jsonData['Price'].toString();
          visitorRating = jsonData['Rating'];
        });
      }
    } catch (error) {
      print('Error fetching visitors: $error');
    }
  }
  
  Future<bool> SendDemandeVisit() async {
    if (villeController.text.isEmpty || rueController.text.isEmpty || CPController.text.isEmpty) {
      setState(() {
        isInvalid = true;
      });
      return false;
    }
    final hours = selectedTime.hour.toString().padLeft(2, '0');
    final minutes = selectedTime.minute.toString().padLeft(2, '0');
    String concatenatedPTC = '';
    for (int i = 0; i < pointToCheck.length; i++) {
      if (i > 0) {
        concatenatedPTC += ',';
      }
      concatenatedPTC += pointToCheck[i].text;
    }
    var url='${AppGlobal.UrlServer}visit/CreateDemande?housingType=$selectedHousingType&visitorId=${widget.idVisitor}&userId=${AppGlobal.idUser}&dateVisit=${DateFormat('yyyy-MM-dd').format(selectedDate)}%20${'$hours:$minutes:00.000'}&city=${villeController.text}&street=${rueController.text}&postalCode=${CPController.text}&points=${concatenatedPTC}';
    AppGlobal.sendData(url);
    setState(() {
      isInvalid = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PayPage(title: 'Pay')), // Provide the title parameter
    );
    return true;

  }

  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                    value: selectedHousingType,
                    decoration: InputDecoration(
                      hintText: 'Type de logement',
                      filled: true,
                      fillColor: AppGlobal.buttonback,
                    ),
                    dropdownColor: Colors.amber,
                    items: items.map((item) {
                      return DropdownMenuItem(value: item, child: Text(item));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedHousingType = newValue;
                        print(selectedHousingType);
                      });
                      fetchVisitors(newValue!);
                    },
                  ),
                ),
                if (isInvalid)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Veuiller compléter les champs adresses',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: villeController,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            hintText: "Ville",
                            filled: true,
                            fillColor: AppGlobal.buttonback,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: rueController,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            hintText: "Rue",
                            filled: true,
                            fillColor: AppGlobal.buttonback,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: CPController,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            hintText: "code postale",
                            filled: true,
                            fillColor: AppGlobal.buttonback,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppGlobal.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () => _selectDate(context),
                      child: Text(
                        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppGlobal.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () => _selectTime(context),
                      child: Text(
                        translateTime(selectedTime, "h"),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Visitor(context, widget.idVisitor, visitorName, visitorSurname, visitorCity, visitorHoulyRate, visitorCost, visitorPrice, visitorRating),
                for (TextEditingController point in pointToCheck)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            controller: point,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              hintText: "ex: WC séparé",
                              filled: true,
                              fillColor: AppGlobal.buttonback,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                pointToCheck.remove(point);
                              });
                            },
                          )
                        )
                      ],
                    )
                  ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: FloatingActionButton(
                          backgroundColor: AppGlobal.secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onPressed: () {
                            setState(() {
                              pointToCheck.add(TextEditingController());
                            });
                          },
                          child: const Text(
                            "+",
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: FloatingActionButton(
                            backgroundColor: AppGlobal.secondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: () {
                              SendDemandeVisit();


                            },
                            child: const Expanded(
                              child: Text(
                                "Valider et payer",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
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
