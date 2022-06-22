import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/Model/Task.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class TaskController extends GetxController {
  RxBool loading = true.obs;
  RxList<Task> tasks = <Task>[].obs;
  RxList<Task> searchedTasks = <Task>[].obs;
  RxString searchText = "".obs;

  RxBool deleting = false.obs;
  RxString deleteID = "".obs;

  String? userToken;

  @override
  onInit() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    userToken = prefs.getString("user_token");
      everAll([searchText,tasks], (_){
        searchTask();
      });
  }

  setTask() async {
    print('____________ $userToken');
    var url = Uri.parse('https://api-nodejs-todolist.herokuapp.com/task');

    var header = {
      'Authorization': 'Bearer $userToken',
      'Content-Type': 'application/json'
    };

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url, headers: header);
    tasks.clear();

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      jsonResponse['data'].forEach((element) {
        tasks.add(Task.fromJson(element));
      });
    } else {}

    loading.value = false;
  }

  addTask(String description) async {
    var url = Uri.parse('https://api-nodejs-todolist.herokuapp.com/task');

    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    var body = {"description": description};

    var response =
        await http.post(url, body: convert.jsonEncode(body), headers: header);
    if (response.statusCode == 201) {
      var jsonResponse = convert.jsonDecode(response.body);
      print('____________ $jsonResponse');
      this.tasks.add(Task.fromJson(jsonResponse['data']));
      Get.back();
    } else {
      print('Request failed with status: ${response.statusCode}.');
      Get.snackbar("Error", "The Information Was not Entered Correctly",
          backgroundColor: Colors.red.withOpacity(0.5));
    }
  }

  updateTask(Task task) async {
    var index = tasks.indexOf(task);

    task.completed = !task.completed!;
    tasks[index] = task;

    var url =
        Uri.parse('https://api-nodejs-todolist.herokuapp.com/task/${task.sId}');

    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };
    var body = {"completed": "${task.completed}"};

    var response =
        await http.put(url, body: convert.jsonEncode(body), headers: header);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print('************ $jsonResponse');
    } else {
      print('Request failed with status: ${response.statusCode}.');
      task.completed = !task.completed!;
      tasks[index] = task;
      Get.snackbar("Error", "Enter The Information Correctly",
          backgroundColor: Colors.red.withOpacity(0.5));
    }
  }

  deleteTask(Task task) async {
    deleting.value = true;
    deleteID.value = task.sId!;
    var index = tasks.indexOf(task);

    var url =
        Uri.parse('https://api-nodejs-todolist.herokuapp.com/task/${task.sId}');

    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $userToken',
    };

    var response = await http.delete(url, headers: header);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print('************ $jsonResponse');
      tasks.removeAt(index);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      task.completed != task.completed;
      Get.snackbar("Error", "An error has occurred",
          backgroundColor: Colors.red.withOpacity(0.5));
    }
    deleting.value = false;
  }

  searchTask() {
    print(searchText+"!!!!!!@@@@@@!!!!");

    searchedTasks.clear();
    if (searchText.isEmpty) {
      searchedTasks.addAll(tasks);
    } else {
      tasks.forEach((Task task) {
        String Tdesc= task.description!;
        if(Tdesc.contains(searchText.toLowerCase())) {
          searchedTasks.add(task);
        }
      });
    }
  }
}
