import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'globals.dart' as AppGlobal;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class Availibility {
  late String day;
  late TimeOfDay startTime;
  late TimeOfDay endTime;

  Availibility(this.day, int hStart, int mStart, int hEnd, int mEnd) {
    startTime = TimeOfDay(hour: hStart, minute: mStart);
    endTime = TimeOfDay(hour: hEnd, minute: mEnd);
  }
  
  TimeOfDay getTime(bool isTimeEnd) {
    if (isTimeEnd) {
      return endTime;
    }
    return startTime;
  }

  void updateAvailibility(Availibility availibility) {
    day = availibility.day;
    startTime = availibility.startTime;
    endTime = availibility.endTime;
  }

  bool compare(Availibility availibility) {
    if (daysMap[day] == daysMap[availibility.day]) {
      return startTime.hour < availibility.startTime.hour;
    }
    return daysMap[day]! < daysMap[availibility.day]!;
  }

  Availibility copy() {
    return Availibility(day, startTime.hour, startTime.minute, endTime.hour, endTime.minute);
  }
}

class Comment {
  String uti;
  String img;
  int rating;
  String txt;
  String date;
  
  Comment(this.uti, this.img, this.rating, this.txt, this.date);
}

/*Réutilisation de Widget*/
ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: AppGlobal.primaryColor,
  foregroundColor: Colors.black
);
/*Fin*/

bool isVisitor = true;
String statut = "";
bool isEdit = false;

/*List<String> days = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];*/
Map<String, int> daysMap = {"Lundi":1, "Mardi":2, "Mercredi":3, "Jeudi":4,"Vendredi":5, "Samedi":6, "Dimanche":7};
Image placeholder = Image.asset("assets/images/profilePicture.jpg", width: 140, height: 180,);

class _ProfilePageState extends State<ProfilePage> {

  double heightLabel = 180;

  Border borderInformation = const Border ();

  String name = "Thomas";
  String firstName = "Thomas";
  String city = "Saint-Poutier-Sur-Rhône";
  String hourlyRate = "50";
  String imageUrl = "imageProfil.png";
  int rating = 2;
  List<Availibility> availibilities = [Availibility("Lundi", 16, 0, 18, 0), Availibility("Vendredi", 14, 0, 16, 0), Availibility("Mardi", 9, 20, 15, 0)];
  List<Comment> comments = [Comment('Utilisateur aléatoire', 'assets/images/profilePicture.jpg', 4, 'Voici un commentaire des plus pertinenant sur un visiteur très charismatique', '12/10/2023'),
    Comment('Utilisateur aléatoire', 'assets/images/profilePicture.jpg', 2, 'NUL à chier mais 2 étoiles parce que j''ai pas race', '02/02/2024')];
  int selectedComments = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController hourlyRateController = TextEditingController();
  List<Availibility> availibilitiesController = [];

  Widget nameWidget = Container();
  Widget firstNameWidget = Container();
  Widget cityWidget = Container();
  Widget hourlyRateWidget = Container();

  AppBar editAppBar = AppBar(toolbarHeight: 0.0);

  @override
  void initState() {
    super.initState();
    shortAvailibilities();
    initAvailibilitiesController();
  }

  void initAvailibilitiesController() {
    availibilitiesController = [];
    for (Availibility availibility in availibilities) {
      availibilitiesController.add(availibility.copy());
    }
  }

  void shortAvailibilities() {
    List<Availibility> shortAvailibilities = [];
    for (Availibility old in availibilities) {
      int i = 0;
      bool find = false;
      
      while (!find && i != shortAvailibilities.length) {
        find = old.compare(shortAvailibilities[i]);
        if (!find) {
          i++;
        }
      }
      shortAvailibilities.insert(i, old);
    } 
    availibilities = shortAvailibilities;
  }

  void viewingMode() {
    heightLabel = 180;

    borderInformation = Border (
      bottom: BorderSide (
        color: AppGlobal.secondaryColor,
        width: 3,
      )
    );

    nameWidget = editProfileText(name);
    firstNameWidget = editProfileText(firstName);
    cityWidget = editProfileText(city);
    hourlyRateWidget = editProfileText("$hourlyRate€");

    editAppBar = AppBar(toolbarHeight: 0.0);
  }

  void editprofile() {
    setState(() {
      isEdit = !isEdit;
    });
  }

  void editMode() {
    heightLabel = 300;
    borderInformation = const Border();

    nameController.text = name;
    firstNameController.text = firstName;
    cityController.text = city;
    hourlyRateController.text = hourlyRate;

    nameWidget = inputProfileEdit(nameController, "Prénom");
    firstNameWidget = inputProfileEdit(firstNameController, "Nom");
    cityWidget = inputProfileEdit(cityController, "Ville");
    
    hourlyRateWidget = TextFormField(
      controller: hourlyRateController,
      decoration: const InputDecoration(
        labelText: "Tarif Horaire",
      ),
      keyboardType: TextInputType.number,
      maxLength: 5,
    );

    editAppBar = AppBar(
      backgroundColor: AppGlobal.backgroundColor,
      shadowColor: Colors.black,
      shape: Border(
        bottom: BorderSide(
          color: AppGlobal.secondaryColor,
          width: 2.0,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () => updateData(),
            style: buttonStyle,
            child: const Icon(Icons.task_outlined)
          ),
          ElevatedButton(
            onPressed: () => cancelUpdate(),
            style: buttonStyle,
            child: const Icon(Icons.cancel_outlined)
          )
        ]
      )
    );
  }

  void cancelUpdate() {
    for (int i = 0; i < availibilities.length; i++) {
      availibilitiesController[i].updateAvailibility(availibilities[i]);
    }
    editprofile();
  }

  void updateData() {
    name = nameController.text;
    firstName = firstNameController.text;
    city = cityController.text;
    hourlyRate = hourlyRateController.text;
    for (int i = 0; i < availibilities.length; i++) {
      availibilities[i].updateAvailibility(availibilitiesController[i]);
    }
    shortAvailibilities();
    initAvailibilitiesController();
    editprofile();
  }

  @override
  Widget build(BuildContext context) {
    if (isVisitor) {statut = "Visiteur";
    } else {statut = "Utilisateur";}

    if (isEdit) {editMode();
    } else {viewingMode();}


    return AppGlobal.Menu(
      Scaffold(
        appBar: editAppBar,
        body: SingleChildScrollView(
          controller: ScrollController(),
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: !isEdit,
                child: Row (
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding (
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Statut : $statut",
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: ElevatedButton(
                        style: buttonStyle,
                        child: const Icon(Icons.edit_sharp),
                        onPressed: () => editprofile(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(children: [ 
                Padding (
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Image.network('${AppGlobal.UrlServer}/image/$imageUrl', 
                    width: 140,
                    height: 180, 
                    errorBuilder: (context, error, stackTrace) => placeholder,
                    loadingBuilder: (context, child, loadingProgress) => placeholder,
                    ),
                ),

                Container (
                  alignment: Alignment.center,
                  height: heightLabel,
                  child : Column (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      profileInformation(nameWidget),
                      profileInformation(firstNameWidget),
                      profileInformation(cityWidget),
                      profileInformation(hourlyRateWidget),
                    ]),
                  ),
                ]
              ),


              Visibility (
                visible: isVisitor && !isEdit,
                child: Container (
                  alignment: Alignment.centerLeft,
                  width: 150,
                  padding: const EdgeInsets.only(left: 16),
                  child: AppGlobal.etoile(rating, 20.0, 50.0)
                ),
              ), 

              Visibility(
                visible: isVisitor,
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 16),
                  child: Column ( 
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text (
                        'Horaires',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      for (var i = 0; i < availibilities.length; i++) 
                        if (isEdit) hourlyInput(availibilitiesController[i]) 
                        else hourlyLabel(availibilities[i])
                    ],
                  ),
                ),
              ),

              Visibility(
                visible: isVisitor && !isEdit,
                child: Container (
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(16),
                  child: Column (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text (
                        'Commentaire',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      commentWidget(comments[selectedComments]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () => updateComment(-1), 
                            style: buttonStyle,
                            child: const Icon(Icons.keyboard_arrow_left)
                          ),
                          Text(
                            '${selectedComments+1} sur ${comments.length}',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ElevatedButton(
                            onPressed: () => updateComment(1), 
                            style: buttonStyle,
                            child: const Icon(Icons.keyboard_arrow_right)
                          )
                        ],
                      )
                    ]
                  ),
                )
              ),
            ]
          ),
        ),
      ), widget, context
    );
  }

  void updateComment(int add) {
    setState(() {
      selectedComments += add;
      if (selectedComments < 0) {
        selectedComments = comments.length - 1;
      }
      else if (selectedComments >= comments.length) {
        selectedComments = 0;
      }
    });
  }

  Container profileInformation(Widget informationWidget) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 150,
      decoration: BoxDecoration (
        border: borderInformation,
      ),
      child: informationWidget,
    );
  }

  Text editProfileText(String value) {
    return Text(
      value, 
      style: const TextStyle (
        fontSize: 15,
        color: Colors.black,
      ),
    );
  }

  TextFormField inputProfileEdit(TextEditingController textController, String label) {
    return TextFormField(
      controller: textController,
      decoration: InputDecoration(
        labelText: label,
      )
    );
  }

  Text hourlyLabel(Availibility availibility) {
    return Text (
      '${availibility.day} : ${translateTime(availibility.startTime)} à ${translateTime(availibility.endTime)}',
      style: const TextStyle(
        fontSize: 16,
        fontStyle: FontStyle.italic
      ),
    );
  }

  Row hourlyInput(Availibility availibility) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DropdownButton<String>(
          value: availibility.day,
          focusColor: AppGlobal.secondaryColor,
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
      ],
    );
  }

  ElevatedButton timeButton(Availibility availibility, bool isTimeEnd) {
    return ElevatedButton(
      onPressed: () async { final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: availibility.getTime(isTimeEnd),
        initialEntryMode: TimePickerEntryMode.input,
        helpText: "Choissiez une heure",
        hourLabelText: "Heure",
        minuteLabelText: "Minute",
        cancelText: "Annuler",
        errorInvalidText: "Heure invalide",
        );
        setState(() {
          if (time != null) {
            if (isTimeEnd) {
              availibility.endTime = time;
            } else {
              availibility.startTime = time;
            }
          }
        });
      }, 
      style: buttonStyle,
      child: Text(translateTime(availibility.getTime(isTimeEnd)))
    );
  }

  String translateTime(TimeOfDay time) {
    int h = time.hourOfPeriod;
    int m = time.minute;
    if (time.period == DayPeriod.pm) {h = (12 + h) % 24;}
    String hSTR = h.toString();
    String mSTR = m.toString();
    if (h<10) {hSTR = "0$h";}
    if (m<10) {mSTR = "0$mSTR";}
    return "${hSTR}h$mSTR";
  }

  Container commentWidget(Comment comment) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 10),
      color: AppGlobal.primaryColor,
      child: Column (
        children: [
          Row (
            children: [
              Container (
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top:2, left: 10),
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(comment.img),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: const Border(
                    bottom: BorderSide(color: Colors.black),
                    top: BorderSide(color: Colors.black),
                    right: BorderSide(color: Colors.black),
                    left: BorderSide(color: Colors.black),
                  )
                ),
              ),

              Padding (
                padding: const EdgeInsets.only(right:16, left: 16, top:3),
                child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text (
                      comment.uti,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      )
                    ),

                    AppGlobal.etoile(comment.rating,10.0,15.0)
                  ],
                )
              ),
              Expanded(
                child: Container (
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.all(5),
                  child: Text (
                    comment.date,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 10,
                    ),
                  )
                )
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right:5, left: 5, top:3),
            child: Text(
              comment.txt,
            ),
          ),
        ],
      ),
    );
  }
}

