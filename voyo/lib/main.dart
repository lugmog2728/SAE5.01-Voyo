import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;
import 'connexion.dart' as connexionPage;
import 'Statuschange.dart' as statChange;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voyo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: AppGlobal.backgroundColor),
      home: const statChange.ChangementStatutPage(title: 'status'),
    );
  }
}
