import 'package:flutter/material.dart';
import 'globals.dart' as AppGlobal;
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.title, required this.id});

  final String title;
  final int id;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var userIdOther = 0;
  var listMessengers = [];
  var messenger = "";
  var listMessage = [];
  var listMessengersString = [""];
  var message = TextEditingController();
  ScrollController _scrollController = ScrollController();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    getMessengers();
    getMessages();
    getMessages();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getMessages());
  }

  void getMessengers() async {
    try {
      var response = await Dio()
          .get('${AppGlobal.UrlServer}Message/GetMessagers?id=${widget.id}');
      if (response.statusCode == 200) {
        setState(() {
          listMessengers = json.decode(response.data) as List;
          messenger = listMessengers.first['Value'];
          userIdOther = listMessengers.first['Key'];
          listMessengersString.removeAt(0);
          for (var messenger in listMessengers)
            listMessengersString.add(messenger['Value']);
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  void SendMessage() async {
    try {
      debugPrint(
          '${AppGlobal.UrlServer}message/SendMessage?message=${message.text}&dateCreate=${DateTime.now().toString().substring(0, 19)}&useridsend=${widget.id}&useridrecieve=${userIdOther}');

      var response = await Dio().get(
          '${AppGlobal.UrlServer}message/SendMessage?message=${message.text}&dateCreate=${DateTime.now().toString().substring(0, 19)}&useridsend=${widget.id}&useridrecieve=${userIdOther}');
      if (response.statusCode == 200) {
        print("success");
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  void getMessages() async {
    try {
      var response = await Dio().get(
          '${AppGlobal.UrlServer}Message/RecieveMessage?useridsend=${widget.id}&useridrecieve=${userIdOther}');
      if (response.statusCode == 200) {
        setState(() {
          print(
              'Message/RecieveMessage?useridsend=${widget.id}&useridrecieve=${userIdOther}');
          if (listMessage.length < (json.decode(response.data) as List).length){
            listMessage = json.decode(response.data) as List;
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }

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
        Column(children: [
          Container(
            color: AppGlobal.inputColor,
            height: 80,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      color: AppGlobal.subInputColor),
                  child: const Icon(Icons.person),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(canvasColor: AppGlobal.subInputColor),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: messenger,
                          elevation: 0,
                          icon: const Visibility(
                              visible: false,
                              child: Icon(Icons.arrow_downward)),
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 0,
                          ),
                          onChanged: (String? value) {
                            for (var messenger in listMessengers)
                              if (messenger['Value'] == value)
                                userIdOther = messenger['Key'];
                            getMessages();
                            // This is called when the user selects an item.
                            setState(() {
                              messenger = value!;
                            });
                          },
                          items: listMessengersString
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Center(
                                child: Text(
                                  value,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ]),
            ),
          ),
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(children: [
                  for (var message in listMessage)
                    if (message['UserIdRecieve'] == widget.id)
                      messageIn(message['Body'])
                    else
                      messageOut(message['Body'])
                ])),
          ),
          Positioned(
              height: 80,
              child: Container(
                  color: AppGlobal.inputColor,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, bottom: 4, top: 4),
                    child: Row(children: [
                      /*ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppGlobal.subInputColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          fixedSize: const Size(100, 50),
                        ),
                        onPressed: null,
                        child: const Icon(
                          Icons.add,
                          size: 40,
                        ),
                      ),*/
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 4, top: 4),
                          child: Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppGlobal.subInputColor,
                                  borderRadius: BorderRadius.circular(50.0)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 12, bottom: 2),
                                child: Row(children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: message,
                                      decoration: const InputDecoration(
                                        hintText: "Message",
                                        border: InputBorder.none,
                                      ),
                                      onSaved: (String? value) {
                                        debugPrint('Value for field saved as ');
                                      },
                                    ),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppGlobal.subInputColor,
                                      ),
                                      onPressed: () {
                                        if (message.text != "") {
                                          SendMessage();
                                          getMessages();
                                          message.text = "";
                                        }
                                      },
                                      child: const Icon(Icons.send)),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ))),
        ]),
        widget,
        context);
  }
}

Padding messageIn(message) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(children: [
      Expanded(
        flex: 1,
        child: Container(),
      ),
      Expanded(
        flex: 9,
        child: Container(
          decoration: BoxDecoration(
              color: AppGlobal.inputColor,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(message),
          ),
        ),
      ),
    ]),
  );
}

Padding messageOut(message) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(children: [
      Expanded(
        flex: 9,
        child: Container(
          decoration: BoxDecoration(
              color: AppGlobal.inputColor,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(message),
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: Container(),
      ),
    ]),
  );
}
