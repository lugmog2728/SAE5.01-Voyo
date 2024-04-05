import 'package:flutter/material.dart';
import 'globals.dart' as app_global;
import 'profile.dart' as profile;

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  TextEditingController nameController = TextEditingController();
  List<User> userList = [];

  @override
  Widget build(BuildContext context) {
    return app_global.Menu(
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Rechercher un utilisateur"
                      )
                    ),
                  ),
                  IconButton(
                    onPressed: () => loadUser(),
                    style: app_global.buttonStyle,
                    icon: const Icon(Icons.search))
                ],
              ),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (User user in userList)
                userView(user)
              ],
            )
            
          ],
        ),
      ),
      widget,
      context,
    );
  }

  void loadUser() {
    if (nameController.text == "") {
      return; 
    }
    app_global.fetchData("${app_global.UrlServer}User/GetUsersByName?name=${nameController.text}").then((List<dynamic>? jsonData) {
      if (jsonData != null) {
        userList.clear();
        for (dynamic userData in jsonData) {
          setState(() {
            userList.add(User(userData["Id"], userData["Name"], userData["FirstName"], userData["City"], userData["ProfilPicture"]));
          });
        }
      }
    });
  }

  ElevatedButton userView(User user) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => (profile.ProfilePage(title: "profil", idUser: user.id))
          )
        );
      }, 
      style: ElevatedButton.styleFrom(
        backgroundColor: app_global.inputColor,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.all(5),
        fixedSize: const Size(200, 100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container (
            margin: const EdgeInsets.only(left: 5, right: 10),
            width: 60,
            height: 100,
            child: user.image,
          ),
          Expanded(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name),
              Text(user.firstName),
              Text(user.city),
            ],
          ),
            )
          
        ]
      ),
    );
  }
}

class User {
  int id; 
  String name;
  String firstName;
  String city;
  late Widget image;

  User(this.id, this.name, this.firstName, this.city, String imageUrl) {
    Image placeholder = Image.asset("assets/images/placeholder.webp", width: 140, height: 180,);

    image = Image.network('${app_global.UrlServer}/image/$imageUrl', 
      errorBuilder: (context, error, stackTrace) => placeholder,
    );
  }
}