library my_prj.globals;

import 'dart:ui';

import 'package:flutter/material.dart';

Color primaryColor =  const Color(0xFFFE881C);
Color secondaryColor = const Color(0xFFFEC534);
Color backgroundColor = const Color(0xFFFCFAD3);
Color inputColor = const Color(0xFFFEE486);
Color buttonback = const Color(0xFFFFFEE8);

BoxDecoration TitleDecoration() {
  return BoxDecoration(
    border: Border(
      bottom: BorderSide(width: 4,color: secondaryColor),
    ),
  );
}

Scaffold Menu(content, widget){
  return Scaffold(
    appBar: AppBar(
      backgroundColor: backgroundColor,
      title:
      Container(
        decoration: TitleDecoration(),
        height: 45,
        child: Stack(
          children: [
            Align(child: Text(widget.title)),
            Positioned(left: 0,width: 100,height: 50, child: Image.asset('assets/images/Logo Voyo.png'),),
          ],
        ),
      ),
    ),
    body: content,
    bottomNavigationBar: Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          flex: 1,
          child:SizedBox(
            height: 80,
            child : Expanded(
              child : FloatingActionButton(
                backgroundColor: secondaryColor,
                onPressed: null,
                tooltip: 'Increment',
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30),
                  ),
                ),
                elevation: 0,
                child: const Icon(Icons.message),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only( topLeft: Radius.circular(50),topRight: Radius.circular(50),
            ),
            color: secondaryColor,
          ),
          padding: const EdgeInsets.only( bottom: 8),
          child : Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(bottomLeft:Radius.circular(50),bottomRight:Radius.circular(50),
              ),
              color: backgroundColor,
            ),
            child:FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: null,
              tooltip: 'Increment',
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50),
                ),
              ),
              elevation: 0,
              child: const SizedBox( width: 100, child : Icon(Icons.home),),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child:SizedBox(
            height: 80,
            child : Expanded(
              child : FloatingActionButton(
                backgroundColor: secondaryColor,
                onPressed: null,
                tooltip: 'Increment',
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                  ),
                ),
                elevation: 0,
                child: const Icon(Icons.people),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
