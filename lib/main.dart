import 'package:flutter/material.dart';
import 'package:zorp_assignment/pages/loading.dart';
import 'package:zorp_assignment/pages/map.dart';
import 'package:sizer/sizer.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp(
        initialRoute: '/',
        //declared routes for screens
        routes: {
          '/': (context) => Loading(),
          '/map': (context) => Map(),
        } ,
      )
    );
  }

}


