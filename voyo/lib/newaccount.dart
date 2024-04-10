import 'dart:convert';
import 'package:flutter/material.dart';
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
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _profilPictureController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String baseUrl = '${AppGlobal.UrlServer}User/AddUser';
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      String firstName = _firstNameController.text;
      String city = _cityController.text;
      String phoneNumber = _phoneNumberController.text;
      String profilPicture = _profilPictureController.text;

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
        } else {
          print(
              'La requête pour vérifier l\'email a échoué avec le code d\'état: ${response
                  .statusCode}');
          // Gérer l'erreur en conséquence
        }
      } catch (e) {
        print('Erreur lors de la requête pour vérifier l\'email: $e');
        // Gérer l'erreur en conséquence
      }

      String requestUrl =
          '$baseUrl?name=$name&email=$email&password=$password&firstName=$firstName&city=$city&phoneNumber=$phoneNumber&profilPicture=$profilPicture';

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
        } else {
          print(
              'La requête pour créer l\'utilisateur a échoué avec le code d\'état: ${response
                  .statusCode}');
          // Gérer l'erreur en conséquence
        }
      } catch (e) {
        print('Erreur lors de la requête pour créer l\'utilisateur: $e');
        // Gérer l'erreur en conséquence
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
            key: _formKey,
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
                          onSaved: (String? value) {
                            debugPrint('Value for Nom saved as $value');
                          },
                          controller: _nameController,
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
                          onSaved: (String? value) {
                            debugPrint('Value for Prénom saved as $value');
                          },
                          controller: _firstNameController,
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
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez sélectionner votre date de naissance';
                          }
                          return null;
                        },
                        onSaved: (String? value) {
                          debugPrint(
                              'Value for Date de naissance saved as $value');
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
                          onSaved: (String? value) {
                            debugPrint('Value for Ville saved as $value');
                          },
                          controller: _cityController,
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
                            hintText: "Code postal",
                            filled: true,
                            fillColor: AppGlobal.buttonback,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre code postal';
                            }
                            return null;
                          },
                          onSaved: (String? value) {
                            debugPrint('Value for Code postal saved as $value');
                          },
                          controller: _phoneNumberController,
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
                      hintText: "Adresse postal",
                      filled: true,
                      fillColor: AppGlobal.buttonback,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre adresse postale';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      debugPrint('Value for Adresse postal saved as $value');
                    },
                    controller: _cityController,
                  ),
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
                    onSaved: (String? value) {
                      debugPrint('Value for Adresse mail saved as $value');
                    },
                    controller: _emailController,
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
                    onSaved: (String? value) {
                      debugPrint('Value for Mot de passe saved as $value');
                    },
                    controller: _passwordController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Photo",
                            filled: true,
                            fillColor: AppGlobal.buttonback,
                          ),
                          onSaved: (String? value) {
                            debugPrint('Value for Photo saved as $value');
                          },
                          controller: _profilPictureController,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                          onPrimary: Colors.white,
                        ),
                        onPressed: _submitForm,
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
                      primary: Colors.yellow,
                      onPrimary: Colors.white,
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
