//Task Object
import 'package:equatable/equatable.dart';

class Task extends Equatable{
  //Declaring fields of the Object Task
  String taskId;
  int seq;
  Coordinate coordinate;
  String name;
  String customerInfo;

  //Constructor for Task Object
  Task(this.taskId, this.seq, this.coordinate, this.name, this.customerInfo);

  //return value of taskId, seq, location, name and customerInfo
  factory Task.fromJson(Map<String, dynamic> json) {

    return Task(
      json['taskId'] as String,
      json['seq'] as int,
      Coordinate.fromJson(json['location']), //Nested Json
      json['name'] as String,
      json['customerInfo'] as String,
    );
  }

  //override toString function to return required values
  @override
  String toString() {
    return '{ ${this.taskId}, ${this.seq}, ${this.coordinate}, ${this.name}, ${this.customerInfo} }';
  }

  @override
  // TODO: implement props
  List<Object> get props => [taskId, seq, coordinate, name, customerInfo];
}








//Coordinate Object
class Coordinate extends Equatable{
  //declaring fields of Object Coordinate
  double latitude;
  double longitude;

  //Constructor for Coordinate Object
  Coordinate(this.latitude, this.longitude);

  //return value of latitude and longitude from json
  factory Coordinate.fromJson(Map<String, dynamic> json) {
    return Coordinate(
      json['lat'] as double,
      json['lon'] as double
    );
  }

  //override toString function to return required values
  @override
  String toString() {
    return '{ ${this.latitude}, ${this.longitude} }';
  }

  @override
  // TODO: implement props
  List<Object> get props => [latitude, longitude];
}
