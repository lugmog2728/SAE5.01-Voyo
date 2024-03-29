
import 'package:flutter/material.dart';
import 'globals.dart' as app_global;
import 'Statuschange.dart' as status_change;
import 'availibility.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title, required this.idUser});

  final String title;
  final int idUser;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
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
  backgroundColor: app_global.primaryColor,
  foregroundColor: Colors.black
);
/*Fin*/

bool isVisitor = false;
String statut = "";
bool isEdit = false;
bool isError = false;
int maxAvailibility = 10;

Image placeholder = Image.asset("assets/images/placeholder.webp", width: 140, height: 180,);

class _ProfilePageState extends State<ProfilePage> {
  double heightLabel = 180;

  Border borderInformation = const Border ();

  int idVisitor = -1; 
  String name = "";
  String firstName = "";
  String city = "";
  String hourlyRate = "";
  String imageUrl = "imageProfil.png";
  int rating = 0;
  List<Availibility> availibilities = [];
  List<Comment> comments = [];
  int selectedComments = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController hourlyRateController = TextEditingController();
  List<Availibility> availibilitiesController = [];
  List<int> availibilitiesError = [];

  Widget nameWidget = Container();
  Widget firstNameWidget = Container();
  Widget cityWidget = Container();
  Widget hourlyRateWidget = Container();

  AppBar editAppBar = AppBar(toolbarHeight: 0.0);

  @override
  void initState() {
    super.initState();
    app_global.fetchDataMap("${app_global.UrlServer}User/GetUserByID?id=${widget.idUser}").then((Map<String, dynamic>? jsonData) {
      if (jsonData != null) {
        if (jsonData["User"] == null) {
        }
          isVisitor = jsonData["User"] != null;
          if (isVisitor) {

            setState(() {
              idVisitor = jsonData["Id"];
              name = jsonData["User"]["Name"];
              firstName = jsonData["User"]["FirstName"];
              city = jsonData["User"]["City"];
              hourlyRate = jsonData["HourlyRate"].toString();
              rating = jsonData["Rating"];
            });

            app_global.fetchData("${app_global.UrlServer}Availibility/GetAvailibiltyByVisitor?id=${jsonData["Id"]}").then((List<dynamic>? jsonDataAv) {
              if (jsonDataAv != null) {
                for (dynamic availibility in jsonDataAv) {
                  List<String> lstStart = availibility["Start"].toString().split(":");
                  List<String> lstEnd = availibility["End"].toString().split(":");
                  Availibility av = Availibility(availibility["day"], int.parse(lstStart[0]), int.parse(lstStart[1]), int.parse(lstEnd[0]), int.parse(lstEnd[1]));

                  availibilities.add(av);
                }
                setState(() {
                  availibilities = shortAvailibilities(availibilities);
                });
                initAvailibilitiesController();
              }
              }).catchError((error) {
                print('\nUne erreur est survenue lors de la récupération des données : $error');
            });
            app_global.fetchData("${app_global.UrlServer}Visit/GetComment?idvisitor=${jsonData["Id"]}").then((List<dynamic>? jsonDataCom) {
              if (jsonDataCom != null) {
                for (dynamic com in jsonDataCom) {
                  List<String> dateSplit = com["DateVisit"].toString().split("T")[0].split("-");
                  Comment comment = Comment(com["NameUser"], "imageProfil.png", com["Rating"], com["Content"], "${dateSplit[2]}/${dateSplit[1]}/${dateSplit[0]}");
                  comments.add(comment);
                }
                setState(() {
                  comments;
                });
              }
            }).catchError((error) {
              print('\nUne erreur est survenue lors de la récupération des données : $error');
            });

          }else {
            setState(() {
              name = jsonData["Name"];
              firstName = jsonData["FirstName"];
              city = jsonData["City"];
            });
          }
      }
      }).catchError((error) {
        isVisitor = false;
        print('\nUne erreur est survenue lors de la récupération des données : $error');
    });
  }
  
  void initAvailibilitiesController() {
    availibilitiesController = [];
    for (Availibility availibility in availibilities) {
      availibilitiesController.add(availibility.copy());
    }
  }

  void viewingMode() {
    heightLabel = 180;

    borderInformation = Border (
      bottom: BorderSide (
        color: app_global.secondaryColor,
        width: 3,
      )
    );

    nameWidget = editProfileText(name);
    firstNameWidget = editProfileText(firstName);
    cityWidget = editProfileText(city);
    hourlyRateWidget = editProfileText("$hourlyRate€");

    editAppBar = AppBar(toolbarHeight: 0.0);
    availibilitiesError.clear();
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
      backgroundColor: app_global.backgroundColor,
      shadowColor: Colors.black,
      shape: Border(
        bottom: BorderSide(
          color: app_global.secondaryColor,
          width: 1.0,
        ),
      ),
      toolbarHeight: 80,
      title: Column (
        children: [Row(
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
              ),
            ]
          ),
          Visibility (
            visible: isError,
            child: const Text(
              "Erreur ! Des horaires sont invalide. La mise à jour ne peut s'effectuer",
              style: TextStyle(
                color: Colors.red,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ),
          ),
          ],
        )
    );
  }

  void cancelUpdate() {
    setState(() {
      isError = false;
    });
    initAvailibilitiesController();
    editprofile();
  }

  void updateData() {
    
    setState(() {
      availibilitiesError = checkAvailibilities(availibilitiesController);
      isError = (availibilitiesError.isNotEmpty);
      availibilitiesController;
    });
    if (!isError) {
      app_global.sendData("${app_global.UrlServer}User/ModifyUser?id=${widget.idUser}&name=${nameController.text}&firstName=${firstNameController.text}&city=${cityController.text}").then((value) {
        setState(() {
          name = nameController.text;
          firstName = firstNameController.text;
          city = cityController.text;
        });
      });
      if (isVisitor) {
        app_global.sendData("${app_global.UrlServer}Visitor/ModifyVisitor?id=$idVisitor&hourlyRate=${hourlyRateController.text}").then((value) {
          setState(() {
            hourlyRate = hourlyRateController.text;
          });
        });
        app_global.sendData("${app_global.UrlServer}Availibility/DeleteAvailibilty?id=$idVisitor").then((value) {
          availibilities.clear();
          for (Availibility availibility in availibilitiesController) {
            String start = translateTime(availibility.startTime, ":");
            String end = translateTime(availibility.endTime, ":");

            app_global.sendData("${app_global.UrlServer}Availibility/SetAvailibilty?id=$idVisitor&day=${availibility.day}&start=$start&end=$end").then((value) {
              if (!value) {
                setState(() {
                  availibilities.remove(availibility);
                });
                initAvailibilitiesController();
              }
            });
            availibilities.add(availibility);
          }
          setState(() {
            availibilities = shortAvailibilities(availibilities);
          });
          initAvailibilitiesController();
        });

        /*int index = 0;
        for (Availibility availibility in availibilitiesController) {
          if (index < availibilities.length) {
            availibilities[index].updateAvailibility(availibilitiesController[index]);
          } else {
            availibilities.add(availibility);
          }
          index++;
        }
        while (index < availibilities.length) {
          availibilities.removeAt(index);
        }*/
        editprofile();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isVisitor) {statut = "Visiteur";
    } else {statut = "Utilisateur";}

    if (isEdit) {editMode();
    } else {viewingMode();}


    return app_global.Menu(
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
                  child: Image.network('${app_global.UrlServer}/image/$imageUrl', 
                    width: 140,
                    height: 180, 
                    errorBuilder: (context, error, stackTrace) => placeholder,
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
                      Visibility(
                        visible: isVisitor,
                        child: profileInformation(hourlyRateWidget),
                        )
                    ]),
                  ),
                ]
              ),

              Visibility(
                visible: !isVisitor,
                child: Center (
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const status_change.ChangementStatutPage(title: "Changement de statut")),
                      );
                    },
                    style: buttonStyle,
                    child: const Text("Devenir visiteur"),
                  ),
                ),
              ),

              Visibility (
                visible: isVisitor && !isEdit,
                child: Container (
                  alignment: Alignment.centerLeft,
                  width: 150,
                  padding: const EdgeInsets.only(left: 16),
                  child: app_global.etoile(rating, 20.0, 50.0)
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
                      if (isEdit) for (var i = 0; i < availibilitiesController.length; i++) hourlyInput(availibilitiesController[i], i)
                      else for (var i = 0; i < availibilities.length; i++) hourlyLabel(availibilities[i]),
                      Visibility(
                        visible: isEdit && availibilitiesController.length < maxAvailibility,
                        child: Center(
                          child: ElevatedButton (
                            onPressed: () => addAvailibility(),
                            style: buttonStyle,
                            child: const Icon(Icons.add),
                          )
                        )
                      ),
                      Visibility(
                        visible: isEdit,
                        child: Center(
                          child: Text(
                            '${availibilitiesController.length} sur $maxAvailibility',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                            ),
                        )
                      ),
                    ],
                  ),
                ),
              ),

              Visibility(
                visible: isVisitor && !isEdit && comments.isNotEmpty,
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
                      if (comments.isNotEmpty) commentWidget(comments[selectedComments]),
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

  void addAvailibility() {
    setState(() {
      availibilitiesController.add(Availibility("lundi", 0, 0, 0, 0));
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
      '${availibility.day} : ${translateTime(availibility.startTime, "h")} à ${translateTime(availibility.endTime, "h")}',
      style: const TextStyle(
        fontSize: 16,
        fontStyle: FontStyle.italic
      ),
    );
  }

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
            style: buttonStyle,
            child: const Icon(Icons.delete)
            )
        ],
      ),
    );
  }

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
      style: buttonStyle,
      child: Text(translateTime(availibility.getTime(isTimeEnd), "h"))
    );
  }

  Container commentWidget(Comment comment) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 10),
      color: app_global.primaryColor,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.black),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network('${app_global.UrlServer}/image/${comment.img}', 
                    errorBuilder: (context, error, stackTrace) => placeholder,
                  ),
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

                    app_global.etoile(comment.rating,10.0,15.0)
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
          Container (
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(right:5, left: 20, top:3, bottom: 5),
            child: Text(comment.txt,),
          ),
        ],
      ),
    );
  }
}

