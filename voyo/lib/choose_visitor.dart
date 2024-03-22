import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;

class VisitePage extends StatefulWidget {
  const VisitePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<VisitePage> createState() => _VisitePageState();
}

class _VisitePageState extends State<VisitePage> {
  String? _selectedOption;
  List<String> items = [];
  final List<String> pointToCheck = ["toto", "tete"];
  List<Widget> extraFields = [];

  @override
  void initState() {
    super.initState();
    AppGlobal.fetchData('http://172.26.240.10:1080/House/GetTypeHouse').then((List<dynamic>? jsonData) {
      if (jsonData != null) {
        List<String> stringArray = jsonData.cast<String>();
        setState(() {
          items = stringArray;
        });
      }
    }).catchError((error) {
      print('Une erreur est survenue lors de la récupération des données : $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      SingleChildScrollView(
        child: Column(
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
                    child: DropdownButtonFormField(
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
                          _selectedOption = newValue;
                        });
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
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
                  Visitor("thomas", "thomas", "lyon", "13", "26"),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: extraFields.length + 1,
                    itemBuilder: (context, index) {
                      if (index < extraFields.length) {
                        return Row(
                          children: [
                            Expanded(child: extraFields[index]),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  extraFields.removeAt(index);
                                });
                              },
                            ),
                          ],
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              hintText: "ex: WC séparé",
                              filled: true,
                              fillColor: AppGlobal.buttonback,
                            ),
                          ),
                        );
                      }
                    },
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
                              bool allFieldsFilled = true;
                              extraFields.forEach((field) {
                                if (field is TextFormField) {
                                  if (field.controller!.text.isEmpty) {
                                    allFieldsFilled = false;
                                  }
                                }
                              });
                              if (allFieldsFilled) {
                                setState(() {
                                  extraFields.add(
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        textAlign: TextAlign.left,
                                        decoration: InputDecoration(
                                          hintText: "ex: WC séparé",
                                          filled: true,
                                          fillColor: AppGlobal.buttonback,
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              }
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
                            onPressed: null,
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
            ),
          ],
        ),
      ),
      widget,
      context,
    );
  }
}

Padding Visitor(name,surname,city,rate,cost) {
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
                    style: TextStyle(color: Colors.black,),
                  )
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    Text(name,style: const TextStyle(color: Colors.black,),),
                    Text(surname,style: const TextStyle(color: Colors.black,),),
                    Text(city,style: const TextStyle(color: Colors.black,),),
                    Text(rate+"€/h",style: const TextStyle(color: Colors.black,),),
                    Image.asset('assets/images/etoile.png', width: 100,)
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
                      cost+"€",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black,)
                  ),
                ),
              ),
            ),
          ],
        ),
        onPressed: () {},
      ),
    ),
  );
}