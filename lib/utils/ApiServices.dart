import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServices {
  final String baseUrl = "http://braille.api.tenji.id";

  Future<void> login(String username, String password, {void Function(dynamic data) onSuccess, void Function(String message) onError}) async {
    var url = Uri.parse(baseUrl + "/signin.php");
    var response = await http.post(url, body: {
      "name": username,
      "password": password
    });

    var data = json.decode(response.body);
    if(!data['error']) {
      onSuccess(data);
    } else {
      onError(data['error_msg']);
    }
  }

  Future<void> register(String username, String email, String password, {void Function(dynamic data) onSuccess, void Function(String message) onError}) async{
    var url = Uri.parse(baseUrl + "/signup.php");
    var response = await http.post(url, body: {
      "name": username,
      "password": password,
      "email": email
    });

    var data = json.decode(response.body);
    if(!data['error']) {
      onSuccess(data);
    } else {
      onError(data['error_msg']);
    }
  }

  Future<void> duration(String start, String end, String type, String userId, {void Function(dynamic data) onSuccess, void Function(String message) onError}) async{

    var url = Uri.parse(baseUrl + "/duration.php");
    var response = await http.post(url, body: {
      "type": type,
      "start": start,
      "end": end,
      "user_id": userId
    });

    var data = json.decode(response.body);

    if(!data['error']) {
      onSuccess(data);
    } else {
      onError(data['error_msg']);
    }
  }

  Future<void> capture(String result, String userId, {void Function(dynamic data) onSuccess, void Function(String message) onError}) async{
    var url = Uri.parse(baseUrl + "/capture.php");
    var response = await http.post(url, body: {
      "result": result,
      "user_id": userId
    });
    var data = json.decode(response.body);
    if(!data['error']) {
      onSuccess(data);
    } else {
      onError(data['error_msg']);
    }

  }

  Future<void> count(String type, String userId, {void Function(dynamic data) onSuccess, void Function(String message) onError}) async{
    var url = Uri.parse(baseUrl + "/count.php");
    var response = await http.post(url, body: {
      "type": type,
      "user_id": userId
    });
    var data = json.decode(response.body);
    if(!data['error']) {
      onSuccess(data);
    } else {
      onError(data['error_msg']);
    }
  }

  Future<void> wrongAnswer(String detectedClass, {void Function(dynamic data) onSuccess, void Function(String message) onError}) async{
    var url = Uri.parse(baseUrl + "/wronganswer.php?data=" + detectedClass);
    var response = await http.get(url);
    var data = json.decode(response.body);

    if(!data['error']) {
      onSuccess(data['data']['message']);
    } else {
      onError(data['error_msg']);
    }
  }
}