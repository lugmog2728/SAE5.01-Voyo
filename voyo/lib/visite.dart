
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'globals.dart' as AppGlobal;

class VisitePage extends StatefulWidget {
  const VisitePage({super.key, required this.title});

  final String title;

  @override
  State<VisitePage> createState() => _VisitePageState();
}

class _VisitePageState extends State<VisitePage> {
  String? _selectedOption = "";

  var items = ['T1', "T2", "Villa"];

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
                    Padding(padding: const EdgeInsets.all(8.0),
                      child:DropdownButtonFormField(
                        decoration: InputDecoration(
                          hintText: 'Type de logement',
                          filled: true,
                          fillColor: AppGlobal.buttonback,
                        ),
                        dropdownColor: Colors.amber,
                        items: items.map((items){
                          return DropdownMenuItem(value : items, child: Text(items));
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedOption = newValue;
                          });
                        }
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0), // ajustez le padding selon vos besoins
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
                            padding: const EdgeInsets.all(8.0), // ajustez le padding selon vos besoins
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
                            padding: const EdgeInsets.all(8.0), // ajustez le padding selon vos besoins
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
                    Row(children: [
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
                                    "Voir profil",
                                    style: TextStyle(color: Colors.black),
                                  ))),
                        ),
                      ),
                    ]),

                    const Padding(padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Point à vérifier:',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
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
                    ),

                    Center(
                      child:
                        Padding(
                          padding: const EdgeInsets.only(top: 8,bottom: 8),
                          child:FloatingActionButton(
                            backgroundColor: AppGlobal.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: null,
                            child:
                            const Expanded(
                              child : Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.black
                                ),
                              )
                            )
                          ),
                        ),
                      ),

                    Row(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8,right: 8),
                          child:FloatingActionButton(
                              backgroundColor: AppGlobal.secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: null,
                              child: const Expanded( child : Text("Valider et payer",style: TextStyle(color: Colors.black),))
                          ),
                        ),
                      ),
                    ]),
                  ]),
              ),
            ],
          ),
        ),
        widget,
    context);
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