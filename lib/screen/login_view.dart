import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_social_authentication/controller/login_controller.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AuthTypeContainer(),
              Form(
                key: controller.formKey,
                child: controller.authType.value == 'phone'
                    ? const PhoneAuthContainer()
                    : const EmailPasswordContainer(),
              ),
              const SizedBox(height: 40),
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
      ),
    );
  }
}

class EmailPasswordContainer extends StatelessWidget {
  const EmailPasswordContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          decoration: const InputDecoration(hintText: 'Email'),
          controller: controller.emailEditController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter you email";
            } else if (value.isNotEmpty && !value.isEmail) {
              return "Enter valid email";
            } else {
              return null;
            }
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          decoration: const InputDecoration(hintText: 'Password'),
          controller: controller.passwordEditController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter your password";
            } else {
              return null;
            }
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => controller.emailPasswordSignIn(),
          child: const Text('Sing in'),
        ),
      ],
    );
  }
}

class PhoneAuthContainer extends StatelessWidget {
  const PhoneAuthContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter you phone number";
            } else if (value.isNotEmpty && !value.isPhoneNumber) {
              return "Enter valid phone number";
            } else {
              return null;
            }
          },
          controller: controller.phoneEditController,
          decoration: InputDecoration(
            hintText: 'Phone number',
            contentPadding: const EdgeInsets.only(top: 16),
            prefixIcon: CountryCodePicker(
              initialSelection: 'bd',
              favorite: const ['bd'],
              onInit: (value) {
                controller.selectedCode.value = value!;
              },
              onChanged: (selectValue) {
                controller.selectedCode.value = selectValue;
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => controller.phoneSingIn(context),
          child: const Text('Send OTP'),
        ),
      ],
    );
  }
}

class AuthTypeContainer extends StatelessWidget {
  const AuthTypeContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find<LoginController>();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Obx(
        () => Row(
          children: [
            AuthTypeView(
              name: 'Phone',
              isActive: (controller.authType.value == "phone"),
              authType: controller.authType.value,
              onTap: () => controller.phoneEmailType('phone'),
            ),
            AuthTypeView(
              name: 'Email',
              isActive: (controller.authType.value == "email"),
              authType: controller.authType.value,
              onTap: () => controller.phoneEmailType('email'),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthTypeView extends StatelessWidget {
  const AuthTypeView({
    Key? key,
    required this.name,
    required this.onTap,
    required this.isActive,
    required this.authType,
  }) : super(key: key);

  final VoidCallback onTap;
  final String name;
  final bool isActive;
  final String authType;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.transparent,
            borderRadius: authType == "phone"
                ? const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  )
                : const BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
          ),
          child: Center(child: Text(name)),
        ),
      ),
    );
  }
}
