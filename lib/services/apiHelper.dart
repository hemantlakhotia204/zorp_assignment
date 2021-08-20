import 'dart:convert';
import 'package:http/http.dart';

class APIHelper {
  APIHelper(); //constructor

  //fetch api data
  Future<List> fetchTaskJson() async {
    try {
      Response response = await get(Uri.parse(
          'http://13.232.145.62:8082/user/1/tasks/'));
      if(response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error Occured');
      }
    } catch (e) {
      throw e;
    }

  }
}
