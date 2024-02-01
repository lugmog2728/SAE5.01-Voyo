import 'package:flutter/material.dart';
import 'globals.dart' as AppColors;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
          scaffoldBackgroundColor: AppColors.backgroundColor
      ),

      home: const MyHomePage(title: 'Page  acceuil'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Menu(
        const Center(
          child: Text("content"),
          )
    ,widget);
  }
}
BoxDecoration TitleDecoration() {
  return BoxDecoration(
    border: Border(
      bottom: BorderSide(width: 4,color: AppColors.secondaryColor),
    ),
  );
}
Scaffold Menu(content, widget){
  return Scaffold(
    appBar: AppBar(
      backgroundColor: AppColors.backgroundColor,
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
                backgroundColor: AppColors.secondaryColor,
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
            color: AppColors.secondaryColor,
          ),
          padding: const EdgeInsets.only( bottom: 8),
          child : Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(bottomLeft:Radius.circular(50),bottomRight:Radius.circular(50),
              ),
              color: AppColors.backgroundColor,
            ),
            child:FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
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
                backgroundColor: AppColors.secondaryColor,
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
