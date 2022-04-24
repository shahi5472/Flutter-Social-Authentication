import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_social_authentication/controller/login_controller.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(
              Buttons.Google,
              onPressed: () {
                controller.showSnackBar(context, 'Google sing in click');
                controller.googleSignIn(context);
              },
            ),
            SignInButton(
              Buttons.Facebook,
              onPressed: () {
                controller.showSnackBar(context, 'Facebook sign in click');
                controller.facebookSignIn(context);
              },
            ),
            if (Platform.isIOS)
              SignInButton(
                Buttons.Apple,
                onPressed: () {
                  controller.showSnackBar(context, 'Apple sign in click');
                  controller.appleSignIn(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}
