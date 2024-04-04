import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'globals.dart' as app_global;
import 'statuschange.dart' as status_change;
import 'availibility.dart';

//####__CONSTANTS__####\\

Image placeholder = Image.asset("assets/images/placeholder.webp", width: 140, height: 180,);
TextStyle sectionStyle = const TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

//####__PROFIL_PAGE__#####\\

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title, required this.idUser});

  final String title;
  final int idUser;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  //####__SUPPORTS_VAR__####\\
  XFile? imagePick;
  ///Image height depending on edit
  double heightLabel = 180;
  ///Index of the comment displayed
  int selectedComments = 0;
  bool isEdit = false;
  ///Defined if the update is feasible
  bool isError = false;
  ///List of index for availibities not valid (isEdit = true)
  List<int> availibilitiesError = [];

  //####__DATA_VAR__####\\

  bool isVisitor = false;
  ///Defined if the visitor has been validated by an administrator
  bool isValid = true;
  bool isActive = true;
  int idVisitor = -1; 
  String statut = "";
  String name = "";
  String firstName = "";
  String city = "";
  String hourlyRate = "";
  String imageUrl = "";
  int rating = 0;
  String street = "";
  String zipCode = "";
  String phone = "";
  String rib = "";
  List<Availibility> availibilities = [];
  List<Comment> comments = [];

  //####__CONTROLLERS__####\\

  TextEditingController nameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController hourlyRateController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ribController = TextEditingController();
  List<Availibility> availibilitiesController = [];

  //####__WIDGET__####\\

  Widget nameWidget = Container();
  Widget firstNameWidget = Container();
  Widget cityWidget = Container();
  Widget hourlyRateWidget = Container();
  Widget streetWidget = Container();
  Widget zipCodeWidget = Container();
  Widget phoneWidget = Container();
  Widget ribWidget = Container();
  ///Yellow underline for information label
  Border borderInformation = const Border ();
  AppBar editAppBar = AppBar(toolbarHeight: 0.0);

  //#####__BUILD_OF_THE_PAGE__####\\

  @override
  Widget build(BuildContext context) {
    if (isVisitor) {statut = "Visiteur";
    } else {statut = "Utilisateur";}

    if (isEdit) {editMode();
    } else {viewingMode();}

    Widget image = placeholder;
    if (imageUrl != "") {
      image = Image.network('${app_global.UrlServer}/image/$imageUrl', width: 140,height: 180, errorBuilder: (context, error, stackTrace) => placeholder);
    }

    return app_global.Menu(
      Scaffold(
        appBar: editAppBar,
        body: SingleChildScrollView(
          controller: ScrollController(),
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: !isValid,
                child: const Center(
                  child: 
                    Text(
                    "Ce compte n'a pas encore était validé par un administrateur.",
                    style: TextStyle(
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: app_global.idUser == 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Désactiver le compte :",
                      style: TextStyle(fontSize: 16),
                      ),
                    Switch(
                      value: !isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = !isActive;
                        });
                      }
                    ),
                  ],
                ) 
              ),
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
                  Container (
                    padding: const EdgeInsets.all(16.0),
                    width: 130,
                    child: Visibility(
                      visible: widget.idUser == app_global.idUser,
                      child: Center(
                        child: IconButton(
                          onPressed: () => editprofile(),
                          style: app_global.buttonStyle,
                          icon: const Icon(Icons.edit_sharp),
                          ),
                        ),
                      ),
                    ),
                  
                  ],
                ),
              ),
              Row(children: [ 
                Stack(
                  children: [
                    Padding (
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: image,
                    ),
                    Visibility(
                      visible: widget.idUser == app_global.idUser,
                      child: Positioned(
                        left: 10,
                        bottom: 10,
                        child: IconButton(
                          onPressed: () async { final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                            imagePick = image;
                          }, 
                          style: app_global.buttonStyle,
                          icon: const Icon(Icons.photo_size_select_actual_outlined)
                        ),
                      )
                    ),
                  ],
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
                            status_change.ChangementStatutPage(title: "Changement de statut", idUser: widget.idUser,)
                        ),
                      );
                    },
                    style: app_global.buttonStyle,
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
                      Text (
                        'Horaires',
                        style: sectionStyle
                      ),
                      if (isEdit) for (var i = 0; i < availibilitiesController.length; i++) hourlyInput(availibilitiesController[i], i)
                      else for (var i = 0; i < availibilities.length; i++) hourlyLabel(availibilities[i]),
                      Visibility(
                        visible: isEdit && availibilitiesController.length < maxAvailibility,
                        child: Center(
                          child: ElevatedButton (
                            onPressed: () => addAvailibility(),
                            style: app_global.buttonStyle,
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
                visible: isVisitor && widget.idUser == app_global.idUser,
                child: Container (
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 16, left: 16),
                  child: Column (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text (
                        'Données privées',
                        style: sectionStyle
                      ),
                      Row (
                        children: [
                          Visibility(
                            visible: !isEdit,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelPrivateData("Adresse :"),
                                labelPrivateData("Code Postal : "),
                                labelPrivateData("Téléphone : "),
                                labelPrivateData("RIB : ")
                              ]
                            ),
                          ),
                          Column(
                            children: [
                              profileInformation(streetWidget),
                              profileInformation(zipCodeWidget), 
                              profileInformation(phoneWidget), 
                              profileInformation(ribWidget)
                            ]
                          )
                        ],
                      )
                    ]
                  ),
                )
              ),

              Visibility(
                visible: isVisitor && !isEdit && comments.isNotEmpty,
                child: Container (
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(16),
                  child: Column (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text (
                        'Commentaires',
                        style: sectionStyle
                      ),
                      if (comments.isNotEmpty) commentWidget(comments[selectedComments]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () => updateComment(-1), 
                            style: app_global.buttonStyle,
                            child: const Icon(Icons.keyboard_arrow_left)
                          ),
                          Text(
                            '${selectedComments+1} sur ${comments.length}',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ElevatedButton(
                            onPressed: () => updateComment(1), 
                            style: app_global.buttonStyle,
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

  //####__LOADING DATA__#####\\

  @override
  void initState() {
    super.initState();
    app_global.fetchDataMap("${app_global.UrlServer}User/GetUserByID?id=${widget.idUser}").then((Map<String, dynamic>? jsonData) {
      if (jsonData != null) {
        if (jsonData["User"] == null) {
        }
          isVisitor = jsonData["User"] != null;
          switch (jsonData["State"]) {
            case "Attente": isValid = false;
              break;
            case "Refuser": isVisitor = false;
          }
          if (isVisitor) {
            setState(() {
              isActive = jsonData["User"]["IsActive"];
              idVisitor = jsonData["Id"];
              name = jsonData["User"]["Name"];
              firstName = jsonData["User"]["FirstName"];
              city = jsonData["User"]["City"];
              hourlyRate = jsonData["HourlyRate"].toString();
              imageUrl = jsonData["User"]["ProfilPicture"];
              rating = jsonData["Rating"];
              street = jsonData["Street"];
              zipCode = jsonData["PostalCode"].toString();
              if (zipCode.length < 5) {
                zipCode = "0$zipCode";
              }
              phone = jsonData["User"]["PhoneNumber"];
              rib = jsonData["RIB"].toString();
              //rib = "**** **** ${rib.substring(rib.length-5)}";
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
            });

          }else {
            setState(() {
              isActive = jsonData["IsActive"];
              name = jsonData["Name"];
              firstName = jsonData["FirstName"];
              city = jsonData["City"];
              imageUrl = jsonData["ProfilPicture"];
            });
          }
      }
      }).catchError((error) {
        isVisitor = false;
    });
  } 

  //####__DISPLAY_MODE__####\\

  ///Change the display in the viewing mode
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
    streetWidget = editProfileText(street);
    zipCodeWidget = editProfileText(zipCode);
    phoneWidget = editProfileText(phone);
    ribWidget = editProfileText(rib);
    editAppBar = AppBar(toolbarHeight: 0.0);
    availibilitiesError.clear();
  }
  ///Change the display in the edit mode
  void editMode() {
    heightLabel = 300;
    borderInformation = const Border();
    nameController.text = name;
    firstNameController.text = firstName;
    cityController.text = city;
    hourlyRateController.text = hourlyRate;
    streetController.text = street;
    zipCodeController.text = zipCode;
    phoneController.text = phone;

    nameWidget = inputProfileEdit(nameController, "Prénom", TextInputType.text, null);
    firstNameWidget = inputProfileEdit(firstNameController, "Nom", TextInputType.text, null);
    cityWidget = inputProfileEdit(cityController, "Ville", TextInputType.text, null);
    hourlyRateWidget = inputProfileEdit(hourlyRateController, "Tarif Horaire", TextInputType.number, 5);
    streetWidget = inputProfileEdit(streetController, "Adresse", TextInputType.text, null);
    zipCodeWidget = inputProfileEdit(zipCodeController, "Code Postal", TextInputType.number, 5);
    phoneWidget = inputProfileEdit(phoneController, "Téléphone", TextInputType.phone, 10);
    ribWidget = inputProfileEdit(ribController, "RIB", TextInputType.text, 34);

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
                style: app_global.buttonStyle,
                child: const Icon(Icons.task_outlined)
              ),
              ElevatedButton(
                onPressed: () => cancelUpdate(),
                style: app_global.buttonStyle,
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

  //####__UPDATE_DATA_FONCTION___####\\

  ///Change the mode to diplay
  void editprofile() {
    setState(() {
      isEdit = !isEdit;
    });
  }
  ///Cancel the edit mode
  void cancelUpdate() {
    setState(() {
      isError = false;
    });
    initAvailibilitiesController();
    editprofile();
  }
  ///Check is data's valid and, if good, updates the user in API and in display
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
        print("${app_global.UrlServer}Visitor/ModifyVisitor?id=$idVisitor&street=${streetController.text}&hourlyRate=${hourlyRateController.text}&phoneNumber=${phoneController.text}&PostalCode=${zipCodeController.text}");
        app_global.sendData("${app_global.UrlServer}Visitor/ModifyVisitor?id=$idVisitor&street=${streetController.text}&hourlyRate=${hourlyRateController.text}&phoneNumber=${phoneController.text}&PostalCode=${zipCodeController.text}").then((value) {
          setState(() {
            hourlyRate = hourlyRateController.text;
            street = streetController.text;
            zipCode = zipCodeController.text;
            phone = phoneController.text;
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
        editprofile();
      }
    }
  }

  //####__INFORMATION_LABEL_MANAGEMENT####\\

  ///Create a container for a information label. Is a Text or TextFormField according to the edit mode
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
  ///Create a information label (String Data) for the viewing mode
  Text editProfileText(String value) {
    return Text(
      value, 
      style: const TextStyle (
        fontSize: 15,
        color: Colors.black,
      ),
    );
  }
  ///Create a input information (String Data) for the edit mode
  TextFormField inputProfileEdit(TextEditingController textController, String label, TextInputType keyboardType, int? maxLength) {
    return TextFormField(
      controller: textController,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
      )
    );
  }

  Text labelPrivateData(String label) {
    return Text(
      label, 
      style: const TextStyle(
        fontSize: 16,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  //####__AVAILIBILITY_MANAGEMENT__####\\

  ///Copy the availibilities data in the availibilitiesController
  void initAvailibilitiesController() {
    availibilitiesController = [];
    for (Availibility availibility in availibilities) {
      availibilitiesController.add(availibility.copy());
    }
  }
  ///Add a empty availibility in the availibilitiesController
  void addAvailibility() {
    setState(() {
      availibilitiesController.add(Availibility("lundi", 0, 0, 0, 0));
    });
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

  //####__COMMENT_MANAGEMENT__####\\

  ///Create a widget comment with a Comment Object
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
  ///Change the selected comment (1 or -1). Overflows are resolved.
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
  
  //####//
}

///Object comments
class Comment {
  String uti;
  String img;
  int rating;
  String txt;
  String date;
  
  Comment(this.uti, this.img, this.rating, this.txt, this.date);
}