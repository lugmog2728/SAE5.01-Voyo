import 'package:flutter/material.dart';
import 'globals.dart' as app_global;
import 'home.dart' as home;

class RdvClosePage extends StatefulWidget {
  const RdvClosePage({Key? key, required this.idVisit}) : super(key: key);

  final String title = "Clore la visite";
  final int idVisit;

  @override
  State<RdvClosePage> createState() => _RdvClosePageState();
}

class PointToCheck {
  String wording;
  String comment;
  bool isVisible;

  PointToCheck(this.wording, this.comment, this.isVisible);
}

class _RdvClosePageState extends State<RdvClosePage> {
  List<PointToCheck> points = [];// State for whether each point is open
  TextEditingController commentController = TextEditingController();
  int rating = 0; // State for the selected rating

  @override
  Widget build(BuildContext context) {
    return app_global.Menu(
      SingleChildScrollView(
        child: Column(
          children: [
            for (PointToCheck point in points) 
              buildPointRectangle(point, 0),
            // Bouton Télécharger en PDF
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Action lorsque le bouton Télécharger en PDF est pressé
                },
                style: app_global.buttonStyle,
                child: const Text('Télécharger en PDF'),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.only(left: 6),
              decoration: BoxDecoration(
                color: app_global.inputColor
              ),
                child: Row(
                  children: [
                    const Text(
                      "Note : ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    for (int i = 1; i <= 5; i++)
                      FilledButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: app_global.inputColor,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = i;
                          });
                        }, 
                        child: chooseEtoile(i)
                      )
                  ],
                ),
            ),
            // Rectangle pour les commentaires
            Container(
              color: app_global.inputColor,
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Commentaire:',
                    style: TextStyle(fontSize: 16),
                    ),
                  TextFormField(
                    controller: commentController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            // Bouton Valider
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => finishVisit(),
                style: app_global.buttonStyle,
                child: const Text('Valider'),
              ),
            ),
          ],
        ),
      ),
      widget,
      context,
    );
  }

  void finishVisit() {
    print("${app_global.UrlServer}Visit/SetComment?id=${widget.idVisit}&comment=${commentController.text}&rate=$rating");
    app_global.sendData("${app_global.UrlServer}Visit/SetComment?id=${widget.idVisit}&comment=${commentController.text}&rate=$rating").then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
            const home.HomePage(title: "Page d'accueil")
        ),
      );
    });
  }

  @override
  void initState() {
    print("");
    super.initState();
    print("${app_global.UrlServer}Pointcheck/GetPointByIdVisit?id=${widget.idVisit}");
    app_global.fetchData("${app_global.UrlServer}Pointcheck/GetPointByIdVisit?id=${widget.idVisit}").then((List<dynamic>? jsonData) {
      if (jsonData != null) {
        for (dynamic pointToCheck in jsonData) {
          points.add(PointToCheck(pointToCheck["Wording"], pointToCheck["Comment"], false));
        }
        setState(() {
          points;
        });
      }
    });
  }

  Image chooseEtoile(int index) {
    if (index <= rating) {
      return Image.asset('assets/images/etoilePleine.png');
    }else {
      return Image.asset('assets/images/etoileVide.png');
    }
  }

  Widget buildPointRectangle(PointToCheck point, int index) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              point.isVisible = !point.isVisible; // Invert the state
            });
          },
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(left:16, right: 16, bottom: 4, top: 4),
            color: app_global.inputColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(point.wording),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      point.isVisible = !point.isVisible; // Invert the state
                    });
                  },
                  icon: Icon(point.isVisible ? Icons.expand_less : Icons.expand_more),
                ),
              ],
            ),
          ),
        ),
        // Contenu du point
        if (point.isVisible) 
          Container(
            padding: const EdgeInsets.all(8.0),
            color: app_global.inputColor,
            child: Column(
              children: [
                Text(point.comment),
              ],
            ),
          )
      ],
    );
  }
}
