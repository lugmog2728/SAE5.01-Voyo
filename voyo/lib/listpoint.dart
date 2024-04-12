import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'globals.dart' as AppGlobal;
import 'home.dart' as homePage;
import 'package:dio/dio.dart';

class PointsPage extends StatefulWidget {
  const PointsPage({Key? key, required this.title, required this.idVisit});

  final String title;
  final int idVisit;

  @override
  State<PointsPage> createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  var text = "";
  var listPoint = [];
  var listComment = [];
  var listExpanded = [];
  var listImage = [];

  @override
  void initState() {
    super.initState();
    GetPoints();
  }

  void GetPoints() async {
    try {

      var response = await Dio().get(
          '${AppGlobal.UrlServer}Pointcheck/GetPointByIdVisit?id=${widget.idVisit}');
      if (response.statusCode == 200) {
        setState(() {
          listPoint = json.decode(response.data) as List;
        });
        var _;
        for (_ in listPoint) {
          listExpanded.add(false);
          listImage.add("");
          listComment.add("");
        }
        setState(() {
          listExpanded;
          listImage;
          listComment;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void SetPoints() async {
    try {

      var Checks = "";
      for (var comment in listComment)
        if (comment == "")
          Checks = Checks + " ;";
        else
        Checks = Checks + comment + ";";
      Checks = Checks.substring(0, Checks.length - 1);
      var Pictures = "";
      for (var picture in listImage)
        if (picture == "")
          Pictures = Pictures + " ;";
        else
          Pictures = Pictures + picture + ";";
      Pictures = Pictures.substring(0, Pictures.length - 1);
      Dio().get(
          '${AppGlobal.UrlServer}Visit/FinishVisit?id=${widget.idVisit}');
      var response = await Dio().get(
          '${AppGlobal.UrlServer}Pointcheck/SetPointByIdVisit?id=${widget.idVisit}&pointChecks=$Checks&pictures=Pictures');
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => homePage.HomePage(title: 'Accueil' ),
          ),
        );
      } 
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      Column(
        children: [
          Text("Liste de points :"),
          for (var point = 0; point < listPoint.length; point++)
            GetPoint(listPoint[point]['Wording'], listPoint[point]['Comment'],
                listExpanded[point], point),
          ElevatedButton(
            onPressed: () {
              SetPoints();
            },
            child: Text("Valider"),
            style: AppGlobal.buttonStyle,
          )
        ],
      ),
      widget,
      context,
    );
  }

  Padding GetPoint(String Name, String Value, bool expanded, int index) {
    if (expanded) {
      return PointsExpanded(Name, Value, index);
    } else {
      return PointsRetracted(Name, Value, index);
    }
  }

  Padding PointsRetracted(String Name, String Value, int index) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppGlobal.inputColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        onPressed: () {
          listExpanded[index] = true;
          setState(() {
            listExpanded;
          });
        },
        child: Container(
            color: AppGlobal.inputColor,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(color: Colors.black, width: 2))),
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 5, bottom: 5, left: 3, right: 3),
                      child: Text(Name),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 3, right: 3),
                    child: Text(Value),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Padding PointsExpanded(String Name, String Value, int index) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppGlobal.inputColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            onPressed: () {
              listExpanded[index] = false;
              setState(() {
                listExpanded;
              });
            },
            child: Container(
                color: AppGlobal.inputColor,
                child: Row(
                  children: [
                    Text(Name),
                    Spacer(),
                    IconButton(
                        onPressed: () async {
                          final XFile? newImg = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (newImg != null) {
                            File file = File(newImg.path);
                            AppGlobal.sendImage(
                                    "${AppGlobal.UrlServer}message/upload?extension=png",
                                    file)
                                .then((String value) {
                              listImage[index] = value;
                              setState(() {
                                listImage;
                              });
                            });
                          }
                        },
                        icon: Icon(Icons.attach_file))
                  ],
                )),
          ),
          Container(
            decoration: BoxDecoration(
                color: AppGlobal.inputColor,
                border: Border(top: BorderSide(color: Colors.black, width: 1))),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(children: [
                TextFormField(
                  initialValue: Value,
                  decoration: InputDecoration(
                      hintText: "Commentaire", border: InputBorder.none),
                  onChanged: (String? value) {
                    listComment[index] = value!;
                    setState(() {
                      listComment;
                    });
                  },
                ),
                Image.network(
                    '${AppGlobal.UrlServer}/image/${listImage[index]}',
                    width: 200,
                    height: 180,
                    errorBuilder: (context, error, stackTrace) => Container()),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
