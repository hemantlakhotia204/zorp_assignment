import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zorp_assignment/objects/task.dart';
import 'package:zorp_assignment/services/apiHelper.dart';
import 'package:zorp_assignment/services/taskHelper.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

//Loading Screen
class _LoadingState extends State<Loading> {

  List<Task> data;

  // Trigger Api calling during runtime
  void getTasks() async {
    try {
      // TaskHelper instance = TaskHelper(); // Instance of Tasks class
      // data = await instance.getTasks(await APIHelper().fetchTaskJson()); // waiting for data
      // print(data);
      data = [
        Task(
          "1",
          2,
          Coordinate(
              37.4242,
              -122.1221
          ),
          'Hemant',
          'W.B.'
        )
      ];
      Timer(Duration(seconds: 3), () => {
        Navigator.pushReplacementNamed(context, '/map', arguments: data) // Passing data and moving to Map Screen with a timer.
      });
    } catch(e) {
     print('Error: $e');
    }
  }


  @override
  void initState() {
    getTasks(); // running getTasks function during initiation of LoadingState
    super.initState();
  }


  //Loading screen widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitPulse(
          size: 50.0,
          color: Colors.blue[300],
        ),
      ),
    );
  }
}