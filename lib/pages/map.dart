import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zorp_assignment/objects/task.dart';
import 'package:location/location.dart';
import 'package:sizer/sizer.dart';

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
  AnimationController animationController;
  Animation animation;
  double _lat, _lng;

  @override
  void initState() {
    _checkLocationPermission();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _location.onLocationChanged().listen((l) {
      _lat = l.latitude;
      _lng = l.longitude;
    });
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
    double distance = calculateDistance(
        _lat, _lng, data[i].coordinate.latitude, data[i].coordinate.longitude);
    String dist = distance.toStringAsFixed(1);

    //show details of the marker tapped
    Future<void> future = showModalBottomSheet<void>(
        barrierColor: Colors.transparent,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => AnimatedContainer(
            height: 25.h,
            margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(2.w),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black45,
                      spreadRadius: 5.0,
                      blurRadius: 20.0)
                ],
                color: Colors.white),
            duration: Duration(milliseconds: 500),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                      child: Image(
                          image: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Dominos_pizza_logo.svg/1200px-Dominos_pizza_logo.svg.png')),
                      height: 16.w,
                      width: 16.w,
                    ),
                    SizedBox(width: 4.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Pizza Express',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        Text(
                          'Forum Mall, Koramangala',
                          style: TextStyle(
                              fontSize: 10.sp, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '14 Kms • 12mins',
                          style: TextStyle(
                              fontSize: 11.sp, fontWeight: FontWeight.w600),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  height: 7.h,
                  width: 90.w,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrangeAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.w)),
                    ),
                    onPressed: () {},
                    child: Text(
                      'PRESS TO START',
                      style: TextStyle(
                          fontSize: 13.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            )));

    future.then((value) => _closeModal(value));
  } // function to trigger upon tapping on a marker

  void _closeModal(void value) {} //function to close bottom sheet

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    //Data received from Loading Screen.
    data = ModalRoute.of(context).settings.arguments;
    target = LatLng(data[0].coordinate.latitude, data[0].coordinate.longitude);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
          appBar: new AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
          body: GoogleMap(
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        buildingsEnabled: false,
        onMapCreated: _onMapCreated,
        mapType: MapType.normal,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: target,
          zoom: 12,
        ),
        markers: _createMarker(),
      )),
    );
  }
}
