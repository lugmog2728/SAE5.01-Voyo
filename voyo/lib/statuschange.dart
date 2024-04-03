import 'package:flutter/material.dart';
import 'globals.dart' as app_global;
import 'availibility.dart';

class ChangementStatutPage extends StatefulWidget {
  const ChangementStatutPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ChangementStatutPage> createState() => _ChangementStatutPageState();
}

class _ChangementStatutPageState extends State<ChangementStatutPage> {
  

  List<Availibility> availibilitiesController = [Availibility("lundi", 0, 0, 0, 0)];
  ///List of index for availibities not valid (isEdit = true)
  List<int> availibilitiesError = [];
  bool isError = false;

  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController ribController = TextEditingController();
  final TextEditingController tarifController = TextEditingController();

  void _confirmer() {
    setState(() {
      availibilitiesError = checkAvailibilities(availibilitiesController);
      isError = (availibilitiesError.isNotEmpty);
      availibilitiesController;
    });
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: telephoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Numéro de téléphone",
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: ribController,
                      maxLength: 27,
                      decoration: const InputDecoration(
                        labelText: "RIB/iBAN",
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: tarifController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Tarif horaire",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Horaires',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    for (var i = 0; i < availibilitiesController.length; i++) hourlyInput(availibilitiesController[i], i),
                    const SizedBox(height: 20.0),
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
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _confirmer,
                style: app_global.buttonStyle,
                child: const Text('Confirmer'),
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
          timeButton(context, availibility, false),
          timeButton(context, availibility, true),
          ElevatedButton(
            onPressed: () {
              setState(() {
                availibilitiesController.removeAt(index);
              });
            }, 
            style: app_global.buttonStyle,
            child: const Icon(Icons.delete)
            )
        ],
      ),
    );
  }
  ///Create a TimePicker button for a modifiy a availibility
  ElevatedButton timeButton(BuildContext context, Availibility availibility, bool isTimeEnd) {
    return ElevatedButton(
      onPressed: () async { final TimeOfDay? time = await showTimePicker(
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
      }, 
      style: app_global.buttonStyle,
      child: Text(translateTime(availibility.getTime(isTimeEnd), "h"))
    );
  }

  ///Add a empty availibility in the availibilitiesController
  void addAvailibility() {
    setState(() {
      availibilitiesController.add(Availibility("lundi", 0, 0, 0, 0));
    });
  }
}