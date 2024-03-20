import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'globals.dart' as AppGlobal;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
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

class _ProfilePageState extends State<ProfilePage> {

  double heightLabel = 180;

  Border borderInformation = const Border ();

  String name = "Thomas";
  String firstName = "Thomas";
  String city = "Saint-Poutier-Sur-Rhône";
  String hourlyRate = "50";

  TextEditingController nameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController hourlyRateController = TextEditingController();

  Widget nameWidget = Container();
  Widget firstNameWidget = Container();
  Widget cityWidget = Container();
  Widget hourlyRateWidget = Container();

  AppBar editAppBar = AppBar(
    toolbarHeight: 0.0,
  );

  viewingMode() {
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
    
    editAppBar = AppBar(
      toolbarHeight: 0.0,
    );
  }

  editprofile() {
    setState(() {
      isEdit = !isEdit;
    });
  }

  editMode() {
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
            onPressed: () => editprofile(),
            style: buttonStyle,
            child: const Icon(Icons.cancel_outlined)
          )
        ]
      )
    );
  }

  updateData() {
    name = nameController.text;
    firstName = firstNameController.text;
    city = cityController.text;
    hourlyRate = hourlyRateController.text;
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
                Container (
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  width: 140,
                  height: 180,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/images/profilePicture.jpg'))
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
                  child: AppGlobal.etoile(2, 20.0, 50.0)
                ),
              ), 

              Visibility(
                visible: isVisitor,
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: 150,
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
                      hourlyLabel("Lundi", "16h", "18h"),
                      hourlyLabel("Mardi", "14h", "16h"),
                      hourlyLabel("Vendredi", "12h", "18h"),
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
                      comment('Utilisateur aléatoire', 'assets/images/profilePicture.jpg', '12/10/2023', 'Voici un commentaire des plus petinenant sur un ivisteur très charismatique', 4, context),
                      comment('Utilisateur aléatoire', 'assets/images/profilePicture.jpg', '02/02/2024', 'NUL à chier mais 2 étoiles parce que j''ai pas race',2 ,context),
                    ],
                  ),
                )
              ),
            ]
          ),
        ),
      ), widget, context
    );
  }

  Container profileInformation(informationWidget) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 150,
      decoration: BoxDecoration (
        border: borderInformation,
      ),
      child: informationWidget,
    );
  }

  Text editProfileText(value) {
    return Text(value, 
      style: const TextStyle (
        fontSize: 15,
        color: Colors.black,
      ),
    );
  }

  TextFormField inputProfileEdit(textController, label) {
    return TextFormField(
      controller: textController,
      decoration: InputDecoration(
        labelText: label,
      )
    );
  }

  Text hourlyLabel(day, startTime, endTime) {
    return Text (
      '$day: $startTime à $endTime',
      style: const TextStyle(
        fontSize: 16,
        fontStyle: FontStyle.italic
      ),
    );
  }

  Container comment(uti, img, date, txt, nbEt, context) {
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
                    image: AssetImage(img),
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
                      uti,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      )
                    ),

                    AppGlobal.etoile(nbEt,10.0,15.0)
                  ],
                )
              ),
              Expanded(
                child: Container (
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.all(5),
                  child: Text (
                    date,
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
              txt,
            ),
          ),
        ],
      ),
    );
  }
}

