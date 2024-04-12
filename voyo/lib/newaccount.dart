import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'globals.dart' as AppGlobal;
import 'package:http/http.dart' as http;
import 'home.dart' as homePage;

class NewAccountPage extends StatefulWidget {
  const NewAccountPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<NewAccountPage> createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
  DateTime? _selectedDate;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String imageUrl = "";
  Widget imageWidget = const Text("Photo");
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      String baseUrl = '${AppGlobal.UrlServer}User/AddUser';
      String name = nameController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String firstName = firstNameController.text;
      String city = cityController.text;
      String phoneNumber = phoneNumberController.text;

      String getUsersUrl = '${AppGlobal.UrlServer}User/GetUsersByName';
      try {
        final response = await http.get(Uri.parse(getUsersUrl));
        if (response.statusCode == 200) {
          List<dynamic> users = jsonDecode(response.body);
          bool emailExists = users.any((user) => user['Email'] == email);
          if (emailExists) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Erreur'),
                  content: Text('Un utilisateur avec cet email existe déjà.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
            return;
          }
        }
      } catch (e) {
        print('$e');
      }

      String requestUrl =
          '$baseUrl?name=$name&email=$email&password=$password&firstName=$firstName&city=$city&phoneNumber=$phoneNumber&profilPicture=$imageUrl';

      try {
        final response = await http.get(Uri.parse(requestUrl));
        if (response.statusCode == 200) {
          AppGlobal.idUser = jsonDecode(response.body);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    homePage.HomePage(title: 'Accueil')
            ),
          );
        }
      } catch (e) {
        print('$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppGlobal.MenuConnexion(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Nom",
                            filled: true,
                            fillColor: AppGlobal.buttonback,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre nom';
                            }
                            return null;
                          },
                          controller: nameController,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Prénom",
                            filled: true,
                            fillColor: AppGlobal.buttonback,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre prénom';
                            }
                            return null;
                          },
                          controller: firstNameController,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "Date de naissance",
                          filled: true,
                          fillColor: AppGlobal.buttonback,
                          border: InputBorder.none,
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez sélectionner votre date de naissance';
                          }
                          return null;
                        },
                        controller: TextEditingController(
                            text: _selectedDate != null ? _selectedDate!
                                .toString().substring(0, 10) : ''),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Ville",
                            filled: true,
                            fillColor: AppGlobal.buttonback,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre ville';
                            }
                            return null;
                          },
                          controller: cityController,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Adresse mail",
                      filled: true,
                      fillColor: AppGlobal.buttonback,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre adresse mail';
                      }
                      return null;
                    },
                    controller: emailController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Mot de passe",
                      filled: true,
                      fillColor: AppGlobal.buttonback,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      }
                      return null;
                    },
                    controller: passwordController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container (
                        decoration: BoxDecoration (
                          color: AppGlobal.subInputColor
                        ),
                        margin: const EdgeInsets.all(16),
                        width: 100,
                        height: 100,
                        child: Center (child: imageWidget)
                      ),
                      ElevatedButton(
                        style: AppGlobal.buttonStyle,
                        onPressed: () async { final XFile? newImg = await ImagePicker().pickImage(source: ImageSource.gallery);
                            if (newImg != null) {
                              File file = File(newImg.path);
                              AppGlobal.sendImage("${AppGlobal.UrlServer}message/upload?extension=png", file).then((String value) {
                                imageUrl = value;
                                setState(() {
                                  imageWidget = Image.network('${AppGlobal.UrlServer}/image/$imageUrl', width: 140,height: 180, 
                                    errorBuilder: (context, error, stackTrace) => const Text("Photo"));
                                });
                              });
                            }
                          }, 
                        child: const Text(
                          'Parcourir',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _submitForm,
                    child: const Text(
                      'Valider',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      widget,
      context,
    );
  }
}
