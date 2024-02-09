import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;

const List<String> list = <String>['PHILIPE DUPUIS', 'THOMAS THOMAS'];
String dropdownValue = list.first;


class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.title});

  final String title;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return AppGlobal.Menu(
      Container(
        color: AppGlobal.inputColor,
        height: 80,
        child : Row(
          children:[
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)),color: AppGlobal.subInputColor),
              child: Icon(Icons.person),
            ),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0,left: 8.0),
                  child : Padding(
                    padding: EdgeInsets.all(10.0),
                      child : Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: AppGlobal.subInputColor
                      ),
                      child:DropdownButton<String>(
                      isExpanded: true,
                      value: dropdownValue,
                    elevation: 0,
                      icon: Visibility (visible:false, child: Icon(Icons.arrow_downward)),
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(
                          child:Text(value,style: TextStyle(color: Colors.black),),
                        ),
                      );
                    }).toList(),
                  ),
                  ),
                  ),
                ),
            ),
            Icon(Icons.keyboard_arrow_down),

          ]
        ),
      ),
        widget,
        context);
  }
}
