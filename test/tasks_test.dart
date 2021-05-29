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
  http.Client mockClient = MockClient();
  APIHelper mockAPIHelper = MockApiCall();
  TaskHelper mockTaskHelper = MockTaskHelper();

  test('When a broken Api is called Then APIHelper returns null', () async {
    //assert
    when(mockClient.get(Uri.parse(
        'http://ec2-13-126-90-75.ap-south-0.compute.amazonaws.com:8082/user/1/tasks/'))).thenAnswer((realInvocation) async => http.Response('Not Found', 404));
    //compare
    expect(await mockAPIHelper.fetchTaskJson(), null);
  });

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

  test('When taskHelper gets and empty array of JSON(No task left of delivery boy) then ', () async{
    final taskHelper = TaskHelper();
    List data = [];

    expect(taskHelper.getTasks(data), null);
  });
}
