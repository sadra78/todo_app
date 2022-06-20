import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/screen/homeScreen.dart';

class LoginController extends GetxController {
  late TextEditingController emailEditingController, passwordEditingController;

  @override
  onInit() {
    emailEditingController = TextEditingController();
    passwordEditingController = TextEditingController();
    super.onInit();
  }

  login(email, password) async {
    var url = Uri.parse('https://api-nodejs-todolist.herokuapp.com/user/login');

    var header = {'Content-Type': 'application/json'};

    var body = {"email": "$email", "password": "$password"};

    // Await the http get response, then decode the json-formatted response.
    var response =
        await http.post(url, body: convert.jsonEncode(body), headers: header);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      prefs.setString("user_token", jsonResponse["token"]);
      Get.off(() => HomeScreen());
      print('jsonResponse: $jsonResponse.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
      Get.snackbar("Error", "Wrong Username or Password",backgroundColor: Colors.red.withOpacity(0.5));
    }
  }
}
