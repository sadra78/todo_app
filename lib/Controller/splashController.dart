import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/homeScreen.dart';
import '../screen/loginScreen.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class SplashController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _handleScreen();
  }

  void _handleScreen() async {
    await Future.delayed(Duration(seconds: 2));
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? userToken=prefs.getString("user_token");
    if (userToken == null) {
      Get.off(() => LoginScreen(),
          transition: Transition.zoom, duration: Duration(milliseconds: 800));
    } else {

      checkUserToken(userToken);
/*      Get.off(() => HomeScreen(),
          transition: Transition.zoom, duration: Duration(milliseconds: 800));*/
    }
  }

  void checkUserToken(String userToken) async{
    var url = Uri.parse('https://api-nodejs-todolist.herokuapp.com/user/me');

    var header = {
      'Authorization': 'Bearer $userToken'
    };


    // Await the http get response, then decode the json-formatted response.
    var response =
        await http.get(url, headers: header);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);
      Get.off(() => HomeScreen());
    } else {
      Get.off(() => LoginScreen(),
          transition: Transition.zoom, duration: Duration(milliseconds: 800));
    }
  }
}
