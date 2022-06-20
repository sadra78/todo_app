import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_indicator_button/button_stagger_animation.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:todo_app/Controller/loginController.dart';
import 'package:todo_app/constants.dart';
import 'package:todo_app/screen/widget/buttonWidget.dart';
import 'package:todo_app/screen/widget/textFieldWidget.dart';

class LoginScreen extends StatelessWidget {
  LoginController loginController = Get.put(LoginController());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              height: 200,
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                color: mediumBlue,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Text('Login',
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: 35,
                      fontWeight: FontWeight.w900))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      child: TextFieldWidget(
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Please Enter Email";
                            }else if(!GetUtils.isEmail(value.trim())){
                              return "Please Enter Valid Email";
                            }
                          },
                          controller: loginController.emailEditingController,
                          labelText: "Email",
                          icon: Icons.email_outlined)),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: TextFieldWidget(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please Enter Password";
                        }
                        else if(value.length<8){
                          return "Password is not Correct";
                        }
                      },
                      controller: loginController.passwordEditingController,
                      labelText: "password",
                      icon: Icons.lock_outline,
                      obscureText: true,
                      suffixIcon: Icons.visibility_off,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'Forget Password',
                      style: TextStyle(color: mediumBlue),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    height: 55,
                    child: Container(
                      width: 200,
                      height: 60,
                      child: ProgressButton(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        strokeWidth: 2,
                        color: mediumBlue,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        onPressed: (AnimationController controller) async {
                            if(_formKey.currentState!.validate()){
                              controller.forward();
                              await loginController.login(
                                  loginController.emailEditingController.text,
                                  loginController.passwordEditingController.text);
                              controller.reverse();
                            }
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 20),
                    child: ButtonWidget(
                      title: "Sign Up",
                      hasBorder: true,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
