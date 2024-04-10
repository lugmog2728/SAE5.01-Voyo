import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'globals.dart' as AppGlobal;
import 'listVisitor.dart' as listVisitor;
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
  var listExpanded = [];
  var listImage = [];

  @override
  void initState() {
    super.initState();
    GetPoints();
  }

  void GetPoints() async {
    try {
      var listExpandedTemp = [];
      var listImageTemp = [];
      var response = await Dio().get(
          '${AppGlobal.UrlServer}Pointcheck/GetPointByIdVisit?id=${widget.idVisit}');
      if (response.statusCode == 200) {
        setState(() {
          listPoint = json.decode(response.data) as List;
        });
        for (var point in listPoint) {
          listExpandedTemp.add(false);
          listImageTemp.add("");
        }
        setState(() {
          listExpanded = listExpandedTemp;
          listImage = listImageTemp;
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  void SetPoints() async {
    try {
      var listExpandedTemp = [];
      var listImageTemp = [];
      var response = await Dio().get(
          '${AppGlobal.UrlServer}Pointcheck/GetPointByIdVisit?id=${widget.idVisit}');
      if (response.statusCode == 200) {
        setState(() {
          listPoint = json.decode(response.data) as List;
        });
        for (var point in listPoint) {
          listExpandedTemp.add(false);
          listImageTemp.add("");
        }
        setState(() {
          listExpanded = listExpandedTemp;
          listImage = listImageTemp;
        });
      } else {
        print(response.statusCode);
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
                    Spacer(), // use Spacer
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
                  initialValue: "",
                  decoration: InputDecoration(
                      hintText: "Commentaire", border: InputBorder.none),
                  onSaved: (String? value) {
                    Value = value!;
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
