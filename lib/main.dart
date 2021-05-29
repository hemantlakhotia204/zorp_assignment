import 'package:flutter/material.dart';
import 'package:zorp_assignment/pages/loading.dart';
import 'package:zorp_assignment/pages/map.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      //declared routes for screens
      routes: {
        '/': (context) => Loading(),
        '/map': (context) => Map(),
      } ,
    );
  }

}


