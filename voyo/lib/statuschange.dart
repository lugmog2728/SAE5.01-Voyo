import 'package:flutter/material.dart';
import 'globals.dart' as app_global;
import 'profile.dart' as profile;
import 'availibility.dart';

class ChangementStatutPage extends StatefulWidget {
  const ChangementStatutPage({Key? key, required this.title, required this.idUser}) : super(key: key);

  final String title;
  final int idUser;

  @override
  State<ChangementStatutPage> createState() => _ChangementStatutPageState();
}

class _ChangementStatutPageState extends State<ChangementStatutPage> {
  

  List<Availibility> availibilitiesController = [Availibility("lundi", 0, 0, 0, 0)];
  ///List of index for availibities not valid (isEdit = true)
  List<int> availibilitiesError = [];
  bool isError = false;

  final TextEditingController streetController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ribController = TextEditingController();
  final TextEditingController rateController = TextEditingController();

  void _confirmer() {
    setState(() {
      availibilitiesError = checkAvailibilities(availibilitiesController);
      isError = (availibilitiesError.isNotEmpty);
      availibilitiesController;
    });
    if (!isError) {
      print("${app_global.UrlServer}Visitor/CreateVisitor?id=${widget.idUser}&street=${streetController.text}&hourlyRate=${rateController.text}&postalCode=${zipCodeController.text}&RIB=${ribController.text}&phoneNumber=${phoneController.text}");
      app_global.sendData("${app_global.UrlServer}Visitor/CreateVisitor?id=${widget.idUser}&street=${streetController.text}&hourlyRate=${rateController.text}&postalCode=${zipCodeController.text}&RIB=${ribController.text}&phoneNumber=${phoneController.text}").then((value) {
         returnInProfil();
      });
    }
  }

  void returnInProfil() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
          profile.ProfilePage(title: "profil", idUser: widget.idUser)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return app_global.Menu(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Informations',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: streetController,
                    decoration: const InputDecoration(
                      labelText: "Adresse",
                    ),
                  ),
                  TextFormField(
                    controller: zipCodeController,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    decoration: const InputDecoration(
                      labelText: "Code Postal",
                    ),
                  ),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      labelText: "Numéro de téléphone",
                    ),
                  ),
                  TextFormField(
                    controller: ribController,
                    maxLength: 34,
                    decoration: const InputDecoration(
                      labelText: "RIB/iBAN",
                    ),
                  ),
                  TextFormField(
                    controller: rateController,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    decoration: const InputDecoration(
                      labelText: "Tarif horaire",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Horaires',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                      textAlign: TextAlign.center,
                    ),
                    for (var i = 0; i < availibilitiesController.length; i++) hourlyInput(availibilitiesController[i], i),
                    Visibility(
                        visible: availibilitiesController.length < maxAvailibility,
                        child: Center(
                          child: ElevatedButton (
                            onPressed: () => addAvailibility(),
                            style: app_global.buttonStyle,
                            child: const Icon(Icons.add),
                          )
                        )
                      ),
                    Center(
                      child: Text(
                        '${availibilitiesController.length} sur $maxAvailibility',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _confirmer,
                style: app_global.buttonStyle,
                child: const Text('Confirmer'),
              ),
              ElevatedButton(
                onPressed: returnInProfil,
                style: app_global.buttonStyle,
                child: const Text('Annuler'),
              ),
            ],
          ),
        ),
      ),
      widget,
      context,
    );
  }

  ///Create a container allow to modifiy a availibility in edit mode
  Container hourlyInput(Availibility availibility, int index) {
    BoxDecoration errorBorder = const BoxDecoration();
    if (availibilitiesError.contains(index)) {
      errorBorder = BoxDecoration(border:Border.all(color: Colors.red));
    }
    return Container(
      decoration: errorBorder,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DropdownButton<String>(
            value: availibility.day,
            focusColor: app_global.secondaryColor,
            items: daysMap.keys.toList().map((d) {
              return DropdownMenuItem(
                value: d,
                child: Text(d),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                availibility.day = value!;
              });
            }
          ),
          timeButton(availibility, false),
          timeButton(availibility, true),
          IconButton(
            onPressed: () {
              setState(() {
                availibilitiesController.removeAt(index);
              });
            }, 
            style: app_global.buttonStyle,
            icon: const Icon(Icons.delete)
            )
        ],
      ),
    );
  }
  ///Create a TimePicker button for a modifiy a availibility
  ElevatedButton timeButton(Availibility availibility, bool isTimeEnd) {
    return ElevatedButton(
      onPressed: () => timePickerFunction(availibility, isTimeEnd),
      style: app_global.buttonStyle,
      child: Text(translateTime(availibility.getTime(isTimeEnd), "h"))
    );
  }

  void timePickerFunction(Availibility availibility, bool isTimeEnd) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: availibility.getTime(isTimeEnd),
      helpText: "Choissiez une heure",
      hourLabelText: "Heure",
      minuteLabelText: "Minute",
      cancelText: "Annuler",
      errorInvalidText: "Heure invalide",
    );
    setState(() {
      if (time != null) {
        if (isTimeEnd) {
          availibility.endTime = TimeOfDay(hour: time.hour, minute: time.minute);
          availibility.endMinute = translateStringHour(time.hour)*60 + time.minute;

        } else {
          availibility.startTime = TimeOfDay(hour: time.hour, minute: time.minute);
          availibility.startMinute = translateStringHour(time.hour)*60 + time.minute;
        }
      }
    });
  }


  ///Add a empty availibility in the availibilitiesController
  void addAvailibility() {
    setState(() {
      availibilitiesController.add(Availibility("lundi", 0, 0, 0, 0));
    });
  }
}