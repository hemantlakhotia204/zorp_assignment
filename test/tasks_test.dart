
import 'package:http/http.dart' as http;
import 'package:zorp_assignment/objects/task.dart';
import 'package:zorp_assignment/services/apiHelper.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:zorp_assignment/services/taskHelper.dart';

class MockClient extends Mock implements http.Client {}

class MockApiCall extends Mock implements APIHelper {}

class MockTaskHelper extends Mock implements TaskHelper {}

void main() {
  //arrange
  test('When sorting of tasks according to seq', () async {
    final taskHelper = TaskHelper();
    List<Task> tasks = [
      Task('1', 5, null, null, null),
      Task('2', 2, null, null, null),
      Task('3', 4, null, null, null),
      Task('4', 1, null, null, null),
      Task('5', 3, null, null, null),
    ];
    List<Task> expectedTasks = [
      Task('4', 1, null, null, null),
      Task('2', 2, null, null, null),
      Task('5', 3, null, null, null),
      Task('3', 4, null, null, null),
      Task('1', 5, null, null, null),
    ];

    expect(taskHelper.sortTasks(tasks), expectedTasks);
  });

  group('getTask', ()  {
    test(
      'sorting array',
   () async {
  final taskHelper = TaskHelper();

  List data = [
  {
  "taskId": "1",
  "seq": 3,
  "location": {
  "lat": 28.7041,
  "lon": 77.1025
  },
  "name": "delivery task 3",
  "customerInfo": "Mohan, N-69, Connaught Place, New Delhi"
  },
  {
  "taskId": "2",
  "seq": 1,
  "location": {
  "lat": 28.7045,
  "lon": 77.103
  },
  "name": "delivery task 1",
  "customerInfo": "Raj, 64, Janpath, New Delhi"
  },
  {
  "taskId": "3",
  "seq": 2,
  "location": {
  "lat": 28.7031,
  "lon": 77.1028
  },
  "name": "delivery task 2",
  "customerInfo": "Bhagat, F-41, First Floor, Connaught Place, New Delhi"
  },
  ];

  List<Task> tasks = [
  Task('2', 1, Coordinate(28.7045, 77.103), "delivery task 1", "Raj, 64, Janpath, New Delhi"),
  Task('3', 2, Coordinate(28.7031, 77.1028 ), "delivery task 2", "Bhagat, F-41, First Floor, Connaught Place, New Delhi"),
  Task('1', 3, Coordinate(28.7041, 77.1025), "delivery task 3", "Mohan, N-69, Connaught Place, New Delhi")
  ];

  expect(await taskHelper.getTasks(data), tasks);
  });


    test('When taskHelper gets and empty array of JSON(No task left of delivery boy)', () async {
     final taskHelper = TaskHelper();
     List data = [];
     expect(await taskHelper.getTasks(data), null);
    });

  });
}
