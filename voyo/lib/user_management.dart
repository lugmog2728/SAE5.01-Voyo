import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Rechercher un utilisateur"
                  )
                ),
                IconButton(
                  onPressed: () => null,
                  icon: const Icon(Icons.search))
              ],
            )
          ],
        ),
      ),
      widget,
      context,
    );
  }
}
