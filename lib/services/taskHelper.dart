
import 'package:zorp_assignment/objects/task.dart';

class TaskHelper {
  TaskHelper();//constructor



  // fetch data from apiHelper, convert to 'List<Task>' object and sort by seq.
  Future<List<Task>> getTasks(List data) async {
    // Handle exception
    try{
      List<Task> tasks = convertData(data);
      tasks = sortTasks(tasks);
      if (data.length == 0) {
        return null;
      } else {
        return tasks;
      }

    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  //JSON to Task Object Conversion
  List<Task> convertData(List data) {
    return data.map<Task>((eachJson) => Task.fromJson(eachJson)).toList();//each task converted from json to task object.
  }

  //Sort according to 'Seq'
  List<Task> sortTasks(List<Task> tasks) {
    tasks.sort((a, b) => a.seq.compareTo(b.seq));
    return tasks;
  }


}
