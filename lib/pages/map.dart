import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zorp_assignment/objects/task.dart';
import 'package:location/location.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  List<Task> data;
  LatLng target;
  Location _location = new Location();
  GoogleMapController _controller;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  @override
  void initState() {
    _checkLocationPermission();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    // if(data == null) {
    //   _location.onLocationChanged().listen((l) {
    //     _controller.animateCamera(
    //       CameraUpdate.newCameraPosition(
    //         CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
    //       ),
    //     );
    //   });
    // }
  } // customize map type, animation, etc.

  void _checkLocationPermission() async {
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        SystemNavigator.pop();
        return;
      }
    }
  } //check Location Permission and location enable

  Set<Marker> _createMarker() {
    Set<Marker> markers = Set<Marker>();

    for (int i = 0; i < data.length; i++) {
      markers.add(Marker(
          onTap: () => _handleTap(i, markers),
          markerId: MarkerId(data[i].taskId),
          position:
              LatLng(data[i].coordinate.latitude, data[i].coordinate.longitude),
          infoWindow: InfoWindow(title: data[i].seq.toString())));
    }
    return markers;
  } //create marker for each task

  void _handleTap(int i, markers) {
    //show details of the marker tapped
    Future<void> future = showModalBottomSheet<void>(
        barrierColor: Colors.transparent,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black45,
                      spreadRadius: 5.0,
                      blurRadius: 20.0)
                ],
                color: Colors.white),
            height: 200,
            child: GestureDetector(
              // onHorizontalDragUpdate: (details) => _handleGesture(details, i), // Gesture Handling
              child: Padding(
                padding: EdgeInsets.all(25.0),
                child: Wrap(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data[i].name.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        Text(
                          'Task Id: ${data[i].taskId}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.black45,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.home_work_rounded,
                            color: Colors.indigo[800],
                            size: 30.0,
                          ),
                          VerticalDivider(
                            color: Colors.white,
                            thickness: 5.0,
                          ),
                          Expanded(
                            child: Text(
                              data[i].customerInfo,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.indigo[800],
                            size: 30.0,
                          ),
                          VerticalDivider(
                            color: Colors.white,
                            thickness: 5.0,
                          ),
                          Text(
                            '${data[i].coordinate.latitude}, ${data[i].coordinate.longitude}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.black45,
                    )
                  ],
                ),
              ),
            )));

    future.then((value) => _closeModal(value));
  } // function to trigger upon tapping on a marker

  void _closeModal(void value) {} //function to close bottom sheet



  @override
  Widget build(BuildContext context) {
    //Data received from Loading Screen.
    data = ModalRoute.of(context).settings.arguments;
    target =
        LatLng(data[0].coordinate.latitude, data[0].coordinate.longitude);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Zorp Assignment',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
          child: GoogleMap(
        onMapCreated: _onMapCreated,
        mapType: MapType.normal,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: target,
          zoom: 16,
        ),
        markers: _createMarker(),
      )),
    );
  }
}
